# HUNK23 — an exact 120° hue turn for the open image module

**Stamp:** `20260813.172645` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round (agent-doable, Lindy-first crux-first)
**Season A · waymark HUNK · journey Open Image** — beside the Photos app's crop · orient · scale · adjust · saturate.
**Kin:** [`../image/photos.rye`](../image/photos.rye) · [`20260813-171223_hunk-photos-scale-area-exploration.md`](20260813-171223_hunk-photos-scale-area-exploration.md) · [`20260813-170307_hunk-photos-saturate-exploration.md`](20260813-170307_hunk-photos-saturate-exploration.md)

---

## Why this rung

The saturate and scale-area rungs each named the same next horizon: a **hue rotation** — the modular color-wheel turn a Photos app spends beside brightness, contrast, and saturation. HUNK21 flagged it honestly as "harder to bound cleanly in integer math — named, not half-built," because a general-angle luma-preserving rotation wants `cos`/`sin`, and clean fixed-point trig with byte-exact proofs is a real design problem, not a leaf verb.

Yet the color wheel has three points where the turn is **exactly integer**: the 120° thirds. A hue rotation by exactly 120° is a **cyclic rotation of the three color channels** — no trig, no rounding, no clamp. It is the exact special case of the general rotation, and it stands to the full hue slider precisely as `rotate_quarter` stands to a general affine rotation: the provable, bounded core landed today, the fractional angle left an honest horizon.

Lindy-first, crux-first points here. Among the doors the last two rungs named, the 120° turn is the one that (1) delivers a real, useful hue verb the Photos app wants, and (2) admits the same **algebra-provable, integer-only** proof the neighboring rungs earned — the register the whole module keeps.

## The verb

`hue_turn(allocator, pm, thirds) → Pixmap` — rotate every pixel's hue by exactly `120° · thirds` around the color wheel, leaving alpha and the pixel count untouched, returning a fresh Pixmap. Pure: the source is never mutated.

The turn is a channel permutation keyed by `thirds % 3`:

| `thirds % 3` | Turn | Channel map (new ← old) |
|---|---|---|
| 0 | identity | `(r, g, b)` |
| 1 | +120° | `(b, r, g)` |
| 2 | +240° | `(g, b, r)` |

A pure primary confirms the direction and the exact 120° step: red `(255,0,0)` → green `(0,255,0)` → blue `(0,0,255)` → red, each a 120° advance on the HSV wheel. Because the map only *permutes* the three color channels, the pixel's **maximum** and **minimum** channel are unchanged — so HSV **value** (`= max`) and **chroma** (`= max − min`) are preserved exactly; only the hue turns. Any `thirds` is valid (the modulo is total, exactly as `rotate_quarter` accepts any `turns`), so there is no bad-argument refusal — only a degenerate zero-dimension image refuses `EmptyImage`.

## The algebra it must obey (the proof, not one arithmetic)

1. **Identity** — `hue_turn(pm, 0)` (and any `thirds` divisible by 3) recovers the source byte-for-byte.
2. **Order three** — `hue_turn` composed three times is the identity, byte-for-byte; and `turn(1)` then `turn(2)` is the identity. The full circle closes, exactly — the same order-N-composition proof `rotate_quarter` earns for a quarter turn.
3. **`turn(2) = turn(1) ∘ turn(1)`** — the two-thirds turn equals two single thirds, so the `thirds` argument is honest.
4. **Direction** — a pure red pixel maps red → green → blue → red across `turn(1)`, `turn(2)`, `turn(3)`, verifying the +120° sense unambiguously.
5. **Value and chroma preserved** — for every pixel, `max(out.rgb) == max(in.rgb)` and `min(out.rgb) == min(in.rgb)`; only hue moves.
6. **Gray is a fixed point** — a pixel with `r == g == b` is unchanged at every turn (its chroma is zero).
7. **Alpha untouched** — the alpha channel passes through at every turn.
8. **Still open** — a hue-turned image re-encodes and round-trips through the QOI codec byte-for-byte.
9. **Pure** — the source is never mutated.
10. **Named refusal** — a zero-dimension image refuses `EmptyImage`.

## What it is not

The **general-angle** hue rotation (a fixed-point `cos`/`sin` turn about the luma axis, reusing `luma_of`) and a fractional-coverage **bilinear** resampler stay named horizons on this same module — each is genuinely harder to bound cleanly in integer math, and half-building either here would cheapen the exact proof this rung earns. `hue_turn` is the color wheel's three exact stops: integer, bounded, and provable today.

## Definition of done

Opening triad present; ≥2 invariants per new function, each `// invariant:`; no `@memcpy`, no compound `assert(a and b)`; `tame_style_check` bans clean; width exit 0; the new `run_hue_turn` selftest GREEN and the five prior image-photos selftests still GREEN beneath it; a new `tools/hunk_photos_hue_turn_witness.rish` GREEN. No network, no key, no funds — hardware buys stay custody gates #2/#3.
