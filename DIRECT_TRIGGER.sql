-- Trigger directo que inserta sin Edge Function
CREATE OR REPLACE FUNCTION public.direct_insert_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    product_name TEXT;
    public_url TEXT;
BEGIN
  -- Solo procesar nuestros buckets
  IF NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly') THEN

    -- Generar nombre del producto
    product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
    product_name := initcap(product_name);

    -- Generar URL
    public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;

    -- Insertar según bucket
    CASE NEW.bucket_id
      WHEN 'carpets' THEN
        INSERT INTO public.carpets_items (name, description, image_url, size, price, is_active)
        VALUES (product_name, 'Alfombra ' || product_name || ' - Auto', public_url, 'Consultar', 'Consultar', true);

      WHEN 'curtains' THEN
        INSERT INTO public.curtains_items (name, description, image_url, size, price, is_active)
        VALUES (product_name, 'Cortina ' || product_name || ' - Auto', public_url, '200x250cm', 'Consultar', true);

      WHEN 'furniture' THEN
        INSERT INTO public.furniture_items (name, description, image_url, category, is_active)
        VALUES (product_name, 'Mueble ' || product_name || ' - Auto', public_url, 'furniture', true);

      WHEN 'monthly' THEN
        INSERT INTO public.monthly_updates (title, description, image_url, is_active)
        VALUES (product_name, 'Producto mensual ' || product_name || ' - Auto', public_url, true);

      WHEN 'gallery' THEN
        INSERT INTO public.gallery_photos (title, description, image_url, is_active)
        VALUES (product_name, 'Foto de galería ' || product_name, public_url, true);
    END CASE;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Si hay error, no fallar el upload
    RAISE LOG 'Direct insert failed: %', SQLERRM;
    RETURN NEW;
END;
$$;

-- Aplicar trigger directo
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly'))
  EXECUTE FUNCTION public.direct_insert_trigger();
