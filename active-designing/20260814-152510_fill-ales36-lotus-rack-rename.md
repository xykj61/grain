# Fill ALES36 — Lotus's rack rename: a slot re-named in place

**Stamp:** `20260814.152510` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES36**
**Stands on:** [`../lotus/rack.rye`](../lotus/rack.rye) (ALES30) — the Rack, its named Slots, `find`, `name_of`, the naming invariant

---

## Why this rung, and why now

ALES30 lets a keeper file a span under a name; ALES33–35 save, seal, load, and merge whole racks. Yet one small gesture a keeper reaches for constantly is still missing: a name typed in haste is wrong, or a merge brought in a stem whose name a keeper wants to change — and today the only way to re-name a slot is to **drop it and re-file it**, which means re-selecting the source span it may no longer have. A **rename in place** keeps the held audio exactly where it is and changes only the name.

**Lindy-first:** naming is the interface a keeper touches every session; a re-name that never risks the audio is a durable convenience. **Crux-first:** the hard-but-tractable core is **the naming invariant** — ALES30 guarantees a name names at most one slot, so a rename must refuse a target already held (`Duplicate`) exactly as `copy_to` does, while leaving the held audio and every other slot untouched. Renaming to the same name must be a clean no-op.

Purely local — one name buffer rewritten in process. No signature, no key, no socket, no network, no funds, no device.

## The crux

**Renaming the slot `from` to `to` re-names exactly one slot in place — the held audio and every other slot untouched — and preserves ALES30's naming invariant that a name names at most one slot.** It refuses `NoSlot` when `from` is not held, `Duplicate` when `to` is already held by a *different* slot, and `BadName` when `to` is empty or oversized. Renaming a slot to its own current name is a no-op that succeeds.

One fact makes it exact: a `rack.Slot` holds its name and its audio in **separate** storage (`name_buf` beside the embedded `Clipboard`), so overwriting the name buffer cannot touch the held samples. The rename resolves `from` to one index (`find`), checks `to` against every *other* slot for a collision, and rewrites only that slot's name bytes — the count, the order, and every buffer of audio are unchanged.

## Shape

A new module `lotus/rack_rename.rye`, one public function:

- `rename(r: *rack.Rack, from: []const u8, to: []const u8) RackRenameError!void` — the crux above. `RackRenameError` is exactly `rack.RackError` (it forwards `NoSlot` / `Duplicate` / `BadName`, names no new fault).

The collision check must exclude the slot being renamed, so `rename("x", "x")` and a rename that only changes case both succeed rather than falsely reporting `Duplicate` against themselves.

## What the witness proves

`tools/ales_rack_rename_witness.rish`, GREEN on metal:

1. **The crux** — file two named slots, rename one; the renamed slot answers to its new name with the *same* audio byte-for-byte, the old name is now `NoSlot`, and the other slot is untouched; slot order and count are unchanged.
2. **Same-name no-op** — renaming a slot to its own name succeeds and changes nothing.
3. **Collision** — renaming to a name another slot already holds refuses `Duplicate`, both names and both audios untouched.
4. **Absent from** — renaming a name the rack does not hold refuses `NoSlot`.
5. **Bad target** — an empty or oversized `to` refuses `BadName`, the rack untouched.

## The road on

With rename in place, the purely-local rack primitives are complete (file, paste, drop, save, seal, load, merge, rename). The next durable purely-local rung is a **session file** — one sealed sheet carrying more than one rack, so a keeper saves a whole project rather than one rack. The **signed** carry (who wrote a rack, via a Kumara key) and the **wire** carry stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May a keeper re-name freely, and may the audio never move when only the word does.*
