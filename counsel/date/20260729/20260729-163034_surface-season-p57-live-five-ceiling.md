# Surface Season p57 — Live-Five Ceiling (Transcript Fill)

**Stamp:** `20260729.163034` · **Voice:** Quin · **Season:** Surface · **Scope:** sept · **Round:** p57  
**Prior:** [p56 idle](20260729-162549_surface-season-p56-live-five-idle.md) · [p54 live-five](20260729-140917_surface-season-p54-live-five-type-quit.md)  
**Ask:** waymark asks: **ceiling**  
**Status:** **LANDED** — transcript ceiling metal · live-five limbs complete

## Verdict

**p57 LANDED.** Live-five ceiling opens as Pond’s refuse-at-bound invent on the Wayland seed — thin `LiveTranscript`, not a Rishi pull:

| Path | Role |
| --- | --- |
| `ceilingtest` | Headless · fill past `max_live_transcript_bytes` (65536) · status invitation · refuse further append · `:quit` still named |
| `live` | Hosted · typed lines append until full · status row shows `transcript full — … :quit to close` |

| Limb | Status |
| --- | --- |
| Type | **GREEN** (p54) |
| `:quit` | **GREEN** (p54) |
| Idle | **GREEN** (p56) |
| Ceiling | **GREEN** (`ceilingtest`) |

Byte ceiling matches Pond drawn-terminal invent. Frame compose keeps body rows under `max_lines` with one reserved status row. Wayland `xdg_wm_base` / surface / toplevel / keyboard listeners now live on `App` (not stack temps), so idle pong stays honest after `create_surface` returns.

## Choir

```
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
rye/bin/rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
brushstroke/bin/brushstroke-wayland-seed livetest
brushstroke/bin/brushstroke-wayland-seed ceilingtest
rishi/bin/rishi run tools/gen/season/surface_season_p57_witness.rish
# hosted (needs WAYLAND_DISPLAY):
brushstroke/bin/brushstroke-wayland-seed live
```

## What this round does *not* do

No Rishi-in-seed · no Mantra `:version` · no twelfth sur · no Generator unpause · no shred · no Codeberg return.

## Next

**p58** — check-in / handback `return_generator_s9` · Line polish · or residual choir.

Live-five invent (build · type · idle · ceiling · `:quit`) is metal-complete on this seed.

---

*p57 · stamp `20260729.163034` · Quin · live-five ceiling · limbs complete*
