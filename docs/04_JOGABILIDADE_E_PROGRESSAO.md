# Sistema de jogo, golpes e progressão

## Movimento e combate
Ação lateral 2D com corrida, salto, queda, ataque leve, ataque forte/seqüência, esquiva, bloqueio ou parry, habilidade especial e interação. O protagonista é atlético e rápido, com espada, golpes corpo a corpo e habilidades sobrenaturais. Combos curtos e responsivos inspirados na expressividade de jogos de luta, sem exigir controles de torneio. Bosses com telegráficos claros, ataques únicos e segunda fase.

## Aprendizado do protagonista
No prólogo, Ren domina apenas técnicas simples porque treinou por conta própria. Treino, observação, equipamentos, desafios e derrotas formam sua evolução. O sobrenatural amplia o que ele aprendeu; não resolve tudo sozinho. A árvore pode separar técnica de espada, defesa/evasão, movimentação e energia espiritual. Não transformar o sistema num RPG inflado.

## Recompensas de chefes — diferencial aprovado
Após derrotar qualquer um dos **7 guardiões**:
1. Ren recebe o **poder principal** daquele guardião automaticamente e para sempre.
2. A tela exibe **exatamente três equipamentos exclusivos** do chefe com efeitos e estética diferentes; o jogador escolhe **um único item** por campanha. É uma decisão irreversível após confirmação e os outros dois desaparecem.
3. Surge uma nova cicatriz/marca visível; algumas interagem com a transformação.
4. O equipamento escolhido pode ser equipado/removido depois. O benefício é situacional, não mero "+5%" genérico. As escolhas devem mudar estilos (mobilidade, defesa, combos, exploração).
5. Poderes imprescindíveis à travessia são automáticos; a escolha de item não pode bloquear áreas obrigatórias ou final.

Sugestão de interface: tela pós-chefe com poder recebido, três cartas de relíquias, prévia de efeitos e alteração visual em Ren, botão "Confirmar escolha" e aviso "Esta decisão será permanente nesta campanha".

## Transformação
Medidor de **Ruptura** carregado por combate preciso, defesa, esquivas e risco. Vida baixa pode acelerar carga, mas nunca deve ser a única condição. Quando ativada, Ren ganha físico mais forte, cabelo muito mais longo e outra cor, marcas luminosas e novas animações de ataque. Duração limitada, custo de energia, vulnerabilidade estratégica ao terminar. Versão inicial pode ser involuntária; depois, controlável. Nome visual "Vínculo do Dragão" foi usado em conceito e ainda precisa de confirmação como termo canônico.

## Cicatrizes
Guardar estado permanente por boss vencido; desenhar marcas de modo cumulativo nas artes/quadros. Isso vale também para retratos do HUD e cutscenes. Gerenciar via camadas de roupa/corpo quando tecnicamente viável, com combinações revisadas manualmente.

## Exploração
Mapa 2D conectado; pontos de salvamento/descanso; paredes quebráveis, portas seladas, plataformas altas, alavancas, sinos e pontes. Poderes destravam atalhos e caminhos, como golpe de ruptura de Baku, reflexão/ilusão de Mei Shian, habilidade de mobilidade de Seiran. Pedir prova de travessia para cada poder para evitar recompensas cosméticas sem uso.

## Luke
Mascote segue Ren ou aparece em seções seguras; fareja passagens e objetos, alerta sobre perigo, proporciona alívio cômico em pequenas animações, sem virar suporte de ataque dominante. Regras de IA simples e robustas são preferíveis a simulação complexa.

## Estrutura de boss
Entrada/cutscene breve; primeira fase com 2–4 ataques e padrões legíveis; transição visual; segunda fase que recombina padrões; vitória e escolha; mudança do mundo/efeitos narrativos. Explorar os temas dos pecados sem torná-los cópias mecânicas.

## HUD prototípico
Vida, energia espiritual/Ruptura, itens rápidos, habilidade equipada, mapa compacto opcional. Identidade visual em metal envelhecido/tinta vermelha, mas legível. Controles para teclado/gamepad e eventualmente touch só se aprovado.

## Save system
Salvar progresso das fases, poderes automáticos, cicatrizes, escolhas únicas por boss, itens equipados, pontos ativados e flags narrativas. Testes contra duplicação de prêmio e save quebrado. Criar caminho para NG+ futuramente, mas não implementar sem necessidade.

## Primeiro protótipo
Um pequeno trecho do distrito/forja, movimentação, Luke simples, dois tipos de inimigo, mini-chefe, habilidade/power-up, tela de 3 recompensas com persistência e 1 sala secreta que exija técnica. Só depois ampliar.

## Atualização 15/11/2026 — controles de toque aprovados
O jogo é jogado no celular (paisagem). Controles de toque **aprovados** e a mecânica de **agachar/andar agachado** estão em `docs/CONTROLES_E_CONVENCOES.md`. Pedidos do dono ainda a especificar: **botão de magia/poder** (ligado à Ruptura e às habilidades de chefes) e **combos** do Ren (T-008 em `docs/TAREFAS.md`).

