import sys, random, time; sys.path.insert(0, __file__.rsplit('/',1)[0]); from common import *
CH = "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾓﾔﾕﾖﾗﾘﾙﾚﾜﾝ0123456789ABCDEFZ$#%&+=<>"
def loop():
    grid = {}; drops = {}
    while True:
        W, H = size()
        for x in range(W):
            d = drops.get(x)
            if d is None:
                if random.random() < 0.03: drops[x] = [0, random.randint(4, max(5, H-2)), random.choice([1,1,1,2])]
                continue
            for _ in range(d[2]):
                if d[0] < H: grid[(x, d[0])] = [random.choice(CH), 0]
                d[0] += 1
            if d[0] - d[1] > H: drops[x] = None
        out = []
        for y in range(H):
            row = []
            for x in range(W):
                c = grid.get((x, y))
                if not c: row.append(" "); continue
                a = c[1]; c[1] += 1
                if random.random() < 0.05: c[0] = random.choice(CH)
                if a == 0: row.append("\x1b[1;97m" + c[0])
                elif a < 3: row.append("\x1b[1;92m" + c[0])
                elif a < 10: row.append("\x1b[0;32m" + c[0])
                elif a < 16: row.append("\x1b[38;5;22m" + c[0])
                else: row.append(" "); del grid[(x, y)]
            out.append("".join(row))
        frame(out); time.sleep(0.07)
run(loop)
