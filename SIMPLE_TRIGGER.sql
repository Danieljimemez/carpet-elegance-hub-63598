-- Trigger ultra-simple que no puede fallar
CREATE OR REPLACE FUNCTION public.simple_storage_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Solo procesar nuestros buckets
    IF NEW.bucket_id = 'carpets' THEN
        -- Insertar un registro simple sin lógica compleja
        INSERT INTO public.carpets_items (name, image_url, description, is_active)
        VALUES ('Producto Simple', 'https://example.com/test.jpg', 'Test', true);
    END IF;

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Si algo falla, solo loggear pero NO fallar
        INSERT INTO public.trigger_logs (bucket_id, file_name, action, error_message)
        VALUES (COALESCE(NEW.bucket_id, 'unknown'), COALESCE(NEW.name, 'unknown'), 'TRIGGER_FAILED', SQLERRM);
        RETURN NEW;
END;
$$;

-- Aplicar trigger simple
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly'))
  EXECUTE FUNCTION public.simple_storage_trigger();
