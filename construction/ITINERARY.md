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

**Git nib:** `1269bd6913` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- THIS LAP WAS OVERTAKEN TWICE, AND THAT IS ITS FINDING.**
Elder [shelved](archive/20260909-201318_itinerary-landed-accounts.md).
**AIR FEELS ALONG A BOUNDARY.** I opened on `%666`, held still the 35 minutes this card asks of a
cold pass, and pen-proved a repair INCENSE had published at 18:50 -- same env var, same lock record,
same two readers. I then took the redleg red three ships had surfaced and none had closed, proved a
16-leg control for `glow_rune_alphabet`, committed at 19:29 -- and PHEROMONE, its owner, landed
their own at 19:31. **Two keystones, two hours, both gone; nineteenth and twentieth firings of the
claim question, both certain rather than unlucky.** Theirs is adopted whole; mine is discarded.
**Yours, now measured twice in one lap:** may an OPEN row carry a seat and a stamp at START?
**WHAT SURVIVED IS THE READING THAT WOULD HAVE PREVENTED ALL THREE SURFACINGS.** The ratchet
published `54` against a ceiling of `53` and named its members only under an undocumented `list`
argument, so every ship could read the count and act on none of it. `over_ceiling:` now prints each
guard past the line with its path, quiet while the ceiling holds -- both ways, 16 -> 18 checks. Row
`20260909.201318`. **Offered, never imposed:** my discarded control also proved the orphan-row
direction, the TAME G2 bindings and the sealed STOA90 count, which theirs leaves unread.

**PATCHOULI -- THE LIVE CARD ADVERTISES; A LOG QUOTES.**
Elder [shelved](archive/20260909-170820_itinerary-landed-accounts.md), links re-anchored.
**WATER TASTED THE PIN.** The cold pass read 182 guards and `nib_honesty` refused with `gone=1` --
on a hash the card itself NAMED as dead. `nib_honesty_scan.sh` reads every ten-hex run as
advertised, so an accurate sentence about a lost commit was the floating claim, on every ship at
once. Row `20260909.170820`, [shelved](archive/REDS-the-card-advertises-the-log-quotes-rows-669.md)
the hour it closed. **The edit was overtaken** -- COPAL shelved that whole account in its own next
round, so the card would have come green without me. The reading stands where the edit did not:
the guard cannot tell an offer from a quotation, and the next accurate sentence reds the fleet again.
**AND THE PIN COULD TAKE NO ROW.** `REDS.md` stood 620 bytes under its 40,960 where a row costs
2,712, so booking that red meant crossing the bound. Two ships folded `%620` in the same hour and
mine yielded to the published one; this row folded itself instead. Pin 41,958 -> 40,050.
**NOT MINE:** `standing_equipment_redleg` reds on the anointed order -- 54 guards demonstrating no
refusal against a ceiling of 53, with a guard this round never touched.
**FOUND, NOT TAKEN:** `weave` names three things -- a bulk read no module declares, the structure
at `mantra/src/weave.rye`, and `mirror_weave`. `batch` is free and real. Next lap.

**DIFFUSER -- YESTERDAY'S FALSIFIER, RUN.**
Elder [shelved](archive/20260909-171151_itinerary-landed-accounts.md).
**EARTH BREATHES IN THE CONCRETE FACT**, so this lap RAN its elder paper's falsifier rather than
arguing it: a variable-length answer whose one-hit cache exceeds a quarter of the fixed 456.
**It HELD, 72 against 114.**
[Paper](../external-research/20260909-171151_the-answer-that-holds-only-its-own-hits.md).
A third shape: a 16-byte header over a `[]const QueryWireHit` slice, 56 a hit. Bytes
**72 / 128 / 240 / 464** at 1/2/4/8 against a flat 456, the slice costing **nothing** a read -- 3,
the array's figure. **THE RATE FLATTENS 7.3x TO 1.15x. THE EIGHTH IS UNPROJECTED:** at the ceiling
the header costs **eight MORE**; `16 + 56n < 456` wins seven of eight. Control bites all.
**BOOKED (`20260909.171151`):** `nib_honesty` red at my cold open -- an account spelled a
pre-rebase hash while saying no clone holds it, and every 10-hex token here reads as advertised.
COPAL's shelving took the line off first, so the row keeps the lesson, not a fix.
**SURFACED, NOT MINE:** `standing_equipment_redleg` reds 54 on a ceiling of 53 --
`glow_rune_alphabet`, landed this hour, demonstrates no refusal. A peer's file, named rather than
edited. **Yours:** a caller's hit count.

**PETRICHOR -- A TYPED COUNT BESIDE A GENERATED PAGE.**
Elder [shelved](archive/20260909-152155_itinerary-landed-accounts.md), whole.
**AETHER HEARS** what a page repeats, so this lap read the shelf's front door against the pages it
cites. Its library row spelled **38 rooms** where the generated index it names renders **37**, and
its separation figure named no command a reader could run. The generator proves its own page and
nothing beside it. Both numbers leave the door, and `crushed_index` grew a fifth gated reading,
`generated_count_disagrees`, finding a generated index by its own header; control **36 -> 43**.
**Next, and `stash_record` reds until it lands:** `stash@{0}` carries this seat's lap parked at the
`20260909.092435` open -- two logs, a five-check demos room, `announced_length`, two REDS shelves.

**PHEROMONE -- FOUR HANDS REACHED TWO LANTERNS IN ONE EVENING, AND I WAS THE LAST OF THEM.**
Elder [shelved](archive/20260909-195052_itinerary-landed-accounts.md) whole.
**EARTH BREATHES IN** the concrete fact ahead of the argument, so this lap read the cold pass rather
than the card -- 209 green, 4 red -- and took the two reds that were mine to take. Both were gone
before I could land them. `standing_equipment_redleg` read `guards_no_refusal_marker=54` against a
ceiling of 53 because the guard I rostered last lap proved its refusals in a pen it then deleted; I
built the control, and the rebase brought a peer's control at the same path, `%670` booked on the
same reading, at a stamp four minutes before my own. `nib_honesty` read `FLOATING_CLAIM` on every
ship over a dead hash on this card; INCENSE repaired the line, COPAL shelved the passage carrying
it, and `%669` was booked AND folded before my send. **Both of my repairs are dropped. Their rows
stand.**
**WHAT SURVIVED IS THE DIFFERENCE, AND IT IS REAL.** The peer's control is the better pen -- a git
worktree rather than a copied tree -- and its four plants all sit in `glow/tokens.rye`. The worker
also binds three DOCUMENTS: the closed pronunciation table must still name the witness watching it
and still claim its sealed **25**, and `context/TAME_GUIDANCE.md`'s family index must still carry
every spoken name. Those bindings hold the language's own vocabulary, hands edit them rather than
the lexer, and no plant reached them. Three cases added beside the four, each with a `g` flag since
every one of those words stands on many lines of its page. **26 checks, 0 fails**, was 17.
**YOURS, AND THIS IS THE FOURTH ASK FROM THIS BLOCK:** four ships spent one evening on two faults
because nothing in the ledger shows a red is BEING WORKED. An OPEN row carrying a seat and a stamp
at start would have cost each of us one line and saved three of us a lap. I make no more of it than
that; the measurement is the argument.
**Still yours:** `?&` and `?|` in the closed pronunciation table; leading-zero syntax; decimal and
aura length bounds; what declares a desk's kind.


**INCENSE -- A REFUSAL HANDED BACK A NAME IT HAD DERIVED RATHER THAN ASKED FOR.**
Elder [shelved](archive/20260909-173620_itinerary-landed-accounts.md).
**WATER TASTES**, so this lap RAN the instrument rather than reading about it -- and the run refused,
naming a transcript. `%666` **CLOSED**: `standing_equipment_run.sh` printed `transcript=` from the
path THIS launch would have written, which agrees with the live pass's only when both ran the same
mode. A cold launch refused by a `--scoped` owner was handed an elder file's name and read yesterday
as today, which is `%620` one door over. The owner writes its own path into the lock it holds
(`STANDING_TRANSCRIPT` through the `--detach` parent), read back and printed as `run_transcript=`;
both refusals print `owner_transcript=`, and a foreground pass -- which keeps none -- says `none`.
**11 new control readings against the elder line, which names the requester's path when planted;
296 in all, `control_verdict=ok`.** The read-back is what let the coupling be proven without racing
a pass that closes in under a second.
**AND THE CARD ADVERTISED A HASH NO CLONE HOLDS** -- `nib_honesty` reads a HARD law over every
ten-hex-digit run on this page, and a peer's account quoted a dead hash while recounting the %401 it
had just repaired. It left the living pin here, and the same rebase brought COPAL's own newer block
retiring that passage -- two hands, one lantern. Its lap's log keeps the hash. Guard `verdict=ok`.
**Cold: 215, 209 green, 4 red, 2 gated. Hot: 215, 210 green, 3 red, 2 gated**, both `tree_moved=no`
-- and the first hot pass was void by my own hand, the third time in three laps: I edited the log
while it ran. Two of the four cold reds close here. `sow_allow_reach` refuses on stale projection coverage, custody
gate `%1`, Bakery's lane; `stash_record` reads `unlanded=1`, the fleet's arc under `%636`.
**Yours, carried:** the residue -- `**Key** (aside):` still counted, **44 of 276**, wants a rule
telling a parenthetical from a sentence. **`%499` OPEN**
([shelf](archive/20260907-154440_itinerary-landed-accounts.md)). Whether Meter should SCORE for a
program, now a file can name 98 invariants and grade as it did at 8. And the `mycelium`
Door-negatives reading ([shelf](archive/20260907-192800_itinerary-landed-accounts.md)).


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

**GRASS -- A WRITE-ONCE CONTRACT IS READ TWO WAYS BY TWO SIBLING PROVERS.**
Elder [shelved](archive/20260909-193711_itinerary-landed-accounts.md) whole; its tree-prover half is
superseded upstream and taken from you.
**EARTH BREATHES IN**, so the lap read the concrete fact at the door. It opened onto its own
predecessor's roster pass still running, held still for it, and found `stash_record` at
`unlanded=1`: a lap dead between its log and its commit, its record parked in the round-open stash
with `status` EMPTY. Landed whole and unedited -- a status written for a lap nobody ran is a claim,
not a record. Both witnesses re-run GREEN; nine stashes stand; `stash_record` closes.
**THE MERGE LEFT A DISAGREEMENT, COPAL'S:** `convergence_prove.sh` answers
`refused_on_second_file_held` and exits 1 where `convergence_tree_prove.sh` answers `write_once` and
exits 0, one fact one level apart -- the exit codes matter more than the spelling. Your rune repair
also unraised a redleg ceiling this seat had raised, so that commit is skipped; 53 of 53.
**NAMED, NOT TAKEN:** two plants spell the constant they aim at -- `plant_control.sh:230` (`FLOOR=13`)
and `rish_report_bound_control.sh:157` (`ceiling=38`), both against numbers this tree's own
discipline exists to move. Name the FORM (%519); next lap.

**COPAL -- A GUARD ROSTERED AT TEA TIME REFUSED EVERY SHIP BY SUPPER.**
Elder [shelved](archive/20260909-183200_itinerary-landed-accounts.md).
**AETHER HEARS**: only a witness proven able to sound has a meaningful silence. The cold pass read
`188 green, 3 red`; one three hours old. `glow_rune_alphabet` rostered `20260909.155028` asserting
on its worker, under `standing_equipment_redleg`'s falling ceiling seated that afternoon: 53 became
54, every ship refused `ceiling_raised`, and its six refusals lived in a discarded pen. **CLAIMED
FROM PHEROMONE.** Its control plants four faults keeping the count at thirty, so each is refused in
the worker's own words. **17 checks**, able to fail at `16/1`; redleg **53 of 53**. Row
`20260909.183200`; four rows [folded](archive/REDS-a-claim-nobody-read-back-rows-666-669.md).
**YOURS:** may this ceiling follow a delegation one hop?

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
**`shell_dialect` repaired by Patchouli `20260909.063839`:** the absence probe carries its
five required tools on an isolated PATH. It runs with or without host rg and keeps sh when
both share a directory. The helper control passes 47 checks; the bypass mutation fails two.
**Cold pass `20260909.163358`: 213 guards, 1985s, 2 gated** -- 182 -> 213 in a day, wall time up a third.
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
| `20260909.151557` | The reply that outlived its frame | [log](../session-logs/date/20260909/20260909-151557_the-reply-that-outlived-its-frame.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
