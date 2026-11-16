# REGISTRO DE DECISÕES APROVADAS

Uma entrada por decisão relevante. Não apague: marque como substituída. Ideias em estudo não são decisões.

## DEC-001 — Autorização permanente de commit e push na branch de trabalho
- Data: 2026-11-15 · Estado: **proposta** (vira aprovada quando o dono confirmar)
- Decisão: as IAs podem fazer commit e push na branch `dev` sem pedir a cada vez. Merge na `main`, gastos e publicação continuam pedindo autorização do dono.
- Aprovada por: não confirmada · Substitui: nenhuma

## DEC-002 — Método Prompt Mestre Universal V4.3 adotado
- Data: 2026-11-15 · Estado: aprovada (padrão do dono, registrado em conversa anterior)
- Decisão: seguir `andrervarella/PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES` (V4.3). **Revezamento** entre IAs, uma por vez, na branch `dev`; merge na `main` só nos portões (V, 1, 2, 3) com o "ok" do dono. Tarefa → FAZER → REVISAR (outro agente) → TESTAR → FECHADA; um commit por tarefa com o ID.
- Observação: até 15/11 o protótipo foi feito **sem seguir o método** (ver DEC-010).

## DEC-003 — Designs oficiais
- Data: 2026-11-15 · Estado: aprovada pelo dono
- Ren oficial = prancha "Ren Arashi — O Guerreiro Errante" (manto preto, katana, máscara oni): `assets/referencias-aprovadas/protagonistas/Ren_Guerreiro_Errante_prancha_OFICIAL.png`. Luke oficial = ficha de pré-produção (`Luke_ficha_conceitual_original.png`). O design "Ren árabe" (pôster e `recortes-referencia/ren/`) está **superado**.
- Luke (AGENTS.md): cão pequeno branco com manchas castanhas e olhos azuis.

## DEC-004 — Rosto do Ren e fotos
- Data: 2026-11-15 · Estado: aprovada
- Ren é inspirado no dono (barba cheia, porte forte), com **cabelo um pouco mais comprido** que nas fotos. Fotos do dono e de Luke **não** entram no repositório público.

## DEC-005 — Ajustes narrativos
- Data: 2026-11-15 · Estado: aprovada pelo dono
- Seis ajustes em `docs/02_HISTORIA_E_UNIVERSO.md` ("Ajustes narrativos aprovados"): culpa real do Ren; selos com marcas de ofício; final com reforja do selo; aliado-descendente por mundo; mistério leve de Luke; escolha final jogável. Detalhes marcados "a definir" seguem abertos.

## DEC-006 — Plataforma e publicação do teste
- Data: 2026-11-15 · Estado: aprovada na prática (dono joga o link)
- Godot **4.4.1**, GL Compatibility, **export Web sem threads**, jogado no navegador do celular (Android), paisagem. Link jogável de teste: https://arashi-vanguard-prototipo.vercel.app (projeto Vercel `arashi-vanguard-prototipo`, deploy de produção a partir da branch `web-build`, que só guarda artefatos). Passos em `tools/README.md`.

## DEC-007 — Controles de toque
- Data: 2026-11-15 · Estado: **aprovada** (dono jogou a v7)
- Direcional único deslizante à esquerda; PULAR e ATACAR à direita; centro limpo; folga à direita; arte de HUD a finalizar. Detalhes em `docs/CONTROLES_E_CONVENCOES.md`. Substitui o esquema de botões separados (v4–v6).

## DEC-008 — Agachar e andar agachado
- Data: 2026-11-15 · Estado: **aprovada**. Mecânica e túnel de teste em `docs/CONTROLES_E_CONVENCOES.md`.

## DEC-009 — Botão de magia/poder e combos
- Data: 2026-11-15 · Estado: **pedido do dono, a especificar** (não é decisão de design ainda).
- O dono quer um botão de magia/poder para o Ren e combos. Fora do link atual. Especificar (T-008) antes de implementar.

## DEC-010 — Desvio declarado: Ren e Luke desenhados por código no protótipo
- Data: 2026-11-15 · Estado: **desvio; decisão do dono pendente**
- O protótipo v1–v7 desenha Ren, Luke, bonecos e cenário por código. O método (regra 3) **proíbe**, inclusive como placeholder. O dono aprovou a **dinâmica**, sabendo que a arte é provisória, mas ainda não decidiu se mantém até o lote-piloto ou troca já por imagens aprovadas. Cores do Luke estão erradas (bege com coleira; o oficial é branco com manchas castanhas e olhos azuis). **Substituir antes do Portão 1** (T-005).

## DEC-011 — Divisão de trabalho e modelos
- Data: 2026-11-15 · Estado: aprovada (padrão do dono)
- Conceito, história e especificação: Claude no modelo mais forte (Fable). Execução/código: Sonnet. Sprites e imagens: ChatGPT/Codex com PixelLab. Cutscenes, música e vídeos: Fenaky. Revisão: outro agente que não escreveu. Nenhuma IA troca o próprio modelo; o dono troca no seletor.
- Gastos (PixelLab, Fenaky, ElevenLabs, Vercel pago) **sempre** pedem estimativa e autorização antes.

## DEC-012 — Método geral é obrigatório e consultado antes de criar
- Data: 2026-11-15 · Estado: aprovada pelo dono
- Decisão: quem trabalhar no ARASHI VANGUARD **deve consultar e seguir** as instruções gerais de criação de jogos (`andrervarella/PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES`, `PROMPT_MESTRE.md` V4.3 e módulos) antes de criar ou alterar qualquer coisa. Registrado em `AGENTS.md`, `CLAUDE.md` e no prompt do Fable. O pedido do dono vale mesmo se o repositório geral mudar de versão: usar a versão mais recente e anotar qual.

## DEC-013 — Chefes com padrão fixo e itens que mudam a luta, sem combinação melhor
- Data: 2026-11-15 · Estado: **princípios aprovados pelo dono**; padrões por chefe e números = rascunho a validar (T-013)
- Decisão: cada chefe tem ciclo de ataque fixo e legível (estilo Mega Man), dificuldade moderada, identidade mecânica própria. Os itens/poderes escolhidos mudam a facilidade de cada chefe, e **nenhuma combinação é a melhor**: a escolha expressa o estilo de jogo. Detalhes e regras de balanceamento em `docs/10_CHEFES_E_BALANCEAMENTO.md`.
- Relação com regras anteriores: complementa "três itens por chefe, escolha única" (`docs/04`); a escolha nunca bloqueia travessia ou final.

## DEC-014 — Acervo no Google Drive + GitHub (método V4.4)
- Data: 2026-11-15 · Estado: **aprovada pelo dono** (regra do método V4.4, `modulos/ACERVO_DRIVE_GITHUB.md`)
- Decisão: arte original, arquivos grandes, sprites de trabalho, áudio, vídeo e ZIPs vão para `GAMES_IA/ARASHI VANGUARD/` no Drive (pastas 00–05). GitHub guarda código, projeto Godot, docs, manifestos e **assets finais de runtime**. Link do Drive não entra no repositório público. Detalhes: `docs/ACERVO_DRIVE.md`.
