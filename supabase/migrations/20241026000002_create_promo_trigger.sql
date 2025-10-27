-- 🎯 TRIGGER PARA EL BUCKET 'promo'

-- 1. Eliminar trigger existente si existe
DROP TRIGGER IF EXISTS auto_insert_promo_trigger ON storage.objects;

-- 2. Crear función que maneja el bucket 'promo'
CREATE OR REPLACE FUNCTION handle_promo_image_trigger()
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
        
        -- Insertar en la tabla promo_banner
        INSERT INTO public.promo_banner (
            image_url,
            alt_text,
            display_order,
            path,
            is_active,
            created_at,
            updated_at
        ) VALUES (
            public_url,
            alt_text,
            0, -- Orden por defecto, se puede ajustar después
            NEW.name,
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

-- 3. Crear trigger
CREATE TRIGGER auto_insert_promo_trigger
AFTER INSERT OR UPDATE ON storage.objects
FOR EACH ROW
WHEN (NEW.bucket_id = 'promo')
EXECUTE FUNCTION handle_promo_image_trigger();

-- 4. Crear trigger para manejar eliminaciones
CREATE OR REPLACE FUNCTION handle_promo_image_delete_trigger()
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

CREATE TRIGGER auto_delete_promo_trigger
BEFORE DELETE ON storage.objects
FOR EACH ROW
WHEN (OLD.bucket_id = 'promo')
EXECUTE FUNCTION handle_promo_image_delete_trigger();

-- 5. Verificación
SELECT '✅ TRIGGERS CREADOS' as status;

SELECT '🔍 TRIGGERS PARA PROMO:' as info,
       trigger_name,
       event_manipulation,
       event_object_table
FROM information_schema.triggers
WHERE trigger_name IN ('auto_insert_promo_trigger', 'auto_delete_promo_trigger');

-- Mostrar configuración actual
SELECT '⚙️ CONFIGURACIÓN ACTUAL:' as info;
SELECT * FROM storage.buckets WHERE name = 'promo';

SELECT '📋 POLÍTICAS RLS:' as info, 
       tablename, 
       policyname, 
       cmd, 
       permissive,
       roles
FROM pg_policies 
WHERE tablename = 'promo_banner' 
   OR (schemaname = 'storage' AND tablename = 'objects');
