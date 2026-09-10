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

**Git nib:** `b5cb75643d` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A CENSUS COUNTED TWO READS AS PLANTS, AND ITS COMMENT SAID IT DID NOT.**
Elder [shelved](archive/20260910-141242_itinerary-landed-accounts.md).
**FIRE SEES**, so this lap took `%519`. **Its open shape decision is made:** `plant.sh` landed,
**27 of 250** controls source it, **all 27 call it**.
**MY HYPOTHESIS WAS REFUTED BY THE WEAKER READING I USED** -- a path grep gave two adopters calling
nothing, both false; the scan repaired that at `20260907.145907`: **the dot command is the import.**
**FOUND INSTEAD:** `plant_liveness_scan.sh`'s writing test read `>&2` as a file redirect, so two
diagnostic READS stood in `plants_unresolved` -- **the inflation its own comment declares avoided**.
Duplications strip first: **67 -> 66**, two removed, one added by this lap's own pen. Census **46
resolved, 46 live, 0 dead**. **`--list`** names the lines behind each count, with no `verdict=` of
its own. Control **74 legs, faults=0**, mutation-proven.
**HOT 239 green, 2 red, `tree_moved=no`** -- `say_compose_bound` and its `red_self` echo, repaired
by a peer at `160342` while I ran. **My cold open read `tree_moved=yes` by my own hand.**
**FLEET:** the front sits past its 8x2,048 arithmetic -- `INCENSE` **2,597**, `PATCHOULI` **2,161**.
**YOURS:** the **~66 unresolved** are mostly pen-authored, so a ceiling is a question rather than
a sweep. REDS pin **22 bytes** free.

**PATCHOULI -- A REFUSAL NAMED AND UNREACHABLE IS A WISH.**
Elder [shelved](archive/20260910-151012_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST STOP** (row 2, hand-advanced), so I read my lane for a refusal the
code names and never reaches. Of **71 named error-set members in mantra/ and tally/, nine are
named in no test**; **one had no return site**: `SnapshotError.BatchCountMismatch`.
**PROVEN ON METAL BEFORE A LINE CHANGED**, in an ignored pen: eight junk bytes on an honest
1,292-byte snapshot, and both `import_catalog` and `import_catalog_horizon` answered **5 leaves,
success** -- two byte strings, one catalog, `20260910.043900`'s class. Lowering the
declared count imported a **PREFIX as whole**, `drop=1 claim=3` and `drop=2 claim=2` accepted, the
leaf claim beside it being one the same hand writes. The horizon refused those with
`HeadDigestMismatch` -- **the head record was the defense; the plain import had none**.
**MECHANISM, one line:** after the batch loop, `off` is compared against `cap_u32(snapshot)` and a
remainder refuses as `BatchCountMismatch` ahead of the leaf claim, since the count decides which
bytes that claim is about. Four legs lifted into named functions took `run_selftest` from **120
lines back under the 70-line ratchet**; the prefix leg sweeps every lowered count at each claim
to 8.
**THE HOT CLOSE REDDENED ON MY OWN BOUND, rightly:** `ceiling_teeth` read that sweep range where I
published it as a `pub const max_` and found it turns no caller away. It bounds a LEG, so it moved
inside the leg, `asserted_only` **2 -> 1**. **A published `max_` is a fence somebody meets.**
**`mantra_snapshot_batch_count` tier lap** GREEN; **13 control legs, `control_failed=0`**, five
pens: `no_leg` drops the selftest's own line and keeps the check, so the behavioral reading is no
grep in disguise, and `lawful_break` bites a byte early, refusing an honest snapshot.
**COLD 241/238/0; HOT 242/239/0, 3 gated, `tree_moved=no`**
**YOURS:** **eight** wire labs in `tools/m/` red here for want of `qemu-system-riscv64`, **all eight
off the roster**, so no lap hears them -- %646's class. A capability row, or a hand's lab?

**DIFFUSER -- A LAP OUT OF THE DEAD-LETTER BOX; THE MERGE WAS THE WHOLE JOB.**
Elder [shelved](archive/20260910-162413_itinerary-landed-accounts.md).
**WATER TASTES**, rota row 3: the happy zone rewards *witnesses cheap enough to actually run* --
my elder paper's observation four, said here a fortnight early.
**THE RED I NAMED LAST LAP, CLOSED:** `stash_record unlanded=1` held a whole DIFFUSER lap of
`13:39` -- `convergence_census` rebuilt resident at **8.68x pooled**, the shared lexer's `cat`
per call cached, one control leg, and the paper. Its base predated a peer's Rishi strand that
arrived on my rebase, so the box was never the fault; the merge nobody ran was.
**BUILT:** the fourth strand joins the resident write map **pre-filtered** rather than called per
file -- `rish_writes` unchanged, one `grep -l` for `"sh" "-c"` or `write-file` over 2,450 tracked
`.rish` sources being a superset of what it emits. A peer's function kept whole is a peer's seven
legs still able to bite.
**BOTH SIDES:** both modes byte-identical to HEAD -- 11 counts, 23 list rows,
`geode_libraries.rish` still admitted. Control **53 legs, fail=0**; the pass dropped to
`/dev/null` reds **three** rish legs by name. Cost **277.4 s to 75.1 s, 3.7x**, unpaired under a
roster; the paper's **8.68x** is three interleaved pairs and stands.
**YOURS:** the paper's falsifier -- scan-to-control wall split over ten guards. Above 70% scan
puts the fleet ceiling near 3x; above 70% control retires the plan. Still open: `max_wakes`.
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
**PHEROMONE -- A PEDESTAL NAMED A NUMBER AND ASKED NOBODY.**
Elder [shelved](archive/20260910-152558_itinerary-landed-accounts.md).
**EARTH BREATHES IN**: the rota's dual seat, `foundations/20260703-202312_the-marked-value.md`,
read *lap one witness waits on seed* while lap one has stood built for weeks.
**ITS CLAIM IS WRITTEN THREE TIMES AND WAS COMPARED NOWHERE:** the engine hardcodes exactly TWO
type-marks; `amphora/manifest_entry.rye` restates it above `mark_plain_bytes` and `mark_manifest`,
`src/shape/tilak-root-count.glow` displays `example    2`, and that desk's leg in
`src_first_resident_witness` greps it for three strings it already holds, opening the engine never.
**A third root wired into `mark_verdict` passed every guard standing.**
**BUILT:** `tilak_root_count` **tier lap**, 3.0s, no toolchain -- five readings that fire apart,
**5 welcomes 16 refusals**, a granted third root free since the scan holds no number of its own.
**THE PEN CORRECTED THE HEADER:** a fifth reading was argued away as unable to fire alone, and case
10 is what it missed -- a bare-literal arm whose constant is later renamed, every other reading
agreeing while the engine answers a mark it no longer publishes.
**THE CLASS, MEASURED:** of the 17 pedestals that leg holds, **three** are tied to their Rye source
(`%358` bought that), one to a fixture, **thirteen** to literals in the witness. One moved; **twelve
remain**, each wanting its own source read.
**REDS, THE SAME ONE CLOSED TWICE:** `say_compose_bound` read **deferred 538 against 537**. Seven
`assert ... else "... ${x.out}"` sites split to the bare `say <name>.out` shape in
`glow_decimal_law_witness` and `comlink_topology_witness`, **1880 -> 1873**, both re-proven GREEN --
and Incense landed eighteen more in its own lane the same hour. **Composed on the rebase, 531 of
537.** **Two ships on one ratchet in one hour is the claim question again**, unanswered here since
`20260906.212057`: nothing shows a red is BEING WORKED.
**YOURS:** **REDS reads 40,771 of 40,960**, so no row could be booked; cited by stamp under rule 4.
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

**COPAL -- THE RED WAS THE INSTRUMENT'S BLIND SPOT; THE SWEEP WAS OWED ANYWAY.**
Elder [shelved](archive/20260910-151309_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST STOP**, and the cold open stopped this pier: `say_compose_bound` red at
**deferred 538 against 537**, `standing_equipment` reddening beside it for that one reason.
**MECHANISM:** the classifier in `tools/fixtures/s/say_compose_bound_scan.sh` read each line from
its start, so a one-line `if COND then ACTION` was invisible whatever the action did. It strips a
leading `if ... then ` now and reads the CONDITION apart from the action, since a condition
interpolating a capture composes every run whatever follows. **UNSEEN: 21** hazardous guarded tails,
every sample a build's stderr, and **155** guarded bare says already spelling the repair.
**SO THE DENOMINATOR SAT 258 LOW.** Run the widened classifier over the tree as it stood BEFORE
any repair -- a worktree pen, measured rather than computed -- and it answers **512, `verdict=ok`**:
the blind spot rather than a habit that had worsened.
**THE TWO SHARES WERE BRAIDED:** a guarded repair LEFT the population, shrinking the denominator
and raising the EAGER share -- a lane doing right pushed a peer toward its ceiling, **165 repairs**
from reddening it. It lands in `safe` now, so only the numerator moves.
**PAID MY SHARE ANYWAY:** `tools/am/` **93 deferred and one eager to zero**; **sixteen witnesses
re-run GREEN**, the refusal proven by breaking a build in a pen.
**CEILINGS FELL** 155 -> **145** and 537 -> **489**. The first was written 144 and set to 145
BEFORE it ever pushed: a peer landed on this guard inside the hour and carried eager to 143,
leaving one per mille across eight writers. **A ceiling only falls, so the number to be careful
about is the one chosen while it is still unshared** -- the derived spine's rule, met in a ratchet.
**Control 29 -> 41 legs**, each new wall removed in turn and its legs watched to fall while the
unguarded stayed green. Two are **named in the witness**: `cases_red=0` hears a leg that failed and
never one that stopped running.
**THE HOT CLOSE CAUGHT WHAT A COLD OPEN CANNOT:** `shim_reason`, green forty-five minutes earlier,
refused at **`late_say_rostered=4`**, all four mine. **THE TWO GUARDS PULL OPPOSITE WAYS ON ONE
LINE** -- one wants the capture OUT of an assert's else, the other the reading ABOVE the first
assert on its binding, since assert stops the run. Printing before the FAILING assert put it below
an EARLIER one. **One shape serves both**, `reds_spine_derive_witness`'s own: print bare right
after the binding, then assert. Back to **zero**.
**GRADED, DECLINED:** the scan reads **C 73**, its elder **C 73** byte for byte -- the card grades
a program's head block, untouched here. Register 43 at 57% negatives in a Meter header whose
subject IS refusal: **Incense's question today**, yours.
**YOURS, KEATON:** REDS reads **40,311 of 40,960**, **649 free**, where a row of this class runs to
thousands -- so this one is cited by stamp (`20260910.151309`) and rests in its log.
**Still yours, on the shelf:** `rish_spoken_ascii` **11,113**, 10,748 table / 365 judgment, sweep
unrun; Meter SCORE for a program; `%456`; `%460`; `%360` **674**/**1,093**; `glow/rune_shape.rye`
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
| `20260910.152558` | The pedestal that asked nobody | [log](../session-logs/date/20260910/20260910-152558_the-pedestal-that-asked-nobody.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
