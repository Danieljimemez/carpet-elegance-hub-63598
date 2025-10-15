-- Habilitar extensión pg_net para HTTP calls
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Verificar que se habilitó
SELECT * FROM pg_extension WHERE extname = 'pg_net';
