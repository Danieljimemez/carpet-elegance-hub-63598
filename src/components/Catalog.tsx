import ProductCard from "./ProductCard";
import { toast } from "sonner";
import rugModern from "@/assets/rug-modern-1.jpg";
import rugPersian from "@/assets/rug-persian-1.jpg";
import rugMinimal from "@/assets/rug-minimal-1.jpg";
import rugShag from "@/assets/rug-shag-1.jpg";
import rugBoho from "@/assets/rug-boho-1.jpg";
import rugContemporary from "@/assets/rug-contemporary-1.jpg";

const products = [
  {
    id: 1,
    image: rugModern,
    name: "Geométrica Moderna",
    size: "200 x 300 cm",
    price: "$3,499",
  },
  {
    id: 2,
    image: rugPersian,
    name: "Persa Tradicional",
    size: "250 x 350 cm",
    price: "$5,999",
  },
  {
    id: 3,
    image: rugMinimal,
    name: "Minimalista Elegante",
    size: "160 x 230 cm",
    price: "$2,799",
  },
  {
    id: 4,
    image: rugShag,
    name: "Shag Luxury",
    size: "200 x 300 cm",
    price: "$4,299",
  },
  {
    id: 5,
    image: rugBoho,
    name: "Boho Étnica",
    size: "180 x 270 cm",
    price: "$3,199",
  },
  {
    id: 6,
    image: rugContemporary,
    name: "Contemporánea Acuarela",
    size: "200 x 290 cm",
    price: "$3,899",
  },
];

const Catalog = () => {
  const handleViewDetails = (product: typeof products[0]) => {
    toast.success(`Ver detalles de ${product.name}`, {
      description: "Próximamente podrás ver más información sobre este producto.",
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

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 lg:gap-10">
          {products.map((product, index) => (
            <div
              key={product.id}
              className="animate-fade-in-up"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              <ProductCard
                image={product.image}
                name={product.name}
                size={product.size}
                price={product.price}
                onViewDetails={() => handleViewDetails(product)}
              />
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Catalog;
