# 🪟 **Gestión de Cortinas - Guía Completa**

## 🎯 **Sistema Automático de Cortinas**

La sección "Cortinas" funciona automáticamente con Supabase. Cuando subas imágenes al bucket `curtains-images` e insertes registros en la tabla `curtains_items`, aparecerán automáticamente en la pestaña "Cortinas" del catálogo.

## 📋 **Cómo Agregar Cortinas**

### **Método 1: Supabase Dashboard**

1. **Ve a Supabase Dashboard:**
   - https://supabase.com/dashboard/project/bmpahscihwojocyoqhjy
   - Click en **"Storage"** → **`curtains-images`**

2. **Sube tus fotos de cortinas:**
   - Click **"Upload Files"**
   - Selecciona fotos de cortinas
   - Espera a que se suban

3. **Copia las URLs generadas**

4. **Ve a "Table Editor" → `curtains_items`**

5. **Inserta nuevo registro:**
   ```sql
   INSERT INTO curtains_items (name, description, image_url, size, price, display_order, is_active)
   VALUES (
     'Nombre de tu cortina',
     'Descripción detallada de la cortina',
     'URL_DE_LA_IMAGEN',
     '200 x 250 cm',
     '$1,899',
     10,
     true
   );
   ```

### **Método 2: SQL Directo**

```sql
-- Insertar múltiples cortinas
INSERT INTO public.curtains_items (name, description, image_url, size, price, display_order, is_active) VALUES
('Cortina Voile Elegante', 'Cortina de voile translúcido perfecta para ambientes elegantes. Tejido ligero que permite el paso de luz natural mientras mantiene la privacidad.', 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/curtains-images/voile-elegante.jpg', '200 x 250 cm', '$2,499', 10, true),
('Cortina Blackout Moderna', 'Cortina blackout con control total de luz. Ideal para dormitorios y salas de cine en casa. Bloquea completamente la luz exterior.', 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/curtains-images/blackout-moderna.jpg', '200 x 250 cm', '$3,299', 9, true),
('Cortina Sheer Clásica', 'Cortina sheer con diseño clásico y atemporal. Perfecta para combinar con cualquier decoración interior.', 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/curtains-images/sheer-clasica.jpg', '200 x 250 cm', '$1,899', 8, true);
```

## 📊 **Campos Disponibles**

- **`name`**: Nombre de la cortina (requerido)
- **`description`**: Descripción detallada
- **`image_url`**: URL de la imagen (requerido)
- **`size`**: Dimensiones (ej: "200 x 250 cm")
- **`price`**: Precio (ej: "$2,499")
- **`display_order`**: Orden (números más altos = aparecen primero)
- **`is_active`**: true/false para mostrar/ocultar

## 🎯 **Funcionamiento Automático**

### **¿Cómo funciona?**
1. **Las imágenes se suben** al bucket `curtains-images`
2. **Se insertan registros** en tabla `curtains_items`
3. **Aparecen automáticamente** en pestaña "Cortinas"
4. **Mismo diseño** que otras secciones

### **Beneficios:**
- ✅ **Actualización automática** del catálogo
- ✅ **No requiere cambios** en el código
- ✅ **Manejo de errores** incluido
- ✅ **Animaciones y diseño** consistentes

## 📋 **Gestión de Cortinas**

### **Actualizar Cortina:**
```sql
UPDATE curtains_items
SET price = '$2,799', description = 'Nueva descripción'
WHERE name = 'Cortina Voile Elegante';
```

### **Ocultar Cortina:**
```sql
UPDATE curtains_items SET is_active = false WHERE name = 'Cortina Antigua';
```

### **Reordenar Cortinas:**
```sql
UPDATE curtains_items SET display_order = 20 WHERE name = 'Cortina Destacada';
```

## 🖼️ **Gestión de Imágenes**

### **Subir Nuevas Imágenes:**
```bash
npx supabase storage upload ./cortinas curtains-images --project-ref bmpahscihwojocyoqhjy
```

### **Eliminar Imagen:**
```bash
npx supabase storage remove nombre-imagen.jpg curtains-images --project-ref bmpahscihwojocyoqhjy
```

## 📈 **Estado Actual**

### **Cortinas Disponibles:**
- ✅ **Cortina Voile Elegante** ($2,499)
- ✅ **Cortina Blackout Moderna** ($3,299)
- ✅ **Cortina Sheer Clásica** ($1,899)

### **Funcionalidades:**
- ✅ Carga automática desde Supabase
- ✅ Orden personalizado por display_order
- ✅ Solo cortinas activas se muestran
- ✅ Imágenes con fallback automático

## 🚀 **Próximos Pasos**

1. **Sube tus fotos** de cortinas al bucket `curtains-images`
2. **Actualiza las URLs** en la tabla `curtains_items`
3. **Personaliza** los nombres, precios y descripciones
4. **Verifica** que aparezcan en la pestaña "Cortinas"

**¡Tu catálogo de cortinas está completamente automatizado!** 🪟✨
