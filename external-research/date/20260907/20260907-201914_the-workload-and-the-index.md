# The workload and the index -- what this tree actually asks of its journal

**Stamp:** `20260907.201914`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living -- **mixed room**: the census, its control and the witness are checkable and bind the reading; the store recommendation is a proposal awaiting a hand
**Kin:** [`20260907-191657_two-shapes-one-notation.md`](20260907-191657_two-shapes-one-notation.md) (the paper this one answers) -- `tools/fixtures/j/journal_query_census.sh` -- `tools/j/journal_query_witness.rish` -- [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)

**A store is fitted to two things: the shape of the data, and the shape of the questions.** The
previous lap measured the first and recommended an index over content-addressed records. It also
wrote down, in plain words, the measurement that would shrink that recommendation:

> Count the queries the tree's own tools actually ask of the journal. This paper measured the
> **data** alone and left the **queries** for another lap, which is a real gap and is named here
> rather than papered over. If nearly every tool asks *the newest N records* and nearly none asks a
> field predicate, then a sorted room is worth more than an index, and the plan shrinks to that.

This lap ran that count. **The falsifier fires.** The tree asks its journal for records by name, by
day, and by recency; it asks for a field predicate approximately once, and that once arrived
yesterday. The recommendation shrinks from *build an index* to *keep the room sorted and watch the
one query that would change the answer* -- and the watching is now a witness rather than a habit.

---

## What was measured, and the unit it was measured in

**Scope.** Every tracked executable source under `tools/` -- `.sh`, `.rish`, `.rye`, `.awk` --
**3,363 files**, read `20260907.205400` on the Dallas pier, after the census excludes its own two
files by exact path. **Population:** the **238** non-comment lines among them that name
`session-logs/`.

**These figures were re-measured on the lap that landed them, and they moved.** The census was
written at `20260907.203000` and its lap was parked in a stash before it could commit; six hours of
fleet work landed underneath it. Re-running before the send is what caught that, and the movement is
itself a reading -- reported below rather than quietly overwritten.

**The unit is a line, not a tool, and the reason is that a tool wears several hats.**
`tools/fixtures/i/index_fold_scan.sh` names the room in a roster, in a path it builds, and in a
message it prints. Counting tools would bin all three under whichever the reader noticed first.
Counting lines lets one file contribute to three classes honestly.

**The classifier reads lead marks and command shapes, first match wins**, and the order is stated in
the script's own header, because a line can wear two hats and the earlier reading is the stronger
claim about what the line is *for*. Every class is planted in a pen and watched to appear:
`tools/fixtures/j/journal_query_control.sh`, **26 behaviors**, both directions, GREEN.

---

## The first finding: most mentions are not questions

| Class | Sites | What the line does |
|---|---:|---|
| `construct` | 88 | builds a pen or a path *under* the room -- `mkdir`, a path join, a create redirect |
| `message` | 41 | quotes the room's name inside a refusal, an echo, an assertion's expected text |
| `roster` | 18 | names the room beside three or more sibling rooms |
| `exclude` | 15 | names the room only to skip it -- `grep -v`, `! -path`, `:(exclude` |
| `rule` | 8 | reads `.claude/rules/session-logs.md`, the **law** rather than the room |
| **non-query total** | **170** | |
| `by_path` | 25 | a literal record path carrying a one-clock stamp |
| `index` | 23 | the room's README or a day shelf, rather than any record |
| `enumerate` | 5 | `find`, `git ls-files`, a `for` over the room, bodies unopened |
| `recency` | 1 | newest-first -- `sort -r`, `head -` |
| `exists` | 0 | a `[ -d ]` test |
| **`field`** | **0** | **a field name anchored at line start inside a record body** |
| `other` | 14 | printed whole, file and line, rather than binned |

**Observation.** Of 238 lines naming the journal, **170 -- 71 percent -- never read a record.**
**54** are real queries. **Zero** are field predicates by the line reading.

**Inference.** The journal is, to this tree's tools, mostly a **place** rather than a **dataset**.
The commonest thing a tool does with the room is build a fake one beside it for a test, and the
second commonest is decline to walk it.

**The `rule` class was not anticipated and is the reading's own small correction.** Eight sites read
the *law* at `.claude/rules/session-logs.md` to check a rule still says what a witness assumes. A
first draft counted those as queries and credited the journal with a workload belonging to the rules
directory. They are separated now, and named, so a reader can disagree with the split.

---

## The second finding: the bracket, and why a single number would have lied

**`class_field=0` is a lower bound, and taking it as the answer would have been the failure this
census exists to avoid.** A regex that matches nothing prints the same zero as a tree that queries
nothing.

**The tree's one real field query is invisible to a line-level read.**
`tools/fixtures/r/rota_declared_scan.sh` enumerates a day shelf at line 77 and matches `^rota ` at
line 104 -- **twenty-seven lines apart, with a loop between them**. No line names both.

**A first draft answered this with a five-line window and got zero.** That would have been a false
all-clear: a bound agreeing with the reading it is meant to check is not a bound. The bound is
**file-level** now -- every source that names the room anywhere and carries a line-start field
anchor anywhere -- and it reads **4**, each named in the output so a reader can close the bracket by
opening them. Read by hand, `20260907.205400`:

| File | Queries the journal? |
|---|---|
| `tools/fixtures/r/rota_declared_scan.sh` | **yes** -- `grep -q '^rota '` over a day shelf |
| `tools/fixtures/s/status_declared_scan.sh` | **yes** -- `grep -q '^status '` and `'^scope '` over a day shelf |
| `tools/fixtures/s/standing_equipment_control.sh` | no -- field anchors over the equipment registry |
| `tools/fixtures/s/standing_equipment_run.sh` | no -- the same registry |

**So the true count of field predicates over the journal is two**, bracketed by a measurement rather
than asserted: at least 0 by line, at most 4 by file, exactly 2 by reading the four.

**And the count doubled inside the parked lap.** The census was written when the answer was one:
`rota_declared_scan.sh`, whose field was seated in `.claude/rules/session-logs.md` on
`20260906.222120`, the first tool in this tree's history to ask the journal about a record's
contents. `status_declared_scan.sh` landed while this lap sat in a stash -- seated
`20260907.200326`, reading `^status ` and `^scope ` over the same shelves.

**Observation:** two field-querying tools, seated a day apart, both within the last two days.
**Inference:** the habit that produced the first produced the second, and it is a habit about
*session-log provenance* rather than about storage -- each new field the log law seats brings a scan
that reads it. **Projection:** if the log law seats one field a week and each brings its scan, the
field-query count reaches a tenth of the querying sites -- today's threshold, **7** against 64 -- in
roughly **five weeks**. Horizon five weeks, confidence **low**: two points make a rate only in the
loosest sense, and the fields a law seats arrive by decision rather than by chance.

**This is why the recommendation is a watch rather than a conclusion.** A single reading would have
said *one query, build nothing*. Two readings a day apart say *build nothing yet, and here is the
number that decides*.

---

## The third finding: the instrument was inside its own reading

**The census names the room and carries a line-start field anchor, and so does its control** -- the
first because that anchor *is* its reading, the second because it plants a field query into a pen to
prove the class visible. Left alone, the pair counted themselves: `field_capable_files` read **6**
where four files were the tree's, and `class_field` read **1** where the one site was the control's
planted literal rather than a question anyone asks.

**That is not a rounding error, because the verdict is a separation and the margin is small.** The
threshold is a tenth of the querying sites -- **6** today. At 6 capable files the guard was one file
from red, and **two of the six were the instrument.** A guard that eventually reds because it exists
teaches only about itself, and the first hand to meet that red would have spent a lap learning
that.

**The census steps out of its own frame once, before any line is read**, by two literal path
equalities, and it **prints how many it excluded** -- `self_excluded_sources=2` -- so a reader sees
the step rather than trusting it. **Exact paths rather than a pattern**, which is `%578`'s lesson in
this tree read forward rather than repeated: a grep for a path matches every mention of it,
including the sentence explaining why the file does not do the thing. A path equality is the act.

**Proven from both sides, and the load sits on the first leg.** The control asserts that both files
**would have counted** -- each names the room and carries a field anchor -- before asserting that
neither appears in the reading. That first leg is what makes the absence mean something: a file that
never qualified and a file correctly excluded read alike from the output. Four cases run over the real
tree, since two hard-coded paths cannot exist inside a pen and an env-var list would be a door
anybody could point anywhere. A fifth runs in a pen and asserts the count reads **zero** there, so a
pen never silently inherits the tree's number. Control **26 behaviors to 31**.

**The honest limit of the cure:** it is a list, so a third file joining this family spends the
budget again until somebody adds it. The printed count is what keeps that visible, and it is the
whole of what this repair promises.

---

## What the reading changes

**The prior recommendation, restated:** a content-addressed key-value store with an index, because
Tablecloth answers *these bytes by their name* and stays silent on *every record whose `voice` reads
Kyri*, which today costs a **153 s** full walk.

**That silence is still real. What has changed is how often anyone speaks into it.** Twice, in two
tools written on consecutive days. **An index is a real cost** -- a second copy of the truth, a
rebuild discipline, a staleness question every reader must hold -- and two queries do not buy it.

**And both queries share a shape the sorted room already serves well.** Each walks **one day's
shelf** -- roughly a hundred records -- rather than the room. `rota_declared_scan.sh` and
`status_declared_scan.sh` both take a day parameter first and grep second, so the sorted room has
already narrowed the population by two orders of magnitude before the field is read. **A field
index earns its keep against a whole-room predicate**, and both field queries this tree asks are
day-shelf ones.

**The proposal, shrunk.** Keep the journal a **sorted room** and spend nothing:

- **Recency and by-path are already free.** The one-clock naming law makes a filename sort a
  chronological sort, so *the newest N records* is `ls | tail`, and *this record* is a path. Those
  two classes are 26 of the 54 queries and need no machinery at all.
- **The `index` class is 23 more, and it is already an index** -- hand-written, in
  `session-logs/README.md` and the day shelves, maintained by the law that a log is born on its
  day's shelf. A store would replace a thing that works and reads.
- **The day shelf is the cheap index the field queries already use**, and strengthening it costs
  nothing new: a query that names a day before it names a field is answered by the filing law.
- **Build the field index when a WHOLE-ROOM field query arrives**, and let the arrival be measured.
  That is now `tools/j/journal_query_witness.rish`, which binds `verdict=sorted_room` and reds the
  day field-capable sources reach a tenth of the querying sites.

**The verdict takes the upper bound on purpose.** A wrong answer then errs toward building the index
rather than toward skipping it, which is the cheaper mistake to discover.

**Whose lane, unchanged.** Copal owns the store's shape and its sealing; Bakery owns the call sites.
This paper hands Bakery **nothing to build today**, and says so plainly, which is the honest half of
a research lane's job.

---

## Falsifiers, horizon, and confidence

**What would kill the central claim, and it is cheap.** Re-run the census after the next ten tools
land. If a field query arrives that reads the **whole room** rather than one day's shelf, the
workload has turned and the index recommendation is live that hour. The counted proxy is
`field_capable_files` against a tenth of `querying_sites` -- **4 against 6** today, a margin of two
files. Horizon: **one week**. Confidence the claim survives that week: **low**, lowered from the
draft's medium by this lap's own re-measurement -- the field-query count doubled in a day, and two
files is one habit's worth of margin. **The verdict flipping is the
instrument working**, not the paper failing: it would mean the watch caught the turn.

**What would kill the reading rather than the claim.** The classifier could be wrong about what a
line does. Two checks stand against that: the `other` bin is **printed whole with file and line**,
so an unanticipated class is visible rather than absorbed, and it holds 14 of 238 -- **6 percent**.
Every class is planted in a pen and proven to appear and to disappear. A reader who disagrees with a
class can open the 14 and say so.

**What this reading does not reach, stated rather than implied.** It reads `tools/` alone. A query
asked from a Rye module, from a git hook, or by a hand at a shell prompt sits outside it. The
hand-at-a-prompt case is the largest gap and the hardest to measure: a maintainer grepping the
journal for a phrase asks a full-text question that neither a sorted room nor a field index answers,
and nobody records those. **Naming that gap is all this paper can do about it.**

**Projection, stated as one.** If the tree keeps writing roughly a hundred records a day, the
journal reaches its census ceiling of **8,192** in about **38 days** from `20260907`, and a full
walk costing 153 s today costs roughly 290 s then. **The workload determines whether that matters.**
Under a sorted-room workload it does not: recency reads the tail and by-path reads one file, and
neither is linear in the room. Under a field workload it does, immediately. **So the projection to
watch is not the record count -- it is the field-query count**, and that is the one this witness
holds.

---

## What this lap hands forward

**To Bakery:** nothing to build, and the reason. **To the card:** one open question, below.

**Yours, one.** The gap this census cannot reach is the hand at a prompt, and it is the query class
an index serves worst and a full-text search serves best. **Is a full-text reading of the journal
worth measuring at all** -- by instrumenting nothing and simply asking what questions the
maintainer actually types -- or is that a census whose only honest source is a person's memory, and
therefore not a census?

*May the room stay sorted, may the one question that changes the answer be heard when it comes, and
may the index we did not build stay unbuilt until it is earned.*
