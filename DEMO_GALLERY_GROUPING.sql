-- 🧪 PRUEBA DEMOSTRATIVA DE AGRUPACIÓN

-- Limpiar para prueba
DELETE FROM gallery_photos;

-- Insertar imágenes de prueba que se agruparán automáticamente
INSERT INTO gallery_photos (title, description, image_url, set_name, alt_text, display_order, is_active) VALUES
-- Conjunto Grey
('Grey 1', 'Imagen de galería Grey 1 - Conjunto Grey', 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/gallery/Grey%201.png', 'Grey', 'Grey 1 - Vista del conjunto Grey', 1, true),
('Grey 2', 'Imagen de galería Grey 2 - Conjunto Grey', 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/gallery/Grey%202.png', 'Grey', 'Grey 2 - Vista del conjunto Grey', 2, true),

-- Conjunto Navy
('Navy 1', 'Imagen de galería Navy 1 - Conjunto Navy', 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/gallery/Navy%201.png', 'Navy', 'Navy 1 - Vista del conjunto Navy', 1, true),
('Navy 2', 'Imagen de galería Navy 2 - Conjunto Navy', 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/gallery/Navy%202.png', 'Navy', 'Navy 2 - Vista del conjunto Navy', 2, true),

-- Conjunto Beige
('Beige 1', 'Imagen de galería Beige 1 - Conjunto Beige', 'https://geppdtgvymykuycrfkdf.supabase.co/storage/v1/object/public/gallery/Beige%201.png', 'Beige', 'Beige 1 - Vista del conjunto Beige', 1, true);

-- Verificar agrupación
SELECT
  set_name,
  COUNT(*) as total_imagenes,
  STRING_AGG(title, ' | ' ORDER BY display_order) as imagenes_en_conjunto
FROM gallery_photos
WHERE is_active = true
GROUP BY set_name
ORDER BY set_name;
