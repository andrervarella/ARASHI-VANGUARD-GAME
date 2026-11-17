# GDD — ARASHI VANGUARD (v0 · rascunho para o Portão V · trava depois do Portão 1)

> Escrito na T-003 (Claude Opus, 15/11/2026). Base: `docs/01` a `docs/04`, `docs/10`, DEC-003 a DEC-013. Itens marcados **(proposta)** ainda não foram aprovados pelo dono.

- **High concept:** um ferreiro comum abre o portão que salva seu bairro e, com isso, rompe o selo que prendia sete demônios.
- **Frase do jogo:** *"Eles fecharam o portão com a gente dentro. Eu abri."*
- **Fantasia do jogador / emoção:** ser o homem comum que aprendeu a lutar sozinho e encara quem manda. Emoção central: **determinação com culpa**, que vira responsabilidade.
- **3 pilares:** (1) combate de leitura: chefes com padrão fixo e justo; (2) escolhas que mostram o estilo do jogador: 1 de 3 itens por chefe, sem combinação melhor; (3) história de ofício: o martelo e a forja explicam o mundo e o final.
- **Core loop:** explorar o distrito → lutar (ler o inimigo, punir) → vencer o chefe → ganhar poder e escolher 1 item → abrir caminho novo → próximo guardião.
- **Hook de 5 s (demonstrável num GIF):** Ren arromba a engrenagem do portão com o martelo, sob a lua vermelha, e o portão explode em luz.

## História curta
Ren Arashi conserta ferramentas numa forja do distrito pobre e treina espada à noite, sozinho. Na noite da Lua Carmesim, o ritual das sete famílias falha, e elas fecham os portões com os trabalhadores dentro. Ren conhece aquelas engrenagens: arromba o mecanismo e o povo foge, junto com um cãozinho que ele passa a chamar de Luke. Mas o portão era parte do selo. Uma entidade escapa, Ren é derrubado, sobrevive com uma cicatriz no peito e vira o culpado oficial. Agora ele caça os sete guardiões. Cada vitória lhe dá um poder e uma nova cicatriz, e o aproxima de uma pergunta: quem forjou os selos de verdade, e por que as marcas de ofício neles parecem as suas?

- **O que está em jogo:** o distrito, o nome do Ren (foi culpa dele ou não?) e ele mesmo, que pode virar o novo recipiente.
- **Pergunta aberta:** quem fez os selos? Por que as entidades não atacam o Luke?
- **Arco emocional:** culpa e raiva (prólogo) → orgulho que cobra preço (chefes do meio) → descoberta (os selos são obra de gente comum) → responsabilidade (reforjar o selo com os aliados, ou não).
- **Gancho dos 10 s:** a primeira imagem já é a noite da ruptura (lua vermelha, portão fechando, gritos). Texto: "Eles fecharam o portão com a gente dentro." Corte para o martelo na engrenagem. Nada de tela parada explicando regras.

## Roteiro das cenas (embalagem)
| # | Cena | Duração | Emoção | Imagens | Música/som |
|---|---|---|---|---|---|
| 1 | **Tela inicial**: Ren e Luke na chuva sob a lua carmesim; chuva e lanternas em parallax, capa do Ren balança, logo pulsa devagar. Jogar · Opções (som) · Créditos | loop | ameaça calma | 1 arte-título paisagem (camadas) | taiko grave, vento, chuva |
| 2 | **Introdução "A noite da ruptura"**: 5 painéis animados (pan/zoom/tremor): forja à noite → ritual falha, portão fecha → Ren na engrenagem → selo racha, entidade → cartaz de "culpado" | 30–40 s, pulável | choque → coragem → culpa | 5 imagens | silêncio, golpe de martelo, estrondo |
| 3 | **Prólogo jogável (tutorial)**: fuga pelo distrito em chamas; mover, pular, agachar sob escombros, atacar; Luke fareja o caminho | 3–5 min | urgência | cenário do distrito (peças) | percussão rápida |
| 4 | **Chefe protótipo** (Portão 1, ver `docs/10`) | 1–3 min | tensão → alívio | chefe + arena | tema do chefe |
| 5 | **Recompensa**: poder recebido, cicatriz acende, 3 cartas de item, "Esta decisão é permanente nesta campanha" | 8–12 s + escolha | conquista com peso | 3 ícones de item + cicatriz | acorde grave |
| 6 | **Derrota**: Ren de joelhos, Luke encosta na mão dele. "Levante." · Tentar de novo | 3 s | frustração acolhida | 1 imagem | 1 nota |
| 7 | **Vitória de área**: o selo mostra uma marca de ferreiro que Ren reconhece | 5–8 s | curiosidade | 1 imagem | tema da forja |
| 8 | **Final (candidato)**: Ren reforja o selo com os aliados, ou aceita o trono | 30–60 s (Fenaky só aqui e na intro, se o dono aprovar) | responsabilidade | 3–4 imagens | tema principal completo |

## Primeiro chefe protótipo (proposta)
**Baku, O General da Fúria (Ira)**, arte individual já aprovada. Motivo: o padrão-exemplo do dono ("pula, dá 2 golpes, para") é literalmente o ciclo de Baku em `docs/10`, e a Ira espelha a culpa e a raiva do Ren logo depois do prólogo. Alternativa: um mini-chefe novo (capataz do portão das famílias), que precisaria de arte nova e aprovação.

## Mecânicas e comandos (estado atual)
Controles de toque aprovados: `docs/CONTROLES_E_CONVENCOES.md`. Magia/poder e combos: a especificar (T-008). Chefes e itens: `docs/10_CHEFES_E_BALANCEAMENTO.md` (T-013).

## Escopo da primeira versão / exclusões
Vertical slice: tela inicial + introdução + prólogo + 1 chefe + tela de recompensa + derrota/vitória. **Fora:** os outros 6 mundos, transformação completa, NG+, vozes.

## Alvo técnico
Android, navegador, paisagem, base 960×540, Godot 4.4.1 (Web, sem threads). Link de teste: https://arashi-vanguard-prototipo.vercel.app.


> **Atualização 16/11 (DEC-016):** frase do jogo, abertura, cenas e trama agora em `docs/13_HISTORIA_CONSOLIDADA.md`. A tabela de cenas acima vale só onde não conflitar com o doc 13 (cutscenes: 1 por fase + final, uma tomada de 8–10 s).
