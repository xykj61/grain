# Fill ALES81 — Lotus's bit-crusher: drop the low bits, the first DRIVE map that is not odd

**Stamp:** `20260814.211634` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; ALES78's hard-clip drive and ALES80's wavefolder each named the bit-crush / decimator as a next member of the DRIVE family)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES81**
**Kin:** [`../lotus/fold.rye`](../lotus/fold.rye) (ALES80 — the sibling waveshaper, its magnitude folded where this one's low bits fall away) · [`../lotus/drive.rye`](../lotus/drive.rye) (ALES78 — the DRIVE family's open, whose pre-gain this rung composes with rather than embeds) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, the one true saturate)

---

## Why this rung

ALES78 opened the DRIVE family with the hard clip, ALES79 rounded its corner into an overdrive, and ALES80 turned the ceiling into a mirror. All three shape **amplitude** while holding the sample's **resolution** — every one of the 65,536 i16 codes still crosses. The bit-crusher shapes the other axis: it **drops the low bits**, so a signal that entered at sixteen bits leaves at eight, or four, or one — the coarse, gritty, quantized voice of an early sampler, a lo-fi drum machine, a digital signal starved of resolution. Lindy-first, the primitive is the plainest imaginable — clear the low bits of an integer; crux-first, the decisive recognition is that this is the DRIVE family's **first map that is not odd**, and that asymmetry is the honest fingerprint of two's-complement bit reduction, not a flaw to hide.

## The crux — drop the low bits, and the map is no longer odd

A bit-crush to `bits` bits keeps the top `bits` bits of each sample and clears the rest. Clearing the low `s = 16 − bits` bits of a two's-complement integer is exactly **flooring to the grid of step `2^s`** — floor **toward negative infinity**, the meaning of an arithmetic right-shift on a signed value:

```
step   = 1 << (16 − bits)          // the grid spacing; bits ∈ [1, 16], step ∈ [1, 32768]
q      = ⌊ x / step ⌋ · step        // divFloor, toward −∞ — the literal low-bit drop
```

Every prior DRIVE map is **odd** (`f(−x) = −f(x)`): the clip, the overdrive, and the wavefolder each shape the *magnitude* and carry the sign. The bit-crush does not — it floors the *signed value*, so `crush(−100) = −256` while `crush(100) = 0` at `bits = 8`. That difference is a faint downward DC offset, and it is precisely what real bit reduction does: two's-complement truncation floors, it does not round toward zero. The rung states that positively — **the low-bit drop floors toward negative infinity, the true signature of bit reduction** — rather than dressing the map in a symmetry it does not have.

## Safe by construction, idempotent, memoryless

The grid of step `2^s` (`s ≤ 15`) includes `sample_min = −2^15` (a multiple of every such step) and every reachable grid point sits at or below `x`, so `q ∈ [sample_min, sample_max]` **before** the write — the shape does the bounding, and the `saturate` that follows is a documented no-op, exactly as the sibling drives. The map is **idempotent**: a grid point crushes to itself, so `crush(crush(x)) = crush(x)` — quantizing twice is quantizing once. It is **memoryless**: every output depends only on its own input, so the in-place read-then-write at one index touches nothing another step needs, and crushing a span block by block equals crushing it whole.

## Shape

`lotus/crush.rye` offers `crush(clip, start, count, bits)` — it bit-crushes `count` samples from `start` in place to `bits` bits of resolution. It carries **no** pre-gain and **no** ceiling: it is the DRIVE family's purest member, changing resolution alone. A keeper who wants a boosted crush runs ALES78's `drive` and then `crush` over the same span — both are in-place span maps, so they compose without new machinery, the way ALES4's fade composes with ALES3's mix into a crossfade. Faults, one consistent name each:

- `BadBits` — a resolution outside `[1, 16]` (zero bits name no signal; past sixteen there are no low bits to drop). Refused, no write.
- `BadRange` — a span outside the current samples (the suite's shared span law). Refused, no write.

`bits = 16` is the **identity** — a shift of zero, the crush that crushes nothing — proving the map generalizes the untouched clip.

## The laws to prove

1. **`bits = 16` is the identity** — a shift of zero clears no bits; the clip is returned byte-for-byte.
2. **Drop-the-low-bits by hand** — `bits = 8` (step 256): `0→0`, `255→0`, `256→256`, `500→256`, `−1→−256`, `−256→−256`, `−257→−512`. The floor read directly.
3. **The one-bit floor** — `bits = 1` (step 32768): every non-negative sample floors to `0`, every negative to `sample_min` — a real two-level output `{0, −32768}`.
4. **Every output is a multiple of the step, and the map is idempotent** — each crushed sample lands on the grid (`q mod step == 0`), and crushing an already-crushed clip changes nothing.
5. **The rail is preserved** — `sample_min` is a grid point (fixed); `sample_max` floors to `32512` at `bits = 8`; under any legal `bits` every output stays within `[sample_min, sample_max]`, never overflowing.
6. **The map is not odd — the honest DC signature** — exhibit `crush(−100, 8) = −256 ≠ −crush(100, 8) = 0`, the downward floor that no odd waveshaper makes.
7. **The span discipline holds** — only `[start, count)` changes; samples outside are untouched.
8. **Each fault refuses by name** — `BadBits` (on `0` and on `17`) and `BadRange`, each before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The resolution is a bit count, the grid a power-of-two step in sample units, the shape a quantizer, instantaneous — no attack/release, no dither, no anti-aliasing (a bit-crush is a heavy harmonic generator, and its quantization noise folds in the i16 domain exactly as any integer decimator's). One divide, one multiply per sample. No pre-gain, no delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate.

## What this opens

The DRIVE family now holds four shapes — the wall (hard clip), the rounded shoulder (overdrive), the mirror (wavefolder), and the coarse grid (bit-crush). Its remaining named rung changes the map once more: an **asymmetric / tube drive** (a different knee per sign, so even harmonics arise) — the other member the sibling drives named. A **sample-rate decimator** (hold each sample across a run, crushing time rather than amplitude) is the bit-crush's twin on the other axis. Each is this waveshaper with its map changed.

## Witness

`tools/ales_crush_witness.rish` — builds `lotus/crush.rye`, runs its selftest, and asserts the single `GREEN ales-crush` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_crush_witness.rish
```
