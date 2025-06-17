# auto_switch.ps1 - Script para seleccionar la mejor señal y reenviarla a la app "live" en Nginx RTMP
# Prioridad: obs_multi > obs_twitch > obs_youtube > obs_kick > fallback

# Configuración
$priorityApps = @("obs_multi", "obs_twitch", "obs_youtube", "obs_kick", "fallback")
$rtmpServer = "localhost"
$liveApp = "live"
$rtmpPort = 1935
$destino = "rtmp://$rtmpServer/$liveApp"
$ffmpegProcessName = "ffmpeg"

function Stop-FFmpeg {
    # Elimina solo los procesos ffmpeg lanzados por este script (opcional: puedes afinar con argumentos únicos)
    Get-Process $ffmpegProcessName -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

$lastSource = $null

while ($true) {
    try {
        # Obtiene y parsea el XML de estado RTMP
        $xml = [xml](Invoke-WebRequest -Uri "http://localhost:8080/stat" -UseBasicParsing).Content
        $source = $null

        # Busca la primera app disponible según prioridad y con viewers conectados
        foreach ($appName in $priorityApps) {
            $app = $xml.rtmp.server.application | Where-Object { $_.name -eq $appName }
            if ($app -and $app.live.nclients -and ([int]$app.live.nclients) -gt 0) {
                Write-Host "⚡ Emitiendo desde $appName ($([int]$app.live.nclients) viewers)"
                $source = "rtmp://$rtmpServer/$appName"
                break
            }
        }

        # Si ninguna app tiene viewers conectados, usar fallback
        if (-not $source) {
            Write-Host "⚠️ Ninguna señal activa. Usando FALLBACK."
            $source = "rtmp://$rtmpServer/fallback"
        }

        if ($source -ne $lastSource) {
            Write-Host "🔄 Cambiando señal a $source"
            Stop-FFmpeg
            # Puedes personalizar los argumentos de ffmpeg aquí
            Start-Process ffmpeg -ArgumentList "-re -i $source -c copy -f flv $destino" -NoNewWindow
            $lastSource = $source
        } else {
            Write-Host "✅ La señal sigue siendo $source, no se reinicia ffmpeg."
        }
    } catch {
        Write-Host "❌ Error al obtener o analizar el estado RTMP: $_"
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
