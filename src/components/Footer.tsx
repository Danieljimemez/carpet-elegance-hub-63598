import { Mail, Phone, MapPin, Clock, Facebook, Instagram } from "lucide-react";

const Footer = () => {
  return (
    <footer className="bg-card border-t border-border">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 sm:gap-12">
          {/* Brand */}
          <div>
            <h3 className="text-2xl font-serif font-bold text-primary mb-4">
              Muebles Rangel
            </h3>
            <p className="text-sm text-muted-foreground leading-relaxed">
              Transformando espacios con elegancia y calidez desde hace años. Tu tienda de confianza para alfombras decorativas de calidad premium.
            </p>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-lg font-semibold text-foreground mb-4">Contacto</h4>
            <ul className="space-y-3">
              <li className="flex items-start gap-3">
                <Mail className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <a
                  href="mailto:contacto@alfombraselegantes.com"
                  className="text-sm text-muted-foreground hover:text-primary transition-colors"
                >
                  contacto@alfombraselegantes.com
                </a>
              </li>
              <li className="flex items-start gap-3">
                <Phone className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <a
                  href="tel:+526611234567"
                  className="text-sm text-muted-foreground hover:text-primary transition-colors"
                >
                  +52 661 123 4567
                </a>
              </li>
              <li className="flex items-start gap-3">
                <MapPin className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <span className="text-sm text-muted-foreground">
                  Playas de Rosarito, México
                </span>
              </li>
            </ul>
          </div>

          {/* Hours */}
          <div>
            <h4 className="text-lg font-semibold text-foreground mb-4">Horario de Atención</h4>
            <ul className="space-y-3">
              <li className="flex items-start gap-3">
                <Clock className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div className="text-sm text-muted-foreground">
                  <p>Lunes a Viernes</p>
                  <p className="font-medium">9:00 AM - 7:00 PM</p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <Clock className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div className="text-sm text-muted-foreground">
                  <p>Sábados</p>
                  <p className="font-medium">10:00 AM - 6:00 PM</p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <Clock className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div className="text-sm text-muted-foreground">
                  <p>Domingos</p>
                  <p className="font-medium">Cerrado</p>
                </div>
              </li>
            </ul>
          </div>

          {/* Social */}
          <div>
            <h4 className="text-lg font-semibold text-foreground mb-4">Síguenos</h4>
            <p className="text-sm text-muted-foreground mb-4">
              Mantente al día con nuestras últimas ofertas y novedades.
            </p>
            <div className="flex gap-3">
              <a
                href="https://facebook.com"
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center hover:bg-primary hover:text-primary-foreground transition-smooth"
                aria-label="Facebook"
              >
                <Facebook className="w-5 h-5" />
              </a>
              <a
                href="https://instagram.com"
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center hover:bg-primary hover:text-primary-foreground transition-smooth"
                aria-label="Instagram"
              >
                <Instagram className="w-5 h-5" />
              </a>
              <a
                href="https://tiktok.com"
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 rounded-full bg-secondary flex items-center justify-center hover:bg-primary hover:text-primary-foreground transition-smooth"
                aria-label="TikTok"
              >
                <svg
                  className="w-5 h-5"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path d="M19.589 6.686a4.793 4.793 0 0 1-3.77-4.245V2h-3.445v13.672a2.896 2.896 0 0 1-5.201 1.743l-.002-.001.002.001a2.895 2.895 0 0 1 3.183-4.51v-3.5a6.329 6.329 0 0 0-1.183-.11 6.444 6.444 0 1 0 6.444 6.444V8.953c1.076.207 2.14.653 3.02 1.285a7.552 7.552 0 0 0 2.717-5.657z"/>
                </svg>
              </a>
            </div>
          </div>
        </div>

        {/* Bottom */}
        <div className="border-t border-border mt-12 pt-8 flex flex-col sm:flex-row justify-between items-center gap-4">
          <p className="text-sm text-muted-foreground">
            © {new Date().getFullYear()} Muebles Rangel. Todos los derechos reservados.
          </p>
          <a
            href="#privacidad"
            className="text-sm text-muted-foreground hover:text-primary transition-colors"
          >
            Aviso de Privacidad
          </a>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
