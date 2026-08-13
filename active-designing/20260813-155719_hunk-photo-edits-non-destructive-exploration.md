# HUNK11 — the non-destructive edit-list: verbs as data, replayed and travelling

**Stamp:** `20260813.155719` · **Voice:** Kyri · **Style:** Radiant · **Status:** Living (self-approved design round)
**Season A · waymark HUNK · Photos-app journey · rung HUNK11**
**Kin:** [`../image/photos.rye`](../image/photos.rye) · [`../image/sprite_catalog.rye`](../image/sprite_catalog.rye) · [`../image/qoi.rye`](../image/qoi.rye) · [`double-seat expansion`](20260813-020035_double-seat-expansion-six-seasons.md)
**Teacher, thanked clean-room:** the non-destructive edit history of iCloud Photos / Google Photos — the original is never overwritten; the edits ride alongside as data (concept only, siloed).

---

## The crux, named

The Photos app now holds six pure verbs — crop, flip_h, flip_v, rotate_quarter, scale, adjust (HUNK3 · HUNK8 · HUNK9 · HUNK10). Each returns a fresh open image and leaves its source untouched. That purity is exactly what a *non-destructive* editor is built on: a photo library keeps the original bytes forever and records the edits **as data beside them**, so an edit is undoable, replayable, and shareable without ever mutating the source.

HUNK11 is that keystone: an **edit-list** — a bounded, ordered sequence of edit verbs recorded as a value — and one function, `apply`, that **replays** the whole list over a source image to produce a fresh edited image, the source never touched. The list itself **travels as text** (a flat-Bron `format photo-edits-v1` record, one verb per line), so `render(parse(render(x)))` is a fixed point exactly as the sprite catalog's does (HUNK7). This composes every verb the journey built and ties the Photos app to the tree's travel-as-text spine.

## Why this is the Lindy-first crux

- **It composes the whole journey.** One value model over all six verbs; every future verb joins by adding one variant, not one new store.
- **Determinism is the content-address guarantee.** Replaying the same edit-list over the same source yields the same bytes **always** — so an edited image never needs its pixels stored; the pair (source address, edit-list text) reproduces it. That is the dedup dividend HUNK1/HUNK6 proved for images, now for edits. Beading an edit-list into Tablecloth is a clean later rung (HUNK12) that stands on this one.
- **Non-destructive is the real product.** iCloud/Google Photos keep the original and let a keeper revert; recording edits as replayable data is that promise, on the open module, no proprietary blob.

## The value model (one variant per verb)

```
Edit = tagged union:
  crop   { x, y, w, h : u32 }
  flip_h {}
  flip_v {}
  rotate { turns : u32 }
  scale  { w, h : u32 }
  adjust { brightness : i32, contrast_num, contrast_den : u32 }

EditList = bounded array of Edit, len <= max_edits (named ceiling)
```

`apply(source, list)` folds the list left to right, threading each verb's fresh
image into the next, and returns the final image. A refusal from any verb
(an out-of-bounds crop, a bad contrast) surfaces by that verb's own named error
through the fold — the edit-list adds no new failure mode, it only sequences the
ones already proven.

## Travel as text — `format photo-edits-v1`

One line per verb, tag then fields, mirroring the sprite catalog exactly:

```
format photo-edits-v1
crop 2 1 3 2
rotate 1
adjust 40 1 1
```

`render_edits` writes the list; `parse_edits` reads it back into a fresh list.
`render(parse(render(x)))` is a fixed point; an unknown header, an unknown verb
tag, a malformed field, or an extra field each refuse `BadEdits`. Bounded by a
named per-line and whole-record ceiling (TAME bound at construction).

## The four rounds of this quest

- **HUNK11 (this round):** `image/photo_edits.rye` — the `Edit` value model, `apply` replay, `render_edits`/`parse_edits` travel, witnessed on metal.
- **HUNK12 (named horizon):** bead an edit-list into Tablecloth content-addressed, so `(image address, edit-list address)` reproduces the edited image from cold — the dedup dividend for edits.
- **HUNK13 (named horizon):** the Skate view of a non-destructive edit (down-map the replayed result), so an edit is *seen* before it is committed.
- **HUNK14 (named horizon):** revert / truncate — drop the last k edits, proving the original is always one empty-list `apply` away.

## What this round proves on metal

1. **Replay composes:** an edit-list of `[crop, rotate, adjust]` applied to a tagged image equals the same three verbs called by hand, byte-for-byte.
2. **Deterministic (the content-address guarantee):** applying the same list to the same source twice yields identical bytes.
3. **Non-destructive:** the source image is untouched after `apply`; the empty edit-list recovers the source byte-for-byte.
4. **Still open:** an edited image re-encodes and round-trips through the codec byte-for-byte.
5. **Travels as text:** `render(parse(render(list)))` is a fixed point; the rebuilt list applies to the same bytes.
6. **Refusals named:** a bad header, an unknown verb, a malformed field, an extra field each refuse `BadEdits`; a verb's own refusal (an out-of-bounds crop in a list) surfaces by its name through the fold.

No network, no key, no funds. Buying or provisioning hardware stays custody gates #2/#3 — untouched here.

*May a keeper's first photo stay whole forever, every edit a word beside it rather than a wound in it.*
