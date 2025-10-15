-- Verificar si hay productos excluyendo placeholders
SELECT 'REAL PRODUCTS' as status,
  (SELECT COUNT(*) FROM gallery_photos WHERE is_active = true AND name NOT LIKE '%empty%') as gallery,
  (SELECT COUNT(*) FROM carpets_items WHERE is_active = true AND name NOT LIKE '%empty%') as carpets,
  (SELECT COUNT(*) FROM curtains_items WHERE is_active = true AND name NOT LIKE '%empty%') as curtains,
  (SELECT COUNT(*) FROM furniture_items WHERE is_active = true AND name NOT LIKE '%empty%') as furniture,
  (SELECT COUNT(*) FROM monthly_updates WHERE is_active = true AND title NOT LIKE '%empty%') as monthly;
