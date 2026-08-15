# Fill ALES80 — Lotus's wavefolder: the excess past the ceiling reflects back, a mirror not a wall

**Stamp:** `20260814.210615` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; ALES78's hard-clip drive and ALES79's overdrive each named the wavefolder as a next member of the DRIVE family)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES80**
**Kin:** [`../lotus/drive.rye`](../lotus/drive.rye) (ALES78 — the pre-gain, reused verbatim, and the ceiling that the fold reflects at rather than pins to) · [`../lotus/soft_drive.rye`](../lotus/soft_drive.rye) (ALES79 — the sibling waveshaper, its shoulder rounded where this one folds) · [`../lotus/fader.rye`](../lotus/fader.rye) (ALES6 — the num/den gain in i64) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, the one true saturate)

---

## Why this rung

ALES78 opened the DRIVE family with the hard clip — a boost forced into a ceiling, the excess pinned flat. ALES79 rounded that corner into an overdrive. Both members treat the ceiling as a **wall**: a boosted sample that reaches it stops there. The wavefolder treats the ceiling as a **mirror** — the excess past the ceiling reflects back down into the field, and if the boost is strong enough the wave folds again and again. Folding multiplies harmonics far past what a clip makes, the bright metallic voice of a West-Coast synth's timbre and a fuzz pushed past sanity. Lindy-first, the durable primitive (ALES78's pre-gain and ceiling) is already proven; crux-first, the decisive recognition is a single sentence read against the clip already in the tree.

## The crux — a hard clip is a wall, a wavefolder is a mirror

**The two rungs agree exactly below the ceiling and diverge above it.** For a boosted magnitude `m = |boosted|` and a ceiling `ceil`:

- `m ≤ ceil` → `m` (clean pass — a wavefolder *is* the hard clip until the signal first touches the ceiling);
- above the ceiling the hard clip **pins** to `ceil`, and the wavefolder **reflects** — the part above the ceiling folds back down, reaches silence at `2·ceil`, folds back up to the ceiling at `3·ceil`, and so on: a triangle wave in `m` with period `2·ceil`.

The fold is one exact integer expression — the triangle on the non-negative magnitude, the sign carried:

```
p = m mod (2·ceil)
folded = if p ≤ ceil then p else 2·ceil − p
```

Every term is exact over non-negative integers (`@mod` of a non-negative magnitude by a positive period is the ordinary remainder). The pre-gain is ALES78's verbatim (ALES6's `num/den` into i64); only the shape past the ceiling is new.

## Safe by construction, odd, memoryless

The folded magnitude sits in `[0, ceil]` for every `m` — the triangle never rises above its peak — so the shaped value lands in `[−ceil, ceil] ⊆ [sample_min, sample_max]` **before** the write: the shape does the bounding, and the `saturate` that follows is a documented no-op, exactly as the hard clip's. The map is **odd**, `wavefold(−x) = −wavefold(x)` (the magnitude is folded, the boosted sign carried), so a symmetric input yields a symmetric output — odd harmonics, richly multiplied. It is **memoryless**: every output depends only on its own input.

## Shape

`lotus/fold.rye` offers `wavefold(clip, start, count, num, den, ceil)` — it wavefolds `count` samples from `start` in place. Faults, one consistent name each, coinciding by name with the sibling drives (Zig merges error sets by name), so a composer sees one consistent fault whichever drive refuses:

- `BadGain` — ALES78's gain faults verbatim (zero denominator, below-unity gain, numerator past `drive.max_drive_num`).
- `BadCeiling` — a ceiling outside `[1, sample_max]` (ALES49's bound). The wavefolder has **no knee**, so it adds no new fault name — simpler than ALES79.
- `BadRange` — a span outside the current samples.

## The laws to prove

1. **Below the ceiling the fold is the hard clip** — with a gain low enough that no boosted sample reaches `ceil`, the wavefold reproduces ALES78's hard drive byte-for-byte (both pass clean; proven against the real ALES78).
2. **The single fold reflects** — `ceil = 1000`, gain ×1/1: `800` clean, `1000` at the peak, `1200→800`, `1500→500`, `2000→0` (the fold touches silence). Signs carried on the negatives.
3. **The double fold continues the triangle** — `2500→500`, `3000→1000` (`ceil = 1000`): past `2·ceil` the wave folds back up, the triangle unbroken.
4. **The fold reaches zero at even multiples of the ceiling** — where a hard clip would pin loudest, the wavefolder nulls (`m = 2·ceil, 4·ceil → 0`), the distinctive fold voice a clip can never make.
5. **The output never leaves `[−ceil, ceil]`** — under a heavy ×8 drive every folded output stays within `±ceil`, its sign held.
6. **The shape is odd** — `wavefold(−x) = −wavefold(x)`.
7. **The span discipline holds** — only `[start, count)` changes.
8. **Each fault refuses by name** — `BadGain`, `BadCeiling`, `BadRange`, each before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The gain a rational (`unity = 1/1`), the ceiling a magnitude in sample units (not decibels), the shape a triangle waveshaper, instantaneous — no attack/release, no anti-aliasing (folding is a heavy harmonic generator, and the harmonics fold in the i16 domain exactly as any integer waveshaper's). One multiply, one divide, one modulo and one compare per sample. No delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate.

## What this opens

The drive family now holds three shapes over one pre-gain — the wall (hard clip), the rounded shoulder (overdrive), and the mirror (wavefolder). Its remaining named rungs each change the map again: an **asymmetric / tube drive** (a different knee per sign, so even harmonics arise), and a **bit-crush / decimator** (quantization drive). Each is this waveshaper with its map changed.

## Witness

`tools/ales_fold_witness.rish` — builds `lotus/fold.rye`, runs its selftest (re-proving the ALES78 hard drive beside it), and asserts the single `GREEN ales-fold` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_fold_witness.rish
```
