# auto_switch.ps1 - Script para seleccionar la mejor señal y reenviarla a la app "live"
# FUNCIONAMIENTO:
# - Prioridad: obs_multi > obs_twitch > obs_youtube > obs_kick > fallback
# - Solo reenvía si hay viewers conectados a la aplicación correspondiente
# - Mata cualquier ffmpeg anterior antes de lanzar uno nuevo

# Configura aquí los nombres de las aplicaciones según tu nginx.conf
$priorityApps = @("obs_multi", "obs_twitch", "obs_youtube", "obs_kick", "fallback")
$rtmpServer = "localhost"
$liveApp = "live"
$rtmpPort = 1935

# Ruta de destino RTMP principal (aplicación "live")
$destino = "rtmp://$rtmpServer/$liveApp"

function Stop-FFmpeg {
    # Elimina cualquier proceso ffmpeg lanzado anteriormente
    Get-Process ffmpeg -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

while ($true) {
    try {
        # Obtiene y parsea el XML de estado RTMP
        $xml = [xml](Invoke-WebRequest -Uri "http://localhost:8080/stat" -UseBasicParsing).Content

        $source = $null

        # Busca la primera app disponible según prioridad y con viewers conectados
        foreach ($appName in $priorityApps) {
            $app = $xml.rtmp.server.application | Where-Object { $_.name -eq $appName }
            if ($app -and $app.live.nclients -and ([int]$app.live.nclients) -gt 0) {
                Write-Host "⚡ Emitiendo desde $appName"
                $source = "rtmp://$rtmpServer/$appName"
                break
            }
        }

        # Si ninguna app tiene viewers conectados, usar fallback
        if (-not $source) {
            Write-Host "⚠️ Ninguna señal activa. Usando FALLBACK."
            $source = "rtmp://$rtmpServer/fallback"
        }

        # Mata cualquier ffmpeg previo antes de lanzar uno nuevo
        Stop-FFmpeg

        # Puedes personalizar los argumentos de ffmpeg aquí
        # - Puedes ajustar codecs, calidad, etc. si lo necesitas
        Start-Process ffmpeg -ArgumentList "-re -i $source -c copy -f flv $destino" -NoNewWindow

    } catch {
        Write-Host "Error al obtener o analizar el estado RTMP: $_"
        Stop-FFmpeg
    }

    # Intervalo de revisión (en segundos)
    Start-Sleep -Seconds 10
}

<# OPCIONES RÁPIDAS PARA EDITAR
- Agrega/quita apps en $priorityApps para ajustar la prioridad
- Cambia $rtmpServer si tu Nginx está en otra máquina
- Ajusta $liveApp si cambias el nombre de la app de salida
- Puedes añadir lógica para logs, notificaciones, etc.
- Si quieres emitir a diferentes plataformas desde "live", añade push en la app "live" del nginx.conf
- Si quieres forzar a que solo un OBS pueda emitir a cada app, usa claves/contraseñas de publicación o cambia las reglas de allow publish
#>
