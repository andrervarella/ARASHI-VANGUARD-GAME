# 11 — Plano de produção e custos (ferramentas de IA)

Status: PROPOSTA (nada gasto). Data: 2026-11-15. Autor: Claude (Sonnet 5.5). Depende do "ok" do dono antes de qualquer gasto.
Evidência: preços do Fenaky e do PixelLab lidos pelas ferramentas conectadas (EXECUTADO, grátis). Preços do Higgsfield e dos planos do PixelLab: SÓ LIDO em sites de terceiros (conflitantes) — NÃO VERIFICADO.

## 1. Regra de divisão

- **Fenaky** = arte "grande" e mídia: conceito, telas, quadros de cutscene, fundos de referência, trailer curto, música.
- **PixelLab** = tudo que entra no jogo em pixel art: sprites, animações, tilesets, ícones, UI, (SFX).
- **Higgsfield** = só se o dono quiser vídeo de maior qualidade (trailer); NÃO é necessário para o jogo (ver seção 4).
- Godot/código = movimento, câmera, parallax procedural, cutscenes animadas em engine (padrão do método V4.3). Nada de personagem desenhado por código.

## 2. O que criar em qual

| Item | Ferramenta | Por quê |
|---|---|---|
| Tela de título, quadros da intro/final, key art | Fenaky Muse Image (0,1 crédito) | Barato, aceita até 9 referências (@Imagem1..9), 16:9 |
| Fichas/turnarounds de conceito (bosses, aliados) | Fenaky Muse Image | Conceito antes de gastar em pixel art |
| Sprites jogáveis (Ren, Luke, chefes, inimigos) | PixelLab (create_character / pro + animate_character) | Saída pronta para Godot; pro aceita imagem de conceito |
| Cenário (tilesets) | PixelLab sidescroller tileset | Standard 1 gen para testar; pro 15–25 para final (precisa Tier 1+) |
| Fundo parallax | Conceito no Fenaky + 1 peça final por mundo no PixelLab (create_image_pro 25 gens) + repetição procedural | Evita pagar 15 fundos |
| Ícones dos 21 itens | PixelLab create_image_pixen (1 gen cada) | Estilo consistente |
| HUD/menus | PixelLab create_ui_asset (10–25) usando HUD_base como estilo | Peças recortáveis |
| Vídeo (1–3 momentos) | Fenaky Ninja 2.0 (0,25/10 s) p/ teste; Gemini Omni 1080p (6,48/10 s) p/ final | Método: vídeo só em momentos-chave |
| Música | Fenaky Music (4 créditos/faixa, 2 versões) | Mais barato e já disponível; loop perfeito não garantido |
| Efeitos sonoros | PixelLab create_sound_effect (1–4 gens) | Fenaky não lista SFX; exige Tier 2+ (NÃO VERIFICADO) |
| VFX de golpes/magias | PixelLab vfx_workbench / pixelart_workbench (grátis) | Sem custo de geração |

## 3. Orçamento

### 3.1 Fatia vertical (protótipo 10–15 min, 1 chefe)
- Fenaky: ~30 imagens (3 tentativas) = ~9 cr; 1 vídeo de teste = ~1 cr; música (título, fase, chefe, vitória, derrota) = 20 cr. **Total ~30 cr (~10 sem música).**
- PixelLab: Ren ~45 + Luke ~20 + mini-chefe ~40 + 3 inimigos ~24 + 1 tileset ~25 + HUD ~40 + ícones ~10 = **~205 gerações**. A avaliação grátis (40) cobre só o piloto do Ren.

### 3.2 Jogo completo (8 chefes, 5 mundos, 21 itens)
- Fenaky: imagens ~225 peças, ~45 cr (25–70); vídeo 8–22 cr; música ~11 faixas, 44–66 cr. **Total ~100–160 cr.**
- PixelLab: Ren+Luke ~75; 8 chefes ~320; 12 inimigos ~100; tilesets ~140; fundos ~125; UI ~80; ícones ~30; SFX ~60 = ~930; com repetições ~**1.200 gerações** (+~110 se a música sair do PixelLab).

### 3.3 Dinheiro
- Fenaky: preço do crédito em R$ NÃO consultado (a conta tem 2 créditos). Conferir no plano antes de comprar.
- PixelLab: ferramentas indicam ~US$0,008 por geração em créditos avulsos (1.200 gerações ≈ US$10); assinatura Tier 1 ≈ US$12/mês (terceiros). Confirmar em pixellab.ai.
- Higgsfield: Starter US$15–19/mês (200–270 créditos, ≈33 vídeos Kling), Plus US$39–59/mês (1.000 créditos). Fontes divergem; créditos não acumulam.

## 4. Fenaky x Higgsfield
- O jogo precisa de poucos vídeos (3 a 6 clipes). Assinatura mensal do Higgsfield para isso tem custo-benefício ruim; Fenaky já está conectado, tem modelos baratos (Ninja 0,25 cr/10 s; Muse Video 0,3) e também faz imagem e música.
- Higgsfield só compensa se o dono também for usar para os vídeos do Instagram (hipótese dele; não verificada) ou se o teste do Fenaky não agradar.
- Higgsfield aparece no diretório de conectores, mas não está conectado (connect_incomplete); não foi testado.
- Regra proposta: testar 1 clipe no Fenaky (0,25 cr). Se a qualidade bastar, nada de Higgsfield para o jogo.

## 5. Primeiro gasto proposto (aguarda ok)
- Fenaky: 4 imagens do Portão V (~0,4 cr) + 1 vídeo de teste Ninja (0,25 cr) = ~0,65 cr dos 2 disponíveis.
- PixelLab: nada até o dono aprovar o piloto do Ren (~25 gerações do conceito + animações).

Fontes: ferramentas Fenaky (studio_video_products, studio_audio_products, get_account) e PixelLab (search_help); higgsfield.ai/blog/higgsfield-pricing-explained; geo.higgsfield.ai (preços divergentes); knowara.com e ai.g2.com (planos PixelLab, terceiros).
