# Fill ALES63 — Lotus's sidechain compressor: the gain that follows another signal

**Stamp:** `20260814.184728` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; ALES56's held follower and ALES58's compressor spent for a keyed detector)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES63**
**Kin:** [`../lotus/compress_env_hold.rye`](../lotus/compress_env_hold.rye) (ALES58 — the attack/hold/release compressor this keys) · [`../lotus/hold_env.rye`](../lotus/hold_env.rye) (ALES56 — the held time base) · [`../lotus/compress.rye`](../lotus/compress.rye) (ALES50 — the softened ceiling)

---

## Why this rung

The held dynamics quartet is whole (ALES57–62): gate, compressor, limiter, and expander each drive their gain from ALES56's one proven held follower. Yet every one of them reads its detector from the **same signal it processes** — the compressor listens to the very track it turns down. A real console does one more thing that opens a whole wing of the craft: it lets the detector listen to a **different** signal. A kick drum keys a compressor on the bass so the bass ducks each time the kick lands; a voice keys a compressor on a music bed so the music steps back whenever someone speaks; the sibilant band of a vocal keys a compressor on the vocal itself so only the "ess" is tamed. All of these are one primitive — a **sidechain**, a detector that follows a *key* signal while the gain lands on a *target* signal.

This rung is that primitive, and it is the crux that opens the wing: once a detector can read a separate key, ducking, de-essing, and keyed gating all follow as compositions rather than new machinery. Crux-first, it is also the tightest possible move — it re-runs ALES58's exact per-sample loop with one change: the held follower advances on `key.buf[start + i]` rather than on the target's own sample, and the resulting gain lands on `target.buf[start + i]`.

## Shape

`lotus/sidechain.rye` offers `compress_key_follow_carry` / `compress_key_follow`, mirroring ALES58's `compress_hold_follow_carry` / `compress_hold_follow` line for line, with a **second clip** — the read-only `key` — added beside the mutable `target`. Both share one span `[start, start + count)`. Each sample:

1. advances ALES56's `env_step_hold` on `key.buf[start + i]` (the key's held magnitude `e`);
2. when `e` crosses the threshold, computes ALES50's softened ceiling `comp = thr + (e − thr)·den/num` and applies the gain `comp/e` to the **target's** raw sample — never the key's.

The key is read, never written; the target is written, never read for detection. The carried state (`env`, `hold_left`) is the key's, so automation spans a key just as it spans a signal.

The faults are ALES58's five plus one: `BadThreshold`, `BadRatio`, `BadCoeff`, `BadHold`, `BadRange`, and **`BadKey`** — a key clip shorter than the span, so the detector would read past the key's samples. `BadKey` is checked at the edge, before any write, like every other fault.

## The laws to prove

1. **Silence stays silence** — a silent target compresses to silence under any key.
2. **A self-key is the ordinary ALES58 compressor, byte-for-byte** — when the key holds the same samples as the target, `compress_key_follow` equals `compress_hold_follow` exactly (ALES58 reads each `x` before it writes, so an identical unmutated key reproduces its detector). This is the grounding law: the sidechain **generalizes** the proven in-line compressor rather than replacing it.
3. **A silent key never reduces** — with a silent key the envelope never crosses the threshold, so the target passes byte-for-byte however loud it is. The gain follows the *key*, not the signal — the defining sidechain fact, stated positively.
4. **A loud key ducks a quiet target** — a target sitting *below* the threshold is still attenuated when the key is loud above it. An in-line compressor would leave that quiet target alone; the sidechain turns it down. This is ducking, proven.
5. **Unit ratio is the identity everywhere** — regardless of the key.
6. **The sign is held and the magnitude never expands** — the keyed gain only ever leans down.
7. **The state carries** — `env` and `hold_left` both — so a span split mid-hold equals the whole once, the key's detector surviving the seam.
8. **Each fault refuses by name before any write** — `BadThreshold`, `BadRatio`, `BadCoeff`, `BadHold`, `BadRange`, `BadKey` — the target and carried state untouched.

The witness re-proves ALES58 the attack/hold/release compressor and ALES56 the held follower beside it.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in two `Clip` buffers on one bench, siloed to `lotus/`. The attack, release, and hold are counted in sample indices, not milliseconds; the threshold is a magnitude in sample units, the ratio a plain fraction. No lookahead, no external key routing, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With this rung the detector can listen to a signal other than the one it turns down — the de-esser (a band-pass key), the ducker (a voice key), and the keyed gate all become compositions of proven parts in later rungs.
