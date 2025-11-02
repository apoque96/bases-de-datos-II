# scripts/backup/check-wal.ps1 - VERSIÓN SIMPLE
Write-Host "=== VERIFICANDO WAL ARCHIVING ===" -ForegroundColor Cyan

# 1. Verificar configuración
Write-Host "CONFIGURACIÓN WAL:" -ForegroundColor Yellow
docker exec primary psql -U postgres -c "
SELECT name, setting 
FROM pg_settings 
WHERE name IN ('wal_level', 'archive_mode', 'archive_command');"

# 2. Verificar estadísticas
Write-Host "ESTADÍSTICAS ARCHIVING:" -ForegroundColor Yellow
docker exec primary psql -U postgres -c "
SELECT 
    archived_count as archivos_creados,
    failed_count as archivos_fallidos,
    last_archived_wal as ultimo_archivo
FROM pg_stat_archiver;"

# 3. Verificar archivos en disco
Write-Host "3. ARCHIVOS WAL EN DISCO:" -ForegroundColor Yellow
$walDir = ".\wal_archive"
if (Test-Path $walDir) {
    $walFiles = Get-ChildItem -Path $walDir -Filter "*" 
    Write-Host "   Total archivos WAL: $($walFiles.Count)" -ForegroundColor Green
    if ($walFiles) {
        $walFiles | Select-Object -First 3 | Format-Table Name, Length, LastWriteTime -AutoSize
    }
} else {
    Write-Host "Directorio WAL no existe" -ForegroundColor Red
}

# 4. Verificar espacio
Write-Host "4. ESPACIO WAL UTILIZADO:" -ForegroundColor Yellow
if (Test-Path $walDir) {
    $totalSize = (Get-ChildItem -Path $walDir -Filter "*" | Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Host "   Tamaño total: $([math]::Round($totalSize, 2)) MB" -ForegroundColor Green
}

Write-Host "✅ VERIFICACIÓN COMPLETADA" -ForegroundColor Green