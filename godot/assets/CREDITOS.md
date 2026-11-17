# Créditos e origem dos assets de runtime (fases 1 e 2)

| Pasta | Origem | Licença/observação |
|---|---|---|
| `sprites/ren` | PixelLab, personagem `036acc6d` (Ren V2, DEC-017) a partir da ficha oficial | conta do dono |
| `sprites/baku`, `sprites/xui`, `sprites/luke` | PixelLab `777192ba`, `68e751b0`, `ca9f89d4` (a partir das fichas oficiais) | conta do dono |
| `sprites/guarda`, `oni`, `servo`, `espirito` | PixelLab `ed0bd480`, `e93af51d`, `752da47b`, `5d676ab0` (personagens secundários inventados) | conta do dono |
| `sprites/tetsu` | PixelLab `d2ca4bb1` (mestre Tetsu, inventado a partir de docs/13) | conta do dono |
| `bg/*.png` | PixelLab `create_image_pro` com recortes da prancha de ambientes oficial (`assets/referencias-pipeline/cenarios`) | conta do dono |
| `story/*.jpg`, `portraits/*.jpg` (exceto tetsu), `ui/title.jpg` | recortes das artes oficiais ilustradas de 16/11 (sem fotos reais) | artes do dono |
| `portraits/tetsu.jpg` | ampliação do sprite do Tetsu | conta do dono |
| `sfx/*.ogg` | **Oculus Audio Pack 1 — Meta, CC BY 4.0** (`sfx/LICENSE_Oculus_Audio_Pack.txt`) | crédito obrigatório (na tela de créditos) |
| `fonts/*.ttf` | DejaVu Serif/Sans Bold (`fonts/LICENSE_DejaVu.txt`) | livre |
| músicas | PixelLab `create_music` (biblioteca do dono); no link Web são baixadas no deploy para `/music/` | conta do dono |

Quadros extraídos com `tools/montar_anim.py` (prévias do workbench do PixelLab, fundo removido por cor).

## Acréscimos v0.3 (16/11/2026)
| Pasta | Origem |
|---|---|
| `story/*.png` (mapa, aldeia, ritual, lua_vermelha, portao_trancado, fuga, refugio) e `bg/refugio.png` | PixelLab `create_image_pro` 688×384 (estilo dos cenários do jogo) |
| `icons/*.png` (coletáveis, itens, poderes) e `props/*.png` (caixa, pedra, plataformas, mesa, telhado, parede rachada, torii, portão, chãos) | PixelLab `create_image_pixen` |
| `fx/*.png` (onda de brasa, brasa do oni, acerto, aparo, vapor, onda de choque, defesa) | PixelLab VFX workbench (salvos em "My effects" do dono) |
| `sprites/ren/guard_*` | PixelLab, animação do Ren `036acc6d` |

## Acréscimos v0.4 (16/11/2026)
- `ui/btn_*.png`, `ui/placa.png`: PixelLab `create_image_pixen`. `bg/refugio.png` refeito sem pessoas (PixelLab `create_image_pro`). `sprites/ren/{thrust,rising,finisher}_*`: animações do Ren `036acc6d`.

## Acréscimos v0.5 (16/11/2026)
| Arquivo | Origem |
|---|---|
| `props/portao_aberto.png`, `props/toldo.png`, `props/aldeao_1.png`, `props/aldeao_2.png` | PixelLab `create_image_pixen` |
| `sprites/luke_rua/*` (Luke de rua, sem lenço, com pingente) | PixelLab, estado do personagem Luke |
| `sprites/ren/run_*` (10 quadros), `roll_*`, `fall_*` | PixelLab, animações do personagem Ren |
| `sprites/ren_carmesim/*` (Forma Carmesim) | PixelLab, estado "Forma Carmesim" do personagem Ren (`36f2ce1b`), a partir da ficha AV-FIC-002 |
| `icons/carmesim.png` | PixelLab `create_image_pixen` |

## Acréscimos v0.7 (16/11/2026)
| Arquivo | Origem |
|---|---|
| `props/altar.png`, `props/nevoa.png`, `props/selo_carmesim.png` | PixelLab `create_image_pixen` |
| `sprites/ren/tired_*` (Ren ofegante) | PixelLab, animação do Ren `036acc6d` |
| `sfx/sino.ogg`, `sfx/esquiva.ogg` | Sintetizados por código (Python/numpy), originais do projeto |

## Acréscimos v0.8 (16/11/2026)
| Arquivo | Origem |
|---|---|
| `props/caixa.png`, `props/pedra.png`, `props/altar.png` (lanterna de pedra) | PixelLab `create_image_pixen` (substituem as versões isométricas) |

## Acréscimos v0.9 (16/11/2026)
| Arquivo | Origem |
|---|---|
| `props/chao_*.png` | Recortes do piso dos próprios fundos (PixelLab) de cada fase, espelhados |
| `props/jaula.png`, `props/aldeao_3..8.png`, `props/refugiado_1..4.png` | PixelLab `create_image_pixen` |
| `sprites/ren/walk_*`, `sprites/ren_carmesim/walk_*` | PixelLab, animações dos personagens Ren `036acc6d` e `36f2ce1b` |
| `portraits/luke_rua.jpg` | Recorte da expressão "Neutro" da ficha oficial do Luke (sem lenço) |
