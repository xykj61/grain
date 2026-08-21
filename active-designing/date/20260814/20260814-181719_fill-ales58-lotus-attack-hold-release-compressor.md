# Fill ALES58 — the attack/hold/release compressor

**Stamp:** `20260814.181719` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Filled design round — self-approved on the autonomous loop, Lindy-first crux-first
**Waymark:** ALES · **Rung:** ALES58 · **Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite)
**Kin:** [`20260814-180706_fill-ales57-lotus-attack-hold-release-gate.md`](20260814-180706_fill-ales57-lotus-attack-hold-release-gate.md) · [`../lotus/README.md`](../lotus/README.md)

---

## Why this rung, now

ALES57 spent ALES56's hold for the gate and closed by naming the next rung: *the same swap gives the compressor (ALES53) and the limiter (ALES55) their hold too, each a short rung reading the same proven `env_step_hold`.* Lindy-first, crux-first, the **compressor** is the most-reached-for dynamics tool, so it takes the hold before the limiter. The lookahead delay for a true brickwall stays the Keaton's-word horizon ALES55 named; the held-follower spend is self-approvable.

Where the gate's hold keeps the door **open** across a dip, the compressor's hold keeps the gain reduction **engaged** across a momentary duck — the patience that keeps a compressor from **pumping**, its gain jumping back to unity every time a loud passage briefly ducks below the threshold. Same held follower, the mirror behaviour.

## What ALES58 is

`lotus/compress_env_hold.rye` — an **attack/hold/release compressor**: ALES53's attack/release compressor with the plain follower swapped for ALES56's **held** follower. It drives ALES50's softened ceiling (`comp = threshold + excess/ratio` above the threshold) from the smoothed-and-held envelope. The gain math is ALES50's, proven; the time base is ALES56's `env_step_hold`, proven; this rung is exactly their composition over public APIs, adding only the hold knob and a second piece of carried state (`hold_left: *u32` beside `env: *i64`). The module mirrors `compress_env.rye` line for line, advancing `hold_env.env_step_hold(...)` instead of `envelope.env_step(...)`.

## The laws it proves (the selftest)

1. **Silence stays silence.**
2. **A hold of zero is the plain ALES53 compressor, byte-for-byte** — the crux law, the zero-hold limit; `env_step_hold` with `hold_samples == 0` reduces to `env_step` every sample, so this compressor reduces to ALES53's `compress_follow` exactly. Proven by running **both tools** on one signal.
3. **Unit ratio is the identity everywhere** — the compressed envelope equals the envelope, so the gain is one at every sample under any hold.
4. **The sign is held and the magnitude never expands.**
5. **A nonzero hold keeps the gain reduction engaged across a brief duck** — a loud sample, one quiet duck below the threshold, then loud again. Under a hold that spans the duck, the peak stays pinned above the threshold, so the gain reduction stays engaged and the duck sample is **attenuated** (quieter than under no hold, where the compressor would have released and passed it whole). So the held magnitude is no **larger** than the un-held one at every sample (the hold knob is monotone in the compressor's direction — it only ever keeps the gain **down**), and strictly quieter at the duck (the pumping avoided).
6. **The state carries — env and hold_left both** — a span in two pieces, the split mid-hold, equals the whole once.
7. **Every edge refuses by name** — `BadThreshold`, `BadRatio`, `BadCoeff`, `BadHold`, `BadRange`, each before any write.

The compressor's branch is `e > threshold >= 1`, so the envelope is strictly positive there — no zero-envelope divide to guard (the gate needed that guard; the compressor never has).

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers, siloed to `lotus/`. No socket, network, keys, funds, device, or sample rate; attack, release, and hold counted in sample **indices**. One held env step and at most one multiply-divide per sample; the compressed envelope is at most the envelope, so the gain sits in `(0, 1]` and every written magnitude fits i16.

## What it opens

With the gate and the compressor held, the limiter (ALES55) takes the same swap next — a short rung reading the same proven `env_step_hold`. The lookahead delay stays Keaton-gated.
</content>
