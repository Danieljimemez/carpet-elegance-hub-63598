import { useState } from "react";
import { Menu, X, MapPin, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const LOCATIONS = [
  {
    name: "Matriz",
    url: "https://maps.app.goo.gl/gKXQML5ncSv2aS8bA",
    address: "Blvd. Benito Juárez No. 151, Zona Centro, 22703 Playas de Rosarito, B.C."
  },
  {
    name: "Sucursal Guerrero",
    url: "https://maps.app.goo.gl/XW5KqTLHP22r5wow7",
    address: "Guerrero 1234, Constitución (Ampl. Constitución), 22707 Playas de Rosarito, B.C."
  },
  {
    name: "Sucursal Mexicali",
    url: "https://maps.app.goo.gl/L8qyz2NknMjrHEnj7",
    address: "Blvd. Lázaro Cárdenas 1190, Desarrollo Urbano Zacatecas II, 21389 Mexicali, B.C."
  }
];

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
              onClick={() => scrollToSection("galeria")}
              className="font-sans text-sm lg:text-base"
            >
              Galería
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
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="outline" className="ml-2 lg:ml-4">
                  <MapPin className="w-4 h-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent className="w-64 p-0">
                {LOCATIONS.map((location) => (
                  <DropdownMenuItem key={location.name} className="p-0">
                    <a 
                      href={location.url} 
                      target="_blank" 
                      rel="noopener noreferrer"
                      className="w-full px-4 py-2 block hover:bg-accent hover:text-accent-foreground"
                    >
                      <div className="flex flex-col items-start">
                        <span className="font-medium">{location.name}</span>
                        <span className="text-xs text-muted-foreground">{location.address}</span>
                      </div>
                    </a>
                  </DropdownMenuItem>
                ))}
              </DropdownMenuContent>
            </DropdownMenu>
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
                onClick={() => scrollToSection("galeria")}
                className="justify-start"
              >
                Galería
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
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="outline" className="justify-start">
                    <MapPin className="w-4 h-4 mr-2" />
                    <span>Ubicaciones</span>
                    <ChevronDown className="w-4 h-4 ml-2 opacity-50" />
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent className="w-64 p-0">
                  {LOCATIONS.map((location) => (
                    <DropdownMenuItem key={location.name} className="p-0">
                      <a 
                        href={location.url} 
                        target="_blank" 
                        rel="noopener noreferrer"
                        className="w-full px-4 py-2 block hover:bg-accent hover:text-accent-foreground"
                      >
                        <div className="flex flex-col items-start">
                          <span className="font-medium">{location.name}</span>
                          <span className="text-xs text-muted-foreground">{location.address}</span>
                        </div>
                      </a>
                    </DropdownMenuItem>
                  ))}
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          </nav>
        )}
      </div>
    </header>
  );
};

export default Header;
