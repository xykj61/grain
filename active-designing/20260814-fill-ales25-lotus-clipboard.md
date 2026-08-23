# ALES25 — Lotus's clipboard, a held span pasted anywhere, any number of times, across masters

**Stamp:** `20260814.140611` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES24
**Waymark:** ALES · rung ALES25
**Kin:** [`ALES24 — the graft`](20260814-fill-ales24-lotus-graft.md) · [`ALES23 — the selection`](20260814-fill-ales23-lotus-selection.md) · [`lotus/clipboard.rye`](../lotus/clipboard.rye) · [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2, `splice` and `cut` reused whole) · [`lotus/pan.rye`](../lotus/pan.rye) (ALES10, the `StereoClip` whose channels share one length)

---

## Why this round

The graft (ALES24) copies and moves a span **within one master** — source and destination live in the same audio. Yet the gesture a keeper reaches for across a session is older and wider than that: **hold** a span, then **paste** it — later, again, and into a *different* master. Copy the chorus off one take and drop it into the mixdown; lift a clean count-in and reuse it on three songs. A clipboard is that held span, decoupled from any one master in both place and time.

Lindy-first, crux-first: the clipboard is the primitive copy and move themselves generalize to — a graft is a copy-and-paste fused into one master, while a clipboard splits the two halves so the paste can land anywhere, any number of times. It is therefore a higher-Lindy move than a crossfade-join ergonomic, and it stays wholly on the edit side, reusing ALES2's proven `splice`/`cut` and ALES23's validated `Selection` over their public APIs — no module seam, no gate.

## The one crux this rung fixes

**A held span pastes byte-for-byte into any master, repeatably, keeping both channels in lockstep — the clipboard itself never changes when it is pasted.** Three facts make this exact:

- **The clipboard holds its own copy.** `copy_to` / `cut_to` snapshot both channels' span samples into the clipboard's own bounded buffers, so the held audio survives after the source master is edited, closed, or replaced — the clipboard depends on no master once filled.
- **Paste is non-consuming and cross-master.** `paste` splices the held samples into the destination master and leaves the clipboard untouched, so the same span pastes into three places and three masters identically — paste is a read of the clipboard, never a move out of it.
- **Lockstep from equal-length held channels.** The clipboard's two channels are always the same length (they hold one stereo span), and every paste passes the **same** `(at, span)` to each destination channel with capacity checked **first** — so a paste grows both by the same count and the stereo stays aligned, or neither channel is touched.

## The shape

`lotus/clipboard.rye`:

- `Clipboard` — a held stereo span: two bounded `max_clip` buffers (left, right) of one shared length, plus `held()` (the span length, 0 when empty). No master reference — once filled it stands alone.
- `ClipboardError` — `error{ Empty } || selection.SelectionError`; a paste of an empty clipboard refuses `Empty`, a paste past the master forwards `BadRange`, a paste that would overflow forwards `ClipFull` — every fault by name.
- `copy_to(cb, master, sel)` — fill the clipboard from a selection, the source master untouched.
- `cut_to(cb, master, sel)` — fill the clipboard from a selection, then remove the span from the master (ALES23's `selection.cut`) — the lift-and-hold gesture.
- `paste(cb, master, at)` — splice the held span into `master` at `at`, both channels in lockstep, the clipboard unchanged so it pastes again.

## What the witness proves (GREEN on metal)

`tools/al/ales_clipboard_witness.rish`: a `copy_to` fills the clipboard and leaves the source untouched; a `paste` drops the held span into a master byte-for-byte in both channels; the **same** clipboard pastes into a **second, different master** identically (the cross-master proof) and pastes **twice** into one master (the non-consuming proof), the held length unchanged after each; a `cut_to` lifts the span (source shrinks) and the lifted audio pastes elsewhere whole (a move across masters); and every edge refuses by name — a paste of an empty clipboard (`Empty`), a paste past the master (`BadRange`), and a paste that would overflow the destination (`ClipFull`) — each before either channel is touched. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a clipboard a keeper holds a span and pastes it anywhere, across masters and across time. The next rung can offer the **choice of law** where a pasted edit meets its neighbours (a crossfade join rather than a hard butt splice), a **multi-slot clipboard** (a named rack of held spans), or — a module seam, Keaton's word — render the clipboard's held span as an ALES0 wire **frame** so a span travels between two Lotus benches. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
