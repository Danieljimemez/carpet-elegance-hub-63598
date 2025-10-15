-- Verificar qué registros hay en carpets_items
SELECT id, name, image_url, created_at FROM public.carpets_items ORDER BY created_at DESC LIMIT 5;

-- Verificar que las imágenes existen en storage
SELECT bucket_id, name, path_tokens FROM storage.objects WHERE bucket_id = 'carpets' ORDER BY created_at DESC LIMIT 5;
