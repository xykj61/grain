# HUNK13 — the Skate view of a pending edit, seen before it is committed

**Stamp:** `20260813.160955` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living (design read) · self-approved design round for the next HUNK rung
**Season A** (Hardware & Right-to-Repair) · **waymark HUNK** · Photos-app journey · rung **HUNK13**
**Kin:** [`../image/photo_edits.rye`](../image/photo_edits.rye) (HUNK11) · [`../pond/apps/edit_store.rye`](../pond/apps/edit_store.rye) (HUNK12) · [`../brushstroke/image_skate.rye`](../brushstroke/image_skate.rye) (HUNK2) · [`20260813-155719_hunk-photo-edits-non-destructive-exploration.md`](20260813-155719_hunk-photo-edits-non-destructive-exploration.md) (names HUNK13)

---

## The crux this round takes

HUNK11 recorded the Photos verbs as data and proved replay is deterministic and
non-destructive. HUNK12 banked that determinism as a content address — an edited
image reproduces from cold out of the pair `(source, edit-list address)`, its
pixels never stored. Both rungs work in bytes; neither lets a keeper *look*.

HUNK13 is the eye. Before a keeper commits an edit-list — before HUNK12 beads it,
before anything is stored under a name — the keeper wants to **see** what the edit
would produce. This rung composes the two seams already proven: `photo_edits.apply`
replays the list over the source (pure, non-destructive, nothing written), and
`image_skate.down_map` turns the replayed result into a Skate grid that lights the
canvas. The whole gesture is a preview: a pending edit is *seen*, not committed.

## The shape

A new module, `brushstroke/edit_preview.rye`, adds one keystone:

```
pub fn preview(allocator, source: *const qoi.Pixmap,
               list: *const photo_edits.EditList,
               cols: u32, rows: u32) !skate.Grid
```

It replays `list` over `source` with `photo_edits.apply` (which folds from a clone,
so the source is untouched), then hands the fresh edited image to
`image_skate.down_map` for the cols×rows Skate grid. It takes **no name**, writes
**no bead**, touches **no funds** — a preview is a look, not a commit. It adds no
new failure mode: a verb's own refusal (an out-of-bounds crop) surfaces by its
name through `apply`'s fold, and an empty image or an over-ceiling grid refuses
from `down_map`, each before a grid is returned.

## The home, and why brushstroke/

The Skate view is a Brushstroke concern, and `image_skate.rye` already lives in
`brushstroke/`. `edit_preview.rye` sits beside it, importing `image_skate.rye`
(real) and `qoi.rye` (symlink) directly, and `photo_edits.rye` through a new
`brushstroke/photo_edits.rye` symlink — its own deps (`photos` · `qoi` ·
`parse_int` · `tally_copy`) already resolve in `brushstroke/`, exactly as the
`pond/apps/` symlink pattern already resolves them there.

## What this round proves on metal

1. **The preview faithfully shows the replayed result:** `preview(source, list)`
   equals `down_map(apply(source, list))` — same cells, same fg indices,
   byte-for-byte.
2. **Non-destructive:** the source is untouched after `preview`, and the **empty**
   edit-list previews to exactly the source's own `down_map` — a look changes
   nothing.
3. **A pending edit changes the view:** an edit that visibly alters the image
   (a `flip_h` swapping a two-tone's halves) yields a preview whose cells differ
   from the source's — the keeper sees the edit *before* committing it.
4. **Deterministic:** the same `(source, list, cols, rows)` previews to the same
   grid twice — the content-address guarantee carried up to the view.
5. **Genuinely seen:** the preview grid rasterizes to a lit canvas, the swapped
   colors landing in the swapped cells.
6. **Refusals named:** an out-of-bounds crop in the list surfaces `OutOfBounds`
   through the fold; an empty grid dimension refuses `EmptyImage`; an over-ceiling
   grid refuses `GridTooLarge` — no new error, only the proven ones sequenced.

## The four rounds of this quest (HUNK11 opened it)

- **HUNK11 (landed):** the `Edit` value model, `apply` replay, travel as text.
- **HUNK12 (landed):** bead an edit-list content-addressed; reproduce from cold.
- **HUNK13 (this round):** the Skate view of a pending edit — seen before committed.
- **HUNK14 (named horizon):** revert / truncate — drop the last k edits, the
  original always one empty-list `apply` away.

No network, no key, no funds. Buying or provisioning hardware stays custody
gates #2/#3 — untouched here.

*May a keeper always see the edit before they keep it, and keep the first photo whole beneath every look.*
</content>
</invoke>
