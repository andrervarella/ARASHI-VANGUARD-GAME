# ACERVO NO GOOGLE DRIVE — ARASHI VANGUARD

Regra do método V4.4 (`modulos/ACERVO_DRIVE_GITHUB.md`, DEC-014). Drive = acervo mestre de arte e arquivos grandes. GitHub = código, projeto Godot, documentação, manifestos e assets finais que o jogo precisa para rodar.

## Caminho lógico
```
Meu Drive/GAMES_IA/ARASHI VANGUARD/
  00_REFERENCIAS_APROVADAS/      originais intocados (AV-REF-xxx)
  01_ASSETS_EM_PRODUCAO/
    conceitos_em_avaliacao/      conceitos ainda não aprovados (AV-CON-xxx)
    recortes_referencia/         recortes do kit v1, não são sprites (AV-REC-xxx)
  02_SPRITES_ANIMACOES/          (vazio)
  03_CENARIOS_UI/                (vazio)
  04_AUDIO_VIDEO/                (vazio)
  05_EXPORTACOES_PACOTES/        (vazio)
```
- Dono e responsável: o proprietário do projeto (conta pessoal). Link da pasta: **não publicado aqui** (repositório público). Quem precisa recebe o link pelo dono.
- Nomes: `ID_nomeoriginal_vN[_data-aprovação].png`. O conteúdo é byte a byte igual ao do GitHub (mesmo tamanho; SHA-256 no manifesto). Nada foi sobrescrito nem editado.

## Permissões verificadas (2026-11-15, Claude, conector Google Drive)
| Verificação | Resultado |
|---|---|
| Ler metadados e listar a pasta e as 6 subpastas | EXECUTADO: OK |
| Criar arquivo e subpasta | EXECUTADO: OK (49 arquivos e 2 subpastas criados) |
| Renomear arquivo criado pelo agente | EXECUTADO: OK (1 renomeação, AV-REF-010) |
| Baixar conteúdo de arquivo | NÃO TESTADO |
| Compartilhamento | Pasta privada, só o dono. **Não alterado.** |
| Acesso do Codex/ChatGPT a esta pasta | NÃO VERIFICADO |

## Limite técnico encontrado e como foi resolvido
O conector do Drive aceita no máximo **~3,1 MB de arquivo por chamada** e não tem envio em partes para um mesmo arquivo (partes soltas no Drive não abrem como imagem). Solução aplicada a pedido do dono (15/11, 22:44):
- AV-CON-002, 003 e 004: PNG recomprimido sem perda (mesmos pixels).
- AV-REF-003, 004, 008 e AV-CON-001: WebP sem perda (mesmos pixels; o PNG recomprimido ainda passava de 3,1 MB).
- Pixels conferidos por script (RGBA idêntico ao original). O hash muda; os dois hashes estão no manifesto. **O original byte a byte continua no GitHub.** Se o dono quiser o PNG original também no Drive, basta enviá-lo manualmente.
- `kit.zip` (80 MB): **não enviado de propósito**. Conferido por hash: os 61 arquivos dele já estão no GitHub e no Drive individualmente; partes de ZIP no Drive só serviriam para remontar no computador.
- Cenário do distrito dos ferreiros (Fenaky, aprovado): **pendente**; o arquivo não chegou ao ambiente da IA (download bloqueado pela rede da sessão). O dono precisa baixar pelo link do Fenaky (expira em 16/11 ~19h50) e enviar.

## Estado de sincronização (três estados separados)
| Item | No Drive | No GitHub | Outro agente acessa |
|---|---|---|---|
| 56 arquivos AV-REF/CON/REC (7 como cópia sem perda) | sim | sim | não verificado |
| kit.zip | não (redundante) | não (conteúdo já está) | — |
| Cenário Fenaky | **não** | **não** | — |

Detalhe arquivo a arquivo: `docs/MANIFESTO_ASSETS.md`.
