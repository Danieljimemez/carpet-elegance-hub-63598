-- Update product images to use real images from /alfombras folder
UPDATE public.herramientas SET imagen_url = '/alfombras/Alfombra Azul Marino.png' WHERE nombre = 'Alfombra Moderna Azul';
UPDATE public.herramientas SET imagen_url = '/alfombras/Alfombra Rojo Ladrillo.png' WHERE nombre = 'Alfombra Persa Roja';
UPDATE public.herramientas SET imagen_url = '/alfombras/Alfombra Gris Azulado.png' WHERE nombre = 'Alfombra Minimalista Gris';
UPDATE public.herramientas SET imagen_url = '/alfombras/Alfombra Marrón Suave.png' WHERE nombre = 'Alfombra Bohemia Multicolor';
