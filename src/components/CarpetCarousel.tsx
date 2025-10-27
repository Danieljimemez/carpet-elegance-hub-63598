import { Card, CardContent } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogTrigger,
} from "@/components/ui/dialog";
import { useQuery } from "@tanstack/react-query";
import { useState, useEffect, useCallback } from "react";
import { fetchGalleryPhotos, getImageUrl } from "@/services/supabaseService";

const CarpetCarousel = () => {
  const { data: carpets = [], isLoading, error } = useQuery({
    queryKey: ["gallery-photos"],
    queryFn: async () => {
      try {
        const photos = await fetchGalleryPhotos();
        console.log('Fetched gallery photos:', photos); // Debug log
        return photos;
      } catch (err) {
        console.error('Error fetching gallery photos:', err);
        throw err;
      }
    },
  });

  // State for image preview modal
  const [previewModal, setPreviewModal] = useState<{
    isOpen: boolean;
    currentSet: any[] | null;
    currentIndex: number;
    setName: string;
  }>({
    isOpen: false,
    currentSet: null,
    currentIndex: 0,
    setName: "",
  });

  // Function to open preview modal
  const openPreview = (carpets: any[], setName: string, startIndex: number = 0) => {
    setPreviewModal({
      isOpen: true,
      currentSet: carpets,
      currentIndex: startIndex,
      setName,
    });
  };

  // Function to close preview modal
  const closePreview = () => {
    setPreviewModal({
      isOpen: false,
      currentSet: null,
      currentIndex: 0,
      setName: "",
    });
  };

  // Function to navigate in preview modal
  const navigatePreview = useCallback((direction: 'prev' | 'next') => {
    setPreviewModal(prev => {
      if (!prev.currentSet) return prev;
      
      const newIndex = direction === 'next'
        ? (prev.currentIndex + 1) % prev.currentSet.length
        : (prev.currentIndex - 1 + prev.currentSet.length) % prev.currentSet.length;

      return {
        ...prev,
        currentIndex: newIndex,
      };
    });
  }, []);

  // Group carpets by set_name
  const carpetSets = (carpets || []).reduce((acc: any, carpet: any) => {
    if (!carpet?.set_name) return acc; // Skip if set_name is not defined
    if (!acc[carpet.set_name]) {
      acc[carpet.set_name] = [];
    }
    acc[carpet.set_name].push(carpet);
    return acc;
  }, {} as Record<string, any[]>);

  // Keyboard navigation for modal
  useEffect(() => {
    if (!previewModal.isOpen) return;
    
    const handleKeyDown = (event: KeyboardEvent) => {
      if (!previewModal.isOpen) return;

      switch (event.key) {
        case 'ArrowLeft':
          event.preventDefault();
          navigatePreview('prev');
          break;
        case 'ArrowRight':
          event.preventDefault();
          navigatePreview('next');
          break;
        case 'Escape':
          event.preventDefault();
          closePreview();
          break;
        default:
          break;
      }
    };

    // Add event listener for keyboard navigation
    window.addEventListener('keydown', handleKeyDown);
    
    // Cleanup function to remove the event listener
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [previewModal.isOpen, navigatePreview]);

  return (
    <section id="galeria" className="py-16 sm:py-20 lg:py-32 bg-muted/30">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Una Muestra de Nuestras Alfombras
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Descubre una selección de nuestros diseños más exclusivos. 
            Visita nuestro showroom para explorar toda la colección y encontrar la alfombra perfecta para tu espacio.
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
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
            {Object.entries(carpetSets).flatMap(([setName, setCarpets]: [string, any[]]) =>
              setCarpets.map((carpet, index) => (
                <div 
                  key={`${setName}-${index}`}
                  className="relative group cursor-pointer overflow-hidden rounded-lg bg-white shadow-sm hover:shadow-md transition-shadow"
                  onClick={() => openPreview([carpet], '', 0)}
                >
                  <div className="aspect-square overflow-hidden flex items-center justify-center bg-white p-2">
                    <img
                      src={getImageUrl('gallery', carpet.image_url)}
                      alt={carpet.alt_text || `Imagen ${index + 1}`}
                      className="max-w-full max-h-full object-contain hover:scale-105 transition-transform duration-300"
                      onError={(e) => {
                        console.error('Error loading image:', carpet.image_url);
                        // Fallback image in case of error
                        e.currentTarget.src = 'https://placehold.co/400x400/1e40af/white?text=Imagen+No+Disponible';
                        e.currentTarget.alt = 'Imagen no disponible';
                      }}
                    />
                  </div>
                </div>
              ))
            )}
          </div>
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

        {/* Image Preview Modal */}
        <Dialog open={previewModal.isOpen} onOpenChange={(open) => !open && closePreview()}>
          <DialogContent className="max-w-6xl w-full p-0 bg-transparent border-0 overflow-hidden shadow-none">
            {previewModal.currentSet && previewModal.currentSet[previewModal.currentIndex] && (
              <div className="relative w-full h-[90vh] flex items-center justify-center">
                {/* Overlay de fondo con efecto de vidrio esmerilado */}
                <div className="absolute inset-0 bg-black/30 backdrop-blur-sm"></div>
                
                {/* Close button */}
                <button
                  onClick={closePreview}
                  className="absolute top-6 right-6 z-50 w-12 h-12 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center hover:bg-white transition-all duration-200 text-gray-800 shadow-lg hover:scale-105"
                >
                  <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth={1.5}>
                    <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>

                {/* Contenedor de la imagen con efecto de vidrio */}
                <div className="relative w-full h-full max-w-5xl max-h-[85vh] flex items-center justify-center p-4">
                  <div className="relative w-full h-full flex items-center justify-center">
                    {/* Fondo del contenedor con efecto de vidrio */}
                    <div className="absolute inset-0 bg-white/80 backdrop-blur-lg rounded-2xl shadow-2xl border border-white/20"></div>
                    
                    {/* Imagen */}
                    <img
                      src={getImageUrl('gallery', previewModal.currentSet[previewModal.currentIndex].image_url)}
                      alt={previewModal.currentSet[previewModal.currentIndex].alt_text || ''}
                      className="relative z-10 max-w-full max-h-full object-contain"
                      onError={(e) => {
                        console.error('Error loading preview image:', previewModal.currentSet[previewModal.currentIndex].image_url);
                        e.currentTarget.src = 'https://placehold.co/800x600/1e40af/white?text=Imagen+No+Disponible';
                        e.currentTarget.alt = 'Imagen no disponible';
                      }}
                    />
                    
                    {/* Efecto de borde sutil */}
                    <div className="absolute inset-0 ring-1 ring-inset ring-black/5 rounded-2xl pointer-events-none"></div>
                  </div>
                </div>

                {/* Navigation buttons */}
                {previewModal.currentSet.length > 1 && (
                  <>
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        navigatePreview('prev');
                      }}
                      className="absolute left-6 top-1/2 -translate-y-1/2 z-50 w-12 h-12 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center hover:bg-white transition-all duration-200 text-gray-800 shadow-lg hover:scale-105"
                      aria-label="Anterior imagen"
                    >
                      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth={1.5}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                      </svg>
                    </button>
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        navigatePreview('next');
                      }}
                      className="absolute right-6 top-1/2 -translate-y-1/2 z-50 w-12 h-12 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center hover:bg-white transition-all duration-200 text-gray-800 shadow-lg hover:scale-105"
                      aria-label="Siguiente imagen"
                    >
                      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth={1.5}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                      </svg>
                    </button>
                  </>
                )}

                {/* Thumbnails */}
                {previewModal.currentSet.length > 1 && (
                  <div className="absolute bottom-8 left-0 right-0 flex justify-center space-x-3 z-50 px-4">
                    {previewModal.currentSet.map((_, idx) => (
                      <button
                        key={idx}
                        onClick={(e) => {
                          e.stopPropagation();
                          setPreviewModal(prev => ({
                            ...prev,
                            currentIndex: idx
                          }));
                        }}
                        className={`h-1.5 rounded-full transition-all duration-300 ${
                          previewModal.currentIndex === idx 
                            ? 'w-8 bg-gray-800' 
                            : 'w-4 bg-gray-400 hover:bg-gray-600'
                        }`}
                        aria-label={`Ir a imagen ${idx + 1}`}
                      />
                    ))}
                  </div>
                )}
              </div>
            )}
          </DialogContent>
        </Dialog>
      </div>
      
      <div className="text-center mt-8">
        <p className="text-sm text-muted-foreground italic">
          Descubre cada detalle: Haz clic en cualquier imagen para verla en alta resolución
        </p>
      </div>
    </section>
  );
};

// Component for individual carpet sets with hover/click functionality
const CarpetSetCard = ({ carpets, setName, onPreview }: {
  carpets: any[],
  setName: string,
  onPreview: (carpets: any[], setName: string, startIndex: number) => void
}) => {
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
    >
      <div
        className="aspect-square relative overflow-hidden"
        onClick={(e) => {
          // Prevent opening preview if clicking on navigation buttons
          if ((e.target as HTMLElement).closest('button')) return;
          onPreview(carpets, setName, currentImageIndex);
        }}
      >
        <img
          src={currentCarpet.image_url}
          alt={currentCarpet.alt_text || currentCarpet.name}
          className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
          loading="lazy"
          onError={(e) => {
            console.warn(`Failed to load image: ${currentCarpet.image_url}`);
            // Fallback to a placeholder if image fails to load
            e.currentTarget.src = "/placeholder.svg";
          }}
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
              <svg className="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>
        </div>

        {/* Hover indicator */}
        <div className={`absolute top-2 right-2 bg-white/90 px-2 py-1 rounded-full text-xs font-medium text-gray-700 transition-opacity duration-300 ${isHovered ? 'opacity-100' : 'opacity-0'}`}>
          Haz clic para ampliar
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
