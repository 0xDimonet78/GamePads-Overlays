# auto_switch.ps1 (corregido y comentado)
while ($true) {
    $stats = Invoke-WebRequest -Uri "http://localhost:8080/stat" -UseBasicParsing
    $content = $stats.Content

    # Detectar si hay emisión en directo
    $hasDirecto = $content -like '*application name="directo"*streams>1*'
    $hasLoop = $content -like '*application name="loop247"*streams>1*'

    if ($hasDirecto) {
        Write-Host "⚡ Emitiendo desde DIRECTO"
        Start-Process ffmpeg -ArgumentList '-re -i rtmp://localhost/directo -c copy -f flv rtmp://localhost/live' -NoNewWindow -Wait
    } elseif ($hasLoop) {
        Write-Host "🔁 Emitiendo desde LOOP247"
        Start-Process ffmpeg -ArgumentList '-re -i rtmp://localhost/loop247 -c copy -f flv rtmp://localhost/live' -NoNewWindow -Wait
    } else {
        Write-Host "⚠️ Emitiendo desde FALLBACK"
        Start-Process ffmpeg -ArgumentList '-re -i rtmp://localhost/fallback -c copy -f flv rtmp://localhost/live' -NoNewWindow -Wait
    }

    Start-Sleep -Seconds 10
}
