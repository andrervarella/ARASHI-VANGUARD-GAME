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

## 2026-11-17 — v0.12 contato KOF
- EXECUTADO (EMULADO): Ren andando sem parar contra o Baku (Vale das Torii): todo dano registrado veio de `slash` ou da onda/pisão; encostado no Baku cansado, distância travou em ~59 px sem dano.
- EXECUTADO (EMULADO): andando pelas fases 2 e 3, todo dano veio de `strike` ou projéteis. Espírito do palácio: acorda, avisa, acerta 1 vez e recua (capturas conferidas).
- NÃO TESTADO: sensação no celular (empurrão, pisão), FPS.

## 2026-11-17 — v0.13
- EXECUTADO (EMULADO): todas as cenas (título, abertura, 4 fases, memória) rodam sem erro de script ou shader.
- EXECUTADO (EMULADO): emboscada do Vale (paredes, ondas); Bocarra de Jade nova; servo acorrentado e santuário no lugar; memória do portão do começo ao fim (volta ao Refúgio); Baku com golpe carregado, contador e barra de postura (robô parado: Baku a ~30% em ~5 s trocando golpes; o robô também morre).
- NÃO TESTADO: sensação no celular (segurar ATAQUE, cima+ATAQUE no direcional), filtro da música no navegador, desempenho com o primeiro plano.

## 2026-11-17 — v0.14
- EXECUTADO (Chrome sem tela, versão web real): saída de áudio medida por analisador. v0.12 = sinal; v0.13 = zero; v0.14 = sinal. Músicas remotas não testadas localmente (vêm do deploy).
- EXECUTADO (EMULADO): todas as fases sem erro de script; barricada da emboscada; Refúgio com aldeões novos; combos Investida e Ascendente disparando; transformação completa contra o Xui (meia vida).
- NÃO TESTADO: toque real no botão de chute; sensação dos combos; desempenho com 22 aldeões animados na fuga.

## 2026-11-17 — v0.15
- EXECUTADO (EMULADO): curativo do Luke pelo atalho `--testcurativo` (gotas, Ren ajoelhado, lenço aparece depois do nó); todas as fases sem erro de script.
- EXECUTADO (Chrome, versão web): áudio com sinal (ver resultado no commit).
- NÃO TESTADO: as músicas novas tocando no site (baixadas só no build da Vercel); não ouvi as músicas (sem áudio aqui); sensação dos chutes no celular.

## 2026-11-17 — v0.16
- EXECUTADO (EMULADO): masmorra do começo ao fim (cela, chaves, porta, saída); duelo antes do Baku (resultado "cedo demais" com o robô); todas as fases sem erro.
- NÃO TESTADO: acertar o duelo no toque real; golpe com retrato na web (usa Engine.time_scale); Luke ao resgate em luta real.
