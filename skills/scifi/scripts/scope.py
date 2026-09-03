import sys, random, time, math; sys.path.insert(0, __file__.rsplit('/',1)[0]); from common import *
BARS = " ▁▂▃▄▅▆▇█"
def loop():
    t = 0.0; spec = None
    while True:
        W, H = size(); t += 0.25; wh = max(3, H - 4); cells = [[" "]*W for _ in range(wh)]
        for x in range(W):
            v = math.sin(x/6 + t) * 0.6 + math.sin(x/2.3 - t*1.7) * 0.3 + random.uniform(-0.08, 0.08)
            y = int((v + 1) / 2 * (wh - 1)); cells[wh-1-y][x] = "\x1b[1;92m●" if x % 7 == 0 else "\x1b[32m•"
        if spec is None or len(spec) != W: spec = [random.random() for _ in range(W)]
        spec = [max(0, min(1, s + random.uniform(-0.25, 0.25))) * (0.4 + 0.6*math.exp(-i/W*3)) for i, s in enumerate(spec)]
        bar = "".join(("\x1b[92m" if s < 0.5 else "\x1b[93m" if s < 0.8 else "\x1b[91m") + BARS[int(s*8)] for s in spec)
        hdr = "\x1b[1;36m ▌ SIGNAL INTERCEPT :: %.3f MHz :: SNR %4.1f dB\x1b[0m" % (433.92 + math.sin(t/9)*0.05, 20 + math.sin(t/3)*6)
        out = [hdr] + ["".join(r) for r in cells] + ["\x1b[90m " + "─"*(W-2) + "\x1b[0m", bar]
        frame(out[:H]); time.sleep(0.06)
run(loop)
