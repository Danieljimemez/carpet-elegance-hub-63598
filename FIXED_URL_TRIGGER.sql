-- Trigger mejorado para agrupar imágenes por conjuntos
CREATE OR REPLACE FUNCTION public.auto_insert_gallery_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    product_name TEXT;
    set_name TEXT;
    public_url TEXT;
BEGIN
    -- Insertar log de que el trigger se activó
    INSERT INTO public.trigger_logs (bucket_id, file_name, action)
    VALUES (NEW.bucket_id, NEW.name, 'TRIGGER_STARTED');

    -- Solo procesar bucket gallery
    IF NEW.bucket_id = 'gallery' THEN

        -- Extraer nombre del producto (todo antes del último número)
        product_name := regexp_replace(split_part(NEW.name, '.', 1), '[-_]', ' ', 'g');
        product_name := initcap(product_name);

        -- Extraer set_name (todo antes del último número/espacio + número)
        -- Ejemplo: "Grey 1" → set_name = "Grey"
        set_name := regexp_replace(product_name, ' \d+$', '');

        -- Si no hay número al final, usar el nombre completo como set_name
        IF set_name = product_name THEN
            set_name := product_name;
        END IF;

        -- Generar URL
        public_url := 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/' || NEW.bucket_id || '/' || NEW.name;

        -- Insertar en gallery_photos
        BEGIN
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
                0, -- display_order, se puede ajustar después
                true
            );

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

-- Aplicar trigger mejorado
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  EXECUTE FUNCTION public.auto_insert_gallery_trigger();
