import { useQuery } from "@tanstack/react-query";
import { fetchPromoBanners, getImageUrl } from "@/services/supabaseService";
import { Loader2, ChevronLeft, ChevronRight, Ruler } from "lucide-react";
import { useState, useCallback, useEffect } from "react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";

// Define el bucket de Supabase donde se almacenan las imágenes
const BUCKET_NAME = 'promo'; // Actualizado a 'promo' según los errores de la consola

const PromoBanner = () => {
  // Obtener banners promocionales de la tabla promo_banner
  const { data: promoBannersData = [], isLoading } = useQuery({
    queryKey: ['promo-banners'],
    queryFn: fetchPromoBanners,
    select: (data) => {
      console.log('Banners data from Supabase:', data); // Debug log
      
      // Mapeo de paths a nombres de archivo reales
      const pathToImageMap: Record<string, string> = {
        'promo-beace242-3fbc-41df-acc3-38e577a0a587': 'Beige Claro 2.png',
        'promo-7eb53537-16fe-4d19-bd27-af6d591937bb': 'Silver 2.png',
        'promo-4b038ea7-15bb-44bc-b560-ccc3ba42474a': 'Grey 2.png'
      };
      
      return data.map(banner => {
        // Usar el path del banner para buscar el nombre del archivo
        const pathKey = banner.path || '';
        const imageName = pathToImageMap[pathKey] || 'default-banner.png';
        
        // Construir la URL completa
        const imageUrl = `https://uiwzfqwmaeihyllfvtbk.supabase.co/storage/v1/object/public/promo/${encodeURIComponent(imageName)}`;
        
        console.log(`Processing banner:`, { 
          id: banner.id,
          originalPath: banner.path,
          mappedImage: imageName,
          imageUrl
        });
        
        return {
          ...banner,
          image_url: imageUrl,
          // Asegurarse de que el path esté disponible para depuración
          _debug: {
            originalPath: banner.path,
            mappedImage: imageName,
            finalUrl: imageUrl
          }
        };
      });
    }
  });

  const [promoBanners, setPromoBanners] = useState<typeof promoBannersData>([]);
  
  // Sincronizar los banners cuando se carguen los datos
  useEffect(() => {
    if (promoBannersData.length > 0) {
      setPromoBanners(promoBannersData);
    }
  }, [promoBannersData]);

  const [currentIndex, setCurrentIndex] = useState(0);
  const [isHovered, setIsHovered] = useState(false);
  const [showCalculator, setShowCalculator] = useState(true);
  const [squareMeters, setSquareMeters] = useState<number | ''>('');
  const [price, setPrice] = useState<number>(0);
  const pricePerM2 = 108; // Precio por metro cuadrado

  // Navegación automática
  useEffect(() => {
    if (promoBanners.length <= 1) return;
    
    const interval = setInterval(() => {
      setCurrentIndex(prevIndex => 
        prevIndex === promoBanners.length - 1 ? 0 : prevIndex + 1
      );
    }, 5000);

    return () => clearInterval(interval);
  }, [promoBanners.length]);

  const goToNext = useCallback(() => {
    setCurrentIndex((prevIndex) => 
      prevIndex === promoBanners.length - 1 ? 0 : prevIndex + 1
    );
  }, [promoBanners.length]);

  const goToPrev = useCallback(() => {
    setCurrentIndex((prevIndex) => 
      prevIndex === 0 ? promoBanners.length - 1 : prevIndex - 1
    );
  }, [promoBanners.length]);

  const handleCalculatePrice = () => {
    if (typeof squareMeters === 'number' && squareMeters > 0) {
      setPrice(squareMeters * pricePerM2);
    }
  };


  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64 bg-gray-100">
        <Loader2 className="w-8 h-8 animate-spin text-primary" />
      </div>
    );
  }

  if (promoBanners.length === 0) {
    return null; // No mostrar el banner si no hay imágenes
  }

  const currentBanner = promoBanners[currentIndex];
  const hasMultipleBanners = promoBanners.length > 1;

  return (
    <section className="bg-white py-3 px-2">
      <div className="max-w-5xl mx-auto">
        <div className="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-100">
          {/* Mensaje principal destacado */}
          <div className="bg-primary py-1.5 px-4 text-center">
            <p className="text-white text-xs sm:text-sm font-medium">
              Alfombras a un precio irresistible: descubre nuestra selección a <span className="font-bold">$108 el metro cuadrado</span>
            </p>
          </div>
          
          <div className="flex flex-col md:flex-row">
            {/* Sección del carrusel */}
            <div className="w-full md:w-3/5 p-1">
              <div 
                className="relative aspect-[5/3] rounded-lg overflow-hidden shadow-sm bg-gray-100"
                onMouseEnter={() => {
                  setIsHovered(true);
                }}
                onMouseLeave={() => {
                  setIsHovered(false);
                }}
              >
                <div className="w-full h-full flex items-center justify-center">
                  <img
                    key={currentBanner.id}
                    src={currentBanner.image_url}
                    alt={currentBanner.alt_text || 'Promoción'}
                    className="w-full h-full object-cover transition-opacity duration-300"
                    onError={(e) => {
                      console.error('Error al cargar la imagen:', currentBanner.image_url);
                      e.currentTarget.src = 'https://placehold.co/600x600/f3f4f6/9ca3af?text=Imagen+no+disponible';
                      e.currentTarget.alt = 'Imagen promocional no disponible';
                      e.currentTarget.className = 'w-full h-full object-contain p-4';
                    }}
                    onLoad={(e) => {
                      console.log('Imagen cargada correctamente:', currentBanner.image_url);
                    }}
                  />
                </div>
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-transparent flex items-end p-3">
                  <div className="text-white max-w-full">
                    <h2 className="text-sm font-bold mb-1">{currentBanner.title}</h2>
                    {currentBanner.description && (
                      <p className="text-gray-200 text-xs">{currentBanner.description}</p>
                    )}
                  </div>
                </div>

                {hasMultipleBanners && (
                  <>
                    <button
                      onClick={goToPrev}
                      className="absolute left-2 top-1/2 -translate-y-1/2 bg-black/50 text-white p-1.5 rounded-full hover:bg-black/70 transition-colors"
                      aria-label="Anterior"
                    >
                      <ChevronLeft className="w-4 h-4" />
                    </button>
                    <button
                      onClick={goToNext}
                      className="absolute right-2 top-1/2 -translate-y-1/2 bg-black/50 text-white p-1.5 rounded-full hover:bg-black/70 transition-colors"
                      aria-label="Siguiente"
                    >
                      <ChevronRight className="w-4 h-4" />
                    </button>

                    <div className="absolute bottom-2 left-1/2 -translate-x-1/2 flex gap-1.5">
                      {promoBanners.map((_, index) => (
                        <button
                          key={index}
                          onClick={() => setCurrentIndex(index)}
                          className={`w-2 h-2 rounded-full transition-colors ${
                            index === currentIndex ? 'bg-white' : 'bg-white/50 hover:bg-white/70'
                          }`}
                          aria-label={`Ir al banner ${index + 1}`}
                        />
                      ))}
                    </div>
                  </>
                )}
              </div>
              
              {/* Miniaturas */}
              {promoBanners.length > 1 && (
                <div className="flex justify-center gap-1.5 mt-2 overflow-x-auto py-1 px-1">
                  {promoBanners.map((banner, bannerIndex) => (
                    <button
                      key={banner.id}
                      onClick={() => setCurrentIndex(bannerIndex)}
                      className={`flex-shrink-0 w-14 h-10 rounded-md overflow-hidden border-2 bg-white transition-all duration-200 ${
                        currentIndex === bannerIndex 
                          ? 'border-primary shadow-md transform scale-105' 
                          : 'border-gray-200 hover:border-primary/50'
                      }`}
                    >
                      <img
                        src={banner.image_url}
                        alt={`Miniatura ${bannerIndex + 1}`}
                        className="w-full h-full object-cover"
                        onError={(e) => {
                          e.currentTarget.src = 'https://placehold.co/100x100/f3f4f6/9ca3af?text=Img';
                          e.currentTarget.className = 'w-full h-full object-contain p-1';
                        }}
                      />
                    </button>
                  ))}
                </div>
              )}
            </div>
            
            {/* Sección de la calculadora */}
            <div className="w-full md:w-2/5 p-2 bg-gray-50 border-l border-gray-100 flex items-center">
              <div className="w-full space-y-3">
                <div className="text-center space-y-1">
                  <h3 className="text-2xl font-bold text-gray-900 leading-none">
                    $108 el m²
                  </h3>
                  <p className="text-base text-primary font-semibold">
                    ¡Precio especial!
                  </p>
                </div>
                
                <div className="space-y-3">
                  <div>
                    <Label htmlFor="length" className="block text-sm font-medium text-gray-700 mb-1">
                      Metros cuadrados (m²)
                    </Label>
                    <Input
                      id="length"
                      type="number"
                      placeholder="Ej: 2.5"
                      min="0.1"
                      step="0.1"
                      value={squareMeters}
                      onChange={(e) => {
                        const value = parseFloat(e.target.value);
                        setSquareMeters(isNaN(value) ? '' : value);
                        setPrice(0);
                      }}
                      className="w-full h-9 text-sm text-center font-medium"
                    />
                  </div>
                  
                  <Button 
                    onClick={handleCalculatePrice} 
                    className="w-full h-9 text-sm font-medium"
                    disabled={!squareMeters}
                  >
                    Calcular precio
                  </Button>
                  
                  <div className="bg-white p-1.5 rounded-lg border border-primary/20 shadow-sm">
                    <p className="text-base font-medium text-gray-600 mb-1">Precio estimado:</p>
                    <p className="text-2xl font-bold text-primary mb-1">
                      {price > 0 ? `$${price.toFixed(2)}` : '---'}
                    </p>
                    <p className="text-[10px] text-gray-500">
                      * Precio estimado. Contáctanos para más información.
                    </p>
                  </div>
                </div>
              </div>
            </div>
            
          </div>
        </div>
      </div>
    </section>
  );
};

export default PromoBanner;
