-- Verificar agrupación por conjuntos en gallery
SELECT
  set_name,
  COUNT(*) as total_images,
  STRING_AGG(title, ', ' ORDER BY display_order) as image_titles,
  STRING_AGG(display_order::text, ', ' ORDER BY display_order) as display_orders
FROM gallery_photos
WHERE is_active = true
GROUP BY set_name
ORDER BY set_name;

-- Ver productos individuales con su set_name
SELECT title, set_name, display_order, image_url
FROM gallery_photos
WHERE is_active = true
ORDER BY set_name, display_order;
