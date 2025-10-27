-- ===========================================
-- SOLUCIÓN SIMPLIFICADA PARA BUCKET 'promo'
-- ===========================================

-- 1. Eliminar todas las políticas del bucket 'promo'
DELETE FROM storage.objects WHERE bucket_id = 'promo';

-- 2. Eliminar políticas existentes para el bucket 'promo'
DO $$
BEGIN
    -- Eliminar políticas específicas del bucket 'promo'
    IF EXISTS (
        SELECT 1 
        FROM pg_policies 
        WHERE tablename = 'objects' 
        AND schemaname = 'storage'
        AND (policyname LIKE '%promo%' OR qual::text LIKE '%promo%')
    ) THEN
        EXECUTE (
            SELECT string_agg('DROP POLICY IF EXISTS "' || policyname || '" ON storage.objects;', ' ')
            FROM pg_policies 
            WHERE tablename = 'objects' 
            AND schemaname = 'storage'
            AND (policyname LIKE '%promo%' OR qual::text LIKE '%promo%')
        );
    END IF;
END $$;

-- 3. Crear el bucket 'promo' si no existe (sin políticas adicionales)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
SELECT 
    'promo', 
    'promo', 
    true, 
    52428800, -- 50MB
    ARRAY['image/jpeg', 'image/png', 'image/webp']
WHERE NOT EXISTS (
    SELECT 1 FROM storage.buckets WHERE name = 'promo'
);

-- 4. Asegurarse de que no hay políticas que restrinjan el bucket 'promo'
-- Esto es importante: no crearemos políticas adicionales para que funcione como los otros buckets

-- 5. Verificación final
SELECT '✅ CONFIGURACIÓN COMPLETADA' as status;

-- Mostrar configuración del bucket
SELECT '📦 CONFIGURACIÓN DEL BUCKET "promo":' as info;
SELECT * FROM storage.buckets WHERE name = 'promo';

-- Mostrar políticas de almacenamiento (debería estar vacío para 'promo')
SELECT '🔐 POLÍTICAS DE ALMACENAMIENTO:' as info;
SELECT * FROM pg_policies 
WHERE schemaname = 'storage' 
AND tablename = 'objects'
AND (policyname LIKE '%promo%' OR qual::text LIKE '%promo%');
