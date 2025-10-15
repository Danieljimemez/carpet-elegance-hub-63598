-- 🎯 CREAR TABLAS PARA TESTIMONIOS Y CONTACTOS

-- Verificar tablas existentes
SELECT 'TABLAS EXISTENTES:' as info;
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('contacts', 'testimonials');

-- Crear tabla testimonials si no existe
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

-- Crear tabla contacts si no existe
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

-- Políticas RLS para testimonials
DROP POLICY IF EXISTS "Enable read access for testimonials" ON testimonials;
DROP POLICY IF EXISTS "Enable insert for testimonials" ON testimonials;
DROP POLICY IF EXISTS "Enable update for testimonials" ON testimonials;

CREATE POLICY "Enable read access for testimonials" ON testimonials
    FOR SELECT USING (is_approved = true);

CREATE POLICY "Enable insert for testimonials" ON testimonials
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Enable update for testimonials" ON testimonials
    FOR UPDATE USING (true);

-- Políticas RLS para contacts
DROP POLICY IF EXISTS "Enable read access for contacts" ON contacts;
DROP POLICY IF EXISTS "Enable insert for contacts" ON contacts;
DROP POLICY IF EXISTS "Enable update for contacts" ON contacts;

CREATE POLICY "Enable read access for contacts" ON contacts
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for contacts" ON contacts
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Enable update for contacts" ON contacts
    FOR UPDATE USING (true);

-- Insertar algunos testimonials de ejemplo ya aprobados
INSERT INTO testimonials (nombre, rol, comentario, calificacion, is_approved) VALUES
('María González', 'Cliente Residencial', 'Excelente calidad en las alfombras. El servicio fue impecable y la entrega puntual.', 5, true),
('Carlos Rodríguez', 'Cliente Empresarial', 'Perfectos para nuestra oficina. Cómodos, elegantes y duraderos.', 5, true),
('Ana López', 'Decoradora de Interiores', 'Gran variedad y calidad superior. Mis clientes quedan siempre satisfechos.', 5, true)
ON CONFLICT DO NOTHING;

-- Verificar estructura final
SELECT 'ESTRUCTURA TESTIMONIALS:' as tabla;
SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_name = 'testimonials' ORDER BY ordinal_position;

SELECT 'ESTRUCTURA CONTACTS:' as tabla;
SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_name = 'contacts' ORDER BY ordinal_position;

-- Verificar datos iniciales
SELECT 'TESTIMONIALS APROBADOS:' as info, COUNT(*) as cantidad FROM testimonials WHERE is_approved = true;
SELECT 'CONTACTOS TOTALES:' as info, COUNT(*) as cantidad FROM contacts;
