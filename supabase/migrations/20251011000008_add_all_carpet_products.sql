-- Add all 15 carpet products with their respective images
INSERT INTO public.herramientas (nombre, descripcion, imagen_url, category_id) VALUES
('Alfombra Azul Brillante', 'Alfombra de diseño moderno en tono azul brillante', '/alfombras/Alfombra Azul Brillante.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Azul Marino', 'Alfombra elegante en azul marino profundo', '/alfombras/Alfombra Azul Marino.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Beige Claro', 'Alfombra suave en tono beige claro', '/alfombras/Alfombra Beige Claro.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Gris Azulado', 'Alfombra moderna con tono gris azulado', '/alfombras/Alfombra Gris Azulado.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Gris Medio', 'Alfombra versátil en gris medio', '/alfombras/Alfombra Gris Medio.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Gris Oscuro', 'Alfombra sofisticada en gris oscuro', '/alfombras/Alfombra Gris Oscuro.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Gris Pardo', 'Alfombra cálida en tono gris pardo', '/alfombras/Alfombra Gris Pardo.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Marrón Oscuro', 'Alfombra elegante en marrón oscuro', '/alfombras/Alfombra Marrón Oscuro.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Marrón Rojizo', 'Alfombra con tono marrón rojizo único', '/alfombras/Alfombra Marrón Rojizo.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Marrón Suave', 'Alfombra suave en marrón delicado', '/alfombras/Alfombra Marrón Suave.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Rojo Ladrillo', 'Alfombra vibrante en rojo ladrillo', '/alfombras/Alfombra Rojo Ladrillo.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Rojo Oscuro', 'Alfombra clásica en rojo oscuro', '/alfombras/Alfombra Rojo Oscuro.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Rosa Pálido', 'Alfombra delicada en rosa pálido', '/alfombras/Alfombra Rosa Pálido.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Verde Azulado', 'Alfombra fresca en verde azulado', '/alfombras/Alfombra Verde Azulado.png', (SELECT id FROM public.categories WHERE name = 'Alfombras')),
('Alfombra Verde Oscuro', 'Alfombra elegante en verde oscuro', '/alfombras/Alfombra Verde Oscuro.png', (SELECT id FROM public.categories WHERE name = 'Alfombras'));
