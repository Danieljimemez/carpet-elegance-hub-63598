-- Verificar registros en carpets_items
SELECT id, name, image_url FROM public.carpets_items WHERE image_url LIKE '%carpets%' ORDER BY created_at DESC LIMIT 5;
