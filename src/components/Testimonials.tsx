import { Card, CardContent } from "@/components/ui/card";
import { Star } from "lucide-react";

const testimonials = [
  {
    id: 1,
    name: "María García",
    role: "Arquitecta de Interiores",
    comment: "La calidad de las alfombras es excepcional. Transformaron completamente mi sala de estar. El servicio al cliente es impecable.",
    rating: 5,
  },
  {
    id: 2,
    name: "Carlos Rodríguez",
    role: "Diseñador",
    comment: "Encontré exactamente lo que buscaba. La asesoría personalizada me ayudó a elegir la alfombra perfecta para mi espacio moderno.",
    rating: 5,
  },
  {
    id: 3,
    name: "Ana Martínez",
    role: "Cliente Satisfecha",
    comment: "Excelente atención y productos de primera. Mi casa ahora se siente más cálida y elegante. ¡Totalmente recomendado!",
    rating: 5,
  },
];

const Testimonials = () => {
  return (
    <section id="opiniones" className="py-16 sm:py-20 lg:py-32 hero-gradient">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Lo Que Dicen Nuestros Clientes
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            La satisfacción de nuestros clientes es nuestra mayor recompensa
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 sm:gap-8">
          {testimonials.map((testimonial, index) => (
            <Card
              key={testimonial.id}
              className="shadow-soft hover:shadow-elevated transition-smooth animate-fade-in-up"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              <CardContent className="p-6 sm:p-8">
                <div className="flex mb-4">
                  {[...Array(testimonial.rating)].map((_, i) => (
                    <Star key={i} className="w-5 h-5 fill-primary text-primary" />
                  ))}
                </div>
                <p className="text-sm sm:text-base text-muted-foreground leading-relaxed mb-6 italic">
                  "{testimonial.comment}"
                </p>
                <div className="border-t border-border pt-4">
                  <p className="font-semibold text-foreground">{testimonial.name}</p>
                  <p className="text-sm text-muted-foreground">{testimonial.role}</p>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Testimonials;
