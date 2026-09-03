import sys, random, time, math; sys.path.insert(0, __file__.rsplit('/',1)[0]); from common import *
def loop():
    a = 0.0; blips = []
    while True:
        W, H = size(); R = max(3, min(H - 2, (W - 2) // 2) // 2 * 1.0) ; cy = H // 2; cx = W // 2; ry = (H-2)/2; rx = min((W-2)/2, ry*2)
        a += 0.18
        if random.random() < 0.08: blips.append([random.uniform(0, 2*math.pi), random.uniform(0.2, 0.95), 1.0])
        cells = {}
        for k in range(360):
            t = math.radians(k)
            for f in (1.0, 0.66, 0.33):
                cells[(int(cx + rx*f*math.cos(t)), int(cy + ry*f*math.sin(t)))] = "\x1b[38;5;22m·"
        for i in range(W): cells[(i, cy)] = cells.get((i, cy), "\x1b[38;5;22m─") if abs(i-cx) <= rx else " "
        for j in range(H): cells[(cx, j)] = "\x1b[38;5;22m│" if abs(j-cy) <= ry else " "
        for d in range(0, 6):
            th = a - d*0.12; col = ["\x1b[1;92m","\x1b[92m","\x1b[32m","\x1b[38;5;28m","\x1b[38;5;22m","\x1b[38;5;22m"][d]
            for s in range(0, 100):
                f = s/100.0; cells[(int(cx + rx*f*math.cos(th)), int(cy + ry*f*math.sin(th)))] = col + ("█" if d == 0 else "▒" if d < 3 else "░")
        for b in blips:
            b[2] -= 0.01; x = int(cx + rx*b[1]*math.cos(b[0])); y = int(cy + ry*b[1]*math.sin(b[0]))
            cells[(x, y)] = ("\x1b[1;97m◉" if b[2] > 0.8 else "\x1b[1;91m●" if b[2] > 0.4 else "\x1b[31m○")
        blips[:] = [b for b in blips if b[2] > 0]
        out = ["".join(cells.get((x, y), " ") for x in range(W)) for y in range(H)]
        out[0] = "\x1b[1;32m SCAN %03d° \x1b[0m\x1b[90mtargets:%d\x1b[0m" % (int(math.degrees(a)) % 360, len(blips)) + out[0][20:]
        frame(out); time.sleep(0.05)
run(loop)
