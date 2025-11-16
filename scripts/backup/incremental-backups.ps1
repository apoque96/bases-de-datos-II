Write-Host "=== BACKUP INCREMENTAL (WAL MANAGEMENT) ===" -ForegroundColor Cyan

# 1. Verificar estado de WAL actual
Write-Host "1. Estado actual de WAL:" -ForegroundColor Yellow
$walStatus = docker exec primary psql -U postgres -c "
SELECT 
    pg_current_wal_lsn() as current_lsn,
    pg_walfile_name(pg_current_wal_lsn()) as current_wal_file,
    (SELECT COUNT(*) FROM pg_ls_waldir()) as wal_files_in_dir,
    (SELECT setting FROM pg_settings WHERE name = 'wal_keep_size') as wal_keep_size;" -t

Write-Host "   $walStatus" -ForegroundColor White

# 2. Forzar rotación de WAL (crear nuevo archivo)
Write-Host "2. Rotando WAL actual..." -ForegroundColor Green
$switchResult = docker exec primary psql -U postgres -c "SELECT pg_switch_wal();" -t
Write-Host "   Nuevo WAL iniciado en: $($switchResult.Trim())" -ForegroundColor Gray

# 3. Verificar archivos WAL existentes (SIN comprimir por ahora)
Write-Host "3. Archivos WAL en archive:" -ForegroundColor Yellow
$walFiles = docker exec primary bash -c "find /wal_archive -name '0000*' -type f 2>/dev/null | wc -l"
$walSize = docker exec primary bash -c "du -sh /wal_archive 2>/dev/null | cut -f1" 2>$null

if ($LASTEXITCODE -eq 0 -and $walSize) {
    Write-Host "   Total archivos WAL: $walFiles" -ForegroundColor White
    Write-Host "   Tamaño total: $walSize" -ForegroundColor White
} else {
    Write-Host "   No se pudo obtener información de WAL" -ForegroundColor Yellow
}

# 4. Registrar metadata del backup incremental
Write-Host "4. Registrando metadata incremental..." -ForegroundColor Green

# Obtener información de manera segura
$walFilesSafe = docker exec primary bash -c "ls -1 /wal_archive/*.wal 2>/dev/null | wc -l" 2>$null
if (-not $walFilesSafe) { $walFilesSafe = "0" }

$currentLSN = docker exec primary psql -U postgres -c "SELECT pg_current_wal_lsn();" -t 2>$null
if (-not $currentLSN) { $currentLSN = "N/A" }

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Crear directorio de logs si no existe
if (!(Test-Path "backups")) { mkdir "backups" -Force | Out-Null }

# Registrar en log
"INCREMENTAL: $timestamp | WAL: $walFilesSafe archivos | LSN: $($currentLSN.Trim())" |
    Add-Content -Path "backups\backup_metadata.log"

Write-Host "   Registrado: $timestamp - $walFilesSafe archivos WAL" -ForegroundColor Gray

# 5. Mostrar resumen
Write-Host "`nBACKUP INCREMENTAL COMPLETADO" -ForegroundColor Green