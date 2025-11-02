# scripts/demo/demo-wal.ps1
# DEMOSTRACION BACKUP INCREMENTAL WAL

Write-Host "=== DEMOSTRACION BACKUP INCREMENTAL WAL ===" -ForegroundColor Cyan

# 1. Configurar WAL
Write-Host "1. CONFIGURANDO WAL ARCHIVING..." -ForegroundColor Yellow
.\scripts\backup\configure-wal.ps1

# 2. Verificar configuración
Write-Host "2. VERIFICANDO CONFIGURACION..." -ForegroundColor Yellow
.\scripts\backup\check-wal.ps1

# 3. Generar actividad para crear WAL files
Write-Host "3. GENERANDO ACTIVIDAD EN LA BD..." -ForegroundColor Yellow
docker exec primary psql -U postgres -c "
INSERT INTO clientes (nombre, email) VALUES 
('Cliente WAL Test 1', 'test1@empresa.com'),
('Cliente WAL Test 2', 'test2@empresa.com');
SELECT pg_switch_wal();
"

# 4. Mostrar WAL files generados
Write-Host "4. WAL FILES GENERADOS:" -ForegroundColor Yellow
.\scripts\backup\check-wal.ps1

Write-Host "✅ BACKUP INCREMENTAL WAL CONFIGURADO" -ForegroundColor Green