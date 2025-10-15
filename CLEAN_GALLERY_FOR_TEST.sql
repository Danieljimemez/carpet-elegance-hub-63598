-- Limpiar gallery existente para pruebas
DELETE FROM gallery_photos WHERE title LIKE '%empty%';

-- Ver estado actual después de limpieza
SELECT COUNT(*) as gallery_images_after_clean FROM gallery_photos WHERE is_active = true;
