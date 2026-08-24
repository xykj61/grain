# Waymarks claim shelf — seasons roster

**Language:** EN  
**Status:** Living pin — one line per closed season  
**Bound:** under `living_pin_max_bytes`  
**Seated:** `20260725.040520`  
**Law:** [`../context/specs/append-only-growth-law.md`](../context/specs/append-only-growth-law.md)

| Season | Range | Count | Index |
|--------|-------|------:|-------|
| living (current) | open | 0 | [`README.md`](README.md) living pin |
| `20260724` | 20260724 | 7 | [`date/README-index-20260724.md`](date/README-index-20260724.md) |
| `20260725` | 20260725 | 34 | [`date/README-index-20260725.md`](date/README-index-20260725.md) |

**Folded `20260824.172000`.** Every day this index carried had already folded into the room, so all
**41** rows moved onto **2** dated shelves in one pass and the living pin came down to well under
its bound. A shelf is immutable once written; the living pin holds only the rows whose claims are
still flat, and none are today.

A claim this index never carried is still found the way any dated file is:
`rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference>` computes its home from the stamp
in its own name.
