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

## Limite técnico encontrado
O conector do Drive nesta sessão aceita no máximo **~3,1 MB de arquivo por chamada**. Arquivos maiores não foram enviados (nada parcial foi gravado):
- AV-REF-003 `Seiran_Soberba_ficha_conceitual.png` (3,5 MB)
- AV-REF-004 `Senhor_Sete_Pecados_conceito_individual.png` (3,4 MB)
- AV-REF-008 `prancha_visual_enviada_usuario.png` (3,9 MB)
- AV-CON-001 a 004 (conceito B do Senhor dos Sete Pecados, mundo fortaleza, mundo lua carmesim, prancha de direção visual; 3,2 a 3,5 MB)
- `kit.zip` original do ChatGPT (80 MB) para `05_EXPORTACOES_PACOTES`
- Cenário do distrito dos ferreiros gerado no Fenaky (15/11, aprovado pelo dono) para `03_CENARIOS_UI`: o arquivo não chegou ao ambiente da IA (download bloqueado pela rede da sessão).

Rotas possíveis (decisão do dono): enviar esses arquivos manualmente ao Drive; ou autorizar cópia PNG otimizada sem perda (mesmos pixels, bytes e hash diferentes) para caber no limite.

## Estado de sincronização (três estados separados)
| Item | No Drive | No GitHub | Outro agente acessa |
|---|---|---|---|
| 49 arquivos AV-REF/CON/REC listados no manifesto como "ENVIADO" | sim | sim | não verificado |
| 7 PNG grandes + kit.zip | **não** | PNG sim / ZIP não | — |
| Cenário Fenaky | **não** | **não** | — |

Detalhe arquivo a arquivo: `docs/MANIFESTO_ASSETS.md`.
