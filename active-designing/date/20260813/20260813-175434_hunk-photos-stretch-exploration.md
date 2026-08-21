# HUNK26 — the Photos app auto-levels: a contrast stretch over the open grid

**Stamp:** `20260813.175434` · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round (agent-doable, no gate) · **Waymark:** HUNK · **Rung:** HUNK26
**Season:** A — Hardware & Right-to-Repair · **Journey:** Open Image · beneath the parts marketplace and the Photos app
**Kin:** [`../image/photos.rye`](../image/photos.rye) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260813-174431_hunk-photos-convolve-exploration.md`](20260813-174431_hunk-photos-convolve-exploration.md)

---

## What the module already holds

The Photos module carries its point verbs (`crop`, the orient family, `adjust` for brightness/contrast, `saturate`, `hue_turn`), its full resampler family (nearest `scale`, area `scale_area`, smooth `scale_bilinear`), and — from HUNK25 — its neighborhood filter primitive `convolve` with `blur` and `sharpen` riding it. Every one is pure over the decoded RGBA grid and returns a fresh open image that re-encodes and round-trips byte-for-byte.

## The gap this rung closes

Every gesture so far maps a pixel by a **fixed** rule — the same brightness lift, the same kernel, everywhere. None reads the image first and adapts to what it actually holds. Yet the single most-reached one-tap fix in any photo app is **auto-levels**: a dim, low-contrast capture whose values crowd a narrow band gets stretched to fill the full tonal range, and it looks corrected without a slider touched. That gesture is the analytical crux the levels and curves tools stand on — it is the first verb that *measures* before it maps.

## The crux, chosen crux-first

`stretch` is a pure two-pass auto-levels over the decoded grid:

1. **Scan** — find each color channel's darkest (`lo`) and brightest (`hi`) value across the whole image. Alpha is read past, never stretched.
2. **Map** — linearly send `[lo, hi]` onto the full `[0, 255]` per channel: `out = round((v − lo)·255 / (hi − lo))`, computed in `u32` (the largest term `255·255 = 65025` is far inside `u32`) with the rounding half added before truncation.

The algebra it must obey, and the selftest proves:

- A **flat channel** (`lo == hi`, range zero) **passes through** untouched — no divide by nothing.
- A **full-range channel** already touching `0` and `255` is a **fixed point** — it maps onto itself.
- The map is **monotone** — pixel order within a channel is preserved, so no tone inversion.
- A **solid color** (every channel flat) is **byte-identical**.
- Alpha rides through untouched; the source stays pure; the stretched image re-encodes and round-trips as an open image.
- A degenerate image refuses `EmptyImage`.

The witness pins the exact numbers: a dim red ramp `[40, 60, 80, 100]` with green and blue held flat stretches to `[0, 85, 170, 255]` — the exact rounded map onto the full range — while the two flat channels pass through untouched, isolating the stretch to one channel where the arithmetic is unambiguous.

## Why this over the alternatives

Edge detection (Sobel/Laplacian) is one kernel over `convolve` — a fine next rung, yet it adds no new *analytical* capability. A per-luma histogram equalization is the richer cousin, yet it wants a per-pixel luma remap with a colour-preservation choice that is harder to prove byte-for-byte in one round. Per-channel contrast stretch is the clean, decisive, still-tractable move: it introduces the measure-then-map shape with fully provable integer arithmetic, and the levels/curves family grows from it.

## Boundaries

No breach, no cairn — a purely additive verb. No network, key, or funds; hardware buys stay custody gates #2/#3. Witness: `tools/hunk_photos_stretch_witness.rish`.

*May the dim capture find its full range, and every tone keep its order on the way there.*
