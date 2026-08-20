# HUNK33 — the Skate preview of a named filter, seen before it is committed

**Stamp:** `20260813.183502` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- self-approved design round · **Season A** (Hardware & Right-to-Repair) · **waymark HUNK** · Photos-app journey · rung **HUNK33**
**Kin:** [`../image/filter_preset.rye`](../image/filter_preset.rye) (HUNK30) · [`../brushstroke/edit_preview.rye`](../brushstroke/edit_preview.rye) (HUNK13) · [`../brushstroke/image_skate.rye`](../brushstroke/image_skate.rye) (HUNK2)

## Where the road stands

The filter-preset journey stands whole: HUNK30 gave a keeper filters *by name*, HUNK31 let a book travel as text, HUNK32 banked a curated book content-addressed. HUNK13 gave the *eye* — a pending edit-list previewed as a Skate grid before it is committed. Both journeys are proven; neither lets a keeper **look at a filter by its name** before choosing it.

By Lindy-first, crux-first, that look is the crux. A keeper reaches for "noir" or "vivid" daily, and the daily gesture is not *apply then judge* — it is *see the strip of named filters over my own photo, then tap the one I want*. HUNK13 previews a raw edit-list; this rung previews **by name**, and its distinguishing property — the one edit-preview cannot claim — is the **filter strip**: a whole book of named filters previewed over one image at once, each cell a named look, none committed.

## The keystone (HUNK33)

`brushstroke/preset_preview.rye`, composing two proven seams and adding no new byte-level pipeline:

- `preview_preset(alloc, book, name, source, cols, rows) -> skate.Grid` — look the recipe up by name in the `PresetBook` (`find`), then hand its edit-list to `edit_preview.preview` (HUNK13, pure — the source untouched, nothing stored). An absent name refuses `UnknownPreset` **before** a grid is built; a verb's own refusal folds through `preview` by its name, adding no new failure mode.
- `preview_book(alloc, book, source, cols, rows, out_grids) -> u32` — the **filter strip**: preview *every* preset in the book over one source, filling a caller-supplied slice of grids and returning the count. Bounded by `filter_preset.max_presets`; the source is previewed, never touched, once per named filter.

## The properties the witness proves

1. **Previews by name, equalling the recipe's own preview** — `preview_preset(book,"vivid",img)` equals `edit_preview.preview(img, book.find("vivid").list)` cell-for-cell and fg-for-fg.
2. **The named preview shows the filter's real work** — `mono` (grayscale) previews to a different grid than `vivid` (saturated) over the same image; a name is not a no-op in the view.
3. **The filter strip** — `preview_book` fills one grid per preset, each equal to that preset's own `preview_preset` cell-for-cell, so a keeper scrolls the whole book over one photo, nothing committed.
4. **Non-destructive and deterministic** — the source is untouched after any preview, and the same name over the same image previews to the same grid twice.
5. **Genuinely seen** — a named preview rasterizes to a lit canvas.
6. **Refusals named** — an unknown name refuses `UnknownPreset` before a grid; the down-map's own `EmptyImage` / `GridTooLarge` surface unchanged; a strip past the ceiling refuses `Overflow`.

No name is stored, no bead written, no funds touched — a preview is a look, not a commit.

## The home, and why brushstroke/

The Skate view is a Brushstroke concern; `edit_preview.rye` and `image_skate.rye` already live in `brushstroke/`. `preset_preview.rye` sits beside them, importing `edit_preview.rye` and `image_skate.rye` (real) and `skate_grid.rye` (real), with a new `brushstroke/filter_preset.rye` symlink to `../image/filter_preset.rye`; that module's deps (`qoi` · `photo_edits` · `tally_copy`) already resolve as symlinks in `brushstroke/`, exactly as the HUNK13 pattern resolved its own.

## Horizons (named, not half-built)

- The **served** filter strip — a Comlink-served preview of a keeper's book over an artifact image (touches the Comlink-served custody gate; stops there).
- A preview of a *content-addressed* book reopened from cold (compose HUNK32's `open_book` with the strip).
- The Realidream page that lays the strip out as a scrollable gallery.
