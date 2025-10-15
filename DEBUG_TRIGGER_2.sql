-- Trigger de debug para ver qué pasa
CREATE OR REPLACE FUNCTION public.debug_storage_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RAISE LOG 'TRIGGER ACTIVADO - Bucket: %, File: %, Path: %', NEW.bucket_id, NEW.name, NEW.path_tokens;

  -- Solo procesar nuestros buckets
  IF NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly') THEN
    RAISE LOG 'Procesando bucket válido: %', NEW.bucket_id;

    -- Intentar insertar y capturar errores
    BEGIN
      -- Lógica simplificada de test
      INSERT INTO public.carpets_items (name, image_url, description, is_active)
      VALUES ('TEST PRODUCT', 'test.jpg', 'Test description', true);

      RAISE LOG 'Inserción de test exitosa';

    EXCEPTION
      WHEN OTHERS THEN
        RAISE LOG 'Error en inserción de test: %', SQLERRM;
    END;
  ELSE
    RAISE LOG 'Bucket ignorado: %', NEW.bucket_id;
  END IF;

  RETURN NEW;
END;
$$;

-- Reemplazar trigger con versión de debug
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  EXECUTE FUNCTION public.debug_storage_trigger();
