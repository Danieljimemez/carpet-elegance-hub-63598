-- Verificar estado actual
SELECT 'BUCKETS:' as info, name, public FROM storage.buckets ORDER BY name;

SELECT 'POLÍTICAS:' as info, COUNT(*) as count FROM pg_policies WHERE schemaname = 'storage' AND tablename = 'objects';

SELECT 'TRIGGER:' as info, COUNT(*) as count FROM pg_trigger WHERE tgname = 'on_storage_update';
