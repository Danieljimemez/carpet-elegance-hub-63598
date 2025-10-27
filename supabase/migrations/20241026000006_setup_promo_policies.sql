-- ===========================================
-- POLÍTICAS DE ACCESO PARA PROMO_BANNER
-- ===========================================

-- 1. Asegurar que la tabla tenga RLS habilitado
ALTER TABLE public.promo_banner ENABLE ROW LEVEL SECURITY;

-- 2. Eliminar políticas existentes si existen
DROP POLICY IF EXISTS "Allow public read promo" ON public.promo_banner;
DROP POLICY IF EXISTS "Allow insert for authenticated" ON public.promo_banner;
DROP POLICY IF EXISTS "Allow update for authenticated" ON public.promo_banner;

-- 3. Crear políticas de acceso
-- Lectura pública para todos los usuarios
CREATE POLICY "Allow public read promo" 
ON public.promo_banner 
FOR SELECT 
USING (true);

-- Inserción solo para usuarios autenticados
CREATE POLICY "Allow insert for authenticated" 
ON public.promo_banner 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Actualización solo para usuarios autenticados
CREATE POLICY "Allow update for authenticated" 
ON public.promo_banner 
FOR UPDATE 
TO authenticated 
USING (true);

-- 4. Configurar políticas de almacenamiento para el bucket 'promo'
-- Eliminar políticas existentes
DROP POLICY IF EXISTS "Allow public read promo bucket" ON storage.objects;
DROP POLICY IF EXISTS "Allow insert promo bucket" ON storage.objects;
DROP POLICY IF EXISTS "Allow update promo bucket" ON storage.objects;

-- 5. Crear políticas para el bucket 'promo'
-- Lectura pública
CREATE POLICY "Allow public read promo bucket"
ON storage.objects 
FOR SELECT
USING (bucket_id = 'promo');

-- Inserción solo para usuarios autenticados
CREATE POLICY "Allow insert promo bucket"
ON storage.objects 
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'promo');

-- Actualización solo para usuarios autenticados
CREATE POLICY "Allow update promo bucket"
ON storage.objects 
FOR UPDATE
TO authenticated
USING (bucket_id = 'promo');

-- 6. Verificar políticas aplicadas
SELECT '✅ POLÍTICAS APLICADAS' as status;

-- Mostrar políticas de la tabla
SELECT '📋 POLÍTICAS DE promo_banner:' as info;
SELECT 
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM 
    pg_policies 
WHERE 
    tablename = 'promo_banner';

-- Mostrar políticas del bucket
SELECT '📦 POLÍTICAS DEL BUCKET "promo":' as info;
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM 
    pg_policies 
WHERE 
    tablename = 'objects' 
    AND schemaname = 'storage'
    AND qual::text LIKE '%promo%';
