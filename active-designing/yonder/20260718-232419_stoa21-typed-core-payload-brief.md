# STOA21 — Typed core payload (`@u32`)

**Status:** Checkable — thin face GREEN `20260718.232419`  
**Depth:** brief  
**Last updated:** 2026-07-18 (`20260718.232419`)  
**Voice:** Quin  
**Waymark:** **STOA** · compressor [`../docs/STOA.md`](../../docs/STOA.md) · prior [`20260718-225931_stoa17-core-payload-brief.md`](20260718-225931_stoa17-core-payload-brief.md)

---

## Thin face claim

```
|%
=/  amount=@u32  5
++  double
--
```

| Piece | Meaning |
|-------|---------|
| `=/  amount=@u32  5` | Typed payload — closed mold `@u32` only |
| `++  double` | Arm reads `self.amount` (5 → 10) |

**Lower:** same Rye field shape as bare STOA17 (`amount: u32 = 5`); the mold is checked at parse. Other auras and named molds refuse.

**Backward compat:** bare `=/  amount  5` payload (STOA17) stays GREEN.

## Not in this face

`@u8` / `@u64` payload · face→three-arm · face→typed-payload compose · variance.

---

*Sample mold on the cell, ordinary Rye underneath.*
