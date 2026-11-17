# TESTES — ARASHI VANGUARD

| Data | Versão/commit | Ambiente | O que foi executado | Resultado | Evidência |
|---|---|---|---|---|---|
| 2026-11-15 | `88b1634` (v7) | Godot 4.4.1 headless, Linux | `--quit-after 60`, sem erros de script | PASSOU | saída sem "error/parse" |
| 2026-11-15 | `88b1634` (v7) | Xvfb + OpenGL, 1166×540 | render com `--demo-stick` (baixo+direita): Ren andou agachado, direcional desenhado | PASSOU (EXECUTADO (EMULADO)) | quadro PNG conferido por inspeção visual |
| 2026-11-15 | `88b1634` (v7) | Celular Android do dono, Chrome, tela cheia | dono jogou o link e aprovou a dinâmica (prints de v3 e v4 mostraram controles e câmera) | APROVADO PELO DONO | mensagens do chat; **toque multitoque não testado por IA** |
| 2026-11-15 | — | — | FPS, tempo de carga (~43 MB de wasm), áudio | NÃO TESTADO | — |
| 2026-11-16 | v0.5 (dev) | Xvfb + OpenGL, 1170×540 | 6 cenas 600 quadros sem erro; render do prólogo (cerca, cão, soldado, portão aberto, povo fugindo, luta com a Ira, queda, luz do pingente), título e poderes Fúria/Jade | PASSOU (EXECUTADO (EMULADO)) | PNGs conferidos por inspeção; **esquiva e toque não testados no aparelho** |
| 2026-11-16 | v0.6 (dev) | Xvfb + OpenGL, 1170×540 | luta do Xui com `--halfboss --killboss`: despertar da Forma Carmesim, luta transformado, calma pelo Luke, poder liberado; sem erros de script | PASSOU (EXECUTADO (EMULADO)) | PNGs conferidos; diálogos pulados (`--nodlg`) |
| 2026-11-16 | v0.7 (dev) | Godot headless + Xvfb 1170×540 | 8 cenas sem erro de script; renders: oni saltador (salta e cai com onda), cansaço ao fim da Forma Carmesim, altar, barreiras de névoa/selo | PASSOU (EXECUTADO (EMULADO)) | PNGs conferidos; **toque, ritmo e dificuldade não testados no aparelho** |
| 2026-11-16 | v0.9 (dev) | Godot headless + Xvfb 1170×540 | todas as cenas sem erro; renders: chão alinhado nas 4 fases, andar (`--demo-walk`), fuga com 8 aldeões, jaula libertada, Refúgio com 6 libertos | PASSOU (EXECUTADO (EMULADO)) | PNGs conferidos; **controle físico e andar por toque não testados no aparelho** |
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

## 2026-11-16 (tarde) — T-016 v0.3, commit ccf12bc
- EXECUTADO: import sem erros; 7 cenas rodam 500 quadros headless com jogador automático, sem erro de script.
- EXECUTADO (EMULADO): render Xvfb 1170×540 (tela larga de celular): palácio com parede rachada (arte nova), torii, refúgio com portais torii, recompensa com ícones, sequência do Grande Portão → storyboard "cicatriz", legenda com faixa escura.
- Corrigido no caminho: texturas carregadas dentro de `_draw` sem referência ficavam brancas (agora ficam em cache).
- NÃO TESTADO: toque real (DEFESA/aparo no celular), FPS, áudio no navegador, dificuldade com jogador humano.

## 2026-11-16 (noite) — T-017 v0.4
- EXECUTADO: 7 cenas rodam 600 quadros headless com jogador automático, sem erro de script.
- EXECUTADO (EMULADO): render 1170×540 da morte do Baku e do Xui (explosões, dissolução, rastro ao selo), buraco do Vale das Torii, refúgio com fundo novo, combo no prólogo.
- Causa provável da duplicação relatada: duas trocas de cena ao mesmo tempo (ex.: morrer enquanto o chefe morre). Corrigido com trava em `Game.goto` e limpeza do grupo "cena". Não reproduzido pela IA; precisa confirmação do dono.
- NÃO TESTADO: toque real, FPS, áudio no navegador.
