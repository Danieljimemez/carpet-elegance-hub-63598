import { Card, CardContent } from "@/components/ui/card";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useState } from "react";

const CarpetCarousel = () => {
  const { data: carpets, isLoading, error } = useQuery({
    queryKey: ["gallery-photos"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("gallery_photos")
        .select("*")
        .eq("is_active", true)
        .order("display_order", { ascending: true });

      if (error) throw error;
      return data;
    },
  });

  // Group carpets by set_name
  const carpetSets = carpets?.reduce((acc: any, carpet: any) => {
    if (!acc[carpet.set_name]) {
      acc[carpet.set_name] = [];
    }
    acc[carpet.set_name].push(carpet);
    return acc;
  }, {}) || {};

  return (
    <section id="galeria" className="py-16 sm:py-20 lg:py-32 bg-muted/30">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Nuestra Colección Completa
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Explora todas nuestras alfombras disponibles, cada una con diseños únicos y colores exclusivos.
            Pasa el mouse sobre las imágenes para ver diferentes vistas.
          </p>
        </div>

        {isLoading ? (
          <div className="text-center py-16">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
            <p className="text-muted-foreground mt-4">Cargando galería...</p>
          </div>
        ) : error ? (
          <div className="text-center py-16">
            <p className="text-muted-foreground">Error al cargar la galería</p>
          </div>
        ) : Object.keys(carpetSets).length > 0 ? (
          <Carousel
            opts={{
              align: "start",
              loop: true,
            }}
            className="w-full max-w-6xl mx-auto"
          >
            <CarouselContent className="-ml-2 md:-ml-4">
              {Object.entries(carpetSets).map(([setName, setCarpets]: [string, any[]]) => (
                <CarouselItem key={setName} className="pl-2 md:pl-4 basis-full sm:basis-1/2 md:basis-1/3 lg:basis-1/4">
                  <CarpetSetCard carpets={setCarpets} setName={setName} />
                </CarouselItem>
              ))}
            </CarouselContent>
            <CarouselPrevious className="hidden md:flex" />
            <CarouselNext className="hidden md:flex" />
          </Carousel>
        ) : (
          <div className="text-center py-16">
            <div className="max-w-md mx-auto">
              <div className="w-24 h-24 bg-muted rounded-full flex items-center justify-center mx-auto mb-6">
                <svg className="w-12 h-12 text-muted-foreground" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <h3 className="text-xl font-semibold text-foreground mb-2">Galería en Preparación</h3>
              <p className="text-muted-foreground">
                Pronto agregaremos las nuevas fotos de nuestra colección completa.
              </p>
            </div>
          </div>
        )}

        <div className="text-center mt-8">
          <p className="text-sm text-muted-foreground">
            Desliza para ver más alfombras • Usa las flechas para navegar
          </p>
        </div>
      </div>
    </section>
  );
};

// Component for individual carpet sets with hover/click functionality
const CarpetSetCard = ({ carpets, setName }: { carpets: any[], setName: string }) => {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [isHovered, setIsHovered] = useState(false);

  const currentCarpet = carpets[currentImageIndex];

  const nextImage = () => {
    setCurrentImageIndex((prev) => (prev + 1) % carpets.length);
  };

  const prevImage = () => {
    setCurrentImageIndex((prev) => (prev - 1 + carpets.length) % carpets.length);
  };

  return (
    <Card
      className="overflow-hidden hover:shadow-lg transition-all duration-300 cursor-pointer group"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onClick={nextImage}
    >
      <div className="aspect-square relative overflow-hidden">
        <img
          src={currentCarpet.image_url}
          alt={currentCarpet.alt_text || currentCarpet.name}
          className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
          loading="lazy"
        />

        {/* Navigation arrows */}
        <div className={`absolute inset-0 flex items-center justify-center bg-black/20 transition-opacity duration-300 ${isHovered ? 'opacity-100' : 'opacity-0'}`}>
          <div className="flex items-center space-x-4">
            <button
              onClick={(e) => {
                e.stopPropagation();
                prevImage();
              }}
              className="w-10 h-10 bg-white/90 rounded-full flex items-center justify-center hover:bg-white transition-colors shadow-lg"
            >
              <svg className="w-5 h-5 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
              </svg>
            </button>

            <div className="bg-white/90 px-3 py-1 rounded-full text-sm font-medium text-gray-700 shadow-lg">
              {currentImageIndex + 1} / {carpets.length}
            </div>

            <button
              onClick={(e) => {
                e.stopPropagation();
                nextImage();
              }}
              className="w-10 h-10 bg-white/90 rounded-full flex items-center justify-center hover:bg-white transition-colors shadow-lg"
            >
              <svg className="w-5 h-5 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>
        </div>

        {/* Hover indicator */}
        <div className={`absolute top-2 right-2 bg-white/90 px-2 py-1 rounded-full text-xs font-medium text-gray-700 transition-opacity duration-300 ${isHovered ? 'opacity-100' : 'opacity-0'}`}>
          Haz clic para cambiar vista
        </div>
      </div>

      <CardContent className="p-4">
        <h3 className="font-medium text-sm text-center text-foreground mb-1">
          {setName}
        </h3>
        <p className="text-xs text-center text-muted-foreground">
          {carpets.length} vistas disponibles
        </p>
      </CardContent>
    </Card>
  );
};

export default CarpetCarousel;
