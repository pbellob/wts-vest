# Contrato de construcción: juego "WTS — Protocolo de supervivencia"

Este documento es la especificación completa para que un agente de código (Antigravity) construya el juego. Todo lo que debe contener está aquí. **No inventes mecánicas, números ni textos**: usa solo los que están en este contrato.

---

## 1. Qué hay que entregar

Un **único archivo `index.html`** que:

- Funcione **sin internet**: nada de CDN, Google Fonts, imágenes externas ni `fetch`. Todo el CSS y el JS va dentro del mismo archivo (CSS en `<style>`, JS en `<script>`).
- Los únicos archivos externos permitidos son los que ya están en el repositorio: el modelo y sus texturas en `modelo/`, la imagen de respaldo **`chaleco.png`**, y las librerías locales de `vendor/`. Nada más.
- Se abra con doble clic en cualquier navegador moderno, en computador y en celular.
- Esté **completamente en español**.
- Use JavaScript plano (vanilla), sin frameworks ni compilación.

## 2. Para quién es y qué tono usar

- Se va a proyectar en una **sustentación de clase** de Diseño de Sistemas Electrónicos (UNAL). La estudiante lo juega en vivo frente al curso, en 3 a 5 minutos, y tiene que alcanzar a mostrar **todas** las funciones del chaleco.
- Tono: sobrio y realista, no caricaturesco. Es una situación de emergencia, no un juego de arcade.
- **El juego debe ser fácil de ganar.** Su propósito es demostrar para qué sirve cada elemento del chaleco, no poner a prueba al jugador. Nunca se castiga por explorar.

## 3. Qué es el WTS (contexto del producto)

El WTS es un chaleco de supervivencia para personas atrapadas bajo escombros después de un terremoto. Es un chaleco de jean con forro interior de manta térmica plateada. Lleva:

| Elemento | Qué hace |
|---|---|
| Parche adhesivo de sensores | Se pega sobre la piel, en el hueco de la base del cuello (fosa supraesternal). Mide frecuencia cardiaca, oxigenación y temperatura. |
| Módulo electrónico (pecho) | Microcontrolador, acelerómetro, radio de largo alcance que funciona como baliza, y un modelo de IA que corre localmente. Tiene un interruptor hundido. |
| Cuatro botones táctiles | Una fila de cuatro botones con puntos en relieve: uno, dos, tres y cuatro puntos. Se cuentan con el dedo a oscuras. Son el **único** método de respuesta: el chaleco pregunta y la persona contesta en escala de 1 a 4. |
| Capucha y mangas térmicas | De manta térmica, se despliegan para conservar el calor. |
| Bolsillo | Linterna, tapabocas N95 y silbato. |
| Motor de vibración | Le comunica cosas a quien lleva el chaleco puesto. |

El jugador es una persona atrapada en un hueco entre escombros, a oscuras, con el chaleco puesto. Un equipo de rescate busca en la superficie.

## 4. El chaleco es la interfaz

Esto es lo más importante del diseño y no es negociable.

El chaleco se muestra **en 3D**, grande y centrado en pantalla, siempre visible, sobre un fondo oscuro. Se usa el modelo `modelo/base.obj` con sus texturas, cargado con three.js desde `vendor/` igual que en el visor de la sección 12.

**Durante el juego la cámara está FIJA en vista frontal.** No hay OrbitControls, no se puede girar ni acercar. Girar el modelo libremente es trabajo de `visor.html`, no del juego.

### Por qué la cámara va fija

El OBJ es **una sola malla** (`o model`), sin grupos ni materiales: no tiene partes separadas, así que es imposible preguntarle qué elemento tocó el usuario. Por eso:

- Las zonas interactivas son **capas planas invisibles superpuestas sobre el canvas**, en coordenadas de pantalla, ubicadas encima de cada elemento del chaleco tal como se ve en la vista frontal.
- Como la cámara no se mueve, esas zonas quedan siempre alineadas.
- Al pasar el cursor, la zona se resalta con un contorno suave y aparece un rótulo pequeño con su nombre.

### Carga del modelo

- El modelo pesa unos 16 MB con texturas. Se **precarga detrás de la pantalla de inicio**, mostrando el porcentaje, y el botón **"Empezar"** permanece deshabilitado hasta que termine. El jugador nunca debe esperar con la partida ya abierta.

### Respaldo obligatorio

Si WebGL no está disponible o el modelo falla al cargar, la página debe **mostrar automáticamente `chaleco.png`** en el mismo lugar y continuar funcionando con normalidad, con las mismas zonas interactivas. Esto es un requisito, no un extra: el juego se proyecta en vivo en una sustentación y no puede quedarse sin imagen.

### Efectos que aprovechan el 3D

- **Réplica** (turnos 4 y 11): la cámara se sacude brevemente.
- **Confirmación de rescate**: el modelo hace un pulso suave de escala, como la vibración del chaleco.
- **Linterna encendida**: se enciende una luz puntual real sobre el modelo; apagada, la escena queda en penumbra.

**No dibujes un chaleco en CSS** ni uses rectángulos de relleno o figuras geométricas que lo sustituyan.

Zonas interactivas, ubicadas sobre el chaleco en vista frontal:

| Zona | Dónde está en la imagen | Acción |
|---|---|---|
| Interruptor | Sobre el módulo negro rectangular del pecho | Encender el chaleco |
| Botones de puntos | Sobre la fila de cuatro botones de colores | Responder el triage (1 a 4) |
| Bolsillo | Sobre el bolsillo grande inferior | Abre un menú con silbato, linterna y tapabocas |
| Cuello | Sobre el cuello alto | Desplegar la capucha térmica |
| Sisas | Sobre los rollos plateados de los hombros | Desplegar las mangas térmicas |

## 5. Mecánica de turnos

- La **partida completa dura de 3 a 5 minutos en total**, no por turno. Cada turno es un clic y una respuesta inmediata.
- Son **15 turnos**. Cada turno equivale a **20 minutos** de la situación simulada, así que la partida cubre unas 5 horas.
- **Toda acción cuesta exactamente un turno**: encender, responder el triage, silbar, la linterna, el tapabocas, la capucha y las mangas.
- **Repetir una acción ya hecha no cuesta turno** y solo muestra un mensaje ("la capucha ya está desplegada").
- Nada de pantallas de carga, animaciones largas ni textos que haya que leer despacio. El ritmo es ágil.
- En pantalla se muestra `Turno 5 de 15` y un contador de **tiempo atrapado en horas y minutos** de la situación simulada (turno × 20 min), no el tiempo real de juego.

## 6. Variables de estado

Todas van de 0 a 100 y se muestran como barras. Los valores son exactos, no los cambies:

| Variable | Inicial | Cambio por turno |
|---|---|---|
| Temperatura corporal | 80 | −6. Con capucha desplegada: −3. Con capucha y mangas: −1. |
| Aire respirable | 100 | −7. Con tapabocas N95 puesto: −1. Una réplica resta 5 adicionales. |
| Batería | 100 | Chaleco apagado: 0. Encendido: −4. Con la linterna encendida: −12. |
| Localización | 0 | Chaleco encendido: +10. Silbato en ventana de silencio: +40. Réplica: −15. |

**El desgaste es continuo, no a saltos.** Las cifras de la tabla son el total
de un turno, pero no se cobran de golpe al final: se reparten entre los 20
segundos del turno y se descuentan cada 120 ms, en proporción al tiempo que ha
pasado. El jugador tiene que *ver* bajar las barras mientras duda, no quedarse
mirando un 74 congelado hasta que suene el reloj. Consecuencias obligatorias:

- La tasa se consulta en cada paso con el estado **de ese momento**: desplegar
  la capucha a mitad de turno frena la pérdida de una vez, no en el siguiente.
- Los umbrales (localización = 100, aire < 40, y las tres muertes) se revisan
  también en cada paso, así que la vibración del rescate o la hipotermia caen
  en el segundo exacto en que ocurren, no al cerrar el turno.
- Si el jugador actúa antes de que se acabe el tiempo, **se le cobra la
  fracción que falte** del turno: una acción cuesta un turno completo pase lo
  que pase, y los totales de la tabla se respetan exactamente.
- El tiempo se mide con marcas de reloj reales (`Date.now()`), no contando
  pasos del temporizador: si el navegador frena la pestaña, al volver se cobra
  lo pendiente en vez de quedarse atrás.

Notas de balance:

- Si el jugador nunca despliega nada de manta, la temperatura llega a 0 cerca del turno 14. Si despliega la capucha, sobrevive sin problema.
- Si nunca se pone el tapabocas, el aire llega a 0 cerca del turno 15.
- La batería solo se agota si deja la linterna encendida muchos turnos. **La linterna se puede apagar** haciendo clic otra vez en el bolsillo.
- La localización llega a 100 sola, con el chaleco encendido, hacia el turno 10. El silbato en ventana de silencio solo lo acelera.

## 7. El triage

El chaleco hace una pregunta en los turnos **3, 6, 9 y 12**, en este orden exacto:

1. (Turno 3) ¿Qué tanto te cuesta respirar?
2. (Turno 6) ¿Qué tanto dolor tienes?
3. (Turno 9) ¿Qué tan atrapado está tu cuerpo por los escombros?
4. (Turno 12) ¿Qué tanto puedes mover brazos y piernas?

- Se responde oprimiendo uno de los cuatro botones de puntos: **1 es lo mejor, 4 lo peor**.
- La pregunta activa se muestra de forma destacada hasta que se responda o hasta que pasen 2 turnos.
- **No existe ningún botón especial para avisar que tiene un miembro aplastado.** Esa información sale únicamente de la pregunta 3.
- Los botones deben verse con **puntos en relieve** (uno, dos, tres y cuatro puntos), no con los números escritos, y en colores de gravedad: verde, amarillo, naranja y rojo.

### Modo automático

Si **tres preguntas** se vencen sin que el jugador las responda, la IA del chaleco interpreta que la persona está inconsciente y pasa a **modo automático**: deja de preguntar y sigue transmitiendo sola con los datos de los sensores. El juego continúa.

Esta comprobación se hace **en cada turno**, no solo cuando el jugador oprime un botón de triage.

## 8. Eventos del entorno

**Réplicas.** En los turnos 4 y 11 hay una réplica del terremoto: la pantalla tiembla brevemente, el aire baja 5 y la localización baja 15. Mensaje: *"Réplica. Los escombros se mueven y la señal se pierde un momento."*

**Ventanas de silencio.** En los turnos 5, 8 y 13 el equipo de rescate apaga las máquinas para escuchar. La ventana **dura todo el turno** y se anuncia **antes** de que el jugador decida qué hacer: *"Arriba se apagaron las máquinas. Están escuchando."* Si silba durante esos turnos, la localización sube 40. Si silba en cualquier otro turno, no pasa nada útil: *"Soplaste el silbato, pero arriba hay demasiado ruido de maquinaria."*

**Confirmación de rescate.** Cuando la localización llega a 100, el chaleco vibra (la imagen pulsa suavemente) y aparece: *"El chaleco vibra. Te detectaron. Vienen por ti."* A partir de ese momento la temperatura baja la mitad de rápido, porque baja el pánico.

**Respiración guiada.** Si en algún turno el aire baja de 40, el chaleco marca un ritmo lento de vibración: *"El chaleco marca un ritmo lento. Respira con él."* La imagen pulsa despacio durante ese turno y el aire deja de bajar en el siguiente.

## 9. Finales

El rescate llega **siempre al terminar el turno 15**, o antes si la localización llegó a 100 y pasaron 2 turnos más. Entonces se evalúa el final:

| Condición | Título | Texto |
|---|---|---|
| Respondió las 4 preguntas | **RESCATADA CON ÉXITO** | El equipo llegó con tu triage completo. Sabían cómo estabas antes de moverte y te liberaron de forma segura. |
| Respondió la pregunta 3, pero no todas | **RESCATADA** | El equipo llegó y te liberó con seguridad, aunque con información incompleta de tu estado. |
| No respondió la pregunta 3, o quedó en modo automático | **SÍNDROME DE APLASTAMIENTO** | Te encontraron, pero nadie sabía que llevabas horas con un miembro comprimido. Al liberarte de golpe, las toxinas acumuladas en el músculo entraron a tu sangre y tu corazón se detuvo. Por eso el triage tenía que llegar completo. |
| Temperatura llegó a 0 | **HIPOTERMIA** | El concreto te robó el calor. Nunca desplegaste la manta térmica. |
| Aire llegó a 0 | **ASFIXIA** | El polvo de concreto te cerró las vías respiratorias. El tapabocas N95 estaba en el bolsillo. |
| Batería llegó a 0 antes del rescate | **SIN ENERGÍA** | La baliza se apagó y nadie supo dónde buscar. La linterna consume mucho más que la radio. |

Cada final tiene un botón **"Jugar de nuevo"** que reinicia la partida sin recargar la página.

## 10. Pantalla

- **Centro**: la imagen del chaleco, grande, con las zonas interactivas encima.
- **Arriba a la izquierda**: las cuatro barras (temperatura, aire, batería, localización). Las barras se ponen rojas por debajo de 30.
- **Arriba a la derecha**: `Turno X de 15` y el tiempo atrapado.
- **Abajo, centrado**: una sola línea de mensaje con lo último que pasó, y si hay pregunta de triage activa, la pregunta destacada.
- Fondo oscuro con una textura sutil de polvo. Sin fotos externas.
- Pantalla de inicio con el título, tres líneas de instrucciones y un botón **"Empezar"**.

## 11. Errores que NO se pueden cometer

Una versión anterior de este juego tenía estos fallos. Están prohibidos:

1. Que unas acciones cuenten turno y otras no. **Todas cuentan.**
2. Que el bolsillo sea un ciclo donde hay que pasar por el tapabocas y la linterna antes de llegar al silbato. **Debe ser un menú con las tres opciones visibles al mismo tiempo.**
3. Que la ventana de silencio dure segundos reales. **Dura un turno completo.**
4. Que el modo automático solo se verifique cuando el jugador oprime un botón de triage. **Se verifica en cada turno.**
5. Dibujar el chaleco en CSS en vez de usar el modelo 3D (o `chaleco.png` como respaldo).
5b. Dejar la cámara del juego libre o con OrbitControls: durante la partida va **fija en vista frontal**.
5c. Empezar la partida mientras el modelo todavía está cargando.
6. Que los temporizadores sigan corriendo después del final de la partida. **Al terminar, detener todos los intervalos.**
7. Que el contador muestre los minutos reales de juego en vez de las horas de la situación simulada.
8. Dejar variables sin inicializar que terminen mostrando `NaN`.

## 12. Visor 3D (página aparte)

Además del juego hay que entregar un segundo archivo, **`visor.html`**, con un visor del modelo 3D del chaleco. Es un complemento de la sustentación, **no** forma parte del juego.

- Desde el juego se llega con un botón discreto **"Ver en 3D"** en una esquina, que abre `visor.html` en una pestaña nueva.
- Desde el visor se vuelve con un botón **"Volver al juego"**.

### Archivos del modelo

Ya están en la carpeta `modelo/` del repositorio:

```
modelo/base.obj              geometría + coordenadas UV
modelo/texture_diffuse.jpg   el color: jean, manta plateada, botones
modelo/texture_normal.jpg    relieve
modelo/texture_roughness.jpg
modelo/texture_metallic.jpg
```

Además hay **tres variantes** del chaleco, cada una en su subcarpeta con los
mismos cinco archivos (`base.obj` + las cuatro texturas):

```
modelo/capucha/   capucha puesta, sin mangas
modelo/mangas/    mangas desplegadas, cuello alto sin capucha
modelo/ambas/     capucha Y mangas desplegadas
```

**Verifica siempre qué trae cada carpeta antes de conectarla a un botón.** Los
modelos llegan del generador 3D con nombres que no dicen nada (`base.obj` suelto
dentro de un ZIP con un UUID), y ya pasó una vez que la carpeta `mangas/` tenía
en realidad el modelo con capucha: al desplegar las mangas aparecía el chaleco
completo. Míralo renderizado, no te fíes del nombre de la carpeta.

Si alguna carpeta llega a faltar, ese estado se queda con `modelo/base.obj`.
**No lo sustituyas por otra variante**: mostrar mangas que la jugadora no ha
desplegado miente sobre el estado del juego, que es justamente el error que se
corrigió.

Cada variante tiene **UV propias**, así que cada una usa *sus* texturas: no se
pueden mezclar las de una carpeta con el OBJ de otra. Las cuatro mallas se
cargan en segundo plano al empezar la partida y se muestra una sola a la vez.
La combinación manda: `modelo/ambas/` aparece **solo** cuando el jugador ha
desplegado la capucha y las mangas; con una sola de las dos va la variante que
corresponde, y sin ninguna va `modelo/base.obj`.

### Cómo cargarlo (datos verificados del archivo, no los cambies)

- El OBJ tiene **59.998 vértices, 120.000 caras y 73.337 coordenadas UV**. Las UV existen y sirven.
- **El OBJ NO trae archivo `.mtl` ni directivas `usemtl`.** Si lo cargas con `OBJLoader` y ya, el chaleco sale **gris sin textura**. Hay que recorrer la malla y asignarle a mano un `MeshStandardMaterial` con `map` = `texture_diffuse.jpg`, `normalMap`, `roughnessMap` y `metalnessMap`. Esto no es opcional: es el punto del visor.
- El modelo es **Y-up** (exportado desde Blender), así que no hay que rotarlo para three.js.
- Está **normalizado, sin unidades**: mide aproximadamente 1,24 × 1,90 × 0,95 y se apoya sobre el origen, no está centrado. Hay que centrarlo y encuadrar la cámara a partir del *bounding box* calculado en tiempo de carga, no con números fijos.
- Si la textura aparece al revés, corregir con `texture.flipY`.

### Qué debe hacer el visor

- Fondo oscuro, una luz ambiental suave y una luz direccional para que se vea el relieve del jean y el brillo de la manta.
- **OrbitControls**: girar con el mouse, acercar con la rueda, y funcionar también con el dedo en celular.
- Rotación automática lenta al abrir, que se detiene en cuanto el usuario toca el modelo.
- Un indicador de **"Cargando modelo…"** con el porcentaje, porque son unos 16 MB y en la sustentación no puede parecer que se colgó.
- Botones de vista rápida: **Frente · Espalda · Lado**.

### Librerías

Esta es la única excepción a la regla de "sin archivos externos" de la sección 1: el visor puede usar **three.js guardado localmente** en una carpeta `vendor/` del repositorio. Nada de CDN. Se necesitan `three.module.js`, `OBJLoader.js` y `OrbitControls.js`, descargados una sola vez y versionados con el repo.

### Rendimiento

Las texturas ya vienen a **1024 × 1024 en `.jpg`** (bajaron de 43 MB a 3,3 MB en total) y los `base.obj` ya vienen **sin las normales `vn`**, porque el visor llama a `computeVertexNormals()` y las recalcula igual. No los vuelvas a subir en PNG de 2048 ni con normales: el repositorio tiene que poder publicarse en GitHub Pages. **No** reduzcas la malla ni cambies la geometría del `base.obj`: el adelgazamiento permitido es solo quitar `vn` y recortar decimales (4 en `v`, 5 en `vt`), que no mueve ningún vértice de forma visible.

## 13. Criterios de aceptación

La entrega está lista cuando, abriendo el archivo con doble clic y sin internet:

- [ ] Se ve el **modelo 3D con sus texturas** grande y centrado, en vista frontal fija, y las zonas se resaltan al pasar el cursor.
- [ ] El botón "Empezar" solo se habilita cuando el modelo terminó de cargar, mostrando el porcentaje.
- [ ] Si se desactiva WebGL, la página cae a `chaleco.png` y el juego sigue siendo jugable.
- [ ] Una partida completa se juega en menos de 5 minutos.
- [ ] Se alcanzan a usar los siete elementos (interruptor, botones, silbato, linterna, tapabocas, capucha, mangas) dentro de los 15 turnos.
- [ ] Las cuatro preguntas de triage aparecen en los turnos 3, 6, 9 y 12 y se responden con los botones de puntos.
- [ ] Ignorar tres preguntas activa el modo automático y sale un aviso.
- [ ] Ignorar la pregunta 3 y llegar al rescate produce el final de síndrome de aplastamiento.
- [ ] Jugar usando el chaleco con sentido común termina en victoria.
- [ ] Al terminar la partida, las barras dejan de moverse.
- [ ] Funciona en celular a 360 px de ancho sin scroll horizontal.
- [ ] `visor.html` abre el modelo **con sus texturas aplicadas**, no gris.
- [ ] El modelo se puede girar con el mouse y con el dedo, y está centrado en pantalla.
- [ ] Mientras carga se ve el porcentaje, no una pantalla en blanco.
- [ ] Los botones "Ver en 3D" y "Volver al juego" conectan las dos páginas.
