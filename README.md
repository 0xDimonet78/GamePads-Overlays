# GamePads-Overlays

Superposiciones (overlays) de controles de videojuegos para streaming, videos o proyectos web.

## Descripción

Este repositorio contiene recursos gráficos y estilos CSS para mostrar visualmente distintos modelos de controladores de videojuegos (Xbox 360, Xbox One, PlayStation 3, etc.) en pantalla. Útil para overlays en transmisiones en vivo, tutoriales, análisis de videojuegos o cualquier proyecto donde se requiera mostrar la interacción con mandos.

## Características

- Soporte para diferentes modelos de mandos (Xbox, PlayStation, etc.)
- Estilos CSS personalizados para animaciones y estados de los botones
- Archivos SVG y PNG listos para usar como base visual
- Fácil integración en páginas web y OBS

## Estructura del repositorio

- Base/  
  Contiene los archivos SVG y CSS base para los overlays.
  - base.svg — Imagen de fondo/base de un mando
  - style.css — Hojas de estilo y animaciones para los overlays

## Uso

1. Descarga o clona el repositorio:
   ```bash
   git clone https://github.com/dimonet78/GamePads-Overlays.git
   ```
2. Incluye los archivos base y los estilos en tu proyecto o escena de streaming.
3. Personaliza los estilos CSS o los assets gráficos si lo necesitas.

### Ejemplo de integración en HTML

```html
<link rel="stylesheet" href="Base/style.css">
<div class="controller xbox"></div>
```

> Asegúrate de que los paths de los assets coincidan con tu estructura de carpetas.

## Créditos

Creado por [dimonet78](https://github.com/dimonet78).  
Inspirado en overlays de mandos populares para la comunidad de streaming.

## Licencia

Este proyecto se publica bajo la licencia MIT.

---

Creado por dimonet78.
Inspirado en overlays de mandos populares para la comunidad de streaming.
