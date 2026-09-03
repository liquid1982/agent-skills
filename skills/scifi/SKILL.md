---
name: scifi
description: "Turn the current Herdr tab into a movie-style sci-fi hacker terminal wall. Splits 10 panes around the calling pane and fills them with matrix rain, radar, a hex dump, a fake intrusion log, a hash cracker, and live system monitor, system log and socket views. Use when the user says scifi, hacker terminal, movie hacker mode, make my terminal look cool, or asks to take that layout down. Requires running inside a Herdr pane (HERDR_ENV=1). Works from any coding agent."
compatibility: "Needs the herdr CLI, bash, jq and python3 on PATH. macOS or Linux. btop optional."
---

# /scifi — hacker-movie terminal wall in Herdr

Everything is scripted. Do not rebuild the layout by hand; run the entry point in this
skill's `scripts/` directory. All paths below are relative to the directory containing this file.

## Launch

1. Check `test "${HERDR_ENV:-}" = 1`. If it fails, tell the user this only works inside a
   Herdr pane and stop.
2. Run `scripts/scifi up`. It splits the calling pane (kept top-left, about 35% wide and
   55% tall) into 10 sibling panes, starts one effect per pane, and records the pane IDs in
   `~/.cache/scifi/`. It refuses to run twice for the same anchor pane.
3. Tell the user which panes show real data (system monitor, system log, socket table) and
   which are animations (matrix, intrusion log, hex dump, cracker, radar, telemetry, clock),
   and that `scripts/scifi down` removes everything.

Constraints the scripts already handle: the anchor pane must be at least 120x30; `btop -p 3`
is used because btop's default layout needs 35 rows (falls back to `top` when btop is absent);
the log pane runs `log stream` on macOS and `journalctl -f` on Linux.

## Teardown

Run `scripts/scifi down`. It sends Ctrl+C (and `q` for btop) to each recorded pane, closes
them, and removes the state file. It never touches panes it did not create.

## Status

`scripts/scifi status` lists running walls by anchor pane.

## Customizing

Effects are `scripts/*.py` sharing `common.py` (terminal size, cursor, full-frame draw). Each
one reads the pane size every frame, so panes can be resized or moved freely. To swap an
effect, edit the matching `run` line in `scripts/launch.sh`.
