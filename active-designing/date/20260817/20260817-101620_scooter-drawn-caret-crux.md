# Scooter's Drawn Caret -- the cursor made a pixel block

**Stamp:** `20260817.101620` - **Status:** Vision -- Design read (self-approved round) - **Voice:** Kyri - **Style:** Radiant
**Kin:** [`../pond/apps/scooter_compose.rye`](../pond/apps/scooter_compose.rye) - [`../pond/apps/scooter_paint.rye`](../pond/apps/scooter_paint.rye) - [`../image/text_grid.rye`](../image/text_grid.rye) - Season G (Open Media Primitives)

## The gap this closes

Two proven parts of the terminal family have never met. `scooter_compose.Session`
already tracks `caret_col()` -- the column where a keeper's cursor sits in the
prompt row -- yet its fold to a frame carries only bytes; the caret is a number,
not a mark a keeper sees. And `image/text_grid.render_grid_cells` (with its pond
sibling `paint_frame_cells`) already paints each cell its own ink over its own
ground. The block cursor a keeper watches is exactly those two facts joined: at
the caret cell, swap the ink and the ground, and the cell reads inverse video --
a solid block over a space, a knocked-out glyph over a letter. Every terminal
ever drawn shows this cursor; it is Lindy-durable floor.

## The rung

`render_session(allocator, atlas, session, ink, ground)` in `scooter_paint.rye`:

1. Fold the session to a frame (`session.frame()`), the journal in the body and
   the prompt on the reserved last row -- the bytes already proven.
2. Compute the caret cell: `compose.prompt_row * frame_cols + session.caret_col()`.
3. Build two per-cell palettes, `ink`/`ground` everywhere, INVERTED at the caret
   cell (`fg[caret] = ground`, `bg[caret] = ink`).
4. Hand both to `paint_frame_cells` -- a pure pass-through of
   `text_grid.render_grid_cells`. The caret is one cell; nothing else braids.

## The crux, proven on metal

- **The cursor is a visible block.** With the caret at the end of a typed prompt
  (over a space), the caret cell's whole pixel block reads the INK color on the
  drawn face, where the plain face reads the GROUND color -- the cell flipped.
- **Confined to one cell (values apart, never braided).** Every pixel OUTSIDE the
  caret cell is byte-for-byte the plain face (`paint_frame` of the same frame);
  the cursor touches its own cell and nothing of the conversation.
- **The cursor moves.** Rendered with the caret walked home, the two faces differ,
  and the end-of-prompt cell reverts to the plain ground -- the old cursor cleared,
  a single mark that follows the keeper.
- **Portable and deterministic.** The drawn face round-trips through the open QOI
  codec byte-for-byte, and the same session renders the same image every time.
- **A mis-sized palette refuses by name** (`GridBgMismatch`), the painter's own
  guard, before any pixel is allocated.

Facts only, custody-first: it paints a line a member is editing in a channel they
already hold -- no network, no key, no funds. The live keystroke reader and the
Comlink wire between two Constel piers reach the serve gate, the maintainer's hand.
