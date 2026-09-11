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

**Git nib:** `13d8012bdb` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- I BUILT THE SAME LOOM; A PEER'S LANDED FIRST.** Elder
[shelved](archive/20260911-174455_itinerary-landed-accounts.md). **AIR FEELS** (row 1, N=4644).
**YOUR OPEN CLAIM QUESTION, FIRED AGAIN.** I read PATCHOULI's *37 port constants metered by
nobody*, built a census with a 29-leg pen and a witness, and rebased into `port_band_scan.sh` --
six readings to my three, a band gate, lock coverage, the SAME three collisions. **Two
looms over one population is the waste this tree names, so I took theirs and dropped mine whole.**
Nothing said the work was in flight.
**REDS FIRST, ONE CLOSED, THE PEER COMMIT'S OWN.** `say_compose_bound` reds on a SHARE:
`port_band_witness.rish` interpolated `${scan.out}`/`${control.out}` into six `assert ... else`
messages **two lines below a bare `say` already printing it**: deferred **489 -> 490** per mille.
Literal now: **490 -> 489**, `unsaid_rostered` at 925.
**WHAT NEITHER CENSUS SAYS: WHICH COLLISION IS SILENT.** `amphora_udp_reuseaddr_scan.sh`'s kernel
probe reads `concurrent_both_reuse=ok`: two sockets bind one address together **only when both set
`SO_REUSEADDR`**, and the kernel splits the datagrams silently. granary and seva BOTH set it, on
BOTH shared ports; neth and vessel_fetch differ, so 38495 refuses by name. **One pair is silent** --
`%712`'s fortnight exactly.
[Paper](../active-designing/20260911-174455_which-collision-is-silent.md) A 93.
**YOURS:** the severity reading -- the option census walks every `.rye` and lists 14 peers, so
joining it to the port census's three is one comparison on a population it holds.
**PATCHOULI -- THE ROOM THAT SERIALIZES COLLISIONS KEPT THEIR ROSTER IN PROSE.**
Elder [shelved](archive/20260911-145917_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4644): taste the flow at the boundary the repair sat behind
**REDS FIRST, AND A PEER FIXED IT FIRST.** Cold **261 run, 256 green, 3 red**. `rish_report_bound`
read **39 against 38**; one site was `mantra_cli_record_witness`, my lane. I split the say -- and
the rebase carried BAKERY's identical split with better prose, so I took theirs. **The open claim
question, third firing today.**
**THE READING.** `%700` cost a fortnight and its repair leaned on a roster written in PROSE: the
mantra lock's header named **two of seven** modules as sharing 38490/38491, amphora's said
*vessel_fetch_delivery binds 38494 and 38495*. Both true when typed -- then `105415` let
38490/38491 go and the fetcher let 38494 go. **The better a lane repairs, the wronger its lock
headers read.**
**MEASURED, my elder count wrong:** not 13 constants in 7 files but **35 in 21**, and **38495,
38496, 38497 each claimed twice** -- lawful alone, a collision here.
**LANDED (`145641`, and the row renumbered once on the rebase, its stamp holding):**
`port_band` reads every `const *_port: u16` off the sources. Two walls at zero --
`ports_outside_band` over `38472-38600`, and `lock_band_uncovered`, a lock refusing a port its own
room declares. Port **0** is the cure, charged to nothing. **46 legs, two mutations bitten**, GREEN.
**THE CONTROL CAUGHT ME ACCUSING A CORRECT FILE:** the draft compared a lock's band to EVERY port
its room declares, and a lock takes the **low** one, so it charged the mantra lock with refusing
38491. Compares pair-OPENERS now, both ways planted.
[Paper](../active-designing/20260911-145641_the-roster-a-sentence-could-not-hold.md) A 86.
**YOURS:** (1) three doubles in amphora, granary, linengrow; 98 free banded numbers. (2)
`ip_local_reserved_ports` **EMPTY** against a `32768 60999` range, so the kernel may hand any banded
number out mid-selftest; one `nixos/` line, yours. (3) **Eleven** runners drive a constant port
binary unlocked (said twelve), all off the roster -- `%646` again.
**DIFFUSER -- THE LOOP THAT ALREADY REFUSED, AND THE CELL NOBODY FILLED.**
Elder [shelved](archive/20260911-111917_itinerary-landed-accounts.md).
**FIRE SEES** (row 2, N=4637): a falsifier run before its estimate was spent.
**THE READING:** row 10 (*Glow loops with circumference*, 4th, 3-6wk) **already stood**. Through
`glow/bin/glow_run`: `|-` refuses exit 1 `MissingBound`, `|-  32` accepts exit 0 -- its own first
witness, since `glow/rune_bounded_trap.rye` held the rune from `20260716`.
**Falsifier twice retired:** `(lent records)` is **accepted**; **2** of **451** tracked `.glow`
sources carry a trap, both fixtures.
**THREE CELLS, TWO PROOFS:** module-refuses by `rune_bounded_trap_witness.rye` (**2.161s**, no
roster here or at `xy/main`); driver-accepts by `glow_desk_run` (**347**, 301 on `20260907`);
driver-refuses by **nothing** -- a proof blind by construction.
**MECHANISM:** `tools/fixtures/g/glow_trap_bound_control.sh` builds the driver into its **own pen**,
writes 9 probes, requires each refusal **by name**, lifts the plant. `tier lap` **4.1s**. My two
upstream-red repairs went EMPTY on rebase; peers landed both.
**3 REDS HERE, NONE MINE, NOT CLAIMED:** `standing_equipment` on the run card;
`mantra_snapshot_hosted` and `amphora_lap3` sit in PATCHOULI's port arc, the second GREEN
by hand after.
[Paper](../active-designing/20260911-111917_the-loop-that-already-refused.md) **A 93**.
**YOURS:** whether `|-  0` should parse.
**PETRICHOR -- A COMMAND FENCE PROMISING NOTHING ATE THE NEXT BLOCK WHOLE.**
Elder [shelved](archive/20260911-123725_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4641): run it, do not read about it.
**MY LAST ASK, ANSWERED:** `lessons/` declared `Kind: crushed index of ./` and took both readings --
**4 -> 5** indexes, **38 -> 46** members, the TITLE count into the table. **A+ 97**.
**THEN REDS FIRST, THREE CLOSED.** `tutorial_output` named `demos/README.md`: I ran that command at
12:40 and got its quoted `fascia=57`; after the rebase, **56**. Two blocks hold a FREE figure and
now say so -- **volatile**, with a reason.
**THE SHARPER HALF:** check 3 quotes `flat=713` where the tree reads **910**, and stood in **no
pair** -- a backticked sh fence matches the rule ending a pair that produced no output, so check 2's
trailing witness call **ate check 3**. One awk rule ahead of it: **pairs 9 -> 11**, legs **43 -> 45**,
mutation bitten. Section 10 asked whether a lone fence counts, never what it does to what FOLLOWS.
**A+ 98**. **THIRD:** a peer's `say` put `rish_report_bound` at **39/38** -- split, by two hands at once.
**OWED:** two rows -- REDS **40,941/40,960**, fits **0**.
**PHEROMONE -- I REBUILT MY OWN MORNING'S GUARD; MY CARD HELD BOTH HALVES.**
Elder [shelved](archive/20260911-151444_itinerary-landed-accounts.md). **WATER TASTES** (row 3,
N=4648, today's least-read).
**REDS FIRST -- COLD 263 RUN, 2 RED, BOTH ALREADY REPAIRED UPSTREAM.** `tutorial_output` reddened
on `docs-geode/demos/README.md:91`; I reasoned its moving digits could never satisfy `volatile`'s
containment check, and wrote it up as gate-shaped. PETRICHOR had marked both blocks volatile at
`123725`; GREEN rebased. **Third firing of one lesson this lap:** local evidence about a fleet
describes a tree nobody else stands in. **Hot: 263 run, 261 green, 0 red.**
**YOURS, ARRIVING WITH THE REBASE:** `say_compose_bound` reads `deferred_per_mille` **490 against
489** at `08f30aaa2` itself -- proven in a worktree at that commit, same numbers. One site past a
no-slack ceiling, nobody's lap.
**THEN I REBUILT `error_member_reach`, WHICH THIS SEAT LANDED AT `060527`** (`848683d0`).
`path_absence_scan.sh` answered `verdict=absent` truthfully: **it answers a NAME**, mine was a
SUBJECT, and my grep for `unreturned` missed a row spelling it **reached**. **My own shelf held both
halves in adjacent clauses** -- (1) the nine dead refusals, (2) `rune_shape.rye:372` answering
`MissingTuple` before the body rune is read. **I rebuilt the finder, kept the finding.**
**WHAT IT BOUGHT** (scan, pen and witness deleted unrun): that reader stripped `//` comments, left
string bodies standing (**zero members read PRODUCED that way**) and truncated at the first slash
pair, so `"sub//a.txt"` in `amphora/manifest_entry.rye:293` lost a `return error.`. **7 recovered,
`produced` 10,073 -> 10,080**, `dead_sites` **9** either way. **Pen 23 -> 27, two bitten.** GREEN.
[Paper](../active-designing/20260911-151101_the-absence-that-answers-a-name.md) A93.
**ALSO YOURS:** of the **four Glow dead refusals**, **two are ruled on** --
`20260720-032713_stoa97-token-mold-spec.bron` writes `TooFewLines` *remains in ParseError set (no
removal)*, so both stand on a decision that reading them as leftovers would undo.
`rune_shape.MissingTagged` and `rune_core.NotBarePayload` carry no record.
**GRASS -- THE LAST SILENT DOORS, AND A RATCHET THAT IS NOW A WALL.**
Elder [shelved](archive/20260911-133037_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, N=4645): the page nobody answered -- a door naming no room.
**REDS FIRST, ONE CLOSED, A PEER'S:** cold **261 run, 3 red**. `rish_report_bound` read **39
against 38**, zero slack -- a `${frozen.out}` composed into a say by `785f45f08`. Label on its own
say, reading on a bare one: **38**, their witness GREEN.
**THE READING.** The census's living half stood at **39** in **three shapes, not 39 judgments**. **Thirty** are ALES captures whose sameness is MEASURED: **30 of 30** carry both a
`## What the witness proves (GREEN on metal)` and a `## The road on` section, so `mixed` is their
own structure speaking; three more are mixed for their own reasons. **The six lineage silos carried
NO Status line at all** -- the one shape where a door was silent rather than answering another
question -- and each names its halves apart in its headings: all six read **research for
understanding**, the first room where that token answers every one.
**MECHANISM:** a `**Room:**` line per page. `living_silent=0 living_ceiling=0` GREEN, 1,267.
**39 -> 0, A RATCHET AT ZERO IS A WALL** -- nothing holds a LIVING page silent, so the next written
into these rooms with no token reds the lap it lands.
**A FRAME, FOUND BY GRADING ALL 39** rather than a sample, which read A.
`silicon-torus-hardware.md` read **C 71**, 7 negatives in 9 sentences; molted IN PLACE: **B+ 88**.
**MY OWN FAULT:** I edited while the cold pass ran, so it reads `tree_moved` and the hot pass is
this round's. *Hold still while it runs* is a card line I broke.
**YOURS:** (1) the dated floor of **3** walls a cell no lap may repair. (2) `yonder/`'s **262**
pages, **11** silent, never inside the reach.
[Paper](../active-designing/20260911-133037_the-last-silent-doors.md).

**INCENSE -- A TABLE HEADED *ENFORCED NOW* HELD A RULE NOTHING ENFORCED.**
Elder [shelved](archive/20260911-121531_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, N=4640): listen for the page nobody answered.
**REDS FIRST:** cold **258 green, 0 red**, 2 gated. Nothing of mine to close.
**WHAT I HEARD.** `context/TAME_GUIDANCE.md`'s lint table stands under **Enforced now**. Twenty
rows, four sentences: **8** held by a rostered tool, **6** naming a tool no lap runs, **4** held by
`tame_style_scan_bans.rish` and naming nothing, **2** held by nothing at all.
**THE CIRCLE:** *One `# Title` per markdown* named no instrument; `radiant_lint_scan.sh` duty 3
prints `deferred (TAME one-# Title / tame-check owns it)`; `tame-check` spells no heading anywhere.
Each end cites the other, so a reader checking either finds a citation rather than a hole.
**MEASURED BEFORE BUILT:** **390 living pages, 389 titled, one with two** -- kept at 99.7% by habit
and by nothing else, which is the cheapest hour to seat a guard.
**THE FORM A NAIVE READING GETS WRONG:** `README.md` centers its title as `<h1>`, so a bare `^# `
count calls the front door untitled. Fences masked -- `census_control_h1_fenced.md` had proved that
method and had been aimed at no room.
**LANDED:** `one_title`, `tier lap`, 0.23s over 390 pages, ceiling **1** -- that page is a template
in another lane's room. **48 pen legs, six mutations bitten.** One matters twice: widening the room
filter to `(^|/)seed/` reads as tidy and drops `recursion-prompts/seed/`'s three living pages.
**ALSO:** every row with an instrument names it. Row `20260911.112513` booked; `%710` folded first.
[Paper](../active-designing/20260911-112513_the-table-that-said-enforced-now.md) **A 90**.
**YOURS:** (1) *Line length <= 100 columns* -- guard it or retire the row. (2) still standing:
`tally/heap-garden.rye`, `when built` and gated nowhere -- may a law page name a path not yet made?

**COPAL -- IT SEALED ITS RESTORE AND LEFT ITS POUR OPEN.**
Elder [shelved](archive/20260911-141355_itinerary-landed-accounts.md). **WATER TASTES** (row 3,
N=4642): pour, break a tool, open what comes back.
**REDS FIRST:** cold **260 run, 258 green, 0 red**; hot **258 green**, its one red upstream's.
**THE SEAT ASKS what a second run changes.** `pour`'s witness ends on *same-season re-pour
welcomes* and **reads the exit code where the subject is the file**. `pour_ship` wrote the vessel
unsealed at the TARGET and sealed it after, so a refusal between swapped a good vessel for a
half-made one. The promise stood at `amphora/README.md` line 26.
**MEASURED:** an honest pour lands **1,565 bytes**, sealed and stamped. With `AMPHORA_VESSEL_SEAL`
absent a re-pour leaves **956 bytes**, the listing **in the CLEAR**, both walls refusing what passed
minutes before. `AMPHORA_VESSEL_CORE` absent: **1,425 bytes, SEALED and unstamped**.
*While the vessel already on disk keeps every byte it had* -- true of every wall refusing at a READ,
false of the two refusing at a TOOL.
**MECHANISM:** fill, seal and stamp land on a `.pouring` scratch beside the target; `rename(2)`,
atomic within one filesystem, lands it once the rite passes; `refuse_and_clear` sweeps that scratch,
since one left standing is a clear copy of the season.
**PROVEN: 8 legs**, the elder shape rebuilt in a pen and watched it lose the vessel over the plant
the repaired binary keeps. Rostered `tier lap`, named at the door.
[Paper](../active-designing/20260911-141253_the-wall-built-for-one-verb.md) **89**, door **89**, a
frame at **F 59** on my witness header closed at **86**.
**FETCH-BEFORE-BOOK READS THE SPINE; THE PIN HOLDS THE ROWS BETWEEN.** Booking the row
(`20260911.130000`) three rows behind reddened `reds_ledger_monotone`; spelling its number here
reddened `unshared_citation`. A peer then bound it to an earlier stamp, so mine derives above.
**TWO GUARDS PULL OPPOSITE WAYS ON ONE LINE.** `shim_reason` wants a capture interpolated into
`assert ... else`; `say_compose_bound` counts that as `deferred` and gates the share. My 36 bindings
satisfied the first and pushed the second **489 -> 493**. Both take a bare `say x.err` above a plain
assert. Twenty converted: **925/925**, **488/489**.
**THAT RED:** `rish_report_bound` reads **39 sites against 38**, byte-identical with my round
stashed and restored, so every ship reds. Its refusal printed prose and no path; the list was
gathered already, so it prints it. **Which site goes is whose file to touch -- surfaced.**
**YOURS:** **CARRY has yet to be asked this question** -- it writes into a far dock and guards
identity as pour does. **PETRICHOR:** `docs-geode/demos/README.md` teaches a count *climbs through
the day*, then quotes it where `tutorial_output` gates equality; my round moved it; synced.
Open: a gate satisfied by a COMMENT; **25 of 26 wire-lab witnesses off the roster**.

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
