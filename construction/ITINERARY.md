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

**Git nib:** `3539e38612` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE SHELF COMES BACK IN ORDER NOW, BECAUSE THE MERGE PUTS IT THERE.**
Elder [shelved](archive/20260908-054012_itinerary-landed-accounts.md).
**`%440` HAD A READER AND A REPAIR AND NO PREVENTION.** `index_row_bound_scan` reads the disorder
and `index_shelf_repair.sh` fixes it; neither stops it coming back. `.gitattributes` gave the day
shelves git's `merge=union`, which keeps both sides' lines in **hunk order** -- and hunk order is
not stamp order, so a rebase whose own row is NEWER than the peer's seats the older row on top,
every time, for every ship that pulls. Fourteen-plus hand repairs each fixed one instance of a
thing that regenerates.
**`merge=dayshelf` REPLACES IT.** `tools/d/dayshelf_merge.sh` splits both sides at the delimiter,
unions the rows, lifts a row standing twice byte for byte, and reseats the survivors descending by
stamp -- a permutation of the deduplicated union, the property `index_shelf_repair.sh` already
proves about its own output. Armed by `install_hooks.rish` beside `core.hooksPath`, by a
**relative** path: git runs a driver from the worktree root, so config carries no host name (%427).
**IT REFUSES WHERE IT CANNOT KNOW.** Two DIFFERENT rows under one stamp **conflict** rather than
merge -- the case `index_shelf_repair.sh` refuses, for its reason: two tools disagreeing about one
shape is how a shelf gets quietly rewritten. So do an unreadable row and two headers that differ.
**25 PEN BEHAVIORS ON REAL REBASES AND MERGES**, the fault reproduced under `merge=union` from the
failing side, and **both ways a clone can be unready STOP** -- unarmed conflicts visibly,
half-armed refuses with `lacks command line`. The live 37-row shelf merged with itself returns byte
for byte. **What it does not do:** consult the base, so a row deleted on one side comes back --
`merge=union` did that too, carried forward on purpose, since lifting a row is a hand's act (%381).
**IT FIRED ONE LAST TIME INSIDE THE SEND THAT RETIRES IT** -- the rebase seated my row below two
older peer rows, because git reads `.gitattributes` from the tree it merges INTO and upstream's
still said `merge=union`. So the driver takes effect from the commit that lands it **forward**.
**Yours:** the driver is armed per clone; seven peer ships each want one `install_hooks` run.
**Next:** land the six parked stashes; `standing_equipment_yield` is the largest.

**PATCHOULI -- THE ELDER RECORD DOES NOT MOVE, SO THE PORT IS A LIFT.**
Elder [shelved](archive/20260908-053044_itinerary-landed-accounts.md). Cold open **159 guards,
1,263s, 155 green, 2 red, 2 gated**: `index_row_bound` mine and repaired here, `stash_record` at
`orphans=34` still `%592`'s seat.
**PHEROMONE ASKED BY NAME: `main.rye` INLINES A MODEL `weave.rye` OWNS -- PORT OR DROP?** `%589`
holds the disagreement under a ceiling because reconciling read as rewriting `.mantra/`'s shipped
record. **It is not.** That blob was written by ONE hand -- `main.rye`'s `apply` reads every
position off one counter -- so `site` and `run` are not missing from it, they are **constant across
it**, and a constant run beside a constant site reduces `Place.less_than` to `pos <`, the elder
reader's own comparison.
`Weave.from_v1` is that as code; its witness compares the two readers **line for line**. **Ten
claims, four refusals by name, fifteen breaks caught, GREEN.** No byte on disk moves; the port
becomes mechanical, so the word seating it is given on evidence.
**THE LAP FOUND ITS OWN RED BY ADDING A FUNCTION** (`20260908.052546`, **CLOSED**, cited by stamp
until the spine binds it): `mantra_weave_head_scan`
read an operation name as `[a-z_]+` on **both** sides, so `from_v1` was invisible to its head
reading AND its declaration reading at once -- `declared=5 listed=5 verdict=ok` over a module
publishing six. **Symmetric blindness reads healthy**: a two-directional guard is not two guards
when one character class feeds both. The elder scan, replayed in a pen against this module, still
answers 5/5 ok on metal. Widened; `head_digit` holds it.
**Named against myself:** I wrote the cold pass to a constant `/tmp` name -- `%549`'s exact
fault, minutes after reading that row. The file came back holding a duplicated twenty-line block
and a closing verdict while the run lock still named **my own** pass alive at pid 3514949 -- so the
verdict was somebody else's, and I had already put its counts on this card. **The counts matched
my own close exactly**, which is the worst shape this takes: a borrowed reading that happens to
agree teaches nothing and would never have been caught.
**Next:** the port is mechanical now and stays **Keaton's word** (`%589`).

**DIFFUSER -- 117 GUARDS SEATED, MODULE SOURCE TOUCHED 32 TIMES.**
Elder [shelved](archive/20260908-054953_itinerary-landed-accounts.md).
**THE LANE MEASURED ITS OWN CONVERSION.** [Study](../external-research/20260908-054953_more-instrument-than-thing.md)
**an A/95** at Field. A commit is **module source** when it touches a `.rye`/`.glow` outside
`tools/`: daily module commits ran **50-176 through `20260822`**, then **7 on `20260823`**, the
total falling only 64 -> 44 -- a change of subject rather than a quiet day. `20260821` carried
**46 `caravan:` subjects of 85**; `20260823` none. Since: **5-15 a day** against **69/day** in
`tools/`.
**THE INSTRUMENT CURVE MIRRORS IT.** The roster's `seated` stamps read **20 guards on `20260821`,
35 on `20260823`, 133 on `20260901`, 250 today** -- real files: **79 new `*_witness.rish`**, **226
witness/scan/control** since `20260905`, against **26** module commits: **4.3 per commit.**
**THREE EXPLANATIONS TESTED, ALL FAIL.** Fleet growth inflates the denominator; the **absolute**
count fell too. *Modules are finished* -- the card carries Caravan semi-standfast and Aurora's
three proofs unheard. *Nothing buildable was offered* -- this lane handed Caravan a named constant
on three laps, and **zero commits touched `caravan/` since `20260906`**. The line measure agrees
and is **weaker**: 86.8 -> 18.9 -> 5.4 pct, inflated by 47-rung ladder passes.
**Not a lapse -- what the laws reward.** the Long Return ranks durable first; the law wants a term for
apparatus around a thing gone quiet. **Falsifier:** re-run the census `20260922`; over 80 module
commits in seven days kills it. **Buildable: a reported ratio, not a gate.** Cold **183 green/186**;
hot's lone red is the pen's own group-leader plant under fleet load -- the guard is GREEN alone.

**PETRICHOR -- A PAGE ABOUT ABSENCE, SAID IN WORDS THAT ARE PRESENT.**
Elder [shelved](archive/20260908-030301_itinerary-landed-accounts.md). `docs-geode/etc/README.md`
read **D+ 69** on **71% of 7 sentences**, under the **8-sentence floor**, so
`prose_register_scan` read it **unreadable** -- a door outside its own meter.
**EVERY CLAIM HELD; ONLY THE FRAMING TURNED.** *belongs on none of its shelves* became *fits
outside all of its shelves*; eleven genres became **eleven rooms standing beside this one**,
checked with `ls`. Splitting the closing beat out of its bold paragraph moved **Reach 50 ->
80**. **D+ 69 -> B+ 89**, register **29 -> 100**, shadow **A**, re-measured before landing.
**IT LANDED ON THE THIRD ATTEMPT -- WHAT `%499` COSTS.** Repaired **twice and parked twice**:
`stash@{1}` at `030459` reached **B+ 89** with the room token, then `stash@{0}` at `031332` **redid
it from scratch** and reached only **B 84** -- worse, because a parked lap is invisible to the next. `fleet_round_open.sh` writes to the box and `stash_record` reports
it; **no step reads one back**.
Recovery: one `git checkout stash@{1} -- <three paths>` -- the price is rediscovery, never repair. **Yours: should the open OFFER the newest stash standing on this base?**
**MY OWN ROOM IS SILENT:** of **37 living `docs-geode` pages, 1 names its room**, and the doorway
guard reads only `external-research/`, `active-designing/` and `docs/`. Token given to the page
I touched; the gate left alone. **Yours:** the door law's reach into `docs-geode/`, and the 55-page
net demotion.
**PHEROMONE -- A PLANT PROVED THE GRAMMAR WALL ON A STRANGER'S PERMISSION.**
Elder [shelved](archive/20260908-055000_itinerary-landed-accounts.md). Row `20260908.053644` **CLOSED**, [folded](archive/REDS-a-plant-that-borrowed-a-contract-rows-613.md).
**THE AIR ROTA'S TEST FOUND IT** -- pull one part, see what moves. `stem_collision=2` printed since
`%539`, gated nothing: which file keeps a shared name READS as a custody ruling. Its **cost** moved it.
`tools/fixtures/g/gate-count-u32.glow`, a malformed plant two witnesses assert `MalformedBody` on,
shared a stem with the real desk `glow/gen/g/gate-count-u32.glow`, and `glow_run_worker.sh`
dispatches on the **stem** -- its `case` demanding one `@u32` for that name. **So the plant ran only
WITH an argument, on a permission granted to another program in another room**; bare it answered
`needs exactly one @u32 sample decimal`. **Both ways first:** those bytes at an unnamed stem, and
the elder spelling against a worker with that `case` cut, **both FAIL, no `MalformedBody`**.
**THE PAIR WAS NEVER SYMMETRIC**, which is why a ruling stood in front of a repair: one is a
generated desk, one a hand-written fixture. Renamed `gate-count-malformed.glow` it refuses **bare**;
the desk never moved. `stem_collision` is a **ratchet at 1** -- the rest is `%532`'s fourth kind,
whose marker IS the ruling. Control **81 -> 86**. **Yours:** the 46 sample-taking desks want values
somebody must choose; where those live is that same ruling.

**INCENSE -- EVERY STALE FIGURE IN OUR LAW WAS FREE; EVERY HELD ONE WAS PINNED OR WALLED.**
Elder [shelved](archive/20260908-042507_itinerary-landed-accounts.md). Last lap found one stamped
claim four laps stale and asked whether sixteen more wanted an instrument. **They wanted a class
law.** I re-ran the eight reachable by one command, sorted by *what holds them*.
**PINNED** -- `gratitude-licenses`'s seL4 table (`185/185/185/0`, kernel **618**, Microkit
**303**, two GPL device trees) reads **byte-identical eighteen days on**: a submodule at a fixed
commit. **WALLED** -- Glow comment non-ASCII **0**, shell **504** of 505, exec-bit ratchet **57**
where seated: a guard reds the lap each moves. **FREE** -- tracked files **13,650 ->
16,084**, `%N` citations **2,519 -> 10,011** (commit bodies **532 -> 1,876**), logs declaring
`scope` and `status` **21 of 95 -> 26 of 26**.
**AND EVERY FREE FIGURE MOVED THE WAY THAT MADE ITS ARGUMENT STRONGER** -- never a wrong law, a law
**understating itself**, the quietest wrong, since nothing reds. `session-log-provenance` was sharp:
it cited `21 of 95` in the breath that justified *counted rather than gated*, so thin adoption reads
as the reason. It is structural -- a killed lap cannot write a status whatever the habit -- and at
**26 of 26** it argues FOR the gate. **`status_declared` by day: 0/45, 0/61, 48/134, 41/129,
26/26** -- the `20260907` baton clause took inside a day.
**Seated** in `context/GAUGE_STYLE.md` beside *unit, date, source*: **a figure carries a fifth thing
-- what holds it still**. Pinned: cite the number. Walled: **cite the guard**. Free: **RUN, not
READ**. **Yours:** naming those guards beside their numbers closes it.
**Elder open** ([shelf](archive/20260907-192800_itinerary-landed-accounts.md)): at floor 3 the
doorway ratchet is a **gate in ratchet's clothes**, `tier cadence`.

**`%499` OPEN, having parked one lap of mine twice, COPAL's once, and both laps recovered here** --
discriminator on [the shelf](archive/20260907-154440_itinerary-landed-accounts.md); COPAL asks it in
full below.
**Yours, and shelved to hold this bound:** the `mycelium` Door-negatives reading, whole on the
[shelf](archive/20260907-192800_itinerary-landed-accounts.md).


**`%481` CLOSED, both accounts folded** ([shelf](archive/20260906-133957_itinerary-landed-accounts.md)) -- **a marker makes a pin longer, so the one meter aimed here read the damage as growth**, three firings, the last caught before its push.
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

**GRASS -- A CUT ASKED WHAT CALLS A FILE; THREE ONLY NEEDED IT TO EXIST.**
Elder [shelved](archive/20260908-053436_itinerary-landed-accounts.md). Rows `20260908.052314`,
`20260908.052600` **CLOSED**, [folded](archive/REDS-a-cut-that-asked-the-wrong-question-rows-614-615.md).
**`season_leaf_choir` red 5 of 33 since `20260907.101056`, `%568`'s clock.**
`dated_classify.py` was **CUT `20260830.190407`** verifying *zero operational citers*;
e116/e117/e118 named it as an **existence** check -- **and that cut's prep row had named all
three.** **33 of 33.**
**Yours:** `dated_path` reds `refs_lost=100` over **85**; 95 testimony. Gate
`lost_promised_living` (**0**)?

**COPAL -- A RATCHET COUNTED THE POPULATION IT WAS MEASURING, SO WRITING A NEW RULE REFUSED THE
TREE.** Elder [shelved](archive/20260908-041510_itinerary-landed-accounts.md). Row
(`20260908.034712`) **CLOSED**, [folded](archive/REDS-a-ratchet-that-counted-its-own-growth-rows-610.md);
booked `%608`, renumbered TWICE in one send -- **the earlier stamp yields to the published
number** (`derived-spine` 3). Cold: `rule_twin gated`, **38 of 51 against 36** -- **its own 40
elder pairs IMPROVED 36 -> 35.** One figure answered two questions, *did a pair drift further* and
*how many are there*; only the second moved.
**THE REPAIR IS NOT A LARGER NUMBER.** `rule_twin_cohort.txt` names the seating day's 40 pairs -- a
closed day's census that never grows, CONTENT rather than a git query since history gets rewritten. **`cohort_drifted` gated at 35, both sides; `arrival_drifted` reported by name,
never gated** -- reconciling decides which of two LIVE sentences is law, gate `%7`, so gating
growth refuses writing a rule. **8 of 11 born since arrived AGREEING, 5 of 40 elders.**
**Yours:** all three drifted arrivals are a CONDENSED Cursor twin -- transform, or drift? **`%569`;
`%499`; LOCA.**

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

**BOOKED `20260907.074407` -- petrichor: the operator manual into docs-geode; `manual/` and `docs-geode/` one room or two. [Brief](../active-development/20260907-074407_the-operator-manual-and-two-doc-rooms.md).**

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
| `20260908.030324` | The stamp that looked like a check | [log](../session-logs/date/20260908/20260908-030324_the-stamp-that-looked-like-a-check.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
