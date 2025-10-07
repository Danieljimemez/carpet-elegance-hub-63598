import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter } from "@/components/ui/card";

interface ProductCardProps {
  image: string;
  name: string;
  size: string;
  price: string;
  onViewDetails: () => void;
}

const ProductCard = ({ image, name, size, price, onViewDetails }: ProductCardProps) => {
  return (
    <Card className="group overflow-hidden shadow-soft hover:shadow-elevated transition-smooth bg-card border-border">
      <div className="relative aspect-square overflow-hidden bg-muted">
        <img
          src={image}
          alt={name}
          className="w-full h-full object-cover group-hover:scale-110 transition-smooth"
        />
      </div>
      <CardContent className="p-4 sm:p-6">
        <h3 className="text-lg sm:text-xl font-serif font-semibold text-foreground mb-2">
          {name}
        </h3>
        <p className="text-sm text-muted-foreground mb-1">Tamaño: {size}</p>
        <p className="text-xl sm:text-2xl font-bold text-primary mt-3">{price}</p>
      </CardContent>
      <CardFooter className="p-4 sm:p-6 pt-0">
        <Button
          variant="outline"
          onClick={onViewDetails}
          className="w-full hover:bg-primary hover:text-primary-foreground transition-smooth"
        >
          Ver Detalles
        </Button>
      </CardFooter>
    </Card>
  );
};

export default ProductCard;
