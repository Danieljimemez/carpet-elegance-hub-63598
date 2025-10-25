import { Mail, Phone, MapPin, Clock, Facebook, Instagram } from "lucide-react";

const Footer = () => {
  return (
    <footer className="bg-card border-t border-border">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-8 sm:gap-12">
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
                  href="mailto:rangelraj@prodigy.net.mx"
                  className="text-sm text-muted-foreground hover:text-primary transition-colors"
                >
                  rangelraj@prodigy.net.mx
                </a>
              </li>
              <li className="flex items-start gap-3">
                <Phone className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div className="space-y-1">
                  <div className="flex items-center">
                    <span className="font-medium mr-1">Matriz:</span>
                    <a
                      href="tel:+526616121426"
                      className="text-sm text-muted-foreground hover:text-primary transition-colors"
                    >
                      (661) 612 1426
                    </a>
                  </div>
                  <div className="flex items-center">
                    <span className="font-medium mr-1">Guerrero:</span>
                    <a
                      href="tel:+526616120561"
                      className="text-sm text-muted-foreground hover:text-primary transition-colors"
                    >
                      (661) 612 0561
                    </a>
                  </div>
                  <div className="flex items-center">
                    <span className="font-medium mr-1">Mexicali:</span>
                    <a
                      href="tel:+526865619588"
                      className="text-sm text-muted-foreground hover:text-primary transition-colors"
                    >
                      (686) 561 9588
                    </a>
                  </div>
                </div>
              </li>
            </ul>
          </div>

          {/* Ubicaciones */}
          <div>
            <h4 className="text-lg font-semibold text-foreground mb-4">Ubicaciones</h4>
            <ul className="space-y-3">
              <li className="flex items-start gap-3">
                <MapPin className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div>
                  <p className="font-medium text-sm">Matriz</p>
                  <p className="text-sm text-muted-foreground">Blvd. Benito Juárez No. 151, Zona Centro</p>
                  <p className="text-sm text-muted-foreground">22703 Playas de Rosarito, B.C.</p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <MapPin className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div>
                  <p className="font-medium text-sm">Sucursal Guerrero</p>
                  <p className="text-sm text-muted-foreground">Guerrero 1234, Constitución (Ampl. Constitución)</p>
                  <p className="text-sm text-muted-foreground">22707 Playas de Rosarito, B.C.</p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <MapPin className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
                <div>
                  <p className="font-medium text-sm">Sucursal Mexicali</p>
                  <p className="text-sm text-muted-foreground">Blvd. Lázaro Cárdenas 1190, Desarrollo Urbano Zacatecas II</p>
                  <p className="text-sm text-muted-foreground">21389 Mexicali, B.C.</p>
                </div>
              </li>
            </ul>
          </div>

          {/* Hours */}
          <div className="lg:col-span-2">
            <h4 className="text-lg font-semibold text-foreground mb-6">Horarios de Atención</h4>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              {/* Horario Matriz */}
              <div className="bg-secondary/20 p-5 rounded-xl border border-border/30">
                <div className="flex items-center gap-2 mb-3">
                  <div className="w-2 h-2 rounded-full bg-primary"></div>
                  <h5 className="font-semibold text-foreground">Matriz</h5>
                </div>
                <ul className="space-y-3">
                  <li className="flex items-start gap-3">
                    <Clock className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                    <div className="text-sm">
                      <p className="text-muted-foreground">Lunes a Viernes</p>
                      <p className="text-foreground font-medium">9:00 AM - 5:30 PM</p>
                    </div>
                  </li>
                  <li className="flex items-start gap-3">
                    <Clock className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                    <div className="text-sm">
                      <p className="text-muted-foreground">Sábado</p>
                      <p className="text-foreground font-medium">9:00 AM - 4:00 PM</p>
                    </div>
                  </li>
                  <li className="flex items-start gap-3">
                    <Clock className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                    <div className="text-sm">
                      <p className="text-muted-foreground">Domingo</p>
                      <p className="text-foreground font-medium">Cerrado</p>
                    </div>
                  </li>
                </ul>
              </div>

              {/* Horario Guerrero */}
              <div className="bg-secondary/20 p-5 rounded-xl border border-border/30">
                <div className="flex items-center gap-2 mb-3">
                  <div className="w-2 h-2 rounded-full bg-primary"></div>
                  <h5 className="font-semibold text-foreground">Sucursal Guerrero</h5>
                </div>
                <ul className="space-y-3">
                  <li className="flex items-start gap-3">
                    <Clock className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                    <div className="text-sm">
                      <p className="text-muted-foreground">Lunes a Sábado</p>
                      <p className="text-foreground font-medium">8:00 AM - 5:00 PM</p>
                    </div>
                  </li>
                  <li className="flex items-start gap-3">
                    <Clock className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                    <div className="text-sm">
                      <p className="text-muted-foreground">Domingo</p>
                      <p className="text-foreground font-medium">Cerrado</p>
                    </div>
                  </li>
                </ul>
              </div>

              {/* Horario Mexicali */}
              <div className="bg-secondary/20 p-5 rounded-xl border border-border/30">
                <div className="flex items-center gap-2 mb-3">
                  <div className="w-2 h-2 rounded-full bg-primary"></div>
                  <h5 className="font-semibold text-foreground">Sucursal Mexicali</h5>
                </div>
                <ul className="space-y-3">
                  <li className="flex items-start gap-3">
                    <Clock className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                    <div className="text-sm">
                      <p className="text-muted-foreground">Lunes a Viernes</p>
                      <p className="text-foreground font-medium">8:00 AM - 6:00 PM</p>
                    </div>
                  </li>
                  <li className="flex items-start gap-3">
                    <Clock className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                    <div className="text-sm">
                      <p className="text-muted-foreground">Sábado</p>
                      <p className="text-foreground font-medium">8:00 AM - 2:00 PM</p>
                    </div>
                  </li>
                  <li className="flex items-start gap-3">
                    <Clock className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                    <div className="text-sm">
                      <p className="text-muted-foreground">Domingo</p>
                      <p className="text-foreground font-medium">Cerrado</p>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
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
