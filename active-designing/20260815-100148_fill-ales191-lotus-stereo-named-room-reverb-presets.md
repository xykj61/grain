# Fill ALES191 — Lotus's stereo named-room reverb presets

**Stamp:** `20260815.100148` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES191**
**Kin:** [`20260815-095435_fill-ales190-lotus-named-room-reverb-presets.md`](20260815-095435_fill-ales190-lotus-named-room-reverb-presets.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES186–189 built the reverb network whole — the mono Schroeder network, its stereo carry, and both real-time faces (`reverb_ms`, `stereo_reverb_ms`). ALES190 gave the *mono* reverb a face a musician reaches for by name: three named rooms (room · hall · plate), each a curated bank, run through the proven timed reverb. Yet a keeper mixing a stereo master still has to hand the stereo timed reverb a whole bank by hand — the named-room comfort stops at mono.

By Lindy-first, crux-first this is the thin twin ALES190 itself named next: **`stereo_reverb_preset`** — the *same* three published banks, now run through ALES189's `stereo_reverb_ms` so a stereo master reverberates by name. It is the highest-Lindy, most-tractable move in the arc: it completes the named-room face across both the mono and stereo timed reverbs, read for years by anyone reaching for a room without reciting four combs.

## The single source of truth stays ALES190's banks

This rung invents no new tuning. It imports `reverb_preset.Room` and `reverb_preset.bank_for` — the *exact* published banks the mono preset and its witness already read — and hands them to the stereo timed reverb. One bank definition, two faces: the mono `reverb_preset` and the stereo `stereo_reverb_preset` are provably the same rooms, because they read the same constants. A future tuning of `hall` moves both at once.

## The five laws the witness proves

1. **A STEREO PRESET IS ITS NAMED BANK** — for every room, `stereo_reverb_preset(sc, clk, room, ...)` equals `stereo_reverb_ms(sc, clk, ..., bank.combs, bank.allpasses)` byte for byte on **both** channels. The preset adds only the name.
2. **THE ROOMS DIFFER** — hall, room, and plate over the same stereo master produce genuinely different washes, not three names for one bank.
3. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel through any preset, since one shared bank feeds both channels; and a genuinely stereo master keeps its two channels distinct (no crossing).
4. **THE CHANNELS LEAVE BALANCED** — the defining `StereoClip` invariant (`left.len == right.len`) holds after every preset, as `stereo_reverb_ms` already guarantees.
5. **THE UNDERLYING FAULTS FORWARD** — a span past the clip refuses `DurationTooLong`, an out-of-range span refuses `BadRange`, each by name with **both** channels untouched and balanced. The preset adds no fault; ALES189's `StereoReverbTimeError` forwards whole.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, and ALES190's three fixed compile-time banks each within `reverb.max_stages`, siloed to `lotus/`. No new arithmetic on the audio path — a constant bank, then the proven timed stereo reverb. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

A **wet/dry mix** (blending the reverberated span with a snapshot of the dry signal) is the next genuinely new expressive knob — the first preset control that is not a bank choice — and it is the crux ALES190 already pointed at past the stereo twin.
