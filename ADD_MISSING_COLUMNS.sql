-- 🔍 VERIFICAR ESTRUCTURA DE LA TABLA GALLERY_PHOTOS
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'gallery_photos'
ORDER BY ordinal_position;

-- ➕ AGREGAR COLUMNA set_name SI NO EXISTE
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'gallery_photos' AND column_name = 'set_name'
    ) THEN
        ALTER TABLE gallery_photos ADD COLUMN set_name TEXT;
        RAISE NOTICE 'Columna set_name agregada exitosamente';
    ELSE
        RAISE NOTICE 'Columna set_name ya existe';
    END IF;
END $$;

-- ➕ AGREGAR COLUMNA display_order SI NO EXISTE
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'gallery_photos' AND column_name = 'display_order'
    ) THEN
        ALTER TABLE gallery_photos ADD COLUMN display_order INTEGER DEFAULT 0;
        RAISE NOTICE 'Columna display_order agregada exitosamente';
    ELSE
        RAISE NOTICE 'Columna display_order ya existe';
    END IF;
END $$;

-- 🔄 ACTUALIZAR REGISTROS EXISTENTES PARA SET_NAME
UPDATE gallery_photos
SET set_name = COALESCE(
    NULLIF(regexp_replace(title, ' \d+$', ''), ''),
    title
)
WHERE set_name IS NULL;

-- 🔄 ACTUALIZAR REGISTROS EXISTENTES PARA DISPLAY_ORDER
UPDATE gallery_photos
SET display_order = COALESCE(
    NULLIF(regexp_replace(title, '^.* ', ''), title)::INTEGER,
    0
)
WHERE display_order IS NULL;
