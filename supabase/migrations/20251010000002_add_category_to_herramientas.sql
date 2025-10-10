-- Add category_id to herramientas table
ALTER TABLE public.herramientas ADD COLUMN category_id UUID REFERENCES public.categories(id);

-- Create index for category_id
CREATE INDEX idx_herramientas_category_id ON public.herramientas(category_id);
