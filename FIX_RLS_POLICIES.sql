-- Asegurar políticas de lectura pública para todas las tablas del catálogo
DROP POLICY IF EXISTS "Allow public read gallery" ON gallery_photos;
DROP POLICY IF EXISTS "Allow public read carpets" ON carpets_items;
DROP POLICY IF EXISTS "Allow public read curtains" ON curtains_items;
DROP POLICY IF EXISTS "Allow public read furniture" ON furniture_items;
DROP POLICY IF EXISTS "Allow public read monthly" ON monthly_updates;

-- Políticas de lectura pública
CREATE POLICY "Allow public read gallery" ON gallery_photos FOR SELECT USING (true);
CREATE POLICY "Allow public read carpets" ON carpets_items FOR SELECT USING (true);
CREATE POLICY "Allow public read curtains" ON curtains_items FOR SELECT USING (true);
CREATE POLICY "Allow public read furniture" ON furniture_items FOR SELECT USING (true);
CREATE POLICY "Allow public read monthly" ON monthly_updates FOR SELECT USING (true);

-- Verificar políticas
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename IN ('gallery_photos', 'carpets_items', 'curtains_items', 'furniture_items', 'monthly_updates')
ORDER BY tablename, policyname;
