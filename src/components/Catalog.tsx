import ProductCard from "./ProductCard";
import { toast } from "sonner";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

interface Herramienta {
  id: string;
  nombre: string;
  descripcion: string | null;
  imagen_url: string | null;
}

const Catalog = () => {
  const { data: herramientas, isLoading } = useQuery({
    queryKey: ['herramientas'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('herramientas')
        .select('*')
        .order('created_at', { ascending: false });
      
      if (error) throw error;
      return data as Herramienta[];
    },
  });

  const handleViewDetails = (product: Herramienta) => {
    toast.success(`Ver detalles de ${product.nombre}`, {
      description: product.descripcion || "Próximamente podrás ver más información sobre este producto.",
    });
  };

  return (
    <section id="catalogo" className="py-16 sm:py-20 lg:py-32 bg-background">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Catálogo de Alfombras
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Explora nuestra selección de alfombras exclusivas, diseñadas para transformar cualquier espacio.
          </p>
        </div>

        {isLoading ? (
          <div className="text-center text-muted-foreground">Cargando productos...</div>
        ) : herramientas && herramientas.length > 0 ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 lg:gap-10">
            {herramientas.map((product, index) => (
              <div
                key={product.id}
                className="animate-fade-in-up"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <ProductCard
                  image={product.imagen_url || "/placeholder.svg"}
                  name={product.nombre}
                  size={product.descripcion || ""}
                  onViewDetails={() => handleViewDetails(product)}
                />
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center text-muted-foreground">
            No hay productos disponibles. Agrega productos desde tu base de datos Supabase.
          </div>
        )}
      </div>
    </section>
  );
};

export default Catalog;
