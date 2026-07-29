# Surface Season p52 — Frame Tidy (Glass · Host Seam)

**Stamp:** `20260729.140036` · **Voice:** Quin · **Season:** Surface · **Scope:** sept · **Round:** p52  
**Prior:** [p51 check-in](20260729-135658_surface-season-p51-check-in-next-lean.md)  
**Ask:** waymark asks: **frame-tidy**  
**Status:** **LANDED** — thin shared Frame lean · live-five still **held**

## Verdict

**p52 LANDED.** Dual Frame debt gets a named supersession, not a rewrite:

| Name | Role |
| --- | --- |
| `brush.Frame` | Glass contract — alias of seated museum `BrushFrame` |
| Host `Frame` (`wayland_seed`) | Wayland Line pack → Skate → SHM |
| `Frame.from_brush` | **One** named hop glass → host |

Museum placards keep saying `BrushFrame` (sur×11). Feed paths (`brushtest` · `brush`) lower once and convert through `from_brush`. Banner marks `from_brush — GREEN`.

## Choir

```
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
rye/bin/rye build brushstroke/brush_parse.rye -femit-bin=brushstroke/bin/brush-parse
rye/bin/rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
brushstroke/bin/brushstroke-wayland-seed brushtest
rishi/bin/rishi run tools/gen/season/surface_season_p52_witness.rish
```

## What this round does *not* do

No live-five · no twelfth sur · no host Frame field merge into glass · no Generator unpause · no shred.

## Next

**p53** — kg live-five on word · handback `return_generator_s9` · or thin host polish (Line wrapper lean) after check-in.

---

*p52 · stamp `20260729.140036` · Quin · glass Frame → host from_brush*
