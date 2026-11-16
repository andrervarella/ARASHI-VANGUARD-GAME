#!/bin/sh
# Build do Vercel: copia o jogo para dist/ e baixa as músicas (biblioteca PixelLab do dono)
# listadas na variável secreta MUSIC_URLS ("nome|url;nome|url"). Os links não ficam no repositório.
set -e
mkdir -p dist/music
cp index.* dist/
if [ -n "$MUSIC_URLS" ]; then
  echo "$MUSIC_URLS" | tr ';' '\n' | while IFS='|' read -r nome url; do
    [ -z "$nome" ] && continue
    curl -fsSL "$url" -o "dist/music/$nome.mp3" && echo "musica ok: $nome" || echo "musica falhou: $nome"
  done
fi
ls -la dist dist/music
