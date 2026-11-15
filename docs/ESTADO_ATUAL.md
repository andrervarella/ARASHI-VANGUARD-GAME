# ESTADO ATUAL DO JOGO — ARASHI VANGUARD

> Leitura obrigatória de quem chega. Se divergir do Git, vale o Git.

- Atualizado em: 2026-11-15 18:40 (America/Sao_Paulo)
- Fonte de verdade: https://github.com/andrervarella/ARASHI-VANGUARD-GAME
- Branch canônica: `main` (só docs antigos até o dono aprovar o PR) · **Branch de trabalho: `dev`** (tem tudo)
- **Commit-base desta atualização:** `e7ab5de` (merge das branches de importação e de história)
- Link jogável de teste: https://arashi-vanguard-prototipo.vercel.app (v7; sem versão visível na tela ainda — T-006)
- Método: Prompt Mestre Universal V4.3 (`andrervarella/PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES`)
- Estágio: **conceito aprovado + protótipo de dinâmica**; Portão V ainda não passado
- Quem está com a vez: ninguém (próxima: sessão com Fable, `docs/PROMPT_FABLE_JOGO_COMPLETO.md`)

## Implementado e confirmado
- Kit visual v1 (59 arquivos + prancha oficial do Ren) importado e verificado por script: `assets/`, `docs/09_AUDITORIA_KIT_v1.md` (EXECUTADO).
- Ajustes narrativos aprovados: `docs/02` e DEC-005.
- Protótipo Godot 4.4.1 Web (v7), `godot/`: andar, pular, agachar/andar agachado, atacar, Luke seguidor, 4 bonecos de treino, túnel baixo, controles de toque (direcional único deslizante + PULAR/ATACAR). Render conferido em Xvfb (EXECUTADO (EMULADO)); **dono jogou e aprovou a dinâmica** em 15/11.
- Documentos de controle do método criados (este arquivo, DECISOES, TAREFAS, HANDOFF, TESTES, APRENDIZADOS, MANIFESTO_ASSETS) e `docs/CONTROLES_E_CONVENCOES.md`.

## Em andamento
- Nada aberto.

## Pendente / bloqueado
- Portão V (T-003) e lote-piloto de animação do Ren (T-004, depende de PixelLab; conector precisa reconectar; custo **não verificado**).
- Personagens desenhados por código violam o método (DEC-010): substituir antes do Portão 1 (T-005).
- Sem menu, introdução, testes automáticos nem GitHub Actions (T-006, T-007).
- Botão de magia/poder e combos: pedidos do dono, sem especificação (T-008).
- Sem revisão independente de T-001 e T-002.

## Testes recentes
- 2026-11-15, `88b1634`: headless sem erros; render Xvfb OK; dono aprovou no celular. FPS/carga/áudio NÃO TESTADOS. Detalhes em `docs/TESTES.md`.

## Próxima ação objetiva
- Fable abre T-003: pacote visual mínimo + história curta + roteiro de cenas, mostrando **uma imagem por vez**; dono responde 3 sim/não (Portão V). Em paralelo, ordem de serviço ao Codex para T-004 (sem gastar crédito antes do "ok").

## Atenção
Este arquivo não comprova conclusão sozinho. Fotos do dono e de Luke não entram no repositório público.
