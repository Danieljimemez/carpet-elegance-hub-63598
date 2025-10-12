-- Update gallery_photos table to support image sets
ALTER TABLE public.gallery_photos
ADD COLUMN set_name VARCHAR(255),
ADD COLUMN set_position INTEGER DEFAULT 1;

-- Clear existing data
DELETE FROM public.gallery_photos;

-- Insert the new carpet sets
INSERT INTO public.gallery_photos (name, image_url, alt_text, season, display_order, set_name, set_position, is_active) VALUES
-- Aqua Blue Set
('Aqua Blue 1', '/alfombras/Aqua Blue 1.png', 'Alfombra Aqua Blue vista 1', 'all', 1, 'Aqua Blue', 1, true),
('Aqua Blue 2', '/alfombras/Aqua Blue 2.png', 'Alfombra Aqua Blue vista 2', 'all', 2, 'Aqua Blue', 2, true),

-- Beige Set
('Beige 1', '/alfombras/Beige 1.png', 'Alfombra Beige vista 1', 'all', 3, 'Beige', 1, true),
('Beige 2', '/alfombras/Beige 2.png', 'Alfombra Beige vista 2', 'all', 4, 'Beige', 2, true),

-- Beige Claro Set
('Beige Claro 1', '/alfombras/Beige Claro 1.png', 'Alfombra Beige Claro vista 1', 'all', 5, 'Beige Claro', 1, true),
('Beige Claro 2', '/alfombras/Beige Claro 2.png', 'Alfombra Beige Claro vista 2', 'all', 6, 'Beige Claro', 2, true),

-- Dark Beige Set
('Dark Beige 1', '/alfombras/Dark Beige 1.png', 'Alfombra Dark Beige vista 1', 'fall', 7, 'Dark Beige', 1, true),
('Dark Beige 2', '/alfombras/Dark Beige 2.png', 'Alfombra Dark Beige vista 2', 'fall', 8, 'Dark Beige', 2, true),

-- Dark Grey Set
('Dark Grey 1', '/alfombras/Dark Grey 1.png', 'Alfombra Dark Grey vista 1', 'winter', 9, 'Dark Grey', 1, true),
('Dark Grey 2', '/alfombras/Dark Grey 2.png', 'Alfombra Dark Grey vista 2', 'winter', 10, 'Dark Grey', 2, true),

-- Grey Set
('Grey 1', '/alfombras/Grey 1.png', 'Alfombra Grey vista 1', 'all', 11, 'Grey', 1, true),
('Grey 2', '/alfombras/Grey 2.png', 'Alfombra Grey vista 2', 'all', 12, 'Grey', 2, true),

-- Grey Oscuro Set (note: filename has inconsistency, using Grey oscuro 2.png)
('Grey Oscuro 1', '/alfombras/Grey Oscuro 1.png', 'Alfombra Grey Oscuro vista 1', 'winter', 13, 'Grey Oscuro', 1, true),
('Grey Oscuro 2', '/alfombras/Grey oscuro 2.png', 'Alfombra Grey Oscuro vista 2', 'winter', 14, 'Grey Oscuro', 2, true),

-- Ivory Set
('Ivory 1', '/alfombras/Ivory 1.png', 'Alfombra Ivory vista 1', 'spring', 15, 'Ivory', 1, true),
('Ivory 2', '/alfombras/Ivory 2.png', 'Alfombra Ivory vista 2', 'spring', 16, 'Ivory', 2, true),

-- Navy Set
('Navy 1', '/alfombras/Navy 1.png', 'Alfombra Navy vista 1', 'all', 17, 'Navy', 1, true),
('Navy 2', '/alfombras/Navy 2.png', 'Alfombra Navy vista 2', 'all', 17, 'Navy', 2, true),

-- Pink Set
('Pink 1', '/alfombras/Pink 1.png', 'Alfombra Pink vista 1', 'spring', 18, 'Pink', 1, true),
('Pink 2', '/alfombras/Pink 2.png', 'Alfombra Pink vista 2', 'spring', 19, 'Pink', 2, true),

-- Purple Set
('Purple 1', '/alfombras/Purple 1.png', 'Alfombra Purple vista 1', 'all', 20, 'Purple', 1, true),
('Purple 2', '/alfombras/Purple 2.png', 'Alfombra Purple vista 2', 'all', 21, 'Purple', 2, true),

-- Red Set
('Red 1', '/alfombras/Red 1.png', 'Alfombra Red vista 1', 'fall', 22, 'Red', 1, true),
('Red 2', '/alfombras/Red 2.png', 'Alfombra Red vista 2', 'fall', 23, 'Red', 2, true),

-- Red Dark Set
('Red Dark 1', '/alfombras/Red Dark 1.png', 'Alfombra Red Dark vista 1', 'fall', 24, 'Red Dark', 1, true),
('Red Dark 2', '/alfombras/Red Dark 2.png', 'Alfombra Red Dark vista 2', 'fall', 25, 'Red Dark', 2, true),

-- Silver Set
('Silver 1', '/alfombras/Silver 1.png', 'Alfombra Silver vista 1', 'winter', 26, 'Silver', 1, true),
('Silver 2', '/alfombras/Silver 2.png', 'Alfombra Silver vista 2', 'winter', 27, 'Silver', 2, true);
