-- ===========================================
-- CONFIGURACIÓN COMPLETA DEL BUCKET 'promo'
-- ===========================================

-- 1. Crear el bucket 'promo' si no existe
INSERT INTO storage.buckets (id, name, public, avif_autodetection, file_size_limit, allowed_mime_types)
SELECT 
    'promo', 
    'promo', 
    true, 
    false, 
    52428800, -- 50MB en bytes (50 * 1024 * 1024)
    ARRAY['image/jpeg', 'image/png', 'image/webp']
WHERE NOT EXISTS (
    SELECT 1 FROM storage.buckets WHERE name = 'promo'
);

-- 2. Configurar políticas de acceso al bucket
-- Eliminar políticas existentes
DELETE FROM storage.objects WHERE bucket_id = 'promo';

-- 3. Función para manejar nuevas imágenes en el bucket 'promo'
CREATE OR REPLACE FUNCTION public.handle_new_promo_image()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    public_url TEXT;
    image_name TEXT;
    alt_text TEXT;
BEGIN
    -- Solo procesar archivos del bucket 'promo'
    IF NEW.bucket_id = 'promo' THEN
        -- Generar URL pública
        public_url := format('https://%s/storage/v1/object/public/%s/%s', 
                           current_setting('app.settings.supabase_url', true),
                           NEW.bucket_id, 
                           NEW.name);
        
        -- Generar nombre descriptivo a partir del nombre del archivo
        image_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        image_name := initcap(image_name);
        
        -- Crear texto alternativo por defecto
        alt_text := 'Imagen promocional: ' || image_name;
        
        -- Insertar o actualizar en la tabla promo_banner
        INSERT INTO public.promo_banner (
            title,
            description,
            image_url,
            alt_text,
            path,
            display_order,
            is_active,
            created_at,
            updated_at
        ) VALUES (
            image_name,
            'Imagen promocional ' || image_name,
            public_url,
            alt_text,
            NEW.name,
            0, -- Orden por defecto
            true,
            NOW(),
            NOW()
        )
        ON CONFLICT (path) 
        DO UPDATE SET
            image_url = EXCLUDED.image_url,
            updated_at = NOW();
            
    END IF;
    
    RETURN NEW;
END;
$$;

-- 4. Función para manejar eliminación de imágenes
CREATE OR REPLACE FUNCTION public.handle_delete_promo_image()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Eliminar el registro correspondiente en promo_banner cuando se elimina un archivo
    IF OLD.bucket_id = 'promo' THEN
        DELETE FROM public.promo_banner WHERE path = OLD.name;
    END IF;
    
    RETURN OLD;
END;
$$;

-- 5. Crear triggers si no existen
DO $$
BEGIN
    -- Eliminar triggers existentes si existen
    DROP TRIGGER IF EXISTS on_promo_image_upload ON storage.objects;
    DROP TRIGGER IF EXISTS on_promo_image_delete ON storage.objects;
    
    -- Crear trigger para nuevas imágenes
    CREATE TRIGGER on_promo_image_upload
    AFTER INSERT ON storage.objects
    FOR EACH ROW
    WHEN (NEW.bucket_id = 'promo')
    EXECUTE FUNCTION public.handle_new_promo_image();
    
    -- Crear trigger para eliminación de imágenes
    CREATE TRIGGER on_promo_image_delete
    BEFORE DELETE ON storage.objects
    FOR EACH ROW
    WHEN (OLD.bucket_id = 'promo')
    EXECUTE FUNCTION public.handle_delete_promo_image();
END $$;

-- 6. Configurar políticas de acceso al bucket
-- Permitir lectura pública
CREATE POLICY "Permitir lectura pública de imágenes promocionales"
ON storage.objects FOR SELECT
USING (bucket_id = 'promo');

-- Permitir subida de imágenes solo a usuarios autenticados
CREATE POLICY "Permitir subida de imágenes a usuarios autenticados"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'promo');

-- Permitir actualización de imágenes solo a usuarios autenticados
CREATE POLICY "Permitir actualización de imágenes a usuarios autenticados"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'promo');

-- Permitir eliminación de imágenes solo a usuarios autenticados
CREATE POLICY "Permitir eliminación de imágenes a usuarios autenticados"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'promo');

-- 7. Verificación final
SELECT '✅ CONFIGURACIÓN COMPLETADA' as status;

-- Mostrar configuración del bucket
SELECT '📦 CONFIGURACIÓN DEL BUCKET "promo":' as info;
SELECT * FROM storage.buckets WHERE name = 'promo';

-- Mostrar triggers creados
SELECT '🔍 TRIGGERS CREADOS:' as info;
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM 
    information_schema.triggers 
WHERE 
    trigger_name IN ('on_promo_image_upload', 'on_promo_image_delete');

-- Mostrar políticas de almacenamiento
SELECT '🔐 POLÍTICAS DE ALMACENAMIENTO:' as info;
SELECT * FROM pg_policies 
WHERE schemaname = 'storage' 
AND tablename = 'objects'
AND policyname LIKE '%promo%';
