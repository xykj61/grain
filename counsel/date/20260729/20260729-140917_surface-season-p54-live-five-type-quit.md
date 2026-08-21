# Surface Season p54 — Live-Five Open (Type · `:quit`)

**Stamp:** `20260729.140917` · **Voice:** Quin · **Season:** Surface · **Scope:** sept · **Round:** p54  
**Prior:** [p53 check-in](20260729-140251_surface-season-p53-check-in-next-lean.md) · [p54 waits-word hold](20260729-140523_surface-season-p54-waits-word.md)  
**Ask:** waymark asks: **live-five**  
**Status:** **LANDED** — type · `:quit` metal · idle · ceiling still **hand**

## Verdict

**p54 LANDED.** Live-five opens on the Wayland seed without inventing a second drawn-terminal:

| Path | Role |
| --- | --- |
| `livetest` | Headless · KeyAction → Prompt → Frame signature · `:quit` GREEN |
| `live` | Hosted · keyboard drain · Frame redraw · `:quit` or window close |

| Limb | Status |
| --- | --- |
| Type | **GREEN** (livetest · hosted live) |
| `:quit` | **GREEN** (named exit word) |
| Idle ~1 min | **hand** |
| Ceiling | **hand** |

Thin `Prompt` sits in `wayland_seed.rye` — no Rishi REPL port. Glass `from_brush` hop stays for `.brush` present; live uses its own placard Frame.

## Choir

```
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
rye/bin/rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
brushstroke/bin/brushstroke-wayland-seed livetest
rishi/bin/rishi run tools/gen/season/surface_season_p54_witness.rish
# hosted (needs WAYLAND_DISPLAY):
brushstroke/bin/brushstroke-wayland-seed live
```

## What this round does *not* do

No idle-minute claim · no transcript ceiling invent · no Pond Rishi-in-seed · no twelfth sur · no Generator unpause · no shred.

## Next

**p55** — kg idle/ceiling lean on word · handback `return_generator_s9` · or Line polish · or check-in.

---

*p54 · stamp `20260729.140917` · Quin · live-five type · :quit · idle/ceiling hand*
