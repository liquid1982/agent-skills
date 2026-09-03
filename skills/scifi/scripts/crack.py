import sys, random, time, hashlib, collections; sys.path.insert(0, __file__.rsplit('/',1)[0]); from common import *
def loop():
    target = hashlib.sha256(str(random.random()).encode()).hexdigest(); prog = 0.0; frags = 0; recent = collections.deque(maxlen=200); t0 = time.time()
    while True:
        W, H = size(); prog += random.uniform(0.05, 0.6)
        if prog >= 100: prog = 0; frags = 0; target = hashlib.sha256(str(random.random()).encode()).hexdigest(); recent.clear()
        for _ in range(3):
            cand = hashlib.sha256(str(random.random()).encode()).hexdigest()
            m = sum(a == b for a, b in zip(cand, target))
            recent.append("\x1b[90m%s\x1b[0m \x1b[32m%s\x1b[0m \x1b[90m%2d/64\x1b[0m" % (hex(random.randrange(1<<32))[2:].rjust(8,"0"), cand[:max(8, W-16)], m))
        if int(prog) // 12 > frags:
            frags += 1; recent.append("\x1b[1;92m ▶ KEY FRAGMENT %d/8 RECOVERED :: %s\x1b[0m" % (frags, target[(frags-1)*8:frags*8]))
        bw = max(10, W - 22); filled = int(bw * prog / 100)
        rate = random.uniform(1.8, 2.4)
        head = ["\x1b[1;33m  ▌ SHA-256 KEY RECOVERY :: node cluster 0x%02x\x1b[0m" % (frags*17 % 256),
                "\x1b[90m  target \x1b[0m\x1b[37m%s\x1b[0m" % target[:max(8, W-10)],
                "  \x1b[92m%s\x1b[38;5;236m%s\x1b[0m \x1b[1;97m%5.1f%%\x1b[0m" % ("█"*filled, "░"*(bw-filled), prog),
                "\x1b[90m  rate \x1b[0m\x1b[36m%.2f GH/s\x1b[0m  \x1b[90mfrags\x1b[0m \x1b[92m%d/8\x1b[0m  \x1b[90muptime\x1b[0m %5ds" % (rate, frags, time.time()-t0), ""]
        body = list(recent)[-(H - len(head)):]
        frame(head + body); time.sleep(0.08)
run(loop)
