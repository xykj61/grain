# ALES32 — Lotus's rack paste, joined

**Stamp:** `20260814.145422` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Living design capture — the self-approved round after ALES31
**Waymark:** ALES · rung ALES32
**Kin:** [`ALES30 — the multi-slot rack`](20260814-144031_fill-ales30-lotus-rack.md) · [`ALES31 — the paste that joins`](20260814-144834_fill-ales31-lotus-paste-join.md) · [`lotus/rack_paste_join.rye`](../lotus/rack_paste_join.rye) · [`lotus/rack.rye`](../lotus/rack.rye) (ALES30, `find` reused) · [`lotus/paste_join.rye`](../lotus/paste_join.rye) (ALES31, `paste_join` reused whole)

---

## Why this round

ALES30's rack lets a keeper hold a handful of named spans and paste each by name, yet its `paste` — like the clipboard's before ALES31 — still **butts** the held span against the audio already there, a click where the samples disagree. ALES31 gave the single clipboard the joined paste. This rung hands the same law to the rack, so a keeper drops a **filed** span (the count-in, the verse, the chorus) into the middle of a mix by name without a click at either boundary.

Lindy-first, crux-first: the ALES31 road-on named "hand the same joined law to the rack's paste" as the next rung. It is a pure composition of two already-proven modules — ALES31's `paste_join` over ALES30's name resolution — reusing both whole with no new sample-touching arithmetic, no new seam law, no module seam, no gate. It closes the "still butts" gap on the rack side just as ALES31 closed it on the single-clipboard side.

## The one crux this rung fixes

**Pasting a named slot with `rack_paste_join` is exactly ALES31's `paste_join` on the slot resolved by name — so a filed span joins both its seams equal-power just as the single clipboard does, and a slot's held span is never touched by the paste (it is a read).** Two facts make this exact:

- **`find` resolves the unique name to a single slot index** (ALES30's own naming invariant — a name names at most one slot), so the paste routes to exactly one board.
- **That board is handed whole to ALES31's `paste_join`**, which is itself ALES29's proven two-sided stereo insert-join — the rack's joined paste adds only the name resolution, no new arithmetic, seam law, or bound.

## The shape

`lotus/rack_paste_join.rye`:

- `RackPasteJoinError` — `error{ NoSlot } || paste_join.PasteJoinError`; a name the rack does not hold refuses `NoSlot`, an empty slot forwards `Empty`, a past-the-master position or too-wide `lead`/`trail` forwards `BadRange`, an overflow forwards `ClipFull` — every fault by name before the master is touched.
- `rack_paste_join(r, name, master, at, lead, trail)` — resolve the name to a slot and join its held span into `master` at `at` over `lead`/`trail`; the new length is `master + held − lead − trail`, atomic across the two channels, the slot untouched.

## What the witness proves (GREEN on metal)

`tools/ales_rack_paste_join_witness.rish`: a filed span (`"flip"`) joined at a full-swing sign flip lands a seam sample **strictly inside** the ±30000 extremes where a butt rack paste would step 60000 (the crux), the new length sharing both overlaps (`16 + 8 − 4 − 4 = 16`), the slot's held length unchanged after; a slot joins **twice** into one master and into a **second, different master** with its held length unchanged, and a **second filed slot is untouched** (disjoint slots, ALES30's invariant carried through); and every edge refuses by name — a name the rack does not hold (`NoSlot`), a past-the-master position (`BadRange`), and an overflow (`ClipFull`) forwarded from ALES31 — each before the master is touched, leaving it untouched and aligned. Purely local — no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a joined rack paste a keeper drops any filed span into the middle of a mix by name without a click. The next rung can let a rack **travel as text** (a saveable slot sheet, mirroring ALES22's cue sheet, so the whole rack persists across a session close), or — a module seam, Keaton's word — carry a slot's held span across the ALES0 audio **wire** as a frame so a filed span travels between two Lotus benches. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
