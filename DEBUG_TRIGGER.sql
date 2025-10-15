-- DIAGNOSTIC: Deshabilitar trigger temporalmente
DROP TRIGGER IF EXISTS on_storage_update ON storage.objects;

-- Probar upload básico sin trigger
-- Si funciona, el problema está en el trigger/función
