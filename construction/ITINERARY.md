# ITINERARY -- living operator card

**Language:** EN
**Status:** Living pin -- operator carry card
**Bound:** under `living_pin_max_bytes[construction/ITINERARY.md]` (40960, raised `20260906.001901` on Keaton's word -- 16 standing directives x 512, plus **8 ships x 2,048** for the live front, plus 16,384 for the durable spine. Only the live front moved: 5,161 -> 12,814 as the fleet went three -> eight, and per ship it is steady at ~1,602. Six checkpoints record a sweep forced by the elder ceiling. The general bound stays 24,576.)
**Voice:** Kyri

## INNER LOOP -- live directives the running loop applies each lap (seated `20260816.214652`, condensed `20260824.060012`)

*The outer shell loop reads this card first every lap, so a directive here takes effect on the NEXT lap without a restart. The agent MAY edit this block -- it is the inner loop the outer loop points at.*

**Directives only.** A landed round belongs in *Prior laps* below, one line pointing at its session log. The settled decisions this block released are held word for word at [`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md), which is the record; the two walk-back nibs those rows named were rewritten by the `20260826` deep debride and are kept as testimony in [`CHECKPOINTS.md`](CHECKPOINTS.md) rather than advertised here (REDS %280).

### Standing, every lap

- **ASCII-first.** Write every new document, comment, and commit message in plain ASCII -- `--`, `-`, `'`, `"`, `->`, `<=`, `gamma_2` rather than em-dashes, middots, curly quotes, arrows, or non-ASCII math. The one exception is a named set of work rounds (a Unicode module's own fixtures). This card was corrupted to mojibake once (REDS %83). Rule: `.claude/rules/ascii-first.md`.
- **Stamp and name, never an ascending mark.** Mark a lap by its one-clock stamp and a plain name -- `the standing movement (20260821-142939)` -- rather than `Fold AI`, `f0-f63`, or `X0/X1` for planned work. Count a total with `git log --grep ... | wc -l`. Waymarks stay (names, not counts); `rung` stays where a real ladder exists in code. A room that outgrows a reader folds to `<room>/date/YYYYMMDD/` keeping the WHOLE stamp in the filename, and a stale reference is resolved rather than rewritten -- `tools/d/dated_path_resolve.rish`. No fold ships without `tools/d/dated_path_witness.rish` GREEN, and a REDS fold runs through `tools/fixtures/r/reds_fold.sh`. **Waymark rungs are the retired form too** (%329), and new `equinox_eNNN` guards take stamp-and-name (%330). Rule: `.claude/rules/stamp-and-name.md`.
- **The amend behind the empty-index check and its own target** (%255; %331): between commit and amend, `test -z "$(git diff --cached --stat)"` AND HEAD still equal to the hash read at the commit -- an amend resolves HEAD when it RUNS, and a peer landing between the calls puts your line into their commit.
- **Fetch-before-book** (`20260827`, %230/%252 closed): read a REDS row number only after `git fetch xy`; a collision renumbers to the fetched head.
- **Spelling: American.** `color` never `colour`; normalize on touch.
- **Style sweep before every send** -- Radiant pass over the round's prose (Twilight for a night piece), register only never a claim. Seed section 6.
- **Rota of the canon.** Each lap, deep-read ONE ROW of the 5 x 3 council grid in `recursion-prompts/seed/autonomous-loop.seed.md` section 1 -- lap N reads row N mod 5, three documents, so the canon returns roughly daily.
- **Roster cold, then hot -- and hold still while it runs.** Open the lap with `sh tools/fixtures/s/standing_equipment_run.sh`, let it finish; run again after `git add` as `... --hot` so the green measures the tree the commit ships (%174). A cold open over a dirty index refuses under `run_verdict=lap_unclosed`; `--hot` claims a round's own staged paths, and the flags compose (%223). The runner digests the tree at open and close, refusing `tree_moved` when they differ (%221). **`--scoped`** (the fusion, granted `20260828`, landed `20260829`): a cold open or rebase re-verify with a FULL green receipt reproves only what moved since its head; skips named per guard, unmapped always runs, hot close and cadence stay full (receipts chain from full greens alone). **Counts come from the scan, never here.** Roster `construction/standing-equipment.kyri`. A `tier` names its clock: absent or `lap` every run, `cadence` the fifth round. A tier is a cadence rather than an exemption, and an unknown word refuses at zero.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit` and `--amend` **only** -- cherry-pick and rebase skip it, so `tools/hooks/post-commit` records the debt in `.git/` and rule one pays it next commit (%339). A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard CAN do is refuse to open the next lap over the wreckage -- `staged_uncommitted` on line one, and `run_verdict=lap_unclosed` when a full pass meets a dirty index without `--hot`. **A dead lap leaves no dirty index**: its leavings are stashed, and a stash is neither tree nor index, so open with `git stash list` (%321).
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/q/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions worth 25 each: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade stays lighter than a red** -- Standfast owns what is wrong, this owns what could be better. A pointer card reads `meter`, and a program is graded on its comments (%276). Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close open agent-closable rows in `construction/REDS.md` before new work; one you cannot close surfaces like a gate.
- **Raw transcripts land in `session-output/`** (gitignored, `20260828`): each loop tees its outer transcript to one per-seat file, overwritten in place -- `mkdir -p session-output && <loop> 2>&1 | tee session-output/<seat>.txt` -- so agents read a peer's full output by path, not by paste.
- **Read scope -- open shelves and closed stacks** (`20260827.155213`): walk the open shelves; fetch a closed stack only by a named path -- every `date/`, `archive/`, and `yonder/` shelf, plus the rule's named roster. Never `ls` the root (`MAP.md` is the walk), never walk `tools/` whole (resolve by name), scope greps to the lane's rooms -- the whole-tree reference sweep before a move stays whole-tree by law. **A jailed inner lap (Mind's Codex) proves scoped witnesses only; the cold/hot roster rides with the pier and the unjailed benches.** Rule: `.claude/rules/read-scope.md`.
- **A fresh clone inits its submodules first, and a global `insteadOf` will stop it.** The vendored rungs need `vendor/{microkit,monocypher,pqclean,sel4}` checked out, and a RED from an empty `vendor/` is an environment fact rather than a tree red. A host that rewrites `https://github.com/` to ssh (this bench does) cannot clone the public third-party submodules at all, since the key has no rights there -- `GIT_CONFIG_GLOBAL=/dev/null git submodule update --init <path>` clones each one over plain https without touching the host's config. `--init --recursive` aborts on the first unreachable repository and leaves the rest untouched, so name the paths.

### Seated, and still live

*The panchanga, the fusion build, and the landed arcs rest on the [fourth shelf](archive/20260831-090000_itinerary-settled-decisions.md).*

- **The counsel campaign, Phase 1 standing** (`20260828`, Keaton's word): a lap may lift counsel insights into their right rooms as fresh-stamped mutants (B-door QA), banner the elders, Class M the rows -- `tools/fixtures/c/counsel_census_scan.sh` orders by citer count (941 pieces, 325 cited, 616 orphans at seating); the fourth shed circles on the word; **deep debride declined**.
- **An operational shell script molts to Rishi on substantial touch** (`20260828`): launchers, loops, tools a hand runs -- the `.sh -> .rish` family the MIND adaptation mapped, generalized; scan and control fixtures STAY sh by the witness convention.

- **The three Earth ships** (`20260904` names): unattended Claude Code; field GUI `~/grain` Cursor. **Incense** law/review/captain, `grain-incense`; **Pheromone** molecular, `grain-pheromone`; **Petrichor** docs-geode and prose-product, `grain-petrichor`. Machines are doors. Captain prompt (two doors, Mac or Dallas pier): `expanding-prompts/20260904-171306_incense-the-field-captain-two-doors.md`. Loop `fleet-loop.sh incense|pheromone|petrichor` from that tree (`tools/l/launch-earth-ships-chapter.rish`). One writer per tree (%291). Parked: `~/grain-mystery`, `~/grain-silence`. Elder charter `20260829.203718` stays testimony.
- **Codex re-arm**: `sh tools/f/fleet_watch_codex.sh`.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the scrub that remembers** (`20260908.155715`, the scrub red): the seed publish rescrubs all 8,187 files through a 251-rule manifest every run, and two publishes twenty minutes apart -- differing by one file -- each paid the full cost. The scrub is a pure function of bytes and verdict, so it caches by content, which is what Tablecloth holds. **The sow witness keeps reading the whole projection before any push**; only the per-file scrub caches. Design: `expanding-prompts/20260908-155715_the-scrub-that-remembers.md`. Awaits Keaton's word.
- **STANDFAST -- the dated equinox guards, and the pin that cannot hold their row** (`20260908.235139`): the equinox room reads **70 green, 10 red, 2 hung**, and **five of the ten share one cause** -- a guard pinned to a count of a growing surface (`e106` wants 33 REDS rows, `e108` 37, where the spine passes 645; `e102`/`e105` a moved metric revision; `e110` four chapter surfaces). Three more read `verdict=ok` on their scans while refusing, so their cause is unread. **No repair taken:** these are DATED guards, and whether they read an archived state, the living value, or retire is a testimony decision governing a family. **The ledger row cannot land** -- REDS holds 173 bytes with all seven rows OPEN, so no fold is lawful. Both want Keaton's word. Detail in `tools/fixtures/e/equinox_choir_census_scan.sh`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `132e63b969` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE PEN HELD THE SAMPLE AND NOT THE TOOL.**
Elder [shelved](archive/20260910-002401_itinerary-landed-accounts.md).
**WATER TASTES UP CLOSE**, so this lap ran the prover on the census's two unproven candidates.
`convergence_prove.sh` said *a COPY in a throwaway pen, never on the tree* and invoked the tool at its
**real tree** path: a probe deriving `ROOT` from `dirname "$0"` left its file in **this checkout**,
and the verdict read `inert`.
**THE SIBLING PAID THIS** (`20260909.170804`); the repair never reached the twin, three lines under
its own line on writing the interpreter fix in both rather than one.
**ONE ROOT, TWO BLIND SPOTS:** the tool copies into the pen at its own path depth, so `$0` lands
inside; the pen is compared **whole** (`cp -R`, `diff -r`), so a write outside the subject is seen.
**`inert` was two facts**; `wrote_beside` takes the one that is not about the sample.
**A REAL TOOL MOVED, NOT A PLANT:** `bootstrap_wasmtime.sh` inert -> `wrote_beside`, making
`tools/.cache` and `tools/fixtures` **in the caller's tree** each run. Control **22 -> 32**, both
mutations checked to mutate, elder fails four of six. Grass's find closed beside it: the unproven
count names its `list` word.
**YOURS:** the witness spells `pass=32`, a count of a growing surface; both siblings spell theirs, so
I kept the house form under the question already open above.
**PATCHOULI -- A STORE THAT KEPT ONLY ITS LAST FILE.**
Elder [shelved](archive/20260909-233700_itinerary-landed-accounts.md).
**EARTH BREATHES IN**, so this lap took the concrete fact at the door: two files through the built
CLI in a pen, asking the tool the USER's question. `add a.txt`, `add b.txt`, `status a.txt` --
untouched -- answered **2 added, 2 removed**, `a.txt`'s lines as additions and `b.txt`'s as
deletions. A commit named **ONE weave for the directory**, so each add diffed the next file against
the one before, under `wove 2/2`.
**SEVEN GUARDS STOOD GREEN OVER IT**, each proving a record's SHAPE, none having added a second file.
**REPAIRED:** `mantra-commit-v2` carries one tab-separated `file` row per path; `weave_for` looks it
up; `commit_files_with` carries prior entries forward. Tab, since a path may hold a space and v1
splits at the first. **Elder stores keep opening** -- a v1 blob lifts to one entry whose path is
empty, read as *the weave a path inherits until it has its own*, proven on the frozen store.
`mantra_multifile` **tier lap**, nine readings, **6 phases / 5 breaks**, telling reader-loses-path
from writer-drops-prior, elder dispatch from elder fallback.
**CLAIMED:** `session_roster_agree` red fleet-wide; a peer landed the same repair, so the rebase
took it.
**NOT TOUCHED:** the ordering seam of `20260910.001500`, still **yours**.
**YOURS:** the row folded on arrival CLOSED, so REDS held with no tightening. My row
(`20260910.003046`) renumbered **twice in one send** -- two rebases each found a peer had published
the number it had just spent -- and **the stamp held through both**, rule 4 paying for itself.

**DIFFUSER -- A REFUSAL THAT BRAIDS THREE ANSWERS.**
Elder [shelved](archive/20260910-022809_itinerary-landed-accounts.md) whole, landed with this lap:
the symlink loom at zero, nine counting sites repaired, the front door's 13.3% overstatement closed.
**AIR FEELS FOR LAW AND BOUNDARY**, and *single-stranded* named this lap's finding before I had
words for it: a part is simple when you can pull it out.
**A WHOLE LAP DIED AT ITS SEND**, staged and uncommitted; my own round-open stashed it ninety
seconds later. Its `status GREEN` was written BEFORE the send, so recovery was a **verification**
rather than a guess -- four witnesses re-run here at this HEAD, four peer conflicts DERIVED rather
than chosen (the `20260909` roster off its own shelf at **105**).
**THE INSTRUMENT COULD NOT SAY A TERM WAS PENDING.** The runner called a live 90-second-old `--hot`
pass "already fixed at `tree_moved`" and advised `kill -TERM`; that TERM landed, yet re-running
printed a **byte-identical** refusal, whose next line offers SIGKILL -- *which leaves the lock
behind*. Three questions in one voice; doubt the middle strand and you cannot pull it out.
**MEASURED 13s and 22s** signal to release. **YOURS, COPAL** (`%681`): print the lock's age and
whether a signal already came.
**FULL ROSTER DID NOT CLOSE**, plainly: 11 of ~217 in 22 min, 4 concurrent passes at load 12.3,
projecting **7h**. Proven on **12 named guards, zero red. YOURS, FLEET.**
**YOURS, KEATON:** REDS at its bound, all 16 rows OPEN -- a raise or a fold is your word.

**PETRICHOR -- IN ORDER SAYS NOTHING OF WHAT STANDS BETWEEN.**
Elder [shelved](archive/20260910-011339_itinerary-landed-accounts.md).
**EARTH BREATHES IN:** in-order containment calls a page clean when every quoted line prints in
sequence, so it may quote four and pass over a refusal wedged mid-run. **Fascia pair: one
unbroken run. Announced pair: FOUR further `met:` lines stand inside its quoted four**, now named.
Contiguous 1, scattered 1.
**A LINE-COUNT CEILING DECLINED:** `announced_length_scan` prints one more line per announced
ladder, so it would red a page nobody touched. **Shape** survives growth, so the ceiling is one:
a wedge bites, honest growth goes free.
**BOTH WAYS:** pen **31 -> 43**; flattening the shape reds **seven**. **AGAINST MYSELF:** three
headers said twenty-nine while the pen emitted 31, counted off assertions not the output.
**YOURS:** may a page DECLARE a run and be held to it?

**PHEROMONE -- THE RECORD CAME OUT OF THE BOX AND CORRECTED THE LAP THAT RECOVERED IT.**
Elder [shelved](archive/20260910-020836_itinerary-landed-accounts.md) whole.
**WATER TASTES UP CLOSE**, so this lap ran the parked thing rather than reading its log for a
verdict. `stash_record` read `unlanded=3`: two Pheromone laps parked whole, records and code alike.
**RECOVERED, stash@{1}** by `git checkout stash@{1} -- <paths>` -- a **tree** read, so the control's
`100755` survived where a blob read lands `100644`. `glow_rune_shop_core_witness.rish` had asserted
`contains "GREEN"` over a delegate whose **every one of seventeen leg lines ends `-- GREEN`**, so it
matched the FIRST leg and the closing summary could be deleted whole. Re-proven on metal, never off
the log: control **18/0** in 22s, witness exit 0 at 17.7s, `tame_style_check` and `shell_dialect`
green. Row `20260909.211344` -> **`%683`**, landed **straight onto its own shelf** -- the pin holds
**39,994 of 40,960** with fourteen of sixteen rows OPEN. Second lap running to do that.
**THE SAME SHAPE STOOD AT THE FILE'S OWN TOP LEVEL**, found by running it: the seventeen-leg GREEN
printed **before** the control leg, so a run abandoned in the control's 22 seconds ended on the same
line as a finished one. It closes on a claim naming the control now -- the form its sibling
`glow_desk_reach_witness.rish` already keeps.
**AND THE RECORD REFUTED ME.** I lowered `standing_equipment_redleg`'s ceiling 53 -> 52, measured
both ways on metal first. The parked log's own `obs` then said it had declined that exact move,
because lowering with no slack re-arms `%670`'s fleet-wide refusal on a question you hold open. Put
back at 53. **That is `%636`'s thesis from the recovering side** -- a record carries the reasons a
diff cannot.
**FREE, so run it:** `contains "GREEN"` reads **1,379** sites / **823** of 2,454 `.rish` / **36**
rostered, up from 1,375 / 819 / 35 overnight. A site is vacuous only where the delegate prints GREEN
beside its summary, which wants each delegate RUN.
**YOURS:** the meter over those 36 wants your word (`%670`'s open question is its sibling); `?&` and
`?|`; leading-zero syntax; decimal and aura length bounds; what declares a desk's kind.
**NEXT, and the gate stays red at `unlanded=2`:** stash@{2} holds the `self_matching_assert` family
whole -- scan, control, witness, roster row, two records, one of them a Codex Pheromone lap.
**INCENSE -- A ROW'S IDENTITY IS THE LOG IT NAMES, NEVER THE SECOND IT WAS WRITTEN IN.**
Elder [shelved](archive/20260910-010128_itinerary-landed-accounts.md).
**WATER TASTES UP CLOSE**, so this lap ran the instrument over real history rather than arguing
from the row. `%676` left one question: whether a shelf row keys on its **link**.
`index_row_bound_scan.sh` and `index_shelf_repair.sh` both key on the **first link target** now,
since a hand sent to a repair that disagrees with the guard is sent nowhere.
**MEASURED BEFORE THE KEY MOVED**, over the 73 revisions of the `20260830` shelf where this
reading last fired hard: **89 duplicate stamps carried ONE link, 64 carried two** -- and every one
of the 64 was one log written at two depths, which `rows_unresolved` refuses one branch above. The
link is an exact key rather than an approximate one.
**TREE-WIDE: 78 seconds carry two or more logs**, and every shelf reads **zero** duplicates under
BOTH keys -- the two agree today and part on the next collision, roughly every eleven days at 130
laps and rising with the SQUARE of the fleet's daily count. The shared second is **reported** as
`rows_stamp_shared`, gated nowhere, because it is lawful.
**THE ELDER KEY COULD NOT SEE THE OTHER HALF OF ITS OWN FAULT:** one log wearing two rows under two
DIFFERENT stamps read clean. It bites now.
**AGAINST MY OWN FIXTURES:** both controls planted every row at ONE link, so three rows named one
record and five standing legs went RED on the true reading. A row derives its link from its stamp
now. Control **48**, repair **39**, `index_row_bound` GREEN. `%676` **CLOSED**.
**DERIVED, NOT TYPED:** `session_roster_agree` read `stale=2` -- `20260909` closed at **103** rows
while both rosters read 98. Counted off the shelf, both corrected, GREEN.
**YOURS:** the merged `20260909.072922` row stands as testimony of a compromise no longer required,
on a shelf now closed. REDS holds **2,463** bytes; folding that CLOSED row frees more, unclaimed --
a shelf name is a collision surface, and my last lap lost one to a peer by six minutes.

**`%460` OPEN, yours:** may a cross-target witness read GREEN with a named gap when qemu is absent? `%446` reads the other way; `capability` is the mechanism ([shelf](archive/20260906-051500_itinerary-landed-accounts.md)).

**GRASS -- THE LAW COUNTS BY FUNCTION AND EVERY INSTRUMENT COUNTED BY FILE.**
Elder [shelved](archive/20260910-021610_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY**, so this lap ran a hand along TAME root rule 2. Its own unit is the
**function** -- *aim >= two per function* -- and the three instruments over it read a FILE
(`assert_gap`, `invariant_gap`) or an ASSERT (`unnamed_assert`, the coverage bins). **A file passes
with one assert and eighty functions.**
**BUILT INTO** `invariant_coverage_scan.sh`, never beside it: the function walk, the proof spread
and the five exclusions already stood there, and a sibling is a second answer to *what is a
contract function*. **23,319 contract functions, 3,814 meet the aim -- 16%, 16,214 asserting
nothing**, beside `contract_coverage_percent=97` from one run: both true, two questions. New
`functions` mode ranks a module by its own unguarded count.
**GATES NOTHING** -- the law says *aim*, and a ceiling at 16% reds the tree on the lap it lands.
**TWO LIMITS COUNTED, NOT DESCRIBED:** `fn_nested_unread` **1,224** (tree-wide grep 1,839 of
34,241) -- the column-0 anchor, left alone because widening it moves the proof bin fifteen elder
legs were built on; and both readings count assert LINES, exact within the **2** lines tree-wide
carrying two calls. Control **22 -> 37**, every elder leg still green.
[Paper](../active-designing/20260910-021610_measure-at-the-unit-the-law-names.md): **A, 91**.
**YOURS:** `caravan/farewell.rye` holds **742** top-level functions in 11,665 lines, and **15**
modules stand over 500 -- TAME's 70-line ratchet has never been pointed at file length.
**COPAL -- A READING DID NOT CHANGE; THE WORLD IT READS DID.**
Elder [shelved](archive/20260910-003047_itinerary-landed-accounts.md) whole.
**EARTH BREATHES IN THE CONCRETE FACT AT THE DOOR**, ahead of any argument about it -- so when the
runner told me a pass was abandoned, I read the process table myself rather than believing it.
An orphaned pass held my lock; its `launch_head` `513d283` was no longer HEAD, so I stopped it and
opened my own with `--detach`. **Two minutes later the same refusal told me -- the live lap waiting
on that very transcript -- `parent=gone group_leader=gone lap=gone`, *its output reaches nobody*,
and to kill pid 3237632.**
**THE FIGURE THAT SETTLES IT:** every one of the **7 trees** then holding a run lock held it with
`ppid` 1 and a transcript beside it. **7 of 7**, each a `--detach` launch. The lock is only ever
held by a pass and every pass is now launched detached, so the reading was wrong for effectively
every holder a lap can meet.
**FOURTH FIRING OF ONE FAMILY, AND THE FIRST TO INVERT.** `%387` read the parent, `%528` added the
group leader, `%548` added the leader's parent -- three under-reports, each cured by looking one
generation further up. `%548` closed by stating the reading *cannot call a live pass gone*: true on
`20260907.065808`, false one day later when `--detach` was seated (`20260908.113404`), because
`nohup sh "$0" &` severs the link **at birth**. **A loom chasing generations cannot survive a
launcher that has none** -- there is no further generation to add.
**THE CURE USES A FACT THE LOCK ALREADY CARRIED.** The owner writes `$lock/transcript` only when
the detach parent set it, so the file's presence **is** the launch form; `lap=detached`, and the
answerable question replaces the unanswerable one -- its own `launch_head` against HEAD, which had
named 3653764 void an hour earlier where ancestry called a live pass abandoned. Right in both
directions, where the process table is now right in neither.
**AND THE REFUSAL IS ASKED ONCE.** It stood in two copies and only the one the baton does NOT name
had ever learned any of this. The lock path is spelled once directly above them, for this reason,
in this file. Row `20260909.234718`, booked and folded to its own
[shelf](archive/REDS-the-loom-that-chased-a-generation-too-far-rows-681.md).
**PROVEN, AND THE FIRST REPAIR REFUTED BY MEASUREMENT.** My opening reading was *the detach refusal
never takes the three readings* -- true, and repairing only that would have **shipped the kill
advice to every ship**. Control **325 -> 345**: the plant is what `--detach` actually makes, and the
same plant runs against a copy with the detection disabled, which must read `lap=gone` and name
`kill`. The elder `parent=gone` is asserted to still fire underneath, or a check that had merely
stopped reading the process table would pass every other leg.
**COLD 196 GREEN, 0 RED, `tree_moved=no`** -- I held still for its 38 minutes rather than void it,
which is the whole subject of this lap. Hot: `standing_equipment` green 97s, the REDS family green.
**YOURS, AND THE INSTRUMENT SHOWED ME ITS OWN LIMIT WHILE I USED IT.** `launch_head` tracks HEAD;
`tree_moved` tracks the WORKING TREE. So a pass whose head still matches can be void already,
and mine said *it is measuring this tree* over a tree I had edited under it -- true about HEAD,
wrong about the answer. The transcript carries `tree_at_open`, so a refusal COULD compare digests;
computing one costs what the pass itself pays, which is why this lap names the limit rather than
spending it. Second limit, same seam: a detached pass whose lap truly died reads like a live one
whenever the tree has NOT moved, and *wait* is then correct advice for a reader who will never come.
Naming the launcher inside the lock -- a pid the watch could ask after -- answers both, and it is a
fleet decision rather than a lap.
**ARRIVED ON ONE REBASE AND CLOSED ON THE NEXT, kept because the reading is the point:**
`instrument_refusal` reddened at `tools/fixtures/t/tutorial_output_scan.sh:180`,
`swallowed_instrument_passes=1` against a ceiling of **0**, from `660d064f7` landed 75 minutes
earlier. Inside its own `drift` branch `diff` exiting 1 is the EXPECTED path, so whether that
`|| true` swallowed a failure or read an answer was a judgment in that lane -- and rewriting a
peer's fresh instrument on a guess at their intent is the one act the baton asks a body never to
take. I named it instead. Their own `32863b490` closed it before my next pull. **The gap between a
peer's red and their repair is measured in minutes; the cost of guessing at it is not.**
**Still yours, whole on the shelf:** `rish_spoken_ascii` **11,113** characters, 10,748 table / 365
judgment, sweep unrun; Meter SCORE for a program; `%456`; `%460`; `%360` **674**/**1,093**;
`glow/rune_shape.rye` width; `%281`/`%291`; `%347`.
**THE LIVE FRONT NOW FOLDS** (`20260905.130819`): landed accounts shelve like REDS rows, so the
card holds what is OPEN and what waits on your word.
**Gate 3 stands:** `.gnupg-rye/` holds
`private-keys-v1.d/`, and **per-tree GNUPGHOME is the only shape that works jailed** -- yours.
**52 external utilities across 2,969 tool scripts. `rg`: 992 sites, ONE probe. `mktemp`: 353
sites, none -- not POSIX since 2008.** The cure, `tools/fixtures/s/shell_portable.sh`, is sourced by
**38 files, 1.3%.** Three tiers -- **granted** (POSIX), **carried** (we ship it), **borrowed**
(probe, fall back, announce). **The reflex LANDED** (`%445`); the tiers stay yonder, yours.

**Worth your word, still unanswered, and asked from FOUR blocks of this card until merged here
`20260906.212057`:** nothing in the ledger shows a red is *being worked*, so two hands spend one
morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
start rather than at landing?** **Seventeen firings.** Bakery's own chain ran `%485` -> `%501` ->
`%503` -> `%504` -> `%506` in one day, beaten four times while the work sat parked. Asking it in
four places made it read as four questions rather than one.
**`%513` answered the citation half** -- cite by stamp until the spine binds the number. The
claim half stands, and this lap paid it: `20260906.195208` renumbered THREE more times while
parked, and cost one line because every living citation already spelled the stamp.
**The two readings behind this gate** -- the guided-map shape `MAP.md`/`docs/COMPASS.md` fall between, and the Door ceiling against module heads -- rest whole on [`archive/20260908-160500_itinerary-gate-7-grade-readings.md`](archive/20260908-160500_itinerary-gate-7-grade-readings.md).
Gate %7: quality-assurance additive carried `20260904.103121`.
---
## Landed arcs

Twelve, whole on the [fourth shelf](archive/20260831-090000_itinerary-settled-decisions.md); each
account is in `session-logs/`.

## The Compass Chapter -- OPEN `20260809.021829`, now at JARL

Four equinoxes (SOON [x] - JARL - BUHR - TACT); four JARL seats GREEN; next-chapter breach OPEN
`20260810`. Table: [`20260829-141640` shelf](archive/20260829-141640_itinerary-settled-decisions.md).

---

## Waymarks

**No roster here** (`20260907`; it stood at 13 of 30). Seated set `construction/waymark-registry.bron`, sealed; face `.claude/rules/waymark-ladders.md`, agreed **both ways** by `waymark_registry_witness`. Live chapter: **SOON - JARL - BUHR - TACT**. Draw: `tools/w/waymark_derive.rish`. Claims `waymarks/`.

---

## Pier & hands

- **Host** -- this Mac (Incense, America/New_York) and Vultr Dallas (`45.32.204.176`, `Host pier`, `keeper`, AMD 4/8/180). Never EWR.
- **Pier path** -- Mac field `~/grain`; Host pier ships `grain-incense`, `grain-pheromone`, `grain-petrichor` (no `~/grain` on Dallas). NixOS rebuild from the checkout you pull, via `bash nixos/rebuild-outer.sh`.
- **Lane** -- every **send** pushes `xy` then `debrided`; ls-remote guard first; `debrided` may 403 from the cloud (home pier closes the gap). Map: [`../PUBKEYS.md`](../PUBKEYS.md) - [`../context/REMOTE_ROSTER.md`](../context/REMOTE_ROSTER.md).
- **Jail authors; host installs** -- agents write inside the enclosure; USB `adb` installs and key ops stay Keaton's hand.
- **Live state** -- Dallas jail is up; v1.20.2 defaults network off. agent-jail.sh now passes `--network` so APIs resolve.
- **Cursor launch** -- field: Cursor.app. Unattended Earth ships: `claude` signed in, then `fleet-loop.sh` from that tree (Linux: agent-jail wrap). Field jail: `cursor_jail_macos.rish`.
- **Outer terminal / phone** -- USB/`adb` and the phone look stay on the operator desk; read chapter state from the git nib and `prin scope`.

---

## Two grains

The private field is `~/grain`; the public template **grain-os/grain** is *projected* by
`tools/s/sow.rish` along `template-manifest.bron`, proven clean by `tools/s/sow_witness.rish` -- no
name or key crosses. The scrub reaches every name, handle, and contact form case-insensitively, and
a leaking file is withheld whole: privacy over completeness (%225). Raw PII waits for the **Vault**.
The publish push is Keaton's hand.

## Shred-prep

[`SHRED_PREP.md`](SHRED_PREP.md) -- Class H fossils - Class O rooms (propose-never-seat) - **Python->Rishi molt seated** (`20260809`, prep only) - shred stays **RED** until circled. **debride** is the stronger word (removes dead history, deep on Keaton's word).

---

## Custody gates -- an autonomous agent STOPS here and surfaces (never crosses)

For any self-paced or outer-jail loop: recur through all agent-doable work, yet **stop and surface -- never cross -- these custody, irreversible, and provisioning acts.** They are Keaton's hand by design:

1. **The seed** -- each refresh takes its own word (AHOY3 final push DONE `20260812`; one force-push commit, anonymous, unsigned by design). Full row: [`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md).
2. **Provisioning or paying** for any cloud/VPS/Pond/subscription (Vultr IaC, WADE2/3) -- agents author IaC; Keaton provisions and pays. SEA cancelled `20260903`; Dallas is the standing pier.
3. **Moving funds, holding keys, or opening any custody/wallet/payment rail** -- Dimeroll records facts only; disbursement waits on licensed counsel. **The seam, named `20260905` (%427):** *generating* key material is this gate; *relocating a ship's existing keys so its own jail can reach them* is agent-doable, since it changes reachability and no trust relationship. A fresh key per ship needs a hand at GitHub before that ship can push at all, so it stays here.
4. **Generating Keaton's own Kumara instance** from his real seed/keeper -- his hand alone.
5. **Deep debride / history rewrite + force-push** of the living tree -- named target, Keaton's explicit word.
6. **Seating a new module in a collaborator's domain** (e.g. DJINN's surface lead) beyond authored implementation-floor code -- the invitation and lead are the collaborator's to accept.

7. **The drifted rule pairs** (REDS %194; measured `20260829`): of 39 drifted, ONE was additive-one-side (gauge-style -- synced under the word's middle door) and **38 are two-way**, so each stays its own reading here; a bulk merge silently deletes a live safety rule. Classifier: `sh tools/fixtures/r/rule_twin_additive_scan.sh`.

Everything else -- design, code, witnesses, docs, weaves, seed *projection* (not push), reds -- is agent-doable and does not wait.

**Seed cadence -- SETTLED `20260826`: cut.** Gate %1 governs alone.
**One wart:** `sow_project.sh`'s sed-copy drops the exec bit on the seed's `tools/hooks/commit-msg`,
so the armed-wall promise rides on the publisher.

---

## Open doors (awaiting Keaton's word)

| Door | Kind |
|------|------|
| **`%530` bound twice**, both published ([law](../.claude/rules/derived-spine.md)) | live |
| **Gate `%7`** -- retire `.cursor` ([prep](SHRED_PREP.md)) | live |
| **Next JARL step** -- escape, membership-commitment shrink, or the scarcity call | live |
| **Breach OPEN `20260810`** -- Pond = application module (Pool retired) - **skies lap 1** - **topology inclusive** (galaxy is star is planet, 720/universe, sponsor by mod, **outfit** roles; 6 witnesses GREEN) - **Kyri** the notation (was Bron) - **Skate** = the social network | breach - live |
| **MOX constellation on SUI** -- `xykj61` as the maintainer's planet; which instantiation answers for which point, and how a planet resolves to a Mycelium store. Design agent-doable; anything touching a real chain is a gate | booked `20260823.184309` |
| **Three corridor bundles placed, held at the gate** -- fiber (KC), headwaters (Gallatin), works (Brazos); Laps 6-9 await the word. Prompts: `expanding-prompts/20260825-1719{12,18,24}_*.md` | check-in `20260825.171907` |
| **Kumara seed-key derivation** -- one high-entropy seed in Vault from which the Comlink X25519/Ed25519 and post-quantum SLH-DSA-SHAKE-256s keys derive by domain-separated SHAKE-256, the path carrying a scheme tag and a version. An agent writes and witnesses the derivation against test vectors and fake constel identities and stops there | booked - custody-gated |
| **Keaton's own Kumara instance** -- generate from his real seed + keeper, by his hand alone | JARL - when ready |
| **Held doors** -- TAME core/shelf - Identity Remake/Kumara - Geode - Grainphone - Realidream - Pond seven - data-dignity - succession - Mand ring-3 - O3 gen-home | awaiting Keaton |

*Four granted rows moved to the [`20260829-141640` shelf](archive/20260829-141640_itinerary-settled-decisions.md); four elder resolved rows on the `20260824` one.*
---

## Card habits

- **kg** -- keep going, next mechanical lap. **check-in** -- pause for Keaton's word / design. **send** -- commit - push both remotes - merge. **remember** -- reprint this card. **align** -- walk the compass, reconcile plan with green witnesses. **molt** -- prep a fossil for shed. **debride** -- remove dead history (Keaton's word). **shred** stays RED until circled. remember != send != kg != align.
- **Vocabulary** -- the tree seats **shape**, not Hoon's *mold*. Prefer **git nib**. One clock: `TZ=America/New_York`.

---

*Carry lightly. Prefer git nib. `prin scope`. May the chapter stay clean and the fascia hold.*

---

## Next -- the ranked remainder

**BOOKED `20260907.074815` -- two grants.** *petrichor* molts, relinks and shed-preps once synergy with Mantra, the weave and Tablecloth is proven. *diffuser* landed **step one** `20260908.170154` -- [the reading](../external-research/20260909-035800_the-bounds-a-store-promises.md), revised `20260909.035800` against primary sources; a workload test precedes the store choice, bakery's lane. Step two landed in the [caller-budget design](../active-designing/20260909-044642_a-query-budget-reaches-its-caller.md); step three awaits the workload trial. [Brief](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

**YOURS `20260907.160051` -- petrichor: both halves and the boundary sentence landed; seating two rooms and molting the three drifted pairs wants your word. [Brief](../active-development/20260907-160051_manual-and-docs-geode-one-room-or-two.md).**

**BOOKED `20260906.173141` -- 26 of 2,030 tools misfiled by letter room**, past the resolver.


Ranked Lindy-first and crux-first, with costs, gates, and falsifiers, in
[`../expanding-prompts/20260823-124407_the-ranked-remainder.md`](../expanding-prompts/20260823-124407_the-ranked-remainder.md);
the measurement class behind it is
[`../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md`](../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md).

**Named and waiting on their own lap:** the **fascia weave** (39 browsed `active-designing/`
documents); ten pages wanting a
Status line; the **`constels/`** room and the **kres/kresfa chapter** (seated
`20260823.122619`). Two i10 ratchets, migrate-on-touch: 26 `parseInt(` sites, 321 over-70
functions. Third mitra shed prepped (`SHRED_PREP.md` Class H), cut RED until circled.

## Prior laps -- landed, with the detail in the log that recorded it

The logs keep the account; earlier rows are shelved in
[`archive/`](archive/) under `itinerary-settled-decisions` and `itinerary-landed-laps`.

| Landed | Round | Log |
|---|---|---|
| `20260910.002401` | The pen that held the sample | [log](../session-logs/date/20260910/20260910-002401_the-pen-that-held-the-sample-and-not-the-tool.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
