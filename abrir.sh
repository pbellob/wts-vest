#!/usr/bin/env bash
# Levanta el servidor local y abre el juego WTS en el navegador.
# Uso: ./abrir.sh      (Ctrl+C para detenerlo)
cd "$(dirname "$0")" || exit 1
PUERTO=8000
while lsof -i :$PUERTO >/dev/null 2>&1; do PUERTO=$((PUERTO+1)); done
echo "Servidor en http://localhost:$PUERTO/index.html"
python3 -m http.server "$PUERTO" >/dev/null 2>&1 &
SRV=$!
trap 'kill $SRV 2>/dev/null' EXIT
sleep 1
xdg-open "http://localhost:$PUERTO/index.html" >/dev/null 2>&1
echo "Ctrl+C para detener el servidor."
wait $SRV
