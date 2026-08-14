# ALES24 — Lotus's graft, a selected span copied or moved onto a second point, both channels in lockstep

**Stamp:** `20260814.140030` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES23
**Waymark:** ALES · rung ALES24
**Kin:** [`ALES23 — the selection`](20260814-fill-ales23-lotus-selection.md) · [`lotus/graft.rye`](../lotus/graft.rye) · [`lotus/selection.rye`](../lotus/selection.rye) (ALES23, the grabbed span this rung relocates) · [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2, `splice` and `cut` reused whole) · [`lotus/pan.rye`](../lotus/pan.rye) (ALES10, the `StereoClip` whose channels share one length)

---

## Why this round

The selection (ALES23) lets a keeper grab the span between two marks and edit it whole — cut it, gain it, silence it. Yet the two gestures a keeper reaches for most in any editor are still missing: **copy** the grabbed span to a second point, and **move** it there. Double the good chorus; relocate the strong verse; lift the count-in off the front and drop it after the bridge. A graft is that gesture — a selected span placed at a second point.

Lindy-first, crux-first: copy and move are the primitives every arrangement edit rides on, read for as long as the tool lives, so grafting is a higher-Lindy move than one more single-purpose transform. It stays wholly on the edit side, reusing ALES2's proven `splice` and `cut` and ALES23's validated `Selection` over their public APIs — no module seam, no gate. The word **graft** names the horticulturist's gesture the tree already lives by: take a living piece and join it whole at another place, so it grows there as if it always had.

## The one crux this rung fixes

**A grafted span lands byte-for-byte at the destination, keeps the two channels in lockstep, and never corrupts itself when source and destination overlap.** Three facts make this exact:

- **Snapshot before mutation.** Both channels' span samples are copied into a bounded scratch **before** a single `splice` or `cut` touches the master, so a copy whose destination sits inside or before its own source reads the original audio, never a half-shifted buffer. The classic self-overlap corruption cannot occur.
- **Lockstep from the shared length.** A `StereoClip`'s two channels share one length (ALES10's `left.len == right.len`), and every graft passes the **same** `(at, span)` to each — so a copy grows both by the same count and a move keeps both equal. Capacity is checked against the shared buffer **first**, so either both channels change or neither does.
- **Move is copy then cut, with the destination re-based honestly.** A move snapshots the span, cuts the source (both channels shrink by `span`), then splices the snapshot at a destination re-based for the samples the cut removed: a destination at or before the source stays put; a destination after the source shifts left by `span`. The net length is unchanged, so a move can never overflow.

## The shape

`lotus/graft.rye`:

- `GraftError` — `error{ BadDest } || selection.SelectionError`; a destination past the master, or (for a move) strictly inside the moved span, refuses `BadDest` before any edit — every forwarded fault refusing by name.
- `copy(master, sel, at)` — duplicate the selected span at `at`, the source kept; both channels grow by `sel.span()` in lockstep, refusing `ClipFull` (via the up-front capacity check) rather than overrun.
- `move(master, sel, at)` — relocate the selected span to `at`, the source removed; the net length unchanged, both channels staying aligned. A destination inside the span (`sel.start < at < sel.end`) refuses `BadDest`; a destination equal to either edge is the honest no-op identity.

Both validate the destination against the master's shared length first, snapshot both channels into a bounded scratch (`max_clip` samples, the same bound ALES2 holds), and then apply the same paired edits — so the graft is atomic across the stereo image.

## What the witness proves (GREEN on metal)

`tools/ales_graft_witness.rish`: a copy duplicates the span at the destination in both channels, the source untouched and the two channels aligned; a copy whose destination sits **before** its own source still reads the original span (the self-overlap snapshot proof); a move relocates the span, the source gone, the net length unchanged and the stereo aligned; a move to a destination after the source re-bases correctly (the moved audio lands exactly where the keeper meant, not off by the cut's width); a move onto its own edge is the identity; and every edge refuses by name — a destination past the master and a destination inside the moved span (`BadDest`), and a copy that would overflow the fixed buffer (`ClipFull`) — each before either channel is touched. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a graft a keeper copies and moves a marked span as one. The next rung can offer the **choice of law** where a crossfade meets a grafted edit (a smooth join rather than a hard butt splice), a **named clipboard** so a span survives across masters, or — a module seam, Keaton's word — carry a grafted span across the ALES0 audio **wire** as its own framed payload, tying an editable span to the Mikrophone's capture. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
