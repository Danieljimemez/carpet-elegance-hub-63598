-- 🔧 AGREGAR TODAS LAS COLUMNAS FALTANTES DE UNA VEZ

-- Verificar qué columnas faltan
SELECT 'COLUMNAS EXISTENTES:' as info;
SELECT column_name FROM information_schema.columns WHERE table_name = 'gallery_photos' ORDER BY column_name;

-- Agregar columnas faltantes
DO $$
BEGIN
    -- set_name
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'gallery_photos' AND column_name = 'set_name') THEN
        ALTER TABLE gallery_photos ADD COLUMN set_name TEXT;
        RAISE NOTICE '✅ Agregada columna: set_name';
    END IF;

    -- display_order
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'gallery_photos' AND column_name = 'display_order') THEN
        ALTER TABLE gallery_photos ADD COLUMN display_order INTEGER DEFAULT 0;
        RAISE NOTICE '✅ Agregada columna: display_order';
    END IF;

    -- alt_text
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'gallery_photos' AND column_name = 'alt_text') THEN
        ALTER TABLE gallery_photos ADD COLUMN alt_text TEXT;
        RAISE NOTICE '✅ Agregada columna: alt_text';
    END IF;

    RAISE NOTICE '🎯 Todas las columnas necesarias están presentes';
END $$;

-- Actualizar registros existentes con valores por defecto
UPDATE gallery_photos SET
    set_name = COALESCE(set_name, COALESCE(NULLIF(regexp_replace(title, ' \d+$', ''), ''), title)),
    display_order = COALESCE(display_order, COALESCE(NULLIF(regexp_replace(title, '^.* ', ''), title)::INTEGER, 0)),
    alt_text = COALESCE(alt_text, title || ' - imagen de galería');

-- Verificar que todo esté correcto
SELECT '✅ VERIFICACIÓN FINAL' as status,
       COUNT(*) as total_registros,
       COUNT(DISTINCT set_name) as conjuntos_unicos,
       STRING_AGG(DISTINCT set_name, ', ') as nombres_conjuntos
FROM gallery_photos WHERE is_active = true;
