# Counsel stack — seasons roster

**Language:** EN  
**Status:** Living pin — one line per closed season  
**Bound:** under `living_pin_max_bytes`  
**Seated:** `20260725.040520`  
**Law:** [`../context/specs/append-only-growth-law.md`](../context/specs/append-only-growth-law.md)

| Season | Range | Count | Index |
|--------|-------|------:|-------|
| `20260704` | closed | 3 | [`date/README-index-20260704.md`](date/README-index-20260704.md) |
| `20260706` | closed | 1 | [`date/README-index-20260706.md`](date/README-index-20260706.md) |
| `20260707` | closed | 24 | [`date/README-index-20260707.md`](date/README-index-20260707.md) |
| `20260708` | closed | 1 | [`date/README-index-20260708.md`](date/README-index-20260708.md) |
| `20260711` | closed | 6 | [`date/README-index-20260711.md`](date/README-index-20260711.md) |
| `20260712` | closed | 3 | [`date/README-index-20260712.md`](date/README-index-20260712.md) |
| `20260724` | closed | 14 | [`date/README-index-20260724.md`](date/README-index-20260724.md) |
| `20260725` | closed | 46 | [`date/README-index-20260725.md`](date/README-index-20260725.md) |
| `20260726` | closed | 13 | [`date/README-index-20260726.md`](date/README-index-20260726.md) |
| `20260731` | closed | 1 | [`date/README-index-20260731.md`](date/README-index-20260731.md) |

**112 rows across ten shelves**, folded from the living pin on `20260824.152800`, which fell from
22,671 bytes to 3,097 in the same pass. The room itself closed on `20260821.174047` and its files
folded to `date/YYYYMMDD/` on `20260821.171105`, so nothing here will grow again: each shelf is
immutable once written, and the pin holds the way in rather than the rows.
