# Fill ALES112 — Lotus's duplicate, repeat a span in place (the growth-twin of crop)

**Stamp:** `20260815.011901` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — one Lotus rung, one keystone, one send
**Waymark:** ALES · rung **ALES112** · Season C thread (Lotus · the creative suite) of the Six-Season double-seat
**Kin:** [`crop.rye`](../lotus/crop.rye) (ALES111) · [`insert_silence.rye`](../lotus/insert_silence.rye) (ALES109) · [`timeline.rye`](../lotus/timeline.rye) (ALES2) · [`meter.rye`](../lotus/meter.rye) (ALES13)

---

## The crux, chosen Lindy-first

ALES111's **crop** keeps a span and drops the rest — the clip **shrinks** to the selection. This rung names the gesture that grows a clip by the plainest means a keeper reaches for: **duplicate.** Circle a bar, press *Duplicate*, and a second copy lands immediately after the first — the doubled drum loop, the repeated chorus, the stutter edit. Where crop reduces the timeline to one span, duplicate repeats one span in place, the clip growing by exactly the span's length. Naming it beside crop completes the shrink/grow pair on a selection: keep only it, or repeat it.

## The rule, stated once

`duplicate(clip, start, count)` inserts a second copy of the `count` samples starting at `start` immediately after the span, so `[start, start+count)` becomes `[start, start+2·count)` holding the span twice back to back and the length grows by `count`. It stands on ALES109's `insert_silence` to open `count` silent seats at the span's end (a bounded grow, refusing `ClipFull` past the fixed buffer), then copies the original span forward into that gap — source `[start, end)` and destination `[end, end+count)` are adjacent and disjoint, so the forward copy is exact with no temporary buffer. It refuses `BadRange` when the span falls outside the current samples before any write, reusing `timeline.EditError` whole. No allocation, no second buffer.

## The four laws

1. **THE DUPLICATE LAW** — after `duplicate(clip, start, count)`, the clip is `original[0..end] ++ original[start..end] ++ original[end..len)` where `end = start+count`, the span appearing twice back to back and the length grown by exactly `count`, checked against a hand-built vector at the head, the middle, and the tail.
2. **THE INVERSE LAW** — the crux tying this rung to ALES2. `duplicate(start, count)` then `cut(end, count)` returns the original **byte for byte**, the inserted copy removed exactly — duplicate is the honest inverse of cut on the copied span, proven side by side.
3. **THE COPY / PEAK LAW** — duplicate copies existing samples and invents none, so every value present after the edit was present before; the peak magnitude re-measured through ALES13 is **unchanged** at any span (the loudest sample, if inside the span, simply appears twice at the same magnitude; if outside, it is untouched).
4. **THE DEGENERATE / REFUSAL LAW** — `count = 0` is the identity; a `start` past the samples or a `count` past the remainder refuses `BadRange`, and a duplicate that would overrun the fixed buffer refuses `ClipFull` — each before any write, the clip untouched.

## Honest scope

Software only, purely local. A bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`. It opens a gap through the proven `insert_silence` and fills it with a copy of an existing span — it invents no sample, changes no value, and reads no byte past `len`. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Definition of done

Opening triad; ≥2 positive-invariant asserts per fn; no new `@memcpy`; `timeline.EditError` reused whole; `tools/ales_duplicate_witness.rish` GREEN on metal proving all four laws (the inverse law against ALES2's own cut); width-check clean; TAME style ratchet counts unchanged; README front door synced; session log rides the same signed commit; send to `origin` and `xykj61`.
