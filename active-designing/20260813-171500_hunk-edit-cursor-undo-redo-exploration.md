# HUNK16 — the edit cursor: undo and redo over one history, a new edit forgets the road not taken

**Stamp:** `20260813.171500` · **Voice:** Kyri · **Style:** Radiant · **Status:** Vision -- Living (self-approved design round)
**Season A · waymark HUNK · Photos-app journey · rung HUNK16**
**Kin:** [`../image/photo_edits.rye`](../image/photo_edits.rye) · [`../image/photo_revert.rye`](../image/photo_revert.rye) · [`../image/photos.rye`](../image/photos.rye) · [`double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md)
**Teacher, thanked clean-room:** the undo/redo history stack of a photo editor (iCloud Photos / Google Photos, and every editor before them) — a position walks back and forth over one recorded history, and a fresh edit past a rewind discards the branch you did not keep (concept only, siloed).

---

## The crux, named

HUNK11 recorded the six Photos verbs as a bounded `EditList` and replayed them over an untouched source. HUNK14 banked what that purity buys: a *revert* is only dropping edits off the end of the list, and because the source list survives untouched, the dropped edits could be **redone** — yet nothing in the tree held the one small piece of state redo actually needs: **where in the history a keeper currently stands.** `revert_one` hands back a shorter list and forgets that a longer one ever existed.

HUNK16 is that missing piece: an **edit cursor** — the whole recorded history in one value, plus a `position` naming how many of its edits are currently in effect. Undo steps the position back; redo steps it forward; the image a keeper sees is `apply(source, first `position` edits)`. Nothing is destroyed by a walk — undo and redo only move the position, so a keeper can rewind ten edits and roll every one of them forward again, byte-for-byte.

The one genuinely new design decision — the crux — is what happens when a keeper, standing rewound in the middle of their history, makes a **fresh edit**: the redo tail past the cursor is **forgotten**, and the new edit becomes the live edge. This is the universal undo/redo law (the road not taken is discarded the moment you take a different one), and it is the property that makes a cursor more than a pair of counters.

## Why this is the Lindy-first crux

- **It is the durable capability, not one more pixel verb.** Every editing surface the tree will ever grow — the Photos app, the Realidream graph editor, any keeper-facing tool — wants undo/redo. A cursor over an edit-list is that capability once, composed over proven seams, rather than a seventh, eighth, ninth verb padding the count.
- **It composes, inventing no storage.** The cursor holds one `EditList` (HUNK11) and a `u32`. `applied` is HUNK14's own `truncate`; `view` is HUNK11's own `apply`. No new buffer, no new failure mode a verb did not already own.
- **It stays non-destructive twice over.** The source image is never mutated (HUNK11), and a walk of the cursor never destroys history (only a fresh edit truncates the redo tail, and only past the cursor). Both promises hold by construction.

## The value model

```
EditCursor = record:
  list     : EditList   // the whole reachable history, up to the live edge
  position : u32        // how many of list's edits are currently applied, 0 <= position <= list.count

applied(cursor)          = truncate(cursor.list, cursor.position)   // HUNK14
view(source, cursor)     = apply(source, applied(cursor))           // HUNK11
push(cursor, edit)       : truncate list to position, push edit, position = list.count   // a fresh edit forgets the redo tail
undo(cursor)             : if position > 0, position -= 1           // clamps at 0
redo(cursor)             : if position < list.count, position += 1  // clamps at the live edge
can_undo / can_redo      : the two guard predicates
```

The invariant that governs the whole structure is one line: **`position <= list.count`, always.** Every operation preserves it — `push` sets `position = list.count` after growing the list; `undo` only lowers `position`; `redo` raises it only while it stays under `list.count`.

## What the selftest proves (on a 6×6 coordinate-tagged image, so correctness is unambiguous)

1. **Undo walks back, redo walks forward, byte-for-byte.** From a three-edit history, undo to two edits equals the first two verbs by hand; redo returns to three; the full view returns byte-for-byte.
2. **A walk destroys nothing.** Rewind all the way to the original (position 0, the empty-list apply), then redo every step back to the full image — each intermediate view matches its by-hand replay.
3. **The crux: a fresh edit forgets the redo tail.** Rewind one step, push a *different* edit, and the cursor's history is now (the kept prefix + the new edit); the discarded edit is gone (`can_redo` is false), and the new view is the prefix replayed with the new verb.
4. **Undo and redo clamp, never underflow or overflow.** Undo past the original stays at 0; redo past the live edge stays at `list.count`; `can_undo`/`can_redo` report the edges honestly.
5. **The applied prefix still travels as an open, fixed-point record.** `render(applied)` parses back and replays to the same bytes — a cursor position is a shareable edit-list like any other.
6. **The ceiling holds.** Pushing past `max_edits` refuses `TooManyEdits` through the list's own bound; no new error class is invented.

No network, no key, no funds — a pure look and a pure move over the edit-list. No custody gate is reached.

## Next doors past HUNK16

- A **branching** history (keep the road not taken as a named alternate) — a richer editor model, its own later rung, not this one.
- The cursor **painted through Skate** (a redo tail shown dimmed) — pure composition over HUNK13's preview and HUNK15's revert view.
- The cursor **beaded into Tablecloth** as a keeper's live editing session — stands on HUNK12's content-addressed edit-list.

*The history a keeper walks stays whole under their feet; only a fresh choice ever forgets a road, and only the road they chose to leave.*
