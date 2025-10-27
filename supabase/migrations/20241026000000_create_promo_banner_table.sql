-- Create promo_banner table
CREATE TABLE IF NOT EXISTS public.promo_banner (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  image_url TEXT NOT NULL,
  alt_text TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  bucket_id TEXT,
  path TEXT,
  size INT,
  mime_type TEXT,
  metadata JSONB
);

-- Enable RLS
ALTER TABLE public.promo_banner ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Enable read access for all users" 
ON public.promo_banner 
FOR SELECT 
TO public 
USING (true);

-- Create policy to allow insert/update/delete for authenticated users with appropriate permissions
CREATE POLICY "Enable insert for authenticated users only"
ON public.promo_banner
FOR INSERT
TO authenticated
WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users only"
ON public.promo_banner
FOR UPDATE
TO authenticated
USING (true);

CREATE POLICY "Enable delete for authenticated users only"
ON public.promo_banner
FOR DELETE
TO authenticated
USING (true);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_modified_column() 
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW; 
END;
$$ language 'plpgsql';

CREATE TRIGGER update_promo_banner_modtime
BEFORE UPDATE ON public.promo_banner
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- Function to handle new files in storage
CREATE OR REPLACE FUNCTION public.handle_new_promo_image()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Only process files in the 'promo' folder
  IF NEW.bucket_id = 'promo' THEN
    INSERT INTO public.promo_banner (
      image_url,
      alt_text,
      bucket_id,
      path,
      size,
      mime_type,
      metadata,
      display_order
    ) VALUES (
      NEW.path_tokens[1],  -- This will be the full path in the bucket
      COALESCE(NEW.metadata->>'alt_text', 'Imagen promocional'),
      NEW.bucket_id,
      NEW.path_tokens[1],
      NEW.metadata->>'size',
      NEW.metadata->>'mimetype',
      NEW.metadata,
      COALESCE((NEW.metadata->>'display_order')::INT, 0)
    )
    ON CONFLICT (path) DO UPDATE
    SET 
      image_url = EXCLUDED.image_url,
      size = EXCLUDED.size,
      mime_type = EXCLUDED.mime_type,
      metadata = EXCLUDED.metadata,
      updated_at = NOW();
  END IF;
  RETURN NEW;
END;
$$;

-- Create trigger for new files in storage
CREATE OR REPLACE TRIGGER on_promo_image_upload
AFTER INSERT ON storage.objects
FOR EACH ROW
EXECUTE FUNCTION public.handle_new_promo_image();

-- Function to handle file deletions from storage
CREATE OR REPLACE FUNCTION public.handle_deleted_promo_image()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  DELETE FROM public.promo_banner 
  WHERE bucket_id = OLD.bucket_id 
  AND path = OLD.path_tokens[1];
  RETURN OLD;
END;
$$;

-- Create trigger for deleted files in storage
CREATE OR REPLACE TRIGGER on_promo_image_delete
AFTER DELETE ON storage.objects
FOR EACH ROW
EXECUTE FUNCTION public.handle_deleted_promo_image();

-- Function to handle file updates in storage
CREATE OR REPLACE FUNCTION public.handle_updated_promo_image()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Only process files in the 'promo' folder
  IF NEW.bucket_id = 'promo' THEN
    UPDATE public.promo_banner
    SET 
      image_url = NEW.path_tokens[1],
      size = NEW.metadata->>'size',
      mime_type = NEW.metadata->>'mimetype',
      metadata = NEW.metadata,
      updated_at = NOW()
    WHERE path = NEW.path_tokens[1];
  END IF;
  RETURN NEW;
END;
$$;

-- Create trigger for updated files in storage
CREATE OR REPLACE TRIGGER on_promo_image_update
AFTER UPDATE ON storage.objects
FOR EACH ROW
WHEN (OLD.path_tokens[1] IS DISTINCT FROM NEW.path_tokens[1])
EXECUTE FUNCTION public.handle_updated_promo_image();

-- Create storage bucket for promo images
INSERT INTO storage.buckets (id, name, public)
VALUES ('promo', 'promo', true)
ON CONFLICT (id) DO NOTHING;

-- Set up storage policies for the promo bucket
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'promo');

CREATE POLICY "Enable insert for authenticated users only"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'promo');

CREATE POLICY "Enable update for authenticated users only"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'promo');

CREATE POLICY "Enable delete for authenticated users only"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'promo');
