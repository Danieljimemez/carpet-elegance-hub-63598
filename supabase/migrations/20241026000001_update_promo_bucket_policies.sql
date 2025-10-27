-- 🎯 ACTUALIZACIÓN DE PERMISOS PARA EL BUCKET 'promo'

-- 1. Habilitar RLS en la tabla promo_banner si no está habilitado
ALTER TABLE public.promo_banner ENABLE ROW LEVEL SECURITY;

-- 2. Eliminar políticas existentes si existen
DROP POLICY IF EXISTS "Enable read access for all users" ON public.promo_banner;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.promo_banner;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON public.promo_banner;
DROP POLICY IF EXISTS "Enable delete for authenticated users only" ON public.promo_banner;

-- 3. Crear nuevas políticas para promo_banner
-- Permitir lectura a todos
CREATE POLICY "Enable read access for all users" 
ON public.promo_banner 
FOR SELECT 
USING (true);

-- Permitir inserción solo a usuarios autenticados
CREATE POLICY "Enable insert for authenticated users only" 
ON public.promo_banner 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Permitir actualización solo a usuarios autenticados
CREATE POLICY "Enable update for authenticated users only" 
ON public.promo_banner 
FOR UPDATE 
TO authenticated 
USING (true);

-- Permitir eliminación solo a usuarios autenticados
CREATE POLICY "Enable delete for authenticated users only" 
ON public.promo_banner 
FOR DELETE 
TO authenticated 
USING (true);

-- 4. Configurar políticas de almacenamiento para el bucket 'promo'
-- Eliminar políticas existentes si existen
DROP POLICY IF EXISTS "Permitir lectura pública de imágenes promocionales" ON storage.objects;
DROP POLICY IF EXISTS "Permitir subida de imágenes a usuarios autenticados" ON storage.objects;
DROP POLICY IF EXISTS "Permitir actualización de imágenes a usuarios autenticados" ON storage.objects;
DROP POLICY IF EXISTS "Permitir eliminación de imágenes a usuarios autenticados" ON storage.objects;

-- 5. Crear políticas para el bucket 'promo'
-- Permitir lectura pública de las imágenes
CREATE POLICY "Permitir lectura pública de imágenes promocionales"
ON storage.objects FOR SELECT
USING (bucket_id = 'promo');

-- Permitir subida de imágenes solo a usuarios autenticados
CREATE POLICY "Permitir subida de imágenes a usuarios autenticados"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'promo' AND
  (storage.foldername(name))[1] IS NULL -- Solo permitir en la raíz del bucket
);

-- Permitir actualización de imágenes solo a usuarios autenticados
CREATE POLICY "Permitir actualización de imágenes a usuarios autenticados"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'promo');

-- Permitir eliminación de imágenes solo a usuarios autenticados
CREATE POLICY "Permitir eliminación de imágenes a usuarios autenticados"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'promo');

-- 6. Verificación final
SELECT '✅ PERMISOS ACTUALIZADOS' as status;
SELECT '🔐 Políticas RLS para promo_banner:' as info, 
       COUNT(*) as politicas 
FROM pg_policies 
WHERE tablename = 'promo_banner';

SELECT '📦 Políticas para el bucket promo:' as info,
       COUNT(*) as politicas
FROM pg_policies 
WHERE tablename = 'objects' 
AND schemaname = 'storage'
AND policy_name LIKE '%promo%';

-- Mostrar configuración actual del bucket
SELECT '⚙️ CONFIGURACIÓN DEL BUCKET "promo":' as info;
SELECT * FROM storage.buckets WHERE name = 'promo';
