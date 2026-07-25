# STOA190 — Remaining Mold → Shape Rename

*An Acme Corporation employee reading this gets the rest of the held mold surface renamed: errors, nest/gate APIs, Zig stems, living desks, with Hoon study twins filed under `hoon-study/`.*

**Language:** EN  
**Version:** `20260721.181551` (UDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — bartis · barket · nest · shape witnesses · glow_run  
**Register:** Checkable (Two Rooms)  
**Grounds in:** [`20260721-180917_stoa189-shapespec-api-rename.md`](20260721-180917_stoa189-shapespec-api-rename.md)

**dated_guard:** Do **not** rewrite dated STOA mold briefs. Hoon-study `*-mold` spellings stay under `glow/gen/hoon-study/`.

---

## Verdict (one breath)

**MOLD_SURFACE_CLOSED.** Living Glow speaks shape:

| Was | Now |
|-----|-----|
| `MoldNotU32` | `UnsupportedShapeAura` |
| `NamedMoldNotYetLowered` | `NamedShapeNotYetLowered` |
| `CastMoldMismatch` | `CastShapeMismatch` |
| `assert_*_mold_*` / `is_*_named_mold` | `assert_*_shape_*` / `is_*_named_shape` |
| Zig `AmountMold` … | Zig `AmountShape` … (`-mold` stem maps to `-shape`) |
| Living `sample=*-mold` gates | `sample=*-shape` |
| `glow/gen/mold-*.glow` | `glow/gen/hoon-study/mold-*.glow` (study) |

Allowlists still accept `-mold` as Hoon aliases.

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_lower_shape_witness.rish
glow/bin/lower_bartis_witness
glow/bin/nest_type_witness
rishi/bin/rishi run tools/glow_run.rish glow/gen/gate-amount.glow
```

---

*May every living path say shape, and may every mold twin keep teaching Hoon from its study shelf.*
