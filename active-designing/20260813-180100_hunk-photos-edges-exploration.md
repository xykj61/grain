# HUNK27 — the Photos app detects edges: a Sobel gradient magnitude over luma

**Stamp:** `20260813.180100` · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable, no gate) · **Waymark:** HUNK · **Rung:** HUNK27
**Season:** A — Hardware & Right-to-Repair · **Journey:** Open Image
**Kin:** [`../image/photos.rye`](../image/photos.rye) · [`20260813-175434_hunk-photos-stretch-exploration.md`](20260813-175434_hunk-photos-stretch-exploration.md) · [`20260813-174431_hunk-photos-convolve-exploration.md`](20260813-174431_hunk-photos-convolve-exploration.md)

---

## What HUNK25 named, this rung lands

When HUNK25 gave the module its 3×3 `convolve` primitive, it named an edge detector the crux that primitive was *for* — "every blur, sharpen, emboss, and edge detector stands on it." The blur and sharpen rode `convolve` directly. An edge detector wants a little more: a true gradient magnitude combines *two* directional convolutions, which no single clamped-per-channel kernel can express. So `edges` is its own verb, and it is the decisive, still-tractable move the earlier rung pointed at.

## The crux

`edges` is a pure Sobel gradient magnitude over each pixel's Rec.601 luma (reusing `luma_of`), returned as a grayscale image:

- Two 3×3 gradient kernels — horizontal `gx = [-1,0,1,-2,0,2,-1,0,1]`, vertical `gy = [-1,-2,-1,0,0,0,1,2,1]` — read the 3×3 luma neighborhood.
- The magnitude is the **L1 sum** `|gx| + |gy|`, clamped into `0..255`. The L1 form avoids a square root and a float entirely, so the arithmetic stays exact: the largest single term is `4·255 = 1020` per direction, far inside `i32`.
- Edges are extended by clamping (reusing `clamp_index`) so no read wraps.
- The edge map is a fresh grayscale view — the same magnitude on every color channel, alpha opaque — because an edge image is a *view of change*, not the source with a filter laid over it.

## The algebra it must obey

The selftest proves it by the facts it cannot escape, not by one arithmetic:

- A **sharp luma step** `[0, 0, 255, 255]` (a single row) Sobels to the magnitudes `[0, 255, 255, 0]` — the two pixels straddling the step light up, the flat ends stay black. With one row clamped vertically, the vertical gradient is zero and the horizontal is `gx = -4·L(x−1) + 4·L(x+1)`, so the numbers are unambiguous.
- The edge map is **grayscale** (`r == g == b`) and **opaque**, proven even from a translucent source (alpha 200 in → 255 out).
- A **solid color** is a **fixed point at black** — no gradient anywhere.
- The source stays **pure**; the edge image re-encodes and round-trips as an open image; a degenerate image refuses `EmptyImage`.

## Why L1, not L2

The true Sobel magnitude is `√(gx² + gy²)`. The L1 approximation `|gx| + |gy|` is the standard integer-friendly stand-in every real-time edge filter uses — it needs no square root, keeps the whole computation exact in `i32`, and lights up the same edges. A precise L2 magnitude with a bounded integer square root is a fine future rung; the provable core lands today.

## Boundaries

No breach, no cairn — a purely additive verb. No network, key, or funds; hardware buys stay custody gates #2/#3. Witness: `tools/hunk_photos_edges_witness.rish`.

*May every real edge find its light, and every flat field keep its calm.*
