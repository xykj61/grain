# Fill ALES78 — Lotus's hard-clip drive: a pre-gain into ALES49's ceiling

**Stamp:** `20260814.204949` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the modulation family closed at ALES77, and this opens the next durable family — DRIVE — with its simplest provable member, the hard clip)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES78**
**Kin:** [`../lotus/limit.rye`](../lotus/limit.rye) (ALES49 — the ceiling law `pin to sign(x)·ceil`, reused here over the BOOSTED sample) · [`../lotus/fader.rye`](../lotus/fader.rye) (ALES6/ALES8 — the num/den gain in the i64 accumulator, the drive's pre-gain) · [`../lotus/tremolo.rye`](../lotus/tremolo.rye) (ALES74 — the amplitude kin whose unity boundary this rung reads in reverse) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, the one true saturate)

---

## Why this rung

The modulation family closed at ALES77: the triangle LFO turned a delay (chorus, vibrato, flanger), an amplitude (tremolo), a bipolar carrier (ring modulator), and a stereo position under both pan laws (auto-pan, equal-power auto-pan). Three LFO targets stand proven. Lindy-first, the durable next move is not one more modulation rung but the opening of the next **family** — and the family a creative suite most owes a musician after EQ, dynamics, and modulation is **DRIVE**: harmonic generation, the grit of an overdriven amp and the crunch of a fuzz.

Crux-first, a family opens cleanest at its simplest member whose one law every richer member later refines — exactly as the dynamics family opened at the brickwall limiter (ALES49), "because every richer shape rests on it." The drive family's floor is the **hard clip**: a boost hard enough to force a signal into a ceiling, where the flat top of the clipped wave is its harmonic voice. A soft knee, a wavefolder, an asymmetric tube — each is a hard clip with a curve added; none of them reads without this one first.

## The crux — drive is pre-gain into ALES49's ceiling

The whole rung is one recognition, the twin of the tremolo's own boundary read in reverse:

- ALES74's **tremolo** forbids its gain from crossing unity (`centre + depth ≤ glide_scale`) precisely so a loud sample can never be pushed past the rail — that is what keeps its `saturate` a proven no-op.
- The **drive** does the opposite: it *invites* the gain past unity and lets a ceiling catch what overflows. The caught overflow is not an error to prevent — it **is** the effect.

So each sample is a plain `y[i] = pin(x[i]·num/den, ±ceil)`:

- the pre-gain is ALES6's fader arithmetic **verbatim** — `@divTrunc(dry · num, den)` in i64, `num`/`den` a rational at least unity (`num ≥ den ≥ 1`, a drive boosts, it never attenuates — that is the fader's job);
- the ceiling is ALES49's limiter law **verbatim** — a value past `±ceil` is pinned to the ceiling with its sign held, one within passes at its boosted value.

No new gain arithmetic and no new clip law; only the ceiling now falls over the **boosted** sample rather than the dry one. That single shift is the drive.

## The one genuine departure — the ceiling is a real clip

Unlike the tremolo's, the drive's ceiling is a **genuine** clip, not a no-op — the whole point is that the boosted sample crosses it. Yet the write is still safe by construction: the pin lands every output in `[−ceil, ceil] ⊆ [sample_min, sample_max]` **before** the write, so the `saturate` that follows is a documented no-op over an already-pinned value. The clip is the pin; the saturate merely restates the bound the pin already holds.

The hard clipper is an **odd** function — `drive(−x) = −drive(x)` — so a symmetric input drives to a symmetric output: odd harmonics, the honest character of a symmetric clip, never an even-order asymmetry the plain clip does not make. And the drive is **memoryless**: every output depends only on its own input sample, so the in-place read-then-write at one index touches nothing another step needs (the tremolo/limiter discipline exactly).

## Shape

`lotus/drive.rye` offers `drive(clip, start, count, num, den, ceil)` — it drives `count` samples from `start` in place. Faults, one consistent name each:

- `BadGain` — a zero denominator, a gain below unity (`num < den` — the tremolo's boundary in reverse), or a numerator past `max_drive_num` (`1 << 20`, which bounds the pre-gain product safely inside i64; since `num ≥ den`, it bounds `den` too).
- `BadCeiling` — a ceiling outside `[1, sample_max]` (ALES49's exact bound, coinciding by name).
- `BadRange` — a span outside the current samples (ALES49's bound, coinciding by name).

## The laws to prove

1. **A unity drive at the rail is the identity** — `1/1`, `ceil = sample_max`: the clip passes byte-for-byte over the symmetric rail. (`sample_min` has magnitude `32768 > sample_max`, so a symmetric ceiling pins it to `−sample_max` by design, exactly as the limiter — the identity is over the symmetric rail, not the asymmetric corner.)
2. **The ceiling is never crossed and the sign is held** — a `×4` drive into a low ceiling clips so every output magnitude is `≤ ceil`, every sign matches the input, and each boosted-past-ceiling sample lands exactly on `±ceil` (the crux — the harmonic flat top).
3. **A hand-computed drive matches exactly** — `×3/2` into `900`: some samples pass scaled, some pin, `@divTrunc` toward zero as the fader.
4. **The clipper is odd** — `drive(−x) = −drive(x)`: a symmetric input drives to a symmetric output (odd harmonics).
5. **An extreme drive squares the wave** — the maximum boost pins every non-zero sample to `±ceil` (the square-wave limit), zeros stay silent.
6. **The span discipline holds** — driving a sub-span leaves samples outside `[start, count)` untouched.
7. **Each fault refuses by name** — `BadGain` (zero den, below-unity gain, oversized numerator), `BadCeiling` (zero, over-rail), `BadRange` (span past the end), each before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM on one bench, siloed to `lotus/`. The drive gain is a rational (`unity = 1/1`), the ceiling a magnitude in sample units (not decibels), the clip instantaneous — no attack/release, no anti-aliasing (a hard clip's harmonics fold in the i16 domain exactly as any integer clipper's). One multiply, one divide, one sign-carried pin per sample. No delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate.

## What this opens

The drive family's next rungs each rest on this floor: a **soft-clip / overdrive** with a knee (a smooth curve into the ceiling), a **wavefolder** (reflection past the ceiling rather than a pin), an **asymmetric / tube drive** (different ceilings per sign, even harmonics), and a **bit-crush / decimator** (quantization drive). Each is this hard clip with a shape added.

## Witness

`tools/ales_drive_witness.rish` — builds `lotus/drive.rye`, runs its selftest, and asserts the single `GREEN ales-drive` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_drive_witness.rish
```
