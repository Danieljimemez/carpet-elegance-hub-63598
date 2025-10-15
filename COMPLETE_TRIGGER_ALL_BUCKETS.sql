-- 🔧 TRIGGER COMPLETO PARA TODOS LOS BUCKETS

-- Eliminar trigger actual
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;

-- Crear función que maneja TODOS los buckets
CREATE OR REPLACE FUNCTION auto_insert_all_buckets_trigger()
RETURNS TRIGGER AS $$
DECLARE
    target_table TEXT;
    product_name TEXT;
    set_name TEXT;
    display_order_val INTEGER;
    public_url TEXT;
BEGIN
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

        -- Procesar nombre del producto
        product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        product_name := initcap(product_name);

        -- Para gallery: extraer set_name para agrupación
        IF NEW.bucket_id = 'gallery' THEN
            set_name := regexp_replace(product_name, ' \d+$', '');
            IF set_name = '' THEN set_name := product_name; END IF;
            display_order_val := COALESCE(NULLIF(regexp_replace(product_name, '^.* ', ''), product_name)::INTEGER, 0);
        END IF;

        -- Generar URL
        public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;

        -- Insertar según tabla
        CASE target_table
            WHEN 'carpets_items' THEN
                INSERT INTO carpets_items (name, description, image_url, size, price, is_active)
                VALUES (product_name, 'Alfombra ' || product_name || ' subida automáticamente', public_url, 'Consultar', 'Consultar', true);

            WHEN 'curtains_items' THEN
                INSERT INTO curtains_items (name, description, image_url, size, price, is_active)
                VALUES (product_name, 'Cortina ' || product_name || ' subida automáticamente', public_url, '200x250cm', 'Consultar', true);

            WHEN 'furniture_items' THEN
                INSERT INTO furniture_items (name, description, image_url, category, is_active)
                VALUES (product_name, 'Mueble ' || product_name || ' subido automáticamente', public_url, 'furniture', true);

            WHEN 'monthly_updates' THEN
                INSERT INTO monthly_updates (title, description, image_url, is_active)
                VALUES (product_name, 'Producto mensual ' || product_name || ' subido automáticamente', public_url, true);

            WHEN 'gallery_photos' THEN
                INSERT INTO gallery_photos (title, description, image_url, set_name, alt_text, display_order, is_active)
                VALUES (product_name, 'Imagen de galería ' || product_name || ' - Conjunto ' || set_name, public_url,
                        set_name, product_name || ' - Vista del conjunto ' || set_name, display_order_val, true);
        END CASE;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a todos los buckets
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  EXECUTE FUNCTION auto_insert_all_buckets_trigger();

-- Verificar que el trigger está aplicado
SELECT '✅ TRIGGER APLICADO' as status,
       trigger_name,
       event_manipulation,
       event_object_table
FROM information_schema.triggers
WHERE trigger_name = 'auto_insert_trigger';
