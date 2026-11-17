# Controles, convenções de gênero e mecânicas aprovadas

Aprovado pelo dono em 15/11/2026 (jogou o link no celular). Qualquer IA que mexer em controle ou HUD deve **ler isto antes** e seguir as convenções dos jogos de plataforma/ação 2D. Fugir do padrão exige aviso ao dono antes (motivo, 2 opções, recomendação).

## Regras do dono para controles de toque
1. Jogo em **paisagem**; o dono joga com os **polegares nos cantos inferiores** e quer o **centro da tela limpo**.
2. Controles **pequenos**, translúcidos e **com acabamento/arte** (não círculos crus). Hoje: laca vermelha, fio dourado, ícones simples; **arte final de HUD ainda a produzir** (T-012).
3. **Convenção de gênero primeiro:** ex. no direcional, "baixo" fica **abaixo**; nunca inventar disposição.
4. Deixar **folga de ~104 px à direita**: o navegador do celular desenha o botão de sair da tela cheia no canto inferior direito e o toque nele minimiza o jogo.
5. Alvo de toque mínimo de 48 dp (método) — conferir no aparelho a cada mudança.

## Esquema aprovado (versão 7 do protótipo, commit `88b1634` na branch de trabalho)
| Controle | Onde | Comportamento |
|---|---|---|
| **Direcional único deslizante** (raio 68) | canto inferior esquerdo | ◀ ▶ andam; ▼ agacha; **diagonal ▼+◀/▶ anda agachado**. O polegar desliza; continua valendo se sair do círculo. Zona morta 30%. Setas acendem e uma bolinha mostra o polegar. |
| **PULAR** (raio 46) | canto inferior direito, mais alto | pulo variável (soltar corta o pulo); coyote 0,1 s; buffer 0,12 s |
| **ATACAR** (raio 40) | à esquerda do PULAR | golpe de katana (0,34 s; acerta entre 0,08 e 0,22 s) |
| Teclado (teste no PC) | — | A/D ou setas; S/↓ agachar; espaço/W/↑ pular; J/X atacar |

Resolução-base 960×540, `stretch=canvas_items`, `aspect=expand` (a tela larga do celular ganha largura extra; o HUD usa o tamanho real do viewport e se ancora nos cantos). Câmera com zoom 1,3, personagem a ~70% da altura.

## Mecânicas aprovadas
- **Agachar:** altura de colisão 84→50 px; velocidade a 45%; **não pula agachado**; só levanta se houver espaço livre acima (teste de colisão); ataque agachado usa hitbox baixa. Fase de teste tem um **túnel baixo** (“Agache para passar”) e plataformas baixas passáveis agachado. Serve de base para passagens estreitas, esquiva e exploração.
- Corrida, pulo, queda, ataque, agachar, câmera suave com limites, Luke seguindo (provisório).

## Pedidos do dono ainda NÃO especificados nem implementados
- **Botão de magia/poder:** Ren terá poder sobrenatural (ligado à Ruptura, ver `docs/04`). O dono quer um botão para isso. Falta decidir disposição: três botões sob o polegar direito (pular, atacar, magia) respeitando a regra do centro limpo e da folga de 104 px. Convenção comum: arco de botões sob o polegar, ataque maior e mais fácil de achar. **Proposta, não decisão:** magia acima/à esquerda do ATACAR em arco; segurar para carregar.
- **Combos:** o dono quer trabalhar combos no personagem. Ideias a avaliar (propostas): sequência de toques em ATACAR (3 golpes), ATACAR + direção (▼ = golpe baixo, ▲/diagonal = golpe ascendente), segurar ATACAR = golpe forte, golpes no ar, cancelamentos para o poder. Precisa de janela de entrada, buffer, feedback (hit-stop, tremor) e hitboxes por golpe. **Especificar antes de implementar** (T-008).
- Esquiva, bloqueio/parry, interação, pausa e mapa: listados em `docs/04`, sem controle definido.

## Lista de conferência antes de entregar controle/HUD
1. Segui a convenção do gênero? 2. Centro limpo? 3. Folga à direita de 104 px? 4. Renderizei e **olhei** a imagem (EXECUTADO (EMULADO))? 5. Avisei que toque real só o dono testa?

## Atualização 16/11/2026 (v0.3)
- Câmera com **zoom 1,0** (personagem ~29% da altura), pedido do dono ("visão mais próxima").
- **DEFESA** (raio 34) à esquerda e acima de ATACAR, em arco com PODER: segurar = bloquear de frente (gasta 10 de poder; 20 contra ondas no chão); apertar no instante do golpe (0,2 s) = **aparo**: sem custo, +15 de poder, inimigo vacila (chefe fica ofegante). Sem poder suficiente: guarda quebra e o dano cai pela metade. Teclado: L/V.

## Golpes (v0.13)
- Toques em ATAQUE: combo de 5. **Cima + ATAQUE:** corte anti-aéreo. **Baixo + ATAQUE:** rasteira (derruba inimigos comuns).
- **Segurar ATAQUE** depois de um corte: carrega (brilho dourado = nível 1; vermelho = nível 2). Soltar = golpe carregado; nível 2 solta a onda do Corte da Tempestade. Teclado: I = cima.
- Diálogos: PULAR ▶▶ no canto pula a conversa.

## Chute e combos (v0.14)
- Botão CHUTE (pé) à esquerda da ESPADA. Teclado U ou Z; controle B. Defesa no controle: RB ou RT.
- 3 chutes seguidos: alto, giratório, voadora. No ar: voadora.
- Espada-chute-espada: Lâmina Giratória · espada-espada-chute: Chute Ascendente · chute-chute-espada: Investida do Ferreiro · chute-espada-chute: Pisão do Trovão.
