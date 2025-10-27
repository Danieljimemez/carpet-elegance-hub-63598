-- Check if RLS is enabled on the gallery_photos table
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'gallery_photos';

-- Check existing policies on the gallery_photos table
SELECT * FROM pg_policies 
WHERE tablename = 'gallery_photos';

-- Enable RLS if not already enabled
ALTER TABLE public.gallery_photos ENABLE ROW LEVEL SECURITY;

-- Create a policy to allow public read access to active gallery photos
CREATE POLICY "Enable read access for all users" 
ON public.gallery_photos
FOR SELECT
TO public
USING (is_active = true);

-- Verify the policy was created
SELECT * FROM pg_policies 
WHERE tablename = 'gallery_photos';
