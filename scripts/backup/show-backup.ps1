$latestBackup = Get-ChildItem .\backups\*.sql | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestBackup) {
    Write-Host "BACKUP EXITOSO" -ForegroundColor Green
    Write-Host "   Archivo: $($latestBackup.Name)" -ForegroundColor White
    Write-Host "   Tamaño: $([math]::Round($latestBackup.Length/1024, 2)) KB" -ForegroundColor White
    Write-Host "   Fecha: $($latestBackup.LastWriteTime.ToString('dd/MM/yyyy HH:mm:ss'))" -ForegroundColor White
    Write-Host "   Ubicacion: backups\$($latestBackup.Name)" -ForegroundColor Gray
} else {
    Write-Host "No se creó el backup" -ForegroundColor Red
}