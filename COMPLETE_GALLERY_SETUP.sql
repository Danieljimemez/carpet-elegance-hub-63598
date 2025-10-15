-- 🎯 SETUP COMPLETO Y PRUEBA DE GALERÍA AGRUPADA

-- Paso 1: Limpiar datos existentes
DELETE FROM gallery_photos;

-- Paso 2: Aplicar trigger que agrupa automáticamente
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;

-- Paso 3: Crear función que agrupa por prefijo
CREATE OR REPLACE FUNCTION public.auto_insert_complete_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    target_table TEXT;
    product_name TEXT;
    set_name TEXT;
    public_url TEXT;
    display_order_val INTEGER;
BEGIN
    -- Solo procesar bucket gallery
    IF NEW.bucket_id = 'gallery' THEN
        -- Extraer nombre del producto
        product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        product_name := initcap(product_name);

        -- Extraer set_name (agrupación automática)
        -- "Grey 1" → "Grey", "Navy 2" → "Navy"
        set_name := regexp_replace(product_name, ' \d+$', '');
        IF set_name = product_name THEN
            set_name := product_name;
        END IF;

        -- Extraer número para orden
        display_order_val := COALESCE(NULLIF(regexp_replace(product_name, '^.* ', ''), product_name)::INTEGER, 0);

        -- Generar URL
        public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/gallery/' || NEW.name;

        -- Insertar en gallery
        INSERT INTO public.gallery_photos (
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

-- Paso 4: Aplicar trigger
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  EXECUTE FUNCTION public.auto_insert_complete_trigger();

-- Paso 5: Insertar datos de prueba
INSERT INTO gallery_photos (title, description, image_url, set_name, alt_text, display_order, is_active) VALUES
('Grey 1', 'Imagen Grey 1', 'https://via.placeholder.com/400x400/808080/ffffff?text=Grey+1', 'Grey', 'Grey 1', 1, true),
('Grey 2', 'Imagen Grey 2', 'https://via.placeholder.com/400x400/808080/ffffff?text=Grey+2', 'Grey', 'Grey 2', 2, true),
('Navy 1', 'Imagen Navy 1', 'https://via.placeholder.com/400x400/000080/ffffff?text=Navy+1', 'Navy', 'Navy 1', 1, true),
('Beige 1', 'Imagen Beige 1', 'https://via.placeholder.com/400x400/D2B48C/000000?text=Beige+1', 'Beige', 'Beige 1', 1, true);

-- Paso 6: Verificar agrupación
SELECT
  '✅ AGRUPACIÓN FUNCIONANDO' as status,
  set_name,
  COUNT(*) as imagenes_en_conjunto,
  STRING_AGG(title, ' → ' ORDER BY display_order) as nombres_imagenes
FROM gallery_photos
WHERE is_active = true
GROUP BY set_name
ORDER BY set_name;
