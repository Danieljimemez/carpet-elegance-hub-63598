import { Database } from "@/integrations/supabase/types";

type Tables = Database['public']['Tables'];

export type ContactRequest = Tables['contact_requests']['Insert'];
export type Testimonial = Tables['testimonials']['Insert'];

// Extender las tablas existentes
declare module "@/integrations/supabase/types" {
  export interface Database {
    public: {
      Tables: {
        contact_requests: {
          Row: {
            id: string;
            created_at: string;
            updated_at: string;
            name: string;
            email: string;
            phone: string | null;
            subject: string;
            message: string;
            status: 'new' | 'in_progress' | 'resolved' | 'spam';
            custom_size?: string | null;
          };
          Insert: Omit<{
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
          }, 'id' | 'created_at' | 'updated_at'>;
          Update: Partial<{
            name: string;
            email: string;
            phone: string | null;
            subject: string;
            message: string;
            status: 'new' | 'in_progress' | 'resolved' | 'spam';
            custom_size?: string | null;
            updated_at?: string;
          }>;
        };
        testimonials: {
          Row: {
            id: string;
            created_at: string;
            updated_at: string;
            author_name: string;
            author_role: string | null;
            content: string;
            rating: number;
            is_approved: boolean;
            status: 'pending' | 'approved' | 'rejected';
          };
          Insert: Omit<{
            id?: string;
            created_at?: string;
            updated_at?: string;
            author_name: string;
            author_role?: string | null;
            content: string;
            rating: number;
            is_approved?: boolean;
            status?: 'pending' | 'approved' | 'rejected';
          }, 'id' | 'created_at' | 'updated_at'>;
          Update: Partial<{
            author_name: string;
            author_role: string | null;
            content: string;
            rating: number;
            is_approved: boolean;
            status: 'pending' | 'approved' | 'rejected';
            updated_at?: string;
          }>;
        };
      };
    };
  }
}
