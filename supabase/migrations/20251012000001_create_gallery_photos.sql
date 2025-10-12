-- Create gallery_photos table for dynamic photo management
CREATE TABLE public.gallery_photos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    image_url TEXT NOT NULL,
    alt_text VARCHAR(255),
    season VARCHAR(50) DEFAULT 'all', -- 'spring', 'summer', 'fall', 'winter', 'all'
    is_active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- Enable RLS
ALTER TABLE public.gallery_photos ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
CREATE POLICY "Anyone can view active gallery photos"
ON public.gallery_photos
FOR SELECT
USING (is_active = true);

-- Create index for better performance
CREATE INDEX idx_gallery_photos_season_active ON public.gallery_photos(season, is_active);
CREATE INDEX idx_gallery_photos_display_order ON public.gallery_photos(display_order);

-- Insert some sample gallery photos (you can manage these from Supabase dashboard)
INSERT INTO public.gallery_photos (name, image_url, alt_text, season, display_order) VALUES
('Alfombra Moderna Azul', '/alfombras/Alfombra Azul Brillante.png', 'Alfombra moderna en tono azul brillante', 'all', 1),
('Alfombra Elegante Gris', '/alfombras/Alfombra Gris Medio.png', 'Alfombra elegante en gris medio', 'all', 2),
('Alfombra Clásica Roja', '/alfombras/Alfombra Rojo Oscuro.png', 'Alfombra clásica en rojo oscuro', 'fall', 3),
('Alfombra Natural Beige', '/alfombras/Alfombra Beige Claro.png', 'Alfombra natural en beige claro', 'spring', 4);
