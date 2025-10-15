# 🧵 **Gestión de Alfombras - Guía Completa**

## 🎯 **Sistema Automático de Alfombras**

La sección "Alfombras" funciona automáticamente con Supabase. Cuando subas imágenes al bucket `carpets-images` e insertes registros en la tabla `carpets_items`, aparecerán automáticamente en la pestaña "Alfombras" del catálogo.

## 📋 **Cómo Agregar Alfombras**

### **Método 1: Supabase Dashboard**

1. **Ve a Supabase Dashboard:**
   - https://supabase.com/dashboard/project/bmpahscihwojocyoqhjy
   - Click en **"Storage"** → **`carpets-images`**

2. **Sube tus fotos de alfombras:**
   - Click **"Upload Files"**
   - Selecciona fotos de alfombras
   - Espera a que se suban

3. **Copia las URLs generadas**

4. **Ve a "Table Editor" → `carpets_items`**

5. **Inserta nuevo registro:**
   ```sql
   INSERT INTO carpets_items (name, description, image_url, size, price, display_order, is_active)
   VALUES (
     'Nombre de tu alfombra',
     'Descripción detallada de la alfombra',
     'URL_DE_LA_IMAGEN',
     '200 x 300 cm',
     '$2,999',
     10,
     true
   );
   ```

### **Método 2: SQL Directo**

```sql
-- Insertar múltiples alfombras
INSERT INTO public.carpets_items (name, description, image_url, size, price, display_order, is_active) VALUES
('Alfombra Shag Moderna', 'Alfombra shag ultra suave con textura larga perfecta para salas contemporáneas.', 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/carpets-images/shag-moderna.jpg', '200 x 300 cm', '$4,299', 10, true),
('Alfombra Persa Tradicional', 'Alfombra persa artesanal con patrones tradicionales y colores cálidos.', 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/carpets-images/persa.jpg', '250 x 350 cm', '$5,499', 9, true),
('Alfombra Geométrica', 'Diseño geométrico moderno perfecto para espacios minimalistas.', 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/carpets-images/geometrica.jpg', '180 x 270 cm', '$3,899', 8, true);
```

## 📊 **Campos Disponibles**

- **`name`**: Nombre de la alfombra (requerido)
- **`description`**: Descripción detallada
- **`image_url`**: URL de la imagen (requerido)
- **`size`**: Dimensiones (ej: "200 x 300 cm")
- **`price`**: Precio (ej: "$4,299")
- **`display_order`**: Orden (números más altos = aparecen primero)
- **`is_active`**: true/false para mostrar/ocultar

## 🎯 **Funcionamiento Automático**

### **¿Cómo funciona?**
1. **Las imágenes se suben** al bucket `carpets-images`
2. **Se insertan registros** en tabla `carpets_items`
3. **Aparecen automáticamente** en pestaña "Alfombras"
4. **Mismo diseño** que otras secciones

### **Beneficios:**
- ✅ **Actualización automática** del catálogo
- ✅ **No requiere cambios** en el código
- ✅ **Manejo de errores** incluido
- ✅ **Animaciones y diseño** consistentes

## 📋 **Gestión de Alfombras**

### **Actualizar Alfombra:**
```sql
UPDATE carpets_items
SET price = '$4,499', description = 'Nueva descripción'
WHERE name = 'Alfombra Shag Moderna';
```

### **Ocultar Alfombra:**
```sql
UPDATE carpets_items SET is_active = false WHERE name = 'Alfombra Antigua';
```

### **Reordenar Alfombras:**
```sql
UPDATE carpets_items SET display_order = 20 WHERE name = 'Alfombra Destacada';
```

## 🖼️ **Gestión de Imágenes**

### **Subir Nuevas Imágenes:**
```bash
npx supabase storage upload ./alfombras carpets-images --project-ref bmpahscihwojocyoqhjy
```

### **Eliminar Imagen:**
```bash
npx supabase storage remove nombre-imagen.jpg carpets-images --project-ref bmpahscihwojocyoqhjy
```

## 📈 **Estado Actual**

### **Alfombras Disponibles:**
- ✅ **Alfombra Moderna Minimalista** ($4,299)
- ✅ **Alfombra Geométrica** ($3,899)
- ✅ **Alfombra Tradicional** ($5,499)

### **Funcionalidades:**
- ✅ Carga automática desde Supabase
- ✅ Orden personalizado por display_order
- ✅ Solo alfombras activas se muestran
- ✅ Imágenes con fallback automático

## 🚀 **Próximos Pasos**

1. **Sube tus fotos** de alfombras al bucket `carpets-images`
2. **Actualiza las URLs** en la tabla `carpets_items`
3. **Personaliza** los nombres, precios y descripciones
4. **Verifica** que aparezcan en la pestaña "Alfombras"

**¡Tu catálogo de alfombras está completamente automatizado!** 🧵✨
