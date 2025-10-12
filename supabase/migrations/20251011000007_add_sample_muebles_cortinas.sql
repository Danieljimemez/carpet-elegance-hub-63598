-- Add sample furniture products
INSERT INTO public.herramientas (nombre, descripcion, imagen_url, category_id) VALUES
('Silla Moderna', 'Silla ergonómica con diseño contemporáneo', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Muebles')),
('Mesa de Comedor', 'Mesa extensible para 6-8 personas', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Muebles')),
('Sofá Minimalista', 'Sofá de 3 plazas en tela gris', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Muebles'));

-- Add sample curtain products
INSERT INTO public.herramientas (nombre, descripcion, imagen_url, category_id) VALUES
('Cortinas Living Room', 'Cortinas blackout para sala de estar', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Cortinas')),
('Cortinas Bedroom', 'Cortinas opacas para dormitorio', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Cortinas')),
('Cortinas Kitchen', 'Cortinas ligeras para cocina', '/placeholder.svg', (SELECT id FROM public.categories WHERE name = 'Cortinas'));
