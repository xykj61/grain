# STOA189 — ShapeSpec / rune_shape / lower_shape API Rename

*An Acme Corporation employee reading this gets the held API rename: Glow's parse and lower modules speak **shape** in their living names, while Hoon study desks keep `-mold`.*

**Language:** EN  
**Version:** `20260721.180917` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — bound by `glow_rune_shape_witness` · `glow_lower_shape_witness` · named-cast · nest_type · glow_run desks  
**Register:** Checkable (Two Rooms) — API rename GREEN; study `mold-*` desks kept; Zig `*Mold` stems from `-mold` names kept  
**Grounds in:** [`20260720-223226_glow-os-shape-not-mold.md`](20260720-223226_glow-os-shape-not-mold.md) · [`20260721-013023_stoa174-living-pin-polish-shape-primary.md`](20260721-013023_stoa174-living-pin-polish-shape-primary.md)

**dated_guard:** Do **not** rewrite dated STOA mold briefs or historical ROADMAP/TASKS rows. Do **not** delete `mold-*` study twins. Prefer **send** with STOA186–188 when the pier should match the hand.

---

## Verdict (one breath)

**SHAPESPEC_API.** Forward rename only:

| Was | Now |
|-----|-----|
| `MoldSpec` | `ShapeSpec` |
| `glow/rune_mold.rye` | `glow/rune_shape.rye` |
| `glow/lower_mold.rye` | `glow/lower_shape.rye` |
| `*_mold_witness` · tools | `*_shape_witness` |
| `looks_like_mold_only` | `looks_like_shape_only` |

Kept: `mold-*` study desks · `MoldNotU32` · `assert_*_mold_nests` · Zig `AmountMold` from `amount-mold` names.

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_rune_shape_witness.rish
rishi/bin/rishi run tools/glow_lower_shape_witness.rish
rishi/bin/rishi run tools/glow_run.rish glow/gen/shape-amount.glow
rishi/bin/rishi run tools/glow_run.rish glow/gen/mold-amount.glow
```

---

*May every living API say shape, and may every mold twin keep teaching the study path.*
