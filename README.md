# 🎮 streaming-hub

¡Bienvenido/a! Este proyecto es tu kit esencial para mostrar mandos de videojuegos en overlays de streaming, videos o páginas web. Aquí encontrarás recursos gráficos listos para usar y guías técnicas para streaming avanzado.

---

## 🚀 ¿Qué encontrarás aquí?

- **Superposiciones visuales de controles**: SVG, PNG y CSS para varios modelos de gamepad (Xbox, PlayStation, etc.), integrables en OBS o sitios web.
- **Guías y utilidades para streaming avanzado**: Scripts y manuales para montar servidores RTMP, automatizar cambios de señal y asegurar tus transmisiones.
- **Recursos listos para personalizar**: Todo el contenido es editable y adaptable a tus necesidades.

---

## 📁 Estructura del repositorio

```
streaming-hub/
├── GamePads-Overlays/                # Archivos base: SVGs, CSS y assets gráficos de los overlays
│    └── base/                        # Recursos y variantes base para controladores (más detalles dentro)
├── Guia_nginx_rtmp_fallback/         # Guía completa para montar un servidor RTMP con auto-fallback en Windows
│    └── nginx/                       # Binarios y configuración específica de nginx-rtmp para Windows
├── NohBoard_Overlays/                # Overlays adaptados para NohBoard (teclado visual para streamers)
├── README.md                         # Este archivo de documentación principal
```

### Detalle de carpetas

- **GamePads-Overlays/**  
  Contiene los SVG y hojas de estilo principales para overlays de mandos. Aquí están los archivos que puedes usar directamente en tu escena de OBS o web.
  Ejemplos y variantes de overlays para diferentes tipos de gamepad. Incluye archivos editables y ejemplos de integración.

- **Guia_nginx_rtmp_fallback/**  
  Guía paso a paso para armar tu propio servidor de streaming RTMP en Windows, con scripts de auto-switch y seguridad.
  - Manual en español súper detallado (con emojis y ejemplos).
  - Scripts PowerShell para automatizar la selección de señal.
  - Binarios de nginx-rtmp para Windows (en subcarpeta `nginx/`).
  - Consejos de seguridad y resolución de problemas.

- **NohBoard_Overlays/**  
  Overlays listos para NohBoard, ideal para streamers que quieren mostrar teclas y gamepad de forma visual.

---

## 🛠️ Cómo usar los overlays

1. Descarga o clona el repositorio:
   ```bash
   git clone https://github.com/0xDimonet78/streaming-hub.git
   ```
2. Elige el overlay y estilo que mejor se adapte a tu mando y escena.
3. Integra los archivos en tu proyecto web o en OBS.

   Ejemplo HTML:
   ```html
   <link rel="stylesheet" href="GamePads-Overlays/base/style.css">
   <div class="controller xbox"></div>
   ```

4. Personaliza los estilos CSS y los SVG si lo necesitas.

---

## 💡 Consejos y filosofía

- Este proyecto nació para facilitar la vida a streamers y creadores que buscan overlays profesionales sin complicaciones.
- Las guías y scripts están pensados para usuarios de todos los niveles: tanto si solo quieres arrastrar y soltar un SVG, como si quieres montar tu propio servidor de streaming.
- ¿Tienes una sugerencia o hiciste una mejora? ¡Los pull requests son bienvenidos!

---

## 👤 Créditos

Creado y mantenido por **dimonet78**.  
Inspirado por la comunidad de streaming y los overlays más usados en Twitch y YouTube.

---

## 📄 Licencia

MIT — ¡Libertad total para modificar, compartir y mejorar!
