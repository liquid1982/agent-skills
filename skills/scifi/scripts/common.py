import os, sys, time, random, math
def size():
    try:
        s = os.get_terminal_size(sys.__stdout__.fileno()); return max(s.columns,10), max(s.lines,4)
    except OSError: return 80, 24
def init(): sys.stdout.write("\x1b[?25l\x1b[2J\x1b[H"); sys.stdout.flush()
def fini(): sys.stdout.write("\x1b[0m\x1b[?25h\x1b[2J\x1b[H"); sys.stdout.flush()
def run(loop):
    init()
    try: loop()
    except KeyboardInterrupt: pass
    finally: fini()
def frame(lines):
    sys.stdout.write("\x1b[H" + "\x1b[0m\n".join(l + "\x1b[K" for l in lines) + "\x1b[0m"); sys.stdout.flush()
