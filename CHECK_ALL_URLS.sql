-- Verificar URLs generadas en todas las tablas
SELECT 'carpets' as bucket, name, image_url FROM public.carpets_items WHERE image_url LIKE '%carpets%' ORDER BY created_at DESC LIMIT 3
UNION ALL
SELECT 'curtains' as bucket, name, image_url FROM public.curtains_items WHERE image_url LIKE '%curtains%' ORDER BY created_at DESC LIMIT 3
UNION ALL
SELECT 'furniture' as bucket, name, image_url FROM public.furniture_items WHERE image_url LIKE '%furniture%' ORDER BY created_at DESC LIMIT 3
UNION ALL
SELECT 'gallery' as bucket, title as name, image_url FROM public.gallery_photos WHERE image_url LIKE '%gallery%' ORDER BY created_at DESC LIMIT 3
UNION ALL
SELECT 'monthly' as bucket, title as name, image_url FROM public.monthly_updates WHERE image_url LIKE '%monthly%' ORDER BY created_at DESC LIMIT 3;
