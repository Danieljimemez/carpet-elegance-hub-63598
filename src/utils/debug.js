// Debug temporal para ver qué pasa con las consultas
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

// Agregar esto temporalmente en cualquier componente para debug
const debugQuery = useQuery({
  queryKey: ['debug-carpets'],
  queryFn: async () => {
    console.log('🔍 Ejecutando consulta de carpets...');
    const { data, error } = await (supabase as any)
      .from('carpets_items')
      .select('*')
      .eq('is_active', true);

    console.log('📊 Resultado:', { data, error, count: data?.length });
    if (error) console.error('❌ Error:', error);

    return data;
  },
  enabled: true // Ejecutar inmediatamente
});

console.log('🐛 Debug carpets result:', debugQuery.data);
