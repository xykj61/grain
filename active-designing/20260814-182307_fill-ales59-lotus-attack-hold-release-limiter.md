# Fill ALES59 — the attack/hold/release limiter

**Stamp:** `20260814.182307` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Filled design round — self-approved on the autonomous loop, Lindy-first crux-first
**Waymark:** ALES · **Rung:** ALES59 · **Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite)
**Kin:** [`20260814-181719_fill-ales58-lotus-attack-hold-release-compressor.md`](20260814-181719_fill-ales58-lotus-attack-hold-release-compressor.md) · [`../lotus/README.md`](../lotus/README.md)

---

## Why this rung, now

ALES57 held the gate and ALES58 held the compressor; both named the last of the three: give the **limiter** (ALES55) the same hold. This rung completes the **held dynamics trio** — limiter, compressor, and gate all reading one proven held follower (`hold_env.env_step_hold`), just as the un-held trio (ALES53–55) all read one proven plain follower. The lookahead delay for a true brickwall stays the Keaton's-word horizon ALES55 named; the held-follower spend is self-approvable.

The limiter's hold is the compressor's mirror-sibling: it keeps the gain reduction **engaged** across a momentary **duck** below the ceiling, the patience that keeps a limiter from **pumping** its gain back to unity every time a loud passage briefly dips under the ceiling.

## What ALES59 is

`lotus/limit_env_hold.rye` — an **attack/hold/release limiter**: ALES55's attack/release limiter with the plain follower swapped for ALES56's **held** follower. It drives ALES49's hard ceiling (the gain `ceil/envelope` in `(0, 1)` above the ceiling) from the smoothed-and-held envelope. The gain math is ALES49's, proven; the time base is ALES56's `env_step_hold`, proven; this rung is exactly their composition over public APIs, adding only the hold knob and a second piece of carried state (`hold_left: *u32` beside `env: *i64`). The module mirrors `limit_env.rye` line for line, advancing `hold_env.env_step_hold(...)` instead of `envelope.env_step(...)`.

## The laws it proves (the selftest)

1. **Silence stays silence.**
2. **A hold of zero is the plain ALES55 limiter, byte-for-byte** — the crux law, the zero-hold limit.
3. **Below the ceiling is the identity** — a signal whose every peak sits within the ceiling never drives the envelope above it, so it passes byte-for-byte under any hold.
4. **The sign is held and the magnitude never expands.**
5. **A nonzero hold keeps the gain reduction engaged across a brief duck** — a loud sample, one duck below the ceiling, then loud again. Under a hold that spans the duck, the peak stays pinned above the ceiling, so the gain reduction stays engaged and the duck is **attenuated** (quieter than under no hold, where the limiter would have released and passed it whole). The held magnitude is no **larger** than the un-held one at every sample (the hold only ever keeps the gain **down**, the knob monotone), and strictly quieter at the duck (the pump avoided).
6. **The state carries — env and hold_left both.**
7. **Every edge refuses by name** — a zero or over-rail ceiling `BadCeiling`, an illegal coefficient `BadCoeff`, a hold past `max_clip` `BadHold`, an out-of-range span `BadRange`, each before any write.

The limiter's branch is `e > ceil >= 1`, so the envelope is strictly positive there — no zero-envelope divide to guard (as with the compressor; only the gate ever needed that guard).

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers, siloed to `lotus/`. No socket, network, keys, funds, device, or sample rate; attack, release, and hold counted in sample **indices**. **No lookahead** — a slow attack lets a fast transient briefly overshoot the ceiling before the envelope catches it (this is an honest gain-reducer over time, not a sample-clamp); a true brickwall wants a lookahead delay line, taken only on Keaton's word.

## What it opens

With the gate, compressor, and limiter all holding, the **held dynamics trio is whole** — the mirror of the un-held trio, over one proven held follower. The lookahead delay line for a true brickwall stays the Keaton's-word horizon.
</content>
