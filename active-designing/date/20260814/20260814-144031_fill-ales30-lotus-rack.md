# ALES30 — Lotus's multi-slot clipboard, a named rack of held spans

**Stamp:** `20260814.144031` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Living design capture — the self-approved round after ALES29
**Waymark:** ALES · rung ALES30
**Kin:** [`ALES25 — the clipboard`](20260814-fill-ales25-lotus-clipboard.md) · [`ALES23 — the selection`](20260814-fill-ales23-lotus-selection.md) · [`lotus/rack.rye`](../lotus/rack.rye) · [`lotus/clipboard.rye`](../lotus/clipboard.rye) (ALES25, `copy_to` / `cut_to` / `paste` reused whole) · [`lotus/pan.rye`](../lotus/pan.rye) (ALES10, the `StereoClip` whose channels share one length)

---

## Why this round

The clipboard (ALES25) holds **one** span and pastes it anywhere, across masters and across time. Yet a keeper working a real session holds **more** than one at once — the count-in, the verse, the chorus, the clean take of the bridge — and reaches for each by **name**, not by remembering which single span the clipboard last held. A rack is that small set of named clipboards: fill a slot from a selection under a name, paste that name later, again, into any master, while every other slot keeps its own held audio.

Lindy-first, crux-first: the rack is the natural generalization of the clipboard the ALES25 road already named as its own next rung ("a multi-slot clipboard, a named rack of held spans"). It stays wholly on the edit side, reusing ALES25's proven `copy_to` / `cut_to` / `paste` over their public API — no module seam, no gate, no new sample-touching arithmetic. It is a higher-Lindy move than a paste-time crossfade ergonomic, because it is a primitive a keeper reaches for on the tenth session as readily as the first.

## The one crux this rung fixes

**A rack holds several independently named spans; pasting one slot by name is exactly ALES25's paste from that slot's own clipboard, and a slot's held span is never touched by a fill, paste, or drop of any other slot.** Two facts make this exact:

- **Each slot owns its clipboard.** A `Slot` embeds a whole ALES25 `Clipboard` with its own bounded buffers, so the slots are disjoint — filling or pasting one reads and writes only that slot's audio, never a neighbour's. The rack holds no shared sample buffer for slots to alias.
- **Every gesture routes to exactly one slot resolved by a unique name.** `copy_to` / `cut_to` refuse a duplicate name, so a name names at most one slot; `paste` / `held` / `drop` resolve that name to a single index and call ALES25's proven operation on that one board. The rack adds naming and bounds, never a new edit.

## The shape

`lotus/rack.rye`:

- `Rack` — a fixed array of up to `max_slots` (8) `Slot`s plus a live `count`; `size()` reports how many named spans are held.
- `Slot` — a bounded `max_name` (24) name beside a whole ALES25 `Clipboard`; once filled it stands alone, surviving any edit to the source master and to any other slot.
- `RackError` — `error{ BadName, Duplicate, RackFull, NoSlot } || clipboard.ClipboardError`; every fault by name.
- `name_of(rack, i)` — read slot `i`'s name back byte-for-byte; `find(rack, name)` — the slot's index or null.
- `copy_to(rack, name, master, sel)` — fill a **new** named slot from a selection, the source untouched.
- `cut_to(rack, name, master, sel)` — fill a **new** named slot from a selection, then remove the span from the master (lift-and-hold, filed under a name).
- `paste(rack, name, master, at)` — paste the span held under `name`, both channels in lockstep, the slot unchanged so it pastes again.
- `held(rack, name)` — the held length of a named span; `drop(rack, name)` — remove a slot so its name may be re-used, tail slots shifting down, no survivor's audio changed.

## What the witness proves (GREEN on metal)

`tools/ales_rack_witness.rish`: two named slots hold two different spans independently, and pasting one by name drops its span byte-for-byte while the other slot's held audio is untouched (the crux); a slot pastes **twice** into one master and into a **second, different master**, its held length unchanged after each (ALES25's non-consuming, cross-master proof, now routed by name); a `cut_to` files a lifted span (source shrinks) and the lifted audio pastes elsewhere whole; a `drop` frees a name — the dropped slot is gone, every surviving slot's audio intact, the freed name paste-able and re-fillable; and every edge refuses by name — an empty or oversized name (`BadName`), a duplicate name (`Duplicate`), a full rack (`RackFull`), a paste/held/drop of an absent name (`NoSlot`), and ALES25's `BadRange` / `ClipFull` forwarded — each before any slot is disturbed. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a rack a keeper carries a handful of named spans through a whole session and pastes each by name. The next rung can let a rack **travel as text** — a saveable slot sheet, mirroring ALES22's cue sheet, so the rack persists across a session close — let a pasted slot **join rather than butt** its neighbour (ALES26's crossfade join at the paste seam), or — a module seam, Keaton's word — carry a slot's held span across the ALES0 audio **wire** as a frame so a filed span travels between two Lotus benches. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
