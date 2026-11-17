# Auditoria do kit visual v1 (15/11/2026)

Gerado por Claude ao importar `ARASHI_VANGUARD_KIT_ASSETS_APROVADOS_v1.zip`. Nada aqui é sprite pronto.

## Verificação do pacote
- 59 arquivos no manifesto = 59 no ZIP; nenhum faltando ou extra.
- SHA-256, tamanho em bytes, dimensões e modo de cor conferem com `assets/kit-v1/MANIFEST.json` (verificado por script).
- Originais copiados sem alteração, preservando os caminhos. O manifesto e o LEIA_PRIMEIRO do kit estão em `assets/kit-v1/`.
- Todos os recortes são RGBA, mas a transparência está só nas margens de enquadramento: o fundo dentro da imagem continua incluído.
- Fotos pessoais do proprietário e de Luke NÃO foram adicionadas (repositório público).

## Decisões do proprietário em 15/11/2026
- **Ren oficial:** prancha "O Guerreiro Errante" (manto preto, katana, máscara oni), adicionada em `assets/referencias-aprovadas/protagonistas/`. Cabelo mais comprido que nas fotos de referência; rosto inspirado no proprietário.
- **Luke oficial:** ficha de pré-produção (`Luke_ficha_conceitual_original.png`).
- O design "Ren árabe" (pôster e os 3 recortes `recortes-referencia/ren/`) fica como **superado**: não usar para o sprite do Ren.

## Problemas encontrados
1. Os recortes do Ren vêm do design superado; é preciso novos recortes/referências do Ren oficial.
2. Muitos recortes carregam logo, legendas, molduras ou cartões de recompensa com texto embutido. Texto gerado por imagem pode estar errado.
3. `Wu_rosto_recorte.png` não mostra o rosto; `Baku_rosto_recorte.png` está cortado no topo.
4. Os 5 itens têm baixa resolução (ampliação ~4-5x) e legenda cortada.
5. Quatro pares de arquivos são idênticos entre `conceitos-em-avaliacao/` e `referencias-aprovadas/` (ver tabela). O Git guarda um blob só, mas a pasta de conceitos não deve ser tomada como versão alternativa.
6. A prancha usada como referência de layout mostra "ARASH VANGUARD" no logo e nomes antigos de guardiões.
7. Faltam fichas individuais de Mei Shian, Shuyin e Seiran (como já registrado em `07_DECISOES_E_PENDENCIAS.md`).

## PixelLab
- Conector "Pixellab2" aparece como **precisa reconectar** (não conectado) em 15/11/2026.
- Nenhuma chamada foi feita; custo e limites **não verificados**. Nenhum crédito gasto.

## Tabela de arquivos
Legenda de verificação: "(miniatura)" = conferido só em miniatura; "(verificado)" = aberto em tamanho cheio.

| Arquivo | Tipo | Dimensões | Status | Observações |
|---|---|---|---|---|
| `conceitos-em-avaliacao/chefes/senhor_sete_pecados_conceito_A.png` | original | 941x1672 | CONCEITO (não canônico) | Idêntico (SHA-256) a assets/referencias-aprovadas/chefes/Senhor_Sete_Pecados_conceito_individual.png. |
| `conceitos-em-avaliacao/chefes/senhor_sete_pecados_conceito_B.png` | original | 1122x1402 | CONCEITO (não canônico) |  |
| `conceitos-em-avaliacao/luke/luke_ficha_preproducao.png` | original | 1122x1402 | CONCEITO (não canônico) | Idêntico (SHA-256) a assets/referencias-aprovadas/luke/Luke_ficha_conceitual_original.png. |
| `conceitos-em-avaliacao/mundos/mundo_fortaleza.png` | original | 1086x1448 | CONCEITO (não canônico) |  |
| `conceitos-em-avaliacao/mundos/mundo_lua_carmesim.png` | original | 1086x1448 | CONCEITO (não canônico) |  |
| `conceitos-em-avaliacao/pranchas/prancha_combate_e_assets.png` | original | 1536x1024 | CONCEITO (não canônico) | Idêntico (SHA-256) a assets/referencias-aprovadas/direcao/prancha_layout_historia_itens.png. |
| `conceitos-em-avaliacao/pranchas/prancha_direcao_visual_geral.png` | original | 1122x1402 | CONCEITO (não canônico) |  |
| `conceitos-em-avaliacao/ren/ren_com_luke_capa_conceito.png` | original | 1086x1448 | CONCEITO (não canônico) | Idêntico (SHA-256) a assets/referencias-aprovadas/protagonistas/Ren_Luke_poster_original.png. |
| `conceitos-em-avaliacao/ren/ren_transformacao_conceito.png` | original | 1086x1448 | CONCEITO (não canônico) |  |
| `recortes-referencia/chefes/Baku/Baku_corpo_recorte.png` | recorte | 768x960 | APROVADO_REF | Logo do jogo no canto; bandeira ao fundo (miniatura). Ampliação sobre a fonte: ~0.8x. |
| `recortes-referencia/chefes/Baku/Baku_reliquia_ou_detalhe_recorte.png` | recorte | 512x512 | VERIFICAR_RECORTES | Cartão "RECOMPENSA — Brasão da Fúria" com texto embutido (miniatura). Ampliação sobre a fonte: ~1.3x. |
| `recortes-referencia/chefes/Baku/Baku_rosto_recorte.png` | recorte | 512x512 | APROVADO_REF | Máscara oni visível, mas cortada no topo (ponta do chifre); inclui peito e mão (verificado em tamanho cheio). Ampliação sobre a fonte: ~1.0x. |
| `recortes-referencia/chefes/BossFinal/BossFinal_corpo_recorte.png` | recorte | 768x960 | APROVADO_REF | Conferir em tamanho cheio. Ampliação sobre a fonte: ~0.8x. |
| `recortes-referencia/chefes/BossFinal/BossFinal_reliquia_ou_detalhe_recorte.png` | recorte | 512x512 | VERIFICAR_RECORTES | Detalhe de armadura/emblema, sem cartão. Conferir em tamanho cheio. Ampliação sobre a fonte: ~1.5x. |
| `recortes-referencia/chefes/BossFinal/BossFinal_rosto_recorte.png` | recorte | 512x512 | APROVADO_REF | Conferir em tamanho cheio. Ampliação sobre a fonte: ~1.2x. |
| `recortes-referencia/chefes/Kairen/Kairen_corpo_recorte.png` | recorte | 768x960 | APROVADO_REF | Logo do jogo no canto e fragmento de legenda no rodapé (miniatura). Ampliação sobre a fonte: ~0.8x. |
| `recortes-referencia/chefes/Kairen/Kairen_reliquia_ou_detalhe_recorte.png` | recorte | 512x512 | VERIFICAR_RECORTES | Cartão "RECOMPENSA — Anel da Coleta Infinita" com texto embutido (verificado). Ampliação sobre a fonte: ~1.4x. |
| `recortes-referencia/chefes/Kairen/Kairen_rosto_recorte.png` | recorte | 512x512 | APROVADO_REF | Enquadramento largo (inclui torso), rosto olhando para cima (miniatura). Ampliação sobre a fonte: ~1.2x. |
| `recortes-referencia/chefes/Seiran/Seiran_corpo_recorte.png` | recorte | 768x960 | APROVADO_REF | Conferir em tamanho cheio (miniatura mostra glifo no rodapé). Ampliação sobre a fonte: ~0.9x. |
| `recortes-referencia/chefes/Seiran/Seiran_reliquia_ou_detalhe_recorte.png` | recorte | 512x512 | VERIFICAR_RECORTES | Painel "DETALHES" (Brasão Imperial, Ornamento Demoníaco, Manto Real), não é um item único (miniatura). Ampliação sobre a fonte: ~1.3x. |
| `recortes-referencia/chefes/Seiran/Seiran_rosto_recorte.png` | recorte | 512x512 | APROVADO_REF | Conferir em tamanho cheio. Ampliação sobre a fonte: ~1.4x. |
| `recortes-referencia/chefes/Wu/Wu_corpo_recorte.png` | recorte | 768x960 | APROVADO_REF | Logo do jogo no canto e borda do cartão de recompensa (miniatura). Ampliação sobre a fonte: ~0.8x. |
| `recortes-referencia/chefes/Wu/Wu_reliquia_ou_detalhe_recorte.png` | recorte | 512x512 | VERIFICAR_RECORTES | Cartão "RECOMPENSA — Incensário da Apatia" com texto embutido (miniatura). Ampliação sobre a fonte: ~1.3x. |
| `recortes-referencia/chefes/Wu/Wu_rosto_recorte.png` | recorte | 512x512 | APROVADO_REF | NÃO mostra o rosto (verificado em tamanho cheio): só pescoço, contas, ombro e sino. Ampliação sobre a fonte: ~1.2x. |
| `recortes-referencia/chefes/Xui/Xui_corpo_recorte.png` | recorte | 768x960 | APROVADO_REF | Logo do jogo no canto e glifo no rodapé (miniatura). Ampliação sobre a fonte: ~0.8x. |
| `recortes-referencia/chefes/Xui/Xui_reliquia_ou_detalhe_recorte.png` | recorte | 512x512 | VERIFICAR_RECORTES | Cartão "RECOMPENSA" cortado ("INCENSÁRIO DA…") (miniatura). Ampliação sobre a fonte: ~1.3x. |
| `recortes-referencia/chefes/Xui/Xui_rosto_recorte.png` | recorte | 512x512 | APROVADO_REF | Enquadramento largo: rosto parcial + barriga (miniatura). Ampliação sobre a fonte: ~1.0x. |
| `recortes-referencia/itens/contas.png` | recorte | 384x384 | APROVADO_CONCEITO_NAO_ATLAS | Item de baixa resolução (ampliado ~4-5x, borrado), fundo escuro de cartão e legenda cortada no rodapé (miniatura). Ampliação sobre a fonte: ~3.8x. |
| `recortes-referencia/itens/katana.png` | recorte | 384x384 | APROVADO_CONCEITO_NAO_ATLAS | Item de baixa resolução (ampliado ~4-5x, borrado), fundo escuro de cartão e legenda cortada no rodapé (miniatura). Ampliação sobre a fonte: ~3.9x. |
| `recortes-referencia/itens/manopla.png` | recorte | 384x384 | APROVADO_CONCEITO_NAO_ATLAS | Item de baixa resolução (ampliado ~4-5x, borrado), fundo escuro de cartão e legenda cortada no rodapé (miniatura). Ampliação sobre a fonte: ~3.9x. |
| `recortes-referencia/itens/talisma.png` | recorte | 384x384 | APROVADO_CONCEITO_NAO_ATLAS | Item de baixa resolução (ampliado ~4-5x, borrado), fundo escuro de cartão e legenda cortada no rodapé (miniatura). Ampliação sobre a fonte: ~3.8x. |
| `recortes-referencia/itens/traje.png` | recorte | 384x384 | APROVADO_CONCEITO_NAO_ATLAS | Item de baixa resolução (ampliado ~4-5x, borrado), fundo escuro de cartão e legenda cortada no rodapé (miniatura). Ampliação sobre a fonte: ~3.7x. |
| `recortes-referencia/luke/Luke_arnes.png` | recorte | 640x480 | APROVADO_REF | Mostra arnês parcial + parte da paleta de cores; NÃO isola o arnês. Ampliação sobre a fonte: ~3.5x. |
| `recortes-referencia/luke/Luke_brincando.png` | recorte | 768x768 | APROVADO_REF | Fundo do painel incluso. Conferido só em miniatura. Ampliação sobre a fonte: ~2.3x. |
| `recortes-referencia/luke/Luke_corrida.png` | recorte | 768x768 | APROVADO_REF | Fundo do painel incluso. Conferido só em miniatura. Ampliação sobre a fonte: ~2.1x. |
| `recortes-referencia/luke/Luke_expressoes.png` | recorte | 640x480 | APROVADO_REF | Moldura e título "EXPRESSÕES" incluídos. Ampliação sobre a fonte: ~1.2x. |
| `recortes-referencia/luke/Luke_farejando.png` | recorte | 768x768 | APROVADO_REF | Resto do rótulo "(CORPO INTEIRO)" no topo; fundo de pedra incluso. Ampliação sobre a fonte: ~1.9x. |
| `recortes-referencia/luke/Luke_lenco.png` | recorte | 640x480 | APROVADO_REF | Lenço parcial, com título "ACESSÓRIOS"; borda cortada. Não isolado. Ampliação sobre a fonte: ~3.9x. |
| `recortes-referencia/luke/Luke_pe.png` | recorte | 768x768 | APROVADO_REF | Fragmentos de texto ("…neiro", "ada,") e rótulo "1 POSE PRINCIPAL" dentro do recorte. Ampliação sobre a fonte: ~1.6x. |
| `recortes-referencia/luke/Luke_pingente.png` | recorte | 640x480 | APROVADO_REF | Pingente com fragmentos de moldura; não isolado. Ampliação sobre a fonte: ~3.9x. |
| `recortes-referencia/luke/Luke_sentado.png` | recorte | 768x768 | APROVADO_REF | Rótulo "2 SENTADO" cortado no rodapé; fundo do painel incluso. Ampliação sobre a fonte: ~1.7x. |
| `recortes-referencia/luke/Luke_turnaround.png` | recorte | 640x480 | APROVADO_REF | Moldura e título "VISTAS DE PRODUÇÃO" incluídos; as 4 vistas são pequenas na fonte. Ampliação sobre a fonte: ~1.2x. |
| `recortes-referencia/ren/Ren_base_corpo.png` | recorte | 768x960 | APROVADO_CONCEITO_CONFERIR_IDENTIDADE | Design "Ren árabe" (cimitarra, lenço branco, cabelo curto): NÃO é o Ren oficial. Barras pretas laterais, texto cortado no rodapé, outro rosto à direita. Ampliação sobre a fonte: ~0.9x. |
| `recortes-referencia/ren/Ren_rosto.png` | recorte | 512x512 | APROVADO_CONCEITO_CONFERIR_IDENTIDADE | Design "Ren árabe" (superado). Conferido só em miniatura. Ampliação sobre a fonte: ~0.9x. |
| `recortes-referencia/ren/Ren_transformado.png` | recorte | 768x960 | APROVADO_CONCEITO_CONFERIR_IDENTIDADE | Design "Ren árabe" (superado). Fundo incluso. Conferido só em miniatura. Ampliação sobre a fonte: ~1.7x. |
| `recortes-referencia/sistemas/HUD_base.png` | recorte | 1024x640 | APROVADO_CONCEITO | Conceito de sistema/ambiente com título do painel incluso; baixa resolução na fonte (miniatura). Ampliação sobre a fonte: ~2.9x. |
| `recortes-referencia/sistemas/arvore_evolucao.png` | recorte | 1024x640 | APROVADO_CONCEITO | Conceito de sistema/ambiente com título do painel incluso; baixa resolução na fonte (miniatura). Ampliação sobre a fonte: ~2.5x. |
| `recortes-referencia/sistemas/exemplos_combate_2d.png` | recorte | 1024x640 | APROVADO_CONCEITO | Conceito de sistema/ambiente com título do painel incluso; baixa resolução na fonte (miniatura). Ampliação sobre a fonte: ~1.8x. |
| `recortes-referencia/sistemas/mapas_e_cenarios.png` | recorte | 1024x640 | APROVADO_CONCEITO | Conceito de sistema/ambiente com título do painel incluso; baixa resolução na fonte (miniatura). Ampliação sobre a fonte: ~2.0x. |
| `referencias-aprovadas/chefes/Baku_Ira_original.png` | original | 1122x1402 | APROVADO_REFERENCIA (original, não editar) |  |
| `referencias-aprovadas/chefes/Kairen_Avareza_original.png` | original | 1122x1402 | APROVADO_REFERENCIA (original, não editar) |  |
| `referencias-aprovadas/chefes/Seiran_Soberba_ficha_conceitual.png` | original | 1122x1402 | APROVADO_REFERENCIA (original, não editar) |  |
| `referencias-aprovadas/chefes/Senhor_Sete_Pecados_conceito_individual.png` | original | 941x1672 | APROVADO_REFERENCIA (original, não editar) | Idêntico (SHA-256) a assets/conceitos-em-avaliacao/chefes/senhor_sete_pecados_conceito_A.png. |
| `referencias-aprovadas/chefes/Wu_Preguica_original.png` | original | 1122x1402 | APROVADO_REFERENCIA (original, não editar) |  |
| `referencias-aprovadas/chefes/Xui_Gula_original.png` | original | 1122x1402 | APROVADO_REFERENCIA (original, não editar) |  |
| `referencias-aprovadas/direcao/prancha_layout_historia_itens.png` | original | 1536x1024 | APROVADO_REFERENCIA (original, não editar) | Fonte dos recortes de itens e sistemas. Visualmente igual a prancha_visual_enviada_usuario.png (arquivo diferente). Idêntico (SHA-256) a assets/conceitos-em-avaliacao/pranchas/prancha_combate_e_assets.png. |
| `referencias-aprovadas/direcao/prancha_visual_enviada_usuario.png` | original | 1536x1024 | APROVADO_REFERENCIA (original, não editar) | O logo na imagem aparece como "ARASH VANGUARD" (erro de texto; o título correto é ARASHI VANGUARD), guardiões com nomes antigos (Zhen Guo, Tao'en) e Ren de coque, diferente do Ren oficial. Usar só como clima/layout. |
| `referencias-aprovadas/luke/Luke_ficha_conceitual_original.png` | original | 1122x1402 | APROVADO_REFERENCIA (original, não editar) | Luke oficial (decisão de 15/11/2026). Idêntico (SHA-256) a assets/conceitos-em-avaliacao/luke/luke_ficha_preproducao.png. |
| `referencias-aprovadas/protagonistas/Ren_Luke_poster_original.png` | original | 1086x1448 | APROVADO_REFERENCIA (original, não editar) | Pôster do design "Ren árabe". Marcado como referência no kit, mas NÃO é o Ren oficial (decisão de 15/11/2026). Idêntico (SHA-256) a assets/conceitos-em-avaliacao/ren/ren_com_luke_capa_conceito.png. |
| `referencias-aprovadas/protagonistas/Ren_Guerreiro_Errante_prancha_OFICIAL.png` | original | 1672x941 | APROVADO_REFERENCIA (Ren oficial) | ADICIONADO em 15/11/2026: prancha enviada pelo proprietário (fora do kit original). SHA-256 4bea4bb0951483bb681f12f95eb4f46e90dc2d6206f341450c101301180f5086. |

## Proposta de produção (aguarda aprovação de custos)
1. Projeto Godot em `godot/` com Ren placeholder (andar, pular, golpe) e controles de toque; exportação Web para teste no celular.
2. Sprite piloto do Ren (alvo ~128 px de altura, a testar entre 96 e 192): parado, correr, pular, golpe. Depende de PixelLab ou outra ferramenta; custo a informar antes de gastar.
3. Luke seguindo Ren e uma microárea. Só depois um chefe protótipo.
