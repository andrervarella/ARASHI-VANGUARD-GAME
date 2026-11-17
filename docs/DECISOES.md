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

## DEC-015 — Divisão padrão Drive × GitHub (refinamento da DEC-014)
- Data: 2026-11-15 22:50 · Estado: **aprovada pelo dono** ("vamos deixar padronizado assim")
- **GitHub:** só o que o jogo usa para rodar (sprites finais, cenários, UI, sons/músicas finais otimizados), código, projeto Godot, documentação, decisões, tarefas e manifestos.
- **Drive:** originais e referências aprovadas, rascunhos, versões descartadas, sprites de trabalho, vídeos, músicas-fonte e ZIPs.
- **Não duplicar tudo nos dois.** Exceção: o asset final de runtime fica no GitHub (o jogo não depende do Drive) e sua fonte/original fica no Drive.
- **Manifesto** (`docs/MANIFESTO_ASSETS.md`) é a ponte: ID, versão, status, local no Drive, local no GitHub, hash.
- **Limite do conector Drive (~3,1 MB por envio):** não enviar em partes soltas; enviar cópia **sem perda** (PNG recomprimido ou WebP lossless, pixels conferidos por script) e registrar os dois hashes; ZIP cujo conteúdo já está no acervo não é reenviado.
- **Repositório público:** arte não lançada no GitHub fica visível a qualquer pessoa. Tornar o repo privado é decisão do dono (pendente). Os PNG de referência que já estão em `assets/` **não serão removidos** sem decisão do dono.
- Link do Drive, URLs assinadas e credenciais nunca entram no repositório.

## DEC-016 — História consolidada, abertura e regra de cenas
- Data: 2026-11-16 15:06 · Estado: **aprovada pelo dono** ("Eu aprovo tudo")
- Trama, portão físico/tranca do selo, frase do jogo, ordem das fases (Baku fixo primeiro; seis em ordem livre a partir da Vila), Tetsu, revelação do Shin-Oni, finais, poderes que mudam a roupa, Mei Shian verde, Shin-Oni como nome e "Senhor dos Sete Pecados" como título: `docs/13_HISTORIA_CONSOLIDADA.md`.
- Higgsfield: no máximo 1 cutscene de uma tomada (8–10 s) por fase + 1 no final; resto em cena no jogo (estilo RPG). Áudio PT ou EN; legenda sempre no jogo. Sem voz do dono; sem dublagem por enquanto.
- Imagens enviadas em 16/11 são as oficiais atuais e prevalecem sobre as anteriores em conflito (ajusta a observação 1 de `docs/12`).

## DEC-017 — Proporção adulta para todos os personagens (sprites)
- Data: 2026-11-16 15:29 · Estado: **aprovada pelo dono** (Ren V2 aprovado como base)
- Todos os personagens jogáveis e chefes usam a **proporção da ficha oficial** (adulto: ~7,5–8 cabeças, pernas longas), nunca proporção de boneco/chibi. Exceções naturais da própria ficha: Luke (cão pequeno), Xui (obeso), Shin-Oni e Baku (gigantes).
- Pipeline padrão do sprite: recorte de corpo inteiro da ficha → `image_to_pixelart` fiel (faithful, força ~200, altura ~150 px para o Ren) → `remove_background` → `create_character` v3 com referência de frente (gira para os lados mantendo a proporção) → limpeza de pixels → animações. O modo `pro` a partir de conceito **não** é usado para personagem principal: ele redesenha o corpo e encurtou o Ren (V1 reprovada).
- Ren base V2: personagem PixelLab `036acc6d` (72×156 por quadro). V1 `5e988eef` reprovada (proporção de boneco).

## DEC-018 — Músicas no link Web via build do Vercel (16/11/2026)
- O ambiente da IA não baixa arquivos do PixelLab (rede bloqueada). As músicas ficam na biblioteca PixelLab do dono e o **build do Vercel** (`baixar_musica.sh` na branch `web-build`) as baixa para `/music/` usando a variável **secreta** `MUSIC_URLS` do projeto (os links não vão para o repositório público). O jogo carrega `music/<nome>.mp3` sob demanda (`Game.music`). Para levar as músicas ao repositório/Drive, o dono baixa no site do PixelLab e envia.

## DEC-019 — Mundo das Sete Terras e linguagem épica (16/11/2026)
- Pedido do dono após jogar a v0.2: a trama vale para o **mundo** (Sete Terras, sete selos), Ren mora numa **aldeia**; falas em linguagem épica, sem gíria. Resumo em `docs/13` (cabeçalho). Ren abre o Portão **jogando** (fim do tutorial), não só em cena.
- Também pedidos e feitos: câmera mais próxima (zoom 1,0), **botão DEFESA** com aparo no instante exato, arte de objetos/coletáveis/ícones no PixelLab, fogo do Baku refeito com efeitos do PixelLab (VFX workbench).

## DEC-020 — Prólogo reescrito e poderes como aura + elemento (16/11/2026)
- Pedido do dono após jogar a v0.4. História de abertura: trevas, uma maldição cai sobre a terra; nascem demônios que encarnam os **sete pecados** do povo; os povos se unem e os prendem com **selos em sete regiões**; os governantes (a seita das **Sete Casas**) passam a usar a energia dos selos para enriquecer, sacrificando os humildes. Parecia lenda; não era.
- Na cidade de Ren, a ganância fecha os portões para sacrificar a cidade inteira (população marcada). Ren, cujo pai fez a fundação da muralha e do portão, abre os portões por senso de justiça. A Ira (Baku) vem cobrar o sacrifício; Ren luta e é ferido (luta "impossível" jogável). A luz do **pingente do Luke** repele a Ira naquela noite. Depois o ancião (Tetsu) explica e a jornada começa.
- Luke entra como **cão de rua sem lenço, com pingente** (que se conecta ao final). Ele late e avisa Ren; um soldado tenta sacrificar o cão; Ren o salva vencendo o soldado e, em cena comovente, dá o próprio lenço ao amigo.
- Legendas avançam só por toque. Esquiva = dois toques em DEFESA (rolamento). Poderes **não mudam a cor da roupa**: aura discreta + elemento (Fúria = mão em chamas; Jade = contas de jade orbitando).

## DEC-021 — Chefe final com novo visual (16/11/2026, direção do dono)
- O demônio ruivo de chifres da ficha "BAKU — IRA (Wrathcleaver)" **não é o Baku**: passa a ser a base visual do **chefe final (Shin-Oni, Senhor dos Sete Pecados)**, acrescido de **máscara/capacete samurai** e aparência demoníaca. O Baku jogável continua o "General da Fúria" (samurai de máscara oni).
- O pôster com todos os chefes deve ser editado: a figura da frente (parecida demais com o Baku) vira o novo chefe final. Arte final de personagem: precisa de aprovação do dono e do custo antes de gerar (T-019).
