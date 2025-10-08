import { Card, CardContent } from "@/components/ui/card";
import { Star } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

interface Testimonio {
  id: string;
  nombre: string;
  rol: string;
  comentario: string;
  calificacion: number;
}

const Testimonials = () => {
  const { data: testimonials, isLoading } = useQuery({
    queryKey: ['testimonios'],
    queryFn: async () => {
      const { data, error } = await (supabase as any)
        .from('testimonios')
        .select('*')
        .order('created_at', { ascending: false });
      
      if (error) throw error;
      return data as unknown as Testimonio[];
    },
  });
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
          {isLoading ? (
            <div className="col-span-full text-center text-muted-foreground">Cargando testimonios...</div>
          ) : testimonials && testimonials.length > 0 ? (
            testimonials.slice(0, 6).map((testimonial, index) => (
              <Card
                key={testimonial.id}
                className="shadow-soft hover:shadow-elevated transition-smooth animate-fade-in-up"
                style={{ animationDelay: `${index * 100}ms` }}
              >
                <CardContent className="p-6 sm:p-8">
                  <div className="flex mb-4">
                    {[...Array(testimonial.calificacion)].map((_, i) => (
                      <Star key={i} className="w-5 h-5 fill-primary text-primary" />
                    ))}
                  </div>
                  <p className="text-sm sm:text-base text-muted-foreground leading-relaxed mb-6 italic">
                    "{testimonial.comentario}"
                  </p>
                  <div className="border-t border-border pt-4">
                    <p className="font-semibold text-foreground">{testimonial.nombre}</p>
                    <p className="text-sm text-muted-foreground">{testimonial.rol}</p>
                  </div>
                </CardContent>
              </Card>
            ))
          ) : (
            <div className="col-span-full text-center text-muted-foreground">
              No hay testimonios disponibles aún. ¡Sé el primero en compartir tu experiencia!
            </div>
          )}
        </div>
      </div>
    </section>
  );
};

export default Testimonials;
