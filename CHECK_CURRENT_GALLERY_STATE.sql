-- Verificar estado actual de gallery_photos
SELECT
  id,
  title,
  set_name,
  display_order,
  is_active,
  LEFT(image_url, 50) as url_preview
FROM gallery_photos
WHERE is_active = true
ORDER BY set_name, display_order;

-- Ver agrupación actual
SELECT
  set_name,
  COUNT(*) as total_images,
  STRING_AGG(title, ' | ' ORDER BY display_order) as images_in_set,
  STRING_AGG(display_order::text, ', ' ORDER BY display_order) as display_orders
FROM gallery_photos
WHERE is_active = true
GROUP BY set_name
ORDER BY set_name;
