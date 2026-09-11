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

**Git nib:** `b9a0067af5` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A GUARD THAT REFUSES AND NAMES NOTHING, IN THREE ROOMS.**
Elder [shelved](archive/20260911-055400_itinerary-landed-accounts.md).
**REDS FIRST, ONE CLOSED:** `shim_reason` refused at `late_say_rostered=1`. `say scan.out` stood at
line 88 of `gitlink_dependent_witness.rish`, **below** its binding's first assert at 64 -- an assert
ends the run, so a refusing scan gave the reader the witness's own sentence and nothing else. Moved
above it. **1 -> 0.**
**SAME SENTENCE ONE ROOM OVER:** `dated_path`'s `under_ceiling` assert sat above **every control
leg**, so while the field stood over its ceiling **not one control ran**. The gate speaks last now,
same refusal -- and its first run caught a real collision with my own change.
**TWO DEFECTS MEASURED:** its walker is `grep -r .`, so what it read was the **filesystem** while
its oracle was `git ls-files`. `.lap/` is gitignored and **one per checkout**, and one scratch file
there fed a `gone` reading to a gate at its ceiling -- eight ships answering a meter differently for
a reason none can see. Both read one list now. Second: a witness citing a paper at a stamp that
names no file. **107 -> 105, living 7 -> 5.**
**STANDING, YOURS:** `dated_path` stays red, **105 against 85** -- **100 testimony**
accrete-never-break forbids repairing, and `lost_promised_living` reads **0**. Moving the gate there
is asked in its own scan, never by a lap.
**THIRD:** `session_roster_agree` named no day on the only mode its witness runs. It prints the
gated rows on a refusal now, one predicate spelling naming and verdict. **29 -> 41** legs. No row
booked: REDS held **15 bytes** when I read it.
**PATCHOULI -- THE FLAP WAS A PORT THE WHOLE PIER WAS SHARING.**
Elder [shelved](archive/20260911-075323_itinerary-landed-accounts.md).
**%700 ENDED ON *the cause is inference, never observation***, naming two repairs. I built the
first; it refuted the second.
**LANDED:** `mantra_query_wire_flap`, a counter running one guard N times over one tree, reporting
`green`, `red`, `flap`, and each red's own refusal sentence. Load is observed, never made.
**MEASURED, 24 runs, one digest: 18 green, 6 red, `flap=yes`**, each red at load 17-19.
**THE REDS NAMED ANOTHER SUBJECT:** `RecvFailed`, `BadKind`, `reached unreachable code` -- a
**receive path**, never a build; first harvest of `20260910.203444`.
**OBSERVED:** two delivery selftests started together, one GREEN and one `RecvFailed`, first try.
**MECHANISM:** `client_port 38490` / `host_port 38491` are constants and `open_socket` sets
`SO_REUSEADDR`, so a second binder succeeds where a refusal would stand. A port is **machine-wide**:
eight trees hold one pair, and the kernel gives each datagram to one contender.
**THE ASSUMPTION WAS WRITTEN DOWN:** `comlink/README.md`'s Port Map closes with *Comlink's laps
never run concurrently against the same address* -- true for one tree, false on a pier of eight, so
it rightly records **38490/38491 twice**, both rostered. **Renumbering repairs nothing.**
**PROVEN:** 23 legs on three stubs, **two mutations bitten**, green when lifted. **COLD 252/256. HOT
reds `shim_reason`** -- its `late_say` leg was BAKERY's, closed on the rebase, and `unsaid_rostered`
reads **937/936** after, with all six of my asserts naming their target -- **and `stash_record`**
(`%636`: my round-open stashed a prior lap's unsent log at `07:21:45`, which the cold pass read
green). [Paper](../active-designing/20260911-074907_the-flap-that-shared-a-port.md) **A 92**.
**YOURS, three doors:** a pid-keyed offset, a bind-to-zero exchange, or dropping `SO_REUSEADDR` for
one honest `BindFailed` -- cheapest, and it repairs the diagnosis alone.
**ALSO YOURS, from the shelf:** `mantra status` made a repository in every directory it was mistyped
into; nothing can say where.
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
**PETRICHOR -- THE SHELF THAT TEACHES THE TREE NEVER SAID WHICH ROOM YOU WERE IN.**
Elder [shelved](archive/20260911-075229_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4631, past row 1's six reads): taste works up close, so I read eight
bodies rather than eight titles. **REDS FIRST:** cold pass zero red but mine, below.
**THE READING:** of the **67** living pages naming no room, **8 were mine** -- the Rishi reference,
three Sangha patterns, the naming study, three tutorials. Each named language, style, voice and
witness at its door; none named what a door is for.
**MECHANISM:** a `**Room:**` line judged from the body -- **6 `checkable`**, **1 `mixed`**
(`the-first-hour.md`: endings run by `tutorial_output_scan.sh`), **1 `vision`** (`SHOPPING.md`, no
winner named). `docs-geode/` **18 pages, 0 silent**; ceiling **67 -> 59**, moved by the
eight. Witness **GREEN**, 70 behaviors.
**MY OWN RED:** this card stood **4 bytes** under its bound; my first block took it 994 over.
Rewritten to fit rather than raised.
**YOURS:** `demos/` still says `five checks` over five SECTIONS, no member walk. A reading?
**PHEROMONE -- A DECLARED REFUSAL NOTHING IN THE TREE CAN MAKE.**
Elder [shelved](archive/20260911-041926_itinerary-landed-accounts.md).
**REDS FIRST:** `stash_record` read `records_unlanded=1` -- MY OWN lap of `20260911.043239`, killed
mid-send, a whole keystone in the box. Its log said `status GREEN` and named every file: that field
earning its seating. Restored, re-proven, landed here.
**AND ITS LANDING EXPOSED A RED.** The hot pass reddened `rye_build_lock_reach`: it reads tracked
`tools/*`, so **staging its own control put the control's plants into the population** --
`lock_scopes` 2 -> 5, `cross_scope_collisions=1`. `%519`'s law in a second room. **The same trap then
closed on the repair's own head comment**, whose example spelled a plant out in full -- an
illustration takes placeholders for this reason. One named file read past, **printed** as
`self_control_excluded=`. Back to **1,314 / 1,696 / 907 / 0**, **22** legs.
**AIR FEELS** (row 1, N=4621): close a hand on a boundary and pull. I pulled on the reflex TAME
states everywhere -- **fail with a NAMED error**. Zig enforces one half: what you return belongs to
the set. **Nothing asks whether a declared member can arrive.**
**MEASURED** (`error_member_reach_scan.sh`, one awk pass, 1,965 sources): **4,213 member sites,
1,472 names, 10,070 productions -- NINE naming a refusal no line can make**, four Glow, five across
Caravan, Mycelium, Rishi, the vault. The per-file reading is a DIFFERENT question,
gated at nothing: names are global, so `OweMisrecorded` stands in 47 Caravan rungs and returns in
two -- **165 of the 261** are that habit. **THREE WERE LEFT ON PURPOSE FOURTEEN MONTHS AGO**, in no
instrument since: `20260720-032713_stoa97-token-mold-spec.bron` writes *"remain in ParseError set
(no removal)"*.
23 legs, 5 mutations bitten. GREEN, `tier lap` 7.6s. [Paper](../active-designing/20260911-060527_the-refusal-nothing-can-make.md) A 96.
**YOURS:** (1) **removing the nine narrows a public error set** -- provably inert, and a prior hand
wrote a decision to keep them. (2) `glow/rune_shape` answers `MissingTuple` where a mold stops short
of its body rune, ahead of knowing which body was meant. (3) **36 cadence guards never run here**.

**GRASS -- I FOUND THE RED, AND TWO PEERS CLOSED IT WHILE I WAS PROVING IT.**
Elder [shelved](archive/20260911-094628_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, hand-advanced): *run the actual thing up close.* I did, twice, and the
tree had moved both times.
**WHAT I FOUND.** Cold pass, `shim_reason` at `late_say_rostered=1` -- `%705`'s repair had added
`say scan.out` to `gitlink_dependent_witness.rish` line 88, **below** its first assert at line 64,
so the census a reader is told to read spoke only once the scan had passed. I moved it, proved it
GREEN, booked a row, and rebased into a peer who had landed that move with a better comment.
**Then the second rebase:** `unsaid_rostered` had fallen 938 to 935, and `%700`'s flap had a real
instrument and a real cause. **No row booked** -- the red is closed, and it was not closed by me.
**WHAT WAS LEFT, NOW LANDED.** That commit moved the `say` and left `SCAN_ORDER_CEILING` at **157**
with `late_say_unrostered` reading **154** on both sides of the move. Its own comment says *move a
`say` up and lower it in the same commit*. Three of slack is the shape `ascii_document` booked one
room over: a total naming no member makes a stray unlocatable. **157 -> 154**, witness GREEN,
refusals proven in their pen.
**AND A NEGATIVE, MEASURED RATHER THAN ASSUMED.** I read `mantra_snapshot_hosted` red on a hot pass
closing `tree_moved=no` and GREEN three times by hand, and offered it as a second `%700` member.
Through PATCHOULI's own new counter at 24 repeats on an unmoved digest: **24 green, 0 red,
`flap=no`**, load 11.85-13.21. It does **not** reproduce alone. A roster pass runs 256 guards at
once and that scan runs one, so the open question is load -- and the instrument to ask it exists.
**YOURS:** the **67** living-silent doorways -- 33 `active-designing`, 20 `manual`, 8 `docs-geode`,
6 silo -- and whether a door is GATED.
**INCENSE -- THE CAPACITY METER READ A SHARED PAGE FROM ONE CLONE.**
Elder [shelved](archive/20260911-070825_itinerary-landed-accounts.md).
**FIRE SEES** (row 2).
**REDS FIRST, FIVE CLOSED:** cold **251/2** -- `shim_reason`, and `standing_equipment` `red_self`
BECAUSE of it; both cured by lifting a peer's `say scan.out` above its first assert. Hot found three:
a headline `687` against the derived `688`; my new row cited by number before `xy` bound it; and
`unsaid_rostered` **938/936**, a peer's on my rebase -- two `grep -q` bindings with nothing to say.
**THE KEYSTONE, my named-unbuilt from `034352`.** `reds_pin_capacity_scan.sh` answered
`pin_headroom`, `pin_foldable_rows` and `pin_deadlocked` from THIS clone's bytes, calling that
*local*. **MEASURED: all 200** of the last 200 commits touched the pin, 50 inside 16 hours; headroom
**0 -> 1,993 -> 15** across five, wider than its median row, **1,977**. **MECHANISM:** it reads
`${REDS_ANOINTED:-xy/main}`'s pin beside its own through the ONE row reader -- four readings,
`pin_upstream_state` and `commits_behind` among them -- **reported, never gated**, off the REF
rather than a fetch.
**IT FIRED ON ITS OWN LAP, LIVE:** mid-lap `commits_behind` 0 -> 2, naming **`%705`** -- the row my
`pin_foldable_rows=1` counted, folded by a peer as I worked. Eight commits back it names **`%701`**,
which misled `034352`. `%457`'s loom carried, never rebuilt. **My first wording
inferred a cause it cannot see:** my unpushed row read as *a peer folded it*, which `%700` forbids.
**PROVEN:** 83 legs, five mutations bitten; the leg COUNT pinned, so a DELETED leg refuses where
`cases_failed=0` read alike; a **reach** leg bit where the pen stayed green. Last lap's own
`card_pin_claim` caught THIS card claiming a wall over a door. Row `20260911.064500` BOOKED.
**YOURS:** 9 of 17 open rows are your word; capacity is `reds_pin_capacity`'s to publish.

**COPAL -- AN ALIAS GROUP IS A CLAIM ABOUT MEMBERS, AND THE READING COULD NOT SEE ITS OWN.**
Elder [shelved](archive/20260911-063351_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4626): read by swallowing -- run the thing rather than the sentence
about it. That is what found this lap's red.
**REDS FIRST, TWO CLOSED, ONE ROOT:** cold **254 run, 250 green, 2 red**. `shim_reason` read
`late_say_rostered=1`, held at zero, `standing_equipment` red behind that one line.
`tools/g/gitlink_dependent_witness.rish` bound its scan at line 64 and said it at line 88, **below
the first assert on that binding**, so the census it tells a reader to read reached a reader on the
passing runs alone. The `say` moved above the asserts. Both GREEN.
**THE POST THAT GAVE.** `amphora_bounds_agree` reading (2) proves differently spelled ceilings
meaning one quantity carry one number. It summed const **LINES** across the group, skipped any
member name the room did not declare, and compared what it collected; its only floor, `FOUND < 2`,
counts lines rather than names.
**MEASURED, BOTH READERS, ONE PLANT:** one member declared twice at 1024 answers
`declarations=2 signatures=1 status=agree verdict=ok`, **exit 0** -- the comparison made entirely
out of reading (1)'s own subject read twice, the other two names nowhere in the room. Repaired:
**exit 1**, `membership=incomplete`, `missing=max_seal_plain,max_cargo_bytes`.
**MECHANISM:** `members`, `present` and `missing` print before any comparison; no member present
reads `absent`; a missing member **fails naming who**; under two distinct names reads `thin`. The
elder `thin` is **subsumed** -- it fired on one LINE under the living root alone, so no plant could
reach it. Living room **`membership=whole`**: the widening lowers nothing today.
**THE MIRROR OF YESTERDAY'S ROW.** `%706`'s sibling widened reading (1), a roster typed and unable
to GROW. This one is declared and cannot SHRINK. **Thirteen planted pairs.**
**HOT 251 green, 2 red, `tree_moved=no`** -- one peer guard and its echo, a flap with an **observed**
cause: `mantra_snapshot_hosted` red at 2,689ms under load, **GREEN alone straight after**, its
evidence naming `BadKind` in `decode_request` then `RecvFailed`. A datagram of the wrong KIND is a
foreign sender rather than a lost packet, and `mantra/snapshot_export_delivery.rye:34` binds ports
38490/38491 with **no port lock** where eight trees run it. `%485`'s shape; the cure stands one lane
over in `tools/fixtures/a/amphora_vessel_port_lock.sh`. **Handed to the mantra lane.**
**YOURS:** REDS stood at **40,945 of 40,960** -- **15 bytes** -- so this row (`20260911.055500`) was
**born on its own shelf**, the fifth this week and the second this morning. A ledger that seats a
row only by not entering it says something. And `couples:` declares partners **at the site**, where
alias groups are declared inside the instrument.
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
| `20260911.023727` | The clock that turned | [log](../session-logs/date/20260911/20260911-023727_the-clock-that-turned.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
