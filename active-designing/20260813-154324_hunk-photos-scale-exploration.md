# HUNK9 — Photos resize: scale on the open grid

**Stamp:** `20260813.154324` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — the Photos-app quest continues past orient
**Season:** A (Hardware & Right-to-Repair) · **Waymark:** HUNK · **Journey:** Photos app · **Rung:** HUNK9
**Kin:** [`../image/photos.rye`](../image/photos.rye) (HUNK3 crop · HUNK8 orient) · [`../image/qoi.rye`](../image/qoi.rye) (HUNK0 codec) · [`20260813-153700_hunk-photos-orient-exploration.md`](20260813-153700_hunk-photos-orient-exploration.md)

---

## Why this round

HUNK3 cropped, HUNK8 turned and mirrored. The next everyday Photos gesture is **resize** — make a thumbnail, fit an image to a frame, upscale a small sprite. Every phone's Photos app carries it; the tree earns it on its own open grid, no proprietary scaler beneath and no permission asked to move a pixel.

## What lands

One new pure verb added **additively** to `image/photos.rye`, beside `crop` and the orient verbs (all untouched, their witnesses still GREEN):

- **`scale(new_w, new_h)`** — nearest-neighbor resize: output pixel `(nx, ny)` samples the source pixel at `(nx·w/new_w, ny·h/new_h)`, the sampling computed in `u64` so a product can never wrap. Returns a fresh `Pixmap`, leaves the source untouched. Refuses a degenerate source or target (`EmptyImage`, zero dimension) and a target past the codec's pixel ceiling (`OutOfBounds`).

Nearest-neighbor is the honest first scaler: exact, bounded, allocation-free per pixel, and enough for thumbnails and integer upscales. A smoother resampler (bilinear, area-average) is a named horizon on the same signature — this rung fixes the shape.

## How correctness is proven

- **Identity resize** (`new == old`) recovers the source **byte-for-byte** — the map is exact when it does nothing.
- **A 2× nearest upscale** samples each output pixel from `src(nx/2, ny/2)`, checked for **every** output pixel on a position-tagged 3×4 image — an unambiguous witness that the sampling arithmetic lands where it should.
- **A downscale to 1×1** picks the **top-left** source pixel (`sx = sy = 0`).
- **Pure** — the source's first pixel is exactly as crafted after every scale.
- **Still an open image** — an upscaled image re-encodes and round-trips through the codec byte-for-byte.
- **Refusals named** — a zero-dimension target refuses `EmptyImage`; a `2048×1024 = 2²¹` target (past the `2²⁰` ceiling) refuses `OutOfBounds` before allocating.

## Bounds and TAME

- `u32` dimensions; the sampling products and the target pixel count computed in `u64`, `@intCast` back at the edge.
- Target pixel count checked against `qoi.qoi_max_pixels` before allocation.
- `copy_disjoint` per pixel — never a bare memcpy.
- Three positive invariants (four-bytes-per-pixel source, target-within-ceiling, four-bytes-per-pixel output).
- No network, no key, no funds.

## Witness

`tools/hunk_photos_scale_witness.rish` builds `image/photos.rye` and asserts the new `GREEN image-photos-scale` line, the identity and 2× upscale proofs, and the open round-trip — confirming HUNK3 crop and HUNK8 orient still print their GREEN lines in the same binary.

---

*A picture that fits the frame you have is a small kindness; may it stay pure, bounded, and open every time it resizes.*
