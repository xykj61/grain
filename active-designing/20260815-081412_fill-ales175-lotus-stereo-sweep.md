# Fill ALES175 — Lotus's stereo_sweep: the filter sweep (a moving low-pass) carried into stereo, the same schedule on both channels — the sixth rung of the stereo EQ / filter class, the automated brightness

**Stamp:** `20260815.081412` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES175
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-080752_fill-ales174-lotus-stereo-bell.md`](20260815-080752_fill-ales174-lotus-stereo-bell.md)

---

## The next crux, honestly chosen

The stereo EQ / filter class now holds its tone control (ALES170), shelf (ALES171), band-pass (ALES172, isolate the middle), notch (ALES173, drop the middle), and bell (ALES174, turn the middle). Every one of those holds **one** brightness for a whole span. The gesture a musician reaches for as often as a fixed cut is the **sweep** — a cutoff that *moves* across the span, the filter opening or closing over a phrase (the slow open on a pad, the close into a drop). Its mono form (`sweep.rye`, ALES44) already stands: the first automated parameter in the suite, a value that changes over time under a schedule, seamless because ALES43's filter state carries across every block so a boundary never re-transients. Carrying it into stereo is the natural sixth rung — and it completes the fixed-and-swept filter family in stereo.

## The shape — the same schedule on both channels, each carrying its own state

`stereo_sweep(sc, start, count, num_from, num_to, den, blocks)` validates the two endpoint coefficients, the span, and the block count **once** against the shared length, then runs ALES44's proven mono `sweep_low_pass` on each channel with the **same** schedule (`num_from → num_to` over `den`, in `blocks` blocks):

- **The schedule is shared** — a sweep's endpoints and block count are values the caller names, not scalars measured across the field, so the same schedule on each channel preserves the stereo image for free. No linking, no measurement — the parametric pattern of ALES170–174.
- **Each channel carries its own state** — `sweep_low_pass` opens a fresh `state = 0` and threads it across its own blocks within the single call, so each channel sweeps its own content with its own carried filter state. There is no cross-channel state to thread across a seam; the two channels never share a filter memory, exactly as a real stereo filter never leaks one side's history into the other.

`StereoSweepError = sweep.SweepError` (BadCoeff, BadRange, BadBlocks) reused whole — the stereo lift adds no new fault. To keep the up-front atomic check the class asks for, ALES44's `check_sweep` is exported (a one-word additive `pub`, mirroring how ALES174 reused `tone.precheck`): the shared validation runs once before either channel is mutated.

## The laws proven

- **The stereo sweep law:** each channel equals ALES44's mono `sweep_low_pass` with the same schedule over the same span byte for byte, proven side by side with genuinely different per-channel content — the left swept by the left's spectrum, the right by the right's, never crossed (the two outputs genuinely differ).
- **The degenerate / crux law:** a degenerate stereo sweep (`num_from == num_to`) over any block partition equals ALES40's fixed `low_pass` on **both** channels byte for byte — the carried state makes the block partition invisible per channel, so a still schedule adds no arithmetic to either audio path.
- **The image law:** an identical-channel (mono-in-stereo) master stays identical through the sweep — the same input through the same schedule is the same deterministic output, so the two channels never split.
- **The balance / silence / atomicity / degenerate law:** an all-silent master sweeps to silence on both; `left.len == right.len` after; an illegal endpoint (BadCoeff), an out-of-range span (BadRange), and an illegal block count (BadBlocks) each refuse by name with both channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each swept through ALES44's own bounded block partition (`max_sweep_blocks = 4096`), the filter state at full i64 precision per channel. The coefficient still smooths over sample **indices**, now under a schedule; a cutoff in hertz is the later time-base rung. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
