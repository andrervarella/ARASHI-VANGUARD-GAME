# TAREFAS — ARASHI VANGUARD

Fila única. **Sem tarefa aberta, nenhuma IA edita arquivo do jogo** (`modulos/TAREFAS_REVISAO_TESTES.md` do método). Pedido direto do dono vira tarefa na hora. Em revezamento, a IA com a vez edita este arquivo.

Etapas: **FAZER → REVISAR → TESTAR → FECHADA** · ou **BLOQUEADA** (com motivo). Commit de cada tarefa começa com o ID (`T-005: ...`). Teste falhou: volta para FAZER.

| ID | Objetivo | Nível | Responsável | Revisor | Etapa | Critério de pronto | Teste | Commit |
|---|---|---|---|---|---|---|---|---|
| T-001 | Importar kit visual v1 + auditoria (`docs/09`) | EXECUÇÃO | Claude (Sonnet) | REVISÃO NÃO FEITA | FECHADA* | 59 arquivos conferidos por script | EXECUTADO: `audit.py` sem divergências | a336269, aa66a66 |
| T-002 | Protótipo de dinâmica jogável (Godot Web): mover, pular, agachar, atacar, Luke, controles de toque | EXECUÇÃO | Claude (Sonnet) | REVISÃO NÃO FEITA | FECHADA* | Dono joga e aprova a dinâmica | EXECUTADO (EMULADO): render Xvfb conferido; dono aprovou em 15/11 | 88b1634 |
| T-003 | **Portão V:** pacote visual mínimo (tela inicial, Ren oficial, rival/chefe protótipo, cenário/mapa, HUD) + história curta + roteiro de cenas; dono responde 3 sim/não | CRIATIVO | Claude (Opus) | dono (revisão leve: texto e imagens) | FAZER (em andamento: GDD v0 escrito; imagens aguardam o "ok" de custo) | Dono diz "gostei" nas 3 perguntas | — | — |
| T-004 | Ordem de serviço ao Codex: **lote-piloto de animação do Ren oficial** (~12 quadros: parado, corrida, pulo, agachar, andar agachado, golpe), ~128 px de altura (testar 96–192), PNG transparente, pivô nos pés | CRIATIVO→EXECUÇÃO | Codex (PixelLab) | Claude | FAZER (bloqueada por custo) | Quadros aprovados pelo dono; manifesto preenchido | — | — |
| T-005 | Remover Ren/Luke desenhados por código; usar imagens/lote aprovados (DEC-010) | EXECUÇÃO | Sonnet | outro agente | FAZER | Nada de personagem por código; Luke com cores oficiais | smoke + render | — |
| T-006 | Tela inicial com animação leve + introdução com a história + **versão/commit visível na tela** | EXECUÇÃO | Sonnet | outro agente | FAZER | Primeiros 10 s com gancho; pulável | render + dono | — |
| T-007 | Testes automáticos (Godot headless) + GitHub Actions (`.github/workflows/testes.yml`) + smoke de export | EXECUÇÃO | Sonnet | outro agente | FAZER | `npm test`/equivalente roda e passa no push | saída anexada | — |
| T-008 | **Especificar** botão de magia/poder e combos (janela de entrada, buffer, hitboxes, hit-stop, medidor de Ruptura, layout de 3 botões) e depois implementar | CRIATIVO→EXECUÇÃO | Fable → Sonnet | outro agente | FAZER | Especificação aprovada pelo dono; link atualizado | dono joga | — |
| T-009 | **Portão 1:** microárea da forja, 2 inimigos, mini-chefe com 2 fases **seguindo o modelo de `docs/10` (ciclo fixo, telégrafo, janela de punição)**, 1 poder, tela de 3 recompensas com persistência | EXECUÇÃO | Sonnet | outro agente | FAZER | Dono responde 3 sim/não e confirma que o padrão do mini-chefe é legível | dono joga | — |
| T-010 | Arte final do HUD (botões, direcional, ícones) como assets | EXECUÇÃO | Codex/PixelLab | Claude | FAZER | Arte aprovada; sem círculos crus | dono | — |
| T-011 | Reconectar conector PixelLab ("Pixellab2" precisa reconectar) e **informar custo** | — | Dono + IA | — | BLOQUEADA | Custo conhecido e autorizado | — | — |
| T-013 | **Especificar** o sistema de chefes e balanceamento: ciclo de ataque de cada chefe, planilha item × chefe (21 itens, afinidades −2..+2), script de soma por item e por trilha, texto das cartas de escolha (`docs/10`) | CRIATIVO | Fable | outro agente | FAZER | Especificação aprovada pelo dono; somas dentro da faixa | script rodado + dono joga 2 trilhas | — |
| T-012 | Fichas individuais de Mei Shian, Shuyin e Seiran; novos recortes do Ren oficial | CRIATIVO | Codex/Fable | — | FAZER | Fichas aprovadas | — | — |

\* Fechadas sem revisão independente e com a regra 3 do método quebrada (DEC-010); a revisão cruzada entra junto com T-005.

## Ordem de serviço

Use o formato da seção 2 de `modulos/COMUNICACAO_CLAUDE_CODEX.md` (repositório do método) ao delegar. O texto pronto para abrir uma sessão do Fable está em `docs/PROMPT_FABLE_JOGO_COMPLETO.md`.
