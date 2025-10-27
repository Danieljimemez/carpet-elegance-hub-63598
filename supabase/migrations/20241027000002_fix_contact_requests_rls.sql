-- Corregir políticas RLS para contact_requests
DO $$
BEGIN
    -- Verificar si la tabla existe
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'contact_requests') THEN
        -- Deshabilitar RLS temporalmente
        ALTER TABLE public.contact_requests DISABLE ROW LEVEL SECURITY;
        
        -- Eliminar políticas existentes si existen
        DROP POLICY IF EXISTS "Permitir insercion de contactos" ON public.contact_requests;
        DROP POLICY IF EXISTS "Permitir lectura a administradores" ON public.contact_requests;
        
        -- Habilitar RLS
        ALTER TABLE public.contact_requests ENABLE ROW LEVEL SECURITY;
        
        -- Crear política para permitir inserción a usuarios anónimos
        CREATE POLICY "Permitir insercion de contactos" 
        ON public.contact_requests 
        FOR INSERT 
        TO anon, authenticated, service_role
        WITH CHECK (true);
        
        -- Crear política para permitir lectura a administradores
        CREATE POLICY "Permitir lectura a administradores" 
        ON public.contact_requests 
        FOR SELECT 
        TO authenticated, service_role
        USING (true);
        
        RAISE NOTICE 'Políticas de RLS actualizadas para contact_requests';
    END IF;
END $$;
