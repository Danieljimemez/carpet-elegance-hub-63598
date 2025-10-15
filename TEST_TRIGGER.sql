-- Función de test que inserta un registro hardcoded
CREATE OR REPLACE FUNCTION public.test_insert_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Solo para carpets, insertar un registro de test
  IF NEW.bucket_id = 'carpets' THEN
    INSERT INTO public.carpets_items (name, image_url, description, is_active)
    VALUES ('TEST PRODUCT', 'https://example.com/test.jpg', 'Registro de test', true);
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error
    RAISE LOG 'Test trigger failed: %', SQLERRM;
    RETURN NEW;
END;
$$;

-- Aplicar trigger de test
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id = 'carpets')
  EXECUTE FUNCTION public.test_insert_trigger();
