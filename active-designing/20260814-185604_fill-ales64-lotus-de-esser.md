# Fill ALES64 — Lotus's de-esser: the first sidechain composition

**Stamp:** `20260814.185604` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; ALES46's band-pass and ALES63's sidechain composed over their public APIs)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES64**
**Kin:** [`../lotus/sidechain.rye`](../lotus/sidechain.rye) (ALES63 — the keyed compressor) · [`../lotus/band.rye`](../lotus/band.rye) (ALES46 — the band-pass that isolates the sibilant band) · [`../lotus/compress_env_hold.rye`](../lotus/compress_env_hold.rye) (ALES58 — the attack/hold/release compressor beneath the key)

---

## Why this rung

ALES63 gave the detector its freedom — a compressor keyed by a *separate* signal — and named the three tools that freedom unlocks: the de-esser (a band-pass key), the ducker (a voice key), the keyed gate. This rung builds the first of them, and it is the crux that proves the sidechain earns its keep: the freedom is worth naming only if a real, loved tool falls out of it as a *composition of proven parts* rather than new machinery. The de-esser does exactly that.

A de-esser tames the harsh "ess" of a vocal without dulling the whole take. It listens to only the **sibilant band** — the high frequencies where the ess lives — and when that band gets loud it ducks the **whole** vocal for that instant, so the ess softens while the body of the voice stays bright. That is precisely a sidechain whose key is a **band-passed copy of the signal itself**: band-pass a copy to isolate the sibilant band (ALES46's proven `Bandpass`), then key ALES63's compressor on that copy over the original.

## Shape

`lotus/deess.rye` offers one function, `deess`, taking the mutable `target`, a caller-owned **empty scratch** `key` clip, the span, the band-pass cutoffs (`num_low/den_low` the high-pass, `num_high/den_high` the low-pass), and the compressor's threshold, ratio, attack, release, and hold. It:

1. splices an exact copy of the target into the empty scratch `key` (so `key.len == target.len`, and `BadKey` can never fire);
2. runs ALES46's `Bandpass` over the span in `key`, isolating the sibilant band in the copy;
3. runs ALES63's `compress_key_follow` over the target keyed on that band-passed copy, from a fresh envelope.

The band-pass runs first over the scratch, so an illegal band cutoff or span refuses **before a single target sample changes**; the keyed compressor checks its own edges before any write. The target is atomic — untouched on any refusal. The band-passed copy lives in the caller's scratch clip, so nothing on the path allocates. The fault set is `tone.ToneError || sidechain.SidechainError` — `BadCoeff`, `BadThreshold`, `BadRatio`, `BadHold`, `BadRange`, `BadKey`, every name already the family's.

## The laws to prove

1. **Silence stays silence** — the band-passed copy of a silent target is silent, so nothing crosses.
2. **The de-esser IS the composition, byte-for-byte** — running `{band-pass a copy; then sidechain-compress}` by hand equals `deess`. The grounding law: the de-esser adds no arithmetic on the audio path; it is ALES46's band-pass and ALES63's keyed compressor in composition.
3. **The key's band-passed level sets the crossing** — measure the band-passed copy's peak `P`; a threshold just *above* `P` is the identity (nothing crosses, however loud the target's broadband level), a threshold *below* `P` ducks. So it is the **sibilant band**, not the raw level, that drives the gain — the de-esser reacts to the band, proven by measuring the copy.
4. **The sign is held and the magnitude never expands** — a loud in-band signal ducks with every sign matched and every magnitude at most its input's.
5. **Each fault refuses by name before the target is touched** — an illegal band cutoff `BadCoeff`, a zero threshold `BadThreshold`, a sub-unity ratio `BadRatio`, an illegal attack coefficient `BadCoeff`, a hold past `max_clip` `BadHold`, an out-of-range span `BadRange`.

The witness re-proves ALES46 the band-pass and ALES63 the sidechain compressor beside it.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in a target and a scratch key, siloed to `lotus/`. The band cutoffs are one-pole coefficients, the attack/release/hold counted in sample indices; the threshold is a magnitude in sample units. This is the **from-silence, whole-span** form only — a carried/spanning de-esser, threading the band-pass and follower states together so it can automate, is a later rung, exactly as the base dynamics preceded their carried forms. No lookahead, no external key routing, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With the de-esser proven, the **ducker** (a voice key over a music bed) and the **keyed gate** are the next compositions of proven parts.
