#!/usr/bin/env python3
"""Extrai quadros de uma prévia do pixelart_workbench (PixelLab) e gera PNGs transparentes.

A prévia do workbench vem em grade: cada célula tem uma faixa de título de 18 px
e o quadro em seguida, sobre fundo cinza-azulado (31,37,44). O script recorta cada
quadro, troca o fundo por transparência e corta todos com a MESMA caixa (pés alinhados).

Uso: extrair_quadros.py <previa.png> <largura_quadro> <altura_quadro> <n_quadros> <saida_dir> [prefixo]
"""
import os
import sys

from PIL import Image

BG = (31, 37, 44)
HEADER = 18


def main() -> None:
    src, fw, fh, n, out = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]), sys.argv[5]
    prefix = sys.argv[6] if len(sys.argv) > 6 else "f"
    im = Image.open(src).convert("RGBA")
    cols = im.width // fw
    cell_h = fh + HEADER
    frames = []
    for i in range(n):
        c, r = i % cols, i // cols
        box = (c * fw, r * cell_h + HEADER, c * fw + fw, r * cell_h + HEADER + fh)
        fr = im.crop(box)
        px = fr.load()
        for y in range(fr.height):
            for x in range(fr.width):
                if px[x, y][:3] == BG:
                    px[x, y] = (0, 0, 0, 0)
        frames.append(fr)
    # caixa comum a todos os quadros (mantém o alinhamento entre eles)
    bbox = None
    for fr in frames:
        b = fr.getbbox()
        if b is None:
            continue
        bbox = b if bbox is None else (min(bbox[0], b[0]), min(bbox[1], b[1]), max(bbox[2], b[2]), max(bbox[3], b[3]))
    os.makedirs(out, exist_ok=True)
    # Quadro inteiro (mesma tela em todas as animações = mesmo ponto de apoio dos pés).
    for i, fr in enumerate(frames):
        fr.save(os.path.join(out, f"{prefix}{i:02d}.png"))
    print(f"{n} quadros {fw}x{fh}; conteúdo ocupa {bbox}")


if __name__ == "__main__":
    main()
