import { resizeImage } from '@/utils/imageResize';

// Ejemplo de uso en componente de subida
const handleFileUpload = async (files: FileList) => {
  const processedFiles = await Promise.all(
    Array.from(files).map(async (file) => {
      // Solo procesar imágenes
      if (file.type.startsWith('image/')) {
        try {
          // Redimensionar automáticamente a 500x500 manteniendo proporción
          const resizedFile = await resizeImage(file, 500, 500);
          console.log(`Imagen ${file.name} redimensionada de ${file.size} a ${resizedFile.size} bytes`);
          return resizedFile;
        } catch (error) {
          console.warn(`Error procesando ${file.name}:`, error);
          return file; // Usar original si falla
        }
      }
      return file;
    })
  );

  // Subir archivos procesados a Supabase
  // ... código de subida
};
