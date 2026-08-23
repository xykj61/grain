# ALES18 — Lotus's live loop meter, a looping stereo region read under two meters

**Stamp:** `20260814.131319` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES17
**Waymark:** ALES · rung ALES18
**Kin:** [`ALES13 — the peak/RMS meter`](20260814-fill-ales13-lotus-meter.md) · [`ALES16 — the stereo loop`](20260814-fill-ales16-lotus-stereo-loop.md) · [`ALES17 — the stereo meter`](20260814-fill-ales17-lotus-stereo-meter.md) · [`lotus/stereo_loop_meter.rye`](../lotus/stereo_loop_meter.rye) · [`lotus/stereo_meter.rye`](../lotus/stereo_meter.rye) (ALES17, the StereoMeter reused whole) · [`lotus/stereo_loop.rye`](../lotus/stereo_loop.rye) (ALES16, the wrapping head)

---

## Why this round

ALES17 named the very next rung it would want in its own road-on: *meter a looping stereo region live — ALES16's wrap under the ALES17 meter.* This round takes it. The read side now has three stereo tools — play (ALES15), loop (ALES16), meter (ALES17) — yet the meter has only ever read a **forward** stereo playthrough. The read a musician watches most is the **practice loop's VU**: a marked bar cycling round and round, its level lit the whole time. Lindy-first, crux-first: composing the two most recent proven rungs (the wrapping head and the two-channel meter) is the highest-Lindy, most-tractable move — it needs no new arithmetic, only the recognition that the two already fit, and it closes the read side's stereo arc into a freely-composing whole (play · loop · meter, each stereo, now interlocking). A punch region tying playback back to the Mikrophone's capture is a module seam that waits for Keaton's word; the live loop meter stays wholly within the read side.

## The one crux this rung fixes

**Metering a whole number of cycles of a looping region gives the identical per-channel peak and RMS as metering the region once at rest — the live VU never drifts however long it loops.** Two facts make this exact, not merely close:

- **Peak** is a maximum, and the loudest sample of K copies of a region is the loudest sample of one copy — invariant under repetition.
- **RMS** is the square root of a mean square, and repeating a region K times leaves the mean of the squares unchanged: the sum of squares scales by K and the count scales by K, and the common factor cancels **exactly even under integer floor division** — `@divTrunc(K·S, K·N) == @divTrunc(S, N)`, since `K·S/(K·N) = S/N` as rationals and the floor of an unchanged rational is unchanged. So the loop VU is stable across cycle count for free, on ALES13's one true `isqrt`.

## The shape

`lotus/stereo_loop_meter.rye`:

- `measure_region(stereo_clip, loop)` — the reference: meter the region `[start, end)` of both channels once, at rest, straight into a fresh ALES17 `StereoMeter`. The level a keeper reads from the marked bar with the transport stopped.
- `meter_loop_live(stereo_clip, loop, cycles, block_len)` — drive the ALES16 wrapping head for exactly `cycles × span` samples (a whole number of cycles), feeding each stereo block into an ALES17 `StereoMeter` block by block. Refuses `MeterFull` when the requested cycles would carry the count past ALES13's bound — the same edge that guards the `cycles × span` `u32` product from overflow before a single read.
- `LoopMeterError` — the combined error set: the stereo read's `BadBlock`, ALES13's `MeterFull`.

Both the wrapping read and the two meters are reused whole; only the reference-and-live drivers and the cycle bound are new.

## What the witness proves (GREEN on metal)

`tools/al/ales_stereo_loop_meter_witness.rish`: block-and-cycle invariance — a looping region metered live at 1-, 2-, and 5-sample blocks and 1, 3, 7 cycles gives the **identical** per-channel peak and RMS as `measure_region` at rest; **stability across 100 cycles** (the same peak and RMS as one cycle — the human payoff of the K-cancels fact); a loud left and a quiet right report distinct levels off the live loop; a `StereoClip` rendered by ALES11's `power.render_stereo` loops-and-meters its two channels exactly (a center pan's `0.707` per side, `700` on a `1000` source); the live loop meter mutates neither channel; and the cycle count is refused past ALES13's meter bound. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With play, loop, and meter all stereo — and the loop now metered live — the read side's tools compose freely over two channels. The next rung can name a **scrub** window (a small movable read a keeper drags across either a mono or stereo master), offer the keeper the **choice of law** on either axis (linear for constant sum, equal-power for constant loudness), or (a module seam, Keaton's word) a **punch region** tying playback back to the Mikrophone's capture. The real two-channel sound-card write a stereo master ultimately feeds stays a paused hardware research round, taken only on Keaton's word.
