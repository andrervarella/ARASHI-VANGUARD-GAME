# Plano de produção incremental (Godot + Claude/Codex)

## Etapa 0 — Preparação
- Confirmar acesso do Claude/Codex ao repo GitHub e ferramentas de assets.
- Importar **somente as referências visuais aprovadas** no diretório designado e revisar nomes.
- Selecionar 1 versão aprovada de Ren e Luke, e uma de Kairen/Xui/Baku/Wu.
- Determinar uma resolução de referência e desenvolver sprite 2D piloto para Ren antes de escalar.
- Verificar termos de uso, custo e limites da ferramenta de sprites (PixelLab etc.).

## Etapa 1 — Vertical slice 10–15 min
- Godot 4.x; projeto 2D com controle lateral, física, câmera e inputs.
- Ren placeholder animável com idle, corrida, salto, dois ataques e esquiva.
- Teste do movimento de Luke (seguir, parar, farejar e retornar).
- Uma microárea do distrito da forja + portão/ruínas + inimigos básicos.
- 1 boss protótipo e fase 2; tela de vitória com poder e 3 itens, salvar escolha definitiva.
- Ponto de descanso e uma área secreta acessada por técnica nova.
- Tela de início PRESS START, pausa, HUD, save básico.
- Build jogável e vídeo curto real do jogo; não apenas artes de apresentação.

## Etapa 2 — Prova de identidade
- Finalizar turnaround e sprite consistente de Ren, incluindo barba e forma transformada.
- Finalizar sprites de Luke e comportamento cômico/ajuda discreta.
- Aprovar artes individuais de Mei Shian, Shuyin e Seiran; congelar designs por versão.
- Testar personagem em 2–3 fundos e medir legibilidade/hitboxes.
- Produzir 1 cutscene 2D de 8–12 s para validar pipeline.

## Etapa 3 — Progresso completo
- Expandir para sete regiões/guardiões e chefe final, respeitando ordem narrativamente flexível.
- Implementar recompensas próprias de cada chefe e travessias associadas.
- Itens únicos visíveis em Ren conforme equipados.
- Cicatrizes progressivas, transformação controlável e balanceamento.
- Mapas, inimigos comuns, puzzles, segredos e NPCs.

## Etapa 4 — Polimento
- Revisão de dificuldade, save/load, bugs, menus, áudio original/licenciado, acessibilidade, gamepad e performance.
- Build exportada para plataforma alvo a decidir.
- Teste completo por jogadores, ajustes e eventual lançamento.

## Critérios de aceite do vertical slice
1. Executa sem erros graves no alvo definido.
2. Movimento e ataque respondem aos comandos.
3. Ren permanece reconhecível em todos os sprites.
4. Luke não trava a navegação.
5. Boss é vencível e possui padrões legíveis.
6. O jogo entrega um poder; a escolha de 1/3 itens persiste após carregar.
7. Itens não selecionados ficam indisponíveis naquela campanha.
8. A cena secreta só fica acessível após a habilidade certa.
9. O jogador compreende o prólogo sem grandes blocos de texto.
10. Capturas reais e logs de teste acompanham a entrega.

## Gestão entre IAs
O repositório é a fonte comum. Claude pode implementar sprites/arquitetura; Codex pode revisar, testar e refatorar. Cada agente abre alterações pequenas (commit/PR), inclui resumo e não substitui arte aprovada sem autorização.

## Questões ainda abertas
Versão específica do Godot, controle prioritário mobile/PC, resolução, formato de animação, engine auxiliar de arte, trilha, orçamento, duração final, monetização, distribuição e ordem completa das fases.