# Fill ALES139 — `lotus/stereo_halve.rye`, the half-wave rectifier carried into stereo, one shared threshold at zero

**Stamp:** `20260815.040747` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES139**
**Kin:** [`20260815-040027_fill-ales138-lotus-stereo-rectify.md`](20260815-040027_fill-ales138-lotus-stereo-rectify.md) · [`20260814-214355_fill-ales85-lotus-half-wave-rectifier.md`](20260814-214355_fill-ales85-lotus-half-wave-rectifier.md)

---

## Where the ladder stands

ALES138 opened the **even** corner of the stereo nonlinear class on the full-wave rectifier (`y = |x|`, pure even harmonics), which **collapsed** an out-of-phase master to identical channels. This rung carries its plain sibling: ALES85's **half-wave rectifier**, `y = max(x, 0)` — keep the positive half of the wave whole, fold the negative half **away to silence** rather than up. Where a diode bridge makes full-wave rectification, a single diode makes half-wave; harmonically it is the average of the dry and full-wave waves (`max(x, 0) = (x + |x|) / 2`), an **even+odd mix** carrying the fundamental plus the even harmonics plus a DC term, not pure even.

## The crux this round — the half-wave partitions where the full-wave collapsed

The full-wave rectifier (ALES138) folded `+a` and `−a` both onto `a`, so an out-of-phase master returned **identical**. The half-wave keeps only the positive half, so an out-of-phase master (right the exact negation of left) returns **partitioned**: at each index exactly one of the two channels survives — where left is positive it is kept and right (= −left, negative) goes to silence; where left is negative it goes to silence and right (positive) is kept. Two facts hold at every index: `left[i] · right[i] = 0` (the channels are **disjoint**, never both sounding at once), and `left[i] + right[i] = |left[i]|` (the two half-waves **partition** the antisymmetric pair, their sum reconstructing the full-wave magnitude). That is the honest half-wave story read in the stereo field — the pair split into complementary one-sided channels rather than folded to mono.

## The crux, as a lift

`stereo_halve(sc, start, count)` half-wave-rectifies `[start, start+count)` in **both** channels of a `StereoClip`, running ALES85's proven mono `halve` on each. `max(x, 0)` is exact for **every** i16 with **no rail edge at all** (a non-negative sample passes unchanged, a negative becomes 0 — neither branch can overflow), so the half-wave needs no saturate: this is even plainer than the full-wave lift. It takes no gain, no ceiling, no threshold (the threshold is fixed at zero), so it names exactly one fault — it validates the span once against the shared length before either channel is mutated (`BadRange`), so a refusal never rectifies one channel and leaves the other signed. `HalveError` is reused whole.

## The four laws proven

- **THE STEREO HALVE LAW** — each channel equals ALES85's mono `halve` over the same span, **byte for byte**: every output is `max(x, 0)`, non-negatives passing unchanged and negatives going to silence, with no rail edge.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a halve writes values only.
- **THE IMAGE-PARTITION LAW** — because `max(x, 0)` keeps only the positive half, an out-of-phase master (right = −left) returns **partitioned**: `left[i] · right[i] = 0` (disjoint) and `left[i] + right[i] = |left[i]|` (the two half-waves summing to the full-wave magnitude) at every index; yet a 1:2 master keeps its ratio on the kept samples (both zero elsewhere), an identical-channel master stays identical, every output on both channels is **non-negative**, and the map is **idempotent** (a non-negative sample halves to itself).
- **THE ATOMICITY / DEGENERATE LAW** — the lone refusal (`BadRange`) leaves **both** channels byte for byte untouched and still balanced; `count = 0` is the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES85's own `halve`, each output at most its input and never below zero, never a length; the shape is a half-wave threshold at zero, instantaneous (no attack/release, no anti-aliasing). No saturate is owed — `max(x, 0)` never leaves the rail. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_halve.rye` — the module.
- `tools/ales_stereo_halve_witness.rish` — the witness.
