import sys, random, time, datetime; sys.path.insert(0, __file__.rsplit('/',1)[0]); from common import *
PROTO = ["TCP SYN","TCP ACK","UDP","ICMP","TLS1.3","SSH","HTTP","DNS","QUIC"]
GEO = ["Minsk, BY","Pyongyang, KP","Shenzhen, CN","Bucharest, RO","Lagos, NG","Moscow, RU","Ashburn, US","Reykjavik, IS","Kyiv, UA","Sao Paulo, BR","Tehran, IR"]
def ip(): return "%d.%d.%d.%d" % (random.choice([45,103,185,193,203,5,91,77,31]),random.randrange(256),random.randrange(256),random.randrange(1,255))
def loop():
    sys.stdout.write("\x1b[1;31m  ▌ IDS :: perimeter-01 :: live capture\x1b[0m\n")
    while True:
        t = datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3]; W, H = size()
        r = random.random(); src = ip(); port = random.choice([22,23,80,443,3389,8080,445,25,53,5900,random.randrange(1024,65535)])
        if r < 0.55: act, col = "ALLOW", "\x1b[32m"
        elif r < 0.85: act, col = "DROP ", "\x1b[33m"
        elif r < 0.95: act, col = "REJECT", "\x1b[91m"
        else: act, col = "ALERT", "\x1b[1;97;41m"
        line = "\x1b[90m%s\x1b[0m %s%-6s\x1b[0m \x1b[36m%-15s\x1b[0m→\x1b[35m:%-5d\x1b[0m \x1b[37m%-7s\x1b[0m" % (t, col, act, src, port, random.choice(PROTO))
        if act == "ALERT": line += " \x1b[1;31m%s\x1b[0m" % random.choice(["brute-force signature", "port-scan sweep", "payload matches CVE-2026-%d" % random.randrange(1000,9999), "beacon to C2", "priv-esc attempt", "exfil pattern 4.2MB"])
        elif random.random() < 0.15: line += " \x1b[90m%s\x1b[0m" % random.choice(GEO)
        sys.stdout.write(line[:W*4] + "\n"); sys.stdout.flush()
        if act == "ALERT": sys.stdout.write("\x1b[1;31m           └─ %s blacklisted, trace initiated\x1b[0m\n" % src); time.sleep(0.4)
        time.sleep(random.choice([0.03,0.05,0.08,0.15,0.3]))
run(loop)
