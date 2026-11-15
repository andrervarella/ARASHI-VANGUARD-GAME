# Ferramentas de build e teste (Godot 4.4.1, Web)

Ambiente de nuvem sem Godot instalado? Passos que funcionaram em 15/11/2026 (EXECUTADO):

1. Baixar o editor Linux 4.4.1 (GitHub releases do `godotengine/godot`, arquivo `Godot_v4.4.1-stable_linux.x86_64.zip`), descompactar e dar `chmod +x`.
2. Templates de exportação Web **sem baixar 1,2 GB**: `python3 tools/fetch_godot_web_templates.py <URL do Godot_v4.4.1-stable_export_templates.tpz> ~/.local/share/godot/export_templates/4.4.1.stable` (lê só as entradas necessárias por HTTP Range; confira a lista impressa).
3. Importar e exportar: `godot --headless --path godot --import` e depois `godot --headless --path godot --export-release Web build/web/index.html` (preset em `godot/export_presets.cfg`, **sem threads**: não precisa de cabeçalhos COOP/COEP).
4. Conferir o render de verdade (EXECUTADO (EMULADO)): `xvfb-run -a -s "-screen 0 1166x540x24" godot --path godot --rendering-driver opengl3 --resolution 1166x540 --write-movie /tmp/shots/m.png --fixed-fps 30 --quit-after 30` e abrir um quadro PNG. Flag `-- --demo-stick` força o direcional para baixo+direita (só para teste).
5. Publicar o link jogável: copiar `godot/build/web/index.*` + `vercel.json` para a branch `web-build` (só artefatos), `git push`, e criar o deploy de produção no Vercel (conector) apontando o SHA dessa branch. Projeto Vercel: `arashi-vanguard-prototipo`. Último link: https://arashi-vanguard-prototipo.vercel.app

Limites conhecidos: o shell da nuvem não testa toque real em Android; só o dono testa no aparelho.
