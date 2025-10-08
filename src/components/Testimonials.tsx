import { Card, CardContent } from "@/components/ui/card";
import { Star } from "lucide-react";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { toast } from "sonner";

interface Testimonio {
  id: string;
  nombre: string;
  rol: string;
  comentario: string;
  calificacion: number;
}

const testimonialSchema = z.object({
  nombre: z.string().min(2, "El nombre debe tener al menos 2 caracteres"),
  rol: z.string().min(2, "El rol debe tener al menos 2 caracteres"),
  comentario: z.string().min(10, "El comentario debe tener al menos 10 caracteres"),
  calificacion: z.number().min(1).max(5),
});

type TestimonialForm = z.infer<typeof testimonialSchema>;

const Testimonials = () => {
  const [showForm, setShowForm] = useState(false);
  const queryClient = useQueryClient();
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

  const form = useForm<TestimonialForm>({
    resolver: zodResolver(testimonialSchema),
    defaultValues: {
      nombre: "",
      rol: "",
      comentario: "",
      calificacion: 5,
    },
  });

  const onSubmit = async (data: TestimonialForm) => {
    const { error } = await (supabase as any)
      .from('testimonios')
      .insert([data]);

    if (error) {
      console.error("Error inserting testimonial:", error);
      toast.error("Error al enviar el testimonio. Inténtalo de nuevo.");
      return;
    }

    toast.success("¡Gracias por tu testimonio! Se publicará pronto.");
    form.reset();
    setShowForm(false);
    queryClient.invalidateQueries({ queryKey: ['testimonios'] });
  };
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

        <div className="mt-12 text-center">
          {!showForm ? (
            <Button onClick={() => setShowForm(true)} variant="outline">
              Deja tu Testimonio
            </Button>
          ) : (
            <Card className="max-w-2xl mx-auto mt-8">
              <CardContent className="p-6">
                <h3 className="text-xl font-semibold mb-4">Comparte tu Experiencia</h3>
                <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                  <div>
                    <Label htmlFor="nombre">Nombre</Label>
                    <Input
                      id="nombre"
                      {...form.register("nombre")}
                      placeholder="Tu nombre"
                    />
                    {form.formState.errors.nombre && (
                      <p className="text-sm text-red-500 mt-1">{form.formState.errors.nombre.message}</p>
                    )}
                  </div>
                  <div>
                    <Label htmlFor="rol">Rol/Profesión</Label>
                    <Input
                      id="rol"
                      {...form.register("rol")}
                      placeholder="Ej: Arquitecta, Cliente, etc."
                    />
                    {form.formState.errors.rol && (
                      <p className="text-sm text-red-500 mt-1">{form.formState.errors.rol.message}</p>
                    )}
                  </div>
                  <div>
                    <Label htmlFor="comentario">Comentario</Label>
                    <Textarea
                      id="comentario"
                      {...form.register("comentario")}
                      placeholder="Cuéntanos tu experiencia..."
                      rows={4}
                    />
                    {form.formState.errors.comentario && (
                      <p className="text-sm text-red-500 mt-1">{form.formState.errors.comentario.message}</p>
                    )}
                  </div>
                  <div>
                    <Label htmlFor="calificacion">Calificación</Label>
                    <Select
                      onValueChange={(value) => form.setValue("calificacion", parseInt(value))}
                      defaultValue="5"
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Selecciona una calificación" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="5">⭐⭐⭐⭐⭐ (5 estrellas)</SelectItem>
                        <SelectItem value="4">⭐⭐⭐⭐ (4 estrellas)</SelectItem>
                        <SelectItem value="3">⭐⭐⭐ (3 estrellas)</SelectItem>
                        <SelectItem value="2">⭐⭐ (2 estrellas)</SelectItem>
                        <SelectItem value="1">⭐ (1 estrella)</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="flex gap-2">
                    <Button type="submit" disabled={form.formState.isSubmitting}>
                      {form.formState.isSubmitting ? "Enviando..." : "Enviar Testimonio"}
                    </Button>
                    <Button type="button" variant="outline" onClick={() => setShowForm(false)}>
                      Cancelar
                    </Button>
                  </div>
                </form>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </section>
  );
};

export default Testimonials;
