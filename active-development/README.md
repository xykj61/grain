# Active-Development -- the room where a round thinks out loud

**Language:** EN
**Opened:** `20260821.174047`
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Living -- new room, bounded at 256 flat files from birth
**Sibling:** [`../active-designing/README.md`](../active-designing/README.md) -- the room that thinks in essays

---

## What this room is for

This is where a **round** does its scoping. The plan for the next lap, the surface an implementation has to meet, the ledger of what a sweep found, the evaluation of two approaches before one is chosen -- granular, near-daily, bound to the work in front of you rather than to the shape of the whole system.

It exists because [`active-designing/`](../active-designing/README.md) was opened for **essays** and quietly filled with **round notes** instead. The evidence was in the room's own cadence: 78, 163, and 141 files on three consecutive days in August 2026, against a room whose purpose was long-form design reasoning. That is not essay tempo. Two different kinds of writing had been sharing one shelf, and the smaller, more numerous kind was crowding out the larger, more durable one.

So the two now have two rooms, and neither has to pretend to be the other.

## The one test

Before filing, ask one question:

> **Would this still be worth reading if the code it describes were deleted?**

**Yes** -- it reasons about a shape, a name, an invariant, a direction, a trade-off that outlives any particular implementation. That is **[`active-designing/`](../active-designing/README.md)**.

**No** -- it scopes a round, plans a lap, records what a survey found, or evaluates a choice already made and shipped. That is **here**.

The test is deliberately blunt. A filing rule that needs a paragraph of adjudication gets skipped, and a skipped rule is how one room filled with two kinds of writing in the first place.

## What holds here

- **One-clock names.** `YYYYMMDD-HHMMSS_short-sprig.md`, the whole stamp, per the [mark law](../.claude/rules/stamp-and-name.md). No ascending marks, no round numbers minted into filenames -- a stamp orders it and a name means it.
- **A bound of 256 flat files**, enforced from the day this room opened rather than earned later by folding. This room was born under the law and never accumulated a backlog, so there is nothing to grandfather: it folds to `date/YYYYMMDD/` before it can ever outgrow a reader (`tools/r/room_bound_witness.rish`).
- **References are resolved, never rewritten.** A note here that cites a file which later moves keeps its words; [`tools/d/dated_path_resolve.rish`](../tools/d/dated_path_resolve.rish) finds the new home.
- **Radiant Style**, the same as everywhere. A round note is short and working prose, not a rough draft of English.

## What does not move here

Nothing already filed. The 629 dated notes that folded out of `active-designing/` on `20260821` stay exactly where they are -- the test governs what is **born** from here forward, and a retroactive re-sort would spend a week to make old files feel tidier without making one of them truer.

## Kin

- [`../active-designing/README.md`](../active-designing/README.md) -- essays and durable design
- [`../active-reviving/README.md`](../active-reviving/README.md) -- an elder thing re-grown beside itself, born with its new name
- [`../session-logs/README.md`](../session-logs/README.md) -- what actually happened, in the voice's own notation
- [`../ORGANIZING.md`](../ORGANIZING.md) -- the filing guide for the whole tree

*May this room stay small and useful, and may the essays next door get the quiet they were opened for.*
