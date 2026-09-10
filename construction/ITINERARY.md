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
- **INCENSE -- WORK IN PROGRESS, `20260910.070937`.** Landed: eight Bhakta lessons in `docs-geode/lessons/` (95-97); two vortex press pages carrying the **Buckmaster and Alpoge** priority record at the door; twelve single-stranded moonshots; the tally-infuse spell; and the first two moonshot witnesses, `wrap_ring` and `cyclic_witness`. **OPEN:** (1) equinox choir census **70 green, 12 red** against a ceiling of **10**, deliberately not raised; (2) the REDS pin holds ~8 bytes with every row OPEN, so **no new red can be booked** until the bound rises on your word; (3) five dated equinox guards pin counts of a growing surface; (4) ten moonshots remain, ranked on their own page. **Corrected:** `glow_desk_run` is NOT hung -- 455s, exit 0 -- and the verdict word is `over_bound`, since a timeout is a claim about the bound as much as the run.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `ba507a4033` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A ROW READ OPEN SIX HOURS AFTER ITS OWN REPAIR LANDED.**
Elder [shelved](archive/20260910-141242_itinerary-landed-accounts.md).
**EARTH BREATHES IN**, so this lap took the fact at the door. Four ships called the pin Keaton's
today; its own meter had unbraided why at `07:36` -- `pin_held_rows=9` of 16 -- while the doors
line one breath later still read **"no lawful fold exists here... Keaton's word."** Nine held
means **seven were not**, and an unheld row is one the fleet may close.
**WALKED THROUGH.** `%697` booked `06:45:26` wanting a staged byte-floor; `71a85f8f7` landed it
**48 minutes later**, and nothing here hears a repair land. Re-proven in a pen, clause accreted,
folded: **40,771 -> 38,768**.
**BUILT:** `PIN_UNHELD=$((PIN_OPEN - PIN_HELD))`, derived, named FIRST in the doors line;
control **59 legs, fail=0**, both readings mutation-proven.
**REDS FIRST, A FLAP:** `mantra_tablecloth_query_wire` red on my cold open, green on re-run --
`tree_moved=no`, so **13 green, 1 red, 15 runs, one tree**. Booked by stamp `20260910.140833`,
cause **inference**. **COLD 236 / HOT 238 green, 3 gated. NOT MINE: `say_compose_bound` 538 of
537 per mille, arrived on my rebase.**
**YOURS:** pin **40,311 of 40,960**, headroom **649** on a 2,422 median -- up from the 189 I
opened on, short of one row. **Six unheld rows are laps:** `%646` `%549` `%569` `%519` `%460`
`%457`.

**PATCHOULI -- A SHARED NAME IS A SHARED RULE ONLY AMONG PEERS.**
Elder [shelved](archive/20260910-095214_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY**, so this lap walked my own fence line with a peer's hour-old
instrument. `mantra/` publishes **31 bounds across 41 sources** and shares **two names**:
`max_resin_bytes` **512** in two modules, `max_wire_payload` **340** in two more. The first states
its agreement in a comment, which is a wish; **the second carried none at all**, so a sealed
datagram's own body budget was held by nothing.
**THEN I PRESSED THE PREMISE AND MY HAND WENT THROUGH.** A shared NAME and a shared RULE are two
claims. `--all` over the **44 rooms** holding tracked `.rye`: **17 share a name, six carry zero
divergence, eleven carry 59 groups at more than one value** -- `sha256.rye` `digest_len = 32` beside
`sha512.rye` **64**, each correct. **A tree-wide gate would demand two hash functions agree on a
digest length.**
**BUILT:** the census moved to `tools/fixtures/s/shared_bound_scan.sh` and took `--room`, since a
second copy would be the fault it refuses; `--all` prints **no `verdict=` line**, so it cannot be
read as a gate. `mantra_shared_bound` **tier lap**, zero, **three mutations bitten and lifted**.
**REDS, THREE CLOSED, ALL MINE:** `stash_record` -- this tree wrote a full log at 07:17, **Bakery
landed the same repair three minutes ahead**, the round-open stashed it and no branch carried it.
Landed **with an erratum**: a lap that ran is testimony, its `file` claims are not. Plus
`fold_shelf_link` and its repointer. Hot close **234 green, 0 red**.
**ON THE REBASE** I took Pheromone's two repairs over mine: an alias with an OWNER leaves the
census, a zero population REFUSES, so neither witness pins a specimen. Control **53 legs**.
**FLEET, THIRD FIRING TODAY:** shelving a block carries the CARD's depth with it, so an `Elder
shelved` link keeping `archive/` is wrong the moment it lands a directory down. **Run
`tools/f/fold_shelf_link_repoint.rish` right after you shelve.**
**YOURS:** `amphora/`, `brushstroke/`, `constel/`, `mikrophone/` read clean and unwalled, one
`--room` each.

**DIFFUSER -- A PROCESS IS AN ALLOCATION, AND IT IS THE ONE WITH NO NAMED MAX.**
Elder [shelved](archive/20260910-141541_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY**, rota row 1: Tally bounds a dependent's memory at **256 bytes**,
Caravan its live population at **4** and restarts at **5**. The count of programs a run starts is
named nowhere.
**MY OWN FALSIFIER, RUN:** `--every 17`, fourteen guards, pooled **6.38 ms per process**, inside
the 6-to-10 band the elder paper named. Thirty guards now read **24 between 1.10 and 12.96** and
**6 between 53.49 and 311.23**; the empty band fell 6.5x to **4.1x**.
**BUILT:** `tools/fixtures/g/guard_cpu_census.sh` -- line two of the POSIX `times` builtin, so
`sys_share = sys/(user+sys)` costs one shell wrapper where strace costs ptrace. **17 guards, 686.8
CPU s, kernel share 0.380**; six carry both readings and the orders agree but for one adjacent
swap, compute **at or under 0.175** and process-bound **at or above 0.302**. A count ceiling would
red on a peer's lawful file, so the bound wants a RATE per item.
**PAPER:** `external-research/20260910-135837_the-one-allocation-nobody-bounded.md`, A/90.
**MY COLD OPEN VOIDED ITSELF** -- I wrote while it digested, the second lap running -- yet it read
one real red first: **`stash_record unlanded=1`**, stash@{0} holding a whole DIFFUSER lap of 13:39
with `convergence_census` rebuilt resident. **NEXT LAP FIRST.**
**YOURS:** whether Tally names `max_wakes`; counted or enforced; over Caravan or the roster.
**PETRICHOR -- THE ROOM MAP.MD SENDS A NEWCOMER TO WAS HELD BY NO REGISTER METER.**
Elder [shelved](archive/20260910-142031_itinerary-landed-accounts.md).
**EARTH BREATHES IN**, advanced by hand past a row four ships read today. The doorway census this
card twice called a regrowing wound reads **3 of 3**, all testimony -- **alarm closed.**
**THE GAP SAT ONE ROOM OVER:** `DOOR` named `docs/README.md` alone and the teaching glob reached
`docs-geode/` and `manual/` past the other fourteen -- the room ASCII walled this morning.
**Measured** by the scan's own `measure()`: 11 of 15 clear the floor, **two stand above Field, and
both are pages whose SUBJECT is refusal.**
**PAID IN RATHER THAN RAISED:** **52 -> 29** and **31 -> 27**, six sentences restated, every claim
held; cards **B+ 89**, **A 90**. Tier **66 -> 81**, over **4**, ceiling unmoved.
**THE RESIDUE IS THE FINDING:** the five still counted are the page itself -- ABSENT, the
negative-space assert, the paired refuse, REFUSE. **A ceiling rather than a goal**, second
after `placeholder-ship-names`.
**YOURS:** all fifteen name their room and **none names a setting**.
**PHEROMONE -- THE WIDENING THE ROSTER ASKED FOR, RUN ONCE, FOR THE PRICE OF ONE FILE.**
Elder [shelved](archive/20260910-121514_itinerary-landed-accounts.md).
**`tame_style_rooms.txt` HAS ASKED FOR THIS LAP FOR TWO DAYS AND PRICED IT:** a widening moves
memcpy, parseInt, Ed25519, long-fn and assert counts at once, and a ceiling only falls, so each is
**RE-DERIVED with the reason recorded** -- *one deliberate lap by the hand that owns these counts.*
**Never run**: `lotus` at 240 files and `rye/tests` at 736 ban hits are blocked on its SIZE
rather than the decision. **`brix` can go first**, holding one tracked `.rye`.
**EIGHT READERS REACH THAT ROSTER; ALL EIGHT WERE READ, BEFORE AND AFTER.** bans GREEN to GREEN;
advise 135 / 46 / 1 / 59 / 686, `opening_lines` four, `rune_assert_sweep` 99 / 98 / 6,487 and
`tame_check` four all **unchanged** by it; `tame_reach` **debt_rooms 25 -> 24**, `uncovered_authored`
**553 -> 552**. **FREE in seven, lowering the eighth.** Two stood at their ceilings with **zero
slack**, so each was read BEFORE the roster line was written.
**ONE CEILING WAS SPELLED IN THREE PLACES, found by stepping in it:** the scan's variable, a pin in
the witness, and the witness's GREEN `say` line. The first two red when they disagree; the third says
nothing, so a lap could move the ceiling correctly and still announce **25** under a green witness.
The pin stays -- a ceiling is a decision, not a measurement; the say line no longer spells it.
Today's third count-pin.
**SWEPT ON TOUCH:** three spoken em dashes in `brix/infuse.rye`, one in its witness's `say`, proven
by re-deriving each file from its committed bytes. **rye 3895 -> 3892**, EXACTLY at its ceiling so
the fall takes no slack; **rish 11153 -> 11152**, 80 below on others' slack and claiming none.
**YOURS:** four language reds each end on a seam -- `%680` document-view ordering, `%689` and `%678`
a record-format door, `%532` what declares a desk's kind. **REDS holds 189 bytes**, so this lap's own
row could not be booked; cited by stamp (`20260910.121514`) under rule 4.
**GRASS -- AN ASK LIVES 104 MINUTES ON THE ONE SURFACE YOU READ.**
Elder [shelved](archive/20260910-141655_itinerary-landed-accounts.md).
**AETHER HEARS**, whose threshold asks a lap to record the silences too. My last lap found one --
a header saying its question was *asked on ITINERARY* when the ask was gone. **THE POPULATION:**
`**YOURS` is this front's ask sigil, and every figure here is FREE. **72** asks stand across **54 of
339** shelves. A block's median life on the card is **104 minutes** -- 292 consecutive same-seat
shelf stamps -- and **283 of 292** run under eight hours, so a question written in the night reaches
a shelf before morning. Of the eight living now, **one** was carried forward by its own ship.
**THE MECHANISM IS THE RIGHT MOVE:** `itinerary_account_shelf.sh` takes a block WHOLE so the card
holds under its bound, and the question rides along -- and **nothing under `tools/` read a shelf for
a question**, so the move was silent.
**BUILT -- THE SHELF SPEAKS:** `asks_shelved=<n>` and one `ask: ` line each, bounded 16 x 160 with
`asks_unprinted=` naming the rest; the COUNT reads the whole block first, since a truncating reader
reporting its own truncation is a fault booked here. Shelving my elder block above printed my own
unanswered ask back at me. **PROVEN:** control **30 -> 43 legs, fail=0**, both bounds from both
sides; two mutations bite, and the witness reds on a silenced tool and greens on its return. Header
**C+/79 -> B+/85**. **COLD: 235 green, 2 red, 3 gated, `tree_moved=no`** -- `stash_record`
(petrichor's 11 stashes) and the roster guard that reds because it does.
**YOURS, STILL:** `dated_path` -- move the gate to `lost_promised_living` (**0**), re-asked rather
than left on a shelf, which is the finding wearing itself. **YOURS, NEW:** whether an ask outlives
its block -- a durable open-asks room, or the spoken shelf and a ship's hand.
**INCENSE -- A RATCHET CROSSED, AND THE INSTRUMENT NAMED ITS OWN REPAIR.**
Elder [shelved](archive/20260910-155933_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY** (row 1, hand-advanced past two aether laps): cold open **238 green, 2
red**, the second `standing_equipment` reporting the first.
**ONE REAL RED, AND NO LEDGER ROW IS OWED.** `say_compose_bound` read `deferred_per_mille=538`
against **537** -- an `assert ... else` interpolating a captured `.out` composes into Rishi's
4,096-byte `StrBuf` only ON FAILURE, so the message that cannot be built is the one describing a real
disagreement. **A ratchet turns on touch and books nothing**, and the scan's own door names the
repair: a bare `say scan.out` opens no buffer and can never refuse.
**REPAIRED, 18 SITES IN 4 GUARDS OF MY LANE** -- `rota_declared`, `status_declared`,
`unshared_citation`, `rota_grid`. Each stream is said BARE once ahead of the asserts that judge it,
each `else` plain. `rota_grid` in miniature: one bare say serves **seven** asserts that each carried
their own copy of the same reading.
**538 -> 534**, the value the ceiling was seated from, so its designed 3 per mille of slack is
restored rather than spent. Ceiling **held at 537**: that slack is sized from the measured rate of
ordinary growth, rather than a number tracking the reading down.
**THE PRICED SWEEP LANDED BESIDE IT: law ceiling 14 -> 9.** `--explain` priced the room; the five
cheapest fell for **nine counted words** -- `tame-guidance` 35%, `placeholder-ship-names` 50%,
`remember` 42%, `remember-git-nib` 34%, `session-log-provenance` 34%, all 27-30%, cards **A**.
**ONE PUSHED A FRAME.** `placeholder-ship-names.md` read **C 70** at HEAD, **C+ 75** after the
sweep, so it molted IN PLACE under checkpoint `20260910.155933`: **grade 17 against 11 was the whole
Reach penalty**, xrefs already inside budget, so the repair is splitting alone. Four paragraphs
became seven; it reads **A 92** at grade 9. `claim_preserve` FAILs read by hand, two first-draft
drifts repaired rather than explained.
**YOURS, MEASURED THIS LAP:** the law tier reads `.claude/rules/*.md` and **has never read
`.cursor/rules/*.mdc`** -- 56 twins, **all 54 law pages carry one**, the twin room **20 over the Field
target against the law room's 9**. Sweeping a `.claude` page leaves its twin where it stood:
`azimuth-galaxy-proposal-format` went 63% to **0%** here and reads **70%** there. **Gate %7 is why I
built nothing** -- 38 of 39 pairs differ two ways, so a gate there pushes a lane into the merge that
gate reserves. Counted-never-gated is one word.

**COPAL -- THE COMPARISON WAS WRITTEN ONCE AND SKIPPED ONCE.**
Elder [shelved](archive/20260910-115439_itinerary-landed-accounts.md) whole.
**AETHER HEARS THE PAGE NOBODY ANSWERED**, and my own card named it: `resin_body_proven` stood as
the proof the ferry never called. `resins/` is content-addressed -- a body's FILENAME is the SHA3-256
of its own bytes -- and `ferry_resins` read that filename's LENGTH alone.
**ON METAL `20260910.114040`, in a pen, before a line changed:** one body overwritten to hash
`42cd36cf...` while its name still read `7cab931a...` was carried whole -- `resins ferried count=4`,
`carry complete`, exit **0** -- and then stood in the far home under a name that lied about it,
where the far Return reads it as the file the listing names. Every digest was honest; one body
was not.
**BUILT:** `body_addresses` published once in `amphora/src/main.rye`, borrowed by both readers the
way they already borrow the wreck rule.
**THE FIRST REPAIR WAS A REPORT, NOT A WALL.** Proving as it wrote let two honest bodies reach the
far side ahead of the forgery's refusal -- the lesson `amphora_prove_before_write` seated one reader
over. The ferry proves in **two walks** now, so a refusal makes no far resins directory at all, and
a resin tampered with BETWEEN the walks writes nothing either.
**THE INNER WALL HAD NO LEG, MEASURED RATHER THAN ASSUMED:** removing the writing walk's own check
left the witness GREEN -- the two walls stand in series and the outer answers first. Shipping it so
would have repeated the fault this lap closed. `AMPHORA_CARRY_SKIP_PROVE` declines
the first pass so the second answers alone -- it forges nothing, the shape
`AMPHORA_CARRY_TRUST_DOCK` already holds here. Each wall removed in turn, its named leg watched to
fall, welcome shown returning.
**`amphora_ferried_body_proven` tier lap**, 4 legs both ways; roster **22 guards, 20 lap**,
`readme_unnamed` 0.
**SWEPT ON TOUCH:** 30 em dashes out of `src/main.rye` -- 26 spoken diagnostics, 4 trailing comments
-- ceilings lowered by exactly what fell, **3895 -> 3869** and **1311 -> 1307**. The vessel HEAD's
own em dash STAYS: those bytes are a data format rather than a spoken line, and moving them moves
every poured vessel.
**MY COLD OPEN WENT VOID BY MY OWN MID-RUN WRITES** -- I edited a tracked file while it read, the
third such firing on this card today counting Diffuser's two. The hot pass is the reading that
counts.
**RECOVERED `20260910.130000`** from `stash@{0}`, parent = HEAD, applied whole; 15 amphora
witnesses and four gates re-proven GREEN. **Second dead send in two laps -- and the runs ledger
named WHICH round:** `ran amphora_ferried_body_proven ... absent`, a guard the roster held at that
pass's launch and lacked at its close, so `standing_equipment` read `roster_broken` and pointed at
the stash, where `stash_record` says only that SOME round is.
**YOURS, KEATON -- THE LEDGER IS STILL FULL.** REDS reads **40,771 of 40,960**, so this row **could
not land**; cited by stamp (`20260910.115439`) under rule 4. A raise, or your word.

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
| `20260910.141741` | A row read OPEN after its own repair | [log](../session-logs/date/20260910/20260910-141741_the-row-that-read-open-after-its-repair.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
