-- Trigger con nombre correcto del producto
CREATE OR REPLACE FUNCTION public.named_storage_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    product_name TEXT;
    public_url TEXT;
BEGIN
    -- Solo procesar carpets por ahora
    IF NEW.bucket_id = 'carpets' THEN
        -- Generar nombre del producto
        BEGIN
            product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
            product_name := initcap(product_name);
        EXCEPTION
            WHEN OTHERS THEN
                product_name := 'Producto ' || NEW.name;
        END;

        -- Generar URL
        BEGIN
            public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;
        EXCEPTION
            WHEN OTHERS THEN
                public_url := 'https://example.com/' || NEW.name;
        END;

        -- Insertar con nombre correcto
        INSERT INTO public.carpets_items (name, image_url, description, is_active)
        VALUES (product_name, public_url, 'Alfombra ' || product_name || ' - Auto', true);
    END IF;

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Log error pero permitir upload
        INSERT INTO public.trigger_logs (bucket_id, file_name, action, error_message)
        VALUES (COALESCE(NEW.bucket_id, 'unknown'), COALESCE(NEW.name, 'unknown'), 'TRIGGER_FAILED', SQLERRM);
        RETURN NEW;
END;
$$;

-- Aplicar trigger con nombre
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly'))
  EXECUTE FUNCTION public.named_storage_trigger();
