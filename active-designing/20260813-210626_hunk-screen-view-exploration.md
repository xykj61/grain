# HUNK — the whole Photos screen in one call: the palette above, the picture below

**Stamp:** `20260813.210626` · **Status:** Living (self-approved design round) · **Voice:** Kyri · **Style:** Radiant
**Waymark:** **HUNK** (Season A, Photos-app journey; seated in [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md))
**Road:** [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) — **Season A, Hardware & Right-to-Repair**
**Builds on:** [`20260813-205957_hunk-strip-chips-view-exploration.md`](20260813-205957_hunk-strip-chips-view-exploration.md) — HUNK52's chip row · [`edit_finger_view.rye`](../brushstroke/edit_finger_view.rye) — HUNK51's picture
**Kin:** [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md)

---

## Why this round, now

HUNK52 painted the gesture strip as a chip row, and HUNK51 paints the edited picture. Two proven surfaces — yet a caller still had to place them by hand: paint the strip, paint the picture, decide where each goes. HUNK52's own named intent points straight here: *compose the chip row and the picture into one canvas — the palette above, the image below — so a caller paints the whole Photos screen in one call.*

Reading **Lindy-first, crux-first**, this is the screen's assembly — the last step that turns two surfaces into the one thing a device shows. It composes only proven grids; every pixel and color is already witnessed beneath.

## The crux

> **The whole editing screen is one grid, and the composition adds no drift.** `paint_screen` stacks HUNK52's `chips × 1` chip row in the top row and HUNK51's `cols × rows` picture in the rows below, into a single grid `max(cols, chips)` wide and `1 + rows` tall. Each sub-surface is written into its own place unchanged, so the screen's top row equals `paint_strip` cell-for-cell and its picture region equals `paint` cell-for-cell. What a keeper sees stacked is exactly the two surfaces already proven — no new arithmetic, only placement.

## The shape

`brushstroke/edit_screen_view.rye`:

- `EditScreenView { strip: EditStripView }` — HUNK52's strip view (itself HUNK51's finger view), wrapped so the one object that edits and paints the palette also composes the screen.
- `open` / `bind` / `finger_down` / `finger_up` / `chip_center_x` / `chips` / `depth` — thin delegations, so nothing about editing or the palette changes.
- `paint_screen(allocator, source)` — the composed grid: chip row on top, picture below, each copied cell-for-cell from its proven sub-grid; refuses `EmptyStrip` (a screen shows a palette) before any picture work. Cells outside a sub-surface's width stay blank.

## What the witness proves on metal

A two-verb strip over an 8×8 two-tone on a 2×2 picture grid: `paint_screen` yields one `2×3` grid (`max(2,2)` wide, `1+2` tall); the top row equals `paint_strip` cell-for-cell and the picture region equals `paint` cell-for-cell (no drift); a real finger tap centered on chip 0 (`flip_h`) repaints the picture region — the picture's top-left cell turns from red to blue *in the composed screen itself*, one row below the palette; the whole screen rasterizes to a lit canvas; an unbound screen refuses `EmptyStrip`; a zero grid, cell, and swipe each refuse at open by name (HUNK52/51 beneath). No network, no key, no funds.

## Where this journey goes next (named intent, not yet built)

- **A gesture session that travels.** Record the raw finger session content-addressed, so a keeper's whole touch edit reproduces from a name (composes HUNK12's edit store).
- **The screen scrolled.** When a picture is taller than the screen, page the picture region under the fixed palette (composes HUNK40–47's scroll cursor).

## Discipline this round keeps

- **Two rooms.** The crux is a green witness or it stays named intent — the horizon rungs above are intent, not settled fact.
- **Reuse, never re-invent.** The chip row is HUNK52; the picture is HUNK51; the palette seam is HUNK2's `set_anchor_palette`. No new render primitive, no new clamp, no new color.
- **Bounds, widths, asserts.** The screen bounded by the sub-surfaces' own ceilings, ≥2 positive invariants per function (TAME).
- **Gates stay the fence.** No funds, keys, provisioning, or network — a pure surface over proven grids.
