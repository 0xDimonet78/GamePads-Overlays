# Overlays_NohBoard/NohBoard

Esta carpeta contiene los archivos principales y recursos necesarios para el uso de NohBoard como overlay en streamings. A continuación, se explica la función de cada archivo y subcarpeta:

## Archivos principales

- [`NohBoard.exe`](./NohBoard.exe): Ejecutable principal de NohBoard.
- [`NohBoard.Hooking.dll`](./NohBoard.Hooking.dll): Biblioteca utilizada para la captura de entradas del teclado.
- [`clipper_library.dll`](./clipper_library.dll): Biblioteca adicional utilizada por NohBoard.
- [`System.ValueTuple.dll`](./System.ValueTuple.dll): Dependencia requerida por el programa.
- [`NohBoard.json`](./NohBoard.json): Archivo de configuración principal de NohBoard.

## Carpetas

- [`keyboards/`](./keyboards): Contiene diferentes configuraciones y diseños de teclado personalizados. Dentro de esta carpeta encontrarás directorios como:
  - [`0xDimonet78`](./keyboards/0xDimonet78)
  - [`BurningFish`](./keyboards/BurningFish)
  - [`Coxotropic`](./keyboards/Coxotropic)
  - [`GamesLegacy`](./keyboards/GamesLegacy)
  - [`HaleyHalcyon`](./keyboards/HaleyHalcyon)
  - [`Normal`](./keyboards/Normal)
  - [`TheCore`](./keyboards/TheCore)
  - [`global`](./keyboards/global)
  - [`joao7yt`](./keyboards/joao7yt)
  - [`quake`](./keyboards/quake)
  - [`wheels`](./keyboards/wheels)

  Cada subcarpeta contiene archivos de configuración específicos para diferentes estilos de teclado o usuarios. Puedes ver todos los directorios disponibles aquí: [Ver más en GitHub](https://github.com/0xDimonet78/streaming-hub/tree/main/Overlays_NohBoard/NohBoard/keyboards)

- [`logs/`](./logs): Carpeta destinada a almacenar los logs generados por NohBoard durante su ejecución.

---

> **Nota:** Si necesitas agregar o modificar un diseño de teclado, hazlo dentro de la carpeta `keyboards`. Si quieres analizar eventos o errores, consulta los archivos dentro de la carpeta `logs`.

---

_Agradecimientos especiales a [@ThoNohT](https://github.com/ThoNohT) por el proyecto original [NohBoard](https://github.com/ThoNohT/NohBoard)._
