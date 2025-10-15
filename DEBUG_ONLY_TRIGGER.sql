-- Trigger de solo logging para debug
CREATE OR REPLACE FUNCTION public.debug_only_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Solo insertar log, nada más
    INSERT INTO public.trigger_logs (bucket_id, file_name, action)
    VALUES (NEW.bucket_id, NEW.name, 'TRIGGER_ACTIVATED');

    RETURN NEW;
EXCEPTION
    WHEN OTHERS THEN
        -- Si ni siquiera puede loggear, algo está muy mal
        RETURN NEW;
END;
$$;

-- Aplicar trigger de solo debug
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly'))
  EXECUTE FUNCTION public.debug_only_trigger();
