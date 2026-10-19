**Style:** Gauge at Field setting
**Stamp:** `20261018.222456`
**Voice:** Kyri
**Status:** Living -- design room, checkable

---

# Scribe, batons, and the single-strand audit

What stands free, what composes from it, and what wants one place.

## What already is single-stranded

`scribe/reader.rye` is the canonical one-place definition for everything Kyri.
It holds:

- `parse` -- the Kyri parser (zero-copy, key-value fields from text)
- `is_session_log` -- `format session-log-v1` + `stamp` + `title` present
- `is_baton` -- `format baton-v1`
- `is_inventory` -- `format inventory-v1` + `stamp`
- `archetype_of`, `is_archetype` -- the dispatch layer for baton shapes
- Five archetype validators: `validates_galleon`, `validates_cutter`,
  `validates_barque`, `validates_holdfast`, `validates_corsair`, `validates_ledgerworks`
- `is_scribe_extension` -- `.kyri` filename check

Both diffuser and incense carry byte-identical `reader.rye` through line 220.
The clean-slate incense tree is the mirror and they agree. This is already unified.

## What composes from the reader

The dashboard (`scribe/dashboard.rye`) reads many Kyri documents, dispatches each
by format through `reader.rye`'s predicates, and lays them on shelves (logs, batons,
inventory, unread). It adds no new type knowledge -- it borrows `is_session_log`,
`is_baton`, `is_inventory` from the reader. One-place, clean composition.

The fleet baton (`tools/f/fleet_baton.txt`) is a different kind of baton entirely:
prose, prepended to every ship's loop prompt. It is not a `format baton-v1` Kyri
document. It governs BEHAVIOR rather than encoding DATA. The `first-baton.kyri`
is the live state baton; the fleet baton is the standing instruction. Two things
wearing the word baton, and they were always different things.

## What is not yet single-stranded: the rota field

The `rota` field in a session log has three homes today:

1. `session-logs.md` rule -- names it, its shape (`rota lap N, row R -- ...`),
   and the honest-absence form (`rota none -- <why>`)
2. Fleet baton ROTA section -- the habit instruction, where a lap reads the row
3. `tools/fixtures/r/rota_declared_scan.sh` -- counts rota, prose-only, and absent
4. `scribe/reader.rye` `is_session_log` -- reads the field as a generic string;
   does NOT validate its shape

The rota field's FORMAT is defined in prose but validated nowhere in Rye. A
session log with a malformed rota still passes `is_session_log`.

The single-stranded fix: add a `has_rota` predicate or a `rota_shape` validator to
`reader.rye`, so the one-place Rye definition knows what a well-formed rota looks
like. Then `rota_declared_scan.sh` can lean on the reader rather than re-deriving
the shape in shell.

## What is not yet single-stranded: `loom` field shape

Same pattern as `rota`: the `loom` field's format (`key=value ...` pairs) is
defined in prose (`session-logs.md`) and counted by `tools/l/loom_trend.sh`, but
not validated in `reader.rye`. A `has_loom` predicate alongside `has_rota` would
close the gap.

## The macro: alias-sameness for session-log fields

Under alias-sameness, several lawful names for one referent keep one implementation.
The session log's field inventory (`rota`, `loom`, `orbit`, `scope`, `status`) is
currently spread across:

- The prose rule (`session-logs.md`)
- The fleet baton (the habit layer)
- Shell scan scripts (the counting layer)
- `reader.rye` (the parsing layer -- only `stamp`, `title` are load-bearing today)

One move: define `required_fields` and `optional_fields` as comptime string arrays
in `reader.rye`, then let `is_session_log` assert `required_fields` and let a new
`session_log_completeness` function score the optional ones. The shell scans
cite that definition rather than re-deriving it.

## The composition picture, after the move

```
reader.rye
  parse()                  -- one Kyri parser
  is_session_log()         -- format + required fields
  session_log_completeness() -- optional field score (rota, loom, orbit, scope, status)
  is_baton()               -- format baton-v1
  validates_galleon/cutter/barque/holdfast/corsair/ledgerworks()  -- archetypes
  is_inventory()           -- format inventory-v1

dashboard.rye              -- composes from reader.rye; reads many docs

fleet_baton.txt            -- prose baton, separate kind; governs habit not data
first-baton.kyri           -- live state baton, format baton-v1

session-logs.md            -- the rule; cites reader.rye as the Rye definition
rota_declared_scan.sh      -- counts; cites is_session_log + session_log_completeness
loom_trend.sh              -- trends; reads `loom` field by key
```

## What to do

1. **No move this lap if reader.rye is green and the two trees agree.** They do.
   The trees are unified. The rota/loom field validators are a future lap.

2. **Name the prose baton and the data baton distinctly** if any new writing
   touches both. The fleet baton's section in the baton rule (`.claude/rules/`)
   already says it is the "opening every ship reads, written once" -- not a
   `format baton-v1` document. That distinction is already in the rule; the
   word disambiguates in the prose already.

3. **The rota validator lap** is the one worth booking: add `has_rota` to
   `reader.rye`, update `rota_declared_scan.sh` to import the shape from the
   reader's own constants, run the scribe witness GREEN. One new instrument,
   one claim before building.

4. **The loom validator** pairs with 3 -- same pattern, same lap.

## Verdict

The unification is mostly already done. What remains is a gap between prose
definitions of session-log fields and Rye knowledge of their shapes. The
`reader.rye` file is the right canonical home. The next concrete lap is: add
`has_rota` and `has_loom` predicates to `reader.rye`, update the scan scripts
to use them, run the scribe reader witness GREEN.
