# BÍBLIA VISUAL — ARASHI VANGUARD (v1, 16/11/2026, DEC-023)

> Regra única para todo asset novo. Se um asset quebra uma regra daqui, ele volta para refazer. Motivo: o dono apontou cenário desconectado do piso, objetos desproporcionais e "flutuando".

## 1. Vista e perspectiva
- **Tudo em vista lateral pura** (side-scroller): personagens de perfil; objetos de frente, **sem face de cima à mostra** (nada isométrico, nada em 3/4).
- Prompt padrão para objetos no PixelLab: "2D side-scroller game sprite seen exactly from the side/front, no top face visible".

## 2. Escala (unidades do mundo)
| Coisa | Altura no mundo |
|---|---|
| Ren | ~150 px (quadro de 216–220 px) |
| Aldeões adultos / criança | ~135 px / ~100 px |
| Luke | ~60 px |
| Caixa empilhada | 110–140 px |
| Lanterna de descanso | ~170 px |
| Chefes | 1,3× a 2× o Ren |
| Casa de dois andares | ~560 px (passa do topo da tela, como na vida real) |
| Barraca de feira / forja de rua | ~235–265 px (mais alta que uma pessoa) |
| Torii | ~360 px |
| Barris empilhados / carroça / cerca | ~150 / ~135 / ~100 px |
| Mesa de banquete | ~78 px (altura de mesa real) |
| Portão da cidade | ~600 px |

**Regra de ouro (dono, 17/11):** tudo na proporção da vida real em relação ao Ren (1,75 m ≈ 150 px). Imagem de história também: o Luke é um cachorro pequeno, na altura do joelho do Ren.
Objetos nunca são esticados: a arte é recortada sem sobra transparente e desenhada mantendo a proporção.

## 3. Chão e fundo (o mesmo ambiente)
- O **chão jogável é recortado do próprio fundo pintado** de cada fase (faixa de piso do fundo, espelhada para emendar). Fase nova = fundo com piso visível na parte de baixo.
- O fundo é posicionado para que o piso pintado fique **na mesma linha do chão jogável** (`bg_chao` em `levels.gd`).
- Névoa leve no pé do cenário e **sombra de contato** sob todo personagem, bloco e objeto.

## 4. Paleta e luz
- Cada terra tem uma paleta (Vale: vermelho-lua e roxo; Palácio: verde-jade e ouro; Cidade: brasa e laranja; Refúgio: azul-noite e terra).
- Luz principal: lua de cima à esquerda; fogo dá contorno quente. Objetos novos pedem "moody night lighting".

## 5. Contorno e detalhe
- Pixel art com contorno seletivo (selective outline); personagens com o mesmo nível de detalhe dos sprites do Ren.
- Retratos de diálogo são pinturas oficiais; o Luke **sem lenço** até a cena do lenço (retrato tirado das expressões da ficha oficial, olhos azuis).

## 6. Checklist de cada lote
1. Vista lateral? 2. Escala da tabela? 3. Sem sobra transparente? 4. Sombra/apoio no chão? 5. Paleta da terra? 6. Combina com a história naquele momento (ex.: lenço do Luke)?
