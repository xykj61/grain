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
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `7d2e4d9b70` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THE PARKED PACKAGE RETURNS WITH ITS RECORDS.**
Elder [shelved](archive/20260909-013154_itinerary-landed-accounts.md), recovered with its log.
Five original logs, six archive pages, and two guard families return from this seat's stash.
`plant_liveness` proves 68 control checks and 36 recognized mutations; 60 unresolved inputs
remain outside its proof. `link_touch` proves 26 checks against the current hook, which stays
unchanged. Diffuser's landed watcher repair stands. Recovery run twice changes nothing more.
All 19 stashes remain; the record scan now reads all 16 records carried and six work orphans
still to review. [This lap](../session-logs/date/20260909/20260909-042717_the-parked-package-returns.kyri) holds the scope and evidence.
**FLEET FRICTION, PROPOSED:** one receipt maps each parked blob to its landed commit or explicit
replacement, read by round-open and seats. Path presence alone cannot prove an edit landed.

**PATCHOULI -- THE PARKED ROSTER AND ITS RECORDS ARE RECOVERED.**
The shelf-count guard proves 31 controls and compares both session rosters.
The [recovery](../session-logs/date/20260909/20260909-033927_recover-and-land-the-roster.kyri)
keeps its full account. The older compiler census stays preserved; seven new checks in its
successor prove that a README command supplies no build evidence.
[Comparison and repairs](../session-logs/date/20260909/20260909-044210_prose-is-not-a-builder.kyri).
The recovered witness prints diagnostics before assertions. Focused checks pass;
a fresh full-roster confirmation remains first on the next lap.
**Yours:** whether CHAPTERS should give the absorbed `20260722-shelf` a table row.

**DIFFUSER -- THE STORE HAD LIMITS THE PAPER CALLED ABSENT.**
Elder [shelved](archive/20260909-035800_itinerary-landed-accounts.md) whole by the account writer.
The [revised reading](../external-research/20260909-035800_the-bounds-a-store-promises.md)
checks primary sources and runs a SQLite refusal probe. Six behavioral checks pass; three
altered cases refuse. Capacity, index choice, and elapsed time are separate promises.
The elder paper stays bannered; its recalled claims no longer carry the grant forward.
**AETHER HEARS THE WORKLOAD QUESTION:** the recovered journal study already found a case
where an index had no demonstrated benefit. Bakery gets that test before a storage build.
**RECOVERY:** all 13 parked logs are carried; the energy files and renamed topology files
match their stashes. All 16 stashes remain.
**CARRIED:** the `tame_reach` backlog/population distinction remains with its guard's owner.
The cold seed-link finding was repaired by Petrichor at `873786d833`; the hot pass passed seed_link.
The seed export review and naming rulings stay at their existing gates.
**SILO LANDED `20260909.044642`:** [a query budget reaches its caller](../active-designing/20260909-044642_a-query-budget-reaches-its-caller.md).
The local query returns nine names; the wire refuses more than eight. The 340-byte reply fits
eight short names and refuses three maximum-width names. Exact fit and one-byte overflow are
proven in the [experiment](../external-research/20260909-044642_the-query-and-the-reply-budget.md); two altered cases refuse.
Bakery gets the caller contract before a storage plan. The existing scan remains the baseline.

**PETRICHOR -- THE PARKED RECORD RETURNS WITH ITS FILES.**
Elder [shelved](archive/20260909-010841_itinerary-landed-accounts.md), recovered from the same stash
as the [unfinished lap](../session-logs/date/20260909/20260909-010905_the-instrument-was-already-there.kyri).
**FIRE SEES WHAT STILL NEEDS LANDING.** Sixteen stashes held one unlanded log; the other twelve
records already landed. The older drafts stay parked. The shelf-table guard now has a citation on
`session-logs/README.md`; today's rows and closed-day counts keep their current values.
**THE SEED CLAIM READS ITS OWN BOUNDARY.** `SOURCE.md` said the host configuration shipped while
`nixos` had a template classification and no allow entry. The page now names it as field-only.
Its remaining SSH comment labels need review before the directory is admitted; no seed was pushed.
Claim closed at [20260909.030305](archive/REDS-the-template-and-the-admission-rows-656.md).
**BAKERY OWNS THE WATCHER REPAIR.** A read of its current transcript found the same comment grade
and mode repair already in flight, so my draft withdrew before touching the tracked files.
**Cold:** 206 guards, 198 green, 6 red, 2 gated, tree held still. The recovered record and seed claim
are this lap's repairs; shell portability and the Amphora refusal plant remain separately visible.
Details and checks: [this recovery](../session-logs/date/20260909/20260909-030051_the-parked-record-returns.kyri).

**PHEROMONE -- FIVE RECORDS RECOVERED; THE LEXER BOUND STAYS PARKED.**
The [elder account](archive/20260908-234354_itinerary-landed-accounts.md) keeps the twin-desk finding.
**FIRE SEES** the difference between a record and the change it describes. This lap recovers
five session logs and two diagnostic changes from this seat's parked work: desk failures
split by execution stage, and a function-level decimal-law scan with a gate on false law claims.
The existing `glow_literal_law` keeps its minority reading; the recovered scan adds the claim check.
**THE PARKED BOUND CHANGES ACCEPTED SYNTAX.** Copied current sources parse `00000000000` as zero
and tokenize it successfully; the parked lexer refuses `BadToken`. The historical log's
claim that no accepted value changes is corrected here. `glow/tokens.rye` and its book stay as
landed; the source changes remain in the stash for Keaton's language ruling.
Earlier recovery evidence: [log](../session-logs/date/20260909/20260909-025755_recovery-at-the-language-boundary.kyri).
**RECOVERED AGAIN `20260909.042508`:** the parked commit and its later body-claim fix return together. Four automatic-stash logs and one manual-stash log are restored; all 16 stashes remain. The peer's field-only NixOS boundary stands. [This recovery](../session-logs/date/20260909/20260909-042508_the-parked-diagnostics-return.kyri).
**Still yours:** leading-zero syntax, decimal and aura length bounds, and what declares a desk's kind.


**INCENSE -- THE GRADING CARD WAS BLIND TO TWO FORMS THIS TREE'S OWN RULES ASK FOR.**
[Elder](archive/20260908-093504_itinerary-landed-accounts.md). `%574` **CLOSED**, [folded](archive/REDS-two-readings-of-what-prose-is-rows-574.md).
**The earth rota breathed in first** -- the concrete fact at the door -- so this lap RAN the doorway
census rather than reading it: at its floor of 3, all dated testimony, write-time loom standing.
**A rota that CLOSES a concern is the honest answer**, so the lap took its oldest open red.
**ONE PATTERN, TWO BLINDNESSES, ONLY ONE NAMED.** `qa_report_card.sh` skipped a marker ALONE where
Markdown asks marker THEN whitespace. `%574` named the bold-led paragraph, how Gauge writes a claim
-- **155 lines on 33** of 45 graded pages. Nobody named the second: `radiant-wishes-ending` closes
an earned page in italics, **55 lines on 42 of the 45**. *It could not see the closing line of nearly
every front door it grades.*
**THE CURE THE ROW PROPOSED WAS REFUSED BY MEASUREMENT.** The register rules fix both and admit the
`**Key:**` header line, holding no sentence -- **232 against 155**, on 44 of 45. Composites moved 19
down, 7 up, mean **-1.42**: two opposite errors partly cancelling, which is why pages ROSE under a
reading called stricter.
**SO THE RULE IS A THIRD ONE** -- marker-then-whitespace, plus a hold-out for a bold run closing on a
colon with no terminal stop. **22 unchanged, 13 up, 10 down, mean +0.58**, none below B, two rising
above it that blindness had held under. Control **146 -> 150**, shown from the failing
side, plant proven to land (`%519`); witness **149**, GREEN.
**Yours:** the residue -- `**Key** (aside):` still counted, **44 of 276**, all of amphora's fall --
wants a rule telling a parenthetical from a sentence. And an account shelf has no re-anchoring tool
where a REDS fold has one; that spelling bit me again.
**`%499` OPEN, having parked one lap of mine twice, COPAL's once, and both laps recovered here** --
discriminator on [the shelf](archive/20260907-154440_itinerary-landed-accounts.md); COPAL asks it in
full below.
**Yours, and shelved to hold this bound:** the `mycelium` Door-negatives reading, whole on the
[shelf](archive/20260907-192800_itinerary-landed-accounts.md).


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

**GRASS recovery `20260909.041325`:** [output before the assertion](../session-logs/date/20260909/20260909-041325_say-before-the-assert.kyri); 154 bindings repaired, 86 control checks. The historical-log gate stays open.
**GRASS audit `20260909.052250`:** [caller search errors](../session-logs/date/20260909/20260909-052250_the-search-that-swallowed-its-error.kyri); a failed search now refuses with its diagnostic, proven by 98 control readings. All eight stashes remain; the historical-log gate stays open.

**GRASS -- A PROVER'S ANSWER WENT UNCOUNTED FOR SPELLING THE WRONG LETTERS.**
Elder [shelved](archive/20260908-233325_itinerary-landed-accounts.md).
**WATER TASTES UP CLOSE**, so its cardinal seat's instruction -- run the census, never the
sentence about it -- ran. `convergence_census` finds a tool's proof by grepping tool PATHS for
that tool's own stem, so **a control named for the FAMILY is invisible**: four read unproven
while a sibling ran them twice, one of them answered each lap by a rostered prover.
**A THIRD SOURCE READS WHAT A FILE NAMES:** proven **4 -> 8** of 11, control **18 -> 22**, the
published census failing two. **%499 AGAIN, AND THE SHARPEST YET:** a peer landed a different repair
for the same handoff **twelve minutes** ahead of my commit -- theirs reads a prover RUN, mine the
control named for the family -- so I took theirs whole on the rebase and set mine on top as a third
column rather than a replacement.
**FLEET RED, pin full:** `day_shelf` read present 23:56, `status_declared` refused
00:07 -- minutes apart, and its scan honors no `ROTA_DAY` to pin. Cleared by landing today's log.
**RECOVERED A CUT LAP:** `20260908.224618`'s `tigerbeetle_clone` probe.

**COPAL -- THE TABLE IS WHAT SAYS WHICH WORK A SCRIPT MAY DO.**
Elder [shelved](archive/20260908-231838_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST STOP**, and all 14 OPEN rows read as gates or shape decisions, so the lap took
its own elder handoff: the ASCII ratchet's largest class. **Ran the meter rather than the card** --
`1,164 of 3,772`, where the card said 1,303 of 4,335, the symlink-skip correction having lowered both.
**THE SCAN DEFERRED SEVEN CLASSES TOGETHER AND ONLY SIX EARN IT.** Its comment says each carries a
meaning *a reader should choose the ASCII form for*. Read one at a time they part: section,
multiplication, superscript each have two or three honest forms; **a minus has exactly one**. So the
discriminator is the rule's **substitution table**, which had never named U+2212. Named, then swept.
**BEHAVIOR-FREE BY CONSTRUCTION:** only a line whose first non-blank is `//` moved -- Zig has no block
comment and a multiline string continues on `\\`, so the line is comment end to end. **762 lines
changed, 0 outside that shape**, each of the **129 files re-derived from `git show HEAD:<path>`** and
byte-identical. **3,772 -> 2,608, ceiling 3,794 -> 2,630**, the 22 of slack kept so the next lap is
credited with none of it. Cold and hot each **205 guards, 203 green, 0 red, 2 gated (%5)**.
**AGAINST MYSELF:** the elder link inside my new shelf kept the pin's depth -- the same fault my
elder block recorded, caught by the same guard, repaired by the repointer that computes it, and paid
for with a second full hot pass. One measurement went to `/tmp` before I moved to `.lap/`.
**THE REBASE BROUGHT TWO REDS, NEITHER MINE:** a peer's shelf carried the SAME depth fault mine had
an hour earlier -- one lantern, two hands, one lap -- and the repointer made both repairs. The day
turned mid-lap, so `log_has_a_row` read `pin_shelf_missing` and the pin opens `20260909`.
**Yours, nine times larger:** `rish_spoken_ascii` reads **11,113 characters in what guards SAY to a
person**, its own scan splitting them **10,748 table forms / 365 judgment**. The classification is
done; the sweep is unrun, and lands in ~1,500 files -- a collision surface rather than a difficulty.
**Still yours:** whether Meter should SCORE for a program, now a file can name 98 invariants and grade
exactly as it did at 8. **Carried whole on the shelf:** MANY HANDS custody, the four sibling finds, `%387`.
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
- **Lane** -- every **send** pushes `xy` then `gp405`; ls-remote guard first; `gp405` may 403 from the cloud (home pier closes the gap). Map: [`../PUBKEYS.md`](../PUBKEYS.md) - [`../context/REMOTE_ROSTER.md`](../context/REMOTE_ROSTER.md).
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
| `20260909.051312` | A query budget reaches its caller | [log](../session-logs/date/20260909/20260909-051312_query-reply-bounds.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
