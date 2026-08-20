# HUNK22 — an area-average downscale for the open image module

**Stamp:** `20260813.171223` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round (agent-doable, Lindy-first crux-first)
**Season A · waymark HUNK · journey Open Image** — beside the Photos app and the marketplace sprite render.
**Kin:** [`../image/photos.rye`](../image/photos.rye) · [`../brushstroke/image_skate.rye`](../brushstroke/image_skate.rye) · [`20260813-170307_hunk-photos-saturate-exploration.md`](20260813-170307_hunk-photos-saturate-exploration.md)

---

## Why this rung

The open image module already scales — yet only by **nearest-neighbor** (`scale`, HUNK9): each output pixel samples one source pixel and drops the rest. That is honest for an upscale and fast for a preview, yet it **aliases** when an image shrinks — a thumbnail of a detailed photo, or the marketplace's McMaster-Carr sprite reduced to a catalog cell, throws away most of the picture and keeps a jittered subset. Every downstream surface that renders a smaller image inherits that loss.

Lindy-first, crux-first points here. Scaling is a **foundational primitive** the whole tree reads — the Photos resize, the marketplace sprite thumbnail, any future preview. Upgrading how an image *shrinks* compounds across every rendered picture, where one more leaf verb would be read once. And among the doors HUNK21 named (a hue rotation, a smoother resampler), the **area average** is the one that both raises quality on a primitive already in use and admits a clean **integer-only, algebra-provable** shape — the same register as `saturate` and `adjust`.

## The verb

`scale_area(allocator, pm, new_w, new_h) → Pixmap` — a **downscale by exact area averaging**. Each output pixel is the integer mean, over all four channels, of the source pixels its cell covers.

The source band for output column `ox` is `[ox·w/new_w, (ox+1)·w/new_w)`; rows likewise. Those bands **tile** the source — the boundaries are monotone and meet exactly, so every source pixel lands in exactly one output cell, no gap and no overlap. Because `new_w ≤ w` and `new_h ≤ h`, every band is **non-empty** (a real gap of `w/new_w ≥ 1` per step forces the integer band width to at least one).

- **Integer, no wrap.** A channel sum is at most `255 · block_area`, and `block_area ≤ qoi_max_pixels = 1<<20`, so `255·(1<<20) < 2^32` — the accumulator stays in `u32`. The band products run in `u64` so `ox·w` cannot wrap. The average is a truncating integer division by the non-zero block area.
- **All four channels averaged.** Unlike `adjust`/`saturate` (which pass alpha through), a resample averages alpha too — it is a genuine spatial mean, uniform across channels.
- **Downscale only.** An upscale would leave source pixels unread, so `new_w > w` or `new_h > h` refuses **`NotDownscale`** by name — nearest `scale` already handles upscales. A zero dimension refuses **`EmptyImage`**.

## The algebra it must obey (the proof, not one arithmetic)

1. **Identity** — `scale_area(pm, w, h)` recovers the source byte-for-byte (every cell is 1×1, its own mean).
2. **Constant stays constant** — a solid-color image downscaled to any smaller size is the *same* solid color, every channel, no rounding drift. This is the defining area-filter invariant and the one nearest-neighbor also passes yet the box filter must not break.
3. **Exact block mean** — a 2×2 image with four known colors downscaled to 1×1 gives the exact integer average of all four pixels per channel, computed by hand.
4. **Alpha averaged** — the alpha channel means alongside the colors, not passes through.
5. **Still open** — a downscaled image re-encodes and round-trips through the QOI codec byte-for-byte.
6. **Pure** — the source is never mutated.
7. **Named refusals** — `NotDownscale` for an upscale in either axis, `EmptyImage` for a zero dimension.

## What it is not

A true **hue rotation** (a modular color-wheel turn) and a fractional-coverage **bilinear** resampler stay named horizons on this same module — both are genuinely harder to bound cleanly in integer math, and half-building either here would cheapen the clean proof this rung earns. `scale_area` is the box filter: exact, bounded, and provable today.

## Definition of done

Opening triad present; ≥2 invariants per new function, each `// invariant:`; no `@memcpy`, no compound `assert(a and b)`; `tame_style_check` bans clean; width exit 0; the new `run_scale_area` selftest GREEN and the four prior image-photos selftests still GREEN beneath it; a new `tools/hunk_photos_scale_area_witness.rish` GREEN. No network, no key, no funds — hardware buys stay custody gates #2/#3.
