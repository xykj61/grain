# HUNK55 — tap-to-jump on the filmstrip: a thumbnail is tapped, the cursor lands there

**Stamp:** `20260813.212112` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season A** (Hardware & Right-to-Repair) · **waymark HUNK** · **Photos-app journey** · **rung HUNK55**
**Kin:** [`../brushstroke/edit_filmstrip.rye`](../brushstroke/edit_filmstrip.rye) (HUNK54) · [`../brushstroke/edit_touch_input.rye`](../brushstroke/edit_touch_input.rye) (HUNK50) · [`../image/edit_cursor.rye`](../image/edit_cursor.rye) (HUNK16)
**Teacher, thanked clean-room:** the edit-history filmstrip of a photo app (iCloud Photos / Google Photos) — a keeper taps a thumbnail in the history strip and the picture jumps to that step (concept only, siloed).

---

## What stands, and the gap

HUNK54 paints the whole edit history as a filmstrip — step 0 the untouched source, step *k* the first *k* edits, each a down-mapped thumbnail tiled left to right, with a marker block above the step the cursor currently stands on. A keeper reads the whole road at a glance. Yet the filmstrip is **read-only**: it shows where the cursor stands, but a keeper cannot *move* the cursor by touching it. The finger arc (HUNK50) walks the history one step at a time by swipe — undo left, redo right — so reaching step 2 of a ten-edit history is eight taps. A filmstrip a keeper can read is a filmstrip a keeper wants to **tap**: touch thumbnail *k*, land on step *k*, in one gesture.

## The crux

**A tap on filmstrip band *k* seeks the cursor to step *k*, and the repainted marker sits on exactly the band that was tapped — the band a keeper TAPS equals the band the marker SHOWS.** This is HUNK52's own no-drift discipline (the palette a keeper sees equals the palette they tap) carried to the history strip, and it is the one property that makes tap-to-jump trustworthy: a keeper who taps the third thumbnail must land on the third step, never the second.

The move is a multi-step navigation that **forgets nothing** — jumping from step 5 to step 2 keeps steps 3, 4, 5 redoable, exactly as three undos would. That is the difference between a jump and a fresh edit: `push` forgets the redo tail (HUNK16's crux), a jump preserves the whole history. So the cursor wants one primitive it does not yet have: `seek(target)`, a pure move that clamps the position to `0..=count` and sets it, destroying no edits.

## The pieces

- **`image/edit_cursor.rye` — add `pub fn seek(target: u32)`** (additive, symlinked into `brushstroke/`). Clamps `target` to `0..=list.count` and sets `position`; preserves the governing invariant `position <= list.count`; forgets no edits (unlike `push`). A no-op when `target == position`. Two invariants: the clamp holds the position within the history, and the sought position equals the clamped target.
- **`brushstroke/edit_filmstrip_jump.rye` — `FilmstripJump`**, a surface owning one `EditCursor` and the filmstrip's thumbnail geometry (`tcols`, `trows`). It records history (`push`, delegating to the cursor), classifies a pixel tap into a band, seeks the cursor there, and repaints the filmstrip.
  - **`band_px`** = `tcols * skate.cell_w` — the pixel width of one thumbnail band (a band is `tcols` cells wide, each cell `cell_w` pixels at scale 1). The exact parallel of HUNK50's `x / cell_px`.
  - **`tap_band(x)`** → `?u32`: a negative `x` returns null (off the left edge); `band = x / band_px`; a band past the last step (`band >= cursor.list.count + 1`) returns null (a tap past the filmstrip). Otherwise the band.
  - **`tap_at(x)`** → `?u32`: classify the band; when some *k*, `cursor.seek(k)`; return the band. The one call that turns a tap into a jump.
  - **`paint`** → `edit_filmstrip.filmstrip` of the owned cursor, so the marker lands on the sought step.

## Why it is a pure composition

No new arithmetic beyond a clamped division (HUNK50's own idiom) and the cursor's clamp. No new render primitive — `paint` is HUNK54's `filmstrip` unchanged. No new storage, no pixels beyond the filmstrip's own, no new failure mode: a tap off the strip fires nothing (as HUNK50's tap off the strip does), a seek always clamps. The crux property — tapped band equals marked band — falls out for free, because the marker is painted at `cursor.position` and `tap_at` sets `cursor.position` to the tapped band.

## The proof (what the witness pins)

Over an 8×8 two-tone source and a cursor of three edits:
1. **Tap-to-jump lands exactly** — a tap centered on band 1's pixel span seeks the cursor to position 1; band 2 to position 2; band 0 (the source) to position 0.
2. **No drift** — after a tap on band *k*, the repainted filmstrip's marker block sits on band *k*, cell-for-cell (the tapped band equals the marked band).
3. **Forgets nothing** — jumping back to step 1 then forward to step 3 recovers the full picture; every edit stayed redoable (a jump is not a push).
4. **A tap off the strip fires nothing** — a tap past the last thumbnail returns null and the cursor does not move.
5. **Seek clamps** — a seek past the count lands on the count, a seek at 0 stays at 0, no under/overflow.
6. **Genuinely seen** — the jumped filmstrip rasterizes to a lit canvas.
7. HUNK54 filmstrip, HUNK16 cursor GREEN beneath.

## Horizons (named, not built)

- A **drag** across the filmstrip to scrub the history (continuous seek) — a later rung on the same geometry.
- The filmstrip **scrolled** when the history outgrows the view (HUNK40–47's pager idiom) — the still-open in-assembly kg beside this one.
- The **session-that-travels** crux (persist a live editing session content-addressed) still crosses the pond/apps↔brushstroke assembly-identity seam — held for Keaton / a design round, unchanged by this rung.

*A read a keeper can touch is a road a keeper can walk in one step. May the thumbnail they tap be the step they reach.*
