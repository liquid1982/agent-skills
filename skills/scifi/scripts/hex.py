import sys, random, time, string; sys.path.insert(0, __file__.rsplit('/',1)[0]); from common import *
def loop():
    addr = random.randrange(0x7ff000000000, 0x7fffffffffff, 16); n = 0
    sys.stdout.write("\x1b[1;36m  ▌ MEMORY DUMP :: /dev/mem :: PID 1 :: DECRYPT PASS 3/7\x1b[0m\n")
    while True:
        W, H = size(); nb = max(4, min(16, (W - 14) // 4))
        bs = [random.randrange(256) if random.random() > 0.35 else 0 for _ in range(nb)]
        hx = []
        for b in bs:
            if b == 0: hx.append("\x1b[38;5;238m00")
            elif 32 <= b < 127: hx.append("\x1b[1;33m%02x" % b)
            else: hx.append("\x1b[32m%02x" % b)
        asc = "".join(chr(b) if 32 <= b < 127 else "\x1b[38;5;238m·\x1b[32m" for b in bs)
        sys.stdout.write("\x1b[36m%012x\x1b[0m  %s \x1b[0m\x1b[32m|%s\x1b[0m|\n" % (addr, " ".join(hx), asc))
        addr += nb; n += 1
        if n % 37 == 0:
            sys.stdout.write("\x1b[1;92m ── SEGMENT %08x UNLOCKED :: KEY %s ──\x1b[0m\n" % (random.randrange(1<<32), "".join(random.choice("0123456789abcdef") for _ in range(16))))
        sys.stdout.flush(); time.sleep(random.choice([0.02,0.04,0.04,0.09]))
run(loop)
