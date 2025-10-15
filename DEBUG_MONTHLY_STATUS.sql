-- Verificar estado exacto de monthly_updates
SELECT id, title, is_active, created_at FROM monthly_updates ORDER BY created_at DESC;

-- Verificar si hay productos con is_active = false
SELECT 'STATUS CHECK' as check_type,
  COUNT(*) as total_products,
  SUM(CASE WHEN is_active = true THEN 1 ELSE 0 END) as active_products,
  SUM(CASE WHEN is_active = false THEN 1 ELSE 0 END) as inactive_products
FROM monthly_updates;
