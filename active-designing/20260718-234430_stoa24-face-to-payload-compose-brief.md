# STOA24 — Face→payload core compose

**Status:** Checkable — thin face GREEN `20260718.234430`  
**Depth:** brief  
**Last updated:** 2026-07-18 (`20260718.234430`)  
**Voice:** Quin  
**Waymark:** **STOA** · compressor [`../docs/STOA.md`](../docs/STOA.md)

---

## Thin face claim

Exactly five Glow lines:

```
=/  note  7
|%
=/  amount  5
++  double
--
```

| Piece | Meaning |
|-------|---------|
| Outer `=/  note  7` | Face beside the core cell |
| Inner `=/  amount  5` | Core payload (bare or `@u32`) |
| `++  double` | Arm reads `self.amount` → `10` |

**Lower:** bind `note`, emit payload `Core`, call `core.double()`, welcome expects `note == 7` and `10`.

## Not in this face

Outer face as arm sample · three arms with payload · `%+` with payload.

---

*One outer face, one payload battery, ordinary Rye underneath.*
