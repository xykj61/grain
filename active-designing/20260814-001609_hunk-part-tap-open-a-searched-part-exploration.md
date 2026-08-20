# HUNK80 — tap a searched part to open its detail: the marketplace loop closes

**Stamp:** `20260814.001609` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable, no gate)
**Season:** A (Hardware & Right-to-Repair) · **waymark:** HUNK · **journey:** parts-marketplace · **rung:** HUNK80
**Kin:** [`../brushstroke/part_and_search.rye`](../brushstroke/part_and_search.rye) (HUNK79 faceted shelf on glass) · [`../brushstroke/part_row.rye`](../brushstroke/part_row.rye) (HUNK73 shelf · HUNK74 paging) · [`../brushstroke/library_tap.rye`](../brushstroke/library_tap.rye) (HUNK70 the same gesture for Photos)

---

## Why this rung

HUNK71–79 built the parts marketplace whole on the reading side: a content-addressed catalog, a painted row, a paged shelf, and a faceted search box that draws exactly the parts a keeper types. Yet the shelf is still a picture — a keeper reads it, but cannot yet **reach into it**. The Photos journey met this same seam at HUNK70 and closed it with `library_tap`: a finger on a wall tile opens that picture. This rung carries that gesture to the marketplace — a tap on a narrowed shelf resolves to the exact part the keeper sees, and returns its detail.

## The crux

The durable property is that **a tap lands on the part it points at, even across the narrowing**. The shelf HUNK79 drew is not the catalog — it is the *narrowed* catalog, so the row a finger touches is at one position on glass and its part at another position in the original catalog. The naïve read (row `k` means catalog part `k`) is a lie the moment a search hides a part above the tap. `part_tap` reads the shelf's own geometry backward, resolves the tap to the narrowed part the keeper sees, then maps that part **back to its home in the original catalog** by its stable name — so `open_tapped_and(cat, "material:stainless-304", …, row 1)` opens the *fourth* part of the catalog when that is the second stainless one on the page, never the catalog's literal second part. The tap invents nothing; a tap past the last result on the page resolves to nothing, and a malformed search line surfaces the parser's own named refusal rather than opening a wrong part.

## Shape

`brushstroke/part_tap.rye`, pure resolution over the surfaces already proven — no new storage, no new codec, no funds:

- `tap_cell_row(px_y) -> u32` — map a pixel tap to a shelf cell row through Skate's own `cell_h`, the same pitch `part_row` paints at, so a finger reaches the row it sees.
- `tap_row(rows, page_len, cell_row) -> ?u32` — pure geometry: resolve a cell row to a within-page part index, or nothing when the tap falls on an empty tail row past the last part drawn. One part per row (HUNK73), so the row *is* the within-page index, valid only below `page_len`.
- `tap_part(cat, rows, offset, cell_row) -> ?PartRef` — over a plain catalog page: resolve the tap and return the part at `offset + within` — its stable name, its honest facts, and its index in the catalog. Nothing on a miss.
- `open_tapped_and(cat, text, rows, offset, cell_row) -> !?PartRef` — the search version and the crux: parse the multi-clause line, narrow with `filter_and`, resolve the tap over the *narrowed* page, then map the tapped part back to its home in the **original** catalog by name — so the returned `PartRef` borrows the caller's long-lived catalog, never the local sub-catalog whose sheet is shared but whose storage is a stack frame. A malformed clause surfaces the parser's named refusal; a tap past the narrowed results returns nothing.

`PartRef` carries `{ index, name, facts }` — the handle a detail page needs, every slice pointing into the caller's own catalog so it outlives the resolution.

## Boundaries

The tap holds no state and no funds — it reads a catalog, a line, and a coordinate, and returns a handle. It moves nothing (custody gate #3 untouched), opens no network, holds no key. The narrowing windows into the caller's shared sheet, borrowed and never copied; the returned `PartRef` reads only the original catalog, so it never dangles on the local sub-catalog. A `brushstroke/part_row.rye` is already resident; the new module reuses `part_row.part_window_len` for the page geometry so the tap and the paint page by one law.

*May a keeper narrow the wall to the few parts that serve, reach out a finger, and land squarely on the one they meant — the marketplace loop closed, search to touch to the part itself.*
