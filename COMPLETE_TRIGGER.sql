-- Trigger completo mejorado para todos los buckets con agrupación inteligente
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
    -- Insertar log de que el trigger se activó
    INSERT INTO public.trigger_logs (bucket_id, file_name, action)
    VALUES (NEW.bucket_id, NEW.name, 'TRIGGER_STARTED');

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

        -- Generar datos base
        product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        product_name := initcap(product_name);

        -- Para gallery, extraer set_name (agrupación inteligente)
        IF NEW.bucket_id = 'gallery' THEN
            -- Extraer set_name (todo antes del último número/espacio + número)
            -- Ejemplo: "Grey 1" → set_name = "Grey"
            set_name := regexp_replace(product_name, ' \d+$', '');
            -- Si no hay número al final, usar el nombre completo como set_name
            IF set_name = product_name THEN
                set_name := product_name;
            END IF;

            -- Extraer número para orden (ejemplo: "Grey 1" → 1)
            display_order_val := COALESCE(NULLIF(regexp_replace(product_name, '^.* ', ''), product_name)::INTEGER, 0);
        END IF;

        -- Generar URL con encoding
        public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;

        -- Insertar según tabla
        BEGIN
            CASE target_table
                WHEN 'carpets_items' THEN
                    INSERT INTO public.carpets_items (name, description, image_url, size, price, is_active)
                    VALUES (product_name, 'Alfombra ' || product_name || ' - Subida automática', public_url, 'Consultar', 'Consultar', true);
                WHEN 'curtains_items' THEN
                    INSERT INTO public.curtains_items (name, description, image_url, size, price, is_active)
                    VALUES (product_name, 'Cortina ' || product_name || ' - Subida automática', public_url, '200x250cm', 'Consultar', true);
                WHEN 'furniture_items' THEN
                    INSERT INTO public.furniture_items (name, description, image_url, category, is_active)
                    VALUES (product_name, 'Mueble ' || product_name || ' - Subido automáticamente', public_url, 'furniture', true);
                WHEN 'monthly_updates' THEN
                    INSERT INTO public.monthly_updates (title, description, image_url, is_active)
                    VALUES (product_name, 'Producto mensual ' || product_name || ' - Subido automáticamente', public_url, true);
                WHEN 'gallery_photos' THEN
                    INSERT INTO public.gallery_photos (
                        title,
                        description,
                        image_url,
                        set_name,
                        alt_text,
                        display_order,
                        is_active
                    )
                    VALUES (
                        product_name,
                        'Imagen de galería ' || product_name || ' - Conjunto ' || set_name,
                        public_url,
                        set_name,
                        product_name || ' - Vista del conjunto ' || set_name,
                        display_order_val,
                        true
                    );
            END CASE;

            -- Log de éxito
            INSERT INTO public.trigger_logs (bucket_id, file_name, action)
            VALUES (NEW.bucket_id, NEW.name, 'INSERT_SUCCESS');

        EXCEPTION
            WHEN OTHERS THEN
                -- Log de error
                INSERT INTO public.trigger_logs (bucket_id, file_name, action, error_message)
                VALUES (NEW.bucket_id, NEW.name, 'INSERT_FAILED', SQLERRM);
        END;
    ELSE
        -- Log de bucket ignorado
        INSERT INTO public.trigger_logs (bucket_id, file_name, action)
        VALUES (NEW.bucket_id, NEW.name, 'BUCKET_IGNORED');
    END IF;

    RETURN NEW;
END;
$$;

-- Aplicar trigger completo
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  EXECUTE FUNCTION public.auto_insert_complete_trigger();
