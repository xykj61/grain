# Fill ALES82 — Lotus's asymmetric tube drive: a different ceiling per sign, the first clip that is not odd

**Stamp:** `20260814.212318` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; ALES78, ALES79, ALES80, and ALES81 each named the asymmetric / tube drive as the next member of the DRIVE family)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES82**
**Kin:** [`../lotus/drive.rye`](../lotus/drive.rye) (ALES78 — the hard clip this rung generalizes: one ceiling both signs becomes one ceiling per sign) · [`../lotus/soft_drive.rye`](../lotus/soft_drive.rye) (ALES79 — the sibling that rounds the corner while staying odd) · [`../lotus/crush.rye`](../lotus/crush.rye) (ALES81 — the family's other not-odd map, whose asymmetry is a downward floor where this one's is an uneven rail) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, the one true saturate)

---

## Why this rung

ALES78 opened the DRIVE family with the hard clip, ALES79 rounded its corner into an overdrive, ALES80 turned the ceiling into a mirror, and ALES81 dropped the low bits. Three of those four shape the sample's magnitude and carry its sign — they are **odd** functions (`f(−x) = −f(x)`), so a symmetric input drives to a symmetric output and only **odd** harmonics arise. The tube drive breaks that symmetry on purpose: it pins the positive half of the wave at one ceiling and the negative half at another. A real vacuum-tube stage clips harder on one polarity than the other, and that uneven clipping is precisely where a tube's warm **even-order** harmonics are born — the second harmonic that a symmetric transistor clip never makes. Lindy-first, asymmetric drive is the oldest reason engineers reach for a tube at all; crux-first, the decisive recognition is that **a different ceiling per sign is the plainest asymmetry there is, and a hard clip is the tube drive whose two ceilings are equal.**

## The crux — one ceiling per sign, and the map is no longer odd

ALES78 pins every boosted sample to the same magnitude `ceil`, both signs. The tube drive splits that one ceiling into two — `ceil_pos` for the positive half, `ceil_neg` for the negative — and pins each half to its own:

```
boosted = ⌊ x · num/den ⌋           // ALES78's pre-gain, verbatim (ALES6's num/den into i64)
y = if boosted >  ceil_pos then  ceil_pos
    else if boosted < −ceil_neg then −ceil_neg
    else boosted
```

When `ceil_pos == ceil_neg` the two branches collapse into ALES78's single ceiling and the tube drive **reproduces the hard clip byte-for-byte** — the family recognition, and the honest proof that this rung only generalizes, never replaces. When the two differ, the map is **not odd**: `tube(1000) = ceil_pos` while `tube(−1000) = −ceil_neg ≠ −ceil_pos`, so a symmetric input drives to an asymmetric output. That asymmetry is a DC offset and a full set of even harmonics — stated positively, **the uneven rail is the tube's honest even-harmonic signature**, not a flaw to correct. It is the sibling of ALES81's not-odd map: the bit-crush floors downward, the tube clips unevenly, and neither dresses itself in a symmetry it does not have.

## Safe by construction, memoryless

Each ceiling is checked into `[1, sample_max]` exactly as ALES78's single ceiling, so the pinned output lands in `[−ceil_neg, ceil_pos] ⊆ [sample_min, sample_max]` **before** the write — the pin does the bounding, and the `saturate` that follows is a documented no-op over an already-pinned value. The pre-gain runs in i64 under ALES78's `max_drive_num` bound, so `x · num` never overflows before the pin. The map is **memoryless**: every output depends only on its own input, so the in-place read-then-write at one index touches nothing another step needs, and driving a span block by block equals driving it whole.

## Shape

`lotus/tube.rye` offers `tube(clip, start, count, num, den, ceil_pos, ceil_neg)` — it boosts `count` samples from `start` by the rational gain `num`/`den` (at least unity, ALES78's law) and pins the positive half to `ceil_pos`, the negative half to `−ceil_neg`. It reuses ALES78's pre-gain and gain faults verbatim. Faults, one consistent name each:

- `BadGain` — a zero denominator, a below-unity gain (`num < den` — a drive boosts, never attenuates), or a numerator past `drive.max_drive_num`. ALES78's three gain faults, verbatim, so a composer sees one consistent fault.
- `BadCeiling` — **either** ceiling below one sample unit or above `sample_max`. The same bound as ALES78's single ceiling, applied to each side.
- `BadRange` — a span outside the current samples (the suite's shared span law).

`ceil_pos == ceil_neg` is the **hard clip** — proving the tube drive generalizes ALES78. A keeper who wants an asymmetric overdrive with a rounded corner composes this with ALES79 over the same span, both in-place span maps.

## The laws to prove

1. **Equal ceilings are ALES78's hard clip** — with `ceil_pos == ceil_neg` the tube drive reproduces the real ALES78 hard drive byte-for-byte, at the same gain, over a signal that both passes and clips (proven against the real `drive.drive`).
2. **A hand-computed asymmetric clip** — `ceil_pos = 1500`, `ceil_neg = 800`, gain ×2: `500→1000` (passes), `1000→1500` (pins positive), `−300→−600` (passes), `−600→−800` (pins negative), `−100→−200` (passes) — the two rails read directly.
3. **The map is not odd — the honest even-harmonic signature** — exhibit `tube(1000) = ceil_pos` and `tube(−1000) = −ceil_neg` with `ceil_pos ≠ ceil_neg`, so `tube(−x) ≠ −tube(x)`: the uneven rail no odd clipper makes.
4. **Each half stays under its own ceiling, sign held** — under a heavy drive every positive output is at most `ceil_pos`, every negative at least `−ceil_neg`, and no sample flips sign.
5. **A symmetric-ceiling drive stays odd** — the degenerate `ceil_pos == ceil_neg` recovers `tube(−x) = −tube(x)`, so the family's odd members are the special case where the two rails meet.
6. **The span discipline holds** — only `[start, count)` changes; samples outside are untouched.
7. **Each fault refuses by name** — `BadGain` (zero den, below unity, oversized numerator), `BadCeiling` (either side zero or over-rail), `BadRange`, each before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The gain is a rational `num`/`den` (unity = 1/1), the two ceilings magnitudes in sample units (not decibels), the shape a piecewise-constant asymmetric clip, instantaneous — no attack/release, no anti-aliasing (a hard asymmetric clip is a heavy harmonic generator, and its harmonics fold in the i16 domain exactly as any integer clipper's). One multiply, one divide, one sign-aware pin per sample. No delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate.

## What this opens

The DRIVE family now holds five shapes — the wall (hard clip), the rounded shoulder (overdrive), the mirror (wavefolder), the coarse grid (bit-crush), and the uneven rail (tube). Its remaining named rung is the **sample-rate decimator** (hold each sample across a run, crushing time rather than amplitude) — the bit-crush's twin on the other axis. Each is this waveshaper with its map changed.

## Witness

`tools/ales_tube_witness.rish` — builds `lotus/tube.rye`, runs its selftest, and asserts the single `GREEN ales-tube` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_tube_witness.rish
```
