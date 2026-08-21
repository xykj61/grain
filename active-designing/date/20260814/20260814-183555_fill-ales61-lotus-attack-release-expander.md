# Fill ALES61 — Lotus's attack/release downward expander: the expander given a sense of time

**Stamp:** `20260814.183555` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the expander driven from the proven ALES52 follower)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES61**
**Kin:** [`../lotus/expand.rye`](../lotus/expand.rye) (ALES60 — the deepened floor this drives over time) · [`../lotus/envelope.rye`](../lotus/envelope.rye) (ALES52 — the proven time base) · [`../lotus/gate_env.rye`](../lotus/gate_env.rye) (ALES54 — the sibling attack/release tool this mirrors)

---

## Why this rung

ALES60 gave the dynamics family its fourth, symmetry-completing member — the downward expander, the compressor mirrored under the threshold. The compressor, gate, and limiter each already earned their attack/release form (ALES53–55) by driving their instantaneous gain from ALES52's proven envelope follower rather than the bare sample. The expander is the one member of the quartet still leaning on samples the instant it sees them. This rung gives it the same breath, so the whole family shares one time base.

Crux-first, this is the tightest next move: it re-runs the exact ALES54 pattern with the gate's below-threshold *division* replaced by the expander's below-threshold *widening*. No new time base, no new arithmetic on the audio path beyond the one widen ALES60 already proved.

## Shape

`lotus/expand_env.rye` mirrors `lotus/gate_env.rye` line for line — the same `expand_follow` (from silence) and `expand_follow_carry` (owning the `i64` envelope across calls) pair sharing one implementation, the same `ExpandEnvError` faults (`BadThreshold`, `BadRatio`, `BadCoeff`, `BadRange`), the same per-sample advance of `envelope.env_step`. The one changed step: when the smoothed envelope `e` falls below the threshold `thr`, the target is ALES60's expanded envelope

```
exp = max(0, thr − (thr − e)·num/den)
```

and the gain `exp/e` (in `[0, 1]`, since `num/den ≥ 1` forces `exp ≤ e`) is applied to the raw sample. A zero envelope means a zero sample (env_step forces a unit step toward any nonzero target), so there is no divide by zero.

## The laws to prove (mirroring ALES54's witness)

1. Silence stays silence.
2. **Unit attack and release reduce it to the plain ALES60 expander byte-for-byte** — the instantaneous expander is the zero-smoothing limit, proven by running both tools.
3. **Unit ratio is the identity everywhere** — `num = den` makes `exp = e`, gain exactly one at every sample.
4. The sign is held and the magnitude never expands, under a real attack and release.
5. **A slower release eases the widening longer** — a slower release keeps the envelope above threshold longer, so a quiet tail is attenuated *less* (the note's fall stays smooth, no pump); the release knob is monotone, and the first tail sample is strictly louder under a slow release than a fast one.
6. **The state carries** — a span expanded in two pieces equals the whole once, byte-for-byte; the seam invisible, the release easing across the boundary.
7. Each fault refuses by name before any write, the clip untouched.

The witness re-proves ALES60 the plain expander and ALES52 the follower beside it, so the rung rests on both proven parents.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM, siloed to `lotus/`. The attack and release are fractions per sample index, not milliseconds against a clock. No lookahead, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched.
