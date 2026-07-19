# STOA15–16 — Two-arm battery and library emit

**Status:** Checkable — both thin faces GREEN `20260718.225150`  
**Depth:** brief  
**Last updated:** 2026-07-18 (`20260718.225150`)  
**Voice:** Quin  
**Waymark:** **STOA** · compressor [`../docs/STOA.md`](../docs/STOA.md) · prior [`20260718-223906_stoa14-cores-thin-battery-brief.md`](20260718-223906_stoa14-cores-thin-battery-brief.md)

---

## STOA15 — two named arms

```
|%
++  double
++  inc
--
```

| Piece | Meaning |
|-------|---------|
| `++  double` | Closed demo: `sample *% 2` (5 → 10) |
| `++  inc` | Closed demo: `sample +% 1` (5 → 6) |

**Lower:** one Rye `Core` struct with both methods; welcome `main` asserts both; desk `glow/gen/core-two.glow`. Cap stays two arms (`max_arms = 2`).

## STOA16 — library emit (no `main`)

Same `|%` / `++` / `--` shape; `lower_source_library` emits `pub const Core` only. Desk `glow/gen/lib-core-double.glow` is the authored battery; a Rye consumer `@import`s the lowered library and exits 0. Ordinary `glow_run` stays for desks that carry `main`.

## Not in these faces

Payload/sample molds · three-plus arms · face→core compose · wet cores · variance.

---

*Two arms in one battery; one battery importable without a main.*
