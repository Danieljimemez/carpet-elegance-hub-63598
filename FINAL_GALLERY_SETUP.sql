-- 🎯 SCRIPT FINAL COMPLETO PARA GALERÍA AGRUPADA

-- PASO 1: Agregar todas las columnas faltantes
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'gallery_photos' AND column_name = 'set_name') THEN
        ALTER TABLE gallery_photos ADD COLUMN set_name TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'gallery_photos' AND column_name = 'display_order') THEN
        ALTER TABLE gallery_photos ADD COLUMN display_order INTEGER DEFAULT 0;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'gallery_photos' AND column_name = 'alt_text') THEN
        ALTER TABLE gallery_photos ADD COLUMN alt_text TEXT;
    END IF;
END $$;

-- PASO 2: Actualizar registros existentes
UPDATE gallery_photos SET
    set_name = COALESCE(set_name, COALESCE(NULLIF(regexp_replace(title, ' \d+$', ''), ''), title)),
    display_order = COALESCE(display_order, COALESCE(NULLIF(regexp_replace(title, '^.* ', ''), title)::INTEGER, 0)),
    alt_text = COALESCE(alt_text, title);

-- PASO 3: Crear trigger corregido
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;

CREATE OR REPLACE FUNCTION auto_insert_gallery_trigger()
RETURNS TRIGGER AS $$
DECLARE
    product_name TEXT;
    set_name TEXT;
    display_order_val INTEGER;
    public_url TEXT;
BEGIN
    IF NEW.bucket_id = 'gallery' THEN
        product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        product_name := initcap(product_name);

        set_name := regexp_replace(product_name, ' \d+$', '');
        IF set_name = '' THEN set_name := product_name; END IF;

        display_order_val := COALESCE(NULLIF(regexp_replace(product_name, '^.* ', ''), product_name)::INTEGER, 0);

        public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/gallery/' || NEW.name;

        INSERT INTO gallery_photos (title, description, image_url, set_name, alt_text, display_order, is_active)
        VALUES (product_name, 'Imagen de galería ' || product_name || ' - Conjunto ' || set_name, public_url,
                set_name, product_name || ' - Vista del conjunto ' || set_name, display_order_val, true);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER auto_insert_trigger AFTER INSERT ON storage.objects
FOR EACH ROW EXECUTE FUNCTION auto_insert_gallery_trigger();

-- PASO 4: Limpiar y probar con datos de ejemplo
DELETE FROM gallery_photos;

INSERT INTO gallery_photos (title, description, image_url, set_name, alt_text, display_order, is_active) VALUES
('Grey 1', 'Imagen Grey 1', 'https://via.placeholder.com/400x400/808080/ffffff?text=Grey+1', 'Grey', 'Grey 1 - Vista del conjunto Grey', 1, true),
('Grey 2', 'Imagen Grey 2', 'https://via.placeholder.com/400x400/808080/ffffff?text=Grey+2', 'Grey', 'Grey 2 - Vista del conjunto Grey', 2, true),
('Navy 1', 'Imagen Navy 1', 'https://via.placeholder.com/400x400/000080/ffffff?text=Navy+1', 'Navy', 'Navy 1 - Vista del conjunto Navy', 1, true),
('Beige 1', 'Imagen Beige 1', 'https://via.placeholder.com/400x400/D2B48C/000000?text=Beige+1', 'Beige', 'Beige 1 - Vista del conjunto Beige', 1, true);

-- PASO 5: Verificar agrupación final
SELECT '🎯 AGRUPACIÓN COMPLETA' as resultado,
       set_name as conjunto,
       COUNT(*) as imagenes,
       STRING_AGG(title, ' → ' ORDER BY display_order) as secuencia_imagenes
FROM gallery_photos
WHERE is_active = true
GROUP BY set_name
ORDER BY set_name;
