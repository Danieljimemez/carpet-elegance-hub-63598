-- Trigger con logging para debug
CREATE OR REPLACE FUNCTION public.handle_storage_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  http_response RECORD;
BEGIN
  RAISE LOG 'Trigger activated for bucket: %, file: %', NEW.bucket_id, NEW.name;
  
  BEGIN
    SELECT * INTO http_response FROM extensions.http((
      'POST',
      'https://geppdtgvymykuycrfkdf.supabase.co/functions/v1/auto-update-tables',
      ARRAY[extensions.http_header('Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcHBkdGd2eW15a3V5Y3Jma2RmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDM5NTc0MywiZXhwIjoyMDc1OTcxNzQzfQ.byc1ZMtovXhxmPmQq5A8Jc-wuCWxGjFiQXGaz4saVyk'),
             extensions.http_header('Content-Type', 'application/json')],
      'application/json',
      json_build_object('record', row_to_json(NEW), 'old_record', NULL)::TEXT
    ));
    
    RAISE LOG 'HTTP Response: %', http_response;
    
  EXCEPTION
    WHEN OTHERS THEN
      RAISE LOG 'Trigger function failed: %', SQLERRM;
  END;
  
  RETURN NEW;
END;
$$;

-- Recrear trigger
DROP TRIGGER IF EXISTS on_storage_update ON storage.objects;
CREATE TRIGGER on_storage_update
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly'))
  EXECUTE FUNCTION public.handle_storage_update();
