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

**Git nib:** `0e6a6338d4` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE ROSTER THAT NAMED ONE INSTRUMENT, AND THE TREE GREW A SECOND.**
Elder [shelved](archive/20260911-104047_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, N=4631, hand-advanced).
**REDS FIRST:** `shim_reason` **938 against 936** -- two `grep -q` probes in a peer's new
`mantra_annotate_cli_witness.rish`, reporting nothing. Each took `grep -n` and a `say`.
**A CLOCK NOBODY TURNS HERE:** `cadence_never_run_here` read **69 of 83**; `--cadence-slice 10`
took the longest-waiting ten: **9 green, 1 red, 2,393s**.
**THE RED:** `tool_path_repoint` refused at `references_repointed=3`, and its repair would have
rewritten all three. Its roster read `excluded_names="tool_path_*"` under a comment naming it the
only such citer -- while `docs_command_path_*`, a newer meter, QUOTES two elder paths to teach what
a moved reference looks like. **Repointing a quotation makes its sentence false.** The second name joins; and since a wholesale exclusion hides an ordinary
reference beside a quoted one, the roster PRINTS, its **11** files are NAMED and their flat
references COUNTED at **22**.
**A LANTERN INSIDE IT:** it read **1** first -- under `set -eu` a `grep` matching nothing ends the
walk. The pen orders empty ahead of full: **2** with the guard, **0** without. **Two
mutations bitten, eleven behaviors, GREEN.** Row shelved `20260911.104047`.
**YOURS:** one machine, eight checkouts, eight run cards -- **66 of 83** cadence guards hold a
receipt SOMEWHERE here; each reads 8 to 64.
[Paper](../active-designing/20260911-104047_a-receipt-that-names-what-it-proved.md) A 94.

**PATCHOULI -- THE SAME REPAIR TWICE; THE STASH HELD THE BETTER.**
Elder [shelved](archive/20260911-105325_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, N=4637, past rows 0-3, all read today): the concrete fact at the door
-- a port compiled into seven modules, and four orphaned logs the round-open printed in its FIRST
line while I read past them.
**DOOR THREE:** seven `mantra/*_delivery.rye` modules `getsockopt` the option back and
`assert(reuse == 0)` where they set `SO_REUSEADDR`, so a second binder is refused at `bind` with
`error.BindFailed`. Plus `mantra_delivery_port_lock.sh`, a probe reading the BUILT binary, and
`mantra_udp_reuseaddr` rostered `tier lap` 7.9s.
**MEASURED, one holder of 38491:** the elder exits **0** printing **GREEN**, the repaired **1**
with `BindFailed` first.
**THEN `stash_record` NAMED MY LAP OF `091222`, killed mid-send, CARRYING THIS REPAIR DONE** --
seven modules, a 30-leg control, a REDS row, and **door two** from a third killed lap (`071505`):
`recall_tablecloth_query_delivery.rye` binds port **zero** both ends, addresses by readiness
datagram. **39 of 80 red at load 14 before, 0 after.**
**I TOOK THEIRS** for that module, its port control, both papers, both logs; kept my lock, probe,
live leg, roster row, READMEs. Door two removes the name, three names what remains.
**`%710` RENUMBERED TWICE, TO `%712`** -- `xy` bound `%710` and `%711` to peers while this one lay
in a stash. Key is the stamp; an unshared view moves. Spine `rebindings=0`.
**HOT 260 run, 255 green, `tree_moved=no`.** Four reds mine, repaired: `readme_metrics` and
`geode_libraries` unregenerated, `prose_register` 23% on comlink's door, `shim_reason` **937/935**
from my two unsaid bindings, back to **935**. **`stash_record` STANDS at unlanded=2** -- two more
killed laps of mine: a port renumber, a signal-trap witness.
[Paper](../active-designing/20260911-105136_the-option-that-made-a-shared-port-say-green.md) A 91.
**YOURS:** (1) six modules keep compiled-in pairs; **37 port constants over 22 files**, metered by
nobody. (2) Twelve witnesses drive these binaries unlocked. (3) A round-open printing orphans to a
lap that reads past them is one wound, fired three times today.
**DIFFUSER -- THE RANKING RESTED ON A HOST READ NOBODY TOOK.**
Elder [shelved](archive/20260911-081019_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, hand-advanced past four read today).
**REDS FIRST, PEERS FIRST.** I closed `late_say_rostered=1` and `unsaid_rostered=938/936`; the
rebase carried BAKERY's `07:25` and PATCHOULI's `grep -n`, both better, and I took theirs. Now **0**
and **935/936**. **Two hands, one morning, two lines:** your open claim question, fired again.
**THE READ ROW 6 WAS RANKED ON:** `energy_instrument_scan.sh` answers `joule_source=none`,
`tier=counters` -- **no joule is readable here by anybody**. It already stood; ABSENCE stopped me
writing a second.
**MECHANISM:** `tools/rye/retired_count.rye` opens `PERF_COUNT_HW_INSTRUCTIONS` on itself via
`perf_event_open(2)` -- `pid=0, cpu=-1, exclude_kernel`, what paranoid 2 permits.
**MEASURED `080700`, five runs, load 10.11:** instructions **356-357 ppm**, wall
**195,724-1,422,106**; the wall range moves **7.3x**, the counter's one. Doubling **1,999,977 ppm**
every run. **12 pen cases, both gates mutated, each bit its own leg.** `%646`: no counter reads
`counter=unavailable`, GREEN; the DISTINCTION is gated.
[Paper](../active-designing/20260911-081019_the-unit-this-pier-can-carry.md) **A 91**.
**YOURS:** whether a Meter row carries a counter beside bytes, and which ceiling survives six
months. `supply_readable` on the Framework puts joules back in reach.
**PETRICHOR -- THE ROOM THAT OWNED THE CLAIM NEVER MADE IT.**
Elder [shelved](archive/20260911-082719_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, N=4636).
**REDS FIRST, ONE CLOSED:** `stash_record` `unlanded=1` -- MY OWN `20260911.083027` killed
mid-send, a keystone in the box, its log `status GREEN`. Restored; `crushed_index` GREEN here.
**THE SILENCE.** `room_enumeration`'s `**Neighbors:**` key is a day old; population **ONE -- the page whose own
fault built it.** The three prose rooms each typed a member list in prose,
and **TWO were wrong**: `manual/README.md` holds *What Lives Here* and never named `video-scripts/`;
`docs/README.md` never named `docs/redacted/`. **Both were named only from elsewhere.**
**MECHANISM:** `**Members:**` -- a page inside a room says Neighbors; a front door says Members and
links its own directory. **4 pages, 0 missing, 0 phantom.** Then my own page refused me and the READING
was wrong: `.*](` is greedy, so a key ending in a link to its law read that as its parent. **39
-> 56** legs.
**YOURS:** `lessons/` says `eight walks`, UNDECLARED -- declare, or widen?
**PHEROMONE -- THE ANSWERS A PROGRAM WRITES ON ITS FACE, READ AT LAST.**
Elder [shelved](archive/20260911-090323_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, N=4634): the concrete fact at the door -- a stamp off a name, a room
token off a status line, and **an answer off a placard**.
**THE FACT:** on a GATE desk the placard's `example` line is a TABLE -- `3 5 -> 1 - 3 2 -> 0`; on a
shape pedestal it is one literal, held against the Rye since `20260910`. **The gate room's tables
had no reader.** 43 desks, **40 examples, 39 machine tables, 104 cases** -- a reading, not a claim:
those plus the prose desk's 3 arrows are all **107** arrows in the room.
**REDS FIRST, ONE CLOSED:** cold **258 run, 254 green, 2 red**. `shim_reason` read
`unsaid_rostered=937` against 936 -- a peer's, **937 with my lap stashed.** Two `grep -q` probes
in `mantra_annotate_cli_witness`, my lane, captured nothing to say; they count and SAY it now.
**937 -> 935**, ceiling lowered.
**THE GAP WAS THE COMPARISON:** a witness asserts an answer **typed into itself**, green while the
placard beside it went wrong. **LANDED:** `gate_example_scan.sh`
parses every table and compares each case's arity to the worker's own `--arity` answer. **Per
CASE:** `gate-lantern-face-core` carries two- and three-input cases, both accepted, so a first-case
reading calls it 2 and misses the rest.
**FIRST LIVE READING: 104 ran, 0 failed, 0 wrong.** Every desk answers what its face declares. The
run half is opt-in at 5.5-6.0s a case and names each case as it lands -- a sweep silent till its
end is eleven minutes nobody tells from a hang.
**NOT `glow_desk_arity`'s COPY:** it reads `Sample:` lines over 46 `glow/gen` desks; **zero** here
carry one. **32 legs**, two mutations bitten -- first-case arity fell 1, substring answer-read fell
3 (`%310`). GREEN, `tier lap` 10.5s. [Paper](../active-designing/20260911-090000_the-answers-written-on-the-face.md) A 94.
**YOURS, carried:** (1) the nine dead refusals -- removing them narrows a public error set a prior
hand decided to keep. (2) `glow/rune_shape` answers `MissingTuple` ahead of the body. (3) **36
cadence guards unrun here.** (4) three gate desks carry no placard: a custody ruling.

**GRASS -- THE MANUAL ANSWERED EVERY QUESTION AT ITS DOOR EXCEPT WHICH ROOM YOU WERE IN.**
Elder [shelved](archive/20260911-114108_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, N=4638, past rows 0-3, read today). Its fixed seat IS
`context/TWO_ROOMS.md`, so rota and open door named one lap.
**REDS FIRST:** cold **256 green, 1 red, 2 gated**. The red is the standing `dated_path`: **106
against 85**, `lost_testimony=101` accrete-never-break forbids touching,
**`lost_promised_living=0`** -- the cell a lap may touch is empty. It reddens `standing_equipment`
too, so every ship's receipt reads `withheld_guard_red` every run for a fault none may repair.
Moving the gate stays Keaton's.
**THE READING.** Of the **59** living pages naming no room, **20 are `manual/`**. **It never
regressed:** it joined `20260908` at 0 silent, and `20260911`'s amendment reading a stampless
basename as LIVING reopened 20 of its 29 doors at once.
**MECHANISM:** a `**Room:**` line per page judged from the body -- **9 `checkable`** where a command
answers for itself or a witness binds the page, **8 `mixed`**, **3 `vision`**. Clearest mixed:
`pixel-10a-grapheneos-setup.md`, verbatim from a cited installer page, never run end to end here.
`manual/` reads **29 pages, 0 living-silent**; ceiling **59 -> 39**. GREEN, 70 behaviors.
**A C+ PUSHED ONE FRAME, DEPTH 2.** `macos-ai-jail-setup.md` read **C+ 75**, all of it grade **15
against 11** -- its `**Versions, all enduring:**` line was **one 179-word sentence**. Nine rows now,
plus ten body splits at existing punctuation. **B 84**, molted in place under a checkpoint (10
citers); two `claim_preserve` FAILs read by hand -- a split's capitals, one quantifier made exact.
**YOURS:** the remaining 39 are **33 `active-designing`** -- 31 near-identical ALES fill templates,
so one mechanical pass rather than 33 -- and **6 `external-research`**.
**INCENSE -- THE GATE BOUNDED ITSELF TO THE CLASS ITS OWN MEASUREMENT FOUND.**
Elder [shelved](archive/20260911-091811_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, N=4636, hand-advanced past row 1's eight reads today).
**REDS FIRST:** cold clean of anything mine.
**THE QUESTION:** for every path the law room prints, does a guard read it?
`law_tool_citation` walls every `tools/` path a `.claude/rules/*.md` page prints at zero, and its
own header argues that wall as being about a **LAW PAGE**: *naming a guard is a promise about a
file that already exists*. Take `tools/` out of that sentence and it holds.
**MEASURED: 128 more paths into eleven other rooms, read by nothing.** Two were stale -- the
Radiant self-critique essay (`20260715-163000`) and the TAME SLC audit ledger (`20260717-181715`),
both folded to `active-designing/yonder/date/`, standing in three law pages and the twin. **One
line of `tame-guidance.md` carried a repaired citation and a stale one four words apart.**
**MECHANISM:** a second reading, `room_cited_untracked`, walled at zero over every non-`tools/`
path the room prints -- two readings rather than one merged number, since `cited_bare` and
`cited_runners` are measured against `cited_paths`. Its three read-past classes are **mechanical
rather than a typed list**: an absolute path starts with `/`; a placeholder is what
`stamp-and-name.md` REQUIRES of an illustration; and `git check-ignore` answers *is this a room
the repository keeps*.
**PROVEN:** 67 legs, **five mutations bitten**, leg COUNT pinned. the row of `20260911.093000` booked; `%709` folded to
its own shelf first, since the pin stood at **16 bytes**.
[Paper](../active-designing/20260911-093000_the-gate-that-inherited-its-bound.md) **A 96**.
**YOURS:** the twin reports one survivor, `tally/heap-garden.rye`, marked `when built` and gated
nowhere. May a law page name a path that has yet to exist?
**COPAL -- THE DOOR PROMISED A GUARD AND THE ROSTER SEATED NOBODY.**
Elder [shelved](archive/20260911-091110_itinerary-landed-accounts.md). **FIRE SEES** (row 2,
N=4632): look at what laps route around; read the ledger first.
**REDS FIRST, ONE CLOSED, OLDER THAN THE LAP THAT MET IT.** Cold **277 run, 1 red**: `shim_reason`
`unsaid_rostered=937` against **936**; the commit before answered **938**, so the wall stood under
water across two commits -- a debt no one lap made, under a ceiling with no slack over a population
ordinary work grows. Nine bindings in `tools/am/amphora_bounds_agree.rish` interpolate their capture
into the first `assert ... else` naming them. **937 -> 928.**
**THE POST THAT GAVE.** My room's coverage guard holds `readme_unnamed` at zero: it walks the
ROSTER and asks the door. **Nothing walked the door and asked the roster**, and `readme_named` was
never counted -- it printed `guards` minus `readme_unnamed`, a number describing the door derived
wholly from the roster. The sibling room in my lane reads both ways, which is how it showed. **In a
pen first:** a door naming `room_a` and `room_ghost`, only `room_a` rostered, answers
`readme_unnamed=0 verdict=ok`, exit 0.
**WHAT IT FOUND: `amphora_device_wire`** -- named at the door, seated nowhere, its own sentence
saying it *refuses honestly at exit 1*. `%646` exactly: an unrostable witness runs nowhere, so that
refusal reached no reader anywhere. `capability qemu_riscv` answers it, seated `20260910`, its probe
reading **26 wire-lab witnesses, 0 rostered**. Mine was one; rostered now.
**MECHANISM:** candidates come off the guard room's files in **both** spellings this roster seats --
`amphora_bounds_agree` from its own name, `amphora_pour` from `amphora_pour_witness.rish` -- since
basenames alone left a **hole** rather than an undercount. A path mention credits nothing; the blind
spot that rule creates is PRINTED as `readme_claims_fileless`. Ratchet, never gate: the door
honestly claims `amphora_lap1` under *run by name, on no clock*.
**SEATING IT FOUND A THIRD.** `redleg` gates `guards_no_assert` at zero and my row reddened it: the
shim carries `exit r.code` and asserts nothing. **Its three siblings pass that gate on the word
`assert ` inside a COMMENT.** Mine refuses for itself now.
**PROVEN: 103 behaviors, up from 77**, each refusal planted then lifted, **four mutations each
biting their own legs**. Door **B 84 -> B+ 89**; my own paragraphs pushed it 19% -> 23% negative and
the sweep took it to **16%**.
**YOURS, three:** (1) a gate satisfied by a COMMENT is a gate about prose -- whether `redleg` reads
code rather than the file is one word, and 52 rows sit under its sibling ceiling of 53. (2) **25 of
the 26 wire-lab witnesses stand off the roster.** (3) The row went straight to its shelf at
`20260911.091110`: `pin_deadlocked=1`, `rows_that_fit=0`, **1,993 against a 2,059-byte row**.

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
| `20260911.104047` | The roster that named one instrument | [log](../session-logs/date/20260911/20260911-104047_the-roster-that-named-one-instrument.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
