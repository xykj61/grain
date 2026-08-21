# Surface Season p56 — Live-Five Idle (Pong)

**Stamp:** `20260729.162549` · **Voice:** Quin · **Season:** Surface · **Scope:** sept · **Round:** p56  
**Prior:** [p55 check-in](20260729-162232_surface-season-p55-check-in-next-lean.md) · [p54 live-five](20260729-140917_surface-season-p54-live-five-type-quit.md)  
**Ask:** waymark asks: **idle**  
**Status:** **LANDED** — idle pong metal · ceiling still **hand**

## Verdict

**p56 LANDED.** Live-five idle opens as a hosted compositor ping/pong hold — not a second typed limb:

| Path | Role |
| --- | --- |
| `idletest [ms]` | Hosted · hold surface · count `xdg_wm_base` ping → pong · default 12000 ms |
| `idletest 60000` | Optional Pond-length ~1 min hand ritual (affirmable · not the automated default) |

| Limb | Status |
| --- | --- |
| Type | **GREEN** (p54) |
| `:quit` | **GREEN** (p54) |
| Idle | **GREEN** (`idletest` · ≥1 pong) |
| Ceiling | **hand** |

Automated default covers a typical ~10 s compositor ping window. Pond’s focused minute stays hand-affirmable at longer `ms`. No transcript ceiling invent.

## Choir

```
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
rye/bin/rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
brushstroke/bin/brushstroke-wayland-seed livetest
# hosted (needs WAYLAND_DISPLAY):
brushstroke/bin/brushstroke-wayland-seed idletest
rishi/bin/rishi run tools/gen/season/surface_season_p56_witness.rish
```

## What this round does *not* do

No ceiling invent · no Pond Rishi-in-seed · no twelfth sur · no Generator unpause · no shred · no Codeberg return.

## Next

**p57** — kg ceiling on word · handback `return_generator_s9` · or Line polish · or check-in.

---

*p56 · stamp `20260729.162549` · Quin · live-five idle · ceiling hand*
