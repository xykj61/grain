# Fill ALES62 — Lotus's attack/hold/release downward expander: the held quartet made whole

**Stamp:** `20260814.184011` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; ALES56's held follower spent for the expander)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES62**
**Kin:** [`../lotus/expand.rye`](../lotus/expand.rye) (ALES60) · [`../lotus/hold_env.rye`](../lotus/hold_env.rye) (ALES56 — the held time base) · [`../lotus/expand_env.rye`](../lotus/expand_env.rye) (ALES61 — the zero-hold limit) · [`../lotus/gate_env_hold.rye`](../lotus/gate_env_hold.rye) (ALES57 — the sibling this mirrors)

---

## Why this rung

ALES56 built the hold stage inside the follower and proved it once; ALES57–59 spent it for the gate, the compressor, and the limiter — the **held trio**, the exact mirror of the un-held attack/release trio (ALES53–55). ALES60 then added the expander as the fourth classic dynamics processor, and ALES61 gave it its attack/release form. The expander is now the one member of the family with no *held* form. This rung gives it that hold, so the **held quartet** (gate, compressor, limiter, expander) mirrors the un-held quartet exactly.

Crux-first, it is the tightest completing move: it re-runs the ALES57 pattern with the gate's below-threshold *division* replaced by the expander's below-threshold *widening*. No new time base, no new gain law — a composition of ALES56's held follower and ALES60's widening over their public APIs, adding only the hold knob.

## Shape

`lotus/expand_env_hold.rye` mirrors `lotus/gate_env_hold.rye` line for line — the same `expand_hold_follow` / `expand_hold_follow_carry` pair sharing one implementation, carrying **both** the `i64` envelope and the `u32` hold countdown so the hold survives a call boundary; the same `ExpandEnvHoldError` faults (`BadThreshold`, `BadRatio`, `BadCoeff`, `BadHold`, `BadRange`); the same per-sample advance of `hold_env.env_step_hold`. The one changed step: when the held envelope `e` falls below the threshold `thr`, the target is ALES60's `exp = max(0, thr − (thr − e)·num/den)`, and the gain `exp/e` (in `[0, 1]`) is applied to the raw sample. With `hold_samples` zero the held follower reduces to ALES52's plain `env_step`, so this reduces to ALES61's un-held expander byte-for-byte.

## The laws to prove (mirroring ALES57's witness)

1. Silence stays silence.
2. **A hold of zero is the plain ALES61 attack/release expander byte-for-byte** — the zero-hold limit, both tools run.
3. Unit ratio is the identity everywhere.
4. The sign is held and the magnitude never expands, under a real attack, release, and hold.
5. **A nonzero hold keeps the expander idle across a brief dip** — a loud/dip/loud signal with instant attack and release: no hold pumps the gain down at the dip, a hold that spans the dip pins the peak so the dip passes; the hold knob is monotone, the dip strictly louder held.
6. **The state carries** — env and hold_left both — so a span split mid-hold equals the whole once.
7. Each fault refuses by name before any write, the clip and carried state untouched.

The witness re-proves ALES60 the expander and ALES61 the un-held attack/release expander beside it.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM, siloed to `lotus/`. The attack, release, and hold are counted in sample indices, not milliseconds. No lookahead, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With this rung the held dynamics quartet is whole — all four members reading ALES56's one proven held follower.
