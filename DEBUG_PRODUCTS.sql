-- Verificar estado de productos y URLs
SELECT
  'GALLERY' as tabla,
  title as nombre,
  image_url,
  is_active,
  CASE WHEN image_url LIKE 'https://%' THEN 'URL_VALIDA' ELSE 'URL_INVALIDA' END as url_status
FROM gallery_photos
WHERE is_active = true
ORDER BY created_at DESC
LIMIT 3;

SELECT
  'CARPETS' as tabla,
  name as nombre,
  image_url,
  is_active,
  CASE WHEN image_url LIKE 'https://%' THEN 'URL_VALIDA' ELSE 'URL_INVALIDA' END as url_status
FROM carpets_items
WHERE is_active = true
ORDER BY created_at DESC
LIMIT 3;

SELECT
  'CURTAINS' as tabla,
  name as nombre,
  image_url,
  is_active,
  CASE WHEN image_url LIKE 'https://%' THEN 'URL_VALIDA' ELSE 'URL_INVALIDA' END as url_status
FROM curtains_items
WHERE is_active = true
ORDER BY created_at DESC
LIMIT 3;

SELECT
  'FURNITURE' as tabla,
  name as nombre,
  image_url,
  is_active,
  CASE WHEN image_url LIKE 'https://%' THEN 'URL_VALIDA' ELSE 'URL_INVALIDA' END as url_status
FROM furniture_items
WHERE is_active = true
ORDER BY created_at DESC
LIMIT 3;

SELECT
  'MONTHLY' as tabla,
  title as nombre,
  image_url,
  is_active,
  CASE WHEN image_url LIKE 'https://%' THEN 'URL_VALIDA' ELSE 'URL_INVALIDA' END as url_status
FROM monthly_updates
WHERE is_active = true
ORDER BY created_at DESC
LIMIT 3;
