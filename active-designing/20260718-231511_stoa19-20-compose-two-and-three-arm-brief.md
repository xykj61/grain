# STOA19–20 — Face→two-arm compose and three-arm battery

**Status:** Checkable — both thin faces GREEN `20260718.231511`  
**Depth:** brief  
**Last updated:** 2026-07-18 (`20260718.231511`)  
**Voice:** Quin  
**Waymark:** **STOA** · compressor [`../docs/STOA.md`](../docs/STOA.md)

---

## STOA19 — face→two-arm

```
=/  amount  5
|%
++  double
++  inc
--
```

Collect `max_lines` rises to **5** (bare multi still caps at 4). Lower calls `Core.double` and `Core.inc` with the outer face. Desk `compose-core-two`.

## STOA20 — three-arm battery

```
|%
++  double
++  inc
++  dec
--
```

`max_arms` rises to **3**. Closed arm `dec` is `sample -% 1` (5 → 4). Desk `core-three`.

## Not in these faces

Typed payload molds · face→three-arm · face→payload compose · `%+` into a core · variance.

---

*Widen the battery; deepen the compose against it.*
