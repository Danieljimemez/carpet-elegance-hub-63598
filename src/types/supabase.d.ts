import { Database as BaseDatabase } from "@/integrations/supabase/types";

declare global {
  namespace Supabase {
    interface ContactRequest {
      id?: string;
      created_at?: string;
      updated_at?: string;
      name: string;
      email: string;
      phone?: string | null;
      subject: string;
      message: string;
      status?: 'new' | 'in_progress' | 'resolved' | 'spam';
      custom_size?: string | null;
    }

    interface Testimonial {
      id?: string;
      created_at?: string;
      updated_at?: string;
      author_name: string;
      author_role?: string | null;
      content: string;
      rating: number;
      is_approved?: boolean;
      status?: 'pending' | 'approved' | 'rejected';
    }
  }

  // Extender la interfaz global de Window para incluir los tipos de Supabase
  interface Window {
    Supabase: typeof Supabase;
  }
}

// Extender los tipos de Supabase
declare module "@/integrations/supabase/types" {
  export interface Database extends BaseDatabase {
    public: {
      Tables: {
        contact_requests: {
          Row: Supabase.ContactRequest;
          Insert: Omit<Supabase.ContactRequest, 'id' | 'created_at' | 'updated_at'>;
          Update: Partial<Supabase.ContactRequest>;
        };
        testimonials: {
          Row: Supabase.Testimonial;
          Insert: Omit<Supabase.Testimonial, 'id' | 'created_at' | 'updated_at'>;
          Update: Partial<Supabase.Testimonial>;
        };
      };
    };
  }
}
