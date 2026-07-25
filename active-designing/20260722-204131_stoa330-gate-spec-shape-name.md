# STOA330 — GateSpec / BarketSpec `shape_name`

*An Acme Corporation employee reading this gets the gate-spec field rename: bartis and barket specs carry `shape_name` rather than `mold_name`, so the API that holds a sample’s closed name matches Glow OS speech.*

**Language:** EN  
**Version:** `20260722.204131` (EDT · Framework host)  
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)  
**Voice:** Quin  
**Status:** Checkable — rename GREEN `20260722.204131`  
**Register:** Checkable (Two Rooms) — gate-spec API; cast/face mold fields still debt  

**Grounds in:** STOA329 lean **C** · shape surface [`20260720-223226_glow-os-shape-not-mold.md`](20260720-223226_glow-os-shape-not-mold.md) · STOA328  

**dated_guard:** Study `-mold` allowlist strings and hoon-study desks stay. Cast/`rune_face` mold fields wait for the next lap.

---

## Verdict (one breath)

**GATE_SHAPE_NAME.** `GateSpec` · `BarketSpec` · `shape_name` · `shape_name_len` · `shape_name_slice` · `max_shape_len` · lowers and witnesses follow · nest · barket GREEN.

---

## What renamed

| Was | Now |
|---|---|
| `mold_name` | `shape_name` |
| `mold_name_len` | `shape_name_len` |
| `mold_name_slice` | `shape_name_slice` |
| `max_mold_len` (gate specs) | `max_shape_len` |

---

## Still mold (named debt)

| Surface | Why held this lap |
|---|---|
| `rune_cast` · `mold` / `max_mold_len` | separate cast API |
| `rune_face` · `mold_slice` | face/cast season |
| study `-mold` strings | Hoon study twins |

---

## Witness

```bash
export RYE_ZIG=vendor/zig-toolchain/zig
rishi/bin/rishi run tools/glow_nest_type_witness.rish
rishi/bin/rishi run tools/glow_barket_lower_witness.rish
```

---

*May the field that holds a shape’s name say shape.*
