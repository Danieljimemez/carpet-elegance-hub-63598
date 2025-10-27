-- ===========================================
-- MIGRACIÓN: TABLA PROMO BANNER
-- ===========================================

-- 1. CREAR TABLA PROMO_BANNER
CREATE TABLE IF NOT EXISTS public.promo_banner (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT,
    description TEXT,
    image_url TEXT NOT NULL,
    alt_text TEXT,
    path TEXT UNIQUE,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. HABILITAR ROW LEVEL SECURITY
ALTER TABLE public.promo_banner ENABLE ROW LEVEL SECURITY;

-- 3. CREAR ÍNDICES
CREATE INDEX idx_promo_banner_created_at ON public.promo_banner(created_at DESC);
CREATE INDEX idx_promo_banner_is_active ON public.promo_banner(is_active);
CREATE INDEX idx_promo_banner_display_order ON public.promo_banner(display_order);

-- 4. POLÍTICAS RLS
-- Eliminar políticas existentes si existen
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'promo_banner' AND policyname = 'Enable read access for all users') THEN
        DROP POLICY "Enable read access for all users" ON public.promo_banner;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'promo_banner' AND policyname = 'Enable insert for authenticated users') THEN
        DROP POLICY "Enable insert for authenticated users" ON public.promo_banner;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'promo_banner' AND policyname = 'Enable update for authenticated users') THEN
        DROP POLICY "Enable update for authenticated users" ON public.promo_banner;
    END IF;
END $$;

-- Crear políticas
-- Permitir lectura pública
CREATE POLICY "Enable read access for all users" 
ON public.promo_banner 
FOR SELECT 
USING (true);

-- Permitir inserción solo a usuarios autenticados
CREATE POLICY "Enable insert for authenticated users" 
ON public.promo_banner 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Permitir actualización solo a usuarios autenticados
CREATE POLICY "Enable update for authenticated users" 
ON public.promo_banner 
FOR UPDATE 
TO authenticated 
USING (true);

-- 5. FUNCIÓN PARA ACTUALIZAR EL TIMESTAMP
CREATE OR REPLACE FUNCTION update_modified_column() 
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW; 
END;
$$ language 'plpgsql';

-- 6. CREAR TRIGGER PARA ACTUALIZAR TIMESTAMP
CREATE TRIGGER update_promo_banner_modtime
BEFORE UPDATE ON public.promo_banner
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- 7. VERIFICACIÓN
SELECT '✅ MIGRACIÓN COMPLETADA: TABLA PROMO_BANNER CREADA' as status;

-- Mostrar configuración de la tabla
SELECT '📋 DETALLES DE LA TABLA:' as info;
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM 
    information_schema.columns 
WHERE 
    table_schema = 'public' 
    AND table_name = 'promo_banner';

-- Mostrar políticas RLS
SELECT '🔐 POLÍTICAS RLS:' as info;
SELECT * FROM pg_policies WHERE tablename = 'promo_banner';
