#!/bin/sh
# Build do Vercel: copia o jogo para dist/ e baixa músicas e efeitos (biblioteca PixelLab do dono)
# listados nas variáveis secretas MUSIC_URLS, MUSIC_URLS_2 e SFX_URLS ("nome|url;nome|url").
# Os links não ficam no repositório.
set -e
mkdir -p dist/music dist/sfx
cp index.* dist/
baixar() {
  lista="$1"; pasta="$2"; ext="$3"
  [ -z "$lista" ] && return 0
  echo "$lista" | tr ';' '\n' | while IFS='|' read -r nome url; do
    [ -z "$nome" ] && continue
    curl -fsSL "$url" -o "dist/$pasta/$nome.$ext" && echo "ok: $pasta/$nome" || echo "falhou: $pasta/$nome"
  done
}
baixar "$MUSIC_URLS" music mp3
baixar "$MUSIC_URLS_2" music mp3
baixar "$SFX_URLS" sfx wav
ls -la dist dist/music dist/sfx
