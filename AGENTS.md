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