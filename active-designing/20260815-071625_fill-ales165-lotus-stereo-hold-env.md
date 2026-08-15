# Fill ALES165 — Lotus's stereo_hold_env: the held envelope follower carried into stereo, one linked detector given the hold stage — the patient time base the whole stereo held-dynamics family waits for

**Stamp:** `20260815.071625` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES165
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-070944_fill-ales164-lotus-stereo-expand-env.md`](20260815-070944_fill-ales164-lotus-stereo-expand-env.md)

---

## The next crux, honestly chosen

ALES160 through ALES164 carried the plain follower and the whole time-varying dynamics quartet (compress · gate · limit · expand) into stereo, each over one linked envelope. The mono family, though, carries one more stage the stereo family has not yet crossed: the **hold** — the patience between attack and release that ALES56 built inside the mono follower, and that the mono held compressor, gate, limiter, and expander each spend.

Crux-first and dependency-first, the hold's *carrier* comes before its four spenders: rather than re-invent the hold four times over inside the coming stereo held compressor, gate, limiter, and expander, this rung gives the **linked detector itself** the held patience once, so all four can read one proven, linked, held time base. It is the exact stereo mirror of ALES56, and it opens the stereo held-dynamics family the way ALES160 opened the plain one.

## The shape — one linked envelope, one shared hold, over time

`stereo_hold_follow(sc, start, count, attack, release, hold)` validates both coefficients, the hold, and the span once, then per pair:

- **Advance the one shared envelope** toward the linked peak `max(|left|, |right|)` clamped to the rail — the attack while rising (rearming the shared hold countdown), the release once the countdown expires, the proven ALES52 `env_step` making every move.
- **A fall while the countdown runs** pins the linked peak and spends one hold sample; the envelope does not move at all. Holding each channel on its own countdown would let the two release on different samples and tear the image — one detector, one hold.
- **Write the one held value into both channels**, so `left == right` after and the held detector is aligned across the field.

`StereoHoldEnvError = hold_env.HoldEnvError` (BadCoeff, BadHold, BadRange) reused whole. Carried-state (`stereo_hold_follow_carry`, carrying **both** the shared `env` and the shared `hold_left`) and from-silence (`stereo_hold_follow`) forms, one implementation, so they cannot drift. The public `stereo_env_step_hold` is the one held step a coming stereo held-dynamics rung reads for its gain.

## The laws proven

- **The linked held detector law (the stereo crux):** the shared held curve equals ALES56's mono `hold_follow` of the per-sample linked key (a synthetic clip of `max(|left|, |right|)` clamped) byte for byte, and both channels equal that curve — while an independent per-channel held follow genuinely differs (the image-tearing bug this prevents).
- **The zero-hold law (the crux link):** `hold_samples == 0` reduces to ALES160's plain linked follower byte for byte on both — the held rung's no-hold limit is exactly the plain linked rung already proven, run against the real tool.
- **The hold-delays-release law:** a larger shared hold pins the linked peak longer, so on a quiet tail the held envelope is no lower than under a smaller hold (monotone in the knob) and strictly higher at the first falling sample.
- **The hold-exact law:** with instant attack and release, a linked peak is pinned for precisely `hold` samples then released in one step, the whole curve checked byte for byte on both channels — the shared countdown spends exactly `hold`, no more, no fewer.
- **The carry law:** a span followed in two pieces, the split falling mid-hold, equals following the whole once, byte for byte on both — `env` **and** `hold_left` both surviving the call boundary.
- **The balance / silence / atomicity / degenerate law:** `left == right` after; silence stays silence on both; an illegal coefficient, a hold past `max_clip`, and an out-of-range span each refuse by name with both channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope and one shared `u32` hold countdown — one linked-peak comparison, at most one `env_step`, and a single counter decrement per pair, all bounded (the envelope in `[0, sample_max]` which fits i16, the hold counter by `max_clip`), so nothing on the path can overflow. The attack, release, and hold are counted in sample indices rather than milliseconds against a clock; the follower renders the linked held magnitude curve rather than routing it into a gain yet (driving the stereo held compressor, gate, limiter, and expander from it is a later rung). No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
