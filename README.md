# ARASHI VANGUARD

**Jogo 2D de ação e exploração (pré-produção)** — história original de Ren Arashi, um trabalhador da forja que aprendeu a lutar por disciplina e sobrevivência, e Luke, o cão que salvou durante a tragédia que o lançou contra as Sete Famílias.

> Este repositório reúne o **contexto autoral do projeto** para colaboração entre proprietário, Claude e Codex. Não é uma versão jogável e não contém ainda o atlas definitivo de sprites.

## Ponto de entrada

- [AGENTS.md](AGENTS.md): regras gerais obrigatórias para agentes.
- [CLAUDE.md](CLAUDE.md): instruções específicas para Claude.
- [Visão geral](docs/01_VISAO_E_ESCOPO.md)
- [História e universo](docs/02_HISTORIA_E_UNIVERSO.md)
- [Elenco e chefes](docs/03_ELENCO_E_CHEFES.md)
- [Jogabilidade e progressão](docs/04_JOGABILIDADE_E_PROGRESSAO.md)
- [Direção de arte e sprites](docs/05_DIRECAO_DE_ARTE_E_PIPELINE.md)
- [Roteiro técnico de produção](docs/06_ROTEIRO_DE_PRODUCAO.md)
- [Decisões e pendências](docs/07_DECISOES_E_PENDENCIAS.md)
- [Referências visuais](assets/README.md)

## Identidade do jogo

- Metroidvania 2D curto com combate expressivo, espada, esquivas, combos e habilidades.
- Sete chefes associados a sete pecados capitais, além de um chefe final que reúne os sete.
- Cada chefe vencido concede **1 poder permanente + escolha irreversível de 1 de 3 itens + cicatriz**.
- Transformação física de Ren com cabelo muito longo e alteração de cor.
- Luke acompanha, ajuda a explorar e acrescenta humanidade e humor.
- Referências de linguagem visual: anime adulto de fantasia oriental, personagens expressivos, cenas escuras **com cor**; personagens e arte do jogo precisam ser originais.

## Importante: estado das imagens

As referências individuais recentemente preferidas pelo proprietário são **Kairen (Avareza), Xui (Gula), Baku (Ira) e Wu (Preguiça)**. Pranchas coletivas antigas podem exibir outros rostos/nomes e são apenas conceitos. Leia [o registro de decisões](docs/07_DECISOES_E_PENDENCIAS.md). As artes individuais ainda serão adicionadas ao GitHub separadamente e não devem ser presumidas presentes.

**Atenção à privacidade:** este repositório é público. Fotografias pessoais do proprietário e fotos reais de Luke usadas como referência de aparência não devem ser publicadas aqui sem revisão e aprovação.

## Primeira meta técnica

Validar um trecho jogável **10–15 minutos** no Godot, com um herói animado, Luke, dois inimigos, um chefe, uma habilidade, escolha permanente entre três itens, uma passagem secreta e salvamento. Somente então ampliar o elenco.

## Coordenação de agentes

Claude/Codex: leia \`AGENTS.md\` e \`CLAUDE.md\` antes de implementar. Não chamar ilustrações de sprites concluídos. Validar acesso ao PixelLab (ou similar) e custo antes de consumir créditos. Criar alterações pequenas, verificáveis e preservar os designs aprovados.
