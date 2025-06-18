🎮 GamePads-Overlays
¡Bienvenido/a! Este proyecto es tu caja de herramientas para mostrar mandos de videojuegos en overlays de streaming, videos o páginas web. Aquí encontrarás recursos gráficos listos para usar y guías técnicas para potenciar tus transmisiones o proyectos interactivos.

🚀 ¿Qué encontrarás aquí?
Superposiciones visuales de controles: SVG, PNG y CSS para varios modelos de gamepad (Xbox, PlayStation, etc.), listos para integrar en OBS o sitios web.
Guías y utilidades para streaming avanzado: Scripts y manuales para montar servidores RTMP, automatizar cambios de señal y asegurar tus transmisiones.
Recursos listos para personalizar: Todo el contenido es editable y adaptable a tus necesidades.
📁 Estructura del repositorio
Code
GamePads-Overlays/
├── Base/                       # Archivos base: SVGs, CSS y assets gráficos de los overlays
├── GamePad_Base/               # Recursos y variantes base para controladores (más detalles dentro)
├── NohBoard_Overlays/          # Overlays adaptados para NohBoard (teclado visual para streamers)
├── Guia_nginx_rtmp_fallback/   # Guía completa para montar un servidor RTMP con auto-fallback en Windows
│    └── nginx/                 # Binarios y configuración específica de nginx-rtmp para Windows
├── README.md                   # Este archivo de documentación principal
Detalle de carpetas:
Base/
Contiene los SVG y hojas de estilo principales para overlays de mandos. Aquí están los archivos que puedes usar directamente en tu escena de OBS o web.

GamePad_Base/
Ejemplos y variantes de overlays para diferentes tipos de gamepad. Suele incluir archivos editables y ejemplos de integración.

NohBoard_Overlays/
Overlays listos para usarse con NohBoard, ideal para streamers que quieren mostrar teclas y gamepad de forma visual.

Guia_nginx_rtmp_fallback/
Una guía paso a paso para armar tu propio servidor de streaming RTMP en Windows, con scripts de auto-switch y seguridad.
Incluye:

Manual en español súper detallado (con emojis y ejemplos).
Scripts PowerShell para automatizar la selección de señal.
Binarios de nginx-rtmp para Windows (en subcarpeta nginx/).
Consejos de seguridad y resolución de problemas.
🛠️ Cómo usar los overlays
Descarga o clona el repositorio:
bash
git clone https://github.com/dimonet78/GamePads-Overlays.git
Elige el overlay y estilo que mejor se adapte a tu mando y escena.
Integra los archivos en tu proyecto web o en OBS.
Ejemplo HTML:
HTML
<link rel="stylesheet" href="Base/style.css">
<div class="controller xbox"></div>
Personaliza los estilos CSS y los SVG si lo necesitas.
💡 Consejos y filosofía
Este proyecto nació para facilitar la vida a streamers y creadores que buscan overlays profesionales sin complicaciones.
Las guías y scripts están pensados para usuarios de todos los niveles: tanto si solo quieres arrastrar y soltar un SVG, como si quieres montar tu propio servidor de streaming.
¿Tienes una sugerencia o hiciste una mejora? ¡Los pull requests son bienvenidos!
👤 Créditos
Creado y mantenido por dimonet78.
Inspirado por la comunidad de streaming y los overlays más usados en Twitch y YouTube.

📄 Licencia
MIT — ¡Libertad total para modificar, compartir y mejorar!
