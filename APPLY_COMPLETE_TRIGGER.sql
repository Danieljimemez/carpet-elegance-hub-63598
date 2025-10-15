-- Verificar trigger actual
SELECT 
  event_object_table,
  trigger_name,
  event_manipulation,
  action_timing,
  action_statement
FROM information_schema.triggers
WHERE event_object_table = 'storage.objects'
AND trigger_name = 'auto_insert_trigger';

-- Aplicar el trigger completo mejorado
\i COMPLETE_TRIGGER.sql
