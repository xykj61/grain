# Expanding prompts — seasons roster

**Language:** EN  
**Status:** Living pin — one line per closed season  
**Bound:** under `living_pin_max_bytes`  
**Seated:** `20260725.040520`  
**Law:** [`../context/specs/append-only-growth-law.md`](../context/specs/append-only-growth-law.md)

| Season | Range | Count | Index |
|--------|-------|------:|-------|
| living (current) | open | 2 | [`README.md`](README.md) living pin |
| `20260618` | 20260618 | 3 | [`date/README-index-20260618.md`](date/README-index-20260618.md) |
| `20260619` | 20260619 | 7 | [`date/README-index-20260619.md`](date/README-index-20260619.md) |
| `20260620` | 20260620 | 11 | [`date/README-index-20260620.md`](date/README-index-20260620.md) |
| `20260621` | 20260621 | 4 | [`date/README-index-20260621.md`](date/README-index-20260621.md) |
| `20260628` | 20260628 | 1 | [`date/README-index-20260628.md`](date/README-index-20260628.md) |
| `20260701` | 20260701 | 2 | [`date/README-index-20260701.md`](date/README-index-20260701.md) |
| `20260702` | 20260702 | 2 | [`date/README-index-20260702.md`](date/README-index-20260702.md) |
| `20260703` | 20260703 | 1 | [`date/README-index-20260703.md`](date/README-index-20260703.md) |
| `20260704` | 20260704 | 3 | [`date/README-index-20260704.md`](date/README-index-20260704.md) |
| `20260705` | 20260705 | 10 | [`date/README-index-20260705.md`](date/README-index-20260705.md) |
| `20260706` | 20260706 | 2 | [`date/README-index-20260706.md`](date/README-index-20260706.md) |
| `20260709` | 20260709 | 11 | [`date/README-index-20260709.md`](date/README-index-20260709.md) |
| `20260710` | 20260710 | 4 | [`date/README-index-20260710.md`](date/README-index-20260710.md) |
| `20260711` | 20260711 | 1 | [`date/README-index-20260711.md`](date/README-index-20260711.md) |
| `20260715` | 20260715 | 4 | [`date/README-index-20260715.md`](date/README-index-20260715.md) |
| `20260716` | 20260716 | 1 | [`date/README-index-20260716.md`](date/README-index-20260716.md) |
| `20260718` | 20260718 | 1 | [`date/README-index-20260718.md`](date/README-index-20260718.md) |
| `20260724` | 20260724 | 2 | [`date/README-index-20260724.md`](date/README-index-20260724.md) |
| `20260725` | 20260725 | 1 | [`date/README-index-20260725.md`](date/README-index-20260725.md) |
| `20260727` | 20260727 | 2 | [`date/README-index-20260727.md`](date/README-index-20260727.md) |
| `20260728` | 20260728 | 5 | [`date/README-index-20260728.md`](date/README-index-20260728.md) |

**Folded `20260824.171500`.** The pin stood at **24,603 bytes** against the **24,576** its own
header declares, and every day it carried had already folded into the room, so all **78** rows
moved onto **21** dated shelves in one pass and the pin came down to well under its bound. A shelf
is immutable once written; the living pin holds only the rows whose prompts are still flat.

A prompt this index never carried is still found the way any dated file is:
`rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference>` computes its home from the stamp
in its own name.
