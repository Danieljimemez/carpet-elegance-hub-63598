import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Sparkles } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

// Esta sección muestra las incorporaciones mensuales desde la base de datos
// Los productos se pueden actualizar mensualmente desde Supabase

interface MonthlyProduct {
  id: string;
  name: string;
  description: string | null;
  image_url: string;
  size: string | null;
  price: string | null;
  display_order: number;
  is_active: boolean;
}

const MonthlyUpdates = () => {
  const { data: monthlyProducts, isLoading } = useQuery({
    queryKey: ['monthly-updates'],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from('monthly_updates')
        .select('*')
        .eq('is_active', true)
        .order('display_order', { ascending: false });

      if (error) throw error;
      return data as MonthlyProduct[];
    },
  });

  return (
    <section className="py-16 sm:py-20 lg:py-32 hero-gradient">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <div className="inline-flex items-center justify-center gap-2 mb-4">
            <Sparkles className="w-6 h-6 text-primary" />
            <Badge variant="secondary" className="text-base px-4 py-1">
              Actualización Mensual
            </Badge>
            <Sparkles className="w-6 h-6 text-primary" />
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Nuevas Incorporaciones
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Descubre las últimas alfombras que hemos añadido a nuestra colección este mes
          </p>
        </div>

        {isLoading ? (
          <div className="text-center text-muted-foreground">Cargando incorporaciones mensuales...</div>
        ) : monthlyProducts && monthlyProducts.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 sm:gap-8 max-w-5xl mx-auto">
            {monthlyProducts.map((product, index) => (
              <Card
                key={product.id}
                className="overflow-hidden shadow-soft hover:shadow-elevated transition-smooth animate-scale-in"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <div className="relative">
                  <img
                    src={product.image_url}
                    alt={product.name}
                    className="w-full h-64 sm:h-80 object-cover"
                    onError={(e) => {
                      console.warn(`Failed to load monthly product image: ${product.image_url}`);
                      e.currentTarget.src = "/placeholder.svg";
                    }}
                  />
                  <Badge className="absolute top-4 right-4 bg-primary text-primary-foreground shadow-soft">
                    ¡Nuevo!
                  </Badge>
                </div>
                <CardContent className="p-6">
                  <h3 className="text-xl sm:text-2xl font-serif font-semibold text-foreground mb-2">
                    {product.name}
                  </h3>
                  <p className="text-sm sm:text-base text-muted-foreground mb-4 leading-relaxed">
                    {product.description || "Producto de nueva incorporación"}
                  </p>
                  <div className="flex justify-between items-center">
                    <div>
                      <p className="text-sm text-muted-foreground">Tamaño: {product.size || "Consultar"}</p>
                      {product.price && (
                        <p className="text-lg font-semibold text-primary mt-1">{product.price}</p>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        ) : (
          <div className="text-center text-muted-foreground py-12">
            No hay incorporaciones mensuales disponibles. Actualiza la tabla monthly_updates en Supabase para mostrar productos nuevos.
          </div>
        )}
      </div>
    </section>
  );
};

export default MonthlyUpdates;
