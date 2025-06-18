# CSS Personalizado para Gamepad Viewer - PS3

A continuación se muestra el CSS traducido y comentado en español para personalizar la apariencia del mando de PS3 en [Gamepad Viewer](https://gamepadviewer.com/).

-Cómo usar CSS personalizado para GamePad Viewer-
https://gamepadviewer.com/

Habilitar un CSS personalizado es tan fácil como añadir &css=[url al archivo css]
al final de la URL así:
https://gamepadviewer.com/?p=1&css=https://gist.github.com/anonymous/526491dc02014099cd14/raw/d7bb0477ba984f794497f3f0f82cb33484dc7889/ps3.css

Si vas a usar un CSS personalizado para el visor de gamepad
para diseñar tu propia skin, asumimos que tienes algún conocimiento
básico sobre cómo funciona CSS. También recomiendo subir
tu CSS personalizado a GitHub Gist, ya que puedes obtener fácilmente
el enlace directo al archivo copiando la dirección del botón
"Raw" en la esquina superior derecha del código.
NOTA: Si usas Gist, ¡ASEGÚRATE DE NOMBRAR TU ARCHIVO CSS!
No importa cómo lo llames, siempre que termine en .css,
de lo contrario el sitio no lo leerá y pensará que es solo texto plano.

Cada entrada de CSS debe ir precedida de '.custom' ya que esa es la 
clase codificada para un estilo personalizado. No tiene sentido 
cambiar esto porque solo puedes tener una skin personalizada cargada a la vez.

Si usas imágenes, deben subirse a un host de imágenes de
tu elección. Personalmente, usaría Imgur porque es fácil subir
y obtener la URL directa de la imagen. Ninguna de las imágenes en este ejemplo
se cargará porque apuntan a una ubicación relativa del archivo css,
ya que esto normalmente se encuentra en el archivo CSS principal del sitio.

Lo siguiente es una copia del código utilizado para mostrar la skin del controlador PS3
en Gamepad Viewer. Puedes desplazarte hacia abajo y leer los comentarios para
entender cómo funciona el estilo y demás. ¡Feliz personalización!

P.D. Si usas esta herramienta a menudo y te gustaría 'invitarme a un café', puedes
hacerlo vía mi PayPal: https://paypal.me/mrmcpowned

```css

/*INICIO de Estilo del Controlador PS3*/
/*Esta clase define los atributos base del skin*/
.controller.custom{
    /* La imagen de fondo es básicamente la base del skin del controlador.
    El skin del controlador PS3 se encuentra en http://mrmcpowned.com/gamepad/ps3-assets/base.png
    y puedes observarla como ejemplo. Los sticks, botones y flechas direccionales están ausentes
    porque sus elementos apropiados se incorporarán cuando se defina su estilo abajo.
    Todo el estilo visual del skin se realiza mediante imágenes de fondo y sprites CSS. */ 
    background: url(ps3-assets/base.png); 
    height: 558px;
    width: 784px;
}
.custom.desconectado { /* Esta clase muestra una imagen cuando el controlador está desconectado */
    background: url(ps3-assets/base-disconnect.png);
}
/* Esto oculta los botones del controlador cuando está desconectado, dejando solo la imagen de fondo */ 
.custom.desconectado div {
    display: none;
}
.custom .triggers{ /* Los gatillos están dentro de un div, así que esto le da tamaño y posición adecuada */
    width: 586px;
    height: 65px;
    position: absolute;
    left: 99px;
}
.custom .trigger{/* Estos son los propios gatillos */
    width:86px;
    height:65px;
    background: url(ps3-assets/triggers.png);
    opacity: 0;
}
/* Las clases izquierda y derecha se usan para posicionar los gatillos
dentro del div contenedor. Como su posición es relativa
al tamaño del elemento padre, simplemente ajustamos el padre
para lograr la posición deseada. */
.custom .trigger.left{ 
    float: left;
}
.custom .trigger.right{
    float: right;
}

/* Los botones superiores (bumpers) siguen la misma lógica de posicionamiento que los gatillos */
.custom .bumper{
    width: 89px;
    height: 28px;
    background: url(ps3-assets/bumpers.png);
    opacity: 0;
}
.custom .bumpers{
    position: absolute;
    width: 586px;
    height: 28px;
    left: 99px;
    top: 72px;
}
.custom .bumper.pressed{ /* La clase '.pressed' se usa en la mayoría de botones para indicar que han sido presionados */
    opacity: 1;
}
.custom .bumper.left{
    /* Llámame vago o listo, pero ¿por qué hacer dos imágenes si son simétricas?
    Podemos simplemente rotarlas en el navegador. Además, normalmente no necesitas
    prefijos específicos de navegador, salvo excepciones.
    NOTA: CLR Browser es básicamente Chrome, así que usa '-webkit-' como prefijo. */
    -webkit-transform: rotateY(180deg);
    transform: rotateY(180deg);
    float: left;
}
.custom .bumper.right{
    float: right;
}
/* Este fragmento de código es para el indicador de jugador, que se representa en
cuadrantes en el control de Xbox. No se llama así en el de PS3,
pero sería innecesario cambiar el HTML solo por eso. */
.custom .quadrant{
    position: absolute;
    background: url(ps3-assets/player-n.png);
    height: 17px;
    width: 111px;
    top: 140px;
    left: 240px;
}
/* Como el indicador de jugador es un sprite CSS, cambiamos la
posición de fondo según el número del jugador.
NOTA: El orden de jugadores empieza en 0, así que p0 = Jugador 1 */
.custom .p0{ background-position: 0 -6px; }
.custom .p1{ background-position: 0 -28px; }
.custom .p2{ background-position: 0 -49px; }
.custom .p3{ background-position: 0 -70px; }
/* Esto ajusta el tamaño y posición del contenedor para los botones start y select */
.custom .arrows{
    position: absolute;
    width: 205px;
    height: 19px;
    top: 250px;
    left: 291px;
}
/* Tamaño y sprite CSS para los botones start y select */
.custom .back, .custom .start{
    background: url(ps3-assets/menus.png);
    width: 34px;
    height: 19px;
}
.custom .back.pressed, .custom .start.pressed{
    background-position-y: -21px;
    margin-top: 2px;
}
.custom .back{ float: left; width: 38px; }
.custom .start{ float: right; width: 36px; background-position: 37px 0; }
/* Posición y tamaño del contenedor de botones principales (cuadrado, círculo, triángulo, X) */
.custom .abxy{
    position: absolute;
    width: 204px;
    height: 205px;
    top: 156px;
    left: 538px;
}
/* Clase base para facilitar el mapeo de sprites */
.custom .button{
    position: absolute;
    width:62px;
    height:62px;
    background: url(ps3-assets/face-buttons.png);
}
.custom .button.pressed{
    background-position-y: -64px;
    margin-top: 5px;
}
.custom .a{ background-position: 62px 0; top: 142px; left: 71px; }
.custom .b{ background-position: 125px 0; top: 71px; right: 0px; }
.custom .x{ background-position: 0 0; top: 71px; }
.custom .y{ background-position: -63px 0; left: 71px; }
/* Los sticks analógicos siguen el mismo principio de posicionamiento que los gatillos
Nota que la rotación de los sticks está codificada con JS, aplicando
el CSS inline. */
.custom .sticks{
    position: absolute;
    width: 364px;
    height: 105px;
    top: 328px;
    left: 210px;
}
.custom .stick{
    position: absolute;
    background: url(ps3-assets/thumbs.png);
    height:105px;
    width: 105px;
}
.custom .stick.pressed.left{ background-position-x: -106px; }
.custom .stick.pressed.right{ background-position-x: -211px; }
.custom .stick.left{ top: 0; left: 0; }
.custom .stick.right{ top: calc(100% - 105px); left: calc(100% - 105px); }
/* Posición y tamaño de la cruceta */
.custom .dpad{
    position: absolute;
    width: 140px;
    height: 132px;
    top: 192px;
    left: 74px;
}
.custom .face{
    background: url(ps3-assets/dpad.png);
    position: absolute;
}
.custom .face.up, .custom .face.down{ width: 38px; height: 52px; }
.custom .face.left, .custom .face.right{ width: 52px; height: 38px; }
.custom .face.up{ left: 50px; top: 0; background-position: 92px 0px; }
.custom .face.down{ left: 50px; top: 79px; background-position: 131px 0; }
.custom .face.left{ top: 47px; left: 0; background-position: 0px 0; }
.custom .face.right{ top: 47px; right: 0px; background-position: 53px 0; }
.custom .face.pressed{
    margin-top: 5px;
    background-position-y: 52px;
}
/* Las siguientes entradas están vacías porque aún no las he usado, pero
existen para mostrar un fightstick. Como los fightsticks tienen
gatillos izquierdo y derecho y botones digitales, hay elementos
HTML separados para mostrarlos como botones presionados en lugar de
una configuración de opacidad */
.custom .trigger-button.left{ }
.custom .trigger-button.right{ }
.custom .trigger-button.left.pressed{ }
.custom .trigger-button.right.pressed{ }
/* Aquí iría el CSS para fightstick. Lo ideal sería usar un sprite
con las 8 posiciones posibles, y cambiarlo según la entrada.
Las clases son autoexplicativas. */
.fstick{
    position: absolute;
    width: 140px;
    height: 132px;
    top: 192px;
    left: 74px;
}
.fstick.up{ }
.fstick.down{ }
.fstick.left{ }
.fstick.right{ }
.fstick.up.right{ }
.fstick.up.left{ }
.fstick.down.right{ }
.fstick.down.left{ }

/*FIN del Estilo del Controlador PS3*/

```
