# Upstream -- reports filed outward, and when we last checked

**Where this sits:** home is [`../README.md`](../README.md) - the walk that explains every room is [`../MAP.md`](../MAP.md)

**Language:** EN
**Status:** Living -- room home
**Voice:** Kyri
**Style:** Gauge, Door setting
**Room:** checkable -- every entry names the report it tracks and the date it was last read

---

## What this room holds

A fault found here sometimes belongs to someone else: a provider's model, a tool's own release, a
vendor's service. We cannot fix those ourselves. What we can do is report them clearly, keep one
record of what we said and where, and check back later without having to reconstruct the whole
story from memory.

**This room is not the REDS ledger.** `construction/REDS.md` holds what we got wrong, the fix
always ours to make. Upstream holds what someone else's system got wrong, reported outward, with
the fix waiting on their hand rather than ours.

## The shape

One file per check-in round, at `upstream/date/YYYYMMDD/YYYYMMDD-HHMMSS_sprig.md`, the same
one-clock naming and day-shelf fold every dated room in this tree already uses. Each entry names:

- **Provider and product** -- who owns the fix.
- **The report** -- links, issue numbers, or ticket IDs, and the date filed.
- **What we observed** -- plain, with evidence (version strings, request IDs, timestamps).
- **Status at last read** -- open, acknowledged, resolved, or stale.
- **What would tell us it moved** -- a maintainer reply, a changelog line, a version bump.

A later check-in on the same report cites the earlier one rather than restating it, the same way a
REDS row's own repair cites the row it closes.

## When to write an entry

When a fault is reported to a provider outside this tree, and again whenever that report is
checked. Not every passing mention of a provider earns a room here -- only a report we filed and
intend to revisit.

## Discipline this room keeps

- **Plain words, never "bug."** [`vocabulary-red-over-bug.md`](../.claude/rules/vocabulary-red-over-bug.md) governs here too: a fault, a red, an error -- never a bug.
- **Dated and closed-stack.** Entries fold under `date/YYYYMMDD/` exactly as `session-logs/` does, and this room joins the closed stacks in [`read-scope.md`](../.claude/rules/read-scope.md) once it has folded once.
- **Accrete-never-break.** An entry is never rewritten to claim a resolution; a new, dated check-in records what changed.

---

*May every report we send outward land somewhere it is actually read, and may the next check-in find good news.*
