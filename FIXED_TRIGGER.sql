-- Trigger corregido SIN el código de test
CREATE OR REPLACE FUNCTION public.log_storage_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    target_table TEXT;
    product_name TEXT;
    public_url TEXT;
BEGIN
    -- Insertar log de que el trigger se activó
    INSERT INTO public.trigger_logs (bucket_id, file_name, action)
    VALUES (NEW.bucket_id, NEW.name, 'TRIGGER_STARTED');

    -- Solo procesar nuestros buckets
    IF NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly') THEN

        -- Mapeo de buckets a tablas
        CASE NEW.bucket_id
            WHEN 'carpets' THEN target_table := 'carpets_items';
            WHEN 'curtains' THEN target_table := 'curtains_items';
            WHEN 'furniture' THEN target_table := 'furniture_items';
            WHEN 'monthly' THEN target_table := 'monthly_updates';
            WHEN 'gallery' THEN target_table := 'gallery_photos';
        END CASE;

        -- Generar nombre del producto desde el nombre del archivo
        product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        product_name := initcap(product_name);

        -- Generar URL pública correcta
        public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;

        -- Intentar insertar con datos correctos
        BEGIN
            CASE target_table
                WHEN 'carpets_items' THEN
                    INSERT INTO public.carpets_items (name, description, image_url, size, price, is_active)
                    VALUES (product_name, 'Alfombra ' || product_name || ' - Sincronizada automáticamente', public_url, 'Consultar', 'Consultar', true);
                WHEN 'curtains_items' THEN
                    INSERT INTO public.curtains_items (name, description, image_url, size, price, is_active)
                    VALUES (product_name, 'Cortina ' || product_name || ' - Sincronizada automáticamente', public_url, '200x250cm', 'Consultar', true);
                WHEN 'furniture_items' THEN
                    INSERT INTO public.furniture_items (name, description, image_url, category, is_active)
                    VALUES (product_name, 'Mueble ' || product_name || ' - Sincronizado automáticamente', public_url, 'furniture', true);
                WHEN 'monthly_updates' THEN
                    INSERT INTO public.monthly_updates (title, description, image_url, is_active)
                    VALUES (product_name, 'Producto mensual ' || product_name || ' - Sincronizado automáticamente', public_url, true);
                WHEN 'gallery_photos' THEN
                    INSERT INTO public.gallery_photos (title, description, image_url, is_active)
                    VALUES (product_name, 'Foto de galería ' || product_name, public_url, true);
            END CASE;

            -- Log de éxito
            INSERT INTO public.trigger_logs (bucket_id, file_name, action)
            VALUES (NEW.bucket_id, NEW.name, 'INSERT_SUCCESS');

        EXCEPTION
            WHEN OTHERS THEN
                -- Log de error
                INSERT INTO public.trigger_logs (bucket_id, file_name, action, error_message)
                VALUES (NEW.bucket_id, NEW.name, 'INSERT_FAILED', SQLERRM);
        END;
    ELSE
        -- Log de bucket ignorado
        INSERT INTO public.trigger_logs (bucket_id, file_name, action)
        VALUES (NEW.bucket_id, NEW.name, 'BUCKET_IGNORED');
    END IF;

    RETURN NEW;
END;
$$;

-- Reaplicar trigger corregido
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  EXECUTE FUNCTION public.log_storage_trigger();
