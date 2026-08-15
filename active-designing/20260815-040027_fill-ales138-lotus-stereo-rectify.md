# Fill ALES138 — `lotus/stereo_rectify.rye`, the full-wave rectifier carried into stereo, one shared fold at zero

**Stamp:** `20260815.040027` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES138**
**Kin:** [`20260815-035333_fill-ales137-lotus-stereo-decimate.md`](20260815-035333_fill-ales137-lotus-stereo-decimate.md) · [`20260814-213747_fill-ales84-lotus-full-wave-rectifier.md`](20260814-213747_fill-ales84-lotus-full-wave-rectifier.md)

---

## Where the ladder stands

The stereo **nonlinear** class now holds the whole DRIVE family across three axes — amplitude (pinned ALES132, rounded ALES133, reflected ALES134, unevenly pinned ALES135), resolution (crushed ALES136), and time (decimated ALES137). Those readings shape or hold a wave through **odd** and **not-odd** maps. This rung opens the class's other half: ALES84's **full-wave rectifier**, `y = |x|`, the plainest **even**-harmonic generator — it folds the whole negative half of the wave up onto the positive side, turning a symmetric wave into a one-sided, DC-heavy signal at double the frequency. A Lotus master is a `StereoClip` (ALES10), two Clips heard together whose defining invariant is that left and right hold the same length; this rung carries the rectifier into stereo the plain way — run ALES84's proven mono `rectify` on each channel over the same span, so one fold at zero lands on both speakers together.

## The crux this round — the strongest image-break in the family

The decimator (ALES137) was the honest **reverse** of the not-odd members: it copies an anchor, computes no new value, and so **preserves** the stereo image. The rectifier is the opposite pole. Because `|x|` is an **even** map, it does not merely break the inter-channel antisymmetry the way crush and tube did — it **collapses** it. An out-of-phase master (right the exact negation of left) rectified through the same fold comes back with right = `|−left|` = `|left|` = left: the two channels become **identical**, the stereo image folded down to mono on the magnitude. That is the honest fingerprint of a full-wave rectifier read in the stereo field, stated positively — the even map's whole point is that `+a` and `−a` land on the same `a`, so a stereo pair that was antisymmetric lands on one signal. Yet the **ratio holds**: `|2x| = 2|x|`, so a 1:2 master keeps its 1:2 ratio (both sides non-negative after), and an identical-channel master stays identical.

## The crux, as a lift

`stereo_rectify(sc, start, count)` rectifies `[start, start+count)` in **both** channels of a `StereoClip`, running ALES84's proven mono `rectify` on each. The rectifier takes **no** gain, **no** ceiling, **no** resolution — an absolute value has no parameter that could be illegal — so this is the plainest lift in the whole class: it names exactly one fault. It validates the span **once** against the shared length before either channel is mutated (`BadRange` on a span past the samples), so a refusal never rectifies one channel and leaves the other signed. `RectifyError` is reused whole — the stereo lift adds no fault.

## The four laws proven

- **THE STEREO RECTIFY LAW** — each channel equals ALES84's mono `rectify` over the same span, **byte for byte**: every output is `|x|` pinned to the rail (sample_min's magnitude 32768 saturating to sample_max, the one place `|x|` leaves the i16 rail).
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a rectify writes values only.
- **THE IMAGE-COLLAPSE LAW** — because `|x|` is an **even** map, an out-of-phase master (right = −left) comes back with **identical** channels (right = |−left| = |left| = left), the antisymmetry collapsed to mono rather than merely broken; yet the ratio holds (`|2x| = 2|x|`, a 1:2 master keeping its ratio), an identical-channel master stays identical, every output on both channels is **non-negative**, and the map is **idempotent** (a non-negative sample rectifies to itself, so twice equals once).
- **THE ATOMICITY / DEGENERATE LAW** — a refusal (`BadRange`) leaves **both** channels byte for byte untouched and still balanced; `count = 0` is the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES84's own `rectify`, each output at most its input's magnitude, never a length; the shape is a full-wave absolute value, instantaneous (no attack/release, no anti-aliasing — a rectifier doubles frequency and its even harmonics fold in the i16 domain exactly as any diode rectifier's). No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_rectify.rye` — the module.
- `tools/ales_stereo_rectify_witness.rish` — the witness.
