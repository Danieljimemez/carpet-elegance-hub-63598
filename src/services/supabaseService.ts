// Import the existing supabase client instance and createClient
import { createClient } from '@supabase/supabase-js';
import { supabase as _supabase } from '@/integrations/supabase/client';

// Type override to include all tables
type OverrideTypes = {
  public: {
    Tables: {
      gallery_photos: { Row: any; Insert: any; Update: any };
      furniture_items: { Row: any; Insert: any; Update: any };
      monthly_updates: { Row: any; Insert: any; Update: any };
      carpets_items: { Row: any; Insert: any; Update: any };
      curtains_items: { Row: any; Insert: any; Update: any };
      promo_banner: { Row: any; Insert: any; Update: any };
      testimonials: { Row: any; Insert: any; Update: any };
      contact_requests: { Row: any; Insert: any; Update: any };
    };
  };
};

// Cast the supabase client with our overridden types
export const supabase = _supabase as unknown as ReturnType<typeof createClient<OverrideTypes>>;

export const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || '';

// Base interface that all table types should extend
interface BaseTable {
  id: string;
  created_at: string;
  updated_at: string;
  [key: string]: any; // Allow any additional properties
}

// Table names as const for better type safety
const TABLE_NAMES = {
  GALLERY_PHOTOS: 'gallery_photos',
  FURNITURE_ITEMS: 'furniture_items',
  MONTHLY_UPDATES: 'monthly_updates',
  CARPET_ITEMS: 'carpets_items',
  CURTAIN_ITEMS: 'curtains_items',
  PROMO_BANNERS: 'promo_banner',
  TESTIMONIALS: 'testimonials',
  CONTACT_REQUESTS: 'contact_requests'
} as const;

type TableName = typeof TABLE_NAMES[keyof typeof TABLE_NAMES];

// Función para obtener la URL pública de una imagen
export const getImageUrl = (bucket: string, path: string): string => {
  if (!path) return '';
  
  const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
  if (!supabaseUrl) {
    console.error('La URL de Supabase no está configurada');
    return '';
  }

  // Si la ruta ya es una URL completa con el dominio correcto, devolverla tal cual
  if (path.includes(supabaseUrl)) {
    return path;
  }

  // Si es una URL completa pero con un dominio diferente, reconstruirla
  if (path.startsWith('http')) {
    try {
      const url = new URL(path);
      // Extraer la ruta después de /storage/v1/object/public/
      const pathParts = url.pathname.split('/storage/v1/object/public/');
      if (pathParts.length > 1) {
        return `${supabaseUrl}/storage/v1/object/public/${pathParts[1]}`;
      }
      // Si la ruta no coincide con el formato esperado, usar solo el nombre del archivo
      const fileName = url.pathname.split('/').pop() || '';
      return `${supabaseUrl}/storage/v1/object/public/${bucket}/${encodeURIComponent(fileName)}`;
    } catch (e) {
      console.error('Error al analizar la URL de la imagen:', e);
      // Usar solo la última parte de la ruta
      const fileName = path.split('/').pop() || '';
      return `${supabaseUrl}/storage/v1/object/public/${bucket}/${encodeURIComponent(fileName)}`;
    }
  }

  // Para rutas relativas, limpiarlas
  const cleanPath = path
    .replace(/^\/+|\/+$/g, '') // Eliminar barras al inicio/final
    .replace(/^storage\/v1\/object\/public\/[^/]+\//, '') // Eliminar cualquier prefijo de almacenamiento existente
    .replace(/^public\//, ''); // Eliminar prefijo 'public/' si existe

  // Codificar el nombre del archivo para manejar espacios y caracteres especiales
  const encodedPath = cleanPath.split('/').map(segment => encodeURIComponent(segment)).join('/');
  
  // Construir la URL completa
  return `${supabaseUrl}/storage/v1/object/public/${bucket}/${encodedPath}`;
};

// Define types for our database tables
export interface GalleryPhoto {
  id: string;
  title: string;
  description?: string;
  image_url: string;
  set_name?: string;
  alt_text?: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface PromoBanner {
  id: string;
  title: string;
  description?: string;
  image_url: string;
  alt_text?: string;
  path?: string;
  display_order: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface ProductItem {
  id: string;
  name: string;
  description?: string;
  image_url: string;
  size?: string;
  price: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface MonthlyUpdate {
  id: string;
  title: string;
  description?: string;
  image_url: string;
  content?: string;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Testimonial {
  id: string;
  author_name: string;
  author_role?: string;
  content: string;
  rating?: number;
  is_approved: boolean;
  created_at: string;
  updated_at: string;
}

export interface ContactRequest {
  id: string;
  name: string;
  email: string;
  phone?: string;
  subject?: string;
  message: string;
  status: 'new' | 'in_progress' | 'resolved' | 'spam';
  created_at: string;
  updated_at: string;
}

async function fetchFromTable<T extends Record<string, any>>(
  tableName: TableName,
  options: {
    activeOnly?: boolean;
    orderBy?: string;
    ascending?: boolean;
  } = {}
): Promise<T[]> {
  const { 
    activeOnly = false,
    orderBy,
    ascending = true 
  } = options;
  
  try {
    // Create base query
    let query = supabase
      .from(tableName)
      .select('*');
    
    // Apply active filter if needed
    if (activeOnly) {
      query = query.eq('is_active', true);
    }
    
    // Apply ordering if specified
    if (orderBy) {
      query = query.order(orderBy, { ascending });
    }
    
    // Execute the query
    const { data, error } = await query;

    if (error) {
      console.error(`Error fetching from ${tableName}:`, error);
      return [];
    }

    return data || [];
  } catch (error) {
    console.error(`Unexpected error in fetchFromTable for ${tableName}:`, error);
    return [];
  }
}

// Export typed fetch functions
export const fetchGalleryPhotos = (): Promise<GalleryPhoto[]> => {
  return fetchFromTable<GalleryPhoto>(TABLE_NAMES.GALLERY_PHOTOS, { 
    activeOnly: true,
    orderBy: 'display_order',
    ascending: true 
  });
};

export const fetchCarpets = (): Promise<ProductItem[]> => {
  return fetchFromTable<ProductItem>(TABLE_NAMES.CARPET_ITEMS, { 
    activeOnly: true 
  });
};

// Fetch curtains - no active filter and no specific order
export const fetchCurtains = (): Promise<ProductItem[]> => {
  return fetchFromTable<ProductItem>(TABLE_NAMES.CURTAIN_ITEMS);
};

// Fetch furniture - no active filter and no specific order
export const fetchFurniture = (): Promise<ProductItem[]> => {
  return fetchFromTable<ProductItem>(TABLE_NAMES.FURNITURE_ITEMS, {
    activeOnly: true
  });
};

// Fetch promotional banners - with active filter and ordered by display order
export const fetchPromoBanners = (): Promise<PromoBanner[]> => {
  return fetchFromTable<PromoBanner>(TABLE_NAMES.PROMO_BANNERS, { 
    activeOnly: true,
    orderBy: 'display_order',
    ascending: true 
  });
};

// Fetch monthly updates - ordered by creation date (newest first)
export const fetchMonthlyUpdates = (): Promise<MonthlyUpdate[]> => {
  return fetchFromTable<MonthlyUpdate>(TABLE_NAMES.MONTHLY_UPDATES, { 
    activeOnly: true,
    orderBy: 'created_at',
    ascending: false 
  });
};

// Fetch testimonials - only active, ordered by creation date (newest first)
export const fetchTestimonials = (): Promise<Testimonial[]> => {
  return fetchFromTable<Testimonial>(TABLE_NAMES.TESTIMONIALS, {
    activeOnly: true,
    orderBy: 'created_at',
    ascending: false
  });
};

// Fetch contact requests - ordered by creation date (newest first)
export const fetchContactRequests = (): Promise<ContactRequest[]> => {
  return fetchFromTable<ContactRequest>(TABLE_NAMES.CONTACT_REQUESTS, {
    orderBy: 'created_at',
    ascending: false
  });
};
