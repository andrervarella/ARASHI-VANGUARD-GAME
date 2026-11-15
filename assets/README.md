# Assets e referências visuais

**Situação atual:** documentos de design estão no repositório; as imagens serão adicionadas separadamente, usando o pacote visual correspondente ou upload manual. NÃO presumir que esta pasta já contém arquivos de arte.

## Estrutura prevista
- \`referencias-aprovadas/chefes/\`: Kairen, Xui, Baku, Wu (arte individual preferida/aprovada).
- \`referencias-aprovadas/protagonista/\`: Ren (após selecionar a versão canônica).
- \`referencias-aprovadas/mascote/\`: Luke (ilustração derivada de fotos privadas).
- \`conceitos-em-avaliacao/\`: painéis gerais, esboços e antigas versões.
- \`turnarounds/\`: frente/perfil/costas/3-4.
- \`sprites/\`: quadros e atlases jogáveis.
- \`props/\`, \`tilesets/\`, \`vfx/\`, \`ui/\`, \`audio/\`, \`manifests/\`.

## Instruções de importação
1. Subir imagens aprovadas com os nomes indicados no manifesto do pacote ZIP.
2. Não substituir originais ao criar recortes. Os recortes têm status *trabalho intermediário*.
3. Evitar arquivos das imagens reais do proprietário ou de Luke num GitHub público; elas podem ficar em canal privado de referência.
4. Atualizar manifestos com SHA-256 de cada arquivo e \`source_of_truth\`.
5. Fichas com nomes e recompensas gerados dentro da imagem não substituem \`docs/\`.
6. Exigir PNG transparente final e sprite sheet consistente antes da importação no Godot.