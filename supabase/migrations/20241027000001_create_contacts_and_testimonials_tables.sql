-- Crear la tabla de contactos
CREATE TABLE IF NOT EXISTS public.contact_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    subject TEXT NOT NULL,
    message TEXT NOT NULL,
    status TEXT DEFAULT 'new',
    custom_size TEXT
);

-- Crear la tabla de testimonios
CREATE TABLE IF NOT EXISTS public.testimonials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    nombre TEXT NOT NULL,
    rol TEXT,
    comentario TEXT NOT NULL,
    calificacion INTEGER NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
    is_approved BOOLEAN DEFAULT FALSE,
    status TEXT DEFAULT 'pending',
    email TEXT
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_contacts_email ON public.contact_requests(email);
CREATE INDEX IF NOT EXISTS idx_contacts_status ON public.contact_requests(status);
CREATE INDEX IF NOT EXISTS idx_testimonials_is_approved ON public.testimonials(is_approved);
CREATE INDEX IF NOT EXISTS idx_testimonials_status ON public.testimonials(status);

-- Comentarios para documentación
COMMENT ON TABLE public.contact_requests IS 'Tabla para almacenar los mensajes de contacto de los usuarios';
COMMENT ON TABLE public.testimonials IS 'Tabla para almacenar los testimonios de los clientes';

-- Después de crear las tablas, ejecutar la migración de políticas RLS
-- Esto asegura que las políticas se apliquen correctamente
-- \i supabase/migrations/20241027000000_add_rls_policies_contacts_testimonials.sql
