-- Trigger que llama a Edge Function con manejo de errores
CREATE OR REPLACE FUNCTION public.call_edge_function()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Llamar a la Edge Function pero no fallar si hay error
  BEGIN
    PERFORM http((
      'POST',
      'https://geppdtgvymykuycrfkdf.supabase.co/functions/v1/auto-update-tables',
      ARRAY[http_header('Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcHBkdGd2eW15a3V5Y3Jma2RmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDM5NTc0MywiZXhwIjoyMDc1OTcxNzQzfQ.byc1ZMtovXhxmPmQq5A8Jc-wuCWxGjFiQGXaz4saVyk'),
             http_header('Content-Type', 'application/json')],
      'application/json',
      json_build_object('record', row_to_json(NEW))::TEXT
    ));
  EXCEPTION
    WHEN OTHERS THEN
      -- Log error pero permitir que el upload continúe
      RAISE LOG 'Edge Function call failed: %', SQLERRM;
  END;

  RETURN NEW;
END;
$$;

-- Aplicar trigger que llama a Edge Function
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly'))
  EXECUTE FUNCTION public.call_edge_function();
