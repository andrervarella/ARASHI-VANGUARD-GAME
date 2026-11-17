#!/usr/bin/env python3
"""Monta animações do jogo a partir das prévias do workbench do PixelLab.
Gera godot/assets/sprites/<personagem>/<anim>_NN.png e <personagem>.json com
quadros, fps, loop e ponto de apoio (pés) de cada animação.
Uso: montar_anim.py <spec.json>
spec: {"personagem": "ren", "anims": {"run": {"src": "...png", "fw":224, "fh":224, "n":8,
        "use":[0,1,...], "fps":12, "loop":true, "rest":0}}}
"""
import json, os, sys
from PIL import Image
BG=(31,37,44); HEADER=18

def frames_of(src, fw, fh, n, sc=1):
    im=Image.open(src).convert('RGBA'); W,H=fw*sc,fh*sc; cols=im.width//W; out=[]
    for i in range(n):
        c,r=i%cols,i//cols
        fr=im.crop((c*W, r*(H+HEADER)+HEADER, c*W+W, r*(H+HEADER)+HEADER+H))
        if sc>1: fr=fr.resize((fw,fh),Image.NEAREST)
        px=fr.load()
        for y in range(fr.height):
            for x in range(fr.width):
                if px[x,y][:3]==BG: px[x,y]=(0,0,0,0)
        out.append(fr)
    return out

def anchor(fr):
    b=fr.getbbox(); px=fr.load(); top=b[1]; lim=top+int((b[3]-b[1])*0.4); xs=[]
    for y in range(top,lim):
        for x in range(b[0],b[2]):
            if px[x,y][3]>0: xs.append(x)
    return (sum(xs)/len(xs), b[3])

spec=json.load(open(sys.argv[1])); name=spec['personagem']
R=os.path.join(os.path.dirname(__file__),'..','godot','assets','sprites',name); os.makedirs(R,exist_ok=True)
jp=os.path.join(R,name+'.json')
meta=json.load(open(jp)) if os.path.exists(jp) else {}
for an,a in spec['anims'].items():
    frs=frames_of(a['src'],a['fw'],a['fh'],a['n'],a.get('scale',1))
    for old,new in a.get('recolor',{}).items():
        o=tuple(int(old[i:i+2],16) for i in (1,3,5)); nw=tuple(int(new[i:i+2],16) for i in (1,3,5))
        for fr in frs:
            px=fr.load()
            for y in range(fr.height):
                for x in range(fr.width):
                    q=px[x,y]
                    if q[3] and abs(q[0]-o[0])+abs(q[1]-o[1])+abs(q[2]-o[2])<90: px[x,y]=nw+(255,)
    use=a.get('use',list(range(a['n'])))
    ax,ay=anchor(frs[a.get('rest',use[0])])
    files=[]
    for k,i in enumerate(use):
        fn=f"{an}_{k:02d}.png"; frs[i].save(os.path.join(R,fn)); files.append(fn)
    meta[an]={'frames':files,'fps':a.get('fps',10),'loop':a.get('loop',True),'anchor':[round(ax,1),ay],'size':[a['fw'],a['fh']]}
    print(an,len(files),'anchor',(round(ax,1),ay))
json.dump(meta,open(os.path.join(R,name+'.json'),'w'),indent=1)
