// Script para sincronizar imágenes de storage con tablas
// Ejecutar con: node sync-images.js

const { createClient } = require('@supabase/supabase-js')

const supabaseUrl = 'https://bmpahscihwojocyoqhjy.supabase.co'
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseKey) {
  console.error('Error: SUPABASE_SERVICE_ROLE_KEY environment variable is required')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseKey)

const bucketToTableMap = {
  'carpets-images': 'carpets_items',
  'curtains-images': 'curtains_items',
  'furniture-images': 'furniture_items',
  'monthly-updates-images': 'monthly_updates',
  'gallery-images': 'gallery_photos',
}

async function syncBucket(bucketId, tableName) {
  console.log(`\n🔄 Sincronizando bucket: ${bucketId} → tabla: ${tableName}`)

  try {
    // Obtener lista de archivos del bucket
    const { data: files, error: listError } = await supabase.storage
      .from(bucketId)
      .list('', { limit: 1000 })

    if (listError) {
      console.error(`Error listando archivos en ${bucketId}:`, listError)
      return
    }

    if (!files || files.length === 0) {
      console.log(`📁 No hay archivos en el bucket ${bucketId}`)
      return
    }

    // Obtener registros existentes en la tabla
    const { data: existingRecords, error: selectError } = await supabase
      .from(tableName)
      .select('image_url')

    if (selectError) {
      console.error(`Error consultando tabla ${tableName}:`, selectError)
      return
    }

    const existingUrls = new Set(existingRecords.map(record => record.image_url))

    let newFilesCount = 0

    for (const file of files) {
      if (file.name) {
        // Generar URL pública
        const { data: { publicUrl } } = supabase.storage
          .from(bucketId)
          .getPublicUrl(file.name)

        // Verificar si ya existe
        if (existingUrls.has(publicUrl)) {
          console.log(`⏭️  Ya existe: ${file.name}`)
          continue
        }

        // Crear nombre del producto
        const productName = file.name.replace(/\.[^/.]+$/, "").replace(/[-_]/g, " ").replace(/\b\w/g, l => l.toUpperCase())

        // Preparar datos para insertar
        let insertData = {
          name: productName,
          image_url: publicUrl,
          is_active: true,
          display_order: Date.now(),
        }

        // Personalizar según tabla
        switch (tableName) {
          case 'carpets_items':
            insertData.description = `Alfombra ${productName} - Sincronizada automáticamente`
            insertData.category = 'carpets'
            insertData.size = 'Consultar'
            insertData.price = 'Consultar'
            break

          case 'curtains_items':
            insertData.description = `Cortina ${productName} - Sincronizada automáticamente`
            insertData.category = 'curtains'
            insertData.size = '200 x 250 cm'
            insertData.price = 'Consultar'
            break

          case 'furniture_items':
            insertData.description = `Mueble ${productName} - Sincronizado automáticamente`
            insertData.category = 'furniture'
            break

          case 'monthly_updates':
            insertData.description = `Producto mensual ${productName} - Sincronizado automáticamente`
            insertData.size = 'Consultar'
            insertData.price = 'Consultar'
            break

          case 'gallery_photos':
            insertData.title = productName
            insertData.description = `Foto de galería ${productName}`
            break
        }

        // Insertar registro
        const { error: insertError } = await supabase
          .from(tableName)
          .insert([insertData])

        if (insertError) {
          console.error(`❌ Error insertando ${file.name}:`, insertError)
        } else {
          console.log(`✅ Insertado: ${file.name} → ${tableName}`)
          newFilesCount++
        }
      }
    }

    console.log(`🎉 Sincronización completada: ${newFilesCount} nuevos archivos en ${tableName}`)

  } catch (error) {
    console.error(`Error en syncBucket ${bucketId}:`, error)
  }
}

async function syncAllBuckets() {
  console.log('🚀 Iniciando sincronización completa de imágenes...\n')

  for (const [bucketId, tableName] of Object.entries(bucketToTableMap)) {
    await syncBucket(bucketId, tableName)
  }

  console.log('\n✅ Sincronización completa finalizada!')
  console.log('\n💡 Para sincronizar automáticamente en el futuro:')
  console.log('   Ejecuta: node sync-images.js')
}

async function showStatus() {
  console.log('📊 ESTADO ACTUAL DE LAS TABLAS:\n')

  for (const [bucketId, tableName] of Object.entries(bucketToTableMap)) {
    try {
      const { data, error } = await supabase
        .from(tableName)
        .select('name, image_url')
        .eq('is_active', true)

      if (error) {
        console.error(`Error consultando ${tableName}:`, error)
        continue
      }

      console.log(`${tableName}: ${data.length} registros activos`)
      data.slice(0, 3).forEach(item => {
        console.log(`  - ${item.name}`)
      })
      if (data.length > 3) console.log(`  ... y ${data.length - 3} más`)
      console.log('')

    } catch (error) {
      console.error(`Error en status ${tableName}:`, error)
    }
  }
}

// Ejecutar según argumentos de línea de comandos
const command = process.argv[2]

if (command === 'status') {
  showStatus()
} else {
  syncAllBuckets()
}
