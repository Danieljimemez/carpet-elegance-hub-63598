import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Eye } from "lucide-react";
import {
  Dialog,
  DialogContent,
} from "@/components/ui/dialog";
import { useState } from "react";

interface ProductCardProps {
  image: string;
  name: string;
  size: string;
  description?: string;
  price?: string;
  onViewDetails: () => void;
}

const ProductCard = ({ image, name, size, description, price, onViewDetails }: ProductCardProps) => {
  const [previewModal, setPreviewModal] = useState(false);

  const openPreview = () => setPreviewModal(true);
  const closePreview = () => setPreviewModal(false);
  return (
    <Card className="group overflow-hidden shadow-soft hover:shadow-elevated transition-smooth bg-card border-border flex flex-col h-full">
      <div className="relative flex-1 min-h-[180px] max-h-[300px] flex items-center justify-center p-3 bg-white">
        <img
          src={image}
          alt={name}
          className="w-auto h-auto max-w-full max-h-[250px] object-contain"
          onError={(e) => {
            console.warn(`Failed to load product image: ${image}`);
            e.currentTarget.src = "/placeholder.svg";
          }}
          style={{
            maxHeight: '250px',
            width: 'auto',
            height: 'auto',
            maxWidth: '100%',
            objectFit: 'contain'
          }}
        />
      </div>
      <CardFooter className="p-2 sm:p-3 flex gap-2 mt-auto">
        <Button
          variant="outline"
          size="sm"
          onClick={openPreview}
          className="flex items-center gap-2 flex-1 hover:bg-primary hover:text-primary-foreground transition-smooth"
        >
          <Eye className="w-4 h-4" />
          Vista Previa
        </Button>
        <Button
          variant="outline"
          size="sm"
          onClick={onViewDetails}
          className="flex-1 hover:bg-primary hover:text-primary-foreground transition-smooth"
        >
          Ver Detalles
        </Button>
      </CardFooter>

      {/* Image Preview Modal */}
      <Dialog open={previewModal} onOpenChange={(open) => !open && closePreview()}>
        <DialogContent className="max-w-6xl w-full p-0 bg-transparent border-0 overflow-hidden shadow-none">
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
                  src={image}
                  alt={name}
                  className="relative z-10 max-w-full max-h-full object-contain"
                />
                
                {/* Efecto de borde sutil */}
                <div className="absolute inset-0 ring-1 ring-inset ring-black/5 rounded-2xl pointer-events-none"></div>
              </div>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </Card>
  );
};

export default ProductCard;
