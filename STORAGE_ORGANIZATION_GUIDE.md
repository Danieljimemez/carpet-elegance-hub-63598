# 🗂️ **Sistema de Storage Organizado por Secciones**


Para tener mejor control y organización, hemos creado **buckets separados** para cada sección de tu página:

### **📦 Buckets Disponibles:**

| Bucket | Propósito | Sección |
|--------|-----------|---------|
| **`gallery-images`** | Imágenes de la galería principal | Galería |
| **`carpets-images`** | Fotos de alfombras del catálogo | Catálogo → Alfombras |
| **`curtains-images`** | Fotos de cortinas del catálogo | Catálogo → Cortinas |
| **`monthly-updates-images`** | Imágenes de actualizaciones mensuales | Actualización Mensual |

---

### **🪑 Muebles (furniture-images)**
```bash
# Subir fotos de muebles
npx supabase storage upload carpeta-muebles furniture-images --project-ref bmpahscihwojocyoqhjy

# URL generada:
https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/furniture-images/nombre-mueble.jpg
```

### **🧵 Alfombras (carpets-images)**
```bash
# Subir fotos de alfombras
npx supabase storage upload carpeta-alfombras carpets-images --project-ref bmpahscihwojocyoqhjy

# URL generada:
https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/carpets-images/alfombra.jpg
```

### **🪟 Cortinas (curtains-images)**
```bash
# Subir fotos de cortinas
npx supabase storage upload carpeta-cortinas curtains-images --project-ref bmpahscihwojocyoqhjy

# URL generada:
https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/curtains-images/cortina.jpg
```

### **📅 Actualizaciones Mensuales (monthly-updates-images)**
```bash
# Subir imágenes de productos mensuales
npx supabase storage upload carpeta-mensual monthly-updates-images --project-ref bmpahscihwojocyoqhjy
https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/monthly-updates-images/producto-mensual.jpg
```

### **🧵 Catálogo (catalog-images)**
```bash
# Subir alfombras y cortinas
npx supabase storage upload carpeta-catalog catalog-images --project-ref bmpahscihwojocyoqhjy

# URL generada:
https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/catalog-images/alfombra.jpg
```

---

## 🔐 **Políticas de Seguridad**

### **Acceso Público:**
- ✅ **Lectura:** Todos pueden ver las imágenes
- 🔒 **Escritura:** Solo usuarios autenticados pueden subir/modificar

### **Políticas RLS:**
Cada bucket tiene políticas específicas que permiten:
- **Acceso público** para ver imágenes
- **Subida autenticada** para agregar/modificar
- **Control granular** por sección

---

## 📊 **Gestión por Sección**

### **Actualizar URLs en Base de Datos:**

#### **Para Muebles:**
```sql
UPDATE furniture_items
SET image_url = 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/furniture-images/tu-imagen.jpg'
WHERE name = 'Nombre del Mueble';
```

#### **Para Actualizaciones Mensuales:**
```sql
UPDATE monthly_updates
SET image_url = 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/monthly-updates-images/tu-imagen.jpg'
WHERE name = 'Nombre del Producto';
```

#### **Para Galería (ya existente):**
```sql
UPDATE gallery_photos
SET image_url = 'https://bmpahscihwojocyoqhjy.supabase.co/storage/v1/object/public/gallery-images/tu-imagen.jpg'
WHERE name = 'Nombre de la Foto';
```

---

## 🗂️ **Organización Recomendada**

### **Estructura de Carpetas Locales:**
```
📁 tu-proyecto/
├── 📁 images/
│   ├── 📁 gallery/          # Fotos para galería
│   ├── 📁 carpets/          # Fotos de alfombras
│   ├── 📁 furniture/        # Fotos de muebles
│   ├── 📁 curtains/         # Fotos de cortinas
│   └── 📁 monthly/          # Productos mensuales
```

### **Nombres de Archivos:**
- `gallery-001.jpg`, `gallery-002.jpg`
- `silla-moderna.jpg`, `mesa-centro.jpg`
- `producto-octubre-2024.jpg`
- `alfombra-shag-crema.jpg`

---

## 🚀 **Beneficios del Sistema Organizado**

### **✅ Ventajas:**
- **🔍 Mejor organización** de archivos
- **🛡️ Control de permisos** por sección
- **📈 Escalabilidad** para nuevas secciones
- **🔒 Seguridad granular** por bucket
- **📊 Gestión independiente** de cada área
- **🎯 Optimización** del rendimiento

### **📈 Futuras Expansiones:**
- Fácil agregar nuevos buckets para nuevas secciones
- Políticas específicas por tipo de contenido
- Control de tamaño y tipo de archivos por sección

---

## 🛠️ **Comandos Útiles**
### **Verificar Buckets:**
```bash
npx supabase storage list --project-ref bmpahscihwojocyoqhjy
```

### **Subida Automática:**
```bash
# Galería
npx supabase storage upload ./images/gallery gallery-images --project-ref bmpahscihwojocyoqhjy

# Alfombras
npx supabase storage upload ./images/carpets carpets-images --project-ref bmpahscihwojocyoqhjy

# Muebles
npx supabase storage upload ./images/furniture furniture-images --project-ref bmpahscihwojocyoqhjy

# Cortinas
npx supabase storage upload ./images/curtains curtains-images --project-ref bmpahscihwojocyoqhjy

# Mensual
npx supabase storage upload ./images/monthly monthly-updates-images --project-ref bmpahscihwojocyoqhjy
```

### **Eliminar Archivos:**
```bash
npx supabase storage remove nombre-del-archivo bucket-name --project-ref bmpahscihwojocyoqhjy
```

---

## 📋 **Checklist de Implementación**

- ✅ **Buckets creados** y configurados
- ✅ **Políticas RLS** aplicadas
- ✅ **URLs actualizadas** en base de datos
- ✅ **Organización local** preparada
- ✅ **Documentación** completa

**¡Tu sistema de storage está completamente organizado!** 🗂️✨
