-- Habilitar RLS en todas las tablas necesarias
DO $$
DECLARE
    t text;
    tablas_importantes TEXT[] := ARRAY[
        'gallery_photos', 
        'promo_banner', 
        'carpets_items', 
        'curtains_items', 
        'furniture_items', 
        'monthly_updates'
    ];
BEGIN
    -- Verificar y habilitar RLS en cada tabla
    FOREACH t IN ARRAY tablas_importantes LOOP
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = t) THEN
            EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY;', t);
            RAISE NOTICE 'RLS habilitado en la tabla: %', t;
            
            -- Crear política de solo lectura para usuarios anónimos
            EXECUTE format('DROP POLICY IF EXISTS "Permitir lectura pública" ON public.%I;', t);
            EXECUTE format('CREATE POLICY "Permitir lectura pública" ON public.%I FOR SELECT TO public USING (is_active = true);', t);
            RAISE NOTICE 'Política de lectura creada en: %', t;
        ELSE
            RAISE NOTICE 'La tabla % no existe, omitiendo...', t;
        END IF;
    END LOOP;
END $$;

-- Verificar las políticas existentes
SELECT 
    tablename, 
    policyname, 
    cmd, 
    roles,
    qual,
    with_check
FROM pg_policies 
WHERE tablename IN (
    'gallery_photos', 
    'promo_banner', 
    'carpets_items', 
    'curtains_items', 
    'furniture_items', 
    'monthly_updates'
)
ORDER BY tablename, policyname;

-- Verificar si el bucket de almacenamiento existe y su configuración
SELECT * FROM storage.buckets;

-- Verificar las políticas de los buckets
SELECT * FROM storage.objects LIMIT 5;

-- Crear políticas para los buckets de almacenamiento si no existen
DO $$
BEGIN
    -- Política para permitir la lectura pública de los buckets
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'objects' 
        AND schemaname = 'storage'
        AND policyname = 'Permitir lectura pública de objetos'
    ) THEN
        CREATE POLICY "Permitir lectura pública de objetos" 
        ON storage.objects 
        FOR SELECT 
        TO public 
        USING (bucket_id IN ('gallery', 'promo', 'carpets', 'curtains', 'furniture', 'monthly'));
        
        RAISE NOTICE 'Política de lectura para storage.objects creada';
    ELSE
        RAISE NOTICE 'La política para storage.objects ya existe';
    END IF;
END $$;
