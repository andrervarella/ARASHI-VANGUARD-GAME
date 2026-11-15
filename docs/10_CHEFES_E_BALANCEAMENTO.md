# Chefes e balanceamento — ARASHI VANGUARD

> Origem: pedido do dono em 15/11/2026 (DEC-012). Os **princípios** abaixo são direção do dono. Os **padrões de cada chefe** e os **números** são rascunho de design do Claude: precisam de validação (T-013) e de teste jogado antes de virar decisão.

## 1. Princípios (direção do dono)

1. **Chefe com padrão fixo, estilo Mega Man.** Cada chefe repete uma sequência reconhecível ("pula, dá 2 golpes, para"). O jogador vence **aprendendo e raciocinando**, não por reflexo puro.
2. **Justo, não fácil e não brutal.** Ataque sempre telegrafado, janela de punição depois de cada sequência, dificuldade moderada. O padrão não pode facilitar demais nem virar parede.
3. **Cada chefe tem identidade mecânica própria** (alcance, ritmo, tipo de ameaça), além da aparência. Dois chefes não podem se resolver do mesmo jeito.
4. **Itens e poderes mudam a luta.** Dependendo do item que o jogador escolheu nos chefes anteriores, um chefe fica mais fácil ou mais difícil.
5. **Não existe combinação melhor.** Nenhum conjunto de itens vence tudo com folga. A escolha expressa o **estilo de jogo** do jogador; cada pessoa monta o seu.
6. A escolha nunca bloqueia travessia obrigatória nem o final (regra já aprovada em `docs/04`). Todo chefe é vencível com qualquer combinação; muda o caminho, não a possibilidade.

## 2. Anatomia de um chefe (modelo obrigatório)

Todo chefe é especificado assim antes de ser implementado:

| Campo | O que descrever |
|---|---|
| Identidade | A "pergunta" que ele faz ao jogador (ex.: "você sabe esperar?") |
| Ciclo de ataque | 2 a 4 ataques em ordem fixa, com a pausa de vulnerabilidade no final |
| Telégrafo | O sinal visual/sonoro de cada ataque (≥ 0,4 s) |
| Janela de punição | Quando e por quanto tempo o jogador pode bater (≥ 1,0 s ao fim do ciclo) |
| Fase 2 | Uma mudança legível (ataque novo ou ciclo acelerado), sem esconder a fase 1 |
| Variação | No máximo 1 ataque fora do ciclo, avisado por sinal próprio |
| Afinidades | Quais itens ajudam e quais atrapalham (seção 4) |
| Faixa de duração | Tempo-alvo de luta para um jogador médio |

Regras: ciclo previsível (sem sorteio puro), dano claro em toda a tela, ponto de recomeço próximo da sala do chefe, e a luta tem de ser legível no celular (telas pequenas, polegares).

## 3. Rascunho de padrão por chefe (a validar)

Ordem de aparição ainda não decidida. Os chefes são independentes entre si (cada um dá poder e três itens).

| Chefe | Identidade (a pergunta) | Ciclo base (rascunho) | Punição | Fase 2 (rascunho) |
|---|---|---|---|---|
| Kairen (Avareza) | "Você consegue se proteger do que eu pego?" | Estende braços para puxar → arremessa relíquias em arco → recua e se abaixa | Ao recuar | Mais braços, relíquias em dois arcos |
| Xui (Gula) | "Você aguenta esperar o momento certo?" | Investe de barriga (lento, longo) → engole projétil/energia → arrota onda baixa que se pula | Depois da onda | Investida em dupla |
| Mei Shian (Inveja) | "Qual é o verdadeiro?" | Cria 2 reflexos → só o original reage a golpe → reflexos somem em sequência | Quando os reflexos somem | 3 reflexos, ordem muda de forma legível |
| Shuyin (Luxúria) | "Você mantém a cabeça fria?" | Fumaça/ilusão que inverte um comando por 3 s, sinalizada → avança com ataque simples | Depois do avanço | Ilusão mais curta e mais frequente (nunca inverte o PULAR) |
| Wu (Preguiça) | "Você controla o ritmo?" | Campo lento no chão → golpes de cajado espaçados → pausa de meditação longa | Meditação | Campos menores, mas dois ao mesmo tempo |
| Baku (Ira) | "Você sabe esquivar e punir?" | Pula → 2 golpes grandes → para ofegante | Ofegante | Terceiro golpe com onda de brasas |
| Seiran (Soberba) | "Você consegue chegar nele?" | Fica no alto e dispara lâminas → desce em estocada → volta ao alto | Depois da estocada | Estocada dupla e lâminas em leque |
| Senhor dos Sete Pecados (final) | "Qual estilo você construiu?" | Alterna mini-ciclos dos sete, um por vez, anunciado por cor/sinal | A cada troca de ciclo | Fusão de dois ciclos, sempre avisada |

Regra de ouro: **o jogador sempre sabe o que vem a seguir** depois de ver um ciclo completo. O telégrafo e a pausa dependem de animação feita à parte (ordem de serviço ao Codex/PixelLab), não de efeito desenhado por código.

## 4. Itens, estilos e afinidades

Cada chefe oferece 3 itens (já aprovado). Para a escolha expressar **estilo**, cada trio deve cobrir estilos diferentes. Eixos de estilo (rascunho):

- **Alcance** — luta à distância ou com controle de espaço.
- **Força** — dano alto, corpo a corpo, aceita risco.
- **Técnica** — defesa, contra-ataque, mobilidade, precisão.
- **Exploração** — achar segredos e atalhos (peso menor em luta, mais no mapa).

### Como o item muda a luta
Cada item tem **afinidade** com chefes específicos, em escala de −2 a +2:
- **+2/+1:** o item ajuda de forma natural nesse chefe (ex.: item de alcance contra um chefe que ameaça no corpo a corpo).
- **0:** neutro.
- **−1/−2:** o item deixa a luta mais exigente (ex.: item de força contra um chefe que castiga quem se aproxima).

Nunca é impossível: o efeito é no **tempo para vencer** e no **risco**, não em bloquear.

### Regras de balanceamento (não negociáveis)
1. **Cada item tem pelo menos um chefe de afinidade positiva e um de afinidade negativa.** Nenhum item é neutro em tudo nem bom em tudo.
2. **Soma de afinidades equilibrada:** a soma por item fica em torno de 0 (alvo: −1 a +1). Nenhum item soma bem acima dos irmãos do mesmo trio.
3. **Nenhuma trilha completa (um item por chefe) sai com soma muito acima das demais.** Verificar por simulação/planilha antes de implementar.
4. **Efeito situacional, nunca "+5% genérico"** (regra de `docs/04`).
5. **Faixa de dificuldade-alvo (a calibrar por teste):** a melhor afinidade reduz o tempo de luta em até ~25%; a pior aumenta até ~25%. Nunca fora dessa faixa.
6. **Dica de leitura:** a tela de escolha e o Luke indicam, de forma discreta, para quem cada item é bom (sem entregar a conta completa).

### Validação (T-013)
1. Planilha item × chefe (21 itens × 7 chefes + final) com afinidades e justificativa mecânica de cada célula.
2. Verificação de somas por item e por trilha (script simples, rodado e anexado).
3. Teste jogado pelo dono em ao menos duas trilhas bem diferentes, sentindo "ficou mais fácil/difícil por causa da minha escolha".
4. Ajuste dos números depois do teste. Registrar o resultado em `docs/TESTES.md`.

## 5. Ligação com os poderes automáticos (sugestão, aberta)

Opcional, a decidir: o poder automático de um chefe também pode ser a "fraqueza leve" de outro (ao estilo Mega Man), com efeito pequeno, para dar ordem de exploração. **Não está decidido.** Se adotado, o efeito entra na planilha da seção 4 e respeita as mesmas faixas.

## 6. Primeiro uso prático

O mini-chefe do Portão 1 (T-009) deve ser o **protótipo desse sistema**: ciclo fixo, telégrafo claro, janela de punição e fase 2 simples. O dono testa se o padrão é legível no celular antes de qualquer chefe grande.
