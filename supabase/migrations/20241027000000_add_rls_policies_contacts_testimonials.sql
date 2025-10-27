-- Habilitar RLS en las tablas de contactos y testimonios
DO $$
BEGIN
    -- Habilitar RLS en contact_requests
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'contact_requests') THEN
        -- Habilitar RLS
        ALTER TABLE public.contact_requests ENABLE ROW LEVEL SECURITY;
        
        -- Crear política para permitir inserción a usuarios anónimos
        DROP POLICY IF EXISTS "Permitir insercion de contactos" ON public.contact_requests;
        CREATE POLICY "Permitir insercion de contactos" 
        ON public.contact_requests 
        FOR INSERT 
        TO public 
        WITH CHECK (true);
        
        -- Crear política para permitir lectura a administradores
        DROP POLICY IF EXISTS "Permitir lectura a administradores" ON public.contact_requests;
        CREATE POLICY "Permitir lectura a administradores" 
        ON public.contact_requests 
        FOR SELECT 
        TO authenticated 
        USING (true);
        
        RAISE NOTICE 'Políticas de RLS configuradas para contact_requests';
    END IF;
    
    -- Habilitar RLS en testimonials
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'testimonials') THEN
        -- Habilitar RLS
        ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;
        
        -- Crear política para permitir inserción a usuarios anónimos
        DROP POLICY IF EXISTS "Permitir insercion de testimonios" ON public.testimonials;
        CREATE POLICY "Permitir insercion de testimonios" 
        ON public.testimonials 
        FOR INSERT 
        TO public 
        WITH CHECK (true);
        
        -- Crear política para permitir lectura de testimonios aprobados a todos
        DROP POLICY IF EXISTS "Permitir lectura de testimonios aprobados" ON public.testimonials;
        CREATE POLICY "Permitir lectura de testimonios aprobados" 
        ON public.testimonials 
        FOR SELECT 
        TO public 
        USING (is_approved = true);
        
        -- Crear política para permitir lectura/escritura a administradores
        DROP POLICY IF EXISTS "Permitir todo a administradores" ON public.testimonials;
        CREATE POLICY "Permitir todo a administradores" 
        ON public.testimonials 
        FOR ALL 
        TO authenticated 
        USING (true) 
        WITH CHECK (true);
        
        RAISE NOTICE 'Políticas de RLS configuradas para testimonials';
    END IF;
END $$;

-- Verificar las políticas creadas
SELECT 
    tablename, 
    policyname, 
    cmd, 
    roles,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN ('contact_requests', 'testimonials')
ORDER BY tablename, policyname;
