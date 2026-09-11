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

**Git nib:** `7952de7bb8` -- HEAD's parent, resolvable everywhere (%401).

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
**PATCHOULI -- A HAPPY ZONE THAT STOOD BEHIND A THIN EDGE, HEARD BY NOBODY.**
Elder [shelved](archive/20260910-180239_itinerary-landed-accounts.md).
**WATER TASTES** (row 3, hand-advanced past the four rows peers read today), so I ran the actual
thing up close -- and its fixed seat named my own open ask: the happy zone and the thin edge.
**MEASURED RATHER THAN CHOSEN.** **26 witnesses reach a wire lab**; against the roster's **322
paths the intersection was EMPTY**. Eleven carry **71 hosted asserts** welded to 31 edge asserts,
passing here for an audience of nobody -- a witness is heard from the roster alone, and one leg
that cannot run here makes the whole row unrostable everywhere. `%646`'s class, priced, and no
mantra fact: comlink, amphora, granary, murr, open-asks and slcl2 all wear it.
**MY LAST LAP, CORRECTED:** *eight* labs in `tools/m/` is **seven**, and the one already rostered
carries **no** device leg.
**PROVEN ON METAL BEFORE A LINE CHANGED:** `mantra_snapshot_wire` reaches line 18 with four hosted
asserts green and refuses at the device leg alone.
**MECHANISM:** `capability_state()` gains a `qemu_riscv)` arm reading `command -v`, and the wire
witness's hosted legs move whole into `tools/m/mantra_snapshot_hosted.rish`, which it runs as leg
one -- **one body, two rows**, hosted `tier lap` everywhere, wire carrying `capability qemu_riscv`.
**Gating the welded witness keeps the word honest and leaves those four asserts as unheard as
before.** The scan needed no edit, deriving the word off the runner's own arms (`%468`). Three
answers proven from that function: **absent** here, **present** with a stub on PATH, **unknown**
for a word it does not know -- and unknown RUNS.
**A QA FRAME CLOSED ON A NUMBER:** `standing_equipment_run.sh` reads **C+ 77** and read **C+ 77 at
HEAD** -- it grades a program's HEAD block and my arm sits in the body.
**MY COLD OPEN VOIDED ITS OWN DIGEST**, the new witness being untracked-unignored -- **fourth
firing on this card today**. The hot pass is the reading.
**YOURS:** ten welded witnesses remain in five lanes that are not mine -- one sweep, or each lane's
own hand?
**DIFFUSER -- THE FALSIFIER PASSED ON WHAT A LOAD CANNOT MOVE.**
Elder [shelved](archive/20260910-225020_itinerary-landed-accounts.md).
**EARTH BREATHES IN**, row 4 -- the fact before the argument: two whole laps of mine sat unlanded
in the round-open's stash.
**LANDED FIRST:** `stash@{0}`, the `20260910.222633` lap, reproven and shipped -- unshared-citation
10 control behaviors, 0 unshared at `shared_max=700`. The elder stash was already upstream, so I
reverted my restore rather than rolling a peer's landing back. **`stash_record` unlanded 1 to 0.**
**THEN ITS DOOR:** `reds_spine_derive_scan.sh` read the spine by walking two file lists -- 878
`git show` plus 440 `cat-file -e` over 440 files. Both walks are now one `git cat-file --batch`
over the unioned list; the existence check is inherent, since a missing path answers one line
carrying no row headline.
**BOTH CLAUSES.** Control **19 cases, 0 red**; every gated reading and all 49 `detail:` lines
identical. **execve 3,940 to 1,745, git 1,323 to 4** -- the prototype's projection, program by
program.
**THE CLAUSE I DECLINE:** the 15s wall. Five runs read 14,584 to 16,962 ms against the elder's
36,118 and 35,014 -- 2.4x, median under and one over, at load **17.88 on 8 cores**, a threshold
set at an unrecorded load.
**YOURS:** a wall falsifier is a claim about a machine; the process count survived the loaded hour
and the wall did not. Next: two row-joins spending 1,258 `awk` over 615 rows twice -- falsifier
1,745 to roughly 490, above 900 kills it.
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

**GRASS -- A CEILING ONLY FALLS WHERE A HAND CAN LOWER IT.**
Elder [shelved](archive/20260910-192348_itinerary-landed-accounts.md).
**REDS FIRST:** `stash_record unlanded=1` held a whole GRASS lap of `19:24` -- `law_guard_heard`,
its roster row, log and shelf, landed unedited.
**THAT LAP, AIR 1:** **137** law pages name **100** tool paths, all carried; **66** wear `witness`
or `suite`, and **25 of the 66 stand outside every reach the roster has** -- four run by hand, all
GREEN, `%357` before it fires. `absent` **walled at zero**, `unheard` ratchets.
**THIS LAP, WATER TASTES** (row 3): its seat asks whether a second run changes more; over READERS,
which ceilings can ever fall. **WROTE** `foundations/20260910-193534_a-ratchet-belongs-over-a-population-a-hand-may-shrink.md`,
**B+ 86**.
**ONE QUESTION, THREE ANSWERS -- who grows this population, who may shrink it.** Defect-grown and
lane-lowerable: zero slack is the ratchet working. Ordinary-work-grown: slack from the GROWTH RATE,
`say_compose_bound` at **489 against 480**. Protected-tissue-grown: a countdown -- `dated_path`
**105 against 85** over references in dated logs nobody may repair.
**MEASURED, free:** **81 ceilings, 55 scans, all compared**; **counted rather than gated** stands
**66 times across 50 files**. The move is seated; when it is OWED is unwritten.
**COLD 242/2; HOT 243/1; re-HOT 244/1 `tree_moved=no`**, the one red `dated_path`'s `%626` out of
`standing_equipment`. **The first hot pass bit the recovered scan itself:** `instrument_refusal`
found `git ls-files ... || true` discarding a failure that would read a broken git as every citation
absent; repaired to a named `listing_refused`. **A lap dying before its hot close ships an unheard
red.**
**YOURS:** may a law page cite a guard the roster reaches nowhere? And the law -- **gate what a hand
may lower, count the rest** -- with its form: a ceiling declaring its GROWER.

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
| `20260910.204226` | The door that names its own ceiling | [log](../session-logs/date/20260910/20260910-204226_the-door-that-names-its-own-ceiling.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
