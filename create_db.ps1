# Script para crear la base de datos pollo_sanjuanero en MongoDB
Write-Host "=== CREANDO BASE DE DATOS POLLO_SANJUANERO ===" -ForegroundColor Green

# 1. Verificar cuál es el nodo primario
Write-Host "`n1. Verificando nodo primario..." -ForegroundColor Yellow
docker exec -it mongo-primary mongosh --eval "rs.status().members.find(m => m.state === 1)"

# 2. Crear la base de datos en el primario
Write-Host "`n2. Creando base de datos 'pollo_sanjuanero'..." -ForegroundColor Yellow
docker exec -it mongo-primary mongosh --eval "
use pollo_sanjuanero
db.proyecto.insertOne({ 
    nombre: 'Base de datos creada', 
    proyecto: 'Pollo Sanjuanero S.A.',
    fecha_creacion: new Date(),
    descripcion: 'Base de datos para el proyecto de Base de Datos 2'
})
print('Base de datos creada exitosamente')
"

# 3. Verificar que se creó en el primario
Write-Host "`n3. Verificando base de datos en primario (27017)..." -ForegroundColor Yellow
docker exec -it mongo-primary mongosh --eval "
show dbs
print('=== Colecciones en pollo_sanjuanero ===')
use pollo_sanjuanero
show collections
"

# 4. Verificar replicación en secundario 1
Write-Host "`n4. Verificando replicación en secundario 1 (27018)..." -ForegroundColor Yellow
docker exec -it mongo-secondary-1 mongosh --port 27018 --eval "
show dbs
print('=== Colecciones en pollo_sanjuanero ===')
use pollo_sanjuanero
show collections
"

# 5. Verificar replicación en secundario 2
Write-Host "`n5. Verificando replicación en secundario 2 (27019)..." -ForegroundColor Yellow
docker exec -it mongo-secondary-2 mongosh --port 27019 --eval "
show dbs
print('=== Colecciones en pollo_sanjuanero ===')
use pollo_sanjuanero
show collections
"

# 6. Verificar datos replicados
Write-Host "`n6. Verificando datos replicados..." -ForegroundColor Yellow
docker exec -it mongo-primary mongosh --eval "
use pollo_sanjuanero
db.proyecto.find().pretty()
"

Write-Host "`n=== PROCESO COMPLETADO ===" -ForegroundColor Green
Write-Host "Base de datos 'pollo_sanjuanero' creada y replicada en todos los nodos" -ForegroundColor Green