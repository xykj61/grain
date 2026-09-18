# The shelf that closes before the guard looks again

**Stamp:** `20260915.174558` (EDT, one clock)
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Room:** mixed -- the census and the commit order are checkable; the disposition at the end is a
proposal wanting Keaton's word
**Status:** Living
**Kin:** [`.claude/rules/session-logs.md`](../.claude/rules/session-logs.md) -
[`.claude/rules/the-baton.md`](../.claude/rules/the-baton.md) -
[`tools/fixtures/i/index_row_bound_scan.sh`](../tools/fixtures/i/index_row_bound_scan.sh)

## What happened, in plain words

`tools/in/index_row_bound_witness.rish` stood **red** on this pier from `20260914.002310` until
`20260915.174634` -- one index row on `session-logs/date/README-index-20260914.md` measuring **196
bytes** against the **192** an index row is given. The repair was one clause: the row's meaning cell
read *280 cold guards green; Glow shape ruling remains* and now reads *280 cold guards green; Glow
ruling stands*, at 186 bytes. The scan answers `verdict=ok` and the witness reads GREEN.

That is the whole of the repair, and it took **two ships and about ninety seconds of margin.**

## The window

The scan decides which shelf is open by name rather than by clock: the open shelf is the newest
`README-index-<day>` in the room, so a control can plant one in a pen and get the answer this tree
gets. That reason is sound, and it has a consequence nobody had written down.

**On the first lap of a new day, the newest shelf is yesterday's.** The scan therefore gates a page
the session-log law calls frozen -- the shelf's own Status line reads *immutable once the day
closes* -- and it stops gating that page the instant any lap writes today's shelf. The window opens
at midnight and closes at the day's first log.

On `20260915` that window ran from midnight to **17:46:17**, seventeen hours and forty-six minutes,
because the fleet had been down overnight. The 196-byte row sat inside it the whole time. Had the
day's first shelf landed first, `date/20260915/` would have existed, `20260914` would have closed by
the scan's own rule, and the row would have stood over the bound forever -- with the roster reading
green, correctly, about a page it had stopped reading.

## The ninety seconds, read off the commit order

Two commits decided it, and their order in history is the whole margin:

| Commit | Author time | What it did |
|---|---|---|
| `afff49795` | 17:46:34 | landed five parked records **and** trimmed the 196-byte row |
| `3e7c10952` | 17:46:17 | created `session-logs/date/README-index-20260915.md`, closing `20260914` |

The repair is the earlier commit in history and the later by author clock, which a rebase can
produce and which changes nothing about the outcome: the trim was in the tree when the shelf froze.
Read `git log --oneline --diff-filter=A -1 -- session-logs/date/README-index-20260915.md` for the
second row, and `git log -1 -S'Glow ruling stands' -- session-logs/date/README-index-20260914.md`
for the first.

**Two ships found it at once.** This lap read the same red off the same scan, made the same trim
with a different clause, and dropped it on the rebase that brought the peer's repair down -- which
is the ordinary cost of eight writers and one ledger surface, and is worth seeing plainly rather
than counted as waste. One red, two hands, ninety seconds of margin, and the margin was luck.

## The census -- how much has escaped

Measured `20260915` over every day shelf in `session-logs/date/`, counting rows above 192 bytes that
carry a stamp cell:

| Span | Shelves with hits | Rows | Rows over bound |
|---|---|---|---|
| `20260801`-`20260829`, before the scan read the open shelf | 26 | -- | **1,569** |
| `20260830`-`20260915`, after it did | 0 of 15 | 1,207 | **0** |

The first figure is the room before the instrument, and the scan's own header tells that story. The
second is the instrument working: fifteen closed shelves, twelve hundred rows, every one inside the
bound. **The window has never once been paid.** Today's row would have been the first.

Both figures are **free**, so run them rather than reading them here:
`sh tools/fixtures/i/index_row_bound_scan.sh` for the open shelf, and the awk one-liner in this
lap's session log for the closed ones.

## The lantern that fired twice

Two rows went over the bound inside two days: a **206**-byte row at `20260914.212434`, named in the
hot pass's own evidence file at `20260914.222020` and since gone from the shelf with its log, and
the **196**-byte row above. Standfast asks what the loom is when a lantern fires twice -- and the
honest answer is that **the loom already stands and fired correctly both times.**
`index_row_bound` is rostered, it reads the open shelf on every pass, and it printed its refusal
with the offending row quoted in full.

The layer above it is where the reading slipped. The lap that met the first firing shipped
**YELLOW**, its own log recording *three existing reds plus its aggregate red*, and the red went to
the ledger's reading as weather rather than to the cord. So the second firing had a whole day to
arrive.

**The helper story ends the same way.** `tools/s/session_logs_index_prepend.rish` is the one tool
that ever wrote index rows, and it writes the elder bullet form into `session-logs/README.md` -- a
page that has held no lap row since the birth-on-shelf law of `20260827.171500`. Measured this lap:
**no living file calls it**; its only citer outside itself is a dated `yonder/` page from
`20260720`. Every shelf row in this tree is typed by a hand, and the roster measures it afterward.
That arrangement works exactly as long as a red line is read as a stop.

## What the two pages disagree about

The shelf says it is immutable once its day closes. The scan says it is open until a newer shelf
exists. Both are right about their own job, and on `20260915` they were right about one file at
once. A hand meeting that disagreement has two honest readings available and one word answering
both questions -- *whether a shelf may be edited* and *whether a shelf is measured* -- which is the
braid this tree already has a name for.

Both ships resolved it the same way, on the ground the law itself supplies: **a row points, it does
not summarise.** The log keeps every word it wrote; the index is the way in, and trimming a pointer
leaves testimony whole. That reading is offered rather than seated.

## The disposition, proposed rather than taken

**Name the day's first act.** The escape needs no new instrument -- it needs the day's first lap to
read the open shelf before it creates today's, and any lap to treat a red guard line as a stop. Both
are habits, and a habit belongs where habits are set: one line on `tools/f/fleet_baton.txt`, beside
the LOG section that already tells a lap where its row goes.

Three repairs were weighed and declined, each for its own reason:

- **Read the clock.** It would close the window exactly and break the pen control, whose whole
  value is that a planted shelf answers the same way on any machine and in any hour.
- **Gate the previous shelf too.** It would red on a page no lap may lawfully edit, which is the
  gate somebody turns off.
- **Book a red.** The ledger stands at sixteen OPEN rows with its bound freshly raised because
  little is closing. A hazard measured at zero instances across fifteen shelves earns a page and a
  baton line before it earns a seventeenth row.

**The falsifier:** if a closed shelf dated `20260830` or later ever reads a row above 192 bytes, the
window has been paid and the habit was the wrong instrument.
