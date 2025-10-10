-- Insert sample categories
INSERT INTO public.categories (name, description, image_url) VALUES
('Alfombras Modernas', 'Diseños contemporáneos con líneas limpias', '/assets/rug-modern-1.jpg'),
('Alfombras Persas', 'Elegancia clásica y artesanía tradicional', '/assets/rug-persian-1.jpg'),
('Alfombras Minimalistas', 'Simplicidad sofisticada para espacios modernos', '/assets/rug-minimal-1.jpg'),
('Alfombras Bohemias', 'Colores vibrantes y patrones étnicos', '/assets/rug-boho-1.jpg');

-- Insert sample products
INSERT INTO public.herramientas (nombre, precio, descripcion, imagen_url, category_id) VALUES
('Alfombra Moderna Azul', '$299.99', 'Alfombra moderna con diseño geométrico en tonos azules', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Alfombras Modernas')),
('Alfombra Persa Roja', '$499.99', 'Alfombra persa tradicional con patrones intrincados', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Alfombras Persas')),
('Alfombra Minimalista Gris', '$199.99', 'Alfombra minimalista en gris claro para espacios modernos', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Alfombras Minimalistas')),
('Alfombra Bohemia Multicolor', '$349.99', 'Alfombra bohemia con colores vibrantes y patrones étnicos', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Alfombras Bohemias'));

-- Insert sample testimonials
INSERT INTO public.testimonios (nombre, rol, comentario, calificacion) VALUES
('María González', 'Arquitecta', 'Excelente calidad y servicio. Las alfombras transformaron mi sala de estar.', 5),
('Carlos Rodríguez', 'Cliente', 'Muy satisfecho con la compra. Entrega rápida y productos de alta calidad.', 4),
('Ana López', 'Decoradora', 'Variedad increíble y atención al cliente excepcional.', 5);
