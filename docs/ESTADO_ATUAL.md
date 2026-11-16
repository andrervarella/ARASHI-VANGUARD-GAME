# ESTADO ATUAL DO JOGO — ARASHI VANGUARD

> Leitura obrigatória de quem chega. Se divergir do Git, vale o Git.

- Atualizado em: 2026-11-15 21:40 (America/Sao_Paulo)
- Fonte de verdade: https://github.com/andrervarella/ARASHI-VANGUARD-GAME
- Branch canônica: `main` (só docs antigos até o dono aprovar o PR) · **Branch de trabalho: `dev`** (tem tudo)
- **Commit-base desta atualização:** `8417365` (dev)
- Link jogável de teste: https://arashi-vanguard-prototipo.vercel.app (v7; sem versão visível na tela ainda — T-006)
- Método: Prompt Mestre Universal **V4.4** (acervo Drive + GitHub, DEC-014) (`andrervarella/PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES`)
- Estágio: **conceito aprovado + protótipo de dinâmica**; Portão V ainda não passado
- Quem está com a vez: ninguém (próxima: sessão com Fable, `docs/PROMPT_FABLE_JOGO_COMPLETO.md`)

## Implementado e confirmado
- Kit visual v1 (59 arquivos + prancha oficial do Ren) importado e verificado por script: `assets/`, `docs/09_AUDITORIA_KIT_v1.md` (EXECUTADO).
- Ajustes narrativos aprovados: `docs/02` e DEC-005.
- Protótipo Godot 4.4.1 Web (v7), `godot/`: andar, pular, agachar/andar agachado, atacar, Luke seguidor, 4 bonecos de treino, túnel baixo, controles de toque (direcional único deslizante + PULAR/ATACAR). Render conferido em Xvfb (EXECUTADO (EMULADO)); **dono jogou e aprovou a dinâmica** em 15/11.
- Documentos de controle do método criados (este arquivo, DECISOES, TAREFAS, HANDOFF, TESTES, APRENDIZADOS, MANIFESTO_ASSETS) e `docs/CONTROLES_E_CONVENCOES.md`.

## Em andamento
- T-003 (Portão V): GDD v0 pronto; cenário do distrito dos ferreiros gerado no Fenaky e aprovado pelo dono ("gostei"). Tela de título com o Ren foi **recusada pelo Fenaky** (rosto realista); próximo passo: dono gera fichas e telas do Ren no ChatGPT e envia.
- T-014 (acervo V4.4): 56 arquivos no Drive (7 como cópia sem perda); `kit.zip` redundante; cenário do Fenaky **pendente** (dono baixa e envia). Ver `docs/ACERVO_DRIVE.md`.

## Pendente / bloqueado
- Lote-piloto de animação do Ren (T-004): PixelLab conectado (avaliação de 40 gerações, nada gasto); aguarda ficha limpa do Ren (ChatGPT) e o "ok" do dono. Plano de ferramentas e custos: `docs/11_PLANO_DE_PRODUCAO_E_CUSTOS.md`.
- Personagens desenhados por código violam o método (DEC-010): substituir antes do Portão 1 (T-005).
- Sem menu, introdução, testes automáticos nem GitHub Actions (T-006, T-007).
- Botão de magia/poder e combos: pedidos do dono, sem especificação (T-008).
- Chefes com padrão fixo (estilo Mega Man) e itens que mudam a dificuldade sem combinação melhor: princípios aprovados (DEC-013), rascunho em `docs/10_CHEFES_E_BALANCEAMENTO.md`, especificação e planilha em T-013.
- Regra do dono (DEC-012): consultar e seguir o método geral (`PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES`) antes de criar.
- Sem revisão independente de T-001 e T-002.

## Testes recentes
- 2026-11-15, `88b1634`: headless sem erros; render Xvfb OK; dono aprovou no celular. FPS/carga/áudio NÃO TESTADOS. Detalhes em `docs/TESTES.md`.

## Próxima ação objetiva
- Dono: baixar o cenário do Fenaky e enviar ao Drive (`03_CENARIOS_UI`); gerar no ChatGPT a ficha (frente/lado/costas) do Ren e mandar. IA: conferir a ficha, registrar no Drive (`01`) e no manifesto, e então propor o Ren piloto no PixelLab (custo antes).

## Atenção
Este arquivo não comprova conclusão sozinho. Fotos do dono e de Luke não entram no repositório público.
