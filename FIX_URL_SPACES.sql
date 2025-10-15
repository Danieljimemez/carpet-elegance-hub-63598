-- Corregir URLs que tienen espacios sin encoding
UPDATE public.carpets_items
SET image_url = REPLACE(image_url, ' ', '%20')
WHERE image_url LIKE '% %' AND image_url LIKE '%carpets%';

UPDATE public.curtains_items
SET image_url = REPLACE(image_url, ' ', '%20')
WHERE image_url LIKE '% %' AND image_url LIKE '%curtains%';

UPDATE public.furniture_items
SET image_url = REPLACE(image_url, ' ', '%20')
WHERE image_url LIKE '% %' AND image_url LIKE '%furniture%';

UPDATE public.monthly_updates
SET image_url = REPLACE(image_url, ' ', '%20')
WHERE image_url LIKE '% %' AND image_url LIKE '%monthly%';

UPDATE public.gallery_photos
SET image_url = REPLACE(image_url, ' ', '%20')
WHERE image_url LIKE '% %' AND image_url LIKE '%gallery%';
