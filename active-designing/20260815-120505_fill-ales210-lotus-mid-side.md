# Fill ALES210 — Lotus's mid/side primitive (the stereo master as its sum and its difference)

**Stamp:** `20260815.120505` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES210**
**Kin:** [`20260815-115900_fill-ales209-lotus-stereo-reverb-freeze.md`](20260815-115900_fill-ales209-lotus-stereo-reverb-freeze.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES209 closed the freeze axis whole and named the next reverb axis openly: **width** — the stereo spread of the tail — noting it "wants its own mid/side primitive and so opens a small primitive round before the reverb rung that spends it." This round takes that primitive, crux-first: rather than reach for a width knob that would smuggle in an unproven change of basis, it lays the **mid/side transform** first and proves it whole, so width — and every other stereo tool that speaks in centre and side — stands on proven ground.

This is the Lindy-first move within the finishing edge. A reusable, reversible primitive is read and spent by many rungs (width, mono-compatibility checks, side-only EQ); a one-off effect is read once. The primitive earns the round.

## The shape — a reversible change of basis, in place

Every stereo edit so far speaks in **LEFT** and **RIGHT** — the two speakers. The deepest stereo tools speak a second language: **MID** (what the channels share, the mono centre, the sum) and **SIDE** (what they differ by, the stereo width, the difference).

- `encode(sc)` folds LEFT/RIGHT into MID/SIDE in place:
  - `mid  = (l + r) / 2` — the average, the shared centre
  - `side = (l - r) / 2` — the half-difference, the stereo width
  - Both provably fit the i16 rail with **no clip** (`|l+r|/2 ≤ 32768`, `|l-r|/2 ≤ 32767`), asserted in place, then routed through ALES2's one true `saturate` so the rail lives in one place even where it is never reached.
- `decode(sc)` folds MID/SIDE back into LEFT/RIGHT:
  - `l = saturate(mid + side)`, `r = saturate(mid - side)` — here the sum **can** exceed the rail, so `saturate` pins it once.

Both ops are **total** — they name no span, hold each channel's length, and keep the balance invariant (`left.len == right.len`) trivially — so neither raises a fault: `void`, no `EditError`, no `try`, exactly as ALES127's `stereo_invert`.

## The honest cost, named not hidden

Because the side is **halved** to stay on the i16 rail, one bit of the difference cannot be stored — the well-known cost of a 16-bit mid/side over a 17-bit-side lossless store (FLAC keeps the extra bit; a fixed i16 clip cannot). So `decode(encode(sc))` is **exact** for every sample where `l + r` is even (equivalently `l` and `r` share parity), and off by **at most one LSB** otherwise. This is stated in the module head, the witness prose, and proven both ways below — never silent drift. A centred master (`l == r`) has `l + r = 2l` even everywhere, so it always round-trips exact — the mono-compatible signal is preserved however loud.

## The provable laws the witness proves

1. **THE ENCODE LAW** — `left[i] = (l+r)/2` and `right[i] = (l-r)/2` per seat, byte for byte against a hand vector; the i16 extremes ride along so the no-clip range claim is proven in place.
2. **THE MONO-COMPATIBILITY LAW** — a centred master (`l == r`) encodes to an all-zero side and a mid equal to the shared channel: a mono signal has no width, the property mid/side exists to expose.
3. **THE RECONSTRUCTION LAW** — `decode(encode)` is exact where `l + r` is even, bounded to ≤ 1 LSB per sample where odd, and always exact for a centred master.
4. **THE BALANCE / LENGTH LAW** — both ops hold `left.len == right.len` and each channel's starting length, at an even and an odd length.
5. **THE EMPTY / DECODE-SHAPE LAW** — an empty pair is unchanged; `decode` is the honest inverse fold, proven directly with a clean case and a saturating case (the rail pinned once).

## Honest scope

Software only, purely local. Two bounded in-process i16 `Clip`s (left, right) on one bench, siloed to `lotus/`. A pure change of basis over existing samples — it fabricates none, changes no length, reads no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker. **No custody gate** — self-approved and shipped as its own signed round.

## Next after this

The mid/side primitive now stands whole, encode and decode. The reverb **width** rung (mono then stereo) opens next — `scale the side, recombine`, spending exactly this primitive: `encode`, scale the side channel by a width fraction, `decode`. The gain on the side is ALES8's fader shape already proven, so width invents no new arithmetic either — it composes this primitive with a proven scale.
