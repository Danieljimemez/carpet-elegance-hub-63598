-- Create contacts table
CREATE TABLE public.contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  message TEXT NOT NULL,
  custom_size TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL
);

-- Enable RLS
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;

-- Create policy for public insert
CREATE POLICY "Anyone can insert contacts"
ON public.contacts
FOR INSERT
WITH CHECK (true);

-- Create index for better performance
CREATE INDEX idx_contacts_created_at ON public.contacts(created_at DESC);
