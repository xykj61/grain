# Fill ALES116 — Lotus's stereo_replace, the general span-edit carried into stereo, both channels in lockstep

**Stamp:** `20260815.014739` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — one Lotus rung, one keystone, one send
**Waymark:** ALES · rung **ALES116** · Season C thread (Lotus · the creative suite) of the Six-Season double-seat
**Kin:** [`replace.rye`](../lotus/replace.rye) (ALES115) · [`pan.rye`](../lotus/pan.rye) (ALES10 — the StereoClip) · [`stereo_insert_join.rye`](../lotus/stereo_insert_join.rye) (ALES29 — the lockstep pattern) · [`timeline.rye`](../lotus/timeline.rye) (ALES2)

---

## The crux, chosen Lindy-first

ALES115 named the general span-edit — `replace`, remove `count` and insert `src` — for a mono Clip. Yet a Lotus master is a **StereoClip** (ALES10), two Clips heard together, one per speaker, whose defining invariant is that **left and right hold the same length** so the two channels stay aligned in time. A keeper who pastes a corrected take over a selection pastes it into **both** channels at once. This rung carries `replace` into stereo the way ALES29 carried the insert-join: run the proven mono `replace` on each channel with the **same** `at` and `count`, and a stereo payload — a left slice and a right slice of equal length — so the edit lands identically in both and the stereo image stays balanced. Chosen crux-first because the whole mono edit family (ALES111–115) becomes usable on real stereo masters the moment `replace` — the family's general case — is lifted; the twin lifts them all.

## The rule, stated once

`stereo_replace(sc, at, count, left_src, right_src)` removes `[at, at+count)` from both channels and inserts `left_src` into the left and `right_src` into the right. It reuses ALES115's `replace` per channel over its public API, inventing no new primitive. **Both channels are validated before either is mutated** — the two payloads must name the same span length (`left_src.len == right_src.len`, else `BadRange`), and the mono `replace` preconditions (`BadRange` on a removed span outside the samples, `ClipFull` on a result past the buffer) are checked against the shared length up front — so a refusal never desynchronises the channels, leaving one edited and the other not. It reuses `timeline.EditError` whole.

## The four laws

1. **THE STEREO REPLACE LAW** — after `stereo_replace(sc, at, count, left_src, right_src)`, the left channel equals mono `replace(left, at, count, left_src)` and the right equals mono `replace(right, at, count, right_src)`, each **byte for byte** against ALES115's own rung run per channel.
2. **THE BALANCE / INVARIANT LAW** — the defining stereo invariant is preserved: `left.len == right.len` after the edit, because equal starting lengths plus equal-length payloads change each channel's length by the same `left_src.len − count`. The stereo image stays aligned in time.
3. **THE ATOMICITY LAW** — the crux of a two-channel edit: any refusal (`BadRange` on a bad span or mismatched payloads, `ClipFull` on an overflow) leaves **both** channels byte for byte untouched, because every check runs before either channel is mutated.
4. **THE DEGENERATE / GENERALIZATION LAW** — empty payloads with `count = 0` is the identity on both channels; and per channel `stereo_replace` inherits ALES115's three faces (empty payload = cut, zero count = splice, payload length = count = paste_over), so the stereo edit generalizes the whole family channel by channel.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It removes a span from both channels and writes caller-supplied stereo samples in its place through the proven mono `replace`, reading no byte past either channel's `len`. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Definition of done

Opening triad; ≥2 positive-invariant asserts per fn; no new `@memcpy` (the edit writes through ALES115's own composition); `timeline.EditError` reused whole; `tools/ales_stereo_replace_witness.rish` GREEN on metal proving all four laws (the stereo replace law against ALES115's own `replace` per channel, the balance law re-measured, the atomicity law verified after each refusal); width-check clean; TAME style ratchet counts unchanged; README front door synced; session log rides the same signed commit; send to `origin` and `xykj61`.
