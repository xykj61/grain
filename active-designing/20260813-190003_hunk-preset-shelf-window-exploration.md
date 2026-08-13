# HUNK37 — a keeper pages through a library larger than one screen

**Stamp:** `20260813.190003` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** self-approved design round · **Season A** (Hardware & Right-to-Repair) · **waymark HUNK** · Photos-app journey · rung **HUNK37**
**Kin:** [`../pond/apps/preset_shelf.rye`](../pond/apps/preset_shelf.rye) (HUNK36) · [`../pond/apps/preset_detail.rye`](../pond/apps/preset_detail.rye) (HUNK35)

## Where the road stands

HUNK36 painted a keeper's installed library on glass — one row per book — and made an honest promise: rather than silently drop a book past the last row, `shelf_grid` refuses `ShelfTooSmall`. That promise is right, yet it leaves a real keeper stuck the moment their library outgrows the screen. A phone shows a handful of rows; a keeper may install more books than that. The honest refusal needs an honest answer: a **window** onto the library, a page the keeper can move through, so a large library is always fully reachable — never hidden, never truncated.

By Lindy-first, crux-first that window is the next crux: paging is the mechanism every list surface on a small screen needs, so the work compounds far past this one shelf, and it composes HUNK36's proven row render rather than inventing a new one.

## The keystone (HUNK37)

Additive on `pond/apps/preset_shelf.rye` (as `parse_listing` was additive on `session_list`), sharing HUNK36's row render through a small extracted `draw_row` helper so both the whole shelf and the window paint identically:

- `page_count(listing, rows)` — how many full pages a library of this size needs at this row height (a ceiling division bounded by the detailing's own count), so a keeper knows how far they can page.
- `shelf_window(allocator, listing, cols, rows, offset)` — render the books `[offset, offset + rows)` onto a fresh grid, a page starting at `offset`. Unlike `shelf_grid`, a window is *meant* to show a slice, so it never refuses `ShelfTooSmall`; instead it refuses `BadOffset` when `offset` lands past the library (an offset with no book to show), so every page a keeper can reach is a real one.
- `window_len(listing, rows, offset)` — how many books this particular page shows (a full `rows` mid-library, fewer on the last page), so a caller sizing a scrollbar reads the truth.

## The property this rung earns

Paging must lose nothing. Walk every page in order — offset `0`, `rows`, `2·rows`, … — and the books shown, concatenated, are exactly the whole library in held order, no book skipped and none shown twice. This *coverage* property is what makes a window an honest answer to HUNK36's refusal: a large library is not hidden, it is reachable one page at a time.

## The properties the witness proves

1. **Page arithmetic is honest** — a library of N books at R rows needs `ceil(N/R)` pages; `window_len` is `R` on full pages and the remainder on the last.
2. **A page shows its slice** — `shelf_window(offset)` renders exactly the books `[offset, offset+rows)` in held order.
3. **Paging loses nothing** — concatenating every page's books in page order reproduces the whole library, each book once.
4. **Refusals named** — an offset past the library refuses `BadOffset`; a zero dimension `EmptyShelf`; an over-ceiling dimension `ShelfTooLarge`.
5. **Still pure** — a window is deterministic and leaves the detailing untouched, exactly as the whole shelf is.

No network, no key, no funds — a window reads the detailing and paints a grid, storing nothing.

## Horizons (named, not half-built)

- A live scroll offset driven by a keeper's gesture (the input seam, above this pure pager).
- A sticky header row naming the current page (`page 2 of 5`) rendered into the grid.
- The served pager — a Comlink-served window over a remote library (stops at the Comlink-served custody gate).
