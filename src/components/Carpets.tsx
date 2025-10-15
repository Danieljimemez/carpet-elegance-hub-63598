import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Sparkles } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

// Debug temporal
const debugQuery = useQuery({
  queryKey: ['debug-carpets'],
  queryFn: async () => {
    console.log('🔍 Ejecutando consulta de carpets...');
    const { data, error } = await (supabase as any)
      .from('carpets_items')
      .select('*')
      .eq('is_active', true);

    console.log('📊 Resultado carpets:', { data, error, count: data?.length });
    if (error) console.error('❌ Error carpets:', error);

    return data;
  },
  enabled: true
});

// Test simple de conexión
console.log('🐛 COMPONENTE CARPETS CARGADO - Debug query:', debugQuery.data);

// Esta sección muestra las alfombras desde la base de datos
// Las imágenes se pueden gestionar desde Supabase

interface CarpetItem {
  id: string;
  name: string;
  description: string | null;
  image_url: string;
  size: string | null;
  price: string | null;
  display_order: number;
  is_active: boolean;
}

const Carpets = () => {
  const { data: carpets, isLoading } = useQuery({
    queryKey: ["carpets"],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from("carpets_items")
        .select("*")
        .eq("is_active", true)
        .order("display_order", { ascending: false });

      if (error) throw error;
      return data as CarpetItem[];
    },
  });

  return (
    <section className="py-16 sm:py-20 lg:py-32 bg-gradient-to-br from-amber-50 to-orange-50">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <div className="inline-flex items-center justify-center gap-2 mb-4">
            <Sparkles className="w-6 h-6 text-amber-500" />
            <Badge variant="secondary" className="text-base px-4 py-1">
              Colección Alfombras
            </Badge>
            <Sparkles className="w-6 h-6 text-amber-500" />
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Calidez en Cada Paso
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Explora nuestra selección exclusiva de alfombras que añaden confort, estilo y personalidad a tus espacios.
          </p>
        </div>

        {isLoading ? (
          <div className="text-center text-muted-foreground">Cargando colección de alfombras...</div>
        ) : carpets && carpets.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 max-w-7xl mx-auto">
            {carpets.map((item, index) => (
              <Card
                key={item.id}
                className="overflow-hidden shadow-soft hover:shadow-elevated transition-smooth animate-scale-in"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <div className="relative">
                  <img
                    src={item.image_url}
                    alt={item.name}
                    className="w-full h-64 sm:h-80 object-cover"
                    onError={(e) => {
                      console.warn(`Failed to load carpet image: ${item.image_url}`);
                      e.currentTarget.src = "/placeholder.svg";
                    }}
                  />
                  <Badge className="absolute top-4 right-4 bg-amber-500 text-white shadow-soft">
                    ¡Nuevo!
                  </Badge>
                </div>
                <CardContent className="p-6">
                  <h3 className="text-xl sm:text-2xl font-serif font-semibold text-foreground mb-2">
                    {item.name}
                  </h3>
                  <p className="text-sm sm:text-base text-muted-foreground mb-4 leading-relaxed">
                    {item.description || "Alfombra de nueva incorporación"}
                  </p>
                  <div className="flex justify-between items-center">
                    <div>
                      <p className="text-sm text-muted-foreground">Tamaño: {item.size || "Consultar"}</p>
                      {item.price && (
                        <p className="text-lg font-semibold text-amber-600 mt-1">{item.price}</p>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        ) : (
          <div className="text-center text-muted-foreground py-12">
            No hay alfombras disponibles. Actualiza la tabla carpets_items en Supabase para mostrar productos nuevos.
          </div>
        )}
      </div>
    </section>
  );
};

export default Carpets;
