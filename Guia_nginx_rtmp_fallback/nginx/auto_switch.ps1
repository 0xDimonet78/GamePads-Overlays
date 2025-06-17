# auto_switch.ps1 - Versión mejorada y robusta

# Ruta del destino RTMP principal
$destino = "rtmp://localhost/live"

# Función para matar instancias previas de ffmpeg lanzadas por este script
function Stop-FFmpeg {
    Get-Process ffmpeg -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

while ($true) {
    try {
        # Obtiene y parsea el XML de estado RTMP
        $xml = [xml](Invoke-WebRequest -Uri "http://localhost:8080/stat" -UseBasicParsing).Content

        # Detecta si hay viewers conectados a cada aplicación
        $directo = $xml.rtmp.server.application | Where-Object { $_.name -eq "directo" }
        $loop247 = $xml.rtmp.server.application | Where-Object { $_.name -eq "loop247" }

        $nDirecto = 0
        $nLoop = 0

        if ($directo.live.nclients) { $nDirecto = [int]$directo.live.nclients }
        if ($loop247.live.nclients) { $nLoop = [int]$loop247.live.nclients }

        # Decide la fuente
        if ($nDirecto -gt 0) {
            Write-Host "⚡ Emitiendo desde DIRECTO"
            $src = "rtmp://localhost/directo"
        } elseif ($nLoop -gt 0) {
            Write-Host "🔁 Emitiendo desde LOOP247"
            $src = "rtmp://localhost/loop247"
        } else {
            Write-Host "⚠️ Emitiendo desde FALLBACK"
            $src = "rtmp://localhost/fallback"
        }

        # Mata procesos ffmpeg previos antes de lanzar uno nuevo
        Stop-FFmpeg

        # Lanza ffmpeg para la fuente elegida
        Start-Process ffmpeg -ArgumentList "-re -i $src -c copy -f flv $destino" -NoNewWindow

    } catch {
        Write-Host "Error al obtener o analizar el estado RTMP: $_"
        # Mata ffmpeg por seguridad si hubo error
        Stop-FFmpeg
    }

    Start-Sleep -Seconds 10
}