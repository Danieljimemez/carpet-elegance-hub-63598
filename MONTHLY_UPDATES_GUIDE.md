# 📅 Actualización Mensual - Guía Completa

## 🎯 Sistema de Actualización Mensual

La sección "Actualización Mensual" ahora funciona dinámicamente con Supabase. Puedes actualizar los productos mensuales fácilmente desde la base de datos.

## 📋 Cómo Actualizar Mensualmente

### **Método 1: Supabase Dashboard**

1. **Accede a Supabase:**
   - https://supabase.com/dashboard/project/bmpahscihwojocyoqhjy
   - Ve a **"Table Editor"**

2. **Abre tabla `monthly_updates`:**
   - Selecciona la tabla de la lista

3. **Opciones de actualización:**

#### **Para agregar productos nuevos:**
- Click **"Insert"**
- Llena los campos:
  ```sql
  name: "Nombre del producto"
  description: "Descripción detallada"
  image_url: "URL de la imagen"
  size: "200 x 300 cm"
  price: "$4,299"
  display_order: 10 (número mayor = aparece primero)
  is_active: true
  ```

#### **Para editar productos existentes:**
- Click en la fila del producto
- Modifica los campos necesarios
- Click **"Save"**

#### **Para ocultar productos:**
- Cambia `is_active` a `false`
- El producto dejará de mostrarse

#### **Para reordenar productos:**
- Modifica `display_order` (números más altos aparecen primero)

### **Método 2: SQL Directo**

Ejecuta consultas SQL en el **SQL Editor** de Supabase:

```sql
-- Agregar nuevo producto
INSERT INTO monthly_updates (name, description, image_url, size, price, display_order, is_active)
VALUES ('Nuevo Producto', 'Descripción', 'URL_IMAGEN', '200x300cm', '$4,299', 11, true);

-- Actualizar producto existente
UPDATE monthly_updates
SET price = '$4,499', description = 'Nueva descripción'
WHERE name = 'Shag Luxury Crema';

-- Ocultar producto
UPDATE monthly_updates SET is_active = false WHERE name = 'Producto Antiguo';

-- Reordenar productos
## 🖼️ Gestión de Imágenes

### **Subir Imágenes:**
1. Ve a **"Storage"** → **`monthly-updates-images`**
2. Click **"Upload Files"**
3. Selecciona las imágenes de productos mensuales
4. Copia las URLs generadas para usar en `image_url`

### **Convención de Nombres Recomendada:**
- `mes-año-nombre-producto.jpg`
- `ejemplo: 2024-10-shag-luxury-crema.jpg`

## 📊 Estado Actual

### **Productos en la Base de Datos:**
- ✅ **Shag Luxury Crema** - Activo
- ✅ **Acuarela Contemporánea** - Activo
- ✅ **Persa Tradicional** - Activo

### **Funcionalidades:**
- ✅ Carga automática desde Supabase
- ✅ Manejo de errores de imágenes
- ✅ Fallback a placeholder
- ✅ Orden personalizado
- ✅ Solo productos activos se muestran

## 📅 Rutina Mensual Recomendada

### **Cada mes:**
1. **Revisa productos actuales** en Supabase Dashboard
2. **Oculta productos antiguos** (`is_active = false`) o elimínalos
3. **Sube nuevas imágenes** de productos mensuales
4. **Inserta nuevos registros** con productos actuales
5. **Ajusta display_order** para destacar productos importantes
6. **Verifica en el sitio web** que se muestren correctamente

## 🔧 Configuración Avanzada

### **Campos Disponibles:**
- `name`: Nombre del producto (requerido)
- `description`: Descripción detallada (opcional)
- `image_url`: URL de la imagen (requerido)
- `size`: Dimensiones (ej: "200 x 300 cm")
- `price`: Precio (ej: "$4,299")
- `display_order`: Orden de aparición (números más altos primero)
- `is_active`: true/false para mostrar/ocultar

### **Filtros y Ordenamiento:**
- Solo productos con `is_active = true` se muestran
- Ordenados por `display_order` descendente
- Máximo 2 productos por fila (responsive)

## 🚀 Automatización Futura

Para automatizar aún más, podrías:
- Crear un panel administrativo
- Programar actualizaciones automáticas
- Integrar con sistemas de inventario
- Conectar con APIs de proveedores

## ✅ Verificación

Después de cada actualización mensual:

1. **Actualiza la página** de tu sitio web
2. **Desplázate a "Actualización Mensual"**
3. **Verifica que aparezcan los productos correctos**
4. **Comprueba que las imágenes carguen bien**
5. **Confirma precios y descripciones**

**¡Tu sección de actualización mensual está lista para contenido dinámico!** 🎉📅
