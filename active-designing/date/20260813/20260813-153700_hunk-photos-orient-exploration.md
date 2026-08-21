# HUNK8 — Photos gestures past crop: orient (rotate · flip)

**Stamp:** `20260813.153700` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — a fresh HUNK quest opens past the sprite-marketplace close
**Season:** A (Hardware & Right-to-Repair) · **Waymark:** HUNK · **Journey:** Photos app, past the crop
**Kin:** [`../image/photos.rye`](../image/photos.rye) (HUNK3 crop) · [`../image/qoi.rye`](../image/qoi.rye) (HUNK0 codec) · [`20260813-144218_hunk-season-a-open-image-exploration.md`](20260813-144218_hunk-season-a-open-image-exploration.md)

---

## Why this round

HUNK3 gave the Photos app its first verb — a crop, a pure bounded function over the decoded RGBA grid. The sprite-marketplace quest (HUNK4–HUNK7) then stood the McMaster-Carr one-sheet trick over that same open module. With the marketplace whole, the next Lindy-first crux on the *whole* road is the Photos app's next everyday gestures: **orient the image** — rotate it in quarter turns, mirror it left-to-right, mirror it top-to-bottom. Every phone's Photos app carries these; the tree earns them on its own open grid, no proprietary codec beneath and no permission asked to move a pixel.

## What lands

Three new pure verbs added **additively** to `image/photos.rye`, beside `crop` (which stays untouched, its witness still GREEN):

- **`flip_h`** — mirror horizontally: pixel `(x, y)` moves to `(w-1-x, y)`.
- **`flip_v`** — mirror vertically: pixel `(x, y)` moves to `(x, h-1-y)`.
- **`rotate_quarter(turns)`** — rotate clockwise by `turns mod 4` quarter turns; a 90° or 270° turn swaps width and height, a 180° turn keeps them.

Each returns a **fresh** `Pixmap`, leaving the source untouched (pure). Each refuses a degenerate image (`EmptyImage`, when width or height is zero) rather than allocating a zero grid. Output pixel count equals input pixel count, so the codec's pixel ceiling already holds.

## How correctness is proven — composition over hand-checked formulas

Rather than trust one hand-derived index formula per verb, the selftest proves the **algebra** the gestures must obey, which pins any mapping bug regardless of the exact arithmetic:

- **`rotate_quarter(1)` four times = identity**, byte-for-byte — a real quarter turn, composed to a full turn.
- **`rotate_quarter(2)` = `flip_h(flip_v(pm))`** — a half turn is both mirrors.
- **`flip_h(flip_h(pm))` = identity** and **`flip_v(flip_v(pm))` = identity** — each mirror is its own inverse.
- **A 90° turn swaps dimensions** (`w×h → h×w`), so a turn is never a no-op or a mere transpose masquerade.
- **A concrete corner** on a position-tagged image: after a 90° clockwise turn, the source top-left pixel lands at the output top-right — a single unambiguous witness that the turn goes clockwise, not counter.
- **Still an open image**: a rotated image re-encodes and round-trips through the codec byte-for-byte.
- **Refusals named**: a zero-dimension image refuses `EmptyImage` for every verb.

## Bounds and TAME

- `u32` dimensions throughout; the products `w×h` never exceed `qoi.qoi_max_pixels` (the input already decoded within it).
- `copy_disjoint` per pixel or per row — never a bare memcpy.
- Two positive invariants per function (four-bytes-per-pixel at construction, matching pixel count at postcondition).
- No network, no key, no funds — a user-facing verb on the open module.

## Witness

`tools/hunk_photos_orient_witness.rish` builds `image/photos.rye` and asserts the new `GREEN image-photos-orient` line, its composition claims, and the open round-trip. HUNK3's crop selftest still runs and prints its own GREEN line in the same binary, so `tools/hunk_photos_witness.rish` stays GREEN unchanged.

---

*A photo you can turn in your hand is a small freedom; may it stay pure, bounded, and open every time it turns.*
