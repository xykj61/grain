# HUNK30 — named filter presets: a book of recipes applied by name

**Stamp:** `20260813.181925` · **Waymark:** HUNK · **Season A** (Hardware & Right-to-Repair) · **Journey:** Photos app
**Status:** self-approved design round · **Kin:** [`photo_edits.rye`](../image/photo_edits.rye) (HUNK11) · [`edit_store.rye`](../pond/apps/edit_store.rye) (HUNK12)

## Where the road stands

HUNK29 closed the edit-list vocabulary: every gesture the Photos app can do — the six geometry verbs and the whole HUNK21–27 filter family — now records, replays, and travels as data. HUNK29 named the next agent-doable crux two ways: *a dedicated general filter round-trip witness*, and *named filter presets (a saved edit-list applied by name)*.

By Lindy-first, crux-first, the presets are the crux. A round-trip witness re-proves what the selftest already holds; a **preset book** opens a genuinely new, durable, user-facing capability — the "filters by name" a keeper reaches for daily. It is read and used far more often than a one-shot edit, so the effort compounds.

## What a preset is, against what already exists

HUNK12's `edit_store` beads *one keeper's* edit-list content-addressed and reproduces it over its own source. Its `reproduce` already takes the source as a parameter, so a stored recipe is not tied to one image — yet its home is a store of *saved user recipes*, keyed by content address.

A **filter preset** is a different thing: a *named, in-code library* the app ships with — `vivid`, `mono`, `noir`, `soft` — each a small edit-list, applied to **any** image by its plain name. No store, no beads, no funds; a book of recipes the Photos app knows by heart. The distinguishing property, the one `edit_store` cannot claim, is that a single preset applies to *many different images*, each reproducing that image's own recipe-by-hand.

## The keystone (HUNK30)

`image/filter_preset.rye`:

- `PresetBook` — a bounded named collection of `photo_edits.EditList` recipes (`max_presets`, `max_preset_name`).
- `define(name, list)` — add a preset; refuses `PresetExists`, `TooManyPresets`, `BadPresetName`.
- `find(name)` / `apply_preset(alloc, book, name, source)` — look a recipe up and replay it over any image (reusing `photo_edits.apply`); an absent name refuses `UnknownPreset`.
- `stock_book()` — the well-known filters, each an honest recipe over verbs the app already has: `vivid` (saturate up), `pop` (saturate strong), `mono` (saturate 0 → true grayscale), `noir` (mono + contrast), `bright` (brightness lift), `auto` (auto-levels stretch), `soft` (blur), `sharp` (sharpen), `sketch` (edges).

## The properties the witness proves

1. **Applies by name, equalling the recipe by hand** — `apply_preset(book,"vivid",img)` equals `photos.saturate(img,3,2)` byte-for-byte, through the edit-list.
2. **Applies to *any* image** — the same preset over two different images each equal that image's own recipe by hand (the property `edit_store` cannot claim of a single source).
3. **Distinct presets differ** — `vivid` and `mono` over one image produce different bytes.
4. **Deterministic** and **pure** — same preset + same image → same bytes; the source untouched.
5. **Open image** — a preset's result re-encodes and round-trips through the codec.
6. **Refusals named** — `UnknownPreset`, `PresetExists`, `TooManyPresets`, `BadPresetName`.

No new failure mode inside a recipe: a verb's own refusal folds through `photo_edits.apply` exactly as HUNK11 proved.

## Horizons (named, not half-built)

- **HUNK31** — the preset book travels as a `format filter-presets-v1` record (a nested grammar over `photo_edits`'s own line format), so a curated book is shareable text and `render(parse(render(x)))` is a fixed point.
- A preset book banked content-addressed (bead the book, reproduce a curated filter set from cold).
- The Skate preview of a preset (reusing HUNK13) — see a filter before committing it.
