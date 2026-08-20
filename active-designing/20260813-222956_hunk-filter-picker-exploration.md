# HUNK63 — the filter picker tool

**Stamp:** `20260813.222956` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season A (Hardware & Right-to-Repair) · waymark HUNK · Photos-app journey · rung HUNK63**
**Kin:** [`filter_preset.rye`](../image/filter_preset.rye) (HUNK30 `PresetBook` · `stock_book`) · [`preset_preview.rye`](../brushstroke/preset_preview.rye) (HUNK33 preview) · [`edit_cursor.rye`](../image/edit_cursor.rye) (HUNK16 history) · [`crop_editor.rye`](../brushstroke/crop_editor.rye) (HUNK62 — the tool pattern this parallels)

## The gap this rung closes

The crop sub-arc (HUNK60–62) turned the app's first crux gesture into a whole tool: a keeper drags a frame, sees it over the picture, commits it into the non-destructive history, and chains another. The itinerary names cropping *"plus the common iCloud Photos / Google Photos gestures"* ([`the double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md), Season A), and the second-most-central of those is **choosing a filter**.

Every seam for it already stands proven — HUNK30 knows the stock filters by name, HUNK33 previews a named filter over an image, HUNK16 holds the non-destructive history — yet nothing ties them into a *tool* a keeper drives. A keeper cannot yet do the other thing a photo app is for: **swipe through the filters, see each one on their own picture, and keep the one they like.**

## The move

`FilterPicker` owns the immutable `source`, a `PresetBook` (the stock filters), an `EditCursor` (the same non-destructive history the crop tool commits into), and a `selection` — which filter in the book a keeper currently has under their finger. `select_next`/`select_prev` walk the selection, clamped to the book's ends (a carousel that never falls off, exactly as HUNK40's scroll cursor is bottom-pinned); `select_to` jumps.

`preview` looks at the **currently selected** filter over the **current view** (the source with every committed edit already applied, HUNK16) and returns a Skate grid — so a keeper sees the pending filter over the picture as it stands, not over a stale original. `commit` pushes the selected preset's whole recipe onto the cursor (each verb in book order), so a chosen filter joins the same edit-list every other gesture lives in (HUNK11): it travels as text, reproduces from cold, and walks with undo/redo for free. A second filter chains over the first, measured over the newly filtered view — the exact parallel of a crop chaining over a crop.

The tool invents no pixel op and no new failure mode: previews and commits ride proven verbs, and the only honest refusal is `EmptyImage` at open for a zero-dimension source. A stock recipe never refuses on a well-formed image (HUNK30's guarantee), so a committed filter always lands.

## Why this shape

- **Lindy-first.** Choosing a filter is the app's second central editing act, read thousands of times over the app's life; it outweighs another history-surface refinement (the filmstrip auto-pan named earlier) which polishes an already-strong sub-feature.
- **Crux-first.** The hardest still-tractable move is committing a *whole recipe* into an edit-granular history so it chains and walks like a single verb — proven, not assumed. Edit-granularity is the honest choice: a two-verb filter (`noir`) commits two edits, and undo steps them one at a time, exactly as the edit-list vocabulary already works. The tool documents this plainly rather than hiding a preset behind a single opaque undo.
- **Pure composition.** No store, no beads, no key, no funds: the picker holds a book and a cursor and drives the proven preview and apply seams. The source is never mutated.

## The proof (selftest)

A small colour image where each pixel carries a distinct colour, so a filter's colour work shows in the down-mapped grid:

1. The picker opens over the stock book, selection at the first filter; `select_next`/`select_prev` walk it and **clamp at both ends** (never off the book).
2. `preview` of the selected filter equals a direct `edit_preview.preview` of that recipe over the current view **cell-for-cell** — no drift between what the picker shows and what the recipe means.
3. Selecting `mono` and committing pushes its one edit; the current view equals `apply_preset(book, "mono", source)` **byte-for-byte** — the picker's commit is exactly the named filter.
4. Chaining `bright` over `mono` commits a second edit; the view equals the two recipes applied in order — filters chain, each over the last.
5. `undo` walks back the `bright` edit (the view returns to `mono`); `redo` returns; `undo` all the way recovers the **source byte-for-byte** — non-destructive throughout.
6. Committing `noir` (a two-verb recipe) advances the cursor by two, and the view equals `apply_preset(book, "noir", …)`; one undo steps back a single verb — the edit-granular history made visible.
7. A **zero-dimension image** refuses `EmptyImage` at open.

## The road on from here

- A Skate **filter strip** under the picture — the whole book previewed at once (HUNK33's `preview_book`) with the selection marked, so a keeper reads every filter over their photo before swiping (a later rung, paralleling the crop overlay's on-glass frame).
- A **swipe gesture** driver (HUNK50's finger law) that turns a horizontal drag into `select_next`/`select_prev`, so the carousel moves under a finger rather than a discrete call.
- A tool that unifies crop and filter into one **Photos editor** owning a single cursor both commit into — the app's whole editing surface behind one history.
