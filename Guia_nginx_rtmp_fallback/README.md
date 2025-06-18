
# ✅ GUÍA COMPLETA: NGINX RTMP en Windows – Auto-Switch, IPs seguras y Servicio

---

## 📑 ÍNDICE

1. [Descargas necesarias](#-1-descargas-necesarias)
2. [Estructura de carpetas](#-2-estructura-de-carpetas)
3. [nginx.conf comentado línea a línea](#-3-nginxconf-comentado-línea-a-línea)
4. [Script auto_switch.ps1 detallado](#-4-script-auto_switchps1-detallado)
5. [Autoarranque como servicio (NSSM)](#-5-autoarranque-como-servicio)
6. [Notas de seguridad y firewall](#-6-notas-de-seguridad-y-firewall)
7. [Prueba de emisión](#-7-probar-emisión)
8. [Desinstalación de servicios (opcional)](#desinstalación-de-servicios-opcional)
9. [Preguntas frecuentes (FAQ)](#preguntas-frecuentes-faq)
10. [Licencia y créditos](#licencia-y-créditos)

---

## 📦 1. DESCARGAS NECESARIAS

| Software                   | Enlace                                                                                        |
|----------------------------|----------------------------------------------------------------------------------------------|
| 🔻 NGINX + RTMP para Win   | [illuspas/nginx-rtmp-win32](https://github.com/illuspas/nginx-rtmp-win32/releases)           |
| 🎞 FFmpeg                  | [https://www.gyan.dev/ffmpeg/builds/](https://www.gyan.dev/ffmpeg/builds/) (descargar versión "full" ZIP) |
| ⚙ NSSM (para servicios)    | [https://nssm.cc/download](https://nssm.cc/download)                                        |

> **IMPORTANTE:** Nunca compartas tus claves de streaming públicamente. Guárdalas en un lugar seguro. Todas las rutas en Windows deben usar `\` y no `/`.

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
├── nssm.exe              <- Ejecutable NSSM
```

---

## 📝 3. nginx.conf COMENTADO LÍNEA A LÍNEA

Guarda esto en `C:\nginx\conf\nginx.conf`:

```nginx
# Número de procesos worker (puede ser 'auto' para ajustarse a núcleos disponibles)
worker_processes  1; # worker_processes  auto;

# Nivel de registro de errores (info para más detalles)
error_log  logs/error.log info;

events {
    # Número máximo de conexiones simultáneas por worker
    worker_connections  1024;
}

# Bloque para la configuración de RTMP (streaming en vivo)
rtmp {
    server {
        # Puerto por defecto para RTMP
        listen 1935;
        # Tamaño de los chunks de datos
        chunk_size 4096;

        # Aplicación para emitir a varias plataformas simultáneamente
        application obs_multi {
            live on;                          # Habilita streaming en vivo
            record off;                       # No grabar el stream
            allow publish 192.168.1.0/24;     # Solo pueden publicar equipos de la red local
            allow publish 127.0.0.1;          # Permite publicar desde localhost
            deny publish all;                 # Deniega el resto de publicaciones

            # Configuración HLS (comentado por defecto)
            # hls on;
            # hls_path /tmp/hls;
            # hls_fragment 4;                # Fragmentos de 4 segundos
            # hls_playlist_length 60;        # Playlist de 60 segundos

            # Empuja el stream a cada plataforma (reemplaza con tus claves)
            push rtmp://live.twitch.tv/app/TU_CLAVE_TWITCH;
            push rtmp://rtmp.kick.com/app/TU_CLAVE_KICK;
            push rtmp://a.rtmp.youtube.com/live2/TU_CLAVE_YOUTUBE;
        }

        # Aplicación para emitir solo a Twitch
        application obs_twitch {
            live on;
            record off;
            allow publish 192.168.1.0/24;
            allow publish 127.0.0.1;
            deny publish all;

            # hls on;
            # hls_path /tmp/hls;
            # hls_fragment 4;
            # hls_playlist_length 60;

            push rtmp://live.twitch.tv/app/TU_CLAVE_TWITCH;
        }

        # Aplicación para emitir solo a YouTube
        application obs_youtube {
            live on;
            record off;
            allow publish 192.168.1.0/24;
            allow publish 127.0.0.1;
            deny publish all;

            # hls on;
            # hls_path /tmp/hls;
            # hls_fragment 4;
            # hls_playlist_length 60;

            push rtmp://a.rtmp.youtube.com/live2/TU_CLAVE_YOUTUBE;
        }

        # Aplicación para emitir solo a Kick
        application obs_kick {
            live on;
            record off;
            allow publish 192.168.1.0/24;
            allow publish 127.0.0.1;
            deny publish all;

            # hls on;
            # hls_path /tmp/hls;
            # hls_fragment 4;
            # hls_playlist_length 60;

            push rtmp://rtmp.kick.com/app/TU_CLAVE_KICK;
        }

        # Aplicación de respaldo (puedes usarla para contenido alternativo)
        application fallback {
            live on;
            record off;

            # hls on;
            # hls_path /tmp/hls;
            # hls_fragment 4;
            # hls_playlist_length 60;
        }

        # Salida principal; puedes elegir el mejor stream mediante script externo
        application live {
            live on;
            record off;
            allow publish 127.0.0.1;
            allow publish 192.168.1.0/24;
            deny publish all;

            # hls on;
            # hls_path /tmp/hls;
            # hls_fragment 4;
            # hls_playlist_length 60;

            # Puedes añadir push a plataformas para retransmitir el resultado final
            # push rtmp://live.twitch.tv/app/TU_CLAVE_FINAL;
        }
    }
}

# Configuración HTTP para acceso web, estadísticas y HLS
http {
    include       mime.types;                 # Tipos MIME para archivos
    default_type  application/octet-stream;   # Tipo por defecto
    sendfile        on;                       # Permite enviar archivos de forma eficiente
    keepalive_timeout  65;                    # Tiempo de espera de keep-alive

    server {
        listen      8080;                     # Puerto de escucha HTTP (puedes usar 80)
        server_name  localhost;               # Nombre del servidor

        location / {
            root html;                        # Carpeta raíz para contenido web
            index  index.html index.htm;      # Archivos de índice
        }

        location /stat {
            rtmp_stat all;                    # Muestra estado RTMP en XML
            rtmp_stat_stylesheet stat.xsl;    # Aplica hoja de estilos
        }

        location /stat.xsl {
            root html;                        # Hoja de estilos para /stat
        }

        # Configuración para servir videos HLS
        location /hls {
            types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
            }
            root /tmp;
            add_header Cache-Control no-cache;

            # Configuración de CORS para HLS
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS' always;
            add_header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept' always;
            add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range' always;

            # Respuesta especial para pre-flight (OPTIONS) de CORS
            if ($request_method = 'OPTIONS') {
                add_header 'Access-Control-Allow-Origin' '*' always;
                add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS' always;
                add_header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept' always;
                add_header 'Access-Control-Max-Age' 1728000;
                add_header 'Content-Type' 'text/plain charset=UTF-8';
                add_header 'Content-Length' 0;
                return 204;
            }
        }

        # Redirección HTTP->HTTPS (comentada por defecto)
        # return 301 https://$host$request_uri;
    }

    # Bloque de ejemplo para configuración HTTPS con certificados Let's Encrypt (comentado)
    # server {
    #    listen 443 ssl;
    #    server_name www.tudominio.com;
    #    ssl_certificate /etc/letsencrypt/live/www.tudominio.com/fullchain.pem;
    #    ssl_certificate_key /etc/letsencrypt/live/www.tudominio.com/privkey.pem;
    #    include /etc/letsencrypt/options-ssl-nginx.conf;
    #    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
    #    location / {
    #        root /usr/local/nginx/html;
    #        index index.html index.htm;
    #    }
    #
    #    location /hls {
    #        types {
    #            application/vnd.apple.mpegurl m3u8;
    #            video/mp2t ts;
    #        }
    #        root /tmp;
    #        add_header Cache-Control no-cache;
    #
    #        # Configuración CORS para HLS en HTTPS
    #        add_header 'Access-Control-Allow-Origin' '*' always;
    #        add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS' always;
    #        add_header 'Access-Control-Allow-Headers' 'Range';
    #        add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
    #
    #        if ($request_method = 'OPTIONS') {
    #            add_header 'Access-Control-Allow-Origin' '*' always;
    #            add_header 'Access-Control-Allow-Methods' 'GET, OPTIONS' always;
    #            add_header 'Access-Control-Allow-Headers' 'Range';
    #            add_header 'Access-Control-Max-Age' 1728000;
    #            add_header 'Content-Type' 'text/plain charset=UTF-8';
    #            add_header 'Content-Length' 0;
    #            return 204;
    #        }
    #    }
    # }
}
```
🔧 Asegúrate de reemplazar `TU_CLAVE_TWITCH`, `TU_CLAVE_KICK` y `TU_CLAVE_YOUTUBE` por tus claves reales.

🛡 **PERMISOS DE EMISIÓN POR IP:**  
Dentro del bloque `application` ya se ha usado:

```nginx
allow publish 192.168.1.0/24;  # Permite toda la subred local
deny publish all;              # Deniega el resto
```
⚠️ Esto **protege que solo PCs de tu red puedan emitir.**

---

## 🤖 4. SCRIPT `auto_switch.ps1` DETALLADO

Este script decide qué señal reenviar a la app "live" según la prioridad y disponibilidad.

Guarda como: `C:\nginx\auto_switch.ps1`

```ps1
# auto_switch.ps1 - Script para seleccionar la mejor señal y reenviarla a la app "live"
# FUNCIONAMIENTO:
# - Prioridad: obs_multi > obs_twitch > obs_youtube > obs_kick > fallback
# - Solo reenvía si hay viewers conectados a la aplicación correspondiente
# - Mata cualquier ffmpeg anterior antes de lanzar uno nuevo
# - Guarda log de los cambios

# Configura aquí los nombres de las aplicaciones según tu nginx.conf
$priorityApps = @("obs_multi", "obs_twitch", "obs_youtube", "obs_kick", "fallback")
$rtmpServer = "localhost"
$liveApp = "live"
$rtmpPort = 1935
$ffmpegPath = "C:\nginx\ffmpeg\bin\ffmpeg.exe" # Ajusta según tu instalación
$logPath = "C:\nginx\auto_switch.log"

# Ruta de destino RTMP principal (aplicación "live")
$destino = "rtmp://$rtmpServer/$liveApp"

function Stop-FFmpeg {
    # Elimina cualquier proceso ffmpeg lanzado anteriormente
    Get-Process ffmpeg -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

function Write-Log {
    param([string]$msg)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp $msg" | Out-File -FilePath $logPath -Append -Encoding UTF8
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
                Write-Log "Emitir desde $appName"
                $source = "rtmp://$rtmpServer/$appName"
                break
            }
        }

        # Si ninguna app tiene viewers conectados, usar fallback
        if (-not $source) {
            Write-Host "⚠️ Ninguna señal activa. Usando FALLBACK."
            Write-Log "FALLBACK activado"
            $source = "rtmp://$rtmpServer/fallback"
        }

        # Mata cualquier ffmpeg previo antes de lanzar uno nuevo
        Stop-FFmpeg

        # Puedes personalizar los argumentos de ffmpeg aquí
        Start-Process -FilePath $ffmpegPath -ArgumentList "-re -i $source -c copy -f flv $destino" -NoNewWindow

    } catch {
        Write-Host "Error al obtener o analizar el estado RTMP: $_"
        Write-Log "Error: $_"
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
```

> **TIP:** Si ffmpeg no está en tu PATH, usa la ruta absoluta en `$ffmpegPath`.

---

## ⚙️ 5. AUTOARRANQUE COMO SERVICIO

### Paso 1: Instalar NGINX como servicio con NSSM

1. Abre CMD como **Administrador** en la carpeta `C:\nginx\`.
2. Ejecuta:
   ```
   nssm install nginx
   ```
3. En la ventana de configuración de NSSM:
   - **Path:** `C:\nginx\nginx.exe`
   - **Startup directory:** `C:\nginx\`

📌 Aparecerá como "nginx" en los servicios de Windows.

### Paso 2: Instalar `auto_switch.ps1` como servicio PowerShell

1. Abre CMD como **Administrador** en la carpeta `C:\nginx\`.
2. Ejecuta:
   ```
   nssm install auto_switch_PS
   ```
3. En la ventana de configuración de NSSM:
   - **Path:** `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
   - **Arguments:** `-ExecutionPolicy Bypass -File "C:\nginx\auto_switch.ps1"`
   - **Startup directory:** `C:\nginx\`

📌 Aparecerá como "auto_switch_PS" en los servicios de Windows.

> **TIP:** Ambos arrancarán al iniciar Windows. Si quieres que se reinicien si fallan, marca las opciones en la pestaña "Exit actions".

---

## 🔥 6. NOTAS DE SEGURIDAD Y FIREWALL

- Asegúrate de abrir los puertos **1935 (RTMP)** y **8080 (panel web)** en el firewall de Windows.
- Nunca compartas tus claves de streaming.
- Monitorea el archivo `logs/error.log` de NGINX para detectar problemas.

---

## 🧪 7. PROBAR EMISIÓN

1. En OBS (en cualquier PC de tu red local), configura como servidor:
   - Para multistream: `rtmp://192.168.1.X/obs_multi`
   - Solo Twitch: `rtmp://192.168.1.X/obs_twitch`
   - Solo YouTube: `rtmp://192.168.1.X/obs_youtube`
   - Solo Kick: `rtmp://192.168.1.X/obs_kick`
2. Desde el propio servidor puedes probar con: `rtmp://localhost/obs_multi`
3. Si ninguno está emitiendo, NGINX mandará el video `fallback.mp4`.

---

## 🧹 Desinstalación de servicios (opcional)

Para eliminar los servicios creados por NSSM:

1. Abre CMD como Administrador en `C:\nginx\`.
2. Ejecuta:
   ```
   nssm remove nginx confirm
   nssm remove auto_switch_PS confirm
   ```

---

## ❓ Preguntas frecuentes (FAQ)

- **OBS no conecta:** ¿Abriste el puerto 1935 en el firewall? ¿La IP es correcta?
- **No cambia el stream:** Revisa el log `auto_switch.log` y el panel `http://localhost:8080/stat`.
- **¿Puedo emitir a más plataformas?** Sí, añade líneas `push` en la app `live` de `nginx.conf`.
- **¿Cómo cambio la prioridad?** Edita el array `$priorityApps` en el PowerShell.

---

## 📜 Licencia y créditos

- Basado en herramientas públicas y documentación oficial.
- Puedes modificar y compartir esta guía, se agradecen mejoras vía pull request.
- Inspirado en tutoriales de la comunidad NGINX y proyectos de streaming open source.

---
