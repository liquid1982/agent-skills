import sys, random, time, math, datetime; sys.path.insert(0, __file__.rsplit('/',1)[0]); from common import *
BARS = "▁▂▃▄▅▆▇█"
SATS = ["KH-11/04","ORION-7","LACROSSE-5","NROL-82","TDRS-13","MENTOR-9"]
def loop():
    sys.stdout.write("\x1b[1;35m  ▌ SATELLITE UPLINK :: TDRSS relay :: AES-256-GCM\x1b[0m\n")
    lat, lon = 41.9, 12.5
    while True:
        W, H = size(); lat += random.uniform(-0.4, 0.4); lon = (lon + random.uniform(0.3, 1.1) + 180) % 360 - 180
        sig = "".join(random.choice(BARS[3:]) for _ in range(8)); ok = random.random() > 0.08
        line = ("\x1b[90m%s\x1b[0m \x1b[35m%-10s\x1b[0m \x1b[36m%7.3f%s %8.3f%s\x1b[0m \x1b[37mALT\x1b[0m %6.1fkm \x1b[92m%s\x1b[0m %s" % (
            datetime.datetime.now().strftime("%H:%M:%S"), random.choice(SATS), abs(lat), "N" if lat >= 0 else "S", abs(lon), "E" if lon >= 0 else "W",
            400 + random.uniform(-15, 15), sig, "\x1b[32mLOCK\x1b[0m" if ok else "\x1b[1;31mDRIFT\x1b[0m"))
        sys.stdout.write(line + "\n"); sys.stdout.flush(); time.sleep(random.uniform(0.15, 0.5))
run(loop)
