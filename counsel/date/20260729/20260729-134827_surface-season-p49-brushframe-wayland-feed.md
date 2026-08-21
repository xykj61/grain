# Surface Season p49 — BrushFrame → Wayland Host Feed

**Stamp:** `20260729.134827` · **Voice:** Quin · **Season:** Surface · **Scope:** sept · **Round:** p49  
**Prior:** [p48 Wayland-from-Frame](20260729-134259_surface-season-p48-wayland-from-frame.md)  
**Ask:** waymark p48 complete / p49 next · asks none  
**Status:** **LANDED** — thin feed metal · live-five still **held**

## Verdict

**p49 LANDED.** `brushstroke/wayland_seed.rye` imports `brush_parse` and feeds a lowered `BrushFrame` into the Wayland seed `Frame`:

| Path | Role |
| --- | --- |
| `brushtest [path.brush]` | Headless · `.brush` → BrushFrame → Wayland Frame → lit pixels |
| `brush <path.brush>` | Hosted · same feed onto a Wayland surface (`WAYLAND_DISPLAY`) |

Default fixture: `brushstroke/seed-frame.brush` · at-nib=`brushstroke-seed` · lines=3 · lit GREEN.

Seam law kept: Glow still quiet on Wayland C · Frame remains the glass · no live-five · no twelfth sur count.

## Choir

`wayland_from_frame_witness` now includes `brushtest`. Rebuild:

```
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"
rye/bin/rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
brushstroke/bin/brushstroke-wayland-seed brushtest
```

## Next

**p50** — kg hosted `brush` path in witness (needs display) · thin shared Frame tidy · or `asks: live-five`.

---

*p49 · stamp `20260729.134827` · Quin · BrushFrame feeds Wayland Frame*
