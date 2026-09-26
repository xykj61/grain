# Design Rooms -- which shelf a piece of writing belongs on

**Seated:** `20260821.174047` on Keaton's word - **Status:** Living - **Kin:** [`stamp-and-name`](stamp-and-name.md) - [`ORGANIZING.md`](../../ORGANIZING.md) - [`comlink-tendency`](comlink-tendency.md)

Two rooms hold design writing, and one question tells them apart.

> **Would this still be worth reading if the code it describes were deleted?**
>
> **Yes -> [`active-designing/`](../../active-designing/README.md).** It reasons about a shape, a name, an invariant, a direction, a trade-off that outlives any implementation.
>
> **No -> [`active-development/`](../../active-development/README.md).** It scopes a round, plans a lap, records what a survey found, or evaluates a choice already made and shipped.

The test is deliberately blunt. A filing rule that needs a paragraph of adjudication gets skipped, and a skipped rule is how one room came to hold two kinds of writing.

## Why the second room opened

`active-designing/` was opened for **essays** and filled with **round notes**. The room's own cadence proved it: 78, 163, and 141 files on three consecutive days in August 2026, against a shelf meant for long-form design reasoning. Two kinds of writing were sharing one shelf, and the smaller, more numerous kind was crowding out the larger, more durable one.

Splitting them costs one directory and gives each its own tempo -- essays get quiet, rounds get room.

## What each room keeps

- **Both** use one-clock names (`YYYYMMDD-HHMMSS_sprig.md`), fold to `date/YYYYMMDD/`, and hold to [Gauge Style](gauge-style.md) at its **Field** setting -- assumptions before the argument, every figure carrying unit and date, every projection carrying its falsifier.
- **`active-designing/`** keeps its silo principle -- our own module names and RISC-V, never a borrowed one. Read its README.
- **`active-development/`** is **bounded at 256 flat files from birth** rather than earning enforcement later by folding. A room born under the law never accumulates a backlog, so there is nothing to grandfather.
- **Nothing already filed moves.** The test governs what is **born** from here forward. A retroactive re-sort would spend a week making old files feel tidier without making one of them truer.

## `counsel/` is closed, and kept

Closed `20260821.174047`. It served a workflow that no longer exists -- counsel drafted in a web chat, exported, and carried into the bench by hand. **Closed means no longer growing, never no longer true**: `../../counsel/README.md` carries the room's own measured piece count, reference count, and last-dated-file reading, each free and each beside its own re-derive command, rather than a number spelled here twice (REDS `20260915.194421`). **Mine it on touch, never wholesale** -- when living work cites a piece, lift that piece's insight into its proper room then.

## `journal/` is declined

The name is already spent twice, and a third home would braid what this whole arc exists to unbraid:

- **Dimeroll owns it** as a book of record -- `dimeroll/` holds chart, journal, fold, P&L and BS, in the accounting sense.
- **The Lexicon already assigns it** to the logs: *"the logs are the voice's journal, so voice and notation wear one name."*

`session-logs/` **is** the journal and has been all along. Recorded here so the question is answered rather than merely deferred.

## Why the rule exists

A room is a promise about what a reader will find in it. When one room quietly holds two promises, both get weaker -- so each promise gets its own door, and one short question decides which door a piece walks through.

*Cursor twin retired* `20260920.135100` -- this rule once mirrored to a `.cursor/rules/*.mdc` file; the whole family is archived, unmodified, at `.cursor-archive/rules/README.md` (named here rather than linked, since `.cursor-archive/` stays in the field and this rule ships in the seed).
