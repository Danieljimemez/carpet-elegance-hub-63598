-- Verificar URLs específicas en todas las tablas
SELECT
  'CARPETS' as table_name,
  name,
  image_url,
  CASE
    WHEN image_url LIKE '% %' THEN 'TIENE ESPACIOS'
    WHEN image_url LIKE '%?%' THEN 'TIENE CARACTERES ESPECIALES'
    ELSE 'OK'
  END as status
FROM public.carpets_items
WHERE image_url LIKE '%carpets%' AND is_active = true
ORDER BY created_at DESC
LIMIT 5;

SELECT
  'CURTAINS' as table_name,
  name,
  image_url,
  CASE
    WHEN image_url LIKE '% %' THEN 'TIENE ESPACIOS'
    WHEN image_url LIKE '%?%' THEN 'TIENE CARACTERES ESPECIALES'
    ELSE 'OK'
  END as status
FROM public.curtains_items
WHERE image_url LIKE '%curtains%' AND is_active = true
ORDER BY created_at DESC
LIMIT 5;

SELECT
  'FURNITURE' as table_name,
  name,
  image_url,
  CASE
    WHEN image_url LIKE '% %' THEN 'TIENE ESPACIOS'
    WHEN image_url LIKE '%?%' THEN 'TIENE CARACTERES ESPECIALES'
    ELSE 'OK'
  END as status
FROM public.furniture_items
WHERE image_url LIKE '%furniture%' AND is_active = true
ORDER BY created_at DESC
LIMIT 5;

SELECT
  'MONTHLY' as table_name,
  title as name,
  image_url,
  CASE
    WHEN image_url LIKE '% %' THEN 'TIENE ESPACIOS'
    WHEN image_url LIKE '%?%' THEN 'TIENE CARACTERES ESPECIALES'
    ELSE 'OK'
  END as status
FROM public.monthly_updates
WHERE image_url LIKE '%monthly%' AND is_active = true
ORDER BY created_at DESC
LIMIT 5;

SELECT
  'GALLERY' as table_name,
  title as name,
  image_url,
  CASE
    WHEN image_url LIKE '% %' THEN 'TIENE ESPACIOS'
    WHEN image_url LIKE '%?%' THEN 'TIENE CARACTERES ESPECIALES'
    ELSE 'OK'
  END as status
FROM public.gallery_photos
WHERE image_url LIKE '%gallery%' AND is_active = true
ORDER BY created_at DESC
LIMIT 5;
