# AGENTS.md — ARASHI VANGUARD

> Documento de orientação para Claude, Codex e qualquer agente de criação. Leia antes de alterar código ou artes.

## Missão
Construir um jogo **single-player de ação e exploração lateral 2D** em Godot, com combate expressivo, progressão ao estilo Metroidvania, narrativa humana, sete chefes temáticos e um chefe final. O título é **ARASHI VANGUARD** (não "Avantgarde" ou "Harashi"). **Nunca recriar do zero o design de um personagem aprovado se já existir referência canônica.**

## Fonte de verdade e ordem de prioridade
1. Instruções recentes aprovadas pelo proprietário e documentação deste repositório.
2. Artes individuais marcadas \`APROVADO_REFERENCIA\` em \`assets/referencias-aprovadas/\`, quando disponibilizadas.
3. \`docs/02_HISTORIA_E_UNIVERSO.md\`, \`docs/03_ELENCO_E_CHEFES.md\`, \`docs/04_JOGABILIDADE_E_PROGRESSAO.md\`.
4. Quadros de conceito e explorações em \`assets/conceitos-em-avaliacao/\` (NÃO são canon).

Se surgir conflito, documentar antes de decidir. **Texto embutido em imagens geradas pode ter erros e não substitui os documentos escritos.**

## Regras obrigatórias
- Jogo final com personagens, fundos e efeitos em **2D**, mesmo que sejam usados modelos 3D como apoio durante a produção.
- Estética anime adulto, expressividade de jogo de luta, paletas individuais, cenários japoneses sombrios com cor e contraste. Referências de clima: Vampire Hunter, KOF, Castlevania, Mega Man. **Não copiar sprites, artes, trilhas, nomes protegidos nem personagens dessas franquias.**
- Ren Arashi: ex-ferreiro/trabalhador sem privilégios; guerreiro construído por prática, estudo e resiliência; aparência física inspirada nas fotos do proprietário, mas essas fotos NÃO devem ser adicionadas a um repositório público automaticamente.
- Luke: cão pequeno branco com manchas castanhas e olhos azuis, companheiro e alívio cômico. As fotos originais são referência privada, não devem ser publicadas automaticamente.
- Ren não usa armadura samurai pesada no visual padrão. Armaduras oni/samurai pesadas são possíveis **para chefes**.
- Transformação de Ren: **cabelo muito mais longo e de outra cor**, evolução corporal e marcas luminosas, mantendo identidade facial. Não substituir por armadura medieval.
- Cada chefe derrota: poder permanente automático + escolha **irreversível** de 1 entre 3 equipamentos exclusivos + nova cicatriz/marca. As opções não escolhidas não podem ser obtidas naquela campanha; nenhum item optativo pode bloquear conclusão.
- Cada chefe precisa de **silhueta, rosto, arma, paleta e comportamento próprios**. Não colocar halo/círculo atrás de todos.
- Nenhum arquivo é sprite pronto apenas por possuir quadros ilustrados. Precisam de recorte, uniformidade anatômica, pivôs, hitboxes, transições e testes.
- Trabalhar em fases pequenas e testáveis. Priorizar protótipo de 10–15 minutos com chefe e loot antes de criar o jogo inteiro.
- Não gastar créditos em PixelLab, geração de imagens/vídeos ou outros serviços sem antes conferir custo e obter autorização do proprietário.
- Não publicar builds ou modificar repositórios terceiros sem aprovação.

## Pipeline de arte
Arte aprovada -> turnaround frente/perfil/costas -> silhueta base -> sprites de animação com dimensões/pivô coerentes -> atlas PNG transparente -> cenas e AnimationPlayer/AnimatedSprite2D no Godot -> testes em jogo -> aprovação.

Para cada personagem manter \`character_id\`, referência canônica, altura em pixels, paleta, estados de animação, pivô de chão, lista de partes equipáveis e observações de colisão. Não afirmar fidelidade perfeita sem conferência visual.

## Organização sugerida
\`docs/\`: design e decisões. \`assets/referencias-aprovadas/\`: originais canônicos. \`assets/conceitos-em-avaliacao/\`: estudos. \`assets/sprites/\`, \`assets/tilesets/\`, \`assets/ui/\`, \`assets/audio/\`: assets produzidos. \`godot/\`: projeto e código.

## Antes de cada entrega
Fornecer o que mudou, quais referências foram usadas, capturas de gameplay e testes realizados, arquivos criados/alterados, itens ainda provisórios e riscos de inconsistência. Preserve o trabalho aprovado, evite renomeações arbitrárias e não declare pronto aquilo que é apenas estudo.

## Método de criação (adicionado em 15/11/2026)
**Obrigatório:** antes de criar ou alterar qualquer coisa neste jogo, **consulte e siga** as instruções gerais de criação de jogos do dono: https://github.com/andrervarella/PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES (`PROMPT_MESTRE.md` e `modulos/`). Se faltar acesso, avise o dono; não improvise (DEC-012).

Seguir o **Prompt Mestre Universal V4.3**: https://github.com/andrervarella/PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES (PROMPT_MESTRE.md e modulos/). Resumo que vale mesmo sem acesso ao repositório central:
1. **Ao chegar:** liste branches e PRs abertos; leia `docs/ESTADO_ATUAL.md` (obrigatório), depois `docs/DECISOES.md`, `docs/TAREFAS.md` e `docs/HANDOFF.md` se a tarefa tocar neles. Branch de trabalho: `dev`; `main` só recebe merge nos portões, com o "ok" do dono. Vale o Git, não as anotações.
2. **Tarefas:** sem tarefa aberta em `docs/TAREFAS.md`, não edite o jogo. FAZER -> REVISAR (outro agente) -> TESTAR (roda de verdade) -> FECHADA. Um commit por tarefa, começando pelo ID.
3. **Evidência:** rótulos EXECUTADO / EXECUTADO (EMULADO) / SÓ LIDO / NÃO VERIFICADO. Nunca declare pronto sem verificar arquivo ou tela.
4. **Sprites:** proibido desenhar personagem ou cenário por código, inclusive como placeholder (desvio atual declarado em DEC-010). Placeholder = imagem aprovada ou lote-piloto aprovado.
5. **Embalagem:** menu, introdução com a história, cutscenes curtas, telas de vitória/derrota e final, com gancho nos 10 s.
6. **Portões:** V (visual e história), 1 (core loop), 2 (vertical slice), 3 (concluído). Produção completa só depois de V e 1.
7. **Controles de toque e convenções de gênero:** `docs/CONTROLES_E_CONVENCOES.md` (aprovado). Siga o padrão dos jogos de plataforma/ação; fugir dele exige aviso prévio.
8. **Link jogável de teste:** https://arashi-vanguard-prototipo.vercel.app; publicação e ferramentas em `tools/README.md`.
9. **Divisão:** conceito/especificação no Fable, execução no Sonnet, sprites no Codex/PixelLab, cutscenes/música no Fenaky. Gastos sempre com estimativa e autorização do dono. Ao parar: commit, push e handoff.
10. **Chefes e balanceamento:** cada chefe tem ciclo de ataque fixo e legível (estilo Mega Man), dificuldade moderada; os itens escolhidos mudam a dificuldade de cada luta e **não existe combinação melhor** (a escolha expressa o estilo do jogador). Ver `docs/10_CHEFES_E_BALANCEAMENTO.md` e DEC-013.

## Acervo (DEC-014/DEC-015)
GitHub = só o que o jogo usa para rodar + código e docs. Drive (`GAMES_IA/ARASHI VANGUARD/`, pastas 00–05) = originais, rascunhos, descartes, vídeo, música e ZIP. Não duplicar tudo; manifesto é a ponte. Ver `docs/ACERVO_DRIVE.md`. Nunca publicar link do Drive.
