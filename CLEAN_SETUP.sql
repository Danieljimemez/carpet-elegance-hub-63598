-- ===========================================
-- SETUP FINAL: POLÍTICAS DE STORAGE Y TRIGGER
-- Ejecutar en Supabase Dashboard > SQL Editor
-- ===========================================

-- 1. LIMPIAR POLÍTICAS EXISTENTES
DROP POLICY IF EXISTS "Allow uploads to gallery" ON storage.objects;
DROP POLICY IF EXISTS "Allow uploads to carpets" ON storage.objects;
DROP POLICY IF EXISTS "Allow uploads to curtains" ON storage.objects;
DROP POLICY IF EXISTS "Allow uploads to furniture" ON storage.objects;
DROP POLICY IF EXISTS "Allow uploads to monthly" ON storage.objects;
DROP POLICY IF EXISTS "Allow view gallery" ON storage.objects;
DROP POLICY IF EXISTS "Allow view carpets" ON storage.objects;
DROP POLICY IF EXISTS "Allow view curtains" ON storage.objects;
DROP POLICY IF EXISTS "Allow view furniture" ON storage.objects;
DROP POLICY IF EXISTS "Allow view monthly" ON storage.objects;

-- 2. POLÍTICAS PARA UPLOADS (sin auth check)
CREATE POLICY "Allow uploads to gallery" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'gallery');
CREATE POLICY "Allow uploads to carpets" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'carpets');
CREATE POLICY "Allow uploads to curtains" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'curtains');
CREATE POLICY "Allow uploads to furniture" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'furniture');
CREATE POLICY "Allow uploads to monthly" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'monthly');

-- 3. POLÍTICAS PARA VISTAS (públicas)
CREATE POLICY "Allow view gallery" ON storage.objects FOR SELECT USING (bucket_id = 'gallery');
CREATE POLICY "Allow view carpets" ON storage.objects FOR SELECT USING (bucket_id = 'carpets');
CREATE POLICY "Allow view curtains" ON storage.objects FOR SELECT USING (bucket_id = 'curtains');
CREATE POLICY "Allow view furniture" ON storage.objects FOR SELECT USING (bucket_id = 'furniture');
CREATE POLICY "Allow view monthly" ON storage.objects FOR SELECT USING (bucket_id = 'monthly');

-- 4. TRIGGER DE AUTOMATIZACIÓN
DROP TRIGGER IF EXISTS on_storage_update ON storage.objects;
DROP FUNCTION IF EXISTS public.handle_storage_update();

CREATE OR REPLACE FUNCTION public.handle_storage_update()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  payload TEXT;
  response_status INTEGER;
  response_body TEXT;
BEGIN
  IF TG_OP = 'INSERT' THEN
    payload := json_build_object(
      'record', row_to_json(NEW),
      'old_record', NULL
    )::TEXT;

    SELECT status, content INTO response_status, response_body
    FROM extensions.http(('POST', 'https://ahckbrfyenssuetjptns.supabase.co/functions/v1/auto-update-tables',
      ARRAY[extensions.http_header('Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFoY2ticmZ5ZW5zc3VldGpwdG5zIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDM5Mjc0NywiZXhwIjoyMDc1OTY4NzQ3fQ.I4jRf2_SpbPW-1i7dU_xhD0iMEHc7wKm4CeQuOKsW9s'),
             extensions.http_header('Content-Type', 'application/json')], 'application/json', payload));

    RAISE LOG 'Storage trigger response: % - %', response_status, response_body;
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER on_storage_update
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  WHEN (NEW.bucket_id IN ('gallery', 'carpets', 'curtains', 'furniture', 'monthly'))
  EXECUTE FUNCTION public.handle_storage_update();

-- 5. VERIFICACIÓN
SELECT 'SETUP COMPLETADO DESDE CERO' as status;
