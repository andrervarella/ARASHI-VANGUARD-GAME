import subprocess, sys, zipfile, io, os, re
URL, outdir = sys.argv[1], sys.argv[2]
final = subprocess.check_output(['curl','-sSL','-o','/dev/null','-w','%{url_effective}','-r','0-0',URL], text=True).strip()
hdr = subprocess.check_output(['curl','-sS','-r','0-0','-D','-','-o','/dev/null',final], text=True)
total = int(re.search(r'content-range:\s*bytes 0-0/(\d+)', hdr, re.I).group(1))
print('tamanho do .tpz:', total)
class RF(io.RawIOBase):
    def __init__(s): s.pos=0; s.cache_start=0; s.cache=b''
    def readable(s): return True
    def seekable(s): return True
    def tell(s): return s.pos
    def seek(s, off, wh=0):
        s.pos = off if wh==0 else (s.pos+off if wh==1 else total+off); return s.pos
    def _fetch(s, start, n):
        end = min(total-1, start+n-1)
        return subprocess.check_output(['curl','-sS','-r',f'{start}-{end}',final])
    def readinto(s, b):
        n = len(b)
        if n==0 or s.pos>=total: return 0
        if not (s.cache_start <= s.pos < s.cache_start+len(s.cache)):
            s.cache_start = s.pos; s.cache = s._fetch(s.pos, max(n, 4*1024*1024))
        off = s.pos - s.cache_start
        chunk = s.cache[off:off+n]
        b[:len(chunk)] = chunk; s.pos += len(chunk); return len(chunk)
z = zipfile.ZipFile(io.BufferedReader(RF(), buffer_size=1024*1024))
names = z.namelist()
print([n for n in names if 'web' in n or 'version' in n])
os.makedirs(outdir, exist_ok=True)
for n in names:
    base = os.path.basename(n)
    if base in ('web_nothreads_release.zip','web_nothreads_debug.zip','version.txt'):
        data = z.read(n); open(os.path.join(outdir, base),'wb').write(data); print('ok', base, len(data))
