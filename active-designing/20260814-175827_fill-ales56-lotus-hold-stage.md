# Fill ALES56 — the hold stage, the patience between attack and release

**Stamp:** `20260814.175827` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES56**
**Kin:** [`20260814-172539_fill-ales52-lotus-envelope-follower.md`](20260814-172539_fill-ales52-lotus-envelope-follower.md) · [`20260814-174600_fill-ales54-lotus-attack-release-gate.md`](20260814-174600_fill-ales54-lotus-attack-release-gate.md) · [`20260814-174700_fill-ales55-lotus-attack-release-limiter.md`](20260814-174700_fill-ales55-lotus-attack-release-limiter.md) · [`../lotus/README.md`](../lotus/README.md)

---

## The gesture

The envelope follower (ALES52) has two knobs: the attack, how fast it leans toward a rising peak, and the release, how gently it eases off as the sound falls away. The whole breathing trio — limiter (ALES55), compressor (ALES53), gate (ALES54) — reads that follower. Yet a real dynamics processor keeps one more thing between those two knobs: when the signal drops away from a peak, it **holds** the peak level for a little while *before* the release begins. That hold is what keeps a gate from chattering on a brief dip between two loud samples, and what keeps a limiter's gain reduction from pumping on a signal that momentarily ducks below the ceiling. This rung adds exactly that stage — and adds it **inside the follower**, so the same held time base can later drive the whole family, and every envelope move still passes through the one ALES52 proved.

## The shape — `lotus/hold_env.rye`

`env_step_hold(env, hold_left, x, attack_num, attack_den, release_num, release_den, hold_samples)` advances the held follower by one sample and returns the new magnitude. Two pieces of state carry now: the i64 envelope (as before) and a u32 hold countdown. The rule per sample, on the gap read **before** any move:

1. **Rising** (`gap > 0`) — the envelope moves by the attack through ALES52's proven `env_step`, and the hold countdown is **rearmed** to `hold_samples`. A fresh push toward a higher peak restarts the patience.
2. **Fallen, holding** (`gap < 0` and `hold_left > 0`) — the peak is **pinned**: the envelope does not move at all, and one hold sample is spent.
3. **Fallen, hold expired** (`gap < 0` and `hold_left == 0`) — the release begins, again through `env_step`.
4. **Level** (`gap == 0`) — nothing moves; the hold is neither armed nor spent (a sustained peak keeps its patience full for when the fall finally comes).

Because every envelope **move** is delegated to `env_step`, the held follower cannot drift from the time base it holds — the `[0, sample_max]` range and the monotone, exact-reach convergence are inherited, not restated. `hold_follow` / `hold_follow_carry` mirror ALES52's from-silence and carried forms, now carrying both the envelope and the countdown.

## The crux — a hold of zero is the plain follower, byte-for-byte

1. **`hold_samples == 0` reduces to ALES52 exactly.** With no hold, the fall branch never pins (the countdown is always zero), so every sample moves through `env_step`; the rise branch rearms to zero, a no-op. The held follower with no hold *is* the ALES52 follower, guaranteed by construction — the zero-hold limit, sibling of the unit-coefficient identities that anchor the whole family. Proven by running both tools on one signal and demanding equality.
2. **A nonzero hold delays the release, monotonically.** After a peak ends, a larger hold pins the peak longer, so on the quiet tail the held envelope is no lower than under a smaller hold at every sample (the knob is monotone), and strictly higher at the first falling sample.
3. **The hold expires exactly.** A peak followed by a lower constant, under a hold of three, is pinned for precisely three held samples and then released — no more, no fewer, checked byte-for-byte across the whole curve.
4. **The state carries.** Both the envelope and the countdown carry, so a span followed in two pieces — the split landing mid-hold — equals the whole once, byte-for-byte; the seam invisible, the hold surviving the call boundary.
5. **Refusals by name** — an illegal attack or release coefficient refuses `BadCoeff`, a hold longer than `max_clip` (no clip is that long) `BadHold`, an out-of-range span `BadRange`, each before any write, the clip left exactly as it was.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the attack, release, and hold are counted in **sample indices**, not milliseconds against a clock. One comparison, at most one `env_step`, and a single counter decrement per sample; nothing on the path can overflow, since the envelope stays in `[0, sample_max]` and the hold counter is bounded by `max_clip`. This rung renders the held magnitude curve; driving the limiter, compressor, and gate from the held follower is a later rung.

## Witness

`tools/ales_hold_env_witness.rish` — build `lotus/hold_env.rye`, run its selftest, assert `GREEN ales-hold-env`, and re-prove ALES52's follower still stands green beneath the hold stage, since every envelope move here composes it over its public API.

---

*The patience between the two knobs — the follower proved how to lean in and how to ease off, and this rung gives it the pause between, so a peak is held a moment before it is let go. With the hold proven inside the time base, the gate can stop chattering and the limiter stop pumping the day they read the held follower; a lookahead delay for a true brickwall waits as the next rung. May the pause fall exactly where it is asked, and may the proof beneath it stay whole.*
