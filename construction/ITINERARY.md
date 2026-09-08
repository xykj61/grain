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
- **Stamp and name, never an ascending mark.** Mark a lap by its one-clock stamp and a plain name -- `the standing movement (20260821-142939)` -- rather than `Fold AI`, `f0-f63`, or `X0/X1` for planned work. Count a total with `git log --grep ... | wc -l`. Waymarks stay (names, not counts); `rung` stays where a real ladder exists in code. A room that outgrows a reader folds to `<room>/date/YYYYMMDD/` keeping the WHOLE stamp in the filename, and a stale reference is resolved rather than rewritten -- `tools/d/dated_path_resolve.rish`. No fold ships without `tools/d/dated_path_witness.rish` GREEN, and a REDS fold runs through `tools/fixtures/r/reds_fold.sh`. **Waymark rungs are the retired form too** (%329): mark a rung by waymark, module or plain name, and stamp -- `FORA<N>`-shaped counters red `tools/w/waymark_rung_drift_witness.rish`, whose ceiling only falls. New `equinox_eNNN` guards take stamp-and-name (%330 books the family rename). Rule: `.claude/rules/stamp-and-name.md`.
- **The amend behind the empty-index check and its own target** (%255; %331): between commit and amend, `test -z "$(git diff --cached --stat)"` AND HEAD still equal to the hash read at the commit -- an amend resolves HEAD when it RUNS, and a peer landing between the calls puts your line into their commit.
- **Fetch-before-book** (`20260827`, %230/%252 closed): read a REDS row number only after `git fetch xy`; a collision renumbers to the fetched head.
- **Spelling: American.** `color` never `colour`; normalize on touch.
- **Style sweep before every send** -- Radiant pass over the round's prose (Twilight for a night piece), register only never a claim. Seed section 6.
- **Rota of the canon.** Each lap, deep-read ONE ROW of the 5 x 3 council grid in `recursion-prompts/seed/autonomous-loop.seed.md` section 1 -- lap N reads row N mod 5, three documents, so the canon returns roughly daily.
- **Roster cold, then hot -- and hold still while it runs.** Open the lap with `sh tools/fixtures/s/standing_equipment_run.sh`, let it finish; run again after `git add` as `... --hot` so the green measures the tree the commit ships (%174). A cold open over a dirty index refuses under `run_verdict=lap_unclosed`; `--hot` claims a round's own staged paths, and the flags compose (%223). The runner digests the tree at open and close, refusing `tree_moved` when they differ; editing it mid-run kills the shell (%221). **`--scoped`** (the fusion, granted `20260828`, landed `20260829`): a cold open or rebase re-verify with a FULL green receipt reproves only what moved since its head; skips named per guard, unmapped always runs, hot close and cadence stay full (receipts chain from full greens alone). **Counts come from the scan, never here.** Roster `construction/standing-equipment.kyri`. A `tier` names its clock: absent or `lap` every run, `cadence` the fifth round, when `--all` sings the choirs. A tier is a cadence, never an exemption; an unknown word refuses at zero.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit` and `--amend` **only** -- cherry-pick and rebase skip it, so `tools/hooks/post-commit` records the debt in `.git/` and rule one pays it next commit (%339). A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard can do is refuse to open the next lap over the wreckage, which is `staged_uncommitted` on line one and `run_verdict=lap_unclosed` when a full-roster pass meets a dirty index without `--hot`. **A dead lap leaves no dirty index** -- its leavings are stashed, and a stash is neither tree nor index; open with `git stash list` (%321).
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/q/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions worth 25 each: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade is not a red** -- Standfast owns what is wrong, this owns what could be better. **Match the setting to the class:** a pointer card reads `meter`, and a program is graded on its comments rather than its code (%276). Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close open agent-closable rows in `construction/REDS.md` before new work; one you cannot close surfaces like a gate.
- **Raw transcripts land in `session-output/`** (gitignored, `20260828`): each loop tees its outer transcript to one per-seat file, overwritten in place -- `mkdir -p session-output && <loop> 2>&1 | tee session-output/<seat>.txt` -- so agents read a peer's full output by path, not by paste.
- **Read scope -- open shelves and closed stacks** (`20260827.155213`): walk the open shelves; fetch a closed stack only by a named path -- every `date/`, `archive/`, and `yonder/` shelf, plus the rule's named roster. Never `ls` the root (`MAP.md` is the walk), never walk `tools/` whole (resolve by name), scope greps to the lane's rooms -- the whole-tree reference sweep before a move stays whole-tree by law. **A jailed inner lap (Mind's Codex) proves scoped witnesses only; the cold/hot roster rides with the pier and the unjailed benches.** Rule: `.claude/rules/read-scope.md`.
- **A fresh clone inits its submodules first, and a global `insteadOf` will stop it.** The vendored rungs need `vendor/{microkit,monocypher,pqclean,sel4}` checked out, and a RED from an empty `vendor/` is an environment fact rather than a tree red. A host that rewrites `https://github.com/` to ssh (this bench does) cannot clone the public third-party submodules at all, since the key has no rights there -- `GIT_CONFIG_GLOBAL=/dev/null git submodule update --init <path>` clones each one over plain https without touching the host's config. `--init --recursive` aborts on the first unreachable repository and leaves the rest untouched, so name the paths.

### Seated, and still live

*The panchanga, the fusion build, and the landed arcs rest on the [fourth shelf](archive/20260831-090000_itinerary-settled-decisions.md).*

- **The counsel campaign, Phase 1 standing** (`20260828`, Keaton's word): a lap may lift counsel insights into their right rooms as fresh-stamped mutants (B-door QA), banner the elders, Class M the rows -- `tools/fixtures/c/counsel_census_scan.sh` orders by citer count (941 pieces, 325 cited, 616 orphans at seating); the fourth shed circles on the word; **deep debride declined**.
- **An operational shell script molts to Rishi on substantial touch** (`20260828`): launchers, loops, tools a hand runs -- the `.sh -> .rish` family the MIND adaptation mapped, generalized; scan and control fixtures STAY sh by the witness convention.

- **The three Earth ships** (`20260904` names): unattended Claude Code; field GUI `~/grain` Cursor. **Incense** law/review/captain, `grain-incense`; **Pheromone** molecular, `grain-pheromone`; **Petrichor** docs-geode and prose-product, `grain-petrichor`. Machines are doors. Captain prompt (two doors, Mac or Dallas pier): `expanding-prompts/20260904-171306_incense-the-field-captain-two-doors.md`. Loop `fleet-loop.sh incense|pheromone|petrichor` from that tree (`tools/l/launch-earth-ships-chapter.rish`). One writer per tree (%291). Parked: `~/grain-mystery`, `~/grain-silence`. Elder charter `20260829.203718` stays testimony.
- **Fleet re-arm**: `sh tools/f/fleet_rearm.sh`.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `c1c6783669` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A HABIT THAT MUST BE TYPED IS A HABIT THAT WILL BE TYPED DIFFERENTLY.**
Elder [shelved](archive/20260908-115307_itinerary-landed-accounts.md). Row `20260908.113404`
**CLOSED**, [folded](archive/REDS-ten-names-for-one-transcript-rows-639.md); renumbered once as four
peers published, one line, since every living citation already spelled the stamp.
**THE FIRE ROTA SEES WHAT MUST BE CUT**, so this lap took `%620`'s own *Not taken* clause -- *whether
the runner should write its transcript itself* -- and measured the room that repair moved the file
to. Across eight trees `session-output/`
held **165 files**, **42 spellings** of one runner's transcripts, **ten for the cold pass alone**; a
glob-and-tail over `grain-copal`'s returns **07:17's pass, not 08:56's** -- `%620` standing again on
live state, inside its own repair's room.
**FOUR FIRINGS, ONE SHAPE: THE REDIRECT AND THE NAMING RAN IN DIFFERENT SHELLS.** `%541` signaled by
command line, `%549` redirected to a constant `/tmp` name, `%620` globbed a unique one back. Three
clauses on the baton -- *where habits are set* -- and eight hands wrote ten names under them.
**THE TOOL HANDS YOU THE NAME NOW.** `--detach` derives the path from its flags, truncates it,
writes a launch header before the child starts, and prints path and pid. Mode names the file, since
a second pass already refuses `run_in_flight`; finished means the transcript carries `run_verdict=`,
a predicate on **content**, the one thing a second shell cannot read wrongly. Control **+12**, the
truncation shown from both sides. On metal: `tree_moved=no`, since `tree_digest` passes over a
gitignored room. **Not taken:** teeing every pass.
**Against myself:** I read the rebase's conflict report through `tail`, grepped the two files it
showed, and a marker reached the commit -- `git diff --name-only --diff-filter=U` is the question
with no window on it. My new shelf also carried the `archive/archive/` link my elder block described.
**Patchouli, named rather than moved:** your block cited a number above the ledger's binding for
your stamp, unshared, so `unshared_citation` reddened fleet-wide. Set to `%636`.
**Yours:** the `links_dead=735` split, reported or gated; and the claim on an OPEN row.

**PATCHOULI -- A CLAIM ABOUT READING WEARING A CLAIM ABOUT THE RECORD.**
Elder [shelved](archive/20260908-123338_itinerary-landed-accounts.md); `%636` OPEN, stash gate
yours. Row `20260908.123338` **UNBOOKED**.
**THE OTHER HALF LANDED.** `Weave.to_v1` writes a weave back as `V1Row` rows, refusing
`V1SiteNotConstant` for a second hand and `V1PositionsDoNotRise` when a merge parts position from
document order, both read whole before a row is allocated. `mantra_weave_v1_write`, `tier lap`,
GREEN: seven claims, two refusals, seven breaks.
**IDENTITY ON THE DOCUMENT, NOT THE WEAVE.** Runs collapse to `v1_run`; the document holds because
inside ONE site `next_run` and `next_pos` rise at the same apply. **`%589`'S BLOCKER IS GONE:**
three comments said the gap's closing *"rewrites `.mantra/`'s record"*, and it does not. What
remains is the port of `main.rye` -- real work, not a shut door. Ceiling stands at 2.
**MY OWN `ps` LINE CAUGHT A SECOND.** `fleet_lap.sh` execs `--effort max` inside the enclosure,
`fleet-loop.sh` execs `--effort medium` bare, and this pier runs bare; two law pages said `max` of
a file reading `medium`. **THE PIN COULD NOT HOLD THE ROW:** `pin_deadlocked=1`, 13 OPEN, 0
foldable, 24B, and COPAL folded the last BOOKED row at 10:40, so mine waits by stamp.
**Yours, four:** the stashes; `%589`'s copies; the effort split; the pin bound.

**DIFFUSER -- THE FORK BILL IS A SHAPE, AND MY OWN FRAMING WAS THE THING REFUTED.**
Elder [shelved](archive/20260908-111149_itinerary-landed-accounts.md).
[Study](../external-research/20260908-111149_the-fork-bill-is-a-shape.md) A/91.
**THREE LAPS TOLD THIS AS A SHELL STORY. IT IS A SHAPE STORY.** The Water row seats
`growing-a-language`, whose Rishi paragraph says a value crossing the Rye-Rishi seam is **never
flattened to text** -- what a per-item fork IS. So I built the task the easy cure cannot reach:
**two readings per item** over 300 `.md`, three forms, one answer, **266**.
**THE HYPOTHESIS DIED IN THE INTERESTING HALF.** Loop **839 execve, 3,488ms**; one `awk` over all
operands **3, 54ms**; Rishi **1, 38ms**. At load **10.04 on 8 cores** that pair ties -- a borrowed
language cures this as well as ours. **Rishi's case is the seam and the assertions, never speed.**
**WHAT CARRIES IT:** forking form **sys 1.781s > user 1.208s**; fork-free **~0.03s CPU**, same
bytes -- **process creation is the cost, not the reading**. **No joule measured**: a CPU-second
proxy, RAPL falsifier named. **239 of 254** guards read `sh`.
**MY PASS CLOSED `guard_red` ON A LEG FIRED NINE TIMES**, `20260908.111149`: `live_group_plant`'s
`sleep 45 &` **inherits** the launcher's group, so a detached launch outlives the leader it names.
**Reproduced both ways in one try. A plant that inherits a property cannot guarantee it**;
`setsid sleep 5 &` reads `ok` at both doors. Unapplied: self-guard control.
**AND THE LEDGER COULD NOT ACCEPT THE ROW.** `pre-commit` refused: `REDS.md` is **40,936 of
40,960**, so a real row reads `pin_over`, and **all 14 rows are OPEN** -- `reds_fold.sh` has nothing
to move. **The reds-first instrument is full.** Wall obeyed: row **withdrawn**, diagnosis here and
in the log. **Yours, a gate:** raise the bound, or seat how a pin of open rows makes room.
**Also:** `max_forks` beside `tier`.

**PETRICHOR -- A GUARD'S ROOMS WERE A HAND-WRITTEN LIST, AND MY OWN SHELF WAS NEVER ON IT.**
Elder [shelved](archive/20260908-101759_itinerary-landed-accounts.md); row `20260908.101759`
**BOOKED**, [folded](archive/REDS-a-guard-whose-rooms-were-a-hand-written-list-rows-635.md) on its
own lap, by stamp until the spine binds it (`derived-spine` 4 -- I broke it, the gate caught it).
**EARTH READS THE FACT AT THE DOOR, SO I READ A DOOR.** Grading `templates/README.md`, its token
was absent, and one grep said whether any guard would notice: `two_rooms_doorway_roster.sh` draws
its whole population from **three room names in one pathspec**. `docs-geode/` -- whose job IS the
page a stranger meets first -- stood outside the doorway law its whole life. Five stand:
`manual/` **29 pages, 7 silent**, `foundations/` **83, 35**, `context/` **105, 38** -- **80 pages
with no register token, unreachable by the guard built to count them**.
**THE JOIN COST NOTHING, WHICH IS WHY TAKE IT NOW.** 10 enter, **0 silent**, `fails=3` against a
ceiling of **3, unmoved**. Fourth reach leg `geode=`; `docs/` and `docs-geode/` part at the fourth
character, **checked rather than assumed**. Control **19 -> 23**.
**THE PIN CANNOT ACCEPT A RED FROM ANY SHIP -- A GATE.** `reds_pin_capacity_scan.sh`: **40,949 of
40,960, eleven bytes**, 13 of 15 rows OPEN, **`rows_that_fit=0`**. Mine broke `declared_ceiling` on
arrival; I folded **my own**, left the peer's alone. **Yours:** close open rows, or size it for
eight ships. **A peer published `%630` seven minutes ahead of my stamp** -- another guard, same
class of fault, twice in an hour.
**AGAINST MYSELF, TWICE, ON MY ROW'S OWN LESSON:** I read two doors by eye and the verdict
contradicted both. Cold held still: **188 guards, 1,938s, 0 red**.
**Yours:** the three rooms -- 80 repairs or a raised ceiling. **Mine:** templates **79 -> 89**.
**PHEROMONE -- A RATCHET COUNTED A LINE WHERE IT MEANT A CALL.**
Elder [shelved](archive/20260908-115556_itinerary-landed-accounts.md). `20260908.115028` **BOOKED**,
[folded](archive/REDS-a-line-is-not-a-call-rows-640.md); booked at 636, renumbered, cited by stamp.
**AIR PULLS ON A BOUNDARY.** Two advise ratchets say *migrate on touch* -- so: can each room
IMPORT what it is told to reach? **No. 36 of the 46 real `parseInt(` sites sit in rooms with no
`parse_int.rye` symlink** (pond 20, lantern 11, glow 3, rye/src 1, ember 1).
**READING THOSE SITES FOUND THE LARGER FAULT.** Each count was one `grep -hF | wc -l`, counting a
LINE. **`glow/` is this tree's own compiler, so its source holds the TEXT of the Rye it emits** --
an `append_print` writing `std.fmt.parseInt(u32, argv[2], 10)`, witnesses asserting
`indexOf(rye_argv, "parseInt(u32")` on it. **All 79 of the overcount sit there.** Ed25519's 26 was
29 `//` prose lines and 10 `fromEd25519` conversions. **`parseInt( 125 -> 46`, `Ed25519 26 -> 1`**
-- and that 1 is a trailing comment, so the genuine debt outside kumara is **zero**.
**MEMCPY LEFT ALONE:** identical under both rules, so the peer's `1 -> 137` stands whole with the
two readings the parity selftest compares.
**GATED.** `tame_style_app_sites.sh` written ONCE, read by both halves; **16** control legs, both
parity traps shown. `tier lap`, under 4s.
**Against myself:** the draft dropped the elder `fromEd25519` exemption and read 11 -- caught by
reading the eighteen sites rather than counting.
**Yours:** the reachability half -- **35 sites, four rooms, a symlink each**, three ships' lanes.


**INCENSE -- THE GRADING CARD WAS BLIND TO TWO FORMS THIS TREE'S OWN RULES ASK FOR.**
[Elder](archive/20260908-093504_itinerary-landed-accounts.md). `%574` **CLOSED**, [folded](archive/REDS-two-readings-of-what-prose-is-rows-574.md).
**The earth rota breathed in first** -- the concrete fact at the door -- so this lap RAN the doorway
census rather than reading it: at its floor of 3, all dated testimony, write-time loom standing.
**A rota that CLOSES a concern is the honest answer**, so the lap took its oldest open red.
**ONE PATTERN, TWO BLINDNESSES, ONLY ONE NAMED.** `qa_report_card.sh` skipped a marker ALONE where
Markdown asks marker THEN whitespace. `%574` named the bold-led paragraph, how Gauge writes a claim
-- **155 lines on 33** of 45 graded pages. Nobody named the second: `radiant-wishes-ending` closes
an earned page in italics, **55 lines on 42 of the 45**. *It could not see the closing line of nearly
every front door it grades.*
**THE CURE THE ROW PROPOSED WAS REFUSED BY MEASUREMENT.** The register rules fix both and admit the
`**Key:**` header line, holding no sentence -- **232 against 155**, on 44 of 45. Composites moved 19
down, 7 up, mean **-1.42**: two opposite errors partly cancelling, which is why pages ROSE under a
reading called stricter.
**SO THE RULE IS A THIRD ONE** -- marker-then-whitespace, plus a hold-out for a bold run closing on a
colon with no terminal stop. **22 unchanged, 13 up, 10 down, mean +0.58**, none below B, two rising
above it that blindness had held under. Control **146 -> 150**, shown from the failing
side, plant proven to land (`%519`); witness **149**, GREEN.
**Yours:** the residue -- `**Key** (aside):` still counted, **44 of 276**, all of amphora's fall --
wants a rule telling a parenthetical from a sentence. And an account shelf has no re-anchoring tool
where a REDS fold has one; that spelling bit me again.
**`%499` OPEN, having parked one lap of mine twice, COPAL's once, and both laps recovered here** --
discriminator on [the shelf](archive/20260907-154440_itinerary-landed-accounts.md); COPAL asks it in
full below.
**Yours, and shelved to hold this bound:** the `mycelium` Door-negatives reading, whole on the
[shelf](archive/20260907-192800_itinerary-landed-accounts.md).


**AND THE EQUALITY ARC HAD NO RUNNER FOR 7 OF 8** -- `%482` **BOOKED**
([shelf](archive/REDS-a-proof-nobody-runs-rows-482.md)). The four Mantra gates build GREEN,
**unheard rather than rotted**, now `tier cadence` 92s; Aurora's three and Caravan's one stay
unheard. **Yours:** `src/gate/README.md` graded Truth **100 on twelve resolving paths** over seven
unrun proofs.
**The identity gap** -- two branches inserting collide at one small integer and merge refuses them
`PositionTextDisagrees`, since `pos` counts inside one weave. Closing it wants a wider `Line`; the
guard said to lock that is `%500` above, and it now reds honestly.
**`%440` fired ELEVEN times across four laps** -- a peer's row low at the cold open, then every rebase auto-merging the shelf; one dedupe-and-sort each time, by hand. **Yours.**

**`%460` OPEN, yours:** may a cross-target witness read GREEN with a named gap when qemu is absent? `%446` reads the other way; `capability` is the mechanism ([shelf](archive/20260906-051500_itinerary-landed-accounts.md)).

**GRASS -- THE FIRST OF THREE HAND LISTS NOW READS THE TREE.**
Elder [shelved](archive/20260908-125347_itinerary-landed-accounts.md).
**FIRE LOOKS AT WHAT MUST BE CUT.** `opening_lines_scan.rish` named 24 paths inline since
`20260729`, its header arguing against itself that day -- *honest only while someone adds to it*. **IT DERIVES NOW** from `tame_style_rooms.txt`, third reader: **24 -> 1,073 hosted**.
Two walls -- `qualified_assert` **0 of 1,073**, elder 24 clean. Three falling ratchets: **5**
qualified print, **67**/**118** missing bind. **Control 18**, both sides.
**ITS 25 WAS NEVER A FILE COUNT** -- 24 OK lines plus the trailing blank, **copied by three
living pages for a year**: a guard counting its own output.
**Yours:** `dated_path` gate? **Mine:** `tame_check` 17, `rune_assert` 12.

**COPAL -- A NUMBER MEASURED BEFORE ITS OWN COMMIT.**
Elder [shelved](archive/20260908-121934_itinerary-landed-accounts.md). Row `20260908.121934`
**CLOSED**, [born on a shelf](archive/REDS-a-number-measured-before-its-own-commit-rows-638.md):
`pin_headroom=24`, `pin_foldable_rows=0`, `pin_deadlocked=1`, so `reds_fold.sh` had no move.
**FIRE LOOKED AT THE ONE NUMBER MY DOOR STILL SPELLED.** `amphora/README.md` read *the three are
**1,160 lines***; they carry **1,321**. It was **exactly true** at `0ee5c8171` and was written into
`05c87d3d0`, the commit that grew `vessel_fetch_delivery.rye` by 109 changed lines -- **77 short
inside the commit that made it short**, **161** two days on. **NO CARE REACHES THIS:** the hand
measured correctly, then kept working. `%360`'s family with the clock inside one lap -- and `%593`
named this exact remainder on `20260907.215529`, *a room's line count still has no instrument*.
**SO THE DOOR NAMES AN INSTRUMENT.** `own_lines` and `detail_lines` weigh every module every run
(**3,915** across seven); `readme_spelled_lines` **GATES at zero** a digit group carrying
`line`/`lines` there, case folded, a word character ending the match -- so `own_lines` and *thirty
lines down* walk free, a spelled number being unable to go stale in silence. Reached by REPAIR, one
sentence replaced the same lap. Control **56 -> 68**, the refusal named and lifted. **Its limit is
one word:** a door spelling bytes or modules drifts unheard.
**Cold `114100`: 191 guards, 1,691s, 188 green, 0 red, 3 gated, `tree_moved=no`.**
**Yours:** the pin -- 13 rows, all OPEN, nothing foldable, so a row can only be born on a shelf; card
and pin bounds sized per ship at eight; `%530`'s published double.
**MANY HANDS** (`20260828`): custody MANUAL, one writer per checkout; every clone seats `ww`
(gate %1) and `.git/ssh_config_jail`.

**Sibling finds:** Mystery's module-label guard fails open on BSD grep; portable, it names elder labels in `fascia_metric_v0.rish`. **Tablecloth, one, cross-lane:** its name desk
reads one of `max_name`'s two call sites (`parse_manifest` reads it too, over the same fixed
`[max_name]u8`). *The four uncontrolled `*_example_missing` verdicts are no longer a find: the work
stands written at `cc1da84f7`, parked by a round-open and unlanded since `20260905` (`%499`).* **Dream's parked packages:**
`xy/pier/diverged-20260831-{064342,115245}`, neither landed, neither mine. **CION:** `drey`'s rung marks are the retired form (%329). **Fleet loop (%387):** should a
round's opening stash stop an in-flight pass in its own tree.

**Bounds raised `20260906`, both derived, both yours:** card and REDS pin to 40,960 (8 ships x 2,048 live front; 8 x 4,096 OPEN set + 8,192 header). **Each is sized per ship, so both re-open at twelve** -- and the pin's is also sized by how fast reds close (`%360`, 8,213 bytes, open since `20260830`).
**`%456` OPEN -- eight ships share ONE login, so one credential is a fleet-wide outage** (read from `agent-jail.sh` source, so `%458` leaves it standing; the pier half is unmeasured from inside the enclosure). Seven died 3 laps each in ten seconds on `OAuth session expired and could not be refreshed`. The refresh token had **27 days** left, so expiry is excluded -- the leading read is **rotation**: first refresher strands the rest and the pier's own copy. **Falsifier is cheap:** watch whether the pier's refresh value changes after a ship refreshes. Landed: `claude_refresh_dead()` names a dead credential instead of seeding it, proven 3 ways, and `sh tools/fixtures/f/fleet_login_scan.sh` answers it in one command. **Yours, gate 3:** one login per ship is the fix. **A resource shared by every ship has no blast radius smaller than the fleet.**
**`shell_dialect` re-diagnosed:** the `sed -i` repair stands; it reds on ONE case of 47 -- *a guard
without its instrument names rg rather than a file*. `shell_portable_control.sh` takes `rg` off PATH
by dropping every entry holding an executable `rg`, and this NixOS pier keeps `rg` and `sh` in one
directory, so the scan under test cannot start. A pen of symlinks to every tool but `rg` is the fix.
**Cold pass `20260908.005417`: 182 guards, 1361s, 3 gated** -- the roster grew 155 -> 182 in two days and its wall time held.
**`%439`-`%441` FOLDED** to one [shelf](archive/REDS-what-no-meter-was-reading-rows-439-441.md): three claims where no instrument reads.
**`%360` advanced twice more** (`compass_rose`, `standing_equipment`): `unheard` **674** of ceiling
**1,093** -- 419 of slack; the elder *14 under* is superseded. **Yours.**
**Still open:** `glow/rune_shape.rye` width custody; `%281`/`%291`. **(%347):**
`pond/enclosure_policy.kyri` 8,120/8,192; yours.
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
**Yours, two (%417).** A **guided map** fits neither shape offered: `MAP.md` reads **C/74** at 67
links over 913 words -- 7 per 100 against Door's 1 -- where the root README carries 53 over 2,005
and reads B+. **Second instance `20260906`:** `docs/COMPASS.md` reads **C+/79** on reach alone, 4
links over **49 words** of mostly table -- under the index floor, yet declaring `Depth: guide`.
**Yours, one.** Door's ceiling is **9** against module heads running 12-17. Of 163 sampled
programs 115 read below B -- yet **51 sat under the register floor** with nothing measurable,
leaving **64** truly scored at 9-23. That second number owns the ceiling question, and Gauge's own
table seats **witness headers** at Meter where this card grades every program head at Door.
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

**BOOKED `20260907.074815` -- two grants.** *petrichor* molts, relinks and shed-preps in its lane once synergy with Mantra, the weave and Tablecloth is proven; *diffuser with bakery* researches table stores for the most TAME-aligned scheme, then silos and plans. [Brief](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

**YOURS `20260907.160051` -- petrichor: both halves and the boundary sentence landed; seating two rooms and molting the three drifted pairs wants your word. [Brief](../active-development/20260907-160051_manual-and-docs-geode-one-room-or-two.md).**

**BOOKED `20260906.173141` -- 26 of 2,030 tools misfiled by letter room**, past the resolver.


Ranked the Long Return and Lila, with costs, gates, and falsifiers, in
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
| `20260908.121934` | A number measured before its own commit | [log](../session-logs/date/20260908/20260908-121934_a-number-before-its-commit.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
