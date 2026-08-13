# HUNK42 — the scrollable surface: page beside a live scroll bar

**Stamp:** `20260813.194607` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read (self-approved round) · **Season A** (Hardware & Right-to-Repair) · waymark **HUNK** · rung **HUNK42**
**Kin:** [`pond/apps/preset_scroll.rye`](../pond/apps/preset_scroll.rye) (HUNK40 cursor · HUNK41 scroll bar) · [`pond/apps/preset_shelf.rye`](../pond/apps/preset_shelf.rye) (HUNK37 pager) · [`brushstroke/skate_grid.rye`](../brushstroke/skate_grid.rye)

---

## Where the ladder stands

HUNK40 gave a keeper a **`ScrollCursor`** — a live viewport offset that walks a library taller than the screen and pins at both ends, so a gesture always lands on a real page. HUNK41 gave that cursor a **`ScrollBar`** — a pure thumb geometry (`track`, `thumb_start`, `thumb_len`) that reads *where in the library a keeper stands* and *how much of it fits*. Two honest facts about the reader, each measured, neither yet **seen together**.

## The crux this rung takes

Paint them on one glass grid. `scroll_view` renders the page the cursor currently shows — HUNK40's `window()` — into the left region of a Skate grid, and paints HUNK41's scroll bar down a reserved right-hand column, one bar cell per viewport row. The reward the two pieces could not claim apart: a keeper **sees** the books they are on *and* the thumb marking their place, in one composed surface, drawn from nothing but the cursor and the listing.

It is a **pure composition** — it invents no storage, no new gesture, and no new render primitive. It stays inside the single-symlink `pond/apps/` assembly (reusing `preset_scroll.window` and `preset_scroll.scroll_bar`), so it never touches the cross-assembly type-identity wall HUNK39 held for the maintainer's hand.

## The shape

`scroll_view(allocator, listing, cursor, cols, bar_w) !Grid`:

- `text_cols = cols - bar_w` — the books fill the left region; the bar owns the right `bar_w` columns. A `bar_w` of zero or one that leaves no text refuses **BadBar**; a zero `cols` refuses **EmptyView**.
- The bar's **track is exactly the viewport height** (`scroll_bar(cursor, cursor.rows)`), so the thumb maps one bar cell per visible row — the honest one-to-one between the groove and the page beside it.
- The thumb cells wear a bright block glyph and a thumb palette slot; the track cells a thin groove glyph and a dim slot — so the bar **rasterizes lit** and reads at a glance.
- The book-name chip color copied from the page, so the composed surface keeps the shelf's own look.

## What the witness proves

A real five-book library, a two-row viewport: at the top the thumb sits on the top bar cell and the left region shows books 0–1; scrolled to the bottom the thumb sits on the bottom bar cell and the region shows the last two books pinned true; the composed grid rasterizes to a lit canvas whose bar column adds pixels beyond the text; the view is pure and deterministic (built twice, byte-identical); a library that fits the screen fills the whole bar (nothing to scroll); a bar wider than the grid refuses **BadBar**, a zero grid **EmptyView**. No network, no key, no funds.

*May the reader always see both the page they are on and how far the road still runs beneath their thumb.*
