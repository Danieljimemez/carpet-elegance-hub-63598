import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Sparkles, Eye } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
} from "@/components/ui/dialog";

// Esta sección muestra las cortinas desde la base de datos
// Las imágenes se pueden gestionar desde Supabase

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

const Curtains = () => {
  const { data: curtainsItems, isLoading } = useQuery({
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

  // State for image preview modal
  const [previewModal, setPreviewModal] = useState<{
    isOpen: boolean;
    currentItem: CurtainItem | null;
  }>({
    isOpen: false,
    currentItem: null,
  });

  // Function to open preview modal
  const openPreview = (item: CurtainItem) => {
    setPreviewModal({
      isOpen: true,
      currentItem: item,
    });
  };

  // Function to close preview modal
  const closePreview = () => {
    setPreviewModal({
      isOpen: false,
      currentItem: null,
    });
  };

  return (
    <section className="py-16 sm:py-20 lg:py-32 bg-gradient-to-br from-rose-50 to-pink-50">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <div className="inline-flex items-center justify-center gap-2 mb-4">
            <Sparkles className="w-6 h-6 text-rose-500" />
            <Badge variant="secondary" className="text-base px-4 py-1">
              Colección Cortinas
            </Badge>
            <Sparkles className="w-6 h-6 text-rose-500" />
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Elegancia en Cada Pliegue
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Descubre nuestra colección de cortinas que combinan funcionalidad, estilo y sofisticación para transformar tus espacios.
          </p>
        </div>

        {isLoading ? (
          <div className="text-center text-muted-foreground">Cargando colección de cortinas...</div>
        ) : curtainsItems && curtainsItems.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 max-w-7xl mx-auto">
            {curtainsItems.map((item, index) => (
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
                      console.warn(`Failed to load curtain image: ${item.image_url}`);
                      e.currentTarget.src = "/placeholder.svg";
                    }}
                  />
                  <Badge className="absolute top-4 right-4 bg-rose-500 text-white shadow-soft">
                    ¡Nuevo!
                  </Badge>
                </div>
                <CardContent className="p-6">
                  <h3 className="text-xl sm:text-2xl font-serif font-semibold text-foreground mb-2">
                    {item.name}
                  </h3>
                  <p className="text-sm sm:text-base text-muted-foreground mb-4 leading-relaxed">
                    {item.description || "Cortina de nueva incorporación"}
                  </p>
                  <div className="flex justify-between items-center">
                    <div>
                      <p className="text-sm text-muted-foreground">Tamaño: {item.size || "Consultar"}</p>
                      {item.price && (
                        <p className="text-lg font-semibold text-rose-600 mt-1">{item.price}</p>
                      )}
                    </div>
                    <Button
                      onClick={() => openPreview(item)}
                      variant="outline"
                      size="sm"
                      className="flex items-center gap-2 hover:bg-rose-50 hover:border-rose-300"
                    >
                      <Eye className="w-4 h-4" />
                      Vista Previa
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        ) : (
          <div className="text-center text-muted-foreground py-12">
            No hay cortinas disponibles. Actualiza la tabla curtains_items en Supabase para mostrar productos nuevos.
          </div>
        )}

        {/* Image Preview Modal */}
        <Dialog open={previewModal.isOpen} onOpenChange={(open) => !open && closePreview()}>
          <DialogContent className="max-w-4xl w-full p-0 bg-black/95">
            {previewModal.currentItem && (
              <div className="relative">
                {/* Close button */}
                <button
                  onClick={closePreview}
                  className="absolute top-4 right-4 z-50 w-10 h-10 bg-black/50 rounded-full flex items-center justify-center hover:bg-black/70 transition-colors text-white"
                >
                  <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>

                {/* Main image */}
                <div className="relative aspect-[4/3] bg-black">
                  <img
                    src={previewModal.currentItem.image_url}
                    alt={previewModal.currentItem.name}
                    className="w-full h-full object-contain"
                  />
                </div>

                {/* Product info */}
                <div className="bg-black/70 text-white p-6">
                  <div className="max-w-2xl mx-auto">
                    <h2 className="text-2xl font-serif font-bold mb-2">{previewModal.currentItem.name}</h2>
                    <p className="text-gray-300 mb-4 leading-relaxed">
                      {previewModal.currentItem.description || "Cortina de nueva incorporación"}
                    </p>
                    <div className="flex flex-wrap gap-4 text-sm">
                      <div className="bg-white/10 px-3 py-1 rounded-full">
                        <span className="font-medium">Tamaño:</span> {previewModal.currentItem.size || "Consultar"}
                      </div>
                      {previewModal.currentItem.price && (
                        <div className="bg-rose-500/20 px-3 py-1 rounded-full">
                          <span className="font-medium">Precio:</span> {previewModal.currentItem.price}
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            )}
          </DialogContent>
        </Dialog>
      </div>
    </section>
  );
};

export default Curtains;
