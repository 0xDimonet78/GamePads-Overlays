* Carpeta base `C:/nginx/`
* Permisos solo para IPs de la red `192.168.1.X`
* Archivos y scripts comentados línea por línea
* Autoarranque como servicio para NGINX y `auto_switch.bat`
* Enlaces a todas las herramientas necesarias

---

# ✅ GUÍA COMPLETA: NGINX RTMP en Windows – Auto-Switch, IPs seguras y Servicio

---

## 📦 1. DESCARGAS NECESARIAS

| Software                         | Enlace                                                                                        |
| -------------------------------- | --------------------------------------------------------------------------------------------- |
| 🔻 NGINX + RTMP para Windows     | [illuspas/nginx-rtmp-win32](https://github.com/illuspas/nginx-rtmp-win32/releases)            |
| 🎞 FFmpeg                        | [https://www.gyan.dev/ffmpeg/builds/](https://www.gyan.dev/ffmpeg/builds/) (versión full ZIP) |
| ⚙ NSSM (para servicios)          | [https://nssm.cc/download](https://nssm.cc/download)                                          |

---

## 📂 2. ESTRUCTURA DE CARPETAS

Descomprime todo en:

```
C:\nginx\
```

Estructura:

```
C:\nginx\
├── conf\
│   └── nginx.conf        <- Configuración principal
├── auto_switch.ps1       <- Script de cambio automático
├── fallback.mp4          <- Video de emergencia
├── ffmpeg\               <- Carpeta con FFmpeg
├── nginx.exe             <- Ejecutable principal
├── nssm.exe              <- Ejecutable nssm
```

---

## 📝 3. nginx.conf COMENTADO LÍNEA A LÍNEA

Guarda esto en `C:\nginx\conf\nginx.conf`:

```nginx
worker_processes  1;

error_log  logs/error.log info;

events {
    worker_connections  1024;
}

rtmp {
    server {
        listen 1935;             # Puerto RTMP estándar
        chunk_size 4096;         # Tamaño recomendado de fragmento

        # APP PARA SEÑAL EN VIVO DESDE PC PERSONAL
        application directo {
            live on;             # Activar live streaming
            record off;          # No grabar transmisiones
            allow publish 192.168.1.0/24;  # Solo IPs internas pueden emitir
            deny publish all;    # Denegar a todos los demás
        }

        # APP PARA EMISIÓN 24/7 (desde servidor)
        application loop247 {
            live on;
            record off;
            allow publish 127.0.0.1;
            allow publish 192.168.1.0/24;
            deny publish all;
        }

        # APP PARA BACKUP SI TODO FALLA
        application fallback {
            live on;
            record off;
        }

        # APP PRINCIPAL QUE REDIRIGE SEGÚN ORDEN (el script publica aquí)
        application live {
            live on;
            record off;
            # Si quieres hacer push a Twitch, descomenta y pon tu clave:
            # push rtmp://live.twitch.tv/app/TU_CLAVE_DE_STREAM;
        }
    }
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen      8080;
        server_name  localhost;

        location / {
            root html;
            index  index.html index.htm;
        }

        # Estado RTMP en formato XML
        location /stat {
            rtmp_stat all;
            rtmp_stat_stylesheet stat.xsl;
        }

        # Hoja de estilos para el estado
        location /stat.xsl {
            root html;
        }

        # Para servir HLS, si lo necesitas
        location /hls {
            root html;
            add_header Cache-Control no-cache;
            add_header Access-Control-Allow-Origin *;

            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
        }
    }
}
```

🔧 Asegúrate de reemplazar `YOUR_STREAM_KEY` con tu clave real de Twitch.

🛡 PERMISOS DE EMISIÓN POR IP

Dentro del bloque `application` ya se ha usado:

```nginx
allow publish 192.168.1.0/24;  # Permite toda la subred local
deny publish all;              # Deniega el resto
```

⚠ Esto **protege que solo PCs de tu red puedan emitir.**

---

## 🤖 4. SCRIPT `auto_switch.ps1` DETALLADO

Este script decide qué señal reenviar a Twitch en función de la disponibilidad.

Guarda como: `C:\nginx\auto_switch.ps1`

```ps1
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
```

---

## ⚙️ 5. AUTOARRANQUE COMO SERVICIO

### ✅ Paso 1: Instalar NGINX como servicio con NSSM

2. Abre CMD como **Administrador** en la carpeta `C:\nginx\`.
3. Ejecuta:

```cmd
nssm install nginx
```

4. Configura:

* **Path:** `C:\nginx\nginx.exe`
* **Startup directory:** `C:\nginx\`

📌 Aparecerá como "nginx" en los servicios de Windows.

### ✅ Paso 2: Instalar `auto_switch.ps1` como servicio

✅ Autoarranque como servicio (versión PowerShell)

2. Abre CMD como **Administrador** en la carpeta `C:\nginx\`.
2. Ejecuta:

```cmd
nssm install auto_switch_PS


Arguments: -ExecutionPolicy Bypass -File "C:\nginx\auto_switch.ps1"

Startup dir: C:\nginx\
```
📌 Aparecerá como "auto_switch_PS" en los servicios de Windows.

Ambos arrancarán al iniciar Windows. Si quieres que se reinicien si fallan, marca las opciones en la pestaña "Exit actions".

---

## 🧪 7. PROBAR EMISIÓN

1. Desde el PC personal: OBS emite a `rtmp://192.168.1.X/directo`
2. Desde el servidor: OBS emite a `rtmp://localhost/loop247`
3. Si ninguno está emitiendo, NGINX mandará el video `fallback.mp4`

---
