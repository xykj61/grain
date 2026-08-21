# HUNK25 — the convolution primitive, and the filter family it opens

**Stamp:** `20260813.174431` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season A** (Hardware & Right-to-Repair) · waymark **HUNK** · journey **Open Image**
**Kin:** [`20260813-173146_hunk-photos-bilinear-exploration.md`](20260813-173146_hunk-photos-bilinear-exploration.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`../image/photos.rye`](../image/photos.rye)

---

## Why this rung, by Lindy-first crux-first

The Photos module already carries the point verbs (crop, orient, adjust, saturate, hue-turn) and the resampler family (nearest, area, bilinear). The one durable core it still lacked is the **neighborhood** operation — a pixel shaped by the pixels around it. That is the crux, because a single 3×3 convolution primitive is the foundation the whole filter family stands on: blur, sharpen, emboss, and every edge detector (Sobel, Laplacian) are each **one kernel** over the same primitive. Landing the primitive once, proven, opens all of them for the cost of a kernel constant apiece — the highest-leverage single move left in the quest.

Chosen over the general-angle hue rotation (which wants fixed-point cos/sin tables — a larger, more delicate lap) because convolution is the harder-*solvable* move that opens more of the road.

## The shape

`convolve(allocator, pm, kernel: *const [9]i32, divisor, bias)` returns a fresh Pixmap. Each output color channel is the kernel-weighted sum of the pixel's 3×3 neighborhood over the divisor, plus the bias, clamped into 0..255. Alpha passes through untouched. Edges **extend** — a neighbor past a border clamps to the nearest real pixel (reusing the module's own `clamp_index`), so no read wraps and no black halo forms.

`blur` (nine ones over nine) and `sharpen` (center five, four −1 neighbors, over one) are thin wrappers — proof that the primitive genuinely opens the family rather than merely computing one effect.

## Bounds, the TAME way

Every weight and the divisor are bounded by `kernel_weight_max = 1<<16`, checked at the edge, refusing `BadKernel` by name. The whole 3×3 accumulation runs in `i64`: the largest single term is `255·(1<<16)`, nine of them plus a bias stay far inside `i64` — no product can wrap. A zero divisor and a degenerate image each refuse by name (`BadKernel` · `EmptyImage`).

## What the witness proves

Identity kernel is the source byte-identical; a solid color is a **fixed point** of both blur and sharpen (each kernel's weights sum to one over a flat field); a 3×1 red row `[0,90,0]` box-blurs to the exact clamped mean `[30,30,30]` at every pixel, edges clamped; alpha rides through untouched; the source is pure; the blurred image still re-encodes and round-trips as an open image; and each degenerate input refuses by name. No network, no key, no funds.

## The next crux this opens

An **edge-detect** verb (Sobel or Laplacian) is now a single kernel over `convolve` — the natural next agent-doable round, alongside the general-angle hue rotation and the wider Season-A journeys.
