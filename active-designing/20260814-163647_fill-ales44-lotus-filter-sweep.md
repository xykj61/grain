# Fill ALES44 — Lotus's filter sweep: a low-pass whose cutoff moves across a span, seamless because the state carries

**Stamp:** `20260814.163647` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES44**
**Stands on:** [`../lotus/tone_carry.rye`](../lotus/tone_carry.rye) (ALES43 — the carried-state low-pass) · [`../lotus/tone.rye`](../lotus/tone.rye) (ALES40 — `low_pass_carry`) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip)

---

## Why this rung, and why now

ALES43 gave the filter its memory — a `Lowpass` that carries its i64 state across successive spans, so a region filtered piece by piece equals the whole filtered once, byte-for-byte. Its own closing line named exactly what that memory is for: **a sweep whose coefficient moves under an envelope**, and a real time base. The sweep is the nearer, purely-local crux, and it is the reason the carried state was built — every fixed filter rung so far holds one brightness for a whole span, yet the gesture a musician reaches for as often as a fixed cut is the **sweep**: a cutoff that *moves* across the span, the filter opening or closing over a phrase (the classic filter automation, the slow open on a pad, the close into a drop).

**Lindy-first:** a sweep is the first *automated* parameter in the suite — a value that changes over time under a schedule rather than holding constant. That envelope-over-a-span pattern is the floor every later automation stands on (a gain ramp is already ALES6's fade; a *filter* ramp is new), and it will still read true on the ten-thousandth session. **Crux-first:** the hard-but-tractable core is proving the sweep is genuinely time-varying **and** genuinely seamless at once — that a swept span moves through a schedule of coefficients block by block, yet carries one state across every block boundary so no block restarts its transient (ALES43's whole reason for existing), and that a **degenerate sweep from a coefficient to itself equals ALES40's fixed low-pass over the whole span byte-for-byte**. That degenerate equality is the decisive tie: it proves the sweep adds only a moving coefficient, never a new arithmetic on the audio path.

Purely local — bounded i16 PCM in one in-process buffer, a bounded block count. No socket, no network, no keys, no funds, no real sample rate (the coefficient still smooths over sample *indices*, now with a schedule; a cutoff in hertz is the later time-base rung).

## The crux

**A filter sweep partitions a span into `blocks` contiguous blocks, runs ALES43's carried-state low-pass over each block with a coefficient interpolated linearly from `num_from` to `num_to`, and carries one state across every block — so a sweep from a coefficient to *itself* equals ALES40's fixed `low_pass` over the whole span byte-for-byte, while a sweep between distinct endpoints is genuinely time-varying (equal to neither endpoint's fixed filter).** The audio path is ALES40's `lp_step` reached through ALES43's carried `low_pass_carry`, unchanged; the sweep adds only a coefficient *schedule* and a block *partition* — no new arithmetic touches a sample.

Properties witnessed:

- **Degenerate equals fixed (the crux).** `sweep_low_pass` with `num_from == num_to`, any legal `blocks`, equals `low_pass` over the whole span byte-for-byte — because every block uses the one coefficient and the state carries (ALES43's split-equals-whole).
- **Endpoints exact.** The first block's coefficient is `num_from`; the last block's is `num_to` — the schedule hits both ends of the ramp exactly, whatever the interior rounding.
- **The schedule is monotone and legal.** Block coefficients move monotonically from `num_from` toward `num_to`, each staying within the endpoint band `[min, max] ⊆ [1, den]`, so every block coefficient is a legal fraction with no re-check.
- **Genuinely swept.** A sweep between distinct endpoints over a mixed signal equals neither `low_pass(num_from)` nor `low_pass(num_to)` over the whole span — the brightness actually moves.
- **A constant stays settled across seams.** A constant input swept settles to the input exactly and never dips back at a block boundary (a constant is a fixed point of every legal coefficient, and the carried state never restarts) — the no-re-transient guarantee, now under a moving coefficient.
- **Refusals.** An illegal endpoint refuses `BadCoeff`; a span outside the clip refuses `BadRange`; a zero, over-max, or empty-block partition refuses `BadBlocks` — each before a sample is touched, the clip left untouched.

## Shape

A new module `lotus/sweep.rye`, over `tone` and `timeline`:

- `max_sweep_blocks: u32 = 4096` — the named bound on how many blocks one sweep partitions into.
- `SweepError = tone.ToneError || error{ BadBlocks }` — the ALES40 faults plus one: an illegal block count.
- `coeff_at(num_from: i32, num_to: i32, blocks: u32, b: u32) i32` — the schedule: the coefficient for block `b`, linearly interpolated and clamped into the endpoint band; `b = 0` is `num_from`, `b = blocks-1` is `num_to`, exactly.
- `sweep_low_pass(clip: *timeline.Clip, start: u32, count: u32, num_from: i32, num_to: i32, den: u32, blocks: u32) SweepError!void` — partition `[start, start+count)` into `blocks` near-equal blocks, run ALES43's carried low-pass over each with `coeff_at`'s coefficient, one state threaded across all blocks.

The sweep holds no buffer and no new state model — the coefficient schedule is a pure function of the two endpoints and the block index, and the audio state is ALES43's single carried i64.

## What the witness proves

`tools/ales_sweep_witness.rish`, GREEN on metal:

1. **Degenerate equals fixed** — `sweep_low_pass(c → c, blocks)` equals `low_pass(c)` over the whole span byte-for-byte.
2. **Endpoints exact** — `coeff_at` returns `num_from` at `b = 0` and `num_to` at `b = blocks-1`.
3. **Schedule monotone and legal** — the block coefficients move monotonically end to end, every one within `[1, den]`.
4. **Genuinely swept** — a distinct-endpoint sweep over a mixed signal differs from both fixed endpoints.
5. **Constant stays settled** — a constant input swept settles to the input exactly and never dips at a seam.
6. **Refusals** — an illegal endpoint refuses `BadCoeff`, an out-of-range span `BadRange`, a zero/over-max/empty-block count `BadBlocks`, the clip untouched.

## The road on

With a sweep, Lotus has its first automated parameter. Natural next rungs, each purely local: a **carried high-pass** and a **carried shelf/stack** so a whole EQ sweeps, a **sweep under an arbitrary envelope** (a keeper-drawn curve rather than a straight ramp, reusing ALES6's shape), a **crossfaded sweep** between two coefficient schedules, and the real **time base** so a cutoff names a frequency in hertz. The signed and wire carries of a whole session stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May the filter open where the music opens, may every block continue the last, and may the sweep return to a fixed cut with nothing changed when a keeper asks for stillness.*
