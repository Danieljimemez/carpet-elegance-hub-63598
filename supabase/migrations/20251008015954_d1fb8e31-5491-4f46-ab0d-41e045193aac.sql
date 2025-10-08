-- Create herramientas table
CREATE TABLE public.herramientas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre TEXT NOT NULL,
  precio TEXT NOT NULL,
  descripcion TEXT,
  imagen_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- Enable RLS
ALTER TABLE public.herramientas ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Anyone can view herramientas"
ON public.herramientas
FOR SELECT
USING (true);

-- Create index for better performance
CREATE INDEX idx_herramientas_created_at ON public.herramientas(created_at DESC);