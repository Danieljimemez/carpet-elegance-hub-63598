#  Subida de Imágenes de Muebles al Catálogo

##  Estado Actual
  **URLs configuradas:** Usando placeholder.svg temporalmente
  **Sistema funcionando:** Los muebles aparecen en la pestaña "Muebles"

##  Reemplazar Imágenes de Ejemplo con Tus Fotos

### **Método 1: Supabase Dashboard**

1. **Ve a Supabase Dashboard:**
   - https://supabase.com/dashboard/project/bmpahscihwojocyoqhjy
   - Click en **"Storage"** → **`furniture-images`**

2. **Sube tus fotos de muebles:**
   - Click **"Upload Files"**
   - Selecciona todas las fotos de: `C:\Users\Daniel\Desktop\MUEBLES PAGINA`
   - Espera a que se suban

3. **Copia las URLs generadas** para cada imagen
   - Formato: `https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/furniture-images/tu-archivo.jpg`

### **Método 2: Actualizar Base de Datos**

Ejecuta estas consultas SQL en **Table Editor** de Supabase:

```sql
-- Reemplaza las URLs de placeholder con tus imágenes reales

-- Silla Moderna Minimalista
UPDATE furniture_items
SET image_url = 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/gallery-images/silla-moderna.jpg'
WHERE name = 'Silla Moderna Minimalista';

-- Mesa de Centro Rectangular
UPDATE furniture_items
SET image_url = 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/gallery-images/mesa-centro.jpg'
WHERE name = 'Mesa de Centro Rectangular';

-- Sofá de Tres Plazas
UPDATE furniture_items
SET image_url = 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/gallery-images/sofa-3-plazas.jpg'
WHERE name = 'Sofá de Tres Plazas';

-- Y así sucesivamente para cada mueble...
```

### **Método 3: Agregar Nuevos Muebles**

Para agregar muebles nuevos desde cero:

```sql
INSERT INTO furniture_items (name, description, image_url, display_order, is_active)
VALUES (
  'Nombre de tu mueble',
  'Descripción detallada',
  'URL_DE_TU_IMAGEN_EN_SUPABASE',
  11,  -- número mayor para que aparezca primero
  true
);
```

##  Muebles Actualmente en el Sistema

| Nombre | Estado | URL Actual |
|--------|--------|------------|
| Silla Moderna Minimalista |  Activo | placeholder.svg |
| Mesa de Centro Rectangular |  Activo | placeholder.svg |
| Sofá de Tres Plazas |  Activo | placeholder.svg |
| Escritorio Ejecutivo |  Activo | placeholder.svg |
| Cómoda de Dormitorio |  Activo | placeholder.svg |
| Silla de Comedor Clásica |  Activo | placeholder.svg |
| Librero Moderno |  Activo | placeholder.svg |
| Mesa Auxiliar Redonda |  Activo | placeholder.svg |

##  Verificación

Después de actualizar las URLs:

1. **Actualiza tu sitio web** (F5)
2. **Ve a la sección Catálogo**
3. **Click en "Muebles"**
4. **Verás tus fotos reales** en lugar de los placeholders

##  Organización Recomendada

**Renombra tus archivos** antes de subirlos:
- `silla-moderna.jpg`
- `mesa-centro.jpg`
- `sofa-3-plazas.jpg`
- `escritorio-ejecutivo.jpg`
- etc.

##  Resultado Final

Una vez que reemplaces las URLs, **tus muebles aparecerán automáticamente en el catálogo** con la misma funcionalidad que la galería: imágenes responsive, manejo de errores, y orden personalizado.

**¡El sistema está listo para mostrar tus muebles!** 
