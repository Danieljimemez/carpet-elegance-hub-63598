-- 🎯 SETUP COMPLETO: TESTIMONIALS Y CONTACTS

-- PASO 1: Crear tablas si no existen
CREATE TABLE IF NOT EXISTS public.testimonials (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nombre TEXT NOT NULL,
    rol TEXT NOT NULL,
    comentario TEXT NOT NULL,
    calificacion INTEGER NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
    is_approved BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.contacts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    message TEXT NOT NULL,
    custom_size TEXT,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- PASO 2: Configurar políticas RLS
DROP POLICY IF EXISTS "Enable read access for testimonials" ON testimonials;
DROP POLICY IF EXISTS "Enable insert for testimonials" ON testimonials;
DROP POLICY IF EXISTS "Enable update for testimonials" ON testimonials;
DROP POLICY IF EXISTS "Enable read access for contacts" ON contacts;
DROP POLICY IF EXISTS "Enable insert for contacts" ON contacts;
DROP POLICY IF EXISTS "Enable update for contacts" ON contacts;

-- Políticas para testimonials (solo mostrar aprobados)
CREATE POLICY "Enable read access for testimonials" ON testimonials FOR SELECT USING (is_approved = true);
CREATE POLICY "Enable insert for testimonials" ON testimonials FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for testimonials" ON testimonials FOR UPDATE USING (true);

-- Políticas para contacts (acceso completo público)
CREATE POLICY "Enable read access for contacts" ON contacts FOR SELECT USING (true);
CREATE POLICY "Enable insert for contacts" ON contacts FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for contacts" ON contacts FOR UPDATE USING (true);

-- PASO 3: Insertar testimonials de ejemplo ya aprobados
INSERT INTO testimonials (nombre, rol, comentario, calificacion, is_approved) VALUES
('María González', 'Cliente Residencial', 'Excelente calidad en las alfombras. El servicio fue impecable y la entrega puntual. Recomiendo ampliamente.', 5, true),
('Carlos Rodríguez', 'Cliente Empresarial', 'Perfectos para nuestra oficina. Cómodos, elegantes y duraderos. La calidad supera las expectativas.', 5, true),
('Ana López', 'Decoradora de Interiores', 'Gran variedad y calidad superior. Mis clientes quedan siempre satisfechos con las alfombras.', 5, true),
('Roberto Martínez', 'Cliente Residencial', 'Servicio excepcional y productos de primera calidad. La atención al cliente es excelente.', 5, true)
ON CONFLICT DO NOTHING;

-- PASO 4: Verificación final
SELECT '✅ SETUP COMPLETADO' as status;
SELECT '📊 Tablas creadas:' as info,
       (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('testimonials', 'contacts')) as tablas_creadas;
SELECT '📝 Testimonials visibles:' as info, COUNT(*) as cantidad FROM testimonials WHERE is_approved = true;
SELECT '📞 Contactos configurados:' as info, COUNT(*) as cantidad FROM contacts;
SELECT '🔐 Políticas RLS:' as info, COUNT(*) as politicas FROM pg_policies WHERE tablename IN ('testimonials', 'contacts');

-- Mostrar testimonials visibles
SELECT '⭐ TESTIMONIALS DISPONIBLES:' as info;
SELECT nombre, rol, calificacion, LEFT(comentario, 60) || '...' as preview
FROM testimonials
WHERE is_approved = true
ORDER BY created_at DESC;
