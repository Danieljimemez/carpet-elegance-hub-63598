import { Button } from "@/components/ui/button";
import heroImage from "@/assets/hero-rug.jpg";

const Hero = () => {
  const scrollToSection = (id: string) => {
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({ behavior: "smooth" });
    }
  };

  return (
    <section id="inicio" className="relative min-h-screen flex items-center justify-center overflow-hidden">
      {/* Background Image */}
      <div className="absolute inset-0 z-0">
        <img
          src={heroImage}
          alt="Elegante sala de estar con alfombra decorativa"
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-b from-background/40 via-background/60 to-background/80" />
      </div>

      {/* Content */}
      <div className="relative z-10 container mx-auto px-4 sm:px-6 lg:px-8 py-20 lg:py-32 text-center">
        <div className="max-w-4xl mx-auto animate-fade-in-up">
          <h2 className="text-4xl sm:text-5xl md:text-6xl lg:text-7xl font-serif font-bold text-foreground mb-6 leading-tight">
            Tu espacio, tu estilo
          </h2>
          <p className="text-lg sm:text-xl md:text-2xl text-foreground/90 mb-8 max-w-2xl mx-auto font-light leading-relaxed">
            Transforma tus espacios con elegancia y calidez. Descubre nuestras alfombras exclusivas.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <Button
              size="lg"
              onClick={() => scrollToSection("catalogo")}
              className="w-full sm:w-auto text-base sm:text-lg px-8 py-6 shadow-elevated hover:scale-105 transition-smooth"
            >
              Ver Catálogo
            </Button>
            <Button
              size="lg"
              variant="outline"
              onClick={() => scrollToSection("contacto")}
              className="w-full sm:w-auto text-base sm:text-lg px-8 py-6 bg-card/80 backdrop-blur-sm hover:bg-card hover:scale-105 transition-smooth"
            >
              Solicitar Asesoría
            </Button>
          </div>
        </div>
      </div>

      {/* Scroll Indicator */}
      <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 z-10 animate-bounce">
        <div className="w-6 h-10 rounded-full border-2 border-foreground/30 flex items-start justify-center p-2">
          <div className="w-1 h-2 bg-foreground/30 rounded-full" />
        </div>
      </div>
    </section>
  );
};

export default Hero;
