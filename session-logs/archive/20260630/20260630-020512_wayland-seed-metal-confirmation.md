# Wayland Seed Metal Confirmation

**Editor:** Cursor · **Model:** Composer  
**Stamp:** `20260630.020512`

---

## Thinking trace

Kaeden asked to continue and know when to check in with Claude. The open factual gate was whether `wayland_seed.rye` runs on the development host's compositor.

Built with the correct protocol file (`xdg-shell-protocol.c`, not the typo `xdg-shell-client-protocol.c` in an earlier failed attempt):

```bash
rye/bin/rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
```

**Selftest:** `1125 lit pixels — GREEN`, exit 0.

**Window mode** on `WAYLAND_DISPLAY=wayland-0`, `XDG_SESSION_TYPE=wayland`: exit 0, stdout `brushstroke wayland seed: skate grid drawn` (frame callback noted pending — seed commits one frame and exits).

**Parity:** `rishi run tools/parity.rish` — all witnesses GREEN (132 suite unchanged).

Updated `TASKS.md` and `ROADMAP.md` to record metal confirmation. SLC-2a bench waits on Claude scope brief, not on the window gate.

## Observations

Visual confirmation (did Kaeden see the window flash) is still human — programmatic path is proven. The seed presents one static frame and exits; SLC-2a grows redraw-on-change from a live value.

## Files

| File | Why |
|------|-----|
| `work-in-progress/TASKS.md` | SLC-2a gate cleared; Claude next |
| `work-in-progress/ROADMAP.md` | Brushstroke/Skate/SLC-2 rows updated |
| `session-logs/20260630-020512_wayland-seed-metal-confirmation.md` | This log |

## Check-in guidance

**Check in with Claude now** for: SLC-2a scope brief + step table, and the three external-research reservations. Bench implementation follows Claude's brief.
