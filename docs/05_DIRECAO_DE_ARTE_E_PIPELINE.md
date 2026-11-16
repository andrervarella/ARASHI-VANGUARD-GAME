# Direção de arte e pipeline de assets 2D

## Art direction
Fantasy anime adulto com silhuetas fortes e cores ricas sobre fundos noturnos. Personagens expressivos, anatomia estilizada, contrastes de luz, efeitos desenhados com impacto. Formas detalhadas de *Vampire Hunter* e impacto gestual de *The King of Fighters* apenas como linguagem criativa, sem replicar propriedade intelectual.

### Ren
Base facial inspirada nas fotos reais do proprietário: barba cheia escura, cabelo preto mais comprido, musculatura definida, rosto maduro e forte. Trocar roupa moderna por traje próprio de ação oriental, de tecidos e pouca armadura. Forma transformada: cabelo muito longo e alterado de cor, maior potência corporal, cicatrizes/aura. Priorizar consistência de rosto. As fotos reais não estão liberadas automaticamente para publicação no GitHub público.

### Luke
Visual inspirado nas fotos do filhote: branco com castanho, olhos azuis, orelhas caídas e focinho peludo. Não é um robô. Manter expressões fofas e humor sem transformar o jogo em infantil.

### Chefes
Kairen: jade/bronze/vinho, magérrimo e multi-braços. Xui: obeso e quase careca, decadente e guloso. Wu: monge austero pálido e roxo/cinza. Baku: samurai oni com brutalidade e fogo. Mei Shian, Shuyin e Seiran precisam fichas individuais aprovadas. **Cada um deve ter paleta e silhueta diferentes**. Evitar círculos sagrados repetidos em todos e ornamentação uniforme.

## Pastas e status
- \`assets/referencias-aprovadas/\`: imagens originais congeladas, associadas a ID e metadados. Não editar.
- \`assets/conceitos-em-avaliacao/\`: estudos, colagens, pranchas e versões antigas com status provisório.
- \`assets/turnarounds/\`: frente, 3/4, perfil, costas + escala.
- \`assets/sprites/\`: atlases PNG transparentes, spritesheets/cenas.
- \`assets/tilesets/\`, \`assets/props/\`, \`assets/vfx/\`, \`assets/ui/\`, \`assets/audio/\`: produção.
- \`assets/manifests/\`: ficha em JSON/YAML para cada personagem.

## Pipeline recomendado com PixelLab ou ferramenta equivalente
1. Identificar arte individual canônica e travar a referência, cores e acessórios.
2. Escrever um character sheet padronizado (frente, perfil, costas, 3/4) usando a MESMA referência.
3. Definir resolução-base do sprite conforme câmera do jogo; fazer primeiro 1 personagem de teste, não todos. Testar 96–192 px de altura como referência preliminar; ajustar após experimentar em tela real.
4. Produzir idle (6–8 quadros), corrida (6–10), salto início/meio/fim, ataque leve, pesado, esquiva, hit, morte e transformação. São metas provisórias de frames; movimento deve ser revisado.
5. Limpar backgrounds, alinhar pés/raiz do sprite, padronizar duração e pivôs, conferir artefatos em mãos/armas/barba/cabelo e continuidade entre frames.
6. Separar assets de equipamento que realmente mudam a aparência, com hierarquia de camadas (roupa, corpo, braço frontal, espada, acessórios etc.) para evitar refazer 7 × 3 combinações integralmente.
7. Exportar PNG transparente, nomes estáveis, atlas e JSON do sprite; importar para Godot em cenas isoladas; validar colisor, hitbox, câmera, scale, clipping e animação em 60 fps.
8. Mostrar evidência visual de cada animação ao proprietário e pedir aprovação.

**Atenção:** o acesso do Claude/Codex ao PixelLab depende de sua integração e de custos/limites disponíveis. Verificar antes. Não inferir integração automaticamente. Gerar 10 sprites sem consistência é pior que criar 1 sprite bom.

## Paleta ambiental
Ambientação gótica japonesa com céu azul-petróleo, vermelho de brasa, violeta, jade, ouro queimado e zonas com contraste alto. Evitar "Berserk monocromático" e saturação indiscriminada. Cenários podem ter dia/crepúsculo se fizer sentido, mas identidade sombria predominante.

## Cutscenes
Pinturas 2D multicamadas, aproximações de câmera, parallax, efeitos de chuva/fogo/lua, poses-chave e breves diálogos. Economizar animação tradicional; não usar PNG de pôster como se fosse sprite game-ready.

## Controle de qualidade
Uma ficha aprovada deve conter: ID, versão/data, paleta, nome, altura-proposta, vistas, gestos, arma e alcance, lista de golpes, camada de equipamento, expressão, QA, status de aprovação. Nunca usar texto em imagem como única fonte: geradores erram nomes, legendas e detalhes.

## Novas orientações de produção — 16/11/2026

- Lote de fichas no Drive: `GAMES_IA/ARASHI VANGUARD/01_ASSETS_EM_PRODUCAO/FICHAS_PERSONAGENS_2026-11-16/`, IDs `AV-FIC-001`–`015`; inventário em `docs/12_HANDOFF_FICHAS_PIXELLAB_2026-11-16.md`. O Claude tem a tarefa de realizar sprites no PixelLab e integração/teste no Godot.
- **Inimigos comuns**: o dono **dispensou fichas individuais**. O Claude pode gerar a arte a partir do texto do GDD, respeitando ambientação, região, estilo, silhueta, padrões de ataque e legibilidade. Validar conjuntos de inimigos por fase.
- **Seiran**: falta uma prancha dedicada exclusivamente às poses; gerar animações a partir do original canônico e da ficha de corpo; não reciclar a estética de Kairen/Shuyin.
- Não considerar pôster ou ficha conceitual PNG como spritesheet jogável. Não publicar artes inéditas no repositório público sem informar o dono. **Originais no Drive, runtime otimizado no GitHub (V4.5).**
