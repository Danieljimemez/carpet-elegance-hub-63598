-- Corregir políticas RLS para testimonials
DO $$
BEGIN
    -- Verificar si la tabla existe
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'testimonials') THEN
        -- Deshabilitar RLS temporalmente
        ALTER TABLE public.testimonials DISABLE ROW LEVEL SECURITY;
        
        -- Eliminar políticas existentes si existen
        DROP POLICY IF EXISTS "Permitir insercion de testimonios" ON public.testimonials;
        DROP POLICY IF EXISTS "Permitir lectura de testimonios aprobados" ON public.testimonials;
        
        -- Habilitar RLS
        ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;
        
        -- Crear política para permitir inserción de testimonios
        CREATE POLICY "Permitir insercion de testimonios" 
        ON public.testimonials 
        FOR INSERT 
        TO anon, authenticated, service_role
        WITH CHECK (true);
        
        -- Crear política para permitir lectura de testimonios aprobados
        CREATE POLICY "Permitir lectura de testimonios aprobados" 
        ON public.testimonials 
        FOR SELECT 
        TO anon, authenticated, service_role
        USING (is_approved = true);
        
        -- Crear política para permitir a los administradores ver todos los testimonios
        CREATE POLICY "Permitir a administradores ver todos los testimonios" 
        ON public.testimonials 
        FOR SELECT 
        TO authenticated, service_role
        USING (true);
        
        RAISE NOTICE 'Políticas de RLS actualizadas para testimonials';
    END IF;
END $$;
