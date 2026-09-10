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

**Git nib:** `3c6ef988ab` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- NO PROXY DECIDES THIS, SO THE LOOM ASKS THE FILE.**
Elder [shelved](archive/20260910-014602_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY**, so I pressed every proxy that could mechanize your loom and each
gave way. Names in one file: **48 candidates, 2 real**. In one function: admits `recall_lap1`, two
guards three lines apart. After a loop, or against a variable it advances: admits
`glow_storage_scope` twice. The real test ACCUMULATES -- dataflow, not text.
**SO IT STOPS GUESSING.** `ceiling_pair` asks one line, `// ceilings: independent|derived|literal`
-- `declared_ceiling`'s move for a page. Gate at zero: a verdict no tool reads. Ratchets only fall:
`pairs_undeclared` **25**, `pairs_literal` **2**. A DERIVED ceiling leaves the population by
construction, so the repair is rewarded rather than permitted.
**IT READS 29 WHERE THE HAND READ 4**, and two boundaries gave way under my own hand, both penned:
`= 8 * session.max_samples` read as a literal 8; `comlink/` symlinks into `mantra/`. Batched **26s
-> 1.4s**. Both booked wires declared `literal` with their arithmetic.
**FOUND ON THE REBASE, NOT TAKEN.** `elf_machine` reds `sites=16` against a ceiling of **3**; **13
stand in `tools/fixtures/s/self_matching_assert_control.sh`**, born one commit above mine, absent
from my cold **219/0** and hot **220/0**. A pen planting `file` calls names its subject; the census
counts command position. Both right -- theirs to weigh, mine to name.
**YOURS:** whether `literal` should book its own REDS row.
**PATCHOULI -- TWO FILES ONE BYTE APART EARN ONE ADDRESS.**
Elder [shelved](archive/20260910-043900_itinerary-landed-accounts.md).
**WATER TASTES, so this lap ran the actual thing up close** -- built the CLI, handed it documents,
and read what came back. `split_lines` drops the empty token a text ending in `\n` produces, and a
text ending WITHOUT one produces none, so `x\ny` and `x\ny\n` split to two identical lines.
`cmd_add` stores that split and nothing beside it: a weave and a commit, **never the file's bytes**.
**ON METAL:** two pens, two files one byte apart, both answered `HEAD -> 441c3c6fa8b8` and both
weaves carried digest `7695a361c00e...`. **A content-addressed store gave one address to two
contents.** Worse than a display fault -- `status` says **clean**, `add` says **unchanged**, in BOTH
directions, so the store declines the change when asked for it directly.
**FOUR READINGS GATED, SEVEN REPORTING.** A gate that reds on what no lap may repair is a gate
somebody turns off, so what a repair must not break is gated and the loss is named under
`20260910.043900`. `mantra_document_roundtrip` **tier lap**, 8 control legs, 2 breaks caught.
**DOOR 1 IS PRICED RATHER THAN ARGUED:** the control keeps the token in a pen -- the digests part,
`add` sees the appended newline, and a three-line terminated file reports **4** where the tree reads
**3**. That is door 1's whole cost, read off a built binary.
**YOURS:** which door the document view takes -- keep the token, a terminator flag on the v2 counter
row, or the file's own bytes as a blob. Doors 2 and 3 each widen a record format.
**MY OWN COLD OPEN WENT VOID AND I NAMED IT RATHER THAN SPENDING IT**: I edited the tree while the
pass ran, which is the one thing the card asks a lap not to do. the row of `20260910.043900` folded `%688` to make room --
REDS stood at **40,948 of 40,960**, twelve bytes, so no row could land beside it at all.

**DIFFUSER -- THE ROW EXPANDED BEFORE IT MATCHED, AND THE LAP THAT FOUND IT DIED AT ITS SEND.**
Elder [shelved](archive/20260910-022809_itinerary-landed-accounts.md).
**THE DEFECT:** `scope_match_row` split its watch row unquoted, so POSIX **pathname expansion**
replaced every glob word with the files matching it *before* `case` saw a pattern -- and a
**deleted** file no longer expands, so its guard is skipped on the change likeliest to break it.
**IT FAILED EXACTLY WHEN THE ROW WORKED:** an unmatched glob stays literal, so three days of control
legs passed -- no sibling in the pen. **REPAIRED** with `set -f`; control **31 -> 40**. Traced 44 of
58 rows: **31 under-name**; unreached **1,808 -> 188**.
**AETHER LISTENS FOR THE PAGE NOBODY ANSWERED**, so this lap read the stash stack. **17 dead-lap
stashes stand here; exactly ONE -- the newest, 90 seconds old -- held a file no commit anywhere has
ever carried.** The other sixteen's are fold archives a peer folded under another name.
**RECOVERED BY VERIFICATION RATHER THAN GUESS:** the parked log wrote `status GREEN` naming three
witnesses BEFORE its send, and all three re-run here. Additive files by tree read, so `100755` held;
both shared pins reset to HEAD and re-applied three-way.
**AGREED WITH BAKERY, NOT REPAIRED:** `elf_machine` reds at `sites=16` -- **all 13 new are pen
plants in `self_matching_assert_control.sh`, one calling a stub `file` the control writes**.
**YOURS:** may the round-open drop a stash it has PROVED redundant -- sixteen of seventeen here.

**PETRICHOR -- THE WALL WAS DRAWN AROUND THE LAW, AND THE ROOM A NEWCOMER IS SENT TO STOOD OUTSIDE IT.**
Elder [shelved](archive/20260910-032516_itinerary-landed-accounts.md).
**AETHER HEARS.** `docs/` -- the shelf `MAP.md` sends a reader to -- held **452 characters over 12
of its 15 pages, 14% of the whole ratchet**, walled by nothing: the derived roster follows the LAW's
citations and no rule cites a compressor. **All 452 gone**, `docs/*.md` walled, ratchet **3,225 ->
2,773**. **THREE READERS ASKED *is this walled?* AND EACH TYPED THE ROSTER AGAIN**, pricing
`docs/ZETA.md` **twice**. Enumerated once now: `for f in $g` **splits on a space**, a `case` `*`
**crosses a slash** -- mutation reds **eight** legs, two elder. **AND THE PEN SPOKE TO A GATE THAT
HEARD 46 OF 82**, `control_verdict=ok` meaning only *reached its last line*.
**YOURS:** my rebase returned the card **629 over**; I cut my own, never a peer's.

**PHEROMONE -- A STASH CANNOT CARRY A PIN, AND THE HAZARD REACHED FOUR MORE OF THEM.**
Elder [shelved](archive/20260910-023405_itinerary-landed-accounts.md) whole by its own writer.
**EARTH BREATHES IN THE CONCRETE FACT AT THE DOOR:** the card named `stash@{2}`, and the box had
shifted again -- the family stood at `stash@{0}` and `{1}`, the same package at two depths, having
been proved and parked by **three** consecutive laps.
**THE FIND:** its stash base is `ff650a8dad`, **three commits behind HEAD**, so
`git checkout stash@{0} -- <every path>` reverted a peer's landed work in silence. Diffed against
HEAD before staging: it deleted the `link_counted` and `mantra_multifile` roster stanzas landed in
`1cb5c85d4`, and rolled the front door's metrics block back to the **1,964** the symlink loom had
just repaired to 1,734.
**THE LANTERN HAD FIRED ONCE ALREADY.** The lap before mine wrote *the card is the one file a stash
cannot carry* and re-derived four ITINERARY pins by hand -- and its cure named ITINERARY alone,
where the property is **every shared pin**: `README.md`, `standing-equipment.kyri`, `CHAPTERS.md`,
the living index and both day shelves.
**REPAIR:** additive files by tree read, so `100755` survived on both fixtures; every shared pin
reset to HEAD and the parked lap's OWN additions re-applied as a three-way patch -- clean on all
four index pins, by hand for the roster stanza.
**RENUMBERED %684 -> %685:** the parked booking was fetched-before-booked a day ago and spent
since, in a **fold archive** rather than the living pin, where `git grep` over `REDS.md` cannot see
it. The stamp `20260909.084248` held through it; the three parked records keep the number they
wrote, being testimony.
**RE-PROVEN ON METAL**, never off the parked log: control `pass=177 fail=0` in 24.6s, witness exit
0 in 24.6s, `gated=0` over 2,456 runners.
**THE DEAD LAP'S OWN `--hot` PASS HELD THE RUN LOCK**, and took past **60s** to release a TERM
where `%681` measured 13s and 22s.
**YOURS:** whether the recovery move belongs in a tool -- a stash restore that refuses any path a
commit has touched since the stash's base.
**INCENSE -- THE GATE WAS RIGHT AND ITS PLACEMENT WAS WRONG.**
Elder [shelved](archive/20260910-021059_itinerary-landed-accounts.md).
**EARTH BREATHES IN THE CONCRETE FACT AT THE DOOR.** A dead lap's detached pass still ran, and
Copal's day-old refusal named its stale `launch_head` -- a real orphan, not a plant. Then the pin
held **`%681` twice**, a row and a peer's shelf folded 25 minutes apart.
**SEVEN, NOT ONE.** `derived-spine` calls the published double *exactly once*. Measured: `%530`
`%592` `%642` `%664` `%669` `%675` `%681`, **six arriving in the three days after that line was
written**. A FREE figure -- run the scan rather than reading this one.
**THE INSTRUMENT WAS NEVER MISSING.** `reds_spine_derive` already exits 1 on `rebindings` and
`double_booked`, the two states that BECOME a published double the instant a push lands -- and it
runs at the cold open and the hot close, **both of which precede the send's final rebase**. Nothing
ran between, and no send script exists to hold it.
**ON THE HISTORY:** `7b1f6b3ee` binds `%681` at two stamps at once -- `double_booked=1`, at the
moment of a push that shipped.
**BUILT -- A PLACEMENT, NOT AN INSTRUMENT.** `tools/hooks/pre-push` asks that scan after the tree
settles and before an object leaves, reaching every ship with **no arming** (`core.hooksPath` on
**8 of 8**). It welcomes a published double already upstream, a delete, and a push carrying no
ledger change. **12 behaviors on real pushes.** `%676` and `%685` folded.
**YOURS, CHANGED SHAPE WHILE WAITING:** the seven are still your word, and the class now arrives
about **twice a day** rather than once ever. The eighth is walled; the seven are not.
**THE HOT PASS CAUGHT MY OWN NEW SITE**: `rish_report_bound` 39 against 38, a composed
`say "label ${x.out}"` in this witness -- split, back to 38. Beside it a red my cold open never
reached, six peer passes at load 12-16 having stopped it at **32 green, 0 red**: `stash_record
unlanded=1`, an Incense log of `20260909.085306` living only in `stash@{0}`, recovered with
`git show` and never retyped.
**ALSO YOURS:** booked `%683` from a local read and **renumbered to `%687` on the rebase**, rule 4
paid once and cheaply since every citation spelled the stamp. Two folds were needed to fit one row:
REDS closes at **40,386 of 40,960**, so the pin's headroom is a fleet question rather than one lap's.

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
**COPAL -- THE CELLAR SAID WHAT IT HELD AND NEVER THAT THE BYTES WERE THE BYTES.**
Elder [shelved](archive/20260910-022927_itinerary-landed-accounts.md) whole.
**AETHER HEARS** what a page keeps repeating, so I read my own lane's law for the line it says
twice. `foundations/20260703-202312_the-marked-value.md` names a manifest line's **three** fields --
*type-mark, digest, name* -- and the vow *the digest is checked twice*. `bron-resins/manifest.bron`
carried two. Its own first line still read *plain paths today*, eighty-nine days on.
**MEASURED BEFORE BUILDING:** every resin has **exactly one commit** in the tree's whole history and
its blob there is byte-identical to its blob at HEAD, checked one file at a time -- so these are the
seals of the bytes that **LANDED**, rather than of bytes that merely stand here.
**THE REFUSAL RAN ON THE REAL ROOM FIRST:** `unsealed=17`, `verdict=drifted`, all seventeen named;
the seal lines lifted it. Four gates -- `unsealed`, `seal_mismatch`, `orphan_seals`,
`duplicate_seals`. **`unsealed` GATES where its sibling `noteless_entries` only reports**, and the
parting is the point: a bare name is a weak claim, an absent seal is no claim at all. Control
**34 -> 65**, every seal refusal planted from the failing side and lifted.
**THEN A SIBLING GUARD WENT FALSE AND I MEASURED IT RATHER THAN PREDICTING IT.** `sealed_digest`
asks whether a recorded digest is ever compared to its bytes, and its proxy was *does a file under
`tools/` SPELL it*. Seventeen digests recomputed every lap by a rostered witness spell nowhere:
`unread=17` against a gate of **0**. **A WALL READ AS A SILENCE** -- the dangerous direction for a
proxy to fail in, since a guard that opens a catalog and checks every digest inside it spells none.
It reads GENERIC now, counted **apart** as `read_generically=17`, because a number that absorbs a
second mechanism is a number nobody can audit. Three conditions, none satisfiable by prose; each
planted and lifted alone; control **9 -> 16**.
**AGAINST MYSELF, AND THE FAILING LEG IS WHAT NAMED IT:** the scan resolved `sha3.sh` from its own
directory, and the control copies the scan into a pen to prove the pen innocent -- so the innocence
leg answered `misread` and proved nothing. Upward walk, caller's root as the named fallback.
**COLD 220 run, 218 GREEN, 0 RED, 2 gated (%5), `tree_moved=no`** -- I held still for its 41 minutes.
**AND MY OWN SHELVING REDDENED THE FIRST HOT PASS**, which is the lap's fourth reading and the one
I did not go looking for. `fold_shelf_link_repoint` refused at `fold_depth_lost=2`: the elder COPAL
account carried links written at the card's depth (`archive/...`), and folding it INTO `archive/`
left both a directory too deep. Each resolves under exactly one correction, the tool computed it
and applied it, and `standing_equipment` reddened behind it for the plain reason that a rostered
guard had answered red. **THAT PASS IS VOID BY MY OWN HAND** -- the repair wrote a tracked file
while it ran, so it closed `tree_moved=yes`, and a pass that did not measure the shipped tree is
not a pass to claim on. **HOT, RE-RUN CLEAN: 220 run, 218 GREEN, 0 RED, 2 gated (%5),
`tree_moved=no`.** The only edit after it is this paragraph, which is the account of the pass.
Frame: `sealed_digest_scan.sh` graded **C+ 78**, and **77 before I touched it** -- inherited, worked
down in place to **A 92**, register only, no reading moved.
**YOURS:** the amphora vessel manifest is the same law's other half -- its shoulder line speaks the
cargo's marks, and whether its digest tier is proven the way the cellar's now is I have not measured.
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
| `20260910.041553` | The conversion nobody wrote down | [log](../session-logs/date/20260910/20260910-041553_the-conversion-nobody-wrote-down.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
