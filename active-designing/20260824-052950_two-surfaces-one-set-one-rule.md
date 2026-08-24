# Two surfaces describing one set want one rule

**Language:** EN
**Stamp:** `20260824.052950`
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Checkable -- every figure below is a measurement on this tree, dated and reproducible
**Kin:** [`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md) - REDS %182

---

## The question

A room of files grows past what a reader can hold, so it folds: the files move into dated
subdirectories and a bound keeps the flat level small. The room's `README.md` indexes them.

**What bounds the index?**

The answer this tree ran for a month was *a separate number, checked by a separate meter.* The room
had a bound of 256 flat files, enforced. The index had a bound of 24,576 bytes, declared in its own
header. Both were measured. Both were reported. The room passed every lap.

The index reached **2,895,849 bytes** -- 117.8 times its bound -- on `20260824`.

## What actually happened, in mechanism

`tools/rye/session_logs_archive.rye` folds a room. For each flat file whose stamp names a day
other than today, it moves the file into `date/YYYYMMDD/` and rewrites that file's link in
`README.md` to point at the new path. The function is `fold_session_logs`, the rewrite is
`rewrite_readme_links`, and both are correct at what they do.

Neither moves a row. So each fold left the index carrying every row it had ever carried, with the
links repointed, and the room shrank while the index did not. Over roughly a month of folds the
index accumulated **2,373 rows** across **30 distinct days**, of which only four days had any file
still flat in the room.

Three further faults were visible once the size was:

- The title `# Session logs` stood at **line 1,881** of 2,421, beneath 1,880 rows. The rule says
  *prepend a newest-first row*, prepending means line 1, and so every row for a month went in
  above the header. Nothing was wrong with any single prepend.
- **None** of the 1,658 table rows sat under a delimiter row. The GitHub-Flavored Markdown spec
  requires a delimiter directly under a table's header for the block to be a table at all, so
  those rows rendered as 1,658 lines of literal pipe characters.
- Two row shapes were interleaved -- 1,658 pipe-table rows and 714 elder list items -- from eras
  nobody had reconciled.

Each of the three is a consequence of the same thing: a file that no one opens whole, because
opening it whole is not practical.

## The measurement that was there the entire time

This is the part worth carrying past the incident.

`tools/fixtures/living_docs_lint_roster.sh` lists `session-logs/README.md`. Duty 6 of
`living_docs_lint` reads that roster, compares each path's bytes to `living_pin_max_bytes`, and
prints a line for every path over it. It printed this, on every run, for a month:

```
ADVISE duty6 living-pin-bytes session-logs/README.md: 2895849 > living_pin_max_bytes=24576
```

Beside three more: `caravan/README.md` at 497,531, `construction/ITINERARY.md` at 76,439,
`docs/CRYPTO.md` at 68,547. The spec that seated the bound names `session-logs/README.md`
**by name** as one of the ledgers that must fold, and it was written on `20260724.132812` -- a
month before this round.

The witness containing duty 6 closes with `GREEN: living-docs lint -- advisories printed; witness
never fails.` That is deliberate and documented. It is also the whole story.

**A measurement that only ever prints is a number rather than a bound.** The gap between those two
things is not knowledge -- every fact needed was on screen every lap -- it is whether anything
stops.

## The design answer: one rule for both surfaces

The repair that generalizes is not a second byte ceiling. It is noticing that the room and the
index describe **one set**, and giving that set one rule:

> **A day's index rows fold the moment that day's logs do.**

The living pin then holds exactly the rows whose logs are still flat. The index cannot grow while
the room shrinks, because they move together. And the byte bound stops being a promise anyone has
to keep: it becomes a consequence. Fold a room to today, and its index holds one day of rows --
a few kilobytes, without anyone aiming at a number.

Measured on this tree: 2,193 rows moved onto 26 dated shelves, and the pin fell from 2,895,849 to
**266,790 bytes**, which is 180 rows for the four days still flat in the room.

### Why the ordering is files-first, and not the reverse

A shelf is immutable once written, so every link in it has to be right forever. That constrains
which rows may fold.

A row for a day the room has folded already reads `](date/YYYYMMDD/name)`. From a shelf at
`date/README-index-YYYYMMDD.md`, one directory down, the same file is `](YYYYMMDD/name)`. One
rewrite, one answer, correct permanently.

A row for a day still flat carries a bare filename. Its correct target from a shelf would be
`](../name)` today and `](YYYYMMDD/name)` the moment the room folded -- so writing it into an
immutable shelf would be writing a link with an expiry date. That row waits.

Following the files is what makes the shelf link a pure function rather than a guess, which is the
same property `stamp-and-name` already asks of every folded path.

### Why the gate is a row rule rather than a byte ceiling

A guard that refuses ordinary work gets turned off, and this is the clearest case of it.

A byte ceiling on the pin would red on the next lap that writes a log, because writing a log is
what the tree does. Everyone would learn to raise the ceiling, and a ceiling raised on schedule is
a comment.

The row rule refuses nothing anyone does on purpose. A row goes stale only when its logs fold, one
tool folds both, and running that tool is the whole repair. So the guard sits silent through
ordinary work and speaks exactly when the two surfaces have drifted apart -- which is the only
moment it has anything to say.

## The alternative that was considered, at its best

Put each day's index rows inside that day's own room, at `date/YYYYMMDD/README.md`.

Its case is genuinely good. A reader browsing `session-logs/date/20260813/` on a forge sees 187
filenames and no explanation; a README there would render above the listing and tell them what the
day held. The path is still a pure function of the stamp. And it keeps one directory rather than
two kinds of thing in `date/`.

It lost on precedent. Three shelves already stood at `date/README-index-YYYYMMDD.md`, seated
`20260725.040520` and listed in `session-logs/SEASONS.md`, and a second shape for the same job is
exactly what the mark law was written to prevent. The right time to reconsider is a round that
converts all of them, rather than a round that adds a twenty-seventh in a new place.

## What the guards taught after the design was right

The design above is sound and the first implementation of it was not, in a way worth recording
beside it.

`shelf_row` moved a row's `](date/YYYYMMDD/name)` link to `](YYYYMMDD/name)` and left every other
target as written. A shelf sits **one directory deeper** than the pin, so a relative target that
meant `<room>/T` has to read `../T`, and **62 targets** in this room reach past the room already --
`../docs/CRYPTO.md`, `../crypto/README.md`, `../foundations/...`. All 62 broke. `readme_reach`
named each one on the roster run after `git add`. The loom for that class already existed and
fired, which is the system working rather than a gap in it: **a repointer moves text while a fold
moves depth** is the tools-fold lesson, restated in a new room.

The second fault teaches more. I repaired the 26 shelves already on disk with a script, and the
script over-applied -- deepening each shelf **header's** own `../SEASONS.md`, which the tool writes
correctly for that depth, and reaching two elder shelves that had stood right since
`20260725.040520`. A patch over generated output has to re-derive what the generator knew, and it
will get part of it wrong.

**When a generator's output is wrong, fix the generator and re-run from a clean base.** The pin
came back from `HEAD`, all 26 shelves went, `shelf_row` learned one rule for every relative target,
and the fold ran again. The elder shelves came back byte-for-byte with `git checkout`. This is
cheap when the generator is the only writer, which is the strongest argument for having one.

## What this does not settle

**Four rooms still carry the fault**: `active-designing` 86 stale rows, `counsel` 112,
`expanding-prompts` 78, `waymarks` 41 -- 317 together, measured `20260824.052950`. They ride a
ratchet under a ceiling that only falls. Folding a room's index also means rewriting its front
door by hand, and four front doors written in a hurry is how a repair becomes its own red.

**The pin is still over its byte bound**, at 266,790 against 24,576, because 180 logs sit flat in
the room and folding the room is Keaton's word. That is a gate rather than a red: the number is
now a consequence of a decision someone can make in one word, rather than a drift nobody owns.

**Three other documents remain over the same bound** -- `caravan/README.md` at 497,531 bytes,
`construction/ITINERARY.md` at 76,439, `docs/CRYPTO.md` at 68,547 -- and none of them is an index,
so none of them is fixed by folding rows. Each wants its own reading about what a front door is
for. `caravan/README.md` is the loudest: 2,694 lines describing 110 modules, on the module whose
legibility the ranked remainder already names as the crux.

## What to take somewhere else

**When two surfaces describe one set, bound them with one rule rather than two numbers.** Two
numbers agree until the day they do not, and the day they part is invisible, because each meter
reads its own surface and reports green.

**Prefer a rule the ordinary case never violates.** A guard is only as good as its silence during
normal work.

**When a meter has been printing the same line for a month, the finding is not the line.** It is
that printing and stopping are different things, and only one of them is a bound.
