-- Función de test sin "extensions."
CREATE OR REPLACE FUNCTION test_edge_function()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result TEXT;
BEGIN
  SELECT content INTO result FROM http((
    'POST',
    'https://geppdtgvymykuycrfkdf.supabase.co/functions/v1/auto-update-tables',
    ARRAY[http_header('Content-Type', 'application/json')],
    'application/json',
    '{"test": "hello"}'
  ));
  
  RETURN result;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'ERROR: ' || SQLERRM;
END;
$$;

-- Probar
SELECT test_edge_function();
