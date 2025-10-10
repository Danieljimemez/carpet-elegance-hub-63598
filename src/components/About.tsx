import { Award, Heart, Sparkles } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";

const features = [
  {
    icon: Award,
    title: "Calidad Artesanal",
    description: "Cada alfombra es seleccionada cuidadosamente por su calidad excepcional y acabados impecables.",
  },
  {
    icon: Heart,
    title: "Atención Personalizada",
    description: "Te ayudamos a encontrar la alfombra perfecta para tu espacio con asesoría experta y dedicada.",
  },
  {
    icon: Sparkles,
    title: "Materiales Premium",
    description: "Trabajamos solo con los mejores materiales naturales y sintéticos de alta durabilidad.",
  },
];

const About = () => {
  return (
    <section id="nosotros" className="py-16 sm:py-20 lg:py-32 bg-background">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="max-w-3xl mx-auto text-center mb-12 sm:mb-16 animate-fade-in">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-6">
            Sobre Nosotros
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground leading-relaxed mb-6">
            En <span className="font-semibold text-primary">Alfombras Elegantes</span>, nos apasiona transformar espacios
            con piezas únicas que combinan elegancia, confort y funcionalidad.
          </p>
          <p className="text-base sm:text-lg text-muted-foreground leading-relaxed">
            Con años de experiencia en el mundo del diseño de interiores, ofrecemos una colección
            cuidadosamente seleccionada de alfombras, muebles y cortinas que reflejan calidad artesanal y estilo contemporáneo.
            Cada pieza es elegida pensando en crear ambientes acogedores y sofisticados.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 sm:gap-8">
          {features.map((feature, index) => {
            const Icon = feature.icon;
            return (
              <Card
                key={index}
                className="shadow-soft hover:shadow-elevated transition-smooth animate-fade-in-up"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <CardContent className="p-6 sm:p-8 text-center">
                  <div className="w-16 h-16 mx-auto mb-4 rounded-full accent-gradient flex items-center justify-center">
                    <Icon className="w-8 h-8 text-primary-foreground" />
                  </div>
                  <h3 className="text-xl sm:text-2xl font-serif font-semibold text-foreground mb-3">
                    {feature.title}
                  </h3>
                  <p className="text-sm sm:text-base text-muted-foreground leading-relaxed">
                    {feature.description}
                  </p>
                </CardContent>
              </Card>
            );
          })}
        </div>
      </div>
    </section>
  );
};

export default About;
