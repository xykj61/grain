# Fill ALES65 — Lotus's keyed gate: the door opened by another signal

**Stamp:** `20260814.190149` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; ALES51's floor and ALES56's held follower keyed like ALES63)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES65**
**Kin:** [`../lotus/sidechain.rye`](../lotus/sidechain.rye) (ALES63 — the keyed compressor this mirrors) · [`../lotus/gate_env_hold.rye`](../lotus/gate_env_hold.rye) (ALES57 — the attack/hold/release gate this keys) · [`../lotus/gate.rye`](../lotus/gate.rye) (ALES51 — the silenced floor) · [`../lotus/hold_env.rye`](../lotus/hold_env.rye) (ALES56 — the held time base)

---

## Why this rung

ALES63 named three tools its keyed detector unlocks: the de-esser, the ducker, the **keyed gate**. ALES64 built the de-esser. This rung builds the keyed gate — the third named tool and the exact **mirror** of the sidechain compressor. Where the compressor **ducks** the target when the key gets *loud* (it acts above the threshold), the gate **opens** the target when the key is *loud* and **closes** it when the key falls *quiet* (it acts below the threshold). A gate triggered by a click track so a pad speaks only on the beat; a tom gated by its own close mic so the bleed from the rest of the kit stays silent; a synth chopped by a drum loop — all one primitive.

Crux-first, it re-runs ALES57's exact per-sample loop with the held follower advanced on `key.buf` rather than the target's own sample, so a **self-key** reduces to ALES57 byte-for-byte — the keyed gate **generalizes** the proven in-line gate.

## The one new care — the silent key over a loud target

The compressor acts *above* the threshold, so a silent key never triggered it; the gate acts *below*, so a silent key **fully closes** the door on a loud target. That exposes a case the sidechain compressor never faced: the KEY envelope reads exact silence (`e == 0`) while the TARGET sample is loud. ALES57 divides the target magnitude through the envelope (`gat/e`), undefined at `e == 0` — yet that gain is algebraically **`den/num`** (the envelope cancels: `gat/e = (e·den/num)/e = den/num`). So the `e == 0` branch applies `den/num` directly: no divide by zero, and for a self-key (where a zero key envelope means a zero target sample) it writes zero over zero, staying byte-for-byte with ALES57. This is the load-bearing correctness argument of the rung.

## Shape

`lotus/gate_key.rye` offers `gate_key_follow` / `gate_key_follow_carry`, mirroring ALES63's sidechain pair with the read-only `key` beside the mutable `target`, carrying `env` and `hold_left` so the key's detector survives a call boundary. Each sample advances `hold_env.env_step_hold` on the key; at or above the threshold the target passes, below it the target's magnitude is attenuated by the ratio (the `e == 0` branch handling the silent key). The faults are ALES57's five plus `BadKey`, matching ALES63.

## The laws to prove

1. **Silence stays silence** — under any key.
2. **A self-key is the ordinary ALES57 gate, byte-for-byte** — the grounding law (both tools run).
3. **A loud key opens the gate** — a quiet target passes whole where the in-line gate would silence it (proven against ALES57).
4. **A silent key closes the gate** — a loud target attenuated where the in-line gate would pass it whole (the `e == 0` branch, proven against ALES57).
5. **Unit ratio is the identity everywhere** — even under a silent key.
6. **The sign is held and the magnitude never expands.**
7. **The state carries** — `env` and `hold_left` both — so a mid-hold split equals the whole once.
8. **Each fault refuses by name before any write** — `BadThreshold`, `BadRatio`, `BadCoeff`, `BadHold`, `BadRange`, `BadKey`.

The witness re-proves ALES57 the attack/hold/release gate beside it.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in a target and a read-only key, siloed to `lotus/`. The attack/release/hold are counted in sample indices; the threshold is a magnitude in sample units. No lookahead, no external key routing, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With the keyed gate, the three tools ALES63 named — de-esser, ducker, keyed gate — all stand as compositions of proven parts; the ducker is the sidechain read with a truly external voice key (already proven behaviorally in ALES63), and a carried/spanning de-esser is the next refinement.
