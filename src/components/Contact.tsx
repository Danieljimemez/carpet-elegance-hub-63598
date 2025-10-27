import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent } from "@/components/ui/card";
import { toast } from "sonner";
import { supabase } from "@/integrations/supabase/client";

const Contact = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    message: "",
    customSize: ""
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validación básica
    if (!formData.name || !formData.email || !formData.message) {
      toast.error("Por favor completa todos los campos requeridos");
      return;
    }

    try {
      // Mostrar indicador de carga
      const loadingToast = toast.loading("Enviando mensaje...");
      
      // Guardar en la base de datos
      const { data, error } = await (supabase as any)
        .from('contact_requests')
        .insert([{
          name: formData.name.trim(),
          email: formData.email.trim(),
          phone: formData.phone?.trim() || null,
          message: formData.message.trim(),
          subject: formData.customSize ? `Medida personalizada: ${formData.customSize}` : 'Consulta general',
          status: 'new'
        }])
        .select();

      // Cerrar el toast de carga
      toast.dismiss(loadingToast);

      if (error) {
        console.error('Error al guardar contacto:', error);
        toast.error(`Error al enviar el mensaje: ${error.message}`);
        return;
      }

      // Mostrar mensaje de éxito
      toast.success("¡Mensaje enviado con éxito!", {
        description: "Nos pondremos en contacto contigo pronto.",
      });

      // Restablecer el formulario
      setFormData({
        name: "",
        email: "",
        phone: "",
        message: "",
        customSize: ""
      });

    } catch (error) {
      console.error('Error inesperado:', error);
      toast.error("Ocurrió un error inesperado. Por favor, inténtalo de nuevo.");
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  return (
    <section id="contacto" className="py-16 sm:py-20 lg:py-32 bg-background">
      <div className="container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12 sm:mb-16 animate-fade-in">
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-serif font-bold text-foreground mb-4">
            Contáctanos
          </h2>
          <p className="text-base sm:text-lg text-muted-foreground max-w-2xl mx-auto">
            ¿Necesitas una alfombra con medidas especiales? Estamos aquí para ayudarte.
          </p>
        </div>

        <div className="max-w-2xl mx-auto">
          <Card className="shadow-elevated animate-scale-in">
            <CardContent className="p-6 sm:p-8 lg:p-10">
              <form onSubmit={handleSubmit} className="space-y-6">
                <div>
                  <label htmlFor="name" className="block text-sm font-medium text-foreground mb-2">
                    Nombre completo *
                  </label>
                  <Input
                    id="name"
                    name="name"
                    type="text"
                    value={formData.name}
                    onChange={handleChange}
                    placeholder="Tu nombre"
                    required
                    className="w-full"
                  />
                </div>

                <div>
                  <label htmlFor="email" className="block text-sm font-medium text-foreground mb-2">
                    Correo electrónico *
                  </label>
                  <Input
                    id="email"
                    name="email"
                    type="email"
                    value={formData.email}
                    onChange={handleChange}
                    placeholder="tu@email.com"
                    required
                    className="w-full"
                  />
                </div>

                <div>
                  <label htmlFor="phone" className="block text-sm font-medium text-foreground mb-2">
                    Teléfono
                  </label>
                  <Input
                    id="phone"
                    name="phone"
                    type="tel"
                    value={formData.phone}
                    onChange={handleChange}
                    placeholder="+52 123 456 7890"
                    className="w-full"
                  />
                </div>

                <div className="space-y-2">
                  <label htmlFor="customSize">Medidas Especiales (opcional)</label>
                  <Input
                    id="customSize"
                    value={formData.customSize}
                    onChange={(e) =>
                      setFormData({ ...formData, customSize: e.target.value })
                    }
                    placeholder="Ej: 2m x 3m"
                    className="w-full"
                  />
                </div>

                <div>
                  <label htmlFor="message" className="block text-sm font-medium text-foreground mb-2">
                    Mensaje *
                  </label>
                  <Textarea
                    id="message"
                    name="message"
                    value={formData.message}
                    onChange={handleChange}
                    placeholder="Cuéntanos sobre tu proyecto..."
                    required
                    rows={5}
                    className="w-full resize-none"
                  />
                </div>

                <Button type="submit" className="w-full py-6 text-lg shadow-soft hover:shadow-elevated transition-smooth">
                  Enviar Solicitud
                </Button>
              </form>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  );
};

export default Contact;
