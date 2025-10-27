-- ===========================================
-- TRIGGER PARA EL BUCKET 'promo'
-- ===========================================

-- 1. Eliminar triggers existentes si existen
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
DROP FUNCTION IF EXISTS auto_insert_all_buckets_trigger();

-- 2. Crear función que maneja el bucket 'promo'
CREATE OR REPLACE FUNCTION handle_promo_image_trigger()
RETURNS TRIGGER AS $$
DECLARE
    image_name TEXT;
    public_url TEXT;
BEGIN
    -- Solo procesar archivos del bucket 'promo'
    IF NEW.bucket_id = 'promo' THEN
        -- Generar nombre descriptivo a partir del nombre del archivo
        image_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        image_name := initcap(image_name);
        
        -- Generar URL pública
        public_url := 'https://' || current_setting('app.settings.supabase_url', true) || 
                     '/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;

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
            'Imagen promocional: ' || image_name,
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
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Crear trigger para manejar eliminaciones
CREATE OR REPLACE FUNCTION handle_promo_image_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Eliminar el registro correspondiente en promo_banner cuando se elimina un archivo
    IF OLD.bucket_id = 'promo' THEN
        DELETE FROM public.promo_banner WHERE path = OLD.name;
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Aplicar triggers
-- Trigger para nuevas imágenes
CREATE TRIGGER auto_insert_trigger
AFTER INSERT ON storage.objects
FOR EACH ROW
WHEN (NEW.bucket_id = 'promo')
EXECUTE FUNCTION handle_promo_image_trigger();

-- Trigger para eliminación de imágenes
CREATE TRIGGER auto_delete_trigger
BEFORE DELETE ON storage.objects
FOR EACH ROW
WHEN (OLD.bucket_id = 'promo')
EXECUTE FUNCTION handle_promo_image_delete();

-- 5. Verificar que los triggers están aplicados
SELECT '✅ TRIGGERS APLICADOS' as status,
       trigger_name,
       event_manipulation,
       event_object_table
FROM information_schema.triggers
WHERE trigger_name IN ('auto_insert_trigger', 'auto_delete_trigger');

-- 6. Verificar configuración del bucket
SELECT '⚙️ CONFIGURACIÓN DEL BUCKET "promo":' as info;
SELECT * FROM storage.buckets WHERE name = 'promo';

-- 7. Mostrar políticas de almacenamiento
SELECT '🔐 POLÍTICAS DE ALMACENAMIENTO:' as info;
SELECT * FROM pg_policies 
WHERE schemaname = 'storage' 
AND tablename = 'objects'
AND (policyname LIKE '%promo%' OR policyname = 'Public Access');
