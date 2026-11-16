# TESTES — ARASHI VANGUARD

| Data | Versão/commit | Ambiente | O que foi executado | Resultado | Evidência |
|---|---|---|---|---|---|
| 2026-11-15 | `88b1634` (v7) | Godot 4.4.1 headless, Linux | `--quit-after 60`, sem erros de script | PASSOU | saída sem "error/parse" |
| 2026-11-15 | `88b1634` (v7) | Xvfb + OpenGL, 1166×540 | render com `--demo-stick` (baixo+direita): Ren andou agachado, direcional desenhado | PASSOU (EXECUTADO (EMULADO)) | quadro PNG conferido por inspeção visual |
| 2026-11-15 | `88b1634` (v7) | Celular Android do dono, Chrome, tela cheia | dono jogou o link e aprovou a dinâmica (prints de v3 e v4 mostraram controles e câmera) | APROVADO PELO DONO | mensagens do chat; **toque multitoque não testado por IA** |
| 2026-11-15 | — | — | FPS, tempo de carga (~43 MB de wasm), áudio | NÃO TESTADO | — |
| — | — | — | `npm test`/testes automáticos | NÃO EXISTEM ainda (T-007) | — |

## Smoke test (web)
Ainda não automatizado. Plano: Playwright/Chromium headless abre o link, 0 erros no console, ~60 s de entradas, screenshot (T-007). Rótulo EXECUTADO (EMULADO); não substitui o aparelho.

## Playtests
| Data | Versão | Jogadores | Achados observados | Decisão |
|---|---|---|---|---|
| 2026-11-15 | v1–v7 | só o dono | v1: botões grandes e à direita; v2: botões sumiram (bug); v4: botão de pulo colidia com o botão de sair da tela cheia; v5: "baixo" acima das setas (fora da convenção); v6: andar agachado exigia dois toques | corrigidos até a v7 (ver `docs/APRENDIZADOS.md`) |

Testador único = **"SÓ DONO"**.

## Scorecard
Não aplicado (Portão 2 ainda longe).

## 2026-11-16 — T-015 (fases 1 e 2), commit 26279bb
- EXECUTADO: `godot --headless --import` sem erros; cada cena (título, história, 4 fases, recompensa) roda 400 quadros headless sem erro de script.
- EXECUTADO (EMULADO): render Xvfb 960×540 com jogador automático (`--auto`): título, abertura, ferreiros (viga, combo), torii (plataformas, inimigos), arena do Baku, arena do Xui (vapor, Bocarra de Jade), Vila (Tetsu). Imagens conferidas.
- EXECUTADO: export Web (wasm 43,7 MB, pck 16,5 MB) e deploy no Vercel a partir de `web-build` 39c2495.
- NÃO TESTADO: toque real no Android, FPS no celular, áudio no navegador, dificuldade com jogador humano, fluxo completo de ponta a ponta numa única partida.
