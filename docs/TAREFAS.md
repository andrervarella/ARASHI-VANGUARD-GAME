# TAREFAS — ARASHI VANGUARD

Fila única. **Sem tarefa aberta, nenhuma IA edita arquivo do jogo** (`modulos/TAREFAS_REVISAO_TESTES.md` do método). Pedido direto do dono vira tarefa na hora. Em revezamento, a IA com a vez edita este arquivo.

Etapas: **FAZER → REVISAR → TESTAR → FECHADA** · ou **BLOQUEADA** (com motivo). Commit de cada tarefa começa com o ID (`T-005: ...`). Teste falhou: volta para FAZER.

| ID | Objetivo | Nível | Responsável | Revisor | Etapa | Critério de pronto | Teste | Commit |
|---|---|---|---|---|---|---|---|---|
| T-001 | Importar kit visual v1 + auditoria (`docs/09`) | EXECUÇÃO | Claude (Sonnet) | REVISÃO NÃO FEITA | FECHADA* | 59 arquivos conferidos por script | EXECUTADO: `audit.py` sem divergências | a336269, aa66a66 |
| T-002 | Protótipo de dinâmica jogável (Godot Web): mover, pular, agachar, atacar, Luke, controles de toque | EXECUÇÃO | Claude (Sonnet) | REVISÃO NÃO FEITA | FECHADA* | Dono joga e aprova a dinâmica | EXECUTADO (EMULADO): render Xvfb conferido; dono aprovou em 15/11 | 88b1634 |
| T-003 | **Portão V:** pacote visual mínimo (tela inicial, Ren oficial, rival/chefe protótipo, cenário/mapa, HUD) + história curta + roteiro de cenas; dono responde 3 sim/não | CRIATIVO | Claude (Opus) | dono (revisão leve: texto e imagens) | FAZER (em andamento: GDD v0 escrito; imagens aguardam o "ok" de custo) | Dono diz "gostei" nas 3 perguntas | — | — |
| T-004 | Ordem de serviço ao Codex: **lote-piloto de animação do Ren oficial** (~12 quadros: parado, corrida, pulo, agachar, andar agachado, golpe), ~128 px de altura (testar 96–192), PNG transparente, pivô nos pés | CRIATIVO→EXECUÇÃO | Codex (PixelLab) | Claude | FAZER (bloqueada por custo) | Quadros aprovados pelo dono; manifesto preenchido | — | — |
| T-005 | Remover Ren/Luke desenhados por código; usar imagens/lote aprovados (DEC-010) | EXECUÇÃO | Sonnet | outro agente | REVISAR (feito em T-015) | Nada de personagem por código; Luke com cores oficiais | smoke + render | — |
| T-006 | Tela inicial com animação leve + introdução com a história + **versão/commit visível na tela** | EXECUÇÃO | Sonnet | outro agente | FAZER | Primeiros 10 s com gancho; pulável | render + dono | — |
| T-007 | Testes automáticos (Godot headless) + GitHub Actions (`.github/workflows/testes.yml`) + smoke de export | EXECUÇÃO | Sonnet | outro agente | FAZER | `npm test`/equivalente roda e passa no push | saída anexada | — |
| T-008 | **Especificar** botão de magia/poder e combos (janela de entrada, buffer, hitboxes, hit-stop, medidor de Ruptura, layout de 3 botões) e depois implementar | CRIATIVO→EXECUÇÃO | Fable → Sonnet | outro agente | FAZER | Especificação aprovada pelo dono; link atualizado | dono joga | — |
| T-009 | **Portão 1:** microárea da forja, 2 inimigos, mini-chefe com 2 fases **seguindo o modelo de `docs/10` (ciclo fixo, telégrafo, janela de punição)**, 1 poder, tela de 3 recompensas com persistência | EXECUÇÃO | Sonnet | outro agente | FAZER | Dono responde 3 sim/não e confirma que o padrão do mini-chefe é legível | dono joga | — |
| T-010 | Arte final do HUD (botões, direcional, ícones) como assets | EXECUÇÃO | Codex/PixelLab | Claude | FAZER | Arte aprovada; sem círculos crus | dono | — |
| T-011 | Reconectar conector PixelLab e **informar custo** | — | Dono + IA | — | FECHADA | Custo conhecido e autorizado | EXECUTADO: conector personalizado responde (avaliação: 40 gerações, 0 usadas, +5/dia); custos em `docs/11` | — |
| T-013 | **Especificar** o sistema de chefes e balanceamento: ciclo de ataque de cada chefe, planilha item × chefe (21 itens, afinidades −2..+2), script de soma por item e por trilha, texto das cartas de escolha (`docs/10`) | CRIATIVO | Fable | outro agente | FAZER | Especificação aprovada pelo dono; somas dentro da faixa | script rodado + dono joga 2 trilhas | — |
| T-014 | **Acervo V4.4:** organizar arte no Drive (00–05), `docs/ACERVO_DRIVE.md`, manifesto com hash/status/local | EXECUÇÃO | Claude (Opus) | outro agente | REVISAR | Drive listado confere com o manifesto; nada sobrescrito; sem link privado no repo | EXECUTADO: 56 arquivos no Drive (7 como cópia sem perda, pixels conferidos); kit.zip redundante; cenário Fenaky pendente | (este commit) |
| T-015 | **Fases 1 e 2 jogáveis** (título, storyboard, tutorial, Baku, Vila, Xui, poderes, itens, HUD com PODER, SFX/músicas) | EXECUÇÃO | Claude (Opus) | outro agente | TESTAR (dono joga) | Dono joga as duas fases no celular e aprova | EXECUTADO (EMULADO): headless sem erros; render Xvfb de título, história, 4 fases e 2 chefes conferido; jogador automático percorre fases | 26279bb (dev), 39c2495 (web-build) |
| T-016 | **v0.3 pelo retorno do dono:** câmera próxima, DEFESA/aparo, arte de objetos e ícones, efeitos novos, história das Sete Terras e linguagem épica | EXECUÇÃO | Claude (Opus) | outro agente | TESTAR (dono joga) | Dono aprova no celular | EXECUTADO (EMULADO): headless sem erros em 7 cenas; render Xvfb 1170×540 conferido | ccf12bc (dev), f274a4f (web-build) |
| T-017 | **v0.4 pelo 2º retorno:** chão/buracos, caixas, duplicação, arena concentrada, morte dos chefes, combo de 5, andar defendendo, botões ilustrados, falas do Baku, fundo do refúgio | EXECUÇÃO | Claude (Opus) | outro agente | TESTAR (dono joga) | Dono aprova no celular | EXECUTADO (EMULADO): 7 cenas sem erro; render da morte dos dois chefes, buraco, hub e combo | ver git log |
| T-018 | Sprites da **Forma Carmesim** a partir da arte oficial (AV-FIC-002) + evento no fim da fase 2 | CRIATIVA | Claude | dono | TESTAR (dono joga) | Dono aprova o visual no celular | EXECUTADO (EMULADO): estado PixelLab `36f2ce1b`, 13 animações montadas; despertar na metade do Xui e calma pelo Luke renderizados | ver git log |
| T-019a | **v0.5 pelo 3º retorno (DEC-020):** abertura nova, prólogo com Luke de rua/soldado/lenço/portão aberto/povo fugindo/luta impossível com a Ira, legendas por toque, zoom 1,2, título inteiro, esquiva, queda, corrida fluida, poderes como aura+elemento | EXECUÇÃO | Claude (Opus) | outro agente | TESTAR (dono joga) | Dono aprova no celular | EXECUTADO (EMULADO): 6 cenas sem erro; render do prólogo, título e poderes | ver git log |
| T-019 | Pôster de todos os chefes com o **novo chefe final** (DEC-021) e depois ficha/sprites do Shin-Oni | CRIATIVA | Claude | dono | AGUARDANDO ESCOLHA DO DONO | Dono escolhe uma das 2 versões | 2 versões geradas no Fenaky (Muse Image, 0,2 crédito); **não conferidas visualmente pelo Claude** (download bloqueado no ambiente) | — |
| T-012 | Fichas individuais de Mei Shian, Shuyin e Seiran; novos recortes do Ren oficial | CRIATIVO | Codex/Fable | — | FAZER | Fichas aprovadas | — | — |

\* Fechadas sem revisão independente e com a regra 3 do método quebrada (DEC-010); a revisão cruzada entra junto com T-005.

## Ordem de serviço

Use o formato da seção 2 de `modulos/COMUNICACAO_CLAUDE_CODEX.md` (repositório do método) ao delegar. O texto pronto para abrir uma sessão do Fable está em `docs/PROMPT_FABLE_JOGO_COMPLETO.md`.


## Atualização de handoff do lote visual — 16/11/2026

- **AV-FIC-001 a AV-FIC-015:** 15 imagens salvas no Drive e verificadas por listagem; documento de instruções e manifesto JSON também no Drive. IDs/hashes em `docs/12_HANDOFF_FICHAS_PIXELLAB_2026-11-16.md`.
- **T-004:** ainda **NÃO executado**. Claude é responsável pelo piloto de sprites Ren no PixelLab e depois integração/teste no Godot; verificar custo e obter aprovações.
- **T-012:** fichas de personagens reunidas; faltam revisão técnica de fidelidade, ficha de poses Seiran (opcional para começar piloto Ren) e confirmação de que Claude conseguiu ler os arquivos no Drive.
- **Inimigos comuns:** autorizado pelo dono uso de briefing textual em vez de fichas individuais.
