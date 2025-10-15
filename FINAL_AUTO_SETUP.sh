# ===========================================
# SETUP COMPLETO AUTOMÁTICO - PROYECTO ACTUAL
# Ejecutar todo este script de una vez
# ===========================================

echo "=== RESET COMPLETO DEL PROYECTO ACTUAL ==="

# 1. Reset database (aplica todas las migrations limpias)
echo "Reseteando base de datos..."
npx supabase db reset --yes

# 2. Limpiar buckets existentes
echo "Eliminando buckets antiguos..."
npx supabase storage delete bucket gallery --yes 2>$null
npx supabase storage delete bucket carpets --yes 2>$null
npx supabase storage delete bucket curtains --yes 2>$null
npx supabase storage delete bucket furniture --yes 2>$null
npx supabase storage delete bucket monthly --yes 2>$null

# 3. Crear buckets nuevos marcados como públicos
echo "Creando buckets nuevos..."
npx supabase storage create bucket gallery --public
npx supabase storage create bucket carpets --public
npx supabase storage create bucket curtains --public
npx supabase storage create bucket furniture --public
npx supabase storage create bucket monthly --public

# 4. Desplegar Edge Function
echo "Desplegando Edge Function..."
npx supabase functions deploy auto-update-tables

echo ""
echo "=== SETUP COMPLETADO ==="
echo ""
echo "AHORA ejecuta el SQL de CLEAN_SETUP.sql en Supabase Dashboard > SQL Editor"
echo ""
echo "Luego prueba subir una imagen a 'carpets' desde el Dashboard"
echo "Debería aparecer automáticamente en carpets_items"
echo ""
echo "¡Si no funciona, crea los buckets MANUALMENTE desde Dashboard!"
