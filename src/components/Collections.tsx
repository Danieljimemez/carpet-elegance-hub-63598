import { Card } from "@/components/ui/card";
import rugModern from "@/assets/rug-modern-1.jpg";
import rugPersian from "@/assets/rug-persian-1.jpg";
import rugMinimal from "@/assets/rug-minimal-1.jpg";
import rugBoho from "@/assets/rug-boho-1.jpg";

const collections = [
  {
    id: 1,
    name: "Alfombras Modernas",
    description: "Diseños contemporáneos con líneas limpias",
    image: rugModern,
  },
  {
    id: 2,
    name: "Alfombras Persas",
    description: "Elegancia clásica y artesanía tradicional",
    image: rugPersian,
  },
  {
    id: 3,
    name: "Alfombras Minimalistas",
    description: "Simplicidad sofisticada para espacios modernos",
    image: rugMinimal,
  },
  {
    id: 4,
    name: "Alfombras Bohemias",
    description: "Colores vibrantes y patrones étnicos",
    image: rugBoho,
  },
];

const Collections = () => {
  return (
    <section id="colecciones" className="py-16 sm:py-20 lg:py-32 hero-gradient">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Nuestras Colecciones
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Descubre estilos únicos para cada gusto y espacio
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 sm:gap-8">
          {collections.map((collection, index) => (
            <Card
              key={collection.id}
              className="group relative overflow-hidden cursor-pointer shadow-soft hover:shadow-elevated transition-smooth animate-scale-in"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              <div className="relative h-64 sm:h-80 lg:h-96 overflow-hidden">
                <img
                  src={collection.image}
                  alt={collection.name}
                  className="w-full h-full object-cover group-hover:scale-110 transition-smooth"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-background/90 via-background/50 to-transparent" />
                <div className="absolute bottom-0 left-0 right-0 p-6 sm:p-8">
                  <h3 className="text-2xl sm:text-3xl font-serif font-bold text-foreground mb-2">
                    {collection.name}
                  </h3>
                  <p className="text-sm sm:text-base text-foreground/80">
                    {collection.description}
                  </p>
                </div>
              </div>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Collections;
