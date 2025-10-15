-- 🔄 SETUP COMPLETO PARA GALERÍA AGRUPADA

-- 1. Limpiar imágenes existentes para empezar limpio
DELETE FROM gallery_photos WHERE title LIKE '%empty%';

-- 2. Aplicar trigger mejorado que agrupa automáticamente
DROP TRIGGER IF EXISTS auto_insert_trigger ON storage.objects;
CREATE TRIGGER auto_insert_trigger
  AFTER INSERT ON storage.objects
  FOR EACH ROW
  EXECUTE FUNCTION public.auto_insert_complete_trigger();

-- 3. Función de prueba para verificar funcionamiento
CREATE OR REPLACE FUNCTION test_gallery_grouping()
RETURNS TABLE(set_name TEXT, image_count BIGINT, titles TEXT) AS $$
BEGIN
  RETURN QUERY
  SELECT
    gp.set_name,
    COUNT(*) as image_count,
    STRING_AGG(gp.title, ' | ' ORDER BY gp.display_order) as titles
  FROM gallery_photos gp
  WHERE gp.is_active = true
  GROUP BY gp.set_name
  ORDER BY gp.set_name;
END;
$$ LANGUAGE plpgsql;

-- Probar función
SELECT * FROM test_gallery_grouping();
