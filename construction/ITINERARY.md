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

**Git nib:** `2e04305582` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE FALSE-FUTURE GATE READ A THIRTIETH OF THE TREE.**
Elder [shelved](archive/20260910-210133_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, N=4614): the concrete fact at the door.
**READ THE FACE:** duty 5 printed `HEAD_OK ... -22941s`. Behind passes, so the verdict is right --
yet a head **six hours stale** asked which population made it.
**MEASURED:** `one_clock_mono_scan.sh` built its population from a **flat glob**, and a log is
**born on its day shelf** since `20260827.171500`, so `session-logs/*` flat holds **zero**. It read
**247 of 7,344** dated artifacts, **3.4%**; its sed anchored on the sprig besides, hiding **237**
sprigless files (`%175`).
**PROVEN, ONE FILE TWO PATHS:** a log stamped **four hours ahead** on its day shelf reads
`HEAD_OK`, exit 0; **moved flat**, `HEAD_BAD`, exit 1 -- the path that hid it is the path the law
requires. It survived because both duty-5 fixtures pass stamps through
`ONE_CLOCK_HEAD_STAMPS`, **bypassing the population walk**: predicate proven, reach never.
**THE LOOM HAD THE SAME HOLE:** `dated_spelling` matches **ERE**, `sed` is **BRE**, so every
*extracting* site went free -- duties 5 and 4, caravan's prose meter.
**STANDING:** `find` over folded shelves and `[_.]`; **5.475s -> 0.192s at 30x the population**;
duty 6 is the reach, 7 legs, 2 mutations bitten; the loom reaches both dialects, 3 cases.
Row `20260911.020039`, born on its shelf -- the pin had 481 bytes, the row wanted 2,929.
**REDS FIRST, TWO CLOSED:** `20260910` read **104** in both rosters; its shelf holds **107**.
**YOURS:** nothing. **NAMED:** `session_roster_agree` builds a stale-row report it never prints.
**PATCHOULI -- MY LANE'S DOOR NAMED TEN GUARDS AS "SLC-1 WITNESSES."**
Elder [shelved](archive/20260910-212718_itinerary-landed-accounts.md).
**AETHER HEARS** (row 0, lap 4595, today's least-read at zero), so I listened for *the silence where
a claim used to be and a witness now stands* -- its own phrase -- and found it on `mantra/README.md`,
the door 538 files cite.
**MEASURED BEFORE A LINE MOVED.** The `src/` row gave the **weave the module is NAMED for** one
clause and named its proof `SLC-1 witnesses`, naming no file, while **ten rostered guards** stood
over that room. `Last updated` read `2026-07-07`.
**AND ITS CARD SAID TRUTH=100.** `truth_counted` reads whether cited PATHS resolve, so five links
scored the page perfect while its claims went quiet -- **PETRICHOR's `truth_mode` finding of six
hours ago, in another lane the same day.** Judged, **B 84**.
**FOUR CITATIONS NAMED NOTHING TRACKED**, of 21: three `tools/mantra_recall_*.rish` globs predating
the `20260823.144100` letter-room fold, plus a lab glob. **Nothing could see them** -- `tracked_link`
reads Markdown LINKS, `law_tool_citation` is scoped to `.claude/rules/`, `docs_command_path` passes
an absent path FREE on purpose. INCENSE's class. My first census called 14 good paths gone: a
backticked path is root-relative OR page-relative, and only trying both tells the truth.
**MECHANISM:** the row points at a new *The Weave* section -- named by a pair, placed by a triple,
parity the tombstone with zero even -- binding each surface to the rostered guard proving it, all ten
GREEN in my own pass. **32 cited, 0 untracked.** Register **26% -> 8%**. **B 84 -> A 91.**
**REDS FIRST, MID-LAP:** the hot pass reddened `index_row_bound` -- two peer rows inverted by a
shared prepend under a rebase. `%440`'s **thirteenth** firing, closed by the one command its own scan
advises; the second red was its `red_self` echo. **Closing hot 249, 246 green, 0 red, `tree_moved=no`.**
**YOURS:** the aether strand says *a guard that cannot red guards nothing*, and **11 of my lane's 31
guards cite no control; 9 of those press no refusal inline.** One sweep, or one per touch?
**DIFFUSER -- A MUTATION THAT DID NOT BITE, AND THE COMMENT THAT CLAIMED IT WOULD.**
Elder [shelved](archive/20260910-230908_itinerary-landed-accounts.md).
**MECHANISM:** the local spine read in `reds_spine_derive_scan.sh` piped each of 440 ledger files
into its own `sed`. `sed` takes many file operands, so the walk is two invocations: paths
accumulate with `set -- "$@" "$f"`, flushing at `MAX_SED_OPERANDS=256`.
**MEASURED:** `execve` **483 to 45**, `sed` **442 to 4**; wall **3.4x**, 3,021 against 896 ms,
five runs each ALTERNATING at load 9.4-10.3. Two laps: **14,157 ms / 1,745 to 896 / 45**.
Byte-identical output. Five readers GREEN.
**THE FALSIFIER FIRED:** three new control legs, each mutated -- **11 of 24 cases** fell when the
flush went, **1** on a word-split operand list, **0** when the `if` became a trailing `&&`. That
third comment claimed `set -e` would kill the script; on metal a false AND-list returns 1 and runs
on. The leg proves the row count rather than the exit status.
**ALSO CLOSED:** `prose_register` refused at `door_setting_undeclared=1` -- the ROOT `README.md`
named no **Door** setting. PETRICHOR repaired it the same hour; I took their wording on the rebase.
[Paper](../external-research/20260911-001648_the-mutation-that-did-not-bite.md) **A 92**, 25%
negative after a sweep from 34.
**YOURS, three peer reds measured rather than claimed:** `shim_reason` **949 against 948**,
`standing_equipment` behind it, `dated_path` **96 against 85** -- all read the same with my changes
stashed.
**PETRICHOR -- A PEER'S REPAIR, REVERTED BY A COMMIT WITH NO BUSINESS THERE.**
Elder [shelved](archive/20260911-000651_itinerary-landed-accounts.md).
**REDS FIRST:** cold read `prose_register red`, `door_setting_undeclared=1` -- **`README.md`**,
the one door of nineteen naming no ceiling. **It had named one:** `570526cad9` landed it and
`84a0ebc26` rewrote it back on a stale tree. Restored, **1->0**; row (`20260911.000651`). **TWO
LINES MOVED THERE, ONE HEALED:** a hook rewrote the count next commit, the clause waited three.
**AETHER HEARS** (row 0). **MY SHELF SAID THE SAME NOTHING:** of `docs-geode`'s 47 pages, **23 carry
a Style line, 7 named one**. Sixteen name one now by READER; **two above Door were SWEPT**, `sangha`
27->17%, `pleac` 27->18%. The libraries index declares Door in its **EMITTER**: a hand-edit expires.
**TWELVE backticked `../` depth errors REPAIRED**, unread. [Paper](../active-designing/20260911-000651_the-front-door-that-named-no-ceiling.md).
**HOT 251 run, 246 green, 2 red** -- `shim_reason` 949/948, twice.
**YOURS:** a wall there -- mine, or `law_tool_citation` wider?

**PHEROMONE -- ONE DESK'S ARITY IS WRITTEN IN THREE FILES, AND NOTHING COMPARED THEM.**
Elder [shelved](archive/20260910-225815_itinerary-landed-accounts.md).
**AIR FEELS** (row 1, hand-advanced): walk the fence line, press every post. **REDS FIRST:**
`index_row_bound` -- two shelf rows misordered, repaired by `index_shelf_repair.sh`.
**THE POST THAT GAVE.** A desk's sample count stands in **three** files -- its `::  Sample:` head
line, `glow_run_worker.sh`'s accepted counts, and the argv gates `glow_run --sample-argv` emits.
Only the third is derived. `%532` repaired two of the desk room's
three enumerations, named arity as the one left underived, and **predicted the fourth in its own
words** -- a sampled desk needs a chosen value "and then a fourth hand-written enumeration to hold
the answers." The `Sample:` line is that fourth.
**MECHANISM:** the worker stated arity only as the shape of what it refused -- a nest of
`test "$NARGS" -eq N`. `arity_accepts()` states the counts once, the membership test is the whole
check, and **`--arity` prints that same list**, so a meter asks the worker rather than parsing it.
`tools/fixtures/g/glow_desk_arity_scan.sh` compares all three; four readings gated at zero.
**MEASURED `20260910`: 46 sampled desks, three statements each, ZERO disagreement** -- the same
perfect agreement `%532` found among its own three, and stored in nobody's instrument until now.
**THE ARITHMETIC THE GATES REST ON:** a tag desk's emitted program checks `argv.len < 2` for the
tag and `< 3` inside the mint arm, so the reading takes the **maximum**; the first gate calls four
real desks split when nothing is wrong, and that mutation reds three control legs.
**PROVEN:** witness `glow_desk_arity`, `tier lap`, **9s** -- the sibling that RUNS these desks
costs 325s of Zig. **39 control legs, 0 failed**, every refusal planted and lifted. `glow_desk_run` **347 desks GREEN** through the refactored worker, and
`glow_desk_reach` GREEN beside it. Scan B+ 87, control A+, worker A+.
**YOURS:** the worker demands an exact count; the emitted program demands a **floor** and ignores
anything past it. Two shapes of one boundary -- worth a gate, or is the worker's exactness enough?

**GRASS -- THE EXEMPTION STOOD OVER THE PAGES A READER MEETS FIRST.**
Elder [shelved](archive/20260911-022523_itinerary-landed-accounts.md).
**REDS FIRST, TWO CLOSED.** `log_has_a_row` read `pin_count_drift` -- both rosters said 104 laps for
`20260910` where the shelf holds **107**. `stash_record` read `records_unlanded=1`: a GRASS lap of
`20260911.013618` killed mid-send, recovered and re-proven at **75 legs**.
**EARTH BREATHES IN** (row 4, lap 4614).
**FOUND:** `two_rooms_doorway_scan_one.sh` passes any stampless basename as **grandfathered**. The
mark law reads that absence the other way -- *a stamp means testimony; everything else is living*
-- so it freed `context/LEXICON.md` and the `manual/` guides, and gated
three dated pages nobody may repair. **1,254 pages, 138 stampless, 106 naming no room**
against a dated 3; the roster's own `manual/ 0 silent` held over the population it could see.
**THE LAW'S OWN DOOR WAS AMONG THEM:** `context/TWO_ROOMS.md` quotes both key names in its `Last
updated` line and the reading kept the first line carrying them anywhere, so the law read silent
three lines above `checkable-room canon`. A key's own line is preferred now; the anywhere match
stays the fallback 92 header rows need.
**MECHANISM:** `names_room()` states the token test once for both branches; the scan prints
`stampless=` and `living_silent=` under their own ceiling; the roster drops 21 day-shelf indexes.
**MY FIRST DRAFT READ 122 SILENT DOORS WHERE 3 STAND:** `grep ... | head -1 && return 0` binds `&&` to the pipeline, whose status is `head`'s -- caught by the number, never the diff.
**REPAIRED 16 DOORS**, so the ceiling opens at **90**. **PROVEN:** 70 behaviors over 70 readings,
+10 legs, three mutations bitten.
**YOURS:** the 90 -- 33 `active-designing`, 23 `context`, 20 `manual`, 9 `docs-geode`, 6 silo, the
last two PETRICHOR's. And whether a living door should end up GATED.

**INCENSE -- A METER KNEW A LAW WAS UNREADABLE AND WOULD NOT NAME IT.**
Elder [shelved](archive/20260911-001547_itinerary-landed-accounts.md).
**FIRE SEES** (row 2, N=4607, unread today): the ledger first. Cold **246/3/2**, the third
`red_self`; **HOT 249 green, 0 red, 2 gated, tree unmoved.**
**(1) `prose_register` refused `door_setting_undeclared=1` on the ROOT `README.md`.**
`declared_style_line_of()` reads only the FIRST PHYSICAL `**Style:**` line and this one wrapped,
so the word had to land on line 23. **18/0** -- **and a peer landed the same repair while my hot
pass ran, so theirs shipped and I took it.**
**(2) `shim_reason` refused 949 against Bakery's 948**, `law_guard_heard_witness.rish` landing
after it with one binding of the old habit. Its `list` mode named it: `under` at line 76, a refusal
leg whose two `else` messages said what was wanted and nothing of what the scan answered. Both
carry `${under.out} ${under.err}` -- **949 to 948**, ceiling unmoved, proven on metal over an
exit-3 run. **A peer landed `${under.out}` alone; the rebase kept `.err` beside it.**
**MY OWN OPEN ASK, HALF WRONG.** I called `cursor_only=2` *printed and gated nowhere*. It **is**
printed -- a bare number, where `arrival:` and `absent:` print members. **A count says a law one
bench cannot read exists; a name says which.**
**NAMED: `arbor-voice` and `fuse-resin-cleanup`.** The first governs every `.arbor` voice tile and
**three stand tracked in `arbor/`**, so a Claude ship editing one has no rule. `claude_only` reads
**0** -- the second reason to print members, a bare zero reading like a wrong room.
**PROVEN:** three legs, **27 cases, `control_fail=0`**, both mutation-proven. **AND THE PEN IS
HEARD:** `control_fail=0` reads alike over a leg that FAILED and one DELETED, so the witness pins
`control_cases=27` -- proven by deleting leg 3, the leg no assertion names: 26, the pin reddening
alone.
**YOURS:** whether either Cursor-only rule is **mirrored** -- a `.claude/rules/*.md` page loads
every lap of eight ships, so ~3 KB x 8 is yours. **44 pairs drift, 1,500 lines.**
**COPAL -- A RISHI GUARD'S SENTENCE IS ALSO A WIRE, WHICH IS WHY NOBODY SWEPT IT.**
Elder [shelved](archive/20260910-190809_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, N=4589): read the fact off the instrument's own face before arguing
with it. `rish_spoken_ascii` is the tree's largest non-ASCII residue -- **11,072 characters across
1,505 files** -- and its ceiling had fallen **two characters in three days**, both on touch. Its two
siblings were swept to zero. **It had no converter, and its table had one row fewer than the law.**
**THE MINUS ROW, the same disagreement one instrument over.** `.claude/rules/ascii-first.md` has
spelled the typographic minus since seating and `ascii_document_scan` carries the row; this meter
filed **103** of them under `notation`, which MEANS *a reader must choose*, about a form the law
answers one way. Split **10,707/365 -> 10,810/262**, total unmoved, since a classification fix moves
no character. **Its two spoken siblings carry the same gap and are named rather than swept.**
**WHY THE SWEEP HAD NEVER RUN, measured rather than guessed.** Rye's `print` and Glow's `::` speak
to a person and to nobody else; a Rishi `say` is **also a wire between guards**. **164** counted
characters sit in assert CONDITIONS, 126 matching a Rye binary's `selftest.out`; and **101 spoken
lines are coupled** to a matcher elsewhere. Real on real bytes: `oven_handback_surface_p39_witness`
greps `prin_scope.rish` for `'oct:   Oven Chapter -- PAUSED'`, so a blind `sed` reddens a guard by
repairing a dash.
**BUILT:** `tools/fixtures/r/rish_spoken_ascii_convert.sh`, card **A 91** -- deriving its **576**
-literal coupling set every run rather than pinning a list that drifts the first time a sentence
changes. **PROVEN:** control **22 -> 37 legs**, every converter leg read off the BYTES rather than
the report, the pen's residue asserted EXACTLY at five characters each with a nameable reason.
Witness **31 affirmative, 5 refusals**, 15.4s, `tier cadence`.
**PAID:** `parity_ch01` and `parity_ch02` swept, **567 characters**, both **RE-DERIVED from their
committed bytes** so nothing but a spoken line moved. Reading **11,072 -> 10,505**; ceiling
**11,152 -> 10,585**, keeping the 80 of slack it stood on and taking none of the 567.
**COLD 245/242/0, 3 gated; HOT 245/242/0, 3 gated, `tree_moved=no` both** -- 245 guards read the
swept tree and not one of them lost a match.
**BOTH SWEPT SUITES WERE ALREADY RED, on a cause I never touched:** `pond_build_drawn_terminal.sh`
answers `verdict=gated_no_display` -- a Wayland application on a headless pier -- and both callers
read that GATE as a build failure. Proven by running the underlying witnesses at bytes this lap
never opened. **`%646`'s class**, beside Patchouli's eight wire labs; neither suite is rostered.
**YOURS, KEATON -- the tree-wide sweep.** **1,502 files, 10,543 characters**, one command now.
Against it: **92 `.rish` files touched per day by eight ships**, so the rebase cost lands on peers
rather than here. Its guard is `tier cadence`, so one lap in five hears the ratchet at all.
**Still yours, on the shelf:** the `rish_spoken_ascii` remainder above;
Meter SCORE for a program; `%456`; `%460`; `%360` **674**/**1,093**; `glow/rune_shape.rye`
width; `%281`/`%291`; `%347`.
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
| `20260911.003300` | A tier of 74, one run row | [log](../session-logs/date/20260911/20260911-003300_a-tier-of-seventy-four-and-one-run-row.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
