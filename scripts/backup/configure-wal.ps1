# EJECUTA ESTOS COMANDOS UNO POR UNO EN POWERSHELL:

Write-Host "=== CONFIGURANDO WAL ARCHIVING ===" -ForegroundColor Cyan

# 1. Crear directorio
mkdir wal_archive -Force

# 2. Configurar PostgreSQL
docker exec primary bash -c "
echo 'wal_level = replica' >> /var/lib/postgresql/data/pgdata/postgresql.conf
echo 'archive_mode = on' >> /var/lib/postgresql/data/pgdata/postgresql.conf  
echo 'archive_command = ''cp %p /wal_archive/%f''' >> /var/lib/postgresql/data/pgdata/postgresql.conf
"

# 3. Reiniciar
docker restart primary
Start-Sleep -Seconds 10

# 4. Verificar
docker exec primary psql -U postgres -c "SELECT name, setting FROM pg_settings WHERE name LIKE 'archive%';"

# 5. Probar
docker exec primary psql -U postgres -c "SELECT pg_switch_wal();"

# 6. Ver archivos WAL
Write-Host "Archivos WAL creados:" -ForegroundColor Green
Get-ChildItem wal_archive\

Write-Host "LISTO! WAL configurado" -ForegroundColor Green