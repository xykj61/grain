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

**Git nib:** `2f1602bb1f` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A REFUSAL THAT NAMED ITS LEG AND DISCARDED ITS TOOL'S SENTENCE.**
Elder [shelved](archive/20260910-210133_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4): the concrete fact at the door before the argument.
`%700` ends on *the cause is inference, never observation*, and one unnamed mechanism is why.
**READ THE WITNESS:** all five bindings of
`mantra_recall_tablecloth_query_wire.rish` assert `.ok` and mention neither `.out` nor `.err`.
Rishi captures both and the interpreter drops them, so a fortnight of flaps left a sentence naming
which LEG refused and nothing of why.
**MECHANISM:** `shim_reason` grows a **fourth reading**, one awk pass -- a
`run` binding asserted on and reported nowhere: no anchored `say var.out|err`, no
`${var.out|err}` outside a comment. The repair interpolates into the `assert ... else` message,
proven on metal over an exit-3 command, so the reason travels only on refusal.
**MEASURED:** **7,110 bindings in 1,699 of 2,485** tracked `.rish` sources, **953 rostered across
170 of 326 guards** -- a RATCHET both sides: a gate at zero reds every lap on a tree no lap can
repair. Ceiling opens at **948**; the motivating witness moved in the same commit.
**THE PARTITION IS PROVEN:** a binding saying its run LATE stays `late_say`, uncounted here, so
one fault pays once. **Control 128 cases, 28 repos, 0 failing legs**, both ratchets bitten and
lifted on one plant. **HOT CLOSE 250 run, 247 green, 0 red, 3 gated, tree_moved=no.**
**I HELD STILL BADLY** -- edited tracked files mid-cold-pass, voiding its digest; stopped by pid.
**YOURS:** the cadence clock still turns for nobody -- **`cadence_never_run_here=74`**, 58 when
`%568` booked it. And whether `%700` may be BOOKED on a mechanism repaired while the flap stays
unobserved.
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
**DIFFUSER -- IDENTICAL OUTPUT ON THIS TREE WAS WRONG IN EVERY FRESH CLONE.**
Elder [shelved](archive/20260910-230908_itinerary-landed-accounts.md).
**FIRE SEES** (row 2, past rows 1 and 4): three row-joins in
`reds_spine_derive_scan.sh` spawned one `awk` per row to ask one question of a file already on disk.
Each is ONE `awk` over both files now, maps built in a first pass; classification stays in the shell,
so all 49 `detail:` sentences read word for word.
**FALSIFIER PASSED, both clauses.** `execve` **1,745 to 483**, `awk` **1,258 to 10**, kill line 900;
wall **3.5x**, 14,157 against 4,188 ms in one hour at load 14.2-16.6 -- the fair comparison my last
lap could only report. Control **19 cases, 0 red**; output identical.
**AND THE DIFF WAS A WEAKER PROOF THAN IT FELT.** The draft wrote `NR == FNR`, which partitions two
files ONLY while the first carries rows: an empty first leaves `FNR` at zero, so the second file's
first line is swallowed and the maps stay unbuilt. **This tree can never show it** -- both sides hold
615 rows and always have. A pen can: `reds_ledger_monotone_witness` planted a double-booking with no
anointed ref and read `double_booked=0`. Repaired to `FILENAME == sharedf`; reverting it reds that
witness, and three more mutations bite each gated arm. Five readers GREEN.
[Paper](../external-research/20260910-230908_identical-output-is-not-a-proof.md) **A 94**.
**YOURS, half of PETRICHOR's ask:** 45% negative first draft, **8 of 21 sentences on `empty`**.
Next: the 442 `sed`.
**PETRICHOR -- THE MANUAL NAMES THE CEILING IT IS HELD TO.**
Elder [shelved](archive/20260910-223215_itinerary-landed-accounts.md).
**AIR FEELS** (row 1): my two rooms' fence line. **Twenty living pages declared a style, naming
no setting**; each names one now, by READER rather than number -- the word inserted into the
`**Style:**` line `declared_style_line_of()` already parses (`qa_report_card.sh:181`). **Five stood
above the new ceiling; three came down** -- overview 21->14%, run-record 22->11%, ai-jail 37->30%
by five phrasing sheds, every claim intact. **Two stand named, their negatives being the subject:**
vpn 33%, walking-the-rounds 31%, where **7 of 21 counted sentences carry `never` alone** -- the
house's own `X, never Y`; drop those seven and it reads 21%. [Paper](../active-designing/20260910-223215_the-ceiling-a-manual-page-is-held-to.md), A 91.
**YOURS, two:** whether `never` in a contrast counts (`prose_register_scan.sh:185`), and whether a
routing page earns an xref budget -- the card frees one only under **100 words**, so `get-started`
(373w, 22 links, C+ 78) stands outside.
**PHEROMONE -- A PEDESTAL COUNTING MEMBERS HAS NO CONSTANT TO READ.**
Elder [shelved](archive/20260910-193704_itinerary-landed-accounts.md).
**IT DIED AT ITS SEND AND CAME BACK WHOLE.** The round-open stashed it; this lap popped that
stash, reran both witnesses GREEN, and landed it -- `stash_record unlanded` **1 to 0**.
**EARTH BREATHES IN** (row 4, hand-advanced): the fact at the door, which a placard's number is.
**THE CLASS FROM MY LAST LAP IS CLOSED.** Five desks read a published constant; the **six** left
display a COUNT, which has no `pub const` -- the three fields of `ManifestEntry` ARE the fact.
**MECHANISM:** `tools/fixtures/s/shape_member_pedestal_scan.sh` pairs each desk with a KIND of
member and its declaration -- **struct fields** (`ManifestEntry`), **constructor parameters**
(`tube_manifest.build`, four, where the struct holds seven with its length companions),
**sibling modules** (`glow_*_grant.rye`, `mand_ring<n>.rye`), **refusal sites** (the four
`error.Missing*` of `finish_brush_surface`, which ARE the required pins), **fixture lines**
(`seed-frame.brush`).
**FOUND: four of the six cited no engine** -- two at `docs/TUBE.md`, one a brief, one its own
rings in prose. All four carry a `Source:` line now, and the scan refuses if one goes.
**MY CONTROL REWROTE MY SCAN:** the grant selector ENUMERATED the three molds, so a fourth could
never be counted -- a reading able to answer only its own length, green forever. It names the
family's SHAPE now, and case 8 plants the fourth mold and meets a refusal.
**19 cases, 4 welcomes 15 refusals, wrong=0**, mutation-proven: dropping the names reading reds
one leg, the value comparison six. Witness **9.0s, lap**. Scan B+ 85, desks A+.
**CORRECTED MID-LAP:** I wrote that the last three desks show words. All three show NUMBERS.
`tilak-root-count` already stands on `tilak_root_count_witness`; the other two show a SAMPLE --
`21` for a one-field `@u32`, `1` for the slot that opens Pool -- so neither has an engine.
**YOURS:** whether a sample on a placard wants a guard at all. REDS pin still ~22 bytes free.

**GRASS -- A PAGE SAID THE FRONT DOOR NAMED IT, AND THE FRONT DOOR HAD STOPPED.**
Elder [shelved](archive/20260910-234454_itinerary-landed-accounts.md).
**REDS FIRST, BOTH MINE.** `prose_register` read `door_setting_undeclared`: my `84a0ebc26`
reverted PETRICHOR's landed README Style line, its stash based two accounts back and carrying it
along. `shim_reason` read **949/948** -- the 949th my own `under` binding, asserted on
and reporting nowhere. Both repaired: **18/0/1**, **948**.
**AETHER HEARS** (row 0, least-read today at 16). **FOUND, STANDING EIGHTEEN DAYS:** the Lindy foundation has said since `20260811` that the root README
"leans on this foundation in its opening; this foundation links back." `7191a938b` rewrote README on
`20260823` and the word left it; `follow-our-compass.md` carried the same promise. **Two of the
room's three oldest orientation pages named the front door, and it named neither.**
`foundations_link` reads the links a page WRITES, `foundations_reach` whether the ROOM's index names
it -- neither reads the ROOT door, and no reading treats a sentence as a promise.
**MECHANISM:** `**Front door:**` becomes a declared key, as `**Style:**` and `**Room:**` are.
`front_door_claim_scan.sh` reads it in `foundations`, `context` and `docs`, resolves each link
against the page's own directory, and walls at **zero** every door failing to name the claimant --
by BASENAME, unique under the one-clock law. Causes: `no_target`, `absent`, `no_backlink`. **Opting
in IS the filter.** README names both foundations now, so the claims are TRUE.
**PROVEN:** control **15 legs, fail=0**, three mutations bitten; A 90 / B 83 / B 81. **COLD 251
run, 245 green, 3 red, 3 gated, `tree_moved=no`** -- held still for the pass.
**YOURS:** the population is **two** and opt-in, so a page that ought to declare a door and
declines is invisible here. Whether a reading may infer the claim from prose is yours.

**INCENSE -- THREE PAIRS DRIFTED APART WHILE THE METER WATCHING THEM WAS GATED SHUT.**
Elder [shelved](archive/20260910-202551_itinerary-landed-accounts.md).
**EARTH BREATHES IN** (row 4, today's least-read at 14), so I took the fact at the door:
`rule_twin` read **`cohort_over_ceiling`, 38 against 35** -- red since `20260908`, behind **gate
%7**, unheard.
**MECHANISM:** replaying the scan's own `norm()` over both rule rooms as they stood at `6a2d0c3e9c`
names the three cohort pairs that fell -- `exec-bit` one swept word, `gauge-style` a nine-line
paragraph its twin never received, `placeholder-ship-names` a Radiant pass on one side. **Each is a
lap editing the page its OWN editor reads**, so bringing the `.mdc` forward completes a half-made
edit rather than ruling which sentence is law. **35 again, `verdict=ok`.**
**MY HYPOTHESIS WAS REFUTED BY MY OWN WEAKER READING.** A rules-room link names the room the
READER's editor loads, and that spelling sits in the differing lines of **24 of 48** pairs -- half
the census as noise. At LINE level it is **12 of 1,512**, such a line nearly always differing for a
second reason too. **One pair flipped**, `vocabulary-survey`, a table rule written `|------|`.
**BUILT:** the transform grew **four steps to seven** -- sibling-room link, delimiter run, HTML
entity -- each planted **twice**: the spelling alone, which must read free, and the spelling with a
real change riding the line, which must still bite. **24 legs, `control_fail=0`**, all three
mutation-proven, each biting exactly its own free leg. Ceiling **35 -> 34**. A/90.
**COLD 244/2 red** -- `tracked_link` on my own untracked shelf, closed by staging; `tree_moved=yes`
by my own hand, since I worked while it ran. **HOT 246 green, 0 red, 2 gated, `tree_moved=no`.**
**YOURS, KEATON:** (1) **`cursor_only=2`** -- `arbor-voice` and `fuse-resin-cleanup` are live law
the Cursor bench reads and **no Claude ship has seen**, printed and gated nowhere; mirroring costs
~3 KB on every always-loaded lap of eight ships, so the spend is yours. (2) **44 pairs still drift,
1,500 lines**; reconciling stays your word, and the size is now measurable. (3) Whether a guard
behind a gate should still be **heard** when it reds.

**COPAL -- THE SWEEP YOU ARE HOLDING IS PROVEN TO CONVERGE, ON YOUR OWN TREE.**
Elder [shelved](archive/20260910-214217_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, N=4598): taste works up close, and the row's cardinal seat,
`what-brix-infuse-is.md`, says run it a SECOND time. `infusion(world') -> world'`.
**THE FINDING:** `tools/fixtures/r/rish_spoken_ascii_convert.sh`, the converter I built last lap,
stood in `convergence_census`'s **unproven** column -- **14 candidates, 11 proven, 3 unproven**. I
shipped a writer and never asked it the tree's own question about writers.
**MECHANISM:** a fifth subject in `tools/c/convergence_tree_prove_witness.rish` -- one `run` of
`tools/c/convergence_tree_prove.sh` handed `--apply tools/m/mycelium_chorus_knot_witness.rish`, with
`rs.ok` and `verdict=converges` both asserted. Census reads **12 proven, 2 unproven**;
`proven_by_prover_run` **3 -> 4**.
**WHY NO `--perturb`.** All four prior subjects run in `tools/hooks/pre-commit`, so at HEAD their
work is done and a bare reading answers `inert`. This one is a **sweep** -- **1,501 of 2,485**
tracked `.rish` sources still hold a character it converts -- so the committed tree is its own
sample. The subject also holds **coupled sayings** back, and that set is **derived every run**
rather than pinned, so a first run could hand the second a different derivation. It does not.
**A FALL I GAVE BACK.** The first subject was `tools/gen/chapter/prin_scope.rish`, better at 3
held lines, and naming it reddened `unheard_guard`: `unnamed_choirs` fell **11 -> 10**, because a
path on a non-comment line reads as **heard**. My leg hands prin_scope to a converter **as a data
file** and never RUNS it, and that guard's first line is *a guard that is never run guards
nothing*. I moved the subject and left the count. **A citation-as-data buys a ratchet fall in a
guard whose subject is execution** -- real, and not my lane.
**THE WHOLE SWEEP, RUN RATHER THAN ARGUED:** the same prover over **all 2,485 tracked `.rish` paths
at once** reads `verdict=converges`. Off the roster on purpose -- its `args=` line alone runs 99KB,
and a witness that prints a hundred kilobytes of arguments teaches nothing.
**A QA FRAME CLOSED ON A NUMBER:** the witness reads **C+ 77** and read **C+ 77 at HEAD**; the
whole gap is `named_by_card=no`, which this block repairs.
**COLD 249/243/3 red** -- `index_row_bound` on a peer's two misordered shelf rows, closed with the
repair its own advice names; `unheard_guard` above; `standing_equipment` for both. **HOT 249/246/0,
3 gated, `tree_moved=no`.**
**YOURS, KEATON:** the tree-wide `.rish` sweep still waits on your word, and it now carries a
convergence proof on your own tree rather than on a pen. The argument against it is unchanged --
**92 `.rish` files touched per day by eight ships**, so the rebase cost lands on peers.
**Still yours, on the shelf:** the `rish_spoken_ascii` remainder; `reds_fold.sh` and
`bootstrap_wasmtime.sh`, the two candidates still unproven, neither in my lane;
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
| `20260910.204226` | The door that names its own ceiling | [log](../session-logs/date/20260910/20260910-204226_the-door-that-names-its-own-ceiling.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
