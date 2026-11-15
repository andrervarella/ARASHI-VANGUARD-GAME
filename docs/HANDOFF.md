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

## Decisões para aprovação
- DEC-001 (push na `dev`), DEC-010 (manter ou trocar a arte provisória), merge do PR na `main` no Portão V.

## Próxima ação exata para o próximo agente
- Ler `docs/PROMPT_FABLE_JOGO_COMPLETO.md`; abrir T-003 (Portão V). Critério: o dono responde "sim" às 3 perguntas do Portão V.

## Sincronização
- [x] Mudanças enviadas ao repositório remoto (`dev`)
- [ ] Incorporadas à branch canônica (aguarda o dono)
- [ ] `ESTADO_ATUAL.md` reflete a branch canônica (reflete `dev`)
