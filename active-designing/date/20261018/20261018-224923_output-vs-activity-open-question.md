**Style:** Gauge at Field setting
**Stamp:** `20261018.224923`
**Voice:** Kyri
**Status:** Living -- design room, open question
**Room:** vision

---

# Output vs activity -- an open question

What does this fleet produce, and how much of that is different from what it does?

## The distinction

**Activity** is motion: guards run, session logs written, loom readings recorded, rota rows
read, commits made. The fleet measures activity well. `loom_trend.sh` trends any key
across the journal. `rota_declared_scan.sh` counts declared rota fields per day. The
standing-equipment roster runs 300+ guards per cold endurance run. Activity is visible,
counted, and growing.

**Output** is what lands and stays: a GREEN witness that proves a new capability, a landed
commit that ships to `xy/main`, a ww seed push that reaches the public, a docs-geode page
that teaches something real, a Rye module that another module imports. Output is what
reads true on the far side of years.

A fleet can be highly active while producing little output. Eight ships running 130 laps
per day each generate 1,040 session logs, thousands of loom measurements, and hundreds
of rota declarations -- and still land fewer than ten net new capabilities in a week. The
activity is honest. The output ratio is the question.

## What output looks like, concretely

A partial working list, each item checkable:

- A new `.rye` source file with a GREEN witness (`scribe_reader_witness`, `caravan_suite_witness`)
- A predicate or function that another module imports or cites
- A docs-geode page graded B or better at Door setting
- A ww seed push (one Option-B commit, `IDENT_CLEAN` witness GREEN)
- A tool whose exec bit is set and that a live hand runs in a real task
- A new Kyri session-log field validator in `scribe/reader.rye` that closes a single-strand gap
- A scan script that a lap actually runs as part of round-open, not just during a dedicated witness

The last two are the kind this fleet produces most of: small, precise, one-strand-at-a-time
additions to the reading machinery. Each is real output. The question is whether that
class of output is the right ratio of the whole.

## What the ratio question asks

Not "is the activity wasted" -- it mostly is not. A cold endurance run that comes back
GREEN proves the tree is still whole. A session log that carries a rota row proves a lap
read the council. Loom measurements that trend over weeks prove a module is getting
faster or slower. Activity earns its keep.

The ratio question asks: **for every hundred laps of activity, how many laps produce
something that a reader who arrives a year from now would call output?**

This tree does not have a number for that today. The loom journal tracks what was
measured. The REDS ledger tracks what was wrong. There is no equivalent ledger for
what was built and stayed.

## One shape for a Tablecloth answer

Tablecloth is content-addressed. Every object it holds is sealed by its own SHA-256,
stamped, and reachable by content key. A "project" in Tablecloth terms is a named
collection -- a root key pointing at a sequence of entries.

If this question were answered via Tablecloth, one shape:

```
project output-vs-activity-20261018
  entry 20261018.224923 -- this question, as a seed record
  entry <stamp> -- each landed output, one record per item
    kind: witness | module | docs-page | ww-push | tool
    path: <path in tree>
    landed: <git nib>
    note: one line saying what it proves
```

A `loom_trend.sh`-style reader over that project would answer: how many outputs per week,
by kind, trending. The ratio would then be computable from loom's activity count and this
project's output count.

## The open questions, in order

1. **Is the distinction load-bearing?** If the fleet's activity is already well-aimed at
   lasting output, the ratio is a confirming read rather than a correcting one. If activity
   is drifting toward motion-for-motion's-sake, the ratio is the early warning. Which of
   those two is true today is not yet measured.

2. **What belongs in the output ledger?** The list above is a first pass. A witness that
   proves an existing module GREEN (no new capability) is not output by that definition --
   yet it is one of the most valuable things a lap does. The boundary between "proving
   something already built" and "building something new" is where the definition needs
   sharpening.

3. **How does Tablecloth's content-addressed shape fit here?** The output ledger is a
   sequence of records pointing at git nibs. Tablecloth holds blobs sealed by content;
   it does not hold branching history. The right carrier might be a ledger file in
   `construction/` (like REDS) rather than a Tablecloth project -- or a hybrid where
   Tablecloth holds the record bodies and the ledger holds their content addresses.

4. **What would change if the number were known?** This is the check: a metric earns
   a home only when it would change a decision. If the output-to-activity ratio were 1%,
   would the fleet respond differently than if it were 20%? Name the threshold first,
   then build the meter.

## The seed shape, inspired by ww

The ww seed ships depersonalized. This question, stripped of any one fleet's
specifics, could ship in the seed as a template for any pier that wants to track
its own output ratio. The template would carry:

- The distinction (activity vs output) in plain words
- The example kinds (witness, module, docs-page, push, tool)
- The ledger shape (one entry per landed output, four fields)
- The open questions section (the four above, generic)

That would make this document a seed-ready design note -- the kind that ships
in `docs/` or `docs-geode/` when a future ww push includes it.

## Verdict

The question is real and the meter does not yet exist. The lap that builds it:

1. Sharpens the definition (which items count as output, by kind)
2. Chooses the carrier (REDS-style ledger, Tablecloth project, or hybrid)
3. Seeds it with today's already-landed outputs (the `has_rota`/`has_loom` predicates,
   the scan script citations, any GREEN witnesses from the last week)
4. Writes one `loom_trend.sh`-analog that reads the ledger and prints the ratio

That lap is a `check-in (either)` -- it wants a ruling on whether the distinction is
load-bearing before any building starts.
