# STOA26 — `/+` library compose

**Status:** Checkable — thin face GREEN `20260718.235530`  
**Depth:** brief  
**Last updated:** 2026-07-18 (`20260718.235530`)  
**Voice:** Quin  
**Waymark:** **STOA** · compressor [`../docs/STOA.md`](../docs/STOA.md) · prior [`20260718-235220_stoa25-open-arm-body-brief.md`](20260718-235220_stoa25-open-arm-body-brief.md)

---

## Thin face claim

Library desk `glow/gen/lib-core-open.glow`:

```
|%
++  id  sample
--
```

Consumer desk `glow/gen/use-lib-open.glow` (exactly three lines):

```
/+  lib-core-open
=/  amount  5
%-  id  amount
```

| Piece | Meaning |
|-------|---------|
| `/+  lib-core-open` | Import stem → `glow/gen/<stem>.glow` |
| `=/  amount  5` | Face sample for the call |
| `%-  id  amount` | Call open arm `id` on the imported `Core` |

**Lower:** `glow_run` library-emits the stem into `glow/.cache/lib_core_open.rye`, then emits a consumer that imports it and checks `lib.Core.id(amount) == 5`.

## Not in this face

Payload libraries · nest arm bodies · NativeActivity import · multi-lib desks.

---

*One Glow battery, one Glow consumer — the first Glow→Glow import seam.*
