-- ===========================================
-- MIGRATION LIMPIA: TABLAS DEL CATÁLOGO
-- ===========================================

-- 1. TABLA PARA GALLERY PHOTOS
CREATE TABLE IF NOT EXISTS public.gallery_photos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT,
    description TEXT,
    image_url TEXT NOT NULL,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. TABLA PARA CARPETS ITEMS
CREATE TABLE IF NOT EXISTS public.carpets_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT NOT NULL,
    size TEXT,
    price TEXT,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. TABLA PARA CURTAINS ITEMS
CREATE TABLE IF NOT EXISTS public.curtains_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT NOT NULL,
    size TEXT,
    price TEXT,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. TABLA PARA FURNITURE ITEMS
CREATE TABLE IF NOT EXISTS public.furniture_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT NOT NULL,
    category TEXT,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. TABLA PARA MONTHLY UPDATES
CREATE TABLE IF NOT EXISTS public.monthly_updates (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    image_url TEXT NOT NULL,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. HABILITAR RLS EN TODAS LAS TABLAS
ALTER TABLE public.gallery_photos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.carpets_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.curtains_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.furniture_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.monthly_updates ENABLE ROW LEVEL SECURITY;

-- 7. POLÍTICAS RLS PARA LECTURA PÚBLICA
CREATE POLICY "Enable read access for all users" ON public.gallery_photos FOR SELECT USING (true);
CREATE POLICY "Enable read access for all users" ON public.carpets_items FOR SELECT USING (true);
CREATE POLICY "Enable read access for all users" ON public.curtains_items FOR SELECT USING (true);
CREATE POLICY "Enable read access for all users" ON public.furniture_items FOR SELECT USING (true);
CREATE POLICY "Enable read access for all users" ON public.monthly_updates FOR SELECT USING (true);

-- 8. ÍNDICES PARA MEJOR PERFORMANCE
CREATE INDEX idx_gallery_photos_created_at ON public.gallery_photos(created_at DESC);
CREATE INDEX idx_carpets_items_created_at ON public.carpets_items(created_at DESC);
CREATE INDEX idx_curtains_items_created_at ON public.curtains_items(created_at DESC);
CREATE INDEX idx_furniture_items_created_at ON public.furniture_items(created_at DESC);
CREATE INDEX idx_monthly_updates_created_at ON public.monthly_updates(created_at DESC);