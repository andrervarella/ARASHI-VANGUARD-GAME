# HANDOFF — TRANSFERÊNCIA ENTRE IAS / SESSÕES

- Data e agente: 2026-11-15 / Claude (Sonnet 5.5), sessão de nuvem
- Repositório e branch de trabalho: https://github.com/andrervarella/ARASHI-VANGUARD-GAME · `dev`
- Commit inicial conferido: `1b370ae` (main)
- Commit-base (antes desta atualização): `e7ab5de`
- Último commit publicado: ver `git log -1` de `dev` (publicado ao final desta sessão)
- PR e situação: PR `dev` → `main` aberto para o "ok" do dono (merge só nos portões)
- Branches antigas (conteúdo já dentro de `dev`, não apagar): `import/kit-assets-v1-2026-11-15`, `story/ganchos-narrativos-2026-11-15`. Branch de artefatos para o link: `web-build`.

## Pedido atendido
- Importar e auditar o kit, montar protótipo jogável de dinâmica para celular, ajustar controles, registrar tudo conforme o método e preparar a passagem para uma sessão do Fable.

## Alterações verificadas
- `assets/` (kit v1 + prancha oficial do Ren), `docs/02` e `docs/07` (história), `docs/09` (auditoria), `godot/` (protótipo v7), `tools/`, e os documentos de controle listados em `docs/ESTADO_ATUAL.md`.

## Testes reais
- Ver `docs/TESTES.md`. EXECUTADO: headless e render Xvfb. NÃO TESTADO por IA: toque multitoque, FPS, carga, áudio.

## Pendências e riscos
- Desvio DEC-010 (personagem por código). Cores do Luke erradas no protótipo.
- PixelLab: conector precisa reconectar; custo desconhecido; nenhum crédito gasto.
- wasm de ~43 MB: carga lenta em 4G (não medida).
- O link Vercel pertence ao projeto `arashi-vanguard-prototipo` na conta do dono; reautorizar o acesso da equipe quando o conector pedir.

## Direção nova do dono (15/11, 18:36)
- DEC-012: consultar e seguir o método geral antes de criar. DEC-013: chefes com padrão fixo e itens que mudam a luta, sem combinação melhor (`docs/10`, T-013). Padrões por chefe e números são rascunho a validar.

## Sessão 15/11 noite (Claude Opus) — acervo V4.4
- Drive verificado (ler, listar, criar, renomear). 49 arquivos enviados e conferidos; pendentes por limite de 3,1 MB por chamada: AV-REF-003/004/008, AV-CON-001..004, `kit.zip`; cenário Fenaky não chegou ao ambiente. Detalhes: `docs/ACERVO_DRIVE.md`, `docs/MANIFESTO_ASSETS.md`.
- Ferramentas: Fenaky recusa o Ren como referência (rosto realista); ChatGPT vai fazer fichas e telas com o Ren; PixelLab transforma as fichas em sprites; Higgsfield fora por custo; cutscenes CGI podem vir do Google Flow; músicas do Suno (só as feitas em plano pago) podem entrar no jogo. Plano: `docs/11`.

## Decisões para aprovação
- DEC-001 (push na `dev`), DEC-010 (manter ou trocar a arte provisória), merge do PR na `main` no Portão V.

## Próxima ação exata para o próximo agente
- Ler `docs/PROMPT_FABLE_JOGO_COMPLETO.md`; abrir T-003 (Portão V). Critério: o dono responde "sim" às 3 perguntas do Portão V.

## Sincronização
- [x] Mudanças enviadas ao repositório remoto (`dev`)
- [ ] Incorporadas à branch canônica (aguarda o dono)
- [ ] `ESTADO_ATUAL.md` reflete a branch canônica (reflete `dev`)

## Sessão 16/11 (Claude Opus) — T-015 fases 1 e 2
- Código novo em `godot/src/` (autoload `Game`, `level.gd` lê `levels.gd`; chefes `boss_baku.gd`/`boss_xui.gd`; `story.gd` lê `stories.gd`). Teste rápido: `godot --path godot -- --go level torii --x 6900 --nodlg --auto --power furia --shots /tmp/s 60,400`.
- Sprites: pipeline DEC-017 + `tools/montar_anim.py` (aceita `scale`, `recolor`, e acrescenta animações ao JSON existente).
- Publicação: branch `web-build` (artefatos + `vercel.json` + `baixar_musica.sh`); projeto Vercel com build `sh baixar_musica.sh` e saída `dist` (DEC-018).
- Riscos: toque real, FPS e áudio no celular não testados pela IA; dificuldade não calibrada com jogador humano; cutscenes ainda são storyboards.
