# ARASHI VANGUARD — KIT DE PRODUÇÃO v1

Este pacote inclui **originais intactos** e **recortes padronizados** para Claude, Codex e ferramentas de pixels/sprites.

**IMPORTANTE:** recorte de referência NÃO é sprite. Muitos recortes mantêm o cenário/textos ao fundo; as bordas externas de padding podem ter transparência, mas isso não remove o fundo dentro da imagem. Nenhum item recebeu máscara semiautomática destrutiva.

## Como começar
1. Leia `AGENTS.md` e `CLAUDE.md` no GitHub e o `MANIFEST.json` deste ZIP.
2. Extraia estes arquivos dentro do repositório preservando as pastas `assets/`.
3. Imagens em `referencias-aprovadas/` são originais de design e **NÃO devem ser modificadas**.
4. Imagens em `recortes-referencia/` servem para close, cores e materiais; devem ser refinadas para remoção de fundo e turnarounds.
5. Imagens em `conceitos-em-avaliacao/` servem como contexto visual; as diferenças de versões não substituem os originais aprovados.
6. Primeiro gerar 1 spritesheet piloto Ren (repouso, correr, salto, golpe), testar no Godot, comparar com modelo aprovado.
7. Não gastar créditos sem confirmação de custo.

## Sobre o elenco
Kairen, Xui, Baku, Wu têm artes originais recentes aprovadas. Seiran e chefe final possuem fichas de conceito aprovadas neste material. A personagem Mei Shian e Shuyin aparecem nas pranchas, mas ainda precisam de desenho individual consistente.

## Privacidade
O repositório GitHub é público. Nenhuma foto pessoal real nem as fotos originais do cão estão neste pacote. Ilustrações derivadas podem ser compartilhadas conforme a aprovação para o jogo.

## Resolução e padrão
Os recortes possuem quadros 768x960 (corpo), 512x512 (detalhes), 384x384 (itens) ou tamanhos próximos. São molduras de referência visual; a resolução real dos sprites deve ser definida após teste de câmera e gameplay.

## Dados verificáveis
Use os tamanhos, caminhos, coordenadas do corte e hashes SHA-256 em `MANIFEST.json` para conferir se não houve perda.
