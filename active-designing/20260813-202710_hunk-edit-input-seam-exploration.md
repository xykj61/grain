# HUNK — the edit input seam: a keeper's gesture becomes exactly one history move

**Stamp:** `20260813.202710` · **Status:** Mixed -- Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-171500_hunk-edit-cursor-undo-redo-exploration.md`](20260813-171500_hunk-edit-cursor-undo-redo-exploration.md) — the HUNK16 EditCursor
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`../image/edit_cursor.rye`](../image/edit_cursor.rye) · [`../image/photo_edits.rye`](../image/photo_edits.rye) · [`../pond/apps/preset_scroll_input.rye`](../pond/apps/preset_scroll_input.rye)

---

## Why this round, now

Two arcs of the Photos app already stand whole. The **editing** arc records the six-plus verbs as a bounded `EditList` (HUNK11), reverts by dropping edits (HUNK14), and walks a live history with undo and redo (HUNK16) — a keeper who *already holds a gesture* can push it, walk back, walk forward, and the viewed image never drifts from the position. The **scroll** arc grew its own input seam (HUNK43): `apply(cursor, input)` translates a raw event — a wheel notch, a page key — into exactly one cursor move, so every clamp the `ScrollCursor` holds survives whatever the device sends.

The `EditCursor` has no such seam above it. A device speaks gestures — a committed verb, a swipe-back, a swipe-forward — not method calls; nothing yet maps one raw editing gesture to exactly one history move. Reading **Lindy-first, crux-first**, this boundary is the missing durable piece: it is read every time a keeper touches the editor, it composes only proven parts (HUNK16's `push`/`undo`/`redo`, HUNK11's `Edit` value model), and it invents no storage, no pixels, and no new failure mode. It is the exact parallel of HUNK43, one arc over.

## The crux

> **One raw editing gesture — commit this verb, undo, or redo — becomes exactly one `EditCursor` move, preserving every clamp the cursor already holds: an undo at the original is a no-op, a redo at the live edge is a no-op, and a committed verb forgets the redo tail. The seam adds no new refusal; the list's own `TooManyEdits` ceiling is the only one it can surface.**

## The shape

`image/edit_input.rye` — entirely within the `image/` assembly beside the cursor it drives, so no cross-assembly type wall.

- `GestureKind = enum { commit, undo, redo }` — the three raw editing gestures.
- `Gesture = struct { kind: GestureKind, edit: Edit }` — one value model, an enum tag beside the `Edit` payload `commit` reads (the others ignore it), with a `commit(e)` constructor mirroring HUNK43's `scroll_by`.
- `apply(cursor, gesture) EditsError!void` — routes `commit` to `cursor.push` (which may refuse `TooManyEdits` at the ceiling), `undo` to `cursor.undo`, `redo` to `cursor.redo`. Positive invariants front and back: the cursor stands within its history before and after, always.

## What the witness proves on metal

A real source image and a real gesture stream: a committed verb advances the depth and the viewed image tracks byte-for-byte; an undo gesture walks it back and a redo forward, the image recovered exactly; a redo at the live edge and an undo at the original each move nothing; a commit while rewound forgets the redo tail (the road not taken discarded); and the list's ceiling still refuses `TooManyEdits` through the seam — no new error invented. HUNK16 GREEN beneath.

## Where this journey goes next (named intent, not yet built)

- **The touchable editor.** Bind this seam to a finger surface as HUNK47 bound the scroll session to the painted view — a tap commits, a swipe undoes/redoes, and the down-mapped image repaints from the same cursor, so the picture cannot drift from the history. (Composes HUNK17's cursor preview and HUNK2's `down_map`.)
- **A gesture log that travels.** Record the raw gesture stream itself content-addressed, so a keeper's whole editing session reproduces from a name.

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The moves are HUNK16's `push`/`undo`/`redo`; the payload is HUNK11's `Edit`. No new storage, cursor, or refusal.
- **Bounds, widths, asserts.** `u32` depth inherited from the cursor; the `Edit` payload carries its own bounded parameters; ≥2 positive invariants per function (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — a pure translation over a value model.
