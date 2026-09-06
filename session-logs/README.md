# Session logs

**Language:** EN
**Style:** Gauge, Meter setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living pin -- the way in: one row per day shelf, newest first
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Bound:** under `living_pin_max_bytes[session-logs/README.md]` (57344)
**Chapters roster:** [`CHAPTERS.md`](CHAPTERS.md)

Every session in this tree leaves a log, and this page is the way in. It reads **newest first**,
and one row is one **day**: which shelf holds it, how many laps rest there, and where to open it.

**This page carries its own byte bound** -- `living_pin_max_bytes[session-logs/README.md]` = **57,344**,
seated when the pin held a row per lap. Since `20260827.171500` it holds a row per **day**, so the
bound is loose by design and the page is small: one row per shelf, a few hundred bytes a year.

**A row points; it does not summarise.** The log is the record and the index is the way in, so a
shelf row stays **at or under 192 bytes** -- a stamp, a linked title, and one clause. The number is
arithmetic rather than taste: a row costs about 123 bytes before it says anything, and 192 leaves a
clause of roughly 69 characters. Rows once ran to 2,223 bytes apiece, which made the index a second
copy of the logs (REDS %204). Held by
[`../tools/in/index_row_bound_witness.rish`](../tools/in/index_row_bound_witness.rish); shelved rows
keep every byte they wrote.

**A log is born on its day's shelf.** From `20260827.171500` a session log is written straight to
`date/YYYYMMDD/` and its row is prepended to `date/README-index-YYYYMMDD.md` in the same breath, so
this room holds no flat logs and this pin holds no laps. Nothing folds afterward, because nothing
arrives loose -- and the page a reader opens first can no longer grow with the room. It stood at
2,895,849 bytes when rows outlived their logs here (REDS %182).

**A day's own order is this table, rather than filename sort.** One-clock stamps sort ascending on
disk; within a day, trust the rows. Naming law:
[`../context/specs/20260627-102012_one-clock-naming-law.md`](../context/specs/20260627-102012_one-clock-naming-law.md).

**The living notation is Kyri** (`.kyri`) -- immutable key-value at the seam, sibling to the elder
`.bron`, with historical Markdown logs folded under `date/YYYYMMDD/` beside them. Rules:
[`../.claude/rules/session-logs.md`](../.claude/rules/session-logs.md) -
[`../.cursor/rules/session-logs.mdc`](../.cursor/rules/session-logs.mdc). Growth law:
[`../context/specs/append-only-growth-law.md`](../context/specs/append-only-growth-law.md).

*Erratum `20260724.203617` -- UTC window:* four logs were stamped from `Etc/UTC` and read in index
order rather than by stamp; they rest on the `20260724` and `20260725` shelves. The host zone is
`America/New_York`, and from `20260724.205009` the one-clock witness is **blocking**.

## The shelves, newest first

A log is **born on its day's shelf** from `20260827.171500`: it is written to
`session-logs/date/YYYYMMDD/` and its row is prepended to `date/README-index-YYYYMMDD.md` in the
same breath. So this pin holds no rows of its own -- it holds the way in, and it cannot grow with
the room. The newest day's shelf is the one to open; it stays open while its day runs and freezes
when the day closes.

**Only a closed day carries a count.** The live day reads `open` in both columns, the way
`CHAPTERS.md` has always written it: an open shelf gains a row every lap, so a number typed
there is wrong before the ink dries, and the hand that must remember to bump it is the fault
REDS %385 booked. A day's number is derived by counting its shelf on the lap that closes it.

| Day | Rows | Shelf |
|---|---|---|
| `20260906` **open** | **open** | [`date/README-index-20260906.md`](date/README-index-20260906.md) |
| `20260905` | 59 | [`date/README-index-20260905.md`](date/README-index-20260905.md) |
| `20260904` | 45 | [`date/README-index-20260904.md`](date/README-index-20260904.md) |
| `20260903` | 65 | [`date/README-index-20260903.md`](date/README-index-20260903.md) |
| `20260831` | 26 | [`date/README-index-20260831.md`](date/README-index-20260831.md) |
| `20260830` | 73 | [`date/README-index-20260830.md`](date/README-index-20260830.md) |
| `20260829` | 86 | [`date/README-index-20260829.md`](date/README-index-20260829.md) |
| `20260828` | 67 | [`date/README-index-20260828.md`](date/README-index-20260828.md) |
| `20260827` | 45 | [`date/README-index-20260827.md`](date/README-index-20260827.md) |
| `20260826` | 44 | [`date/README-index-20260826.md`](date/README-index-20260826.md) |
| `20260825` | 37 | [`date/README-index-20260825.md`](date/README-index-20260825.md) |
| `20260824` | 58 | [`date/README-index-20260824.md`](date/README-index-20260824.md) |
| `20260823` | 28 | [`date/README-index-20260823.md`](date/README-index-20260823.md) |
| `20260822` | 61 | [`date/README-index-20260822.md`](date/README-index-20260822.md) |
| `20260821` | 80 | [`date/README-index-20260821.md`](date/README-index-20260821.md) |
| `20260820` | 64 | [`date/README-index-20260820.md`](date/README-index-20260820.md) |
| `20260819` | 106 | [`date/README-index-20260819.md`](date/README-index-20260819.md) |
| `20260818` | 68 | [`date/README-index-20260818.md`](date/README-index-20260818.md) |
| `20260817` | 149 | [`date/README-index-20260817.md`](date/README-index-20260817.md) |
| `20260816` | 107 | [`date/README-index-20260816.md`](date/README-index-20260816.md) |
| `20260815` | 183 | [`date/README-index-20260815.md`](date/README-index-20260815.md) |
| `20260814` | 120 | [`date/README-index-20260814.md`](date/README-index-20260814.md) |
| `20260813` | 187 | [`date/README-index-20260813.md`](date/README-index-20260813.md) |
| `20260812` | 117 | [`date/README-index-20260812.md`](date/README-index-20260812.md) |
| `20260811` | 64 | [`date/README-index-20260811.md`](date/README-index-20260811.md) |
| `20260810` | 80 | [`date/README-index-20260810.md`](date/README-index-20260810.md) |
| `20260809` | 28 | [`date/README-index-20260809.md`](date/README-index-20260809.md) |
| `20260808` | 54 | [`date/README-index-20260808.md`](date/README-index-20260808.md) |
| `20260807` | 1 | [`date/README-index-20260807.md`](date/README-index-20260807.md) |
| `20260805` | 1 | [`date/README-index-20260805.md`](date/README-index-20260805.md) |
| `20260804` | 21 | [`date/README-index-20260804.md`](date/README-index-20260804.md) |
| `20260803` | 13 | [`date/README-index-20260803.md`](date/README-index-20260803.md) |
| `20260802` | 77 | [`date/README-index-20260802.md`](date/README-index-20260802.md) |
| `20260801` | 58 | [`date/README-index-20260801.md`](date/README-index-20260801.md) |
| `20260731` | 51 | [`date/README-index-20260731.md`](date/README-index-20260731.md) |
| `20260730` | 145 | [`date/README-index-20260730.md`](date/README-index-20260730.md) |
| `20260729` | 32 | [`date/README-index-20260729.md`](date/README-index-20260729.md) |
| `20260728` | 223 | [`date/README-index-20260728.md`](date/README-index-20260728.md) |
| `20260727` | 38 | [`date/README-index-20260727.md`](date/README-index-20260727.md) |
| `20260726` | 25 | [`date/README-index-20260726.md`](date/README-index-20260726.md) |
| `20260725` | 181 | [`date/README-index-20260725.md`](date/README-index-20260725.md) |
| `20260724` | 51 | [`date/README-index-20260724.md`](date/README-index-20260724.md) |
| `20260722` | 161 | [`date/README-index-20260722.md`](date/README-index-20260722.md) |
| `20260722-shelf` | 80 | [`date/README-index-20260722-shelf.md`](date/README-index-20260722-shelf.md) |
| `through-20260721` | 775 | [`date/README-index-through-20260721.md`](date/README-index-through-20260721.md) |

Full roster with counts: [`CHAPTERS.md`](CHAPTERS.md).
