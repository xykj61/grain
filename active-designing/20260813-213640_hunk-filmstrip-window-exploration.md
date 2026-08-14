# HUNK57 — a windowed filmstrip: a history longer than the strip is wide, read a window at a time

**Stamp:** `20260813.213640` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season A** (Hardware & Right-to-Repair) · **waymark HUNK** · **Photos-app journey** · **rung HUNK57**
**Kin:** [`../brushstroke/edit_filmstrip.rye`](../brushstroke/edit_filmstrip.rye) (HUNK54, extended additively) · [`../brushstroke/edit_filmstrip_scrub.rye`](../brushstroke/edit_filmstrip_scrub.rye) (HUNK56) · [`../image/edit_cursor.rye`](../image/edit_cursor.rye) (HUNK16)
**Teacher, thanked clean-room:** the scrollable edit-history strip of a photo app (iCloud Photos / Google Photos) — the strip shows a handful of thumbnails at a time, never the whole history at once (concept only, siloed).

---

## What stands, and the gap

HUNK54 paints the whole edit history as one filmstrip — every step a thumbnail, the cursor's step marked — and HUNK55/56 let a keeper tap or drag it to navigate. Yet the strip paints *every* step into one grid, `steps·tcols` wide, and refuses `FilmstripTooWide` once that width passes the map ceiling. Two truths break the whole-strip model as a history grows: a real edit history reaches `max_edits` (64) steps, and a phone screen shows only a handful of thumbnails at once. A 64-edit history at a four-cell thumbnail already tiles past the 256-cell map ceiling (65·4 > 256) — so it **cannot be painted at all** today. The strip needs to show a *window*.

## The crux

**A bounded window of the history paints only `count` thumbnails starting at step `first`, mapping window band `j` to absolute step `first + j`, with the marker shown only when the current step stands inside the window.** This is the one primitive every scrolling or windowing model needs — and it forces no interaction decision, because it only *paints* a range; whichever gesture later chooses the range (a scrubber that pulls the strip, or a separate scroll) composes this same primitive.

The subtle, honest part is the marker. In the whole strip the current step is always present, so the marker always draws. In a window the current step may be **scrolled off-view** — and then the marker row must be **blank**, an honest "you are elsewhere," rather than marking a band that is not the current step. A marker that always drew somewhere would lie about where the keeper stands.

## The pieces

- **`brushstroke/edit_filmstrip.rye` — add `pub fn filmstrip_window(allocator, source, cursor, tcols, trows, first, count)`** (additive to HUNK54's module, exactly as `seek` was added to HUNK16's for HUNK55). It clamps the count to the real steps (`vis = min(count, steps - first)`), so a window running past the live edge paints only steps that exist; tiles band `j` with a HUNK13 preview of absolute step `first + j`; draws the marker only when `first ≤ position < first + vis`. Refuses `FilmstripBadWindow` on an empty count or a `first` past the last step, and `FilmstripTooWide` when the *visible window* itself would pass the ceiling.
- **`filmstrip` becomes a thin wrapper** — `filmstrip_window(…, 0, max_edits + 1)`, the full window clamped to every step. So HUNK54's own witness proves the wrapper's parity with the old behavior, and the tiling logic lives in exactly one place (no duplication).

## Why it is a pure composition

The window is a clamp and an offset over HUNK54's own tiling — no new render primitive, no new arithmetic beyond a clamped subtraction and the band offset `first + j`. The marker's in-window test is one range check. No new storage, no history moved, no source mutated. The whole strip is now a special case of the window, so the two can never drift.

## The proof (what the witness pins)

Over a two-tone source and a six-edit history (seven steps):
1. **No drift** — a window of three bands from step 2 paints steps 2, 3, 4, each band equal to a direct preview of that absolute step cell-for-cell (band `j` shows step `first + j`).
2. **Marker in-window** — the current step (3) marks band 1 (`3 − first 2`); the other bands blank.
3. **Marker off-view** — with the current step at 0, outside the window `[2, 5)`, the marker row is blank everywhere.
4. **Clamp past the live edge** — a window of 3 from step 5 paints only steps 5, 6 (two bands), never a phantom step.
5. **Full window equals the whole filmstrip** — a window from step 0 counting past the history equals `filmstrip` cell-for-cell.
6. **Bad window refuses by name** — an empty count and a `first` past the last step each refuse `FilmstripBadWindow`.
7. **The crux** — a full-length history at a four-cell thumbnail refuses `FilmstripTooWide` for the whole strip, yet a five-band window paints GREEN and rasterizes to a lit canvas. The history is readable a window at a time.

## Horizons (named, not built) — one is a real design fork

- **The windowed scrub surface** — a `FilmstripScrub` that owns a window, mapping a window-relative touch to an absolute band and advancing the window as the finger reaches an edge. This raises a genuine **interaction-design fork**, worth a check-in: does scrubbing *pull* the strip along (the marker stays under the finger, the window follows), or is scrolling a *separate* gesture from scrubbing? Both are real photo-app models. This primitive serves either; the choice wants Keaton's eye.
- **A velocity fling** across the window (HUNK45's idiom) — a later rung once the interaction model is chosen.
- The **session-that-travels** crux still crosses the `pond/apps`↔`brushstroke` assembly-identity seam — held for Keaton, unchanged by this rung.

*A road too long to see at once is still a road you can walk a window at a time. May the step you stand on be marked when it is near, and may the strip be honest when it is far.*
