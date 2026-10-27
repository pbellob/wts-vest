# WTS — Protocolo de supervivencia

### ▶ [Jugar ahora](https://pbellob.github.io/wts-vest/)

**https://pbellob.github.io/wts-vest/** — se abre en el navegador, no hay que
instalar ni descargar nada. Funciona en computador y en celular.

---

Juego interactivo de *mixed reality* del **WTS**, un chaleco de supervivencia
para personas atrapadas bajo escombros después de un terremoto.

Proyecto del curso **Diseño de Sistemas Electrónicos** · UNAL 2026-2

## De qué se trata

Quedaste atrapada bajo una losa de concreto, a oscuras, con el chaleco WTS
puesto. Tienes **15 turnos** y **20 segundos reales por turno**: si no actúas,
el turno pasa solo y el frío, el polvo y la batería siguen corriendo en vivo.

El chaleco tiene cuatro botones con puntos en relieve que se cuentan con el
dedo a oscuras, una capucha y unas mangas térmicas que se despliegan, y un
bolsillo con silbato, linterna y tapabocas N95. Cada tanto hace una pregunta
de triage; si dejas de responder, asume que estás inconsciente y pasa a modo
automático.

Hay siete finales distintos. Uno de ellos es el **síndrome de aplastamiento**,
que es real: liberar de golpe un miembro comprimido muchas horas puede matar
a la persona al sacarla.

## Si lo quieres ver por dentro

| Archivo | Qué es |
|---|---|
| `index.html` | El juego completo, en un solo archivo |
| `visor.html` | Visor 3D del chaleco, se puede girar con el mouse |
| `CONTRATO.md` | La especificación completa con la que se construyó |
| `modelo/` | Las cuatro mallas del chaleco (cerrado, capucha, mangas, ambas) con sus texturas |
| `chaleco.png` | Render del chaleco; se usa de respaldo si el equipo no soporta WebGL |
| `abrir.sh` | Solo para desarrollo: levanta un servidor local |

## Correrlo en tu propio computador

No hace falta para jugar —para eso está el link de arriba—, pero si quieres
modificarlo:

```bash
git clone https://github.com/pbellob/wts-vest.git
cd wts-vest
./abrir.sh
```

No abras `index.html` con doble clic: el navegador bloquea la carga del modelo
3D y las texturas cuando se usa `file://`. Por eso está `abrir.sh`, que levanta
un servidor local y abre el navegador solo.
