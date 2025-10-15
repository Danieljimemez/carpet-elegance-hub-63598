# 🚀 **Sincronización Automática de Imágenes**

## 🎯 **Sistema de Sincronización Automática**

Ahora puedes subir imágenes a los buckets de Supabase y automáticamente se crearán registros en las tablas correspondientes. ¡No necesitas insertar manualmente!

## 📋 **Cómo Funciona**

### **Método 1: Comando de Sincronización (Recomendado)**

#### **Subir imágenes y sincronizar:**

```bash
# 1. Subir imágenes a los buckets
npx supabase storage upload ./carpets carpeta-alfombras carpets-images --project-ref bmpahscihwojocyoqhjy
npx supabase storage upload ./curtains carpeta-cortinas curtains-images --project-ref bmpahscihwojocyoqhjy
npx supabase storage upload ./furniture carpeta-muebles furniture-images --project-ref bmpahscihwojocyoqhjy
npx supabase storage upload ./monthly carpeta-mensual monthly-updates-images --project-ref bmpahscihwojocyoqhjy
npx supabase storage upload ./gallery carpeta-galeria gallery-images --project-ref bmpahscihwojocyoqhjy

# 2. Sincronizar con las tablas (esto crea los registros automáticamente)
npm run sync-images
```

#### **Ver estado actual:**
```bash
npm run sync-status
```

### **Método 2: Sincronización Manual**

```bash
# Configurar variable de entorno
export SUPABASE_SERVICE_ROLE_KEY="tu-service-role-key"

# Ejecutar sincronización
node sync-images.js

# Ver estado
node sync-images.js status
```

## 🎯 **Mapeo Automático**

| Bucket | Tabla | Campos Automáticos |
|--------|-------|-------------------|
| **`carpets-images`** | `carpets_items` | name, description, image_url, category, size, price |
| **`curtains-images`** | `curtains_items` | name, description, image_url, category, size, price |
| **`furniture-images`** | `furniture_items` | name, description, image_url, category |
| **`monthly-updates-images`** | `monthly_updates` | name, description, image_url, size, price |
| **`gallery-images`** | `gallery_photos` | title, description, image_url |

## 📝 **Nombres de Archivos**

Los nombres de archivos se convierten automáticamente en nombres de productos:

```
"alfombra-moderna.jpg" → "Alfombra Moderna"
"cortina-voile.jpg" → "Cortina Voile"
"silla-oficina.jpg" → "Silla Oficina"
```

## ✅ **Resultado Automático**

Después de ejecutar `npm run sync-images`, se crearán registros como:

### **En `carpets_items`:**
```sql
{
  name: "Alfombra Moderna",
  description: "Alfombra Alombra Moderna - Sincronizada automáticamente",
  image_url: "https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/carpets-images/alfombra-moderna.jpg",
  category: "carpets",
  size: "Consultar",
  price: "Consultar",
  is_active: true,
  display_order: 1703123456789
}
```

## 🔄 **Proceso Completo de Trabajo**

### **Para Alfombras:**
```bash
# 1. Subir imágenes
npx supabase storage upload ./mis-alfombras carpets-images --project-ref bmpahscihwojocyoqhjy

# 2. Sincronizar
npm run sync-images

# 3. Ver en la web: http://localhost:5173 → Catálogo → Alfombras
```

### **Para Todas las Secciones:**
```bash
# Subir a todos los buckets
npx supabase storage upload ./carpets carpets-images --project-ref bmpahscihwojocyoqhjy
npx supabase storage upload ./curtains curtains-images --project-ref bmpahscihwojocyoqhjy
npx supabase storage upload ./furniture furniture-images --project-ref bmpahscihwojocyoqhjy
npx supabase storage upload ./monthly monthly-updates-images --project-ref bmpahscihwojocyoqhjy
npx supabase storage upload ./gallery gallery-images --project-ref bmpahscihwojocyoqhjy

# Sincronizar todo
npm run sync-images

# Verificar
npm run sync-status
```

## 📊 **Comandos Disponibles**

| Comando | Descripción |
|---------|-------------|
| `npm run sync-images` | Sincroniza todas las imágenes con las tablas |
| `npm run sync-status` | Muestra el estado actual de todas las tablas |
| `node sync-images.js` | Sincronización manual completa |
| `node sync-images.js status` | Estado manual de tablas |

## 🎯 **Beneficios**

- ✅ **Actualización automática** - Sube y sincroniza
- ✅ **No tocar código** - Todo automático
- ✅ **Nombres inteligentes** - De archivos a productos
- ✅ **Campos completos** - Descripción, precio, etc.
- ✅ **Múltiples buckets** - Cada sección separada
- ✅ **Estado visible** - Ver qué hay en cada tabla

## 🚀 **Próximos Pasos**

1. **Sube tus imágenes** a los buckets correspondientes
2. **Ejecuta** `npm run sync-images`
3. **Ve a tu sitio web** y verifica que aparezcan automáticamente
4. **Edita los registros** en Supabase si necesitas ajustar precios/descripciones

**¡Tu catálogo ahora se actualiza automáticamente!** 🎉✨
