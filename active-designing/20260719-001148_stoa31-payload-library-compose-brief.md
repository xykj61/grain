# STOA31 — `/+` payload library compose

**Status:** Checkable — thin face GREEN `20260719.001148`  
**Depth:** brief  
**Last updated:** 2026-07-19 (`20260719.001148`)  
**Voice:** Quin  
**Waymark:** **STOA** · compressor [`../docs/STOA.md`](../docs/STOA.md) · prior [`20260719-000745_stoa30-payload-open-compose-brief.md`](20260719-000745_stoa30-payload-open-compose-brief.md)

---

## Thin face claim

Library desk `glow/gen/lib-core-payload-nest.glow`:

```
|%
=/  amount  5
++  pack  (jam amount amount)
--
```

Consumer desk `glow/gen/use-lib-payload-nest.glow` (exactly three lines):

```
/+  lib-core-payload-nest
=/  amount  5
%-  pack  amount
```

| Piece | Meaning |
|-------|---------|
| Library payload | `amount = 5` — arm reads `self.amount` |
| Outer face value | Must match the library payload atom |
| Call | `core.pack()` — no sample arg |
| Welcome | `amount == 5 and core.pack() == 327685` |

Sample-arg libraries (STOA26/29) stay on `lib.Core.arm(face)`.

## Not in this face

`(cue …)` · NativeActivity import · multi-lib desks.

---

*Importable payload batteries — Glow modules with state other Glow desks can call.*
