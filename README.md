# WTS — Protocolo de supervivencia

Juego interactivo de *mixed reality* del **WTS**, un chaleco de supervivencia
para personas atrapadas bajo escombros después de un terremoto.

Proyecto del curso **Diseño de Sistemas Electrónicos** · UNAL 2026-2

## Contenido

| Archivo | Qué es |
|---|---|
| `index.html` | El juego: 15 turnos, triage y finales |
| `visor.html` | Visor 3D del chaleco |
| `CONTRATO.md` | Especificación completa del desarrollo |
| `modelo/` | Modelo 3D (OBJ) y texturas PBR |
| `chaleco.png` | Render del chaleco, respaldo si falla WebGL |
| `abrir.sh` | Lanzador local (levanta un servidor y abre el juego) |

## Cómo jugarlo en local

```bash
./abrir.sh
```

No abras los archivos con doble clic: el navegador bloquea la carga del
modelo y las texturas cuando se usa `file://`.
