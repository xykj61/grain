# HUNK — the strip painted beside the picture: a keeper reads the palette they tap

**Stamp:** `20260813.205957` · **Status:** Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-205200_hunk-edit-finger-view-exploration.md`](20260813-205200_hunk-edit-finger-view-exploration.md) — HUNK51's finger-driven view · [`image_skate.rye`](../brushstroke/image_skate.rye) — HUNK2's down-map
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## Why this round, now

HUNK51 gave the Photos editor a whole finger: a keeper taps a gesture-strip cell and the picture on glass repaints the committed edit, a swipe walks the history — all through one cursor, so the glass never drifts from the finger. Yet the strip itself is **invisible**. A keeper taps pixel columns they cannot see, trusting that cell 0 is `flip_h` because they were told so. HUNK51's own named intent points straight here: *render the gesture strip as a Skate row of verb chips above the image, so a keeper reads the palette they are tapping.*

Reading **Lindy-first, crux-first**, this is the palette's own last mile — the visible half of the surface HUNK51 built the invisible half of. It composes only proven parts: HUNK2's down-map palette (`set_anchor_palette`, `block_cell`, the seven anchors) paints each chip a solid block, and HUNK51's finger geometry decides where each chip sits.

## The crux

> **The chip a keeper sees at pixel column *x* is exactly the verb a tap at *x* commits.** `paint_strip` renders a `chips × 1` Skate row where chip *i* wears the stable color of the verb bound at strip cell *i*, and chip *i* occupies exactly the pixel span `[i·cell_px, (i+1)·cell_px)` — the same span `finger_up` reads as cell *i*. So the palette a keeper reads and the palette a keeper taps can never disagree, structurally. The exact parallel of HUNK51's no-drift, carried from the picture to the palette.

## The shape

`brushstroke/edit_strip_view.rye`:

- `EditStripView { finger: EditFingerView }` — HUNK51's finger-driven view, wrapped so the same object that edits the picture also paints its palette.
- `open` / `bind` / `finger_down` / `finger_up` / `paint` / `depth` — thin delegations to HUNK51, so nothing about the editing changes.
- `chips()` — how many verb chips the strip carries (HUNK50's `cells()`).
- `chip_slot(e)` — the stable palette slot (1..7) a verb wears, folded from the verb kind's ordinal into HUNK2's anchor palette; the same verb always the same color.
- `chip_center_x(i)` — the pixel column at the center of chip *i*, exactly where a tap commits verb *i* — the tie between the painted chip and the finger geometry.
- `paint_strip(allocator)` — the `chips × 1` down-mapped row, each chip a solid anchor block; refuses `EmptyStrip` before any grid is built when nothing is bound.

The row adds no new arithmetic beyond a modulo into the palette and the cell-center a tap already uses; every pixel and color is HUNK2's, every geometry is HUNK50's.

## What the witness proves on metal

A three-verb strip (`flip_h`, `flip_v`, `rotate`) on a ten-pixel cell: `paint_strip` yields a `3 × 1` grid, each chip a full block; chip *i*'s color is exactly `chip_slot` of the verb bound at cell *i*; the row rasterizes to a lit canvas, each chip its own solid color; and — the crux — a real finger tap centered on chip *i* (`chip_center_x(i)`) fires a commit of exactly the verb that chip *i* paints, for every chip, so the seen palette and the tapped palette agree cell-for-cell. An unbound strip refuses `EmptyStrip`; a bad grid, cell, or swipe still refuses at open by name (HUNK51 beneath). No network, no key, no funds.

## Where this journey goes next (named intent, not yet built)

- **The chips stacked over the picture.** Compose the chip row and the picture into one canvas — the palette above, the image below — so a caller paints the whole Photos screen in one call.
- **A gesture session that travels.** Record the raw finger session content-addressed, so a keeper's whole touch edit reproduces from a name (composes HUNK12's edit store).

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The chip color is HUNK2's anchor palette; the chip geometry is HUNK50's cell width; the editing is HUNK51. No new palette, no new render primitive, no new clamp.
- **Bounds, widths, asserts.** The row bounded by `max_strip`, the slot within `anchor_count`, ≥2 positive invariants per function (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — a pure surface over proven seams.
