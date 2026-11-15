# APRENDIZADOS (viram skills com o "ok" do dono)

Cada linha: o que deu trabalho → o jeito certo.

1. **Ler o método antes de começar.** O protótipo foi feito sem ler `PROMPT-MESTRE-CRIACAO-DE-GAMES-GAMES`; gerou desvios (personagem por código, sem documentos de controle, sem menu/história). → Abrir o jogo lendo `docs/ESTADO_ATUAL.md`, `AGENTS.md` e o método **antes** de qualquer código.
2. **Convenção do gênero primeiro.** Pôr "baixo" acima das setas gerou retrabalho. → Antes de desenhar controle ou HUD, listar o que os jogos do gênero fazem e só fugir com aviso (`docs/CONTROLES_E_CONVENCOES.md`).
3. **Olhar o render, não só compilar.** v2 passou no "compila" e os botões estavam fora da tela (layout usava o `size` do Control, que vinha zerado; o certo é `get_viewport_rect().size`). → Renderizar com Xvfb e abrir o PNG a cada mudança de UI.
4. **Botão do navegador no canto inferior direito.** O Chrome mobile desenha o botão de sair da tela cheia ali; encostar o PULAR nele minimiza o jogo. → Folga de ~104 px à direita.
5. **Andar agachado.** Botões separados exigem dois toques. → Direcional único deslizante com diagonal.
6. **Rede e ferramentas.** Templates Web do Godot são 1,2 GB; leitura por HTTP Range pega só ~20 MB. → `tools/fetch_godot_web_templates.py`.
7. **Publicar sem arquivos grandes por MCP.** O wasm (~43 MB) não cabe em chamada de MCP. → Branch `web-build` só de artefatos + deploy no Vercel apontando o SHA.
8. **Texto no jogo.** A fonte padrão do Godot não tem a seta "→"; apareceu quadrado. → Evitar glifos especiais ou embarcar fonte.
9. **Comandos de limpeza.** `rm -rf` com glob foi bloqueado pelo ambiente. → Não limpar pastas de build; o export sobrescreve.
