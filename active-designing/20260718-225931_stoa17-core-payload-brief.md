# STOA17 — Core payload (thin sample face)

**Status:** Checkable — thin face GREEN `20260718.225931`  
**Depth:** brief  
**Last updated:** 2026-07-18 (`20260718.225931`)  
**Voice:** Quin  
**Waymark:** **STOA** · compressor [`../docs/STOA.md`](../docs/STOA.md) · prior [`20260718-225150_stoa15-16-two-arm-and-library-brief.md`](20260718-225150_stoa15-16-two-arm-and-library-brief.md)

---

## Why now

STOA14–16 give a battery of arms and library emit. A Hoon core is `[battery payload]`. Glow still needs the **payload** half — one named sample atom the arms read — before the cell is honest.

## Thin face claim

Exactly four Glow lines (`max_lines` stays 4):

```
|%
=/  amount  5
++  double
--
```

| Piece | Meaning |
|-------|---------|
| `=/  amount  5` | Payload face — bare decimal sample on the core |
| `++  double` | Arm reads `self.amount` (closed demo: `*% 2` → 10) |

**Lower:** Rye `Core` with field `amount: u32 = 5` and `double(self: @This()) u32`. Welcome `main` constructs `Core{}` and expects `10`.

**Backward compat:** desks with only `++` arms (no `=/`) keep STOA14/15 — methods still take `sample: u32`.

## Not in this face

Typed payload molds · two arms plus payload (would need a fifth line) · face→core compose · variance · wet cores.

---

*Battery and payload, one ordinary Rye struct underneath.*
