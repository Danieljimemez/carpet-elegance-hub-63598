import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Sparkles } from "lucide-react";
import rugShag from "@/assets/rug-shag-1.jpg";
import rugContemporary from "@/assets/rug-contemporary-1.jpg";

// Esta sección está diseñada para conectarse fácilmente a una base de datos
// o servicio como Airtable para actualizaciones dinámicas semanales
const weeklyProducts = [
  {
    id: 1,
    image: rugShag,
    name: "Shag Luxury Crema",
    description: "Alfombra ultra suave con textura de pelo largo, perfecta para espacios de relajación.",
    size: "200 x 300 cm",
    price: "$4,299",
    isNew: true,
  },
  {
    id: 2,
    image: rugContemporary,
    name: "Acuarela Contemporánea",
    description: "Diseño abstracto inspirado en acuarelas, ideal para ambientes modernos.",
    size: "200 x 290 cm",
    price: "$3,899",
    isNew: true,
  },
];

const WeeklyUpdates = () => {
  return (
    <section className="py-16 sm:py-20 lg:py-32 hero-gradient">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <div className="inline-flex items-center justify-center gap-2 mb-4">
            <Sparkles className="w-6 h-6 text-primary" />
            <Badge variant="secondary" className="text-base px-4 py-1">
              Actualización Semanal
            </Badge>
            <Sparkles className="w-6 h-6 text-primary" />
          </div>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Nuevas Incorporaciones
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            Descubre las últimas alfombras que hemos añadido a nuestra colección esta semana
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 sm:gap-8 max-w-5xl mx-auto">
          {weeklyProducts.map((product, index) => (
            <Card
              key={product.id}
              className="overflow-hidden shadow-soft hover:shadow-elevated transition-smooth animate-scale-in"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              <div className="relative">
                <img
                  src={product.image}
                  alt={product.name}
                  className="w-full h-64 sm:h-80 object-cover"
                />
                {product.isNew && (
                  <Badge className="absolute top-4 right-4 bg-primary text-primary-foreground shadow-soft">
                    ¡Nuevo!
                  </Badge>
                )}
              </div>
              <CardContent className="p-6">
                <h3 className="text-xl sm:text-2xl font-serif font-semibold text-foreground mb-2">
                  {product.name}
                </h3>
                <p className="text-sm sm:text-base text-muted-foreground mb-4 leading-relaxed">
                  {product.description}
                </p>
                <div className="flex justify-between items-center">
                  <div>
                    <p className="text-sm text-muted-foreground">Tamaño: {product.size}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

      </div>
    </section>
  );
};

export default WeeklyUpdates;
