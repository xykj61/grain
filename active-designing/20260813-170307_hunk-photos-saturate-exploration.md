# HUNK21 — the Photos app tunes saturation

**Stamp:** `20260813.170307` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Landed (self-approved design round) · **Season A** · waymark **HUNK** · journey **Photos app** · rung **HUNK21**
**Kin:** [`../image/photos.rye`](../image/photos.rye) · [`20260813-154324_hunk-photos-scale-exploration.md`](20260813-154324_hunk-photos-scale-exploration.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this rung takes

HUNK10 gave the Photos app its light — a bounded affine brightness-and-contrast map over the decoded RGBA grid. The named next agent-doable crux was another Photos gesture: a smoother resampler, or **hue/saturation as a new bounded verb**. Read Lindy-first, crux-first, saturation wins: a saturation slider is a capability every photo app carries and a keeper will reach for on the ten-thousandth day, and — unlike a floating-point HSL round-trip — it admits a clean, integer-only, algebra-provable shape that stands entirely on the open module already built. So this rung adds `saturate`, and names a true hue rotation as its own later horizon.

## The shape

`saturate(allocator, pm, sat_num, sat_den)` scales each pixel's color toward or away from its own gray, leaving alpha untouched, returning a fresh `Pixmap`. Each color channel takes the **luma-preserving map**

```
out = L + (c - L)·sat_num/sat_den,  clamped into 0..255
```

where `L` is the pixel's Rec.601 luma. The luma weights are scaled to sum **exactly 256** (`77 + 150 + 29`), so a right shift by 8 divides exactly and a gray pixel (`r == g == b == v`) maps to luma `v` with no rounding drift.

- `sat_num == sat_den` → the source, byte-for-byte (`out = L + (c - L) = c`).
- `sat_num == 0` → every pixel flattened to its own gray — a true grayscale.
- `sat_num > sat_den` → colors pushed apart, each channel driven further from its luma.
- A gray pixel is a **fixed point** at every saturation, since its chroma `c - L` is zero.

The whole map runs in `i64` so no product wraps; `sat_num` and `sat_den` are bounded by a named ceiling (`saturate_max = 1 << 16`), a zero denominator refuses `BadSaturation`, and a zero-dimension image refuses `EmptyImage`.

## Why it is proven by algebra, not by one arithmetic

The witness pins the verb to the laws it must obey rather than to a single computed byte, so an index or rounding bug is caught regardless of the exact arithmetic: neutral recovers the source, zero saturation makes `r == g == b == luma`, an already-gray pixel never moves, a boost drives the dominant channel above its luma and the weak channel below it, alpha always passes through, the source stays pure, and a saturated image still re-encodes and round-trips through the codec byte-for-byte — it is still an open image. The named refusals close the edges.

## Horizon named, not faked

A true **hue rotation** — a modular rotation of the color wheel, cleanest as a matrix in a luma-chroma space — is a genuinely harder verb to bound and to prove cleanly in integer arithmetic. It stays a named horizon on the same module, to be taken as its own rung rather than half-built here. Nothing about `saturate` blocks it; the luma helper this rung lands is exactly the piece a chroma rotation will reuse.

*Witness:* `tools/hunk_photos_saturate_witness.rish` GREEN; TAME bans clean, width exit 0; HUNK3 crop · HUNK8 orient · HUNK9 scale · HUNK10 adjust all still GREEN beneath.
