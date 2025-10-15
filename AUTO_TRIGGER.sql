-- Función SQL pura para automatización
CREATE OR REPLACE FUNCTION public.auto_insert_product()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  target_table TEXT;
  product_name TEXT;
  public_url TEXT;
  insert_data JSONB;
BEGIN
  -- Mapeo de buckets a tablas
  CASE NEW.bucket_id
    WHEN 'carpets' THEN target_table := 'carpets_items';
    WHEN 'curtains' THEN target_table := 'curtains_items';
    WHEN 'furniture' THEN target_table := 'furniture_items';
    WHEN 'monthly' THEN target_table := 'monthly_updates';
    WHEN 'gallery' THEN target_table := 'gallery_photos';
    ELSE RETURN NEW; -- Ignorar buckets no mapeados
  END CASE;

  -- Generar nombre del producto
  product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
  product_name := initcap(product_name);

  -- Generar URL pública
  public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;

  -- Crear datos de inserción según tabla
  CASE target_table
    WHEN 'carpets_items' THEN
      insert_data := jsonb_build_object(
        'name', product_name,
        'description', 'Alfombra ' || product_name || ' - Subida automáticamente',
        'image_url', public_url,
        'size', 'Consultar',
        'price', 'Consultar',
        'is_active', true,
        'display_order', floor(extract(epoch from now()))
      );
    WHEN 'curtains_items' THEN
      insert_data := jsonb_build_object(
        'name', product_name,
        'description', 'Cortina ' || product_name || ' - Subida automáticamente',
        'image_url', public_url,
        'size', '200 x 250 cm',
        'price', 'Consultar',
        'is_active', true,
        'display_order', floor(extract(epoch from now()))
      );
    WHEN 'furniture_items' THEN
      insert_data := jsonb_build_object(
        'name', product_name,
        'description', 'Mueble ' || product_name || ' - Subido automáticamente',
        'image_url', public_url,
        'category', 'furniture',
        'is_active', true,
        'display_order', floor(extract(epoch from now()))
      );
    WHEN 'monthly_updates' THEN
      insert_data := jsonb_build_object(
        'title', product_name,
        'description', 'Producto mensual ' || product_name || ' - Subido automáticamente',
        'image_url', public_url,
        'is_active', true,
        'display_order', floor(extract(epoch from now()))
      );
    WHEN 'gallery_photos' THEN
      insert_data := jsonb_build_object(
        'title', product_name,
        'description', 'Foto de galería ' || product_name,
        'image_url', public_url,
        'is_active', true,
        'display_order', floor(extract(epoch from now()))
      );
  END CASE;

  -- Insertar en la tabla correspondiente
  EXECUTE format('INSERT INTO public.%I SELECT * FROM jsonb_populate_record(NULL::public.%I, $1)', target_table, target_table)
  USING insert_data;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error pero no fallar el upload
    RAISE LOG 'Auto insert failed for %: %', NEW.name, SQLERRM;
    RETURN NEW;
END;
$$;

-- Crear trigger
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly'))
  EXECUTE FUNCTION public.auto_insert_product();
