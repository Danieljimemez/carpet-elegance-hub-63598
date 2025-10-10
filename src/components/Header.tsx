import { useState } from "react";
import { Menu, X, MapPin } from "lucide-react";
import { Button } from "@/components/ui/button";

const Header = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const scrollToSection = (id: string) => {
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({ behavior: "smooth" });
      setIsMenuOpen(false);
    }
  };

  return (
    <header className="fixed top-0 left-0 right-0 z-50 bg-card/95 backdrop-blur-sm shadow-soft border-b border-border">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 lg:h-20">
          <div className="flex-shrink-0">
            <h1 className="text-xl sm:text-2xl lg:text-3xl font-serif font-bold text-primary">
              Muebles Rangel
            </h1>
          </div>

          {/* Desktop Navigation */}
          <nav className="hidden md:flex items-center space-x-1 lg:space-x-2">
            <Button
              variant="ghost"
              onClick={() => scrollToSection("inicio")}
              className="font-sans text-sm lg:text-base"
            >
              Inicio
            </Button>
            <Button
              variant="ghost"
              onClick={() => scrollToSection("catalogo")}
              className="font-sans text-sm lg:text-base"
            >
              Catálogo
            </Button>
            <Button
              variant="ghost"
              onClick={() => scrollToSection("colecciones")}
              className="font-sans text-sm lg:text-base"
            >
              Colecciones
            </Button>
            <Button
              variant="ghost"
              onClick={() => scrollToSection("nosotros")}
              className="font-sans text-sm lg:text-base"
            >
              Nosotros
            </Button>
            <Button
              variant="ghost"
              onClick={() => scrollToSection("opiniones")}
              className="font-sans text-sm lg:text-base"
            >
              Opiniones
            </Button>
            <Button
              onClick={() => scrollToSection("contacto")}
              className="ml-2 lg:ml-4"
            >
              Contacto
            </Button>
            <a href="https://maps.app.goo.gl/gKXQML5ncSv2aS8bA" target="_blank" rel="noopener noreferrer">
              <Button variant="outline" className="ml-2 lg:ml-4">
                <MapPin className="w-4 h-4" />
              </Button>
            </a>
          </nav>

          {/* Mobile Menu Button */}
          <button
            className="md:hidden p-2"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            aria-label="Toggle menu"
          >
            {isMenuOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
          </button>
        </div>

        {/* Mobile Navigation */}
        {isMenuOpen && (
          <nav className="md:hidden py-4 border-t border-border animate-fade-in">
            <div className="flex flex-col space-y-2">
              <Button
                variant="ghost"
                onClick={() => scrollToSection("inicio")}
                className="justify-start"
              >
                Inicio
              </Button>
              <Button
                variant="ghost"
                onClick={() => scrollToSection("catalogo")}
                className="justify-start"
              >
                Catálogo
              </Button>
              <Button
                variant="ghost"
                onClick={() => scrollToSection("colecciones")}
                className="justify-start"
              >
                Colecciones
              </Button>
              <Button
                variant="ghost"
                onClick={() => scrollToSection("nosotros")}
                className="justify-start"
              >
                Nosotros
              </Button>
              <Button
                variant="ghost"
                onClick={() => scrollToSection("opiniones")}
                className="justify-start"
              >
                Opiniones
              </Button>
              <Button onClick={() => scrollToSection("contacto")} className="justify-start">
                Contacto
              </Button>
              <a href="https://maps.app.goo.gl/gKXQML5ncSv2aS8bA" target="_blank" rel="noopener noreferrer">
                <Button variant="outline" className="justify-start">
                  <MapPin className="w-4 h-4 mr-2" />
                  Ubicación
                </Button>
              </a>
            </div>
          </nav>
        )}
      </div>
    </header>
  );
};

export default Header;
