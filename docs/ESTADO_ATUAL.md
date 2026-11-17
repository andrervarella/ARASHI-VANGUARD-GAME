# ESTADO ATUAL DO JOGO — ARASHI VANGUARD

> Leitura obrigatória de quem chega. Se divergir do Git, vale o Git.

- Atualizado em: 2026-11-16 (America/Sao_Paulo)
- Fonte de verdade: https://github.com/andrervarella/ARASHI-VANGUARD-GAME
- Branch canônica: `main` (só docs antigos até o dono aprovar o PR) · **Branch de trabalho: `dev`** (tem tudo)
- Link jogável de teste: https://arashi-vanguard-prototipo.vercel.app (**v0.6 · fases 1 e 2**, versão visível na tela-título e na pausa)
- Método: Prompt Mestre Universal **V4.4** (`andrervarella/PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES`)
- Estágio: **demo jogável das fases 1 e 2 (T-015)**, aguardando o dono jogar no celular
- Quem está com a vez: dono (jogar e dar retorno)

## v0.6 (16/11, noite) — Forma Carmesim (T-018, aprovada pelo dono)
- Sprites da Forma Carmesim (cabelo prateado longo, marcas e olhos vermelhos, colete aberto) gerados como estado do mesmo Ren no PixelLab (`36f2ce1b`), 13 animações.
- Na luta contra Xui, ao chegar na metade da vida dele, a Forma Carmesim desperta sozinha (dano maior e mais velocidade até o fim da luta). Depois da vitória, Ren se perde nela; Luke late, o pingente brilha e o traz de volta. A partir daí a Forma Carmesim vira poder equipável (custa o ki cheio, dura 12 s).
- Corrigido: a chuva de comida e os espíritos da fase 2 do Xui não funcionavam (referência quebrada).
- Pôster com o novo chefe final: 2 versões geradas no Fenaky, aguardando escolha do dono (T-019).

## v0.5 (16/11, noite) — T-019a, terceiro retorno do dono (DEC-020)
- Abertura reescrita (maldição, sete pecados, selos em sete regiões, seita das Sete Casas, portões fechados para o sacrifício); legendas só avançam por toque.
- Prólogo jogável novo: Ren foge da cerca dos marcados, Luke (cão de rua com pingente) late e guia, soldado agride o cão e Ren o salva; cena do lenço; Ren abre o portão (sprite do portão aberto) e o povo foge; luta impossível contra a Ira; a luz do pingente repele Baku.
- Câmera mais próxima (zoom 1,2), tela-título inteira no celular, telhado flutuante virou toldo apoiado, esquiva com dois toques em DEFESA, queda do Ren deitada no chão, corrida com 10 quadros.
- Poderes sem trocar a cor da roupa: aura discreta + mão em chamas (Fúria) / contas de jade (Jade).
- Pendentes de aprovação do dono: Forma Carmesim (T-018) e pôster com o novo chefe final (T-019, DEC-021).

## v0.4 (16/11, noite) — T-017, segundo retorno do dono
- Chão das fases corrigido (metade das emendas não aparecia e ficava um vão escuro "pisável"); buracos agora têm borda de penhasco, escuridão e névoa; caixas assentadas no chão.
- Troca de cena protegida contra duplicação (fase/chefe duplicados); arenas menores e enquadradas inteiras na tela; menos chuva de comida e espíritos na luta do Xui.
- Morte de chefe com destruição: câmera lenta, explosões, corpo se desfazendo em brasas e a essência voltando ao selo (vaga para cutscene "fim_<chefe>").
- Combo de 5 golpes (corte, ascendente, estocada, corte rápido, golpe final) com 3 animações novas do Ren; andar enquanto defende.
- Botões ilustrados (PixelLab), direcional dourado, placa do poder com ícone, nome e "toque para trocar".
- Falas do Baku reescritas (mais curtas e marciais). Fundo do refúgio refeito sem pessoas.
- Pendente de decisão do dono: sprites da transformação (Forma Carmesim) — arte final de personagem, pede aprovação.

## v0.3 (16/11, tarde) — T-016, retorno do dono sobre a v0.2
- Câmera mais próxima (zoom 1,0). Botão **DEFESA** com aparo. Caixas, plataformas, blocos, chãos, portais e o Grande Portão com arte do PixelLab; coletáveis e itens com ícones; fogo/vapor/acertos com efeitos do PixelLab (VFX).
- História em escala de mundo (Sete Terras, sete selos, aldeia de Arashi, Refúgio) e falas épicas (DEC-019). 7 quadros novos de história em pixel art; Ren abre o Grande Portão jogando, no fim do tutorial.

## Novo nesta sessão (16/11) — T-015
- Jogo refeito em `godot/src/` com **sprites PixelLab fiéis às fichas (proporção adulta, DEC-017)**; protótipo desenhado por código arquivado em `godot/legacy/` (ignorado pelo Godot) → resolve DEC-010/T-005.
- Fluxo: tela-título (arte oficial) → 3 telas de texto + **storyboard** de imagens (vaga para a cutscene Higgsfield: `res://assets/video/abertura.ogv` toca no lugar se existir) → **Prólogo/tutorial no Distrito dos Ferreiros** (andar, pular, agachar sob a viga, combo, plataformas, salvar o Luke, Baku aparece e vence o Ren) → storyboard "cicatriz" → **Fase 1 Vale das Torii + chefe Baku** → vitória (poder + 1 de 3 itens) → **Vila de Arashi** (hub com Tetsu e 7 portais; só o Palácio de Xui abre) → **Fase 2 Palácio de Xui + chefe Xui** (parede rachada com segredo) → storyboard "dois chefes" + fim da demonstração.
- Poderes estilo Mega Man: **Golpe da Fúria** (Baku; investida que quebra parede) e **Bocarra de Jade** (Xui; engole projéteis e cura). Equipar troca as cores da roupa do Ren (shader) e acende uma aura. Itens: 6 no total, escolhe 1 de 3 por chefe; salvam em `user://`.
- HUD aprovado (v7) mantido + botão **PODER** em arco acima de ATACAR/PULAR (some sem poderes), retrato e barras estilo jogo de luta, barra do chefe, pausa.
- Cenários: 4 fundos PixelLab (`assets/bg`). Inimigos novos: Guarda das Sete Famílias, Oni de Brasa, Servo do Banquete, Espírito do Incenso; NPC mestre Tetsu. Créditos: `godot/assets/CREDITOS.md`.
- Som: SFX do Oculus Audio Pack 1 (CC BY 4.0, crédito na tela). Músicas (título, fase, chefe, vila) feitas no PixelLab; no link Web são baixadas no build do Vercel por variável secreta `MUSIC_URLS` (DEC-018).

## Implementado e confirmado
- Kit visual v1 (59 arquivos + prancha oficial do Ren) importado e verificado por script: `assets/`, `docs/09_AUDITORIA_KIT_v1.md` (EXECUTADO).
- Ajustes narrativos aprovados: `docs/02` e DEC-005.
- Protótipo Godot 4.4.1 Web (v7), `godot/`: andar, pular, agachar/andar agachado, atacar, Luke seguidor, 4 bonecos de treino, túnel baixo, controles de toque (direcional único deslizante + PULAR/ATACAR). Render conferido em Xvfb (EXECUTADO (EMULADO)); **dono jogou e aprovou a dinâmica** em 15/11.
- Documentos de controle do método criados (este arquivo, DECISOES, TAREFAS, HANDOFF, TESTES, APRENDIZADOS, MANIFESTO_ASSETS) e `docs/CONTROLES_E_CONVENCOES.md`.

## Em andamento
- T-003 (Portão V): GDD v0 pronto; cenário do distrito dos ferreiros gerado no Fenaky e aprovado pelo dono ("gostei"). Tela de título com o Ren foi **recusada pelo Fenaky** (rosto realista); próximo passo: dono gera fichas e telas do Ren no ChatGPT e envia.
- T-014 (acervo V4.4): 56 arquivos no Drive (7 como cópia sem perda); `kit.zip` redundante; cenário do Fenaky **pendente** (dono baixa e envia). Ver `docs/ACERVO_DRIVE.md`.

## Pendente / bloqueado
- Lote-piloto de animação do Ren (T-004): PixelLab conectado (avaliação de 40 gerações, nada gasto); aguarda ficha limpa do Ren (ChatGPT) e o "ok" do dono. Plano de ferramentas e custos: `docs/11_PLANO_DE_PRODUCAO_E_CUSTOS.md`.
- Personagens desenhados por código violam o método (DEC-010): substituir antes do Portão 1 (T-005).
- Sem menu, introdução, testes automáticos nem GitHub Actions (T-006, T-007).
- Botão de magia/poder e combos: pedidos do dono, sem especificação (T-008).
- Chefes com padrão fixo (estilo Mega Man) e itens que mudam a dificuldade sem combinação melhor: princípios aprovados (DEC-013), rascunho em `docs/10_CHEFES_E_BALANCEAMENTO.md`, especificação e planilha em T-013.
- Regra do dono (DEC-012): consultar e seguir o método geral (`PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES`) antes de criar.
- Sem revisão independente de T-001 e T-002.

## Testes recentes
- 2026-11-15, `88b1634`: headless sem erros; render Xvfb OK; dono aprovou no celular. FPS/carga/áudio NÃO TESTADOS. Detalhes em `docs/TESTES.md`.

## Próxima ação objetiva (16/11)
- Dono: jogar o link v0.2 no celular e dizer o que ajustar (dificuldade, tamanho dos personagens, controles, textos).
- IA: corrigir pelo retorno; cutscenes Higgsfield quando o dono assinar; vozes depois (ElevenLabs).

## Próxima ação objetiva (anterior, 15/11)
- Dono: baixar o cenário do Fenaky e enviar ao Drive (`03_CENARIOS_UI`); gerar no ChatGPT a ficha (frente/lado/costas) do Ren e mandar. IA: conferir a ficha, registrar no Drive (`01`) e no manifesto, e então propor o Ren piloto no PixelLab (custo antes).

## Atenção
Este arquivo não comprova conclusão sozinho. Fotos do dono e de Luke não entram no repositório público.
