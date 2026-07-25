# STOA18 — Face→core compose

**Status:** Checkable — thin face GREEN `20260718.230846`  
**Depth:** brief  
**Last updated:** 2026-07-18 (`20260718.230846`)  
**Voice:** Quin  
**Waymark:** **STOA** · compressor [`../docs/STOA.md`](../docs/STOA.md) · prior [`20260718-225931_stoa17-core-payload-brief.md`](20260718-225931_stoa17-core-payload-brief.md)

---

## Why now

STOA11–12 compose faces into closed gates. STOA14–17 give a real `|%` battery (and payload). The missing join is calling a core arm from an outer face bind — the compose season meeting the core cell.

## Thin face claim

Exactly four Glow lines:

```
=/  amount  5
|%
++  double
--
```

| Piece | Meaning |
|-------|---------|
| `=/  amount  5` | Outer face — sample for the arm call |
| `|%` … `++  double` … `--` | Thin one-arm core (no inner payload) |

**Lower:** bind `amount`, emit `Core` with `double(sample: u32)`, call `Core.double(amount)`, expect `10`.

**Not in this face:** inner payload + outer face · two arms · `%+` into a core · typed faces.

---

*One face, one battery, one call — ordinary Rye underneath.*
