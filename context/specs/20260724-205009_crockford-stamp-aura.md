# Crockford Stamp Aura -- Wire u64 - Spoken Edge

**Language:** EN  
**Version:** `20260724.205009`  
**Style:** Gauge (see `../GAUGE_STYLE.md`)
**Voice:** Quin  
**Status:** Living -- seats Hands We Grow Decision 6  
**Room:** Checkable  
**Witness:** `rishi/bin/rishi run tools/crockford_stamp_witness.rish`  
**Counsel:** [`../../counsel/20260724-193912_the-hands-we-grow.md`](../../counsel/20260724-193912_the-hands-we-grow.md) section Six

Radiant pass `20260725.041039`

---

## What This Seats

One chronological stamp has **two canonical faces** and a bijection asserted both ways:

| Face | Form | Role |
|------|------|------|
| **Inward** | `u64`, fixed eight bytes, **little-endian** | Zero-copy wire - batches - named bound - cast at the seam |
| **Outward** | **Crockford base32**, exactly **thirteen** characters | URLs - filenames - anything read aloud |

Glow desks: `glow/gen/shape-stamp-aura.glow` (`+$` / `$:` `stamp=@u64`) - `glow/gen/cast-named-stamp-aura.glow` (same-desk `^-  stamp-shape`) - `glow/gen/shape-stamp-mixed.glow` (mixed admitted auras).  
Rye codec: `linengrow/crockford_stamp.rye`.

The warm-aura date atom ([`20260714-024800_warm-aura-date-atom-naming.md`](20260714-024800_warm-aura-date-atom-naming.md)) remains the prose rendering (`YYYYMMDD.HHMMSS` / filename hyphen form). This aura seats the **machine faces** of that same moment: the integer on the wire, the Crockford string at the edge.

**Aura floor:** from `20260724.205719`, `@u64` sits on the admitted-shape list in `glow/rune_shape.rye` (`admitted_shape_auras` -- data in one place). Genuinely unsupported auras still refuse with `UnsupportedShapeAura`.

## Why Crockford, not base64url

Base64url is compact and URL-safe on a page. It is not safe in a mouth. It mixes `+`/`/` (or `-`/`_`), keeps both `I`/`l`/`1` and `O`/`0` confusable sets, and is case-sensitive -- a reader speaking a stamp aloud forces a transcription tax the Radiant register refuses to levy.

**Crockford base32** excludes **I, L, O, and U**, is case-insensitive, and stays inside a spoken alphabet a person can read back without inventing a spelling alphabet. Thirteen characters cover a `u64` (`ceil(64/5)`). That is why Decision 6 chooses it for the outward face: it survives being spoken, which the Radiant register requires.

## Width law

- **`u64`** -- the wire-persistent stamp value (and the little-endian eight-byte field).  
- **`u32`** -- bounded counts (`encoded_len`, `wire_bytes`, loop indices).  
- **No authored `usize`** -- casts stay at the indexing seam only.

## Negative space

The witness rejects:

- any symbol **I, L, O, or U** (upper or lower)  
- over-long and under-long strings (length must be exactly thirteen)  
- symbols outside the Crockford alphabet  

Round-trip over a fixture set proves encode -> decode and little-endian wire pack -> unpack.

## Alphabet

`0123456789ABCDEFGHJKMNPQRSTVWXYZ` -- pinned in `linengrow/crockford_stamp.rye` as `alphabet`.

---

*May every stamp we speak be the same stamp we wire -- one atom, two faces, no confusion in the ear.*
