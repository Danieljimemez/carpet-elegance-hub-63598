// Edge Function simple para auto-insertar productos
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const supabaseUrl = Deno.env.get('SUPABASE_URL')!
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const supabase = createClient(supabaseUrl, supabaseServiceKey)

Deno.serve(async (req) => {
  try {
    const { record } = await req.json()
    const bucketId = record.bucket_id
    const fileName = record.name

    // Generar nombre del producto
    const productName = fileName
      .replace(/\.[^/.]+$/, '') // quitar extensión
      .replace(/[-_]/g, ' ') // reemplazar - y _ con espacios
      .replace(/\b\w/g, l => l.toUpperCase()) // capitalizar

    // Generar URL
    const publicUrl = `${supabaseUrl}/storage/v1/object/public/${bucketId}/${fileName}`

    // Insertar según bucket
    let tableName = ''
    let insertData = {}

    switch (bucketId) {
      case 'gallery':
        tableName = 'gallery_photos'
        insertData = {
          title: productName,
          description: `Foto de galería ${productName}`,
          image_url: publicUrl,
          is_active: true
        }
        break

      case 'carpets':
        tableName = 'carpets_items'
        insertData = {
          name: productName,
          description: `Alfombra ${productName} - Subida automáticamente`,
          image_url: publicUrl,
          size: 'Consultar',
          price: 'Consultar',
          is_active: true
        }
        break

      case 'curtains':
        tableName = 'curtains_items'
        insertData = {
          name: productName,
          description: `Cortina ${productName} - Subida automáticamente`,
          image_url: publicUrl,
          size: '200x250cm',
          price: 'Consultar',
          is_active: true
        }
        break

      case 'furniture':
        tableName = 'furniture_items'
        insertData = {
          name: productName,
          description: `Mueble ${productName} - Subido automáticamente`,
          image_url: publicUrl,
          category: 'furniture',
          is_active: true
        }
        break

      case 'monthly':
        tableName = 'monthly_updates'
        insertData = {
          title: productName,
          description: `Producto mensual ${productName} - Subido automáticamente`,
          image_url: publicUrl,
          is_active: true
        }
        break

      default:
        return new Response(JSON.stringify({ message: 'Bucket not handled' }), {
          status: 200,
          headers: { 'Content-Type': 'application/json' }
        })
    }

    // Insertar
    const { error } = await supabase
      .from(tableName)
      .insert([insertData])

    if (error) {
      console.error('Insert error:', error)
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    return new Response(JSON.stringify({
      message: `Inserted into ${tableName}`,
      product: insertData
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    })

  } catch (error) {
    console.error('Function error:', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
})
