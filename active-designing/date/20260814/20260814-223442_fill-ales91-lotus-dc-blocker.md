# Fill ALES91 — Lotus's one-pole IIR DC blocker: the carried-state sibling that follows a drifting offset

**Stamp:** `20260814.223442` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the rung is a bounded, in-process one-pole difference equation over one local i16 clip, and the ALES90 doc already *booked* this IIR blocker as "a later, named rung — the ALES43-shaped sibling")
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES91**
**Kin:** [`../lotus/dc_remove.rye`](../lotus/dc_remove.rye) (ALES90 — the block-mean remover this rung is the carried-state sibling of) · [`../lotus/tone_carry.rye`](../lotus/tone_carry.rye) (ALES43 — the carried-state idiom this rung reuses) · [`../lotus/tone.rye`](../lotus/tone.rye) (ALES40 — the one-pole filter whose coefficient law this rung diverges from) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, `sample_min`/`max`, and the one true `saturate`)

---

## Why this rung

ALES90 landed the **block-mean** DC remover: it looks at a whole span at once, subtracts the one average, and is memoryless — the exact right tool for the **constant** offset a rectifier introduces over a bounded region. Yet a real offset **drifts**. A microphone warms up and its bias creeps; two takes spliced together each ride a different DC rail; the offset steps partway through a clip. A block mean cannot follow a moving offset — it subtracts one number, leaving each region offset by its distance from the whole-span average. The ALES90 doc named the answer in as many words: *the classic one-pole IIR DC blocker, a drifting-offset remover with carried state, the ALES43-shaped sibling — a later, named rung.* This is that rung.

Lindy-first, a DC blocker is a primitive that reads true for as long as audio is a stream of signed samples — it sits at the front of every console channel, plugin host, and codec, the same as the block-mean remover, yet it is the form a **stream** wants where the block form fits a **buffer**. Crux-first, it is the sibling the family that just landed demands, and it is the hardest-still-tractable next Lotus move: it is the first rung to carry **two** feedback states through a recursive equation and prove them stable in pure integers.

## The crux — a DC blocker **carries state**, so split equals whole

The block-mean remover is memoryless: run it twice and the second pass is a no-op. This rung is its opposite — it has **memory**. The one-pole difference equation is

```
y[n] = (x[n] − x[n−1]) + R·y[n−1]          R = num/den, a stable pole in [0, 1)
```

The term `x[n] − x[n−1]` is the **zero at direct current**: a constant input makes it zero, so the steady-state output is zero — DC removed. The term `R·y[n−1]` is the **leaky integrator** that widens the notch: `R` near one keeps a narrow notch that lets the bass just above DC survive, `R = 0` is the plain first difference (a wide highpass). To run it a caller must carry the previous input `x[n−1]` and the previous output `y[n−1]` — and the moment a filter carries state, the ALES43 property returns:

> **A span blocked in two pieces, the second continuing from the first's ending state, equals the whole span blocked once — byte-for-byte.** No fresh transient at the seam, the click a per-span restart would leave.

That split-equals-whole property is the whole reason ALES91 is a **sibling** of ALES90 rather than a copy. dc_remove is memoryless (a second pass changes nothing); dc_block has memory (a second span continues the first's decay). The two answer the same word — *take the offset out* — for the two shapes audio comes in: a buffer you hold whole, and a stream you meet sample by sample.

## Reaching zero exactly, in finite steps

The one correctness a recursive DC blocker owes on integer PCM is that a settled constant reach output **exactly zero** — not drift near it forever. It does, for the same reason ALES40's low-pass reaches a constant exactly: the feedback `R·y[n−1] = @divTrunc(num·y_prev, den)` truncates toward zero, so once `|y_prev|` falls below `den/num` the feedback truncates to **exactly 0** and the output settles at zero and stays. The feedback reads the **saturated** prior output, so the recurrence stays bounded (`|y_prev| ≤ sample_max`); every intermediate runs in i64 so nothing overflows before the one clamp, and the feedback multiply is bounded by `max_pole_den` so `num·y_prev` stays far inside i64.

## Its own coefficient law — the pole is `[0, 1)`, not `(0, 1]`

The ALES40 tone filter demands a coefficient in `(0, 1]` — it must *move forward* (`num ≥ 1`) and may reach the identity (`num = den`). A DC blocker's pole is a **different** law, and the rung states it as its own:

- `den > 0` and `den ≤ max_pole_den` — no divide by zero, and the feedback multiply stays inside i64.
- `num ≥ 0` — **`num = 0` is legal here**: it is the real, useful first-difference highpass. (This is the divergence from the tone filter, which would refuse it.)
- `num < den` **strictly** — the pole must lie *inside* the unit circle. `num = den` is a pure integrator (`y[n] = x[n] − x[0]`, marching, never settling); `num > den` is unstable. Both refuse `BadCoeff`.

## Shape

`lotus/dc_block.rye` offers three faces of one implementation, the ALES43 idiom exactly:

- `dc_block_carry(clip, start, count, x_prev, y_prev, num, den)` — the general carried form; the caller owns the two i64 states.
- `dc_block(clip, start, count, num, den)` — the from-silence convenience, the `states = 0` case of `dc_block_carry` (so the two can never drift).
- `DcBlocker { x_prev, y_prev, num, den }` — the tiny value a keeper holds beside a clip; `run` continues from the carried state, `reset` returns it to silence.

Two faults, both refused before a sample is touched: `BadCoeff` (an unstable or divide-by-zero pole) and `BadRange` (a span outside the samples).

## The laws to prove

1. **A fresh blocker is from-silence** — a `DcBlocker` with both states 0 equals `dc_block` byte-for-byte (one implementation, cannot drift).
2. **A constant offset settles to exactly zero** — the defining correctness; a constant span passes its first sample (the transient) then reaches a tail of exactly 0.
3. **Split equals whole (the crux)** — a span blocked in two pieces, the second carrying the first's ending state, equals the whole blocked once, byte-for-byte.
4. **It follows a drifting offset a block mean cannot** — a DC *step* (`+4000` then `−2000`) drives each region to zero, where ALES90's block mean leaves the regions riding `±3000`.
5. **Reset re-opens the transient** — after a settled run, `reset` returns the state to silence so the next run passes its first sample fresh.
6. **`R = 0` is the legal first difference** — `num = 0` blocks a constant to its first sample then exactly zero (legal here, unlike the tone filter).
7. **Saturation at the rail is honest** — a sharp edge past the ceiling pins to `sample_max` rather than wrapping.
8. **The span discipline holds** — only `[start, count)` changes; the samples outside are untouched.
9. **An illegal pole refuses `BadCoeff`** — `num = den`, `num < 0`, `den = 0`, and `den` past the ceiling each refuse, the state untouched.
10. **An out-of-range span refuses `BadRange`** — the clip untouched before any write.

## Honest scope

Software only, purely local. A bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`. One recursive difference equation run sample by sample, every intermediate in i64 so nothing overflows before the one clamp, the feedback multiply bounded by `max_pole_den`. The "DC" is the zero-frequency component by definition, not a claim about any hardware highpass; no real sample rate (the pole is a fraction over sample **indices**, not a cutoff in hertz — a real time base is a later rung), no anti-aliasing, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker.

## What this opens

With both DC removers in hand — the memoryless block mean for a bounded region, the carried-state IIR blocker for a stream — the offset family generated by the DRIVE shelf stands fully answered. Beyond it the loop names its own next Lotus crux: a **hysteresis comparator** that gives ALES89's square a memory against chatter, a **one-pole/one-zero shelving IIR** that carries state like this blocker, or a fresh DSP family — as its own self-approved design round.
