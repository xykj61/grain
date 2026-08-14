# ALES31 — Lotus's paste that joins rather than butts

**Stamp:** `20260814.144834` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES30
**Waymark:** ALES · rung ALES31
**Kin:** [`ALES25 — the clipboard`](20260814-fill-ales25-lotus-clipboard.md) · [`ALES29 — the stereo two-sided insert-join`](20260814-fill-ales29-lotus-stereo-two-sided-insert-join.md) · [`ALES26 — the crossfade join`](20260814-fill-ales26-lotus-crossfade-join.md) · [`lotus/paste_join.rye`](../lotus/paste_join.rye) · [`lotus/stereo_insert_join.rye`](../lotus/stereo_insert_join.rye) (ALES29, `insert_join_stereo` reused whole) · [`lotus/clipboard.rye`](../lotus/clipboard.rye) (ALES25, the held span)

---

## Why this round

ALES25's clipboard `paste` and ALES30's rack both drop a held span into a master with a hard **butt** (`timeline.splice`) — exact where the samples already agree, yet where the span's head disagrees with the outgoing tail, or its own tail disagrees with the audio that follows, the waveform **steps**, and a step is a click a keeper hears. ALES26 gave a seam the choice of law (the crossfade join), and ALES28/ALES29 carried the two-sided insert into stereo. This rung hands that same law to the **paste**, the gesture a keeper reaches for constantly — so a carried span drops into the middle of a mix and both new boundaries flow through power rather than stepping.

Lindy-first, crux-first: the ALES29 road-on named "let the graft or paste **join rather than butt** by default" as a candidate next rung. It is a pure composition of two already-proven modules — ALES29's stereo two-sided insert-join over ALES25's held span — reusing both whole over their public APIs with no new sample-touching arithmetic, no new seam law, no module seam, and no gate. It closes the last "still butts" gap on the paste side, the gesture reached for most.

## The one crux this rung fixes

**Pasting a held span with `paste_join` is exactly ALES29's stereo two-sided insert-join applied to the clipboard's own held buffers — so the paste crosses both seams of both channels equal-power, atomic across the two channels, where ALES25's plain `paste` butts.** One fact makes this exact:

- **The clipboard already holds its two channels at one shared length** (ALES25's own invariant), so `paste_join` hands `left[0..held]` and `right[0..held]` to ALES29's `insert_join_stereo` with the same `at`, `lead`, and `trail` — adding only the `Empty` guard, no new arithmetic, no new seam law, no new bound. The joined paste inherits ALES29's proven scratch-clip atomicity and ALES28's trailing-seam law rather than re-deriving either.

The clipboard is **unchanged** (a read of its held buffers), so a joined paste is still **non-consuming** and **cross-master**, exactly like ALES25's butt paste.

## The shape

`lotus/paste_join.rye`:

- `PasteJoinError` — `error{ Empty } || timeline.EditError`; an empty clipboard refuses `Empty`, a past-the-master `at` or a `lead`/`trail` wider than its neighbour or an overlap under two forwards `BadRange`, an overflow forwards `ClipFull` — every fault by name before either channel is touched.
- `paste_join(cb, master, at, lead, trail)` — paste the held span crossing both seams of both channels equal-power; the new length is `master + held − lead − trail`, atomic across the two channels, the clipboard untouched.

## What the witness proves (GREEN on metal)

`tools/ales_paste_join_witness.rish`: a held span joined at a full-swing sign flip (eight +30000 then eight −30000, a span of four −30000 heads and four +30000 tails, `lead`/`trail` 4) lands a seam sample **strictly inside** the ±30000 extremes where a butt paste would leave a 60000 step (the crux); the new length shares both overlaps (`16 + 8 − 4 − 4 = 16`); the **same** clipboard joins into a **second, different master** with its held length **unchanged** (non-consuming, cross-master); and every edge refuses by name — an empty clipboard (`Empty`), a past-the-master position (`BadRange`), a lead wider than the head (`BadRange`), and an overflow (`ClipFull`) — each before the master is touched, leaving it untouched and aligned. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a joined paste a keeper drops a carried span into the middle of a mix without a click at either boundary. The next rung can **hand the same joined law to the rack's paste** (so a named slot pastes joined too), let a rack **travel as text** (a saveable slot sheet, mirroring ALES22's cue sheet), or — a module seam, Keaton's word — carry a slot's held span across the ALES0 audio **wire** as a frame so a filed span travels between two Lotus benches. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
