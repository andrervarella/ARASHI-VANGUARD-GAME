# MANIFESTO DE ASSETS — ARASHI VANGUARD

Contrato entre quem produz e quem integra. Sem proveniência = licença não confirmada.

## Referências aprovadas (não são sprites)
| Chave | Caminho | Status | Proveniência |
|---|---|---|---|
| ren_oficial_prancha | `assets/referencias-aprovadas/protagonistas/Ren_Guerreiro_Errante_prancha_OFICIAL.png` | APROVADO_REFERENCIA (Ren oficial) | enviada pelo dono em 15/11/2026; arte de IA, ferramenta/prompt não informados |
| luke_ficha | `assets/referencias-aprovadas/luke/Luke_ficha_conceitual_original.png` | APROVADO_REFERENCIA (Luke oficial) | kit v1 |
| chefes, itens, pranchas, mundos | ver `docs/09_AUDITORIA_KIT_v1.md` (tabela com 60 linhas) | referência / conceito | kit v1, MANIFEST.json em `assets/kit-v1/` |

## Sprites e animações do jogo
**Nenhum asset jogável final existe.** Não afirmar que recorte, turnaround, paleta ou animação estão prontos.

| Chave | Quadro | Pivô | FPS | Estados | Status | Proveniência |
|---|---|---|---|---|---|---|
| ren | a definir (~128 px, testar 96–192) | pés | a definir | parado, corrida, pulo, agachar, andar agachado, golpe | **PENDENTE** (T-004) | — |
| luke | a definir | pés | a definir | parado, seguir, farejar | PENDENTE | — |

## Provisórios no protótipo (declarados, a substituir — DEC-010)
Ren, Luke, bonecos de treino, cenário e ícones do HUD são **desenhados por código** em `godot/*.gd`. Não são assets finais.

## Gerados por IA nesta fase
| ID | Título | Tipo | Ferramenta | Status | Drive | GitHub | Data |
|---|---|---|---|---|---|---|---|
| AV-GEN-001 | Distrito dos ferreiros à noite (conceito de cenário, 16:9, sem personagens) | conceito de cenário | Fenaky Muse Image, só texto (prompt em `docs/11`), 0,1 crédito | **GOSTEI do dono** (15/11) — conceito, não é tileset | PENDENTE (`03_CENARIOS_UI`; arquivo não chegou ao ambiente da IA) | não | 2026-11-15 |

Tentativas recusadas pelo Fenaky (política de segurança, sem cobrança): tela de título com a prancha do Ren como referência (2x). Uma falha sem motivo com a imagem da Lua Carmesim como referência.

## Lotes reprovados
Nenhum lote de sprites gerado ainda. Custos conhecidos em `docs/11_PLANO_DE_PRODUCAO_E_CUSTOS.md`.

## Acervo no Drive (V4.4, DEC-014)
Caminho lógico e permissões: `docs/ACERVO_DRIVE.md`. Nenhum destes arquivos é sprite jogável. Duplicatas do kit v1 (mesmo SHA-256) ficaram só em `00`: `conceitos-em-avaliacao/ren/ren_com_luke_capa_conceito.png` = AV-REF-011, `.../luke/luke_ficha_preproducao.png` = AV-REF-009, `.../chefes/senhor_sete_pecados_conceito_A.png` = AV-REF-004, `.../pranchas/prancha_combate_e_assets.png` = AV-REF-007.
Procedência comum: kit v1 do ChatGPT (15/11/2026), ferramenta/prompt originais não informados; prancha do Ren enviada pelo dono.

| ID | Arquivo no Drive (`GAMES_IA/ARASHI VANGUARD/...`) | Caminho no GitHub | Status | Dim. | Bytes | SHA-256 (12) | Drive |
|---|---|---|---|---|---|---|---|
| AV-REF-001 | `00_REFERENCIAS_APROVADAS/AV-REF-001_Baku_Ira_original_v1_2026-11-15.png` | `assets/referencias-aprovadas/chefes/Baku_Ira_original.png` | APROVADO_REFERENCIA | 1122x1402 | 2928438 | `2cbd4ab240d7` | ENVIADO e conferido |
| AV-REF-002 | `00_REFERENCIAS_APROVADAS/AV-REF-002_Kairen_Avareza_original_v1_2026-11-15.png` | `assets/referencias-aprovadas/chefes/Kairen_Avareza_original.png` | APROVADO_REFERENCIA | 1122x1402 | 2701915 | `80b6a623c7f9` | ENVIADO e conferido |
| AV-REF-003 | `00_REFERENCIAS_APROVADAS/AV-REF-003_Seiran_Soberba_ficha_conceitual_v1_2026-11-15_webp-sem-perda.webp` | `assets/referencias-aprovadas/chefes/Seiran_Soberba_ficha_conceitual.png` | APROVADO_REFERENCIA | 1122x1402 | 3511280 | `9840d8a2c6c5` | ENVIADO: cópia sem perda (pixels idênticos conferidos por script), SHA-256 no Drive `108c3b5f5904`; original byte a byte só no GitHub |
| AV-REF-004 | `00_REFERENCIAS_APROVADAS/AV-REF-004_Senhor_Sete_Pecados_conceito_individual_v1_2026-11-15_webp-sem-perda.webp` | `assets/referencias-aprovadas/chefes/Senhor_Sete_Pecados_conceito_individual.png` | APROVADO_REFERENCIA | 941x1672 | 3421545 | `c040cc9305ed` | ENVIADO: cópia sem perda (pixels idênticos conferidos por script), SHA-256 no Drive `1ae408b44dd4`; original byte a byte só no GitHub |
| AV-REF-005 | `00_REFERENCIAS_APROVADAS/AV-REF-005_Wu_Preguica_original_v1_2026-11-15.png` | `assets/referencias-aprovadas/chefes/Wu_Preguica_original.png` | APROVADO_REFERENCIA | 1122x1402 | 2566879 | `db113aa1bc9e` | ENVIADO e conferido |
| AV-REF-006 | `00_REFERENCIAS_APROVADAS/AV-REF-006_Xui_Gula_original_v1_2026-11-15.png` | `assets/referencias-aprovadas/chefes/Xui_Gula_original.png` | APROVADO_REFERENCIA | 1122x1402 | 2837713 | `eaa07762119b` | ENVIADO e conferido |
| AV-REF-007 | `00_REFERENCIAS_APROVADAS/AV-REF-007_prancha_layout_historia_itens_v1_2026-11-15.png` | `assets/referencias-aprovadas/direcao/prancha_layout_historia_itens.png` | APROVADO_REFERENCIA | 1536x1024 | 3063321 | `f618c72bdb6e` | ENVIADO e conferido |
| AV-REF-008 | `00_REFERENCIAS_APROVADAS/AV-REF-008_prancha_visual_enviada_usuario_v1_2026-11-15_webp-sem-perda.webp` | `assets/referencias-aprovadas/direcao/prancha_visual_enviada_usuario.png` | APROVADO_REFERENCIA | 1536x1024 | 3889726 | `fb806b4ce53f` | ENVIADO: cópia sem perda (pixels idênticos conferidos por script), SHA-256 no Drive `25a4539fef14`; original byte a byte só no GitHub |
| AV-REF-009 | `00_REFERENCIAS_APROVADAS/AV-REF-009_Luke_ficha_conceitual_original_v1_2026-11-15.png` | `assets/referencias-aprovadas/luke/Luke_ficha_conceitual_original.png` | APROVADO_REFERENCIA | 1122x1402 | 2726191 | `2e08fcc0e82c` | ENVIADO e conferido |
| AV-REF-010 | `00_REFERENCIAS_APROVADAS/AV-REF-010_Ren_Guerreiro_Errante_prancha_OFICIAL_v1_2026-11-15.png` | `assets/referencias-aprovadas/protagonistas/Ren_Guerreiro_Errante_prancha_OFICIAL.png` | APROVADO_REFERENCIA | 1672x941 | 3116353 | `4bea4bb09514` | ENVIADO e conferido |
| AV-REF-011 | `00_REFERENCIAS_APROVADAS/AV-REF-011_Ren_Luke_poster_original_v1_2026-11-15.png` | `assets/referencias-aprovadas/protagonistas/Ren_Luke_poster_original.png` | APROVADO_REFERENCIA | 1086x1448 | 3019959 | `27448ebc5dcf` | ENVIADO e conferido |
| AV-CON-001 | `01_ASSETS_EM_PRODUCAO/conceitos_em_avaliacao/AV-CON-001_senhor_sete_pecados_conceito_B_v1_webp-sem-perda.webp` | `assets/conceitos-em-avaliacao/chefes/senhor_sete_pecados_conceito_B.png` | CONCEITO_EM_AVALIACAO | 1122x1402 | 3526344 | `6ac9ee50a34e` | ENVIADO: cópia sem perda (pixels idênticos conferidos por script), SHA-256 no Drive `34790f17e75e`; original byte a byte só no GitHub |
| AV-CON-002 | `01_ASSETS_EM_PRODUCAO/conceitos_em_avaliacao/AV-CON-002_mundo_fortaleza_v1_png-otimizado-sem-perda.png` | `assets/conceitos-em-avaliacao/mundos/mundo_fortaleza.png` | CONCEITO_EM_AVALIACAO | 1086x1448 | 3333062 | `43b5a66547ae` | ENVIADO: cópia sem perda (pixels idênticos conferidos por script), SHA-256 no Drive `8f79acd20db2`; original byte a byte só no GitHub |
| AV-CON-003 | `01_ASSETS_EM_PRODUCAO/conceitos_em_avaliacao/AV-CON-003_mundo_lua_carmesim_v1_png-otimizado-sem-perda.png` | `assets/conceitos-em-avaliacao/mundos/mundo_lua_carmesim.png` | CONCEITO_EM_AVALIACAO | 1086x1448 | 3188992 | `ff8650fda85b` | ENVIADO: cópia sem perda (pixels idênticos conferidos por script), SHA-256 no Drive `d6dd966486b9`; original byte a byte só no GitHub |
| AV-CON-004 | `01_ASSETS_EM_PRODUCAO/conceitos_em_avaliacao/AV-CON-004_prancha_direcao_visual_geral_v1_png-otimizado-sem-perda.png` | `assets/conceitos-em-avaliacao/pranchas/prancha_direcao_visual_geral.png` | CONCEITO_EM_AVALIACAO | 1122x1402 | 3299274 | `94b0865ea821` | ENVIADO: cópia sem perda (pixels idênticos conferidos por script), SHA-256 no Drive `e947c0b47bdb`; original byte a byte só no GitHub |
| AV-CON-005 | `01_ASSETS_EM_PRODUCAO/conceitos_em_avaliacao/AV-CON-005_ren_transformacao_conceito_v1.png` | `assets/conceitos-em-avaliacao/ren/ren_transformacao_conceito.png` | CONCEITO_EM_AVALIACAO | 1086x1448 | 3103570 | `495984a11a50` | ENVIADO e conferido |
| AV-REC-001 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-001_chefes_Baku_Baku_corpo_recorte_v1.png` | `assets/recortes-referencia/chefes/Baku/Baku_corpo_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 768x960 | 1256021 | `0d347367ded8` | ENVIADO e conferido |
| AV-REC-002 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-002_chefes_Baku_Baku_reliquia_ou_detalhe_recorte_v1.png` | `assets/recortes-referencia/chefes/Baku/Baku_reliquia_ou_detalhe_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 277708 | `cde4c126b452` | ENVIADO e conferido |
| AV-REC-003 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-003_chefes_Baku_Baku_rosto_recorte_v1.png` | `assets/recortes-referencia/chefes/Baku/Baku_rosto_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 545784 | `1af32268bda7` | ENVIADO e conferido |
| AV-REC-004 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-004_chefes_BossFinal_BossFinal_corpo_recorte_v1.png` | `assets/recortes-referencia/chefes/BossFinal/BossFinal_corpo_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 768x960 | 1499871 | `f50cb0eaabe8` | ENVIADO e conferido |
| AV-REC-005 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-005_chefes_BossFinal_BossFinal_reliquia_ou_detalhe_recorte_v1.png` | `assets/recortes-referencia/chefes/BossFinal/BossFinal_reliquia_ou_detalhe_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 403638 | `b66bb5565cbd` | ENVIADO e conferido |
| AV-REC-006 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-006_chefes_BossFinal_BossFinal_rosto_recorte_v1.png` | `assets/recortes-referencia/chefes/BossFinal/BossFinal_rosto_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 523442 | `240dfd3ab31e` | ENVIADO e conferido |
| AV-REC-007 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-007_chefes_Kairen_Kairen_corpo_recorte_v1.png` | `assets/recortes-referencia/chefes/Kairen/Kairen_corpo_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 768x960 | 1167455 | `51e78d3ee0df` | ENVIADO e conferido |
| AV-REC-008 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-008_chefes_Kairen_Kairen_reliquia_ou_detalhe_recorte_v1.png` | `assets/recortes-referencia/chefes/Kairen/Kairen_reliquia_ou_detalhe_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 234283 | `6d1d365fa167` | ENVIADO e conferido |
| AV-REC-009 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-009_chefes_Kairen_Kairen_rosto_recorte_v1.png` | `assets/recortes-referencia/chefes/Kairen/Kairen_rosto_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 390018 | `259dcbb855d8` | ENVIADO e conferido |
| AV-REC-010 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-010_chefes_Seiran_Seiran_corpo_recorte_v1.png` | `assets/recortes-referencia/chefes/Seiran/Seiran_corpo_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 768x960 | 1688054 | `6eb790dcdc9c` | ENVIADO e conferido |
| AV-REC-011 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-011_chefes_Seiran_Seiran_reliquia_ou_detalhe_recorte_v1.png` | `assets/recortes-referencia/chefes/Seiran/Seiran_reliquia_ou_detalhe_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 277114 | `652e77419c16` | ENVIADO e conferido |
| AV-REC-012 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-012_chefes_Seiran_Seiran_rosto_recorte_v1.png` | `assets/recortes-referencia/chefes/Seiran/Seiran_rosto_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 587290 | `fc8af9433194` | ENVIADO e conferido |
| AV-REC-013 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-013_chefes_Wu_Wu_corpo_recorte_v1.png` | `assets/recortes-referencia/chefes/Wu/Wu_corpo_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 768x960 | 1054301 | `2b2ab70e1e1d` | ENVIADO e conferido |
| AV-REC-014 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-014_chefes_Wu_Wu_reliquia_ou_detalhe_recorte_v1.png` | `assets/recortes-referencia/chefes/Wu/Wu_reliquia_ou_detalhe_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 224540 | `c32181d763f9` | ENVIADO e conferido |
| AV-REC-015 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-015_chefes_Wu_Wu_rosto_recorte_v1.png` | `assets/recortes-referencia/chefes/Wu/Wu_rosto_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 428476 | `e609ec4434bd` | ENVIADO e conferido |
| AV-REC-016 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-016_chefes_Xui_Xui_corpo_recorte_v1.png` | `assets/recortes-referencia/chefes/Xui/Xui_corpo_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 768x960 | 1291492 | `d660368be4f6` | ENVIADO e conferido |
| AV-REC-017 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-017_chefes_Xui_Xui_reliquia_ou_detalhe_recorte_v1.png` | `assets/recortes-referencia/chefes/Xui/Xui_reliquia_ou_detalhe_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 251881 | `5a351b123e5c` | ENVIADO e conferido |
| AV-REC-018 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-018_chefes_Xui_Xui_rosto_recorte_v1.png` | `assets/recortes-referencia/chefes/Xui/Xui_rosto_recorte.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 538167 | `6eda3bf4fb01` | ENVIADO e conferido |
| AV-REC-019 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-019_itens_contas_v1.png` | `assets/recortes-referencia/itens/contas.png` | RECORTE_REFERENCIA (não é sprite) | 384x384 | 92780 | `2667bd487893` | ENVIADO e conferido |
| AV-REC-020 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-020_itens_katana_v1.png` | `assets/recortes-referencia/itens/katana.png` | RECORTE_REFERENCIA (não é sprite) | 384x384 | 81767 | `22999e47f1c8` | ENVIADO e conferido |
| AV-REC-021 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-021_itens_manopla_v1.png` | `assets/recortes-referencia/itens/manopla.png` | RECORTE_REFERENCIA (não é sprite) | 384x384 | 131565 | `99b305a2896d` | ENVIADO e conferido |
| AV-REC-022 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-022_itens_talisma_v1.png` | `assets/recortes-referencia/itens/talisma.png` | RECORTE_REFERENCIA (não é sprite) | 384x384 | 111397 | `4cad699dae9d` | ENVIADO e conferido |
| AV-REC-023 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-023_itens_traje_v1.png` | `assets/recortes-referencia/itens/traje.png` | RECORTE_REFERENCIA (não é sprite) | 384x384 | 125327 | `826b2ec42014` | ENVIADO e conferido |
| AV-REC-024 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-024_luke_Luke_arnes_v1.png` | `assets/recortes-referencia/luke/Luke_arnes.png` | RECORTE_REFERENCIA (não é sprite) | 640x480 | 207791 | `21ba45aa889f` | ENVIADO e conferido |
| AV-REC-025 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-025_luke_Luke_brincando_v1.png` | `assets/recortes-referencia/luke/Luke_brincando.png` | RECORTE_REFERENCIA (não é sprite) | 768x768 | 515327 | `0c6c9fd50ee7` | ENVIADO e conferido |
| AV-REC-026 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-026_luke_Luke_corrida_v1.png` | `assets/recortes-referencia/luke/Luke_corrida.png` | RECORTE_REFERENCIA (não é sprite) | 768x768 | 501658 | `401292d05506` | ENVIADO e conferido |
| AV-REC-027 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-027_luke_Luke_expressoes_v1.png` | `assets/recortes-referencia/luke/Luke_expressoes.png` | RECORTE_REFERENCIA (não é sprite) | 640x480 | 315806 | `73c588848a5e` | ENVIADO e conferido |
| AV-REC-028 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-028_luke_Luke_farejando_v1.png` | `assets/recortes-referencia/luke/Luke_farejando.png` | RECORTE_REFERENCIA (não é sprite) | 768x768 | 517051 | `8569d270c85e` | ENVIADO e conferido |
| AV-REC-029 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-029_luke_Luke_lenco_v1.png` | `assets/recortes-referencia/luke/Luke_lenco.png` | RECORTE_REFERENCIA (não é sprite) | 640x480 | 294095 | `70fcbb1c653c` | ENVIADO e conferido |
| AV-REC-030 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-030_luke_Luke_pe_v1.png` | `assets/recortes-referencia/luke/Luke_pe.png` | RECORTE_REFERENCIA (não é sprite) | 768x768 | 885268 | `3ad50e2f4d05` | ENVIADO e conferido |
| AV-REC-031 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-031_luke_Luke_pingente_v1.png` | `assets/recortes-referencia/luke/Luke_pingente.png` | RECORTE_REFERENCIA (não é sprite) | 640x480 | 167498 | `28c12d368103` | ENVIADO e conferido |
| AV-REC-032 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-032_luke_Luke_sentado_v1.png` | `assets/recortes-referencia/luke/Luke_sentado.png` | RECORTE_REFERENCIA (não é sprite) | 768x768 | 659089 | `b2cca9e989bf` | ENVIADO e conferido |
| AV-REC-033 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-033_luke_Luke_turnaround_v1.png` | `assets/recortes-referencia/luke/Luke_turnaround.png` | RECORTE_REFERENCIA (não é sprite) | 640x480 | 297478 | `03a967aad1a5` | ENVIADO e conferido |
| AV-REC-034 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-034_ren_Ren_base_corpo_v1.png` | `assets/recortes-referencia/ren/Ren_base_corpo.png` | RECORTE_REFERENCIA (não é sprite) | 768x960 | 1129685 | `e39c64bbe835` | ENVIADO e conferido |
| AV-REC-035 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-035_ren_Ren_rosto_v1.png` | `assets/recortes-referencia/ren/Ren_rosto.png` | RECORTE_REFERENCIA (não é sprite) | 512x512 | 465616 | `b0c303be2070` | ENVIADO e conferido |
| AV-REC-036 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-036_ren_Ren_transformado_v1.png` | `assets/recortes-referencia/ren/Ren_transformado.png` | RECORTE_REFERENCIA (não é sprite) | 768x960 | 909100 | `e935b3fc0104` | ENVIADO e conferido |
| AV-REC-037 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-037_sistemas_HUD_base_v1.png` | `assets/recortes-referencia/sistemas/HUD_base.png` | RECORTE_REFERENCIA (não é sprite) | 1024x640 | 626273 | `cd78f4197390` | ENVIADO e conferido |
| AV-REC-038 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-038_sistemas_arvore_evolucao_v1.png` | `assets/recortes-referencia/sistemas/arvore_evolucao.png` | RECORTE_REFERENCIA (não é sprite) | 1024x640 | 655753 | `8b5fffd7ad37` | ENVIADO e conferido |
| AV-REC-039 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-039_sistemas_exemplos_combate_2d_v1.png` | `assets/recortes-referencia/sistemas/exemplos_combate_2d.png` | RECORTE_REFERENCIA (não é sprite) | 1024x640 | 432357 | `ca7daabc2849` | ENVIADO e conferido |
| AV-REC-040 | `01_ASSETS_EM_PRODUCAO/recortes_referencia/AV-REC-040_sistemas_mapas_e_cenarios_v1.png` | `assets/recortes-referencia/sistemas/mapas_e_cenarios.png` | RECORTE_REFERENCIA (não é sprite) | 1024x640 | 544758 | `847856bf5a6a` | ENVIADO e conferido |

## Regra de runtime
Sprites, cenários, UI e áudio **finais** usados pelo Godot ficam no GitHub, otimizados. O Google Drive guarda a **fonte/original**, não cópia integral dos arquivos de runtime. O jogo nunca depende de baixar algo do Drive para rodar (V4.5, DEC-015).


## Fichas de pré-produção novas — 16/11/2026 (não são sprites finais)

Lote de 15 imagens no Drive, com hashes, versões e estado individual: [`docs/12_HANDOFF_FICHAS_PIXELLAB_2026-11-16.md`](12_HANDOFF_FICHAS_PIXELLAB_2026-11-16.md). Arquivos `AV-FIC-001` a `AV-FIC-015`. **Salvos e listados no Drive; acesso do Claude ainda não verificado; nenhum sprite final de runtime gerado.**

| ID | Versão | Status | Drive (pasta lógica + arquivo) | Runtime no GitHub | SHA-256 do upload Drive |
|---|---|---|---|---|---|
| AV-FIC-001 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-001_REN_forma_base_v01.png` | — | `a57864d6fb72f702d039d1732f4de03958f7a3fe80ecab90886d3b0ea3c11496` |
| AV-FIC-002 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-002_REN_forma_carmesim_v01.png` | — | `2155b5e3e1bf66605f49c7e354aca84607d2cadec8245773a23737b802f41cf3` |
| AV-FIC-003 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-003_LUKE_turnaround_acoes_v01.png` | — | `5e37f338f64c6acec23c7bf191d553733bb05d279320fde4287dadf30984f5fc` |
| AV-FIC-004 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-004_KAIREN_corpo_e_golpes_v01.png` | — | `bd498839877c09c64b6df7521af4c08dca269731d1b03dedaef8b2700d77992c` |
| AV-FIC-005 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-005_XUI_corpo_e_golpes_v01.png` | — | `9d3e0e283a4012dce74f0fe869732434c9d6310fa8307d2b16f9fd0eb708110d` |
| AV-FIC-006 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-006_BAKU_corpo_e_golpes_v01.png` | — | `93745830b49aa52a83da9a951fd660627c84cadc58dd5bc68f1272fe6b15a348` |
| AV-FIC-007 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-007_WU_corpo_e_golpes_v01.png` | — | `2d33a9f00d06433d81127082ced21d96a2d1e16351bb42a8b654f8cc102e874c` |
| AV-FIC-008 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-008_MEI_SHIAN_visual_turnaround_v01.png` | — | `0505cd903a086c786d626d586b10b3bf5b19dca150ebd6880568dc0deec98785` |
| AV-FIC-009 | v01 | aprovada | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-009_MEI_SHIAN_poses_combate_v01.png` | — | `51c1aa8b0d5bc7f689d09bf036c4d412bdd923399bd830b1760155f3502de4e8` |
| AV-FIC-010 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-010_SHUYIN_visual_principal_v01.png` | — | `b39ae689059cad26787bed759636c8a415ce7a035784e0d6d7727547c32d2f15` |
| AV-FIC-011 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-011_SHUYIN_poses_combate_v01.png` | — | `3ba20bb0ac86742cdd0e71d1de29541dd3aece44753b263c70eddd26336e87f9` |
| AV-FIC-012 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-012_SEIRAN_corpo_e_detalhes_v01.png` | — | `b7960d0747a97e16b541f0577c73f59111b41cae85e660c31e6ddf6d546c66e9` |
| AV-FIC-013 | v01 | referência | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-013_SHIN_ONI_corpo_fisico_v01.png` | — | `47b943500adee1d9f49de012231fd6f3bc526eda43b37993e70d3495d5645434` |
| AV-FIC-014 | v01 | aprovada | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-014_SHIN_ONI_fases_combate_v01.png` | — | `da40fbae50e8d94ba49cbb0d1373ca45a83fbe61ef89a121fc8773f9f81463da` |
| AV-FIC-015 | v01 | pôster em avaliação | `01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/AV-FIC-015_PANTEÃO_CHEFES_poster_eclipse_v01.webp` | — | `9aee7016aa465752a6ddb779690589a1252e5b0408a98dd2e901bd3f1f226ab0` |

Nenhum link do Google Drive foi publicado aqui. O `MANIFESTO_FICHAS_CLAUDE_2026-11-16.json` (somente no Drive) registra o SHA-256 da origem e o do arquivo salvo, indicando os 2 casos de conversão **sem perda** com igualdade RGBA exata verificada por script.

## Runtime das fases 1 e 2 (16/11/2026, T-015)
Origem, IDs do PixelLab e licenças: `godot/assets/CREDITOS.md`. Pastas: `godot/assets/{sprites,bg,story,portraits,ui,sfx,fonts}`. Status: **em teste** (dono ainda não aprovou no celular). Fundos PixelLab: ferreiros, torii, vila, xui (688×384). Músicas: biblioteca PixelLab do dono (AV - Titulo, AV - Fase, AV - Chefe, AV - Vila; take 1), fora do repositório (DEC-018).

## Pôster oficial dos chefes com o chefe final (16/11/2026, T-019, DEC-021)
| ID | Arquivo no GitHub | Status | Tamanho | Origem |
|---|---|---|---|---|
| AV-POSTER-002 | `assets/referencias-aprovadas/chefes/AV-POSTER-002_chefes_chefe_final_v3.png` | APROVADO PELO DONO (versão 3 de 4) | 1280×1920, SHA-256 `a68cfcb509ac…` | Fenaky Muse Image, edição do pôster AV-FIC-015 com a ficha do demônio ruivo como referência; sem máscara (revisão do dono). Asset Fenaky `3719b69f-773f-40de-b5f4-ed6aa20fc8ce` |
