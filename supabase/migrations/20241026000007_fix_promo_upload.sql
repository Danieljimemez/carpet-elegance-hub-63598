-- ===========================================
-- SOLUCIÓN COMPLETA PARA SUBIR FOTOS A PROMO
-- ===========================================

-- 1. Asegurarse de que el bucket 'promo' existe
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
SELECT 
    'promo', 
    'promo', 
    true, 
    52428800, -- 50MB
    ARRAY['image/jpeg', 'image/png', 'image/webp']
WHERE NOT EXISTS (
    SELECT 1 FROM storage.buckets WHERE name = 'promo'
);

-- 2. Configurar políticas del bucket
-- Eliminar políticas existentes
DELETE FROM storage.objects WHERE bucket_id = 'promo';

-- 3. Crear políticas de almacenamiento
-- Política de lectura pública
CREATE POLICY "Promo public access"
ON storage.objects FOR SELECT
USING (bucket_id = 'promo');

-- Política de subida para usuarios autenticados
CREATE POLICY "Promo upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'promo');

-- 4. Función para manejar nuevas imágenes
CREATE OR REPLACE FUNCTION public.handle_new_promo_image()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    image_name TEXT;
    public_url TEXT;
BEGIN
    -- Solo procesar archivos del bucket 'promo'
    IF NEW.bucket_id = 'promo' THEN
        -- Generar nombre descriptivo
        image_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        image_name := initcap(image_name);
        
        -- Generar URL pública
        public_url := 'https://' || current_setting('app.settings.supabase_url', true) || 
                     '/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;

        -- Insertar en la tabla promo_banner
        INSERT INTO public.promo_banner (
            title,
            description,
            image_url,
            alt_text,
            path,
            display_order,
            is_active
        ) VALUES (
            image_name,
            'Imagen promocional ' || image_name,
            public_url,
            'Imagen promocional: ' || image_name,
            NEW.name,
            0,
            true
        )
        ON CONFLICT (path) 
        DO UPDATE SET
            image_url = EXCLUDED.image_url,
            updated_at = NOW();
    END IF;
    
    RETURN NEW;
END;
$$;

-- 5. Crear trigger para nuevas imágenes
DROP TRIGGER IF EXISTS on_promo_image_upload ON storage.objects;
CREATE TRIGGER on_promo_image_upload
AFTER INSERT ON storage.objects
FOR EACH ROW
WHEN (NEW.bucket_id = 'promo')
EXECUTE FUNCTION public.handle_new_promo_image();

-- 6. Función para manejar eliminación de imágenes
CREATE OR REPLACE FUNCTION public.handle_delete_promo_image()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    IF OLD.bucket_id = 'promo' THEN
        DELETE FROM public.promo_banner WHERE path = OLD.name;
    END IF;
    RETURN OLD;
END;
$$;

-- 7. Crear trigger para eliminación de imágenes
DROP TRIGGER IF EXISTS on_promo_image_delete ON storage.objects;
CREATE TRIGGER on_promo_image_delete
BEFORE DELETE ON storage.objects
FOR EACH ROW
WHEN (OLD.bucket_id = 'promo')
EXECUTE FUNCTION public.handle_delete_promo_image();

-- 8. Verificación final
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
AND (policyname LIKE '%promo%' OR policyname = 'Public Access');
