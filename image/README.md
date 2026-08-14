# The Open Image module — a picture you own, all the way down

**Stamp:** `20260814.000000` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living front door — the Open Image journey stands whole and witnessed (HUNK0–HUNK70)
**Season:** A — Hardware & Right-to-Repair · **Waymark:** HUNK · opening journey **Open Image**
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/20260813-020035_double-seat-expansion-six-seasons.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)
**Teacher, thanked clean-room:** [`../gratitude/qoi.md`](../gratitude/qoi.md) — the "Quite OK Image" format, public one-page spec only, never the reference C.

---

## What this is

A picture in Grain is **verified bytes that decode, deterministically and within named bounds, to a pixel grid** — and everything a keeper does with that picture is a pure, bounded function over the grid, the source never mutated. No network is asked to read a pixel; no key, no funds, no permission. An image is yours the way a page in a notebook is yours: held in your own hand, decoded by code small enough to read whole, addressed by its own content so a tampered byte refuses **by name** rather than painting garbage.

This module is the floor beneath Season A's **parts marketplace** and its **Photos app**. It answers the plainest question a device family can ask — *can the person who holds it also hold every picture on it?* — with yes, proven on metal.

## The three arcs, each closed whole

### Open Image — the codec and its guarantees (HUNK0–HUNK3)

- **`qoi.rye`** — a whole open **QOI** codec, encode and decode, so `decode(encode(pm))` recovers a pixmap **byte-for-byte** across all six chunk kinds (rgb · rgba · index · diff · luma · run). Real compression, and five corruptions each refusing by name rather than reading past the end. Witness: `tools/hunk_qoi_witness.rish`.
- **`../pond/apps/image_artifact.rye`** — an image becomes a content-addressed **Tablecloth** artifact. `store_image` beads a picture under a name that pins a SHA3 content address; `fetch_image` reassembles it, proving **every bead against its digest first**, so a tampered bead refuses `DigestMismatch` and an unknown name refuses `UnknownArtifact` — each *before the codec reads a single pixel*. Same image under two names stores once (the dedup dividend). Witness: `tools/hunk_artifact_witness.rish`.
- **`../brushstroke/image_skate.rye`** — the decoded grid meets **Skate**: `down_map` averages each block to the nearest of a seven-color anchor palette and wears it over a full-block glyph, so a picture paints on the glass surface. Witness: `tools/hunk_skate_witness.rish`.
- **`photos.rye` — `crop`** — the first Photos verb, pure and bounded: read a rectangle, return a fresh smaller image, source untouched; coordinates checked in `u64` so a rectangle can never wrap. Witness: `tools/hunk_photos_witness.rish`.

### The parts marketplace — McMaster-Carr's one-sheet trick, with honest facts (HUNK4–HUNK7 · HUNK71)

One decoded sheet serves a whole catalog. `sprite.rye` binds each product name to a bounded **window** into a single decoded image and renders it by reusing `photos.crop` — every window bound-checked in `u64` at **add time**, so a render can never fail on bounds. `../pond/apps/sprite_store.rye` gives the sheet a content-addressed identity; `sprite_catalog.rye` lets the index itself travel as a flat-Bron `format sprite-catalog-v1` record, so `render(parse(render(x)))` is a fixed point. Disjoint windows never leak a neighbor's bytes; the sheet is shared and unmutated across every render.

A part is a picture *with its facts*. `part_catalog.rye` binds each product's window to a **part number**, a **material**, and a **price in cents** — recorded as a `u64` fact, never a balance the tree can move — so a `PartCatalog` holds one `SpriteIndex` (the pictures) and one record per product (the facts) in the same order, grown together so a part is never a window without facts. The whole catalog travels as `format part-catalog-v1`, a fixed point over *both* halves. `../pond/apps/part_store.rye` gives the catalog a content address: `store_catalog` beads its text, `open_catalog` fetches it back **verified before the parser reads a window or a price**, so a whole marketplace — pictures and prices — reproduces from cold out of *(sheet, catalog address)*, a tampered catalog refusing `DigestMismatch`. Witnesses: `tools/hunk_sprite_*_witness.rish`, `tools/hunk_part_catalog_witness.rish`, `tools/hunk_part_store_witness.rish`.

A keeper searches the catalog by its facts, and the **boolean query algebra stands whole** (HUNK75–HUNK85). `part_filter.rye` reads a single `key:value` clause over the stored facts; `part_query.rye` parses it; `part_and.rye` narrows a line of clauses to the **intersection** (a match-all empty line), `part_or.rye` widens it to the **union** (a match-none empty line) — the two true De Morgan duals, OR always a superset of AND. `part_facets.rye` joins them into the canonical faceted query — **OR within a facet** (values joined by `|`), **AND across facets** (groups by space), so `material:stainless-304|material:brass max:100` means *(stainless or brass) and under a dollar*; a `|`-free line is exactly HUNK78's conjunction, a strict superset that disturbs nothing. On glass, `../brushstroke/part_and_search.rye`, `../brushstroke/part_or_search.rye`, and `../brushstroke/part_facets_search.rye` draw exactly the narrowed, widened, or faceted page — *what a keeper types is what a keeper sees* — a price clause **comparing** a recorded cent count, never moving one (custody gate #3 untouched). Above the shelf, `../brushstroke/part_search_header.rye` (the pure AND) and `../brushstroke/part_facets_header.rye` (the whole faceted grammar) **echo the canonical query and its *N results* count**, stacked into one screen a keeper reads top to bottom — the echo a **fixed point of the parser**, so the header shows the query the machine understood, never a hopeful transcript, and its count is exactly the number of parts drawn beneath it (no drift). `../brushstroke/part_facets_paged.rye` carries the page into that header — ***page N of M*** above the very page of parts it names, a zero-result line carrying no page at all. `../brushstroke/part_facets_sort.rye` sorts the result **cheapest-first** — `sort_by_price` reorders the parts a query kept by their recorded cent count, ascending, ties keeping held order (a **stable** sort, a **permutation** of the result — same parts, only reordered), and `facets_sorted_shelf` draws that page least dear at the top, a price still **compared and reordered by, never moved** (custody gate #3 untouched). `../brushstroke/part_facets_sorted_screen.rye` closes the arc — `format_sorted_header` appends **`sorted by price`** to the paged header (only when a result exists) and `facets_sorted_screen` stacks it over the sorted shelf, so a keeper reads *what I asked · how many · which page · that it is sorted by price* above the cheapest-first parts, the word naming the order it sits over (no drift). `../brushstroke/part_facets_sort_desc.rye` turns the sort **both ways** — `sort_by_price_desc` reads the same result **dearest-first**, ties still kept in **held order** (so descending is not a naive reversal; on distinct prices it is the exact reverse of ascending), and `facets_sorted_desc_shelf` draws that page high to low, answering *what is the best they have* beside *what can I afford*. `../brushstroke/part_facets_sort_dir.rye` names the direction over the page — a `SortDir` drives both the header tail (**`sorted by price low to high`** or **`high to low`**) and the shelf it sits over, so `facets_sorted_screen_dir` can never let the label disagree with the order (the `high to low` header sits over the dearest part first, `low to high` over the cheapest), and the two directions read as exact reverses on a distinct result. `../brushstroke/part_facets_sort_query.rye` hands the direction to the keeper — a **`sort:price-asc`** or **`sort:price-desc`** directive anywhere in the typed line is lifted out (default ascending when absent, `UnknownSortValue` on a bad value, `DuplicateSort` on a second), and the stripped rest rejoins as the faceted query byte-for-byte, so `facets_sorted_query_screen` draws the keeper's chosen direction from one honest line — a strict superset of HUNK92 (a line with no directive behaves exactly as ascending). Witnesses: `tools/hunk_part_filter_witness.rish`, `tools/hunk_part_and_witness.rish`, `tools/hunk_part_or_witness.rish`, `tools/hunk_part_facets_witness.rish`, `tools/hunk_part_and_search_witness.rish`, `tools/hunk_part_or_search_witness.rish`, `tools/hunk_part_facets_search_witness.rish`, `tools/hunk_part_search_header_witness.rish`, `tools/hunk_part_facets_header_witness.rish`, `tools/hunk_part_facets_paged_witness.rish`, `tools/hunk_part_facets_sort_witness.rish`, `tools/hunk_part_facets_sorted_screen_witness.rish`, `tools/hunk_part_facets_sort_desc_witness.rish`, `tools/hunk_part_facets_sort_dir_witness.rish`, `tools/hunk_part_facets_sort_query_witness.rish`.

### The Photos app — edit without ever losing the original (HUNK8–HUNK70)

Named plainly **Photos**, built entirely on the module above. Every gesture is a pure verb over the grid, added **additively** beside `crop`:

- **Orient** — `flip_h`, `flip_v`, `rotate_quarter`, proven by the algebra they obey (four quarter-turns are identity; a mirror is its own inverse).
- **Resample** — `scale` (nearest-neighbor), an area-average path, and a bilinear path, each refusing a zero-dimension or over-ceiling target before it allocates.
- **Light and color** — `adjust` (brightness · contrast around the 128 midpoint, alpha untouched), `saturate`, hue rotation, and a book of named **filter presets** that travels as a `format filter-presets-v1` record.
- **Non-destructive editing** — `photo_edits.rye` records the verbs **as data** (an `Edit` union, a bounded `EditList`, `max_edits = 64`) and `apply` **replays** them over a source to a fresh image; replay is deterministic, so an edited picture never needs its pixels stored — only the pair *(source, edit-list)*. The list travels as a `format photo-edits-v1` record; `../pond/apps/edit_store.rye` beads it content-addressed; `photo_revert.rye` reverts by simply dropping edits off the end, never losing what a keeper might redo.
- **The glass surface** — `../brushstroke/` carries the whole app onto Skate: a crop tool (drag → frame → commit → chain), a filter strip and picker (read the book at a glance, swipe to preview, keep one), a filmstrip of the edit history (jump, scrub, track), a scrolled screen view, and the **Photos library** — a wall of content-addressed tiles where a tap resolves backward through the wall's geometry to fetch and open exactly the picture under the finger. The loop closes end to end: **library → tap → open → edit → save → library**, the wall growing by one when an opened picture is saved back.

## The invariants this module keeps

- **Prove before you paint.** A content-addressed picture is verified against its digest *before* the codec touches a pixel — a tampered or unknown artifact refuses by name.
- **Pure over the grid.** Every Photos verb returns a fresh image and leaves the source unmutated; an edit is data replayed, never a destroyed original.
- **Bounded everywhere.** Coordinates and samples run in `u64` so no rectangle or resample can wrap; every list names a maximum; every failure has a name.
- **No network to read a picture.** No key, no funds, no permission asked — custody-first, all the way down.

## Horizons — named, not yet built

These wait for their own rounds (some for a web-search research pass, per the Season-A capture):

- **Real part values** — HUNK71 built the catalog *structure* (window + part number + material + price-as-fact); filling it from real refurbished-parts sources through MCP-API-friendly marketplaces is a **web-search research round**, and **buying real parts is a custody gate.**
- A **colour e-ink** render target for the Grainphone hybrid — research round.
- Richer resamplers and a wider filter grammar as the Photos app grows.

## Gratitude

**QOI** (Dominic Szablewski, MIT reference, public one-page spec) is the teacher for the codec — studied clean-room, never the C. The **Photos app** honors the gestures a keeper already knows from iCloud Photos and Google Photos, siloed and thanked; **McMaster-Carr** is thanked for the single-sheet render trick. We study concepts; we write our own code.

---

*May every picture stay the keeper's own — decoded in the open, addressed by its own bytes, edited without ever losing the first frame. May the wall grow one honest tile at a time, and may no picture here ever need to phone home to be seen.*
</content>
</invoke>
