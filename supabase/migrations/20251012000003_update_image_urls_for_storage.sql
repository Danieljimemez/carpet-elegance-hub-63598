-- Update gallery_photos table to use Supabase Storage URLs
UPDATE public.gallery_photos SET image_url =
CASE
  WHEN image_url LIKE '/alfombras/%' THEN
    REPLACE(image_url, '/alfombras/', 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/gallery-images/')
  ELSE image_url
END;
