-- 🧪 VERIFICACIÓN COMPLETA DE TESTIMONIALS Y CONTACTS

-- Verificar estructura de tablas
SELECT '📊 ESTRUCTURA DE TABLAS:' as info;
SELECT table_name, table_type FROM information_schema.tables
WHERE table_schema = 'public' AND table_name IN ('testimonials', 'contacts');

-- Verificar columnas de testimonials
SELECT '📝 COLUMNAS TESTIMONIALS:' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'testimonials'
ORDER BY ordinal_position;

-- Verificar columnas de contacts
SELECT '📞 COLUMNAS CONTACTS:' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'contacts'
ORDER BY ordinal_position;

-- Verificar políticas RLS
SELECT '🔐 POLÍTICAS RLS:' as info;
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename IN ('testimonials', 'contacts')
ORDER BY tablename, policyname;

-- Verificar datos existentes
SELECT '✅ TESTIMONIALS APROBADOS:' as info, COUNT(*) as cantidad FROM testimonials WHERE is_approved = true;
SELECT '📝 TESTIMONIALS PENDIENTES:' as info, COUNT(*) as cantidad FROM testimonials WHERE is_approved = false;
SELECT '📞 CONTACTOS TOTALES:' as info, COUNT(*) as cantidad FROM contacts;

-- Ver testimonials de ejemplo
SELECT '⭐ TESTIMONIALS VISIBLES:' as info;
SELECT nombre, rol, calificacion, LEFT(comentario, 50) || '...' as comentario_preview, is_approved
FROM testimonials
WHERE is_approved = true
ORDER BY created_at DESC
LIMIT 3;

-- Probar inserción de testimonial de prueba
INSERT INTO testimonials (nombre, rol, comentario, calificacion, is_approved)
VALUES ('Usuario de Prueba', 'Cliente de Prueba', 'Este es un testimonial de prueba para verificar que funciona.', 4, true)
ON CONFLICT DO NOTHING;

-- Verificar inserción
SELECT '🧪 TESTIMONIAL PRUEBA INSERTADO:' as info,
       COUNT(*) as total_testimonials_despues
FROM testimonials;
