-- Create testimonios table
CREATE TABLE public.testimonios (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL,
  rol TEXT NOT NULL,
  comentario TEXT NOT NULL,
  calificacion INTEGER NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- Enable RLS
ALTER TABLE public.testimonios ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Anyone can view testimonios"
ON public.testimonios
FOR SELECT
USING (true);

-- Create policy for public insert
CREATE POLICY "Anyone can insert testimonios"
ON public.testimonios
FOR INSERT
WITH CHECK (true);

-- Create index for better performance
CREATE INDEX idx_testimonios_created_at ON public.testimonios(created_at DESC);