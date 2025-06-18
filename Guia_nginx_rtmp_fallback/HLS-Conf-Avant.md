El bloque hls en la configuración del módulo nginx-rtmp-module ofrece varias opciones, más allá de las básicas. Según la información encontrada en los archivos de tu repositorio, aquí tienes un resumen de las opciones más habituales y útiles:

### Opciones comunes del bloque hls en nginx-rtmp:

- hls on;  
  Activa la salida HLS.

- hls_path /ruta/al/directorio;  
  Directorio donde se guardarán los archivos .ts y .m3u8 generados.

- hls_fragment SEGUNDOS;  
  Duración de cada fragmento de video (por ejemplo, 4 segundos).

- hls_playlist_length SEGUNDOS;  
  Duración total de la lista de reproducción HLS (por ejemplo, 60 segundos).

Otras opciones avanzadas (según la documentación oficial del módulo):

- hls_continuous on|off;  
  Para mantener la lista de reproducción continua incluso si no hay clientes conectados.

- hls_cleanup on|off;  
  Borra archivos antiguos automáticamente.

- hls_nested on|off;  
  Crea un subdirectorio por cada stream.

- hls_fragment_naming [sequential|timestamp|system];  
  Controla cómo se nombran los fragmentos.

- hls_fragments_per_key N;  
  Para cambiar la clave de cifrado cada N fragmentos (si usas cifrado).

- hls_type [live|event];  
  Define el modo HLS (por defecto live).

- hls_key_url URL;  
  URL para la clave de cifrado (si usas contenido cifrado AES-128).

### Ejemplo de configuración:

```nginx
application live {
    live on;
    hls on;
    hls_path /tmp/hls;
    hls_fragment 4;
    hls_playlist_length 60;
    hls_continuous on;
    hls_cleanup on;
}
```

### Referencias útiles:
- Documentación oficial de directivas: https://github.com/arut/nginx-rtmp-module/wiki/Directives#hls
- Resultados de búsqueda en tu repo que puedes revisar: búsqueda de "hls".

¿Te interesa alguna opción específica o necesitas ejemplos para un caso de uso concreto?
