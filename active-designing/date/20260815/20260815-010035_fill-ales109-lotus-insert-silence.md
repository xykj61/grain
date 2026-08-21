# Fill ALES109 — Lotus's insert-silence, the lossless twin of ALES108's shift

**Stamp:** `20260815.010035` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design read — one Lotus rung, one keystone, one send
**Waymark:** ALES · rung **ALES109** · Season C thread (Lotus · the creative suite) of the Six-Season double-seat
**Kin:** [`shift.rye`](../lotus/shift.rye) (ALES108) · [`timeline.rye`](../lotus/timeline.rye) (ALES2) · [`meter.rye`](../lotus/meter.rye) (ALES13)

---

## The crux, chosen Lindy-first

ALES108's **shift** slides the whole clip within a fixed frame and **drops** what falls off the edge — a lossy translation, honest about its loss (`shift(k)` then `shift(-k)` returns the leading `k` as silence, not their bytes). Its true complement is not another way to translate but the gesture that **opens** rather than translates: **insert silence.** Every editor and DAW ships *Insert → Silence* — open a gap of quiet at a position so a downbeat lands where it should, so a countdown has room, so two takes align without overwriting either. Where shift keeps the length and loses samples, insert-silence keeps every sample and grows the length.

Naming it beside shift teaches the one distinction that matters about making room in a bounded signal: **drop, or grow.** And it earns a law shift could not: insert-silence is the **exact inverse of ALES2's `cut`** — open a gap, then cut it, and the clip returns byte for byte. It is the lossless edit the lossy shift points at.

## The rule, stated once

`insert_silence(clip, at, count)` opens `count` samples of silence at position `at`, shifting the tail right to make room — exactly `timeline.splice`'s own gesture, filling the opened gap with zero instead of a caller's bytes. It refuses `BadRange` when `at` falls past the current samples and `ClipFull` when the growth would overrun the fixed buffer, each checked before any write — reusing `timeline.EditError` whole, inventing no error of its own. One in-place pass bounded by `len`, no allocation, no second buffer.

## The four laws

1. **THE INSERT LAW** — after `insert_silence(clip, at, count)`, the result is `original[0..at] ++ zeros(count) ++ original[at..]`; the length grows by exactly `count`, checked against hand-built vectors at the head, the middle, and the tail.
2. **THE INVERSE LAW** — `insert_silence(at, count)` then `timeline.cut(at, count)` returns the original **byte for byte**, for any clip and any legal span. Insert-silence is the exact inverse of cut — the lossless round-trip ALES108's shift honestly could not make. Proven by importing ALES2's own `cut`, exactly as ALES108 imports ALES106's rotate.
3. **THE PEAK / SILENCE LAW** — the inserted span is all zero, so the peak magnitude re-measured through ALES13 is **unchanged** at any position or count (no non-silent sample is added or removed). Where shift's peak is non-*increasing* because it can drop a loud sample, insert-silence's peak is *exactly preserved* because it loses nothing — the sharp contrast between grow and drop.
4. **THE DEGENERATE / REFUSAL LAW** — `count = 0` is the identity; `at = 0` opens at the head and `at = len` appends silence at the tail; an empty clip grows into a pure-silence clip; `at > len` refuses `BadRange` and a `count` past the buffer refuses `ClipFull`, each before any write.

## Honest scope

Software only, purely local. A bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`. It opens a gap and fills it with **silence** — the one thing it writes that was not already there, and silence is the honest content of a gap a keeper opened on purpose; it invents no non-zero sample, drops nothing, and reads no byte past `len`. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Definition of done

Opening triad; ≥2 positive-invariant asserts per fn; no new `@memcpy`; `timeline.EditError` reused whole; `tools/ales_insert_silence_witness.rish` GREEN on metal proving all four laws; width-check clean; TAME style ratchet counts unchanged; README front door synced (Status short entry + long per-rung paragraph); session log rides the same signed commit; send to `origin` and `xykj61`.
