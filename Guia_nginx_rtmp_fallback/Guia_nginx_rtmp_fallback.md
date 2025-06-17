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
| 📁 ZIP preconfigurado (opcional) | *(te lo puedo generar si quieres)*                                                            |

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
```

---

## 📝 3. nginx.conf COMENTADO LÍNEA A LÍNEA

Guarda esto en `C:\nginx\conf\nginx.conf`:

```nginx
# Número de procesos worker (1 es suficiente para RTMP)
worker_processes 1;

events {
    # Número máximo de conexiones por proceso
    worker_connections 1024;
}

# BLOQUE RTMP
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
            allow publish 192.168.1.0/24;
            deny publish all;
        }

        # APP PARA BACKUP SI TODO FALLA
        application fallback {
            live on;
            record off;
        }

        # APP PRINCIPAL QUE REDIRIGE SEGÚN ORDEN
        application live {
	    live on;
	    record off;
	    push rtmp://live.twitch.tv/app/YOUR_LIVE_KEY;  # Cambia por tu clave real
        }
    }
}

# BLOQUE HTTP PARA ESTADÍSTICAS Y CONTROL
http {
    include mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;

    server {
        listen 8080;            # Puerto para panel web
        server_name localhost;

        location /stat {
            rtmp_stat all;              # Mostrar estadísticas RTMP
            rtmp_stat_stylesheet stat.xsl;
        }

        location /stat.xsl {
            root html;                  # Estilos de la estadística
        }
    }
}
```

---

## 🤖 4. SCRIPT `auto_switch.ps1` DETALLADO

Este script decide qué señal reenviar a Twitch en función de la disponibilidad.

Guarda como: `C:\nginx\auto_switch.ps1`

```ps1
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

```

🔧 Asegúrate de reemplazar `YOUR_STREAM_KEY` con tu clave real de Twitch.

---

## 🛡 5. PERMISOS DE EMISIÓN POR IP

Dentro del bloque `application` ya se ha usado:

```nginx
allow publish 192.168.1.0/24;  # Permite toda la subred local
deny publish all;              # Deniega el resto
```

⚠ Esto **protege que solo PCs de tu red puedan emitir.**

---

## ⚙️ 6. AUTOARRANQUE COMO SERVICIO

### ✅ Paso 1: Instalar NGINX como servicio con NSSM

1. Extrae `nssm.exe` en una carpeta.
2. Abre CMD como **Administrador**.
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

1. Abre CMD como **Administrador**.
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
