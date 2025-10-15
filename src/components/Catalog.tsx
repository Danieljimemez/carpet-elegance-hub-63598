import ProductCard from "./ProductCard";
import { toast } from "sonner";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { useState } from "react";

interface FurnitureItem {
  id: string;
  name: string;
  description: string | null;
  image_url: string;
  category: string | null;
  display_order: number;
  is_active: boolean;
}

interface CurtainItem {
  id: string;
  name: string;
  description: string | null;
  image_url: string;
  size: string | null;
  price: string | null;
  display_order: number;
  is_active: boolean;
}

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

const Catalog = () => {
  const [activeTab, setActiveTab] = useState("alfombras");

  const { data: muebles, isLoading: mueblesLoading } = useQuery({
    queryKey: ['furniture-items'],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from('furniture_items')
        .select('*')
        .eq('is_active', true)
        .order('display_order', { ascending: false });

      if (error) throw error;
      return data as FurnitureItem[];
    },
  });

  const { data: cortinas, isLoading: cortinasLoading } = useQuery({
    queryKey: ['curtains-items'],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from('curtains_items')
        .select('*')
        .eq('is_active', true)
        .order('display_order', { ascending: false });

      if (error) throw error;
      return data as CurtainItem[];
    },
  });

  const { data: alfombras, isLoading: alfombrasLoading } = useQuery({
    queryKey: ['carpets-items'],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from('carpets_items')
        .select('*')
        .eq('is_active', true)
        .order('display_order', { ascending: false });

      if (error) throw error;
      return data as CarpetItem[];
    },
  });

  const handleViewDetails = (product: FurnitureItem | CurtainItem | CarpetItem, type: 'mueble' | 'cortina' | 'alfombra') => {
    let name: string;
    let description: string;

    switch (type) {
      case 'mueble':
        name = (product as FurnitureItem).name;
        description = (product as FurnitureItem).description || "";
        break;
      case 'cortina':
        name = (product as CurtainItem).name;
        description = (product as CurtainItem).description || "";
        break;
      case 'alfombra':
        name = (product as CarpetItem).name;
        description = (product as CarpetItem).description || "";
        break;
      default:
        name = "Producto";
        description = "Descripción no disponible";
    }

    toast.success(`Ver detalles de ${name}`, {
      description: description || "Próximamente podrás ver más información sobre este producto.",
    });
  };

  const renderMueblesGrid = (products: FurnitureItem[]) => (
    products && products.length > 0 ? (
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 lg:gap-10">
        {products.map((product, index) => (
          <div
            key={product.id}
            className="animate-fade-in-up"
            style={{ animationDelay: `${index * 100}ms` }}
          >
            <ProductCard
              image={product.image_url}
              name={product.name}
              size={product.description || ""}
              onViewDetails={() => handleViewDetails(product, 'mueble')}
            />
          </div>
        ))}
      </div>
    ) : (
      <div className="text-center text-muted-foreground py-12">
        No hay muebles disponibles. Agrega muebles desde tu tabla furniture_items en Supabase.
      </div>
    )
  );

  const renderCortinasGrid = (products: CurtainItem[]) => (
    products && products.length > 0 ? (
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 lg:gap-10">
        {products.map((product, index) => (
          <div
            key={product.id}
            className="animate-fade-in-up"
            style={{ animationDelay: `${index * 100}ms` }}
          >
            <ProductCard
              image={product.image_url}
              name={product.name}
              size={product.size || product.description || ""}
              onViewDetails={() => handleViewDetails(product, 'cortina')}
            />
          </div>
        ))}
      </div>
    ) : (
      <div className="text-center text-muted-foreground py-12">
        No hay cortinas disponibles. Agrega cortinas desde tu tabla curtains_items en Supabase.
      </div>
    )
  );

  const renderAlfombrasGrid = (products: CarpetItem[]) => (
    products && products.length > 0 ? (
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 lg:gap-10">
        {products.map((product, index) => (
          <div
            key={product.id}
            className="animate-fade-in-up"
            style={{ animationDelay: `${index * 100}ms` }}
          >
            <ProductCard
              image={product.image_url}
              name={product.name}
              size={product.size || product.description || ""}
              onViewDetails={() => handleViewDetails(product, 'alfombra')}
            />
          </div>
        ))}
      </div>
    ) : (
      <div className="text-center text-muted-foreground py-12">
        No hay alfombras disponibles. Agrega alfombras desde tu tabla carpets_items en Supabase.
      </div>
    )
  );

  return (
    <section id="catalogo" className="py-16 sm:py-20 lg:py-32 bg-background">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Nuestro Catálogo
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Explora nuestra selección exclusiva de alfombras, muebles y cortinas, diseñados para transformar cualquier espacio.
          </p>
        </div>

        <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
          <TabsList className="grid w-full grid-cols-3 max-w-md mx-auto mb-12">
            <TabsTrigger value="alfombras">Alfombras</TabsTrigger>
            <TabsTrigger value="muebles">Muebles</TabsTrigger>
            <TabsTrigger value="cortinas">Cortinas</TabsTrigger>
          </TabsList>

          {false || mueblesLoading || cortinasLoading || alfombrasLoading ? (
            <div className="text-center text-muted-foreground">Cargando productos...</div>
          ) : (
            <>
              <TabsContent value="alfombras">
                {renderAlfombrasGrid(alfombras || [])}
              </TabsContent>

              <TabsContent value="muebles">
                {renderMueblesGrid(muebles || [])}
              </TabsContent>

              <TabsContent value="cortinas">
                {renderCortinasGrid(cortinas || [])}
              </TabsContent>
            </>
          )}
        </Tabs>
      </div>
    </section>
  );
};

export default Catalog;
