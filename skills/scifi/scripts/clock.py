import sys, time, datetime, random; sys.path.insert(0, __file__.rsplit('/',1)[0]); from common import *
D = {"0":["███","█ █","█ █","█ █","███"],"1":["  █","  █","  █","  █","  █"],"2":["███","  █","███","█  ","███"],"3":["███","  █","███","  █","███"],
     "4":["█ █","█ █","███","  █","  █"],"5":["███","█  ","███","  █","███"],"6":["███","█  ","███","█ █","███"],"7":["███","  █","  █","  █","  █"],
     "8":["███","█ █","███","█ █","███"],"9":["███","█ █","███","  █","███"],":":[" "," ▪"," "," ▪"," "]}
ST = ["UPLINK ● SECURE","TRACE ● ACTIVE","PROXY CHAIN 7/7","TOR CIRCUIT OK","VPN ● HANDSHAKE","ICE BREAKER ARMED","GHOST MODE ON"]
def loop():
    i = 0
    while True:
        W, H = size(); s = datetime.datetime.now().strftime("%H:%M:%S"); i += 1
        rows = ["".join(D[c][r] + (" " if c != ":" else "") for c in s) for r in range(5)]
        pad = max(0, (W - len(rows[0])) // 2)
        out = [""] + ["\x1b[1;92m" + " "*pad + r for r in rows] + [""]
        col = "\x1b[1;92m" if (i // 8) % 2 else "\x1b[32m"
        out.append(col + ST[(i // 40) % len(ST)].center(W) + "\x1b[0m")
        out.append("\x1b[90m" + datetime.datetime.utcnow().strftime("%Y-%m-%d  UTC%z ZULU").center(W))
        frame(out[:H]); time.sleep(0.25)
run(loop)
