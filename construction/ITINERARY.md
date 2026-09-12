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
- **Roster cold, then hot -- and hold still while it runs.** Open the lap with `sh tools/fixtures/s/standing_equipment_run.sh`, let it finish; run again after `git add` as `... --hot` so the green measures the tree the commit ships (%174). A cold open over a dirty index refuses under `run_verdict=lap_unclosed`; `--hot` claims a round's own staged paths, and the flags compose (%223). The runner digests the tree at open and close, refusing `tree_moved` when they differ (%221). **`--scoped`** (the fusion, granted `20260828`, landed `20260829`): a cold open or rebase re-verify with a FULL green receipt reproves only what moved since its head; skips named per guard, unmapped always runs, hot close and cadence stay full (receipts chain from full greens alone). **Counts come from the scan, never here.** Roster `construction/standing-equipment.kyri`. A `tier` names its clock: absent or `lap` every run, `cadence` the slower one -- turned by **`--cadence-slice N`** off the run card, and it read **74 of 74 never run here** (`20260910.233112`); default 0. A tier is a cadence rather than an exemption, and an unknown word refuses at zero.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit` and `--amend` **only** -- cherry-pick and rebase skip it, so `tools/hooks/post-commit` records the debt in `.git/` and rule one pays it next commit (%339). A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard CAN do is refuse to open the next lap over the wreckage -- `staged_uncommitted` on line one, and `run_verdict=lap_unclosed` when a full pass meets a dirty index without `--hot`. **A dead lap leaves no dirty index**: its leavings are stashed, and a stash is neither tree nor index, so open with `git stash list` (%321).
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/q/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions worth 25 each: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade stays lighter than a red** -- Standfast owns what is wrong, this owns what could be better. A pointer card reads `meter`, and a program is graded on its comments (%276). Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close open agent-closable rows in `construction/REDS.md` before new work; one you cannot close surfaces like a gate. **Capacity comes from the instrument, never from this card** -- a full pin with one foldable row is one `reds_fold.sh` from headroom, and a card sentence spelling that state is held to `reds_pin_capacity`'s own reading by `tools/ca/card_pin_claim_witness.rish` (stamp `20260911.034352`).
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
- **INCENSE -- WORK IN PROGRESS, `20260910.070937`.** Landed: eight Bhakta lessons in `docs-geode/lessons/` (95-97); two vortex press pages carrying the **Buckmaster and Alpoge** priority record at the door; twelve single-stranded moonshots; the tally-infuse spell; and the first two moonshot witnesses, `wrap_ring` and `cyclic_witness`. **OPEN:** (1) equinox choir census **70 green, 12 red** against a ceiling of **10**, deliberately not raised; (2) the pin's capacity is `reds_pin_capacity`'s to publish rather than this card's to spell, and a bound raise is yours when that reading leaves a lap nothing to fold; (3) five dated equinox guards pin counts of a growing surface; (4) ten moonshots remain, ranked on their own page. **Corrected:** `glow_desk_run` is NOT hung -- 455s, exit 0 -- and the verdict word is `over_bound`, since a timeout is a claim about the bound as much as the run.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `b234288f1e` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE BOX WAS READ, THEN COUNTED, AND NEVER NAMED.** Elder
[shelved](archive/20260911-225721_itinerary-landed-accounts.md). **AIR FEELS** (row 1, N=4666):
single-stranded -- one line answering two questions.
**THE READING.** `fleet_round_open.sh` has read the dead-letter box since `%464` and split its
kinds since `%592`. Both answer *is something in the box*; neither answers *is it mine*, and
recognition runs on names. A peer read `git stash list` on `20260911`, saw its census counted, judged
the box not worth a `list`, and rebuilt **747 lines** the stash held finished for **15s**. **HERE TOO:** 19 stashes, 9 orphans, **5 parked work** -- a whole
`standing_equipment_yield` triple in `stash@{10}` since `20260907`.
**LANDED.** The open names each `orphan:work` path beside its stash, `work` alone. **One
invocation:** `list` emits the rows AND the same counters, so every standing grep reads what it
read and the naming costs no second scan -- **2.3s against 3.1s**. Bounded at **8**, proven both
ways: 12 parked, 8 named, **4 more** exact.
**AND THE WITNESS HEARD HALF ITS PEN.** `fail=0` is what an empty pen prints too. The control counts
its legs out loud, `legs_expected=41`; the witness asserts both meet -- deleting a leg reds it.
**41 legs**, GREEN, B/B/A. Hot **271/268/1**, `tree_moved=no`; the red is `%626`'s
`dated_path`, **110/85**, **105 testimony**, unmoved here. **NO ROW:** `pin_deadlocked=1`.
**YOURS:** (1) carried -- a `gate` word for a LEDGER-parked red; (2) `stash@{10}` holds a finished
guard triple; may a lap land a dead lap's parked work?
**PATCHOULI -- THE DOUBLE-CLAIMED NUMBER WAS NEVER THE ROSTER'S REAL COLLISION.**
Elder [shelved](archive/20260911-204217_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, N=4661, hand-advanced to today's least-read): the fact at the door.
**REDS FIRST:** cold **267 run, 0 red**; `%680` and `%689` are mantra seams wanting your word. My
own hot pass then reddened `shell_dialect` on a `sed -i` in the pen I had just written -- GNU-only,
repaired to a through-write that also keeps the mode, re-proven, and re-run whole.
**THE READING.** Of the three doubles -- 38495, 38496, 38497 -- **only one side of one pair is
rostered**, and that one only *compiles* its module. So a roster pass never runs both claimants of
any double. What it runs is **one guard, on eight checkouts, against one machine**, which a census
counting modules per number reads as zero.
**BUILD AND RUN ARE TWO FACTS WEARING ONE WORD.** Five rostered guards build a binder and **four
run it**; `amphora_mark_wreck` compiles `vessel_fetch_delivery` to prove it compiles and never runs
it. My own handoff last lap called it a runner.
**THE CROSSING, JOINING BAKERY'S SEVERITY PAPER TO MINE.** Unlocked with no `SO_REUSEADDR` the
kernel refuses the second bind -- **loud**, a re-run, a RATCHET at **4**. Unlocked WITH it, both
bind and the kernel splits the datagrams -- **silent**, the fortnight `%700` paid, a **WALL at
zero**.
**LANDED (`204217`):** `port_runner_lock` scan, pen, witness, rostered `tier lap`, 8s. **38 legs,
two mutations bitten.** Both faults were mine and both are `%717`'s lesson inside the instrument
built for `%717`: Rishi spells a reference `${bin}` and bare `bin`, and reading one spelling called
a locked runner a non-runner; and `constel/bin/socket.out` swallowed `constel/bin/socket` until the
target had to end at a boundary.
[Paper](../active-designing/20260911-204217_the-guard-that-meets-itself.md) A 91.
**YOURS:** the four open runs are **comlink** and **constel** -- a lock or bind-to-zero, each
lane's choice; `fora_socket:82` races two binds ON PURPOSE, so a lock rather than a port. And
`ip_local_reserved_ports` is still **EMPTY**, one `nixos/` line, still yours.
**DIFFUSER -- I REBUILT A CENSUS THE STASH ALREADY HELD, FINISHED, FOR AN HOUR.**
Elder [shelved](archive/20260911-210649_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4658): taste what is in the box before cooking a second pot.
**THE OPEN CLAIM QUESTION, FOURTH FIRING TODAY, AND THE PEER WAS ME.** I read row 4 (*aether as
falloff field*), measured the roster's wake set off `scope_rank`, and reached the row's own verdict
independently -- the woken set covers the roster, cause **absence rather than density**. My previous
lap had built it whole: **747 lines**, scan, control, witness, paper, roster seat, stashed at the
round open **15 seconds** before this lap began. I read `git stash list` and never opened it.
**RECOVERED, NOT REBUILT.** `aether_falloff` GREEN, **38 legs**, anchor rule mutated and bitten.
`r0` woken share **0.888**, saturation **two hops**, floor **291 of 348**. My own reading was a
subset of its r0 column, so I **dropped it whole**.
**A ROW BOOKED (`20260911.205727`), AND THE GHOST THAT CAUGHT IT.** `standing_equipment` red on `unrostered:
aether_falloff` -- the dead lap's pass wrote a card row for a guard whose roster seat the round-open
then stashed, and the untracked card carried it forward every pass. **`stash@{13}` has held
`topology_routed`, witness and two fixtures, since `20260906.190715` -- five days** --
and `stash_record_scan.sh list` names all three `orphan:work` under `verdict=ok`. No round open
reads it. Folded `%717`; pin **40,460/40,960**.
**YOURS:** (1) a round-open reader printing `orphans_work` by name is one lap. (2) recover
`stash@{13}`. (3) whether `|-  0` should parse (carried).
**PETRICHOR -- A REPORTED POPULATION PRINTED ITS SIZE AND NEVER ITS NAMES.**
Elder [shelved](archive/20260911-212157_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, N=4659). Cold **264 green, 0 red**.
**THE READING:** `tutorial_output_scan.sh` REPORTS two populations rather than gating them, each on
its header's promise they stay **visible** -- and a lap read `undeclared_after_prose=4`, `held=3`:
**seven pages, the totals alone.** The names went to a `list` verb whose **two callers neither run**. A bare count is visible the way a locked door is. **Not a red:** the verb
is documented. **Read one by one:** all four are honest reattributions.
**A FOURTH SHAPE, DECLINED:** output as a `#` comment in the fence -- **39 over 80 pages, 22
living, SIX claims**, five off the roster. Two awk lines name each; pen **55 -> 58**.
[Paper](../active-designing/20260911-212157_the-count-that-stood-where-a-name-belonged.md) A 95.
**YOURS: `%714`'s remainder, measured.** *Line length <= 100* stands under **Enforced now** while
**101,591 of 884,752 lines** run past it -- **11.5%**, **3,933 of 4,476** sources, **Rye 8.9%, Rishi
27.0%**. A wall is impossible; the doors are retirement or an honest head.
**PHEROMONE -- THREE BINDINGS HELD THE RUNE TABLE AND NONE ASKED WHETHER A RUNE WAS TAUGHT.**
Elder [shelved](archive/20260911-202958_itinerary-landed-accounts.md). **FIRE SEES** (row 2,
N=4657). **REDS FIRST, NOTHING MINE:** cold **266 run, 264 green, 0 red**, 2 gated at `%5`.
**THE READING.** `match_rune2` accepts **30** heads. `glow_rune_alphabet` has held that derived
population against three documents since `20260909.155028` -- pronunciation roll, three G1 briefs,
TAME family index -- and **every one asks for a NAME**, so a named rune answers all three and *can
a reader learn it* went unasked. `active-designing/docs/glow/runes.md` taught **27 of 30**.
**`|+` BARLUS, UNTAUGHT TWENTY DAYS:** named `20260822`, 28th pronunciation row, parsed at
`rune_shop_gate.rye:parse_body`, laws STOA332-336, folded by **seven** `src/gate/` sources -- named
on **no page of the Book**. `?&`/`?|` keep the exemption they hold one binding over, same cause: an
entry leads with its spoken name, so one custody question holds both pages.
**MECHANISM:** a fourth loop over the same derived heads asking whether the page writes the glyph
backticked; `book_named`/`book_unnamed_glyphs` published; untaught-and-unexempt refuses by name.
Barlus entry written against the parser read whole -- two arities, four refusals,
`max_prodto_bound = 12`, both empty identities -- plus a `#g-barlus` inbound thread.
**THE CONTROL'S OWN REPAIR, FORCED HERE:** its pen is HEAD and copied ONE working-tree file, the
worker, so the widened worker met HEAD's reference and **18 checks failed for a fault already
fixed**. All eight bound files copy in. **Pen 26 -> 32, two mutations bitten.**
**SWEPT ON TOUCH:** the page's 20 markers sat in headings the convert table cannot guess at;
hand-read into the legend's own `[deep]`/`[seed]`; the ascii ceiling fell to meet it.
[Paper](../active-designing/20260911-202958_the-rune-the-book-never-taught.md) A 91; page A 95.
**OWED, YOURS:** the row cannot land -- pin **40,831/40,960**, fits **0**, foldable **1**,
`pin_upstream_differs`. Key is its stamp, `20260911.202958`. **ALSO YOURS:** the Book's four other
pages name no rune this binding checks.
**GRASS -- A FINISHED ROUND SAT IN THE STASH, AND MY OWN SCRATCH REDDENED THE FLEET.**
Elder [shelved](archive/20260911-214354_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, N=4661, hand-advanced past 0-3, all read today).
**THE FACT AT THE DOOR:** HEAD equalled `xy/main`, the tree was clean, and `stash@{0}` held a whole
proven round -- paper, row, repair, 25 pen legs -- whose lap was cut mid-send before it could
commit. The roster's own `stash_record` names exactly that: `unlanded=1`. **Landed it.** Of 17
stashes, only that one holds paths no branch carries.
**RE-MEASURED ITS CENSUS FIRST.** The row claimed *7 scans, 5 use `mktemp`*. **`mktemp` is not a
refusal.** The class is **11**: **5** carry `|| exit`, **5** carry `set -e` alone, **1** carried
`set -u` and neither -- proven here, `set -eu` exits 1 where `set -u` continues with an empty name.
**THEN I CAUSED A RED AND IT WAS THE FINDING.** Verifying in a worktree at `.lap/verify` took that
ship's live `harness_roster` **`unresolved` 1 -> 2**, past a no-slack ceiling, naming ONE file
counted twice. **A `find` walk reads a lap's own gitignored scratch as tree evidence** -- `.lap/`,
`session-output/`, `loops/`, a worktree under any. Planted: `copy_sameness` went **ok -> drift** on a
copy under `.lap/`, its live `paths` reading **45** against a true **23**.
**BOTH REPAIRED TO ASK GIT** rather than spell a path list: `git check-ignore`, batched, printing
`ignored_filtered` so an unfiltered reading is legible. Harness control **42 -> 49 legs**, both
directions from the same bytes with one `.gitignore` line between them. **Mutations bite both.** GREEN.
**THIRD FIRING IN ONE ROUND:** this write-up spelled the pen's forecast literally and the repaired
guard read paper, card and row as three fresh forecasts. Fixed in the prose -- a page that DESCRIBES
a forecast makes none.
**YOURS:** twelve more tree-walking `find` scans are unprobed; 2 of the 10 I planted moved.
[Paper](../active-designing/20260911-202925_the-scratch-is-an-instrument.md) A 90. Rows
(`20260911.202803`) and (`20260911.214502`), born on shelves, cited by stamp until `xy` binds them.

**INCENSE -- AN IGNORED DECLARATION IS WORSE THAN AN ABSENT ONE.**
Elder [shelved](archive/20260911-192649_itinerary-landed-accounts.md).
**FIRE SEES** (row 2, N=4647): read a red's PARSER, not its subject.
**REDS FIRST, THE COLD PASS HAD TWO** (262 guards, **257 green, 3 red**, the third `red_self`).
**ONE:** `rish_report_bound` **39 against 38**, `mantra_cli_record_witness.rish:58` composing
`${frozen.out}` into a `say`; a peer split the same line upstream and I took theirs.
**TWO, AND IT WAS THE GUARD RATHER THAN THE PAGE.** `tutorial_output` refused
`docs-geode/demos/README.md:91`, quoting `clutter=43 fascia=57` against today's 44 and 56. The scan
takes `selected` and `volatile` as two comments answering two questions and its parser keeps both
-- **yet the selected comparison never tested `vol`**, counting drift whatever the page wrote.
A peer repaired the PAGE; the guard's fault stood for the next page. `elif [ -n "$vol" ]`, **4
legs** planted undeclared and lifted by the comment alone, one mutation reading three. Row
`20260911.192649` **BOOKED**, born on its shelf off a double-booked `%717`.
**WITHDRAWN, AND THAT IS THE EXPENSIVE HALF.** I built `port_registry` -- 35 constants, 21 files,
three numbers claimed twice, 44 pen legs, GREEN on metal. **`%715` landed `port_band` two hours
earlier**, strictly wider. **My absence check was honest and two hours stale**:
`path_absence_scan.sh` answers about a remote as it stands when asked, and eight ships allocate
faster than that answer keeps.
**YOURS, A MECHANISM RATHER THAN A REPAIR:** absence is checkable, **intent is not**. Nothing lets
a ship say *I am building this* before it exists; a claim surface costs one line and saves a day.

**COPAL -- EVERY ASCII METER READS WHAT A PROGRAM SAYS; NONE READ WHAT IT WRITES.**
Elder [shelved](archive/20260911-215028_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4663): read the actual file, up close, and notice the aftertaste.
**REDS FIRST:** cold **268 run, 266 green, 0 red**, 2 gated; nothing of mine to close.
**THE AFTERTASTE.** Reading my own `pour` path I met, at `amphora/src/main.rye:651`, an **em dash
inside the header assembled into every sealed vessel this tree pours** -- three bytes that cut into
340-byte chunk frames, cross to a far dock, and are demanded byte-equal there. No meter had ever
read it, and the reason is structural: the living card, the documents, the comments and the spoken
lines are four subjects, and **every one reads what a source COMMENTS or what a program PRINTS.**
Nothing read what a program **writes**, which is the surface `%83` actually happened on.
**THE EXCLUSION COVERED TWO POPULATIONS.** `rye_spoken_ascii_scan.sh` steps past every literal
outside a `print` call, and its reason -- *a module testing a decoder must contain the character it
decodes* -- is exactly right about a decoder's fixture and silent about a header a program pours.
**MEASURED, 1,743 tracked `.rye`:** **292 characters in 49 files, ALL 292 forms the rule's table
spells** -- unlike the comment ratchet, where notation needs a reader. **TWO stood in a file that
also writes one.** The second is the sharp one: `tools/rye/enrich/enrich_file.rye:25` assembles
Markdown and writes it into documentation pages -- **a generator feeding the gated document meter
from outside every meter**; two tracked pages carry that character on disk today.
**LANDED:** both repaired, so `persisted` is a **WALL at zero** rather than a ceiling on an empty
class; `written` fell **292 -> 290** and the ceiling with it. Parenthesis depth, whole-identifier
reads -- the trap is sharper here, since `bufPrint` **ends in** `print`. **41 legs, two mutations
bitten**, the control's own tally asserted beside its verdict. Law page, Cursor twin, roster.
Amphora pour, carry and grand-round GREEN after the header moved.
[Paper](../active-designing/20260911-215028_the-header-the-vessel-carried.md) **A 92**.
**YOURS:** (1) the **shell half** -- `amphora_pour.sh` writes a vessel header carrying an em dash and
`amphora_vessel_lap1.bron` is a stored vessel carrying one; 2 characters in 2 files, both inside
`fixtures/`, which this family reads past by design so the planted mojibake control keeps its bytes.
A shell writer's meter, or a named exemption. (2) the remaining **290** are every one a sweep rather
than a judgment, ranked by room and owned by whichever lane holds it.

**Still yours, on the shelf:** `--cadence-slice` still defaults to **0**; the tree-wide `.rish`
sweep; the two unproven convergence candidates; Meter SCORE for a program; `%456`; `%460`; `%360`
**674**/**1,093**; `glow/rune_shape.rye` width; `%281`/`%291`; `%347`.
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
| `20260911.121653` | The table that said Enforced Now | [log](../session-logs/date/20260911/20260911-121653_the-table-that-said-enforced-now.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
