# Fill ALES57 — the attack/hold/release gate

**Stamp:** `20260814.180706` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Filled design round — self-approved on the autonomous loop, Lindy-first crux-first
**Waymark:** ALES · **Rung:** ALES57 · **Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite)
**Kin:** [`../lotus/README.md`](../lotus/README.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Why this rung, now

ALES56 built the hold stage **inside** the follower (`lotus/hold_env.rye`) and closed by naming its own next rung plainly: *drive the limiter, compressor, or gate from the held follower.* That is the agent-doable crux — the lookahead delay line the true brickwall wants is explicitly Keaton-gated (ALES55's honest horizon), so the hold's first spend is the self-approvable move.

The **gate** is where hold earns its keep. Hold time is a knob every real noise gate carries, for one reason the plain attack/release gate cannot answer: on a brief dip between two loud samples, an un-held gate slams shut and re-opens — it **chatters**, and the ear hears the door. A held gate pins the envelope above the threshold through the dip, so the gate stays open and the passage stays whole. The compressor and limiter want hold too (against pumping on a momentary duck), yet the gate is where the artifact is loudest and the fix most audible, so the gate is the crux of the three.

## What ALES57 is

`lotus/gate_env_hold.rye` — an **attack/hold/release noise gate**: ALES54's attack/release gate with the plain follower swapped for ALES56's **held** follower. It drives ALES51's silenced floor (`new = sign(x)·(m·ratio_den/ratio_num)` below the threshold) from the smoothed-and-held envelope rather than the bare sample or the un-held envelope. Nothing on the audio path is re-invented: the gain math is ALES51's, proven; the time base is ALES56's `env_step_hold`, proven; this rung is exactly their composition over public APIs, adding only the hold knob.

The module mirrors `gate_env.rye` line for line, with two changes: it carries a second piece of state (`hold_left: *u32` beside `env: *i64`), and each sample advances `hold_env.env_step_hold(...)` instead of `envelope.env_step(...)`.

## The laws it proves (the selftest)

1. **Silence stays silence** — an all-zero clip gates to zeros at any legal knobs and any hold.
2. **A hold of zero is the plain ALES54 gate, byte-for-byte** — the crux law, the zero-hold limit. With `hold_samples == 0` the held follower's fall branch never pins, so `env_step_hold` reduces to `env_step` every sample, and this gate reduces to ALES54's `gate_follow` exactly. Proven by running **both tools** on one signal and demanding equality — the sibling of the family's unit-coefficient and zero-hold identities.
3. **Unit ratio is the identity everywhere** — `ratio_num == ratio_den` makes the gated envelope equal the envelope, so the gain is one at every sample and the whole signal passes byte-for-byte, even below the threshold and even under a hold.
4. **The sign is held and the magnitude never expands** — a gate only ever leans down; every output sign matches its input and every magnitude is at most the input's.
5. **A nonzero hold keeps the gate open across a brief dip** — a loud passage, one quiet dip sample, then loud again. Under a hold long enough to span the dip, the dip sample passes **louder** than under no hold (the gate did not chatter); and the held magnitude is no smaller than the un-held one at every sample (the hold knob is monotone).
6. **The state carries — env and hold_left both** — gating a span in two pieces, the split landing mid-hold, equals gating the whole once, byte-for-byte: the seam invisible, the hold surviving the call boundary (ALES43's lesson, now carrying two pieces of state).
7. **Every edge refuses by name before any write** — a zero/over-rail threshold `BadThreshold`, a sub-unity or zero-denominator ratio `BadRatio`, an illegal attack or release coefficient `BadCoeff`, a hold past `max_clip` `BadHold`, an out-of-range span `BadRange`; on refusal the clip and the carried state are untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — attack, release, and hold are counted in sample **indices**, not milliseconds; the threshold is a magnitude in sample units, the ratio a plain fraction. One held env step and at most one multiply-divide per sample; the gated envelope is at most the envelope, so the gain sits in `[0, 1]` and every written magnitude fits i16.

## What it opens

With the gate held, the same swap gives the compressor (ALES53) and the limiter (ALES55) their hold too — each a short rung reading the same proven `env_step_hold`. The lookahead delay line for a true brickwall stays Keaton-gated.
</content>
</invoke>
