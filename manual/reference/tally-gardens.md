# Tally Gardens — Reference

**Language:** EN
**Version:** `20260702.205630`
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Witness:** `rye/tests/tally_gardens_test.rye` (via parity) · `tools/foundation_seeds.rish` · parity **142**

---

This page documents only what the gardens witness and foundation-seed gate prove — named bounded memory regions for hosted modules.

## Witness paths

**Parity (std test):** `tally_gardens_test` in the regression suite.

**Foundation seeds:**

```bash
rishi/bin/rishi run tools/foundation_seeds.rish
```

Expect `tally gardens: all facts held` in output when `tally/bin/tally-gardens` runs green.

## Region (witnessed)

A **Region** is bump allocation inside a fixed byte buffer:

- `alloc(n)` advances `pos`; returns a slice
- Past the edge → **`OutOfBounds`** (named error, not silent corruption)
- `clear()` resets `pos` to zero — the season ends, the same backing store may begin again
- **Invariant:** `pos <= buf.len` at every mutation

## Gardens (witnessed)

A **Gardens** holds up to **8** named regions (`max_gardens`):

| Rule | Witnessed |
|------|-----------|
| Every garden has a non-empty name | yes |
| Name length ≤ **32** | yes |
| No duplicate names | asserted at add |
| Lookup by name | returns region or absent |

## The three near-stack gardens (documented in seed)

| Name | Role |
|------|------|
| `blob` | working memory for one Mantra blob |
| `diff` | line buffer for LCS diff |
| `frame` | Brushstroke widget tree per redraw |

The witness exercises add/get/clear/overflow — not every production name in every build path.

## Chronological version

`tally_gardens_version = "20260620.211712"` — carried in the seed source.

---

*May every allocation fail loudly at the edge, and may every garden keep its name and its season honestly.*
