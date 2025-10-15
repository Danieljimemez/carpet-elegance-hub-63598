-- 🔧 CORRECCIÓN DEL TRIGGER PARA GALERÍA AGRUPADA

-- Paso 1: Eliminar trigger existente si existe
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;

-- Paso 2: Crear función corregida (solo para gallery)
CREATE OR REPLACE FUNCTION auto_insert_gallery_trigger()
RETURNS TRIGGER
AS $$
DECLARE
    product_name TEXT;
    set_name TEXT;
    display_order_val INTEGER;
    public_url TEXT;
BEGIN
    -- Solo procesar bucket gallery
    IF NEW.bucket_id = 'gallery' THEN
        -- Extraer nombre del producto
        product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        product_name := initcap(product_name);

        -- Extraer set_name (agrupación automática)
        set_name := regexp_replace(product_name, ' \d+$', '');
        IF set_name = '' THEN
            set_name := product_name;
        END IF;

        -- Extraer número para orden
        display_order_val := COALESCE(NULLIF(regexp_replace(product_name, '^.* ', ''), product_name)::INTEGER, 0);

        -- Generar URL
        public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/gallery/' || NEW.name;

        -- Insertar en gallery
        INSERT INTO gallery_photos (
            title, description, image_url, set_name, alt_text, display_order, is_active
        ) VALUES (
            product_name,
            'Imagen de galería ' || product_name || ' - Conjunto ' || set_name,
            public_url,
            set_name,
            product_name || ' - Vista del conjunto ' || set_name,
            display_order_val,
            true
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Paso 3: Aplicar trigger
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  EXECUTE FUNCTION auto_insert_gallery_trigger();

-- Paso 4: Probar con datos de ejemplo
DELETE FROM gallery_photos;

INSERT INTO gallery_photos (title, description, image_url, set_name, alt_text, display_order, is_active) VALUES
('Grey 1', 'Imagen Grey 1', 'https://via.placeholder.com/400x400/808080/ffffff?text=Grey+1', 'Grey', 'Grey 1', 1, true),
('Grey 2', 'Imagen Grey 2', 'https://via.placeholder.com/400x400/808080/ffffff?text=Grey+2', 'Grey', 'Grey 2', 2, true),
('Navy 1', 'Imagen Navy 1', 'https://via.placeholder.com/400x400/000080/ffffff?text=Navy+1', 'Navy', 'Navy 1', 1, true);

-- Paso 5: Verificar agrupación
SELECT
  '✅ RESULTADO AGRUPACIÓN' as status,
  set_name,
  COUNT(*) as imagenes,
  STRING_AGG(title, ' → ' ORDER BY display_order) as conjunto
FROM gallery_photos
WHERE is_active = true
GROUP BY set_name
ORDER BY set_name;
