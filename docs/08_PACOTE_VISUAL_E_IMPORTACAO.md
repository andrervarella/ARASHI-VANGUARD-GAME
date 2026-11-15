# Pacote visual aprovado — handoff Claude / Codex

**Data:** 15/11/2026 | **Versão:** v1

## Situação

O proprietário confirmou nesta conversa que as artes atuais de personagens, Luke, chefes, itens e pranchas de ambiente/sistema estão **aprovadas como base conceitual**. A versão exportada é o arquivo:

**ARASHI_VANGUARD_KIT_ASSETS_APROVADOS_v1.zip**

Arquivo entregue diretamente na conversa ChatGPT. **Ainda não está armazenado no GitHub**; para integrá-lo, é necessário extrair/upload do ZIP via Claude/Codex ou via interface GitHub. Este arquivo Markdown não contém os PNGs.

## Conteúdo do kit (físico)

- **19 PNGs originais intactos**: referências prioritárias de Kairen, Xui, Baku, Wu, Seiran, chefe final, Ren, Luke e pranchas do universo.
- **40 PNGs de recorte padronizado**: corpo/rosto/recompensa ou detalhe de chefes; poses, turnaround e acessórios de Luke; Ren e transformação; 5 itens da prancha; HUD, mapa/ambiente, combate e árvore de evolução.
- \`MANIFEST.json\`: SHA-256, origem, caminho, dimensões e caixas de recorte.
- \`LEIA_PRIMEIRO.md\`: instruções de importação e limites dos recortes.

Há ainda um ZIP **ARASHI_VANGUARD_PREVIA_LEVE_v1.zip**, com 59 imagens WebP compactadas para consulta no celular; a versão leve **não substitui** os originais para produção.

## Estrutura esperada após importação
\`\`\`
assets/
  referencias-aprovadas/
    chefes/
    protagonistas/
    luke/
    direcao/
  conceitos-em-avaliacao/
    ren/
    luke/
    chefes/
    mundos/
    pranchas/
  recortes-referencia/
    ren/
    luke/
    chefes/{Kairen,Xui,Baku,Wu,Seiran,BossFinal}/
    itens/
    sistemas/
\`\`\`

## Padrões de entrega

Recortes de referência: corpo em canvas 768 × 960, close em 512 × 512, item em 384 × 384, variando conforme categoria. **Essas dimensões são de consulta visual, NÃO resolução final de sprites.**

- O background de muitos recortes ainda faz parte da imagem original. Margens podem ter alpha, mas não equivale a personagem isolado.
- Não existe modelo separado em camadas, rig, turn-around confirmado ou spritesheet jogável.
- Ao recortar com PixelLab, ferramentas locais ou outro modelo, comparar cada sprite com referência integral. Verificar face, cabelo/barba, mãos, armas, ornamentos, legibilidade 2D e patas/olhos de Luke.
- Crie arquivo de teste de idle, corrida, salto e golpe de Ren; **não processe todos os 8 chefes de uma só vez**.
- Não alterar os originais em \`referencias-aprovadas/\`. Escrever trabalho intermediário em novo diretório.
- Aprovação de arte = aprovação da **linguagem visual**; textos gerados dentro das imagens podem conter erros, e a nomenclatura final de itens/poderes deve seguir documentação escrita.
- **Não incluir fotos pessoais reais ou fotos originais de Luke neste repositório público** sem autorização explícita adicional.

## Instrução para Claude

1. Leia \`AGENTS.md\`, \`CLAUDE.md\` e todos os docs.
2. Receba o ZIP do proprietário; extraia e verifique hashes a partir do MANIFEST.json.
3. Faça uma auditoria de assets presentes e faltantes em formato de tabela.
4. Verifique integração e custos do PixelLab. Solicite autorização para uso de créditos.
5. Defina resolução de sprite após escolher câmera e escala para a vertical slice.
6. Inicie com Ren + Luke, preserve quatro designs antigos prioritários (Kairen, Xui, Wu, Baku). Seiran e boss final têm ficha conceitual; Mei Shian e Shuyin precisam turnarounds individuais.
7. Construa código em Godot por pequenas entregas testáveis; registre PR/commit, gameplay real, logs e capturas.
8. Nunca afirmar que os PNG de recorte já são sprites, assets transparentes ou animações funcionais.

## Por que não subir somente o ZIP?

GitHub, arquivos de jogo e ferramentas de sprite trabalham melhor com **PNGs individuais versionados**; um ZIP versionado seria opaco para diff/revisão. Importe a hierarquia \`assets/\` descompactada. Atenção aos custos de armazenamento e tamanho do repositório ao adicionar muitos arquivos binários em versões futuras.