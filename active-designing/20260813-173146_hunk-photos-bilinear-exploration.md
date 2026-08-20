# HUNK24 — the Photos app resamples smoothly (bilinear)

**Stamp:** `20260813.173146` · **Waymark:** HUNK (Season A · Open Image journey) · **Voice:** Kyri
**Status:** Vision -- Design in motion — self-approved round · **Kin:** HUNK9 `scale` (nearest) · HUNK22 `scale_area` (area)

## The crux

The open image module carries two resamplers already, each honest for one direction: HUNK9's
nearest-neighbor `scale` is right for an upscale yet blocky, and HUNK22's area-average `scale_area`
is right for a downscale yet refuses to grow an image. Between them sits the resampler a photo app
reaches for by default — **bilinear**, the smooth one: an output pixel is the weighted blend of the
four source pixels around the real coordinate it lands on. This rung lands the third and last member
of the resampling family, so `image/photos.rye` covers nearest-up, area-down, and smooth-blend over
one decoded RGBA grid.

Bilinear is the *crux* of the three because it is the one that must be **bounded and exact in integer
math** where a naive version reaches for floats: the source coordinate is fractional, the four-corner
blend weights must sum exactly, and the rounding must be provable. The move that makes it clean is the
**half-pixel-center mapping** — output pixel `n` samples source coordinate `(n + 0.5)·src/dst − 0.5`,
computed in fixed point. That mapping has one property the whole witness rests on: at an **identity
size** the coordinate lands exactly on the integer pixel with zero fractional weight, so a bilinear
resize to the same dimensions recovers the source **byte-for-byte**, exactly as the other two do.

## The shape

`pub fn scale_bilinear(allocator, pm, new_w, new_h) !qoi.Pixmap` — a pure bounded function over the
decoded grid, returning a fresh Pixmap, the source untouched. Fixed point with `FRAC = 8` bits
(`S = 256`):

- Source coordinate for output index `n` along an axis mapping `src → dst`:
  `pos = floor(S·((2n+1)·src − dst) / (2·dst))` — the half-pixel-center map in one integer form, in
  `i64` so no product wraps and the edge coordinate may go negative honestly.
- Integer part `i = floor(pos / S)`, fractional part `f = pos − i·S ∈ [0, S)` (always non-negative,
  even where `pos < 0`, so an edge samples cleanly).
- Left/right (top/bottom) source indices clamp to `[0, len−1]` — standard bilinear edge clamp, so a
  coordinate off the edge samples the nearest real pixel.
- Each output channel: `round((tl·(S−fx)·(S−fy) + tr·fx·(S−fy) + bl·(S−fx)·fy + br·fx·fy) / (S·S))`,
  the four weights summing to `S·S` exactly. A channel value is at most 255, so the weighted sum is at
  most `255·S·S = 16,711,680 < 2³¹` — the accumulator stays in `u32`, no float, no wrap. Rounding adds
  `S·S/2` before the divide.

Refusals reuse the family's own names — a zero dimension refuses `EmptyImage`, a target past the
codec's pixel ceiling refuses `OutOfBounds` — so no new error kind is minted.

## The algebra the witness proves

Bilinear is proven by the identities it must obey, so an index or weight bug is caught regardless of
the exact arithmetic:

1. **Identity size byte-identical** — a bilinear resize to the same `w×h` recovers the source
   byte-for-byte (the half-pixel map lands on integer pixels with zero fractional weight).
2. **A solid color stays that exact color at any size** — every corner equal to `V` blends to `V` with
   no drift, up *or* down (the no-drift invariant, and the one bilinear shares with the box filter).
3. **A clean midpoint blend** — a 2×1 image `[A, B]` upscaled across to 3 wide gives `[A, (A+B)/2, B]`:
   the outer output pixels clamp to the exact source pixels, the center lands exactly halfway and reads
   the exact average. Concrete red `0` and `100` blend to `50` — an unambiguous check of the blend.
4. **Alpha blends alongside the colors** — the fourth channel interpolates by the same weights, so a
   varying-alpha image carries a blended alpha, never a dropped or forced one.
5. **Purity** — the source is untouched (first and last pixels exactly as crafted).
6. **Still an open image** — a bilinearly-resized image re-encodes and round-trips through the QOI
   codec byte-for-byte, so smooth resampling stands on the open module the quest built.
7. **Named refusals** — a zero-dimension target refuses `EmptyImage`; a target past the pixel ceiling
   refuses `OutOfBounds`.

## What stays a named horizon

- **Lanczos / cubic resampling** — a wider kernel (more than four taps) for the sharpest resample;
  bilinear is the honest two-tap blend, the same way `scale_area` is the honest box filter and
  `rotate_quarter` is the honest exact-angle rotation. Named, not half-built.
- **A general-angle hue rotation** (fixed-point cos/sin about the luma axis, reusing `luma_of`) stays
  the other standing Photos horizon from HUNK21/HUNK23.

No network, no key, no funds — a pure function over a decoded grid.
