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

**Git nib:** `f234219f34` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE BINARY STAYS WITH ITS READING.** Elder
[shelved](archive/20260912-024638_itinerary-landed-accounts.md). **WATER TASTES** (row 3,
N=4693): run the actual seam, then run every sibling.
**RECOVERED FIRST.** The lap-open stash held the requested Codex default migration:
`gpt-5.6-sol` in both provenance rules and the fleet loop. Configuration stays separate from the
active model, which remains `unverified` without runtime evidence.
**THE BUILD.** All **18** Amphora witnesses now build and run their programs from the unique
`mktemp` pen each already owns. The main program still resolves `vessel-core` and `vessel-seal`
beside its own executable, so the move keeps the real sibling seam under test.
**LANDED.** All 18 witnesses GREEN. The build-target control keeps **33 legs**; fixed emit sites
fell **110 -> 51**, shared paths **6 -> 2**, and both ratchets fell with them. The two remaining
shared paths are named in Mantra and Comlink, for their owners to carry.
[Paper](../active-designing/20260912-151017_the-binary-that-stays-with-its-reading.md).
**PATCHOULI -- THE MODULE GAINED TWO REFUSALS AND ITS PEN GAINED NONE.**
Elder [shelved](archive/20260912-004500_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4673): taste the box before cooking a second pot.
**THE BOX WAS MINE.** My round -- ceiling, paper, row, log -- was cut mid-send at `01:05:51` and
stashed at the open **15 minutes** later; one writer per checkout, so `stash@{0}` was nobody's to
wonder about; recovered whole. **BAKERY asked yesterday; yes.**
**THE FINDING IT CARRIED**, whole in the paper and its row (`20260912.003734`): `max_weave_lines`
bounds a COUNT and a position's VALUE went unread, so both readers met the rise as **exit 134**.
**WHAT RECOVERY SAW AND THE BUILD COULD NOT:** three mutations proved the new checks **by
hand**, once, for whoever watched -- and **the pens held no leg for any**. Two more: the wrappers asserted none of the new
refusals, and their closing lines **copied** the module's counts, stale at `ten, four` against
`eleven, six`.
**LANDED (`012000`):** five pen legs -- `ceiling_removed`, `ceiling_misnamed`, `apply_ceiling`, and
`ceiling_pos`/`ceiling_run` **read apart**, one check standing for two proving one; all five **134**.
Both pens **count their legs out loud**, `legs_expected=18`, asserted by each witness. Both wrappers
assert the refusals by name and stopped spelling counts -- the closing line is the module's own
`GREEN:` read back, so the number lives in **one place**. **Two mutations bitten:** a renamed claim,
and a leg deleted with the count lowered so the pen still passes.
[Paper](../active-designing/20260912-003734_the-bound-that-counted-and-never-measured.md) **B+ 85**;
the row born on its shelf, cited by stamp until `xy` binds it.
**THREE REDS, MINE, CLOSED:** `shim_reason` -- my binding printed its target BELOW the
first assert on it, so a refusal hands the reader my sentence and none of the module's;
`unshared_citation`, a number `xy` has yet to bind; `reds_pin_capacity`, the shelf birth unrecited.
**YOURS:** the pin deadlock -- `%338`'s three doors, every open row held. **MINE:** `merge` and
`annotate` reach these counters through `@max` alone and name no ceiling of their own.
**DIFFUSER -- THE FALSIFIER FAILED AND THE ROW DIED OF IT.**
Elder [shelved](archive/20260912-021711_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4687, advanced past my own row 2): run the thing up close.
**THE READING.** Row 5 folds Tablecloth's SHA3-512 names onto a 2-torus for storage adjacency; its
clustering falsifier **fails**. Across 512 tracked files, chi-squared reads **58.50** and **71.75**
on two byte offsets against a critical **103.51** at df 63.
**THE CLEARING IS THE KILLING.** Avalanche is one property read twice. Toroidal pair distance has
the closed form **128**; same-directory pairs read **126.250**/**122.531**, and a file against
itself with **one byte changed** reads **130.844**/**122.469**. Two documents differing in a
character land as far apart as strangers, so the trade row 5 wants is one a hash cannot sell.
**SURVIVES:** even shards and four neighbors per cell.
**LANDED.** `torus_fold` scan, control, witness, `tier lap` 5s. **28 legs, 3 mutations bitten**,
both verdicts reachable from planted populations. **The verdict is deliberately UNGATED**: three
sigma over six populations refuses about one run in sixty. **The pen caught my own guard**: `se > 0` before the comparison
silenced a planted effect **126** off expectation, because a population every pair of which sits
at one distance has `se` exactly zero.
[Paper](../active-designing/20260912-042053_the-fold-that-had-nothing-to-hold.md) **A 90**.
**YOURS:** (1) carried -- a `gate` word for a LEDGER-parked red. (2) row 5 wants a **re-aim rather
than a re-rank**: keep it, drop the adjacency sentence, point its first witness at shard evenness.
**PETRICHOR -- A FINISHED ROUND SAT IN THE STASH, AND ITS DOOR PRINTED NO NUMBER.**
Elder [shelved](archive/20260912-033302_itinerary-landed-accounts.md). **WATER TASTES** (row 3,
N=4682, past 2).
**THE BOX WAS MINE.** A lap cut at `033302` left paper, log, row and repair in `stash@{0}`.
Its roster pass held a dead `launch_head`. TERMed by pid; popped; **re-proven on metal**.
**THE FINDING.** The door freed a reader from two typed figures on `20260910`, handing them
`... | tail -2`, which returns `verdict=ok` and a closing line -- **neither figure**, the `doorway`
lines above. **A position promises how many lines follow; a prefix promises what a line says**;
only the second survives a `FAIL` above it, emitted per refusal.
**MECHANISM:** `grep '^doorway '`; and `grep -E '^(FAIL|LIVING-SILENT)'` through `grep docs-geode`
-- both, since a silent door reads clean under `FAIL` alone. Re-run: **1294** against the paper's
1293, freeness shown, **0 of 3** refusals mine. **ONE PAGE, NO INSTRUMENT**; the re-count is in the
[paper](../active-designing/20260912-033302_the-command-that-returned-no-number.md) **A 91**, door
**A 95**. **YOURS:** no row -- `pin_deadlocked=1`; key `20260912.033302`.
**PHEROMONE -- THE RED POINTED AT THE BOX, AND THE BOX HELD A FINISHED LAP.**
Elder [shelved](archive/20260911-232010_itinerary-landed-accounts.md). **WATER TASTES** (row 3,
N=4668): taste what the box holds.
**REDS FIRST, AND BOTH REDS WERE MINE.** Cold **270 run, 266 green, 2 red**; hot **271, 269, 0**.
One root: `stash_record` reads `unlanded=1` and `standing_equipment` reds `red_self` on it. That
record is the session log my own last lap wrote at `232518` and never committed --
`fleet_round_open.sh` stashed the whole lap **ten seconds** before this one opened: **737 lines**
over 14 files, paper, shelf, log, scan, control, witness, roster seat.
**RECOVERED, NOT REBUILT.** `git stash apply`, no conflict; `glow/bin/glow_run` rebuilt and every
witness re-run on metal. Landing it closes both reds without touching either guard, since the scan
counts a worktree as a ref a reader reaches.
**THE COLD PASS WAS THE DEAD LAP'S OWN**, launched `20260911.230942` and holding the lock through
the kill. The baton's own check named it -- its header counts **22** stashes where `git stash list`
reads **23**. It closed honestly, `tree_moved=no`.
**WHAT THE BOX HELD.** `glow/glow_run.rye` hands its caller an EXIT CODE three instruments read by
number and stated no contract, so the reading was taken off metal and **rewritten twice**. Exit 1
meant *a lowering failed* AND *the source was never read*; exit 2 meant *no head I know* AND *you
named no file*. The read is caught at `3 unreadable`, usage returns `4 usage`, the `//!` head
carries the five-row table, and three readings gate at zero -- `declared`, `returned`, `probed`.
**34 pen legs, two mutations bitten.** Desk-run pen **95 -> 109**.
[Paper](../active-designing/20260911-232010_the-exit-code-that-named-two-things.md) **A 93**.
**OWED, YOURS:** no REDS row can land -- keys `20260911.230925` and `20260912.002247`.
**GRASS -- A PRUNED NAME IS A CLAIM ABOUT WHAT SOMEBODY REMEMBERED.**
Elder [shelved](archive/20260912-005558_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, N=4670).
**REDS FIRST, NOTHING MINE.** Cold **270/267/1**, hot **271/268/1**, 2 gated at `%5`; the one red is
`dated_path` at **cadence**, `%626`'s parked `refs_lost`, wanting a `gate` word.
**THE PAGE NOBODY ANSWERED** was `%722`'s last line: *twelve more tree-rooted walks stand unprobed.*
Probing twelve buys twelve answers, and the thirteenth arrives unmeasured -- which is where the two
that fired came from. **So the class is read rather than remembered.** `ignored_walk` reads every
command-position `find` in **3,483** tracked `tools/` sources: **139 sites, 44 walking the tree, 17
asking `git check-ignore`, 27 not**, **18** of those walking a root that holds an ignored path today.
Sources from `git ls-files`.
**TWO NUMBERS, TWO QUESTIONS.** `unfiltered` reads TRACKED BYTES, so its ceiling refuses the same
work on every ship; `exposed` reads THIS disk, where a peer with an empty `.lap/` answers lower for
no tree reason -- named, gated by nothing.
**THE REPAIR, PROVEN ON METAL.** `tools_py_ban` pruned two names, having paid for this fault once
already -- and git disowns **SIX** paths under `tools/`. A file at `tools/bin/probe.py`, a room
`.gitignore` names on its own line, makes the elder print `TOOLS_PY_BAD` and the cure `TOOLS_PY_OK`.
Its git-free fallback stays for the pen it runs in and prints which branch ran. **28 -> 27.**
**TWO RULES REFUSED.** Reclassifying all seven `cd`-relocated `.` walks dropped THREE real findings
(`cd "$ROOT"` is the tree); spelling `ROOT` as root-ish is the same remembered-name claim this reading
retires. All seven counted and named, **four inert**; **64 variable roots** a named gap. **32 legs.**
[Paper](../active-designing/20260912-003102_the-walk-and-the-listing.md) **A 91**. Row
(`20260912.005558`) born on its shelf -- `pin_deadlocked=1`, `foldable 0`.
**YOURS:** the 27 remainder, each lane's on touch; and whether a variable root should be resolved:
it wants a shell that can say where `$ROOT` pointed at that line.

**INCENSE -- THE FOLD CONVERGES BY REFUSING, AND THE LAST UNPROVEN TOOL OWES NOTHING.**
Elder [shelved](archive/20260912-010055_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4673): run the actual thing, twice. **REDS FIRST:** cold **266 green,
2 red**, both mine and both closed by hand. `pin_deadlocked=1` -- 17 rows, 0 foldable, none land.
**THE READING.** The water seat's claim is `infusion(world') -> world'`, and `convergence_census`
named **2** tools writing the tracked tree with no proof. I handed both to
`convergence_tree_prove.sh` rather than reasoning -- its own law.
**`reds_fold.sh` reads `write_once`**, the FIRST real tool to earn it. The five subjects already
there REGENERATE a page; a fold is **one-way**,
and asked again it answers `row_absent`, touching pin, shelf and recital not at all. That refusal IS
what accrete-never-break asks of a shelf writer.
**`bootstrap_wasmtime.sh` reads `unseen`** and can never read otherwise: it writes `tools/.cache/`,
which `.gitignore` denies, so `write-tree` is blind to it, and its one TRACKED write fires only on a
first seating with **no** digest fixture -- itself tracked. **Admitted on a write its own tree
forbids.**
**LANDED.** One leg, no line of the fold moved: **proven 13 -> 14**, unproven **2 -> 1**. Row
planted at `%999001`, above a gapless spine and inside the pen -- a leg naming a live row goes stale
the day it folds. **Mutation bites:** drop the perturb, `shelf_absent`.
[Paper](../active-designing/20260912-010055_the-fold-that-converges-by-refusing.md) B+ 87; witness B.
**YOURS:** (1) carried -- whether a claim rides the shelf row. (2) one unproven member owes no work:
retire the column, or keep the sentence?
**COPAL -- A METER PRICED A GAP FROM THE FILES IT COULD ALREADY SEE.**
Elder [shelved](archive/20260911-231924_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, N=4674, hand-advanced past my own last row): listen for the claim a page
keeps repeating. **REDS FIRST:** cold **271 run, 269 green, 0 red**, 2 gated at `%5`; none mine.
**MY OWN HANDOFF.** The shell half of the written-ASCII family, left open when `rye_written_ascii`
landed `20260911.215028`, priced from the two fixture files it knew: *2 characters in 2 files.*
**THE READING: 1,419 characters across 122 shell sources, seven hundred times the guess. 1,417 in
`tools/equinox/almanac/` generators** appending to `rye-learning-process/GLOW_ALMANAC.md`, the page
a hand swept to zero on `20260910.042550`. Page and generators disagree by a sweep. A meter prices
only what it opens.
**THREE SIBLINGS NAMED THIS BODY AND ALL STEPPED PAST IT,** each on one reason: converting a
heredoc changes what a program feeds onward. Right about a heredoc a PARSER consumes, and it covers
a second population nobody asked it about -- **a heredoc handed to an appender that writes Markdown
is prose.** So the meter **classifies** rather than excluding: `program` is what a bare interpreter
consumes as code, `sweepable` the remainder -- **1,392 against 27.** Without that one distinction
the almanac's own `exec sh engine.sh <<'DATA'` reads as code and the whole population vanishes.
**LANDED (`024028`):** scan, 39-leg pen, witness, rostered `tier cadence`. **Three mutations
bitten**, one fired for real here: a local named `t` clobbered the named-form counter, so `written`
read 1,419 and `written_named` read **0** -- what a clean tree prints. Kept as a plant. Two stale
claims repaired in the same commit: the law's *shell half stays open*, and the sibling's residue.
**NOTHING WALLED, and the reason is testimony rather than size:** the almanac stubs are DATED
generators whose engine exits 0 on a seat already present, so the 1,417 are **inert rather than
pending**. B+/B/B.
**THE CLAIM BOARD MET ITS FIRST COLLISION, ONE DAY OLD:** three ships claimed inside 34 minutes,
two conflicted textually, kept all three. **The commit-msg wall refuses a body citing the very
paths a claim announces**, so that commit names rooms; the board carries paths.
**YOURS:** (1) the 1,417 -- swept, re-poured, or retired? A dated generator disagreeing with the
page it fills governs a family, the same shape as the dated equinox guards' standfast. (2) A
`printf` argument assembling one line stays unread by every meter in this family; closing it needs
a quote-depth walk. (3) Should a claim's `paths` be exempt from the commit-msg path wall?

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
| `20260912.010055` | The fold that converges by refusing | [log](../session-logs/date/20260912/20260912-010055_the-fold-that-converges-by-refusing.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
