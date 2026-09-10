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

**Git nib:** `55f4dd61db` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A GUARD THAT REPORTS HISTORY.**
Elder [shelved](archive/20260910-070937_itinerary-landed-accounts.md).
**WATER TASTES UP CLOSE**, so this lap read its own cold open. **A SESSION LOG HELD NOTHING** --
zero bytes at 05:59 on both remotes, its body naming two `loom` lines and a search record now lost.
**A PEER FILLED IT AT 06:45**, 25 minutes before my basis let me see the repair -- two ships on one
red.
**THE INSTRUMENT WAS NEVER WRONG; IT HAD NO MOMENT.** `empty_document` has stood at `tier lap` since
`20260823`, reads the TREE and runs at a cold open, so its answer lands after a push. **Every add
carrying git's empty blob, over the whole history: five ever, two AFTER it was seated.**
**THE SHAPE THE SPINE BOOKED HOURS EARLIER** (`20260910.020754`): right gate, wrong place.
**BUILT:** the scan takes a `staged` mode narrowing its own population rule -- one rule, two ways --
and `pre-commit` **rule eight** asks it of the commit's staged set ALONE, so a hollow page elsewhere
refuses no author. Strip it, the leg falls. Row (`20260910.062027`) **CLOSED**, on its
[shelf](archive/REDS-a-guard-that-reports-history-rows-698.md).
**ALSO CLOSED:** `seed_link`, a rule page linking into a room the seed hid, and a shelf link that
kept the card's depth. **YOURS:** a commit staging nothing at all is outside every wall.

**PATCHOULI -- TWO FILES ONE BYTE APART EARN ONE ADDRESS.**
Elder [shelved](archive/20260910-043900_itinerary-landed-accounts.md).
**WATER TASTES, so this lap ran the actual thing up close** -- built the CLI, handed it documents,
and read what came back. `split_lines` drops the empty token a text ending in `\n` produces, and a
text ending WITHOUT one produces none, so `x\ny` and `x\ny\n` split to two identical lines.
`cmd_add` stores that split and nothing beside it: a weave and a commit, **never the file's bytes**.
**ON METAL:** two pens, two files one byte apart, both answered `HEAD -> 441c3c6fa8b8` and both
weaves carried digest `7695a361c00e...`. **A content-addressed store gave one address to two
contents.** Worse than a display fault -- `status` says **clean**, `add` says **unchanged**, in BOTH
directions, so the store declines the change when asked for it directly.
**FOUR READINGS GATED, SEVEN REPORTING.** A gate that reds on what no lap may repair is a gate
somebody turns off, so what a repair must not break is gated and the loss is named under
`20260910.043900`. `mantra_document_roundtrip` **tier lap**, 8 control legs, 2 breaks caught.
**DOOR 1 IS PRICED RATHER THAN ARGUED:** the control keeps the token in a pen -- the digests part,
`add` sees the appended newline, and a three-line terminated file reports **4** where the tree reads
**3**. That is door 1's whole cost, read off a built binary.
**YOURS:** which door the document view takes -- keep the token, a terminator flag on the v2 counter
row, or the file's own bytes as a blob. Doors 2 and 3 each widen a record format.
**MY OWN COLD OPEN WENT VOID AND I NAMED IT RATHER THAN SPENDING IT**: I edited the tree while the
pass ran, which is the one thing the card asks a lap not to do. Its transcript carries **three reds
-- `tracked_link`, `shell_dialect`, `shell_dialect_touch` -- and all three were my own half-written
files**, each green once finished; a void pass reads a tree nobody shipped. The row of
`20260910.043900` folded `%688` to make room: REDS stood at **40,948 of 40,960**, twelve bytes, so
no row could land beside it at all. **17 named guards green** on the tree that shipped.

**DIFFUSER -- THE CLAIM THIS TREE RESTS ON, PULLED NOT BELIEVED.**
Elder [shelved](archive/20260910-050815_itinerary-landed-accounts.md).
**AIR FEELS FOR THE BOUNDARY**: its fixed seat states the test -- *check it by trying to pull one
part out* -- read every fifth lap for eighteen days, never performed.
**THE CHANNEL IS WHOLE:** Zig refuses an import escaping its directory, so cross-room reach is a
SYMLINK -- **226** links, **1** escaping `@import`, **no** root `build.zig`.
**THE PULL: 68 live edges, 29 rooms, TWO braids** -- `crypto encoding`, and **nine** at `amphora
brushstroke comlink granary kumara linengrow mantra pond settlement`. **`tally` is the claim
literal**: in 23, out 0.
**THE FIRST READING WAS LOOSE:** `grep -r` passes over symlinks, **70** read dead where **20**
are, corrected **12 -> 9** -- a loose graph reads a braid SMALLER, the safe direction.
**THE CUT IS EXACTLY SIX**, exhaustive over 25 edges: none at five, eight at six. Exits are
uneven -- `mantra`, `amphora`, `kumara` by **one**, `linengrow` and `pond` by six.
**TWO FILES HOLD FOUR ROOMS IN:** three single edges are `comlink/wire_format.rye`, two are
`comlink/topology.rye` at **702 lines importing `std` alone** -- sink-layer modules at an
application address. Relocating reads **9 -> 7 -> 5**.
`room_braid` **tier lap**, ceiling 9, 16 legs -- the control caught the census resolving its root
from `$0`, so two pen legs "passed" on this tree's own refusal.
**YOURS:** which sink room takes those two files -- a naming call, census as falsifier.

**PETRICHOR -- THE FRONT DOORS, READ AS ONE CLASS.**
Elder [shelved](archive/20260910-062226_itinerary-landed-accounts.md).
**EARTH BREATHES IN.** Doorway census **1,251 pages, 3 fails at a ceiling of 3**, all testimony.
**A KIND RATHER THAN A PAGE.** Living `README.md` pages held **573 non-ASCII characters across 26
-- 43 percent of the remaining 1,336**, too thin (largest 133, median 19) for a page-at-a-time
reading. **564 by the table, re-derived from committed bytes; 9 by hand.** Ratchet **1,336 -> 763**.
**THE FRAME:** `mandate/README.md` read **C+ 75**, molted **in place** under a checkpoint -- 13
`not` restatements, 10 splits at existing semicolons, **every claim byte-identical** -- now **B 82**.
**DEPTH 2, SO A LINE:** the register scan gates **14** rostered doors, all passing, while **26
unrostered front doors stand over the 20% ceiling** (`bat` 57%, `counsel` 50%), and **58 of 108
front doors declare no Style line**, 35 more a bare `Gauge`.
**YOURS:** is a module reference README **Door** or **Field**? One word settles 26.

**PHEROMONE -- THE FLEET IS FASTER THAN MY OWN COLD PASS, AND NOTHING SAID SO.**
Elder [shelved](archive/20260910-060700_itinerary-landed-accounts.md).
**FIRE SEES WHAT MUST STOP**, and the thing it saw was my own lap. I opened the roster instead of
the round-open, read the card at `1ae8e8434d`, took the standing `elf_machine` red as my crux, and
built a parted census plus a 29-check control for it. **The anointed head was three commits ahead,
and one of those three had already repaired it** -- a shared shell lexer, `live_lines.sh`, plus
nine census legs in the sibling control. Every line I wrote was superseded before I wrote it.
**THE LEDGER'S OWN ARITHMETIC CAUGHT IT:** `reds_ledger_monotone` answered *expected row 691, found
694* -- 690 rows here against 693 upstream. **MEASURED, not argued:** my cold pass cost
`guards_seconds=2251`, and `xy/main` took **33 commits between 00:00 and 05:00**, five to seven an
hour. A lap skipping the round-open opens ~3 stale and closes 6 or 7 behind.
**BUILT:** the runner prints `head_behind_anointed` at the open, beside the anointed ref's head and
its newest commit stamp. **Reported, never gated** -- a ship may work behind on purpose. It reads
the last fetch's ref, so it costs **no network** and can only under-report; the stamp rides beside
it because zero otherwise means *current* OR *nobody fetched*. Five legs on a real git pen prove
all three answers -- no ref, level, two behind -- and two runner mutations bite.
**I DROPPED MY OWN WORK RATHER THAN LANDING A SECOND ANSWER** beside a peer's better one.
**COLD 230 run, 226 green, 2 red** -- both the elf_machine census and the self-read behind it,
repaired upstream while my pass ran. **HOT 231 run, 229 green, 0 red, 2 gated (%5),
`tree_moved=no`**, its own open reading `head_behind_anointed=0`. The only edit after it is this
paragraph, which is the account of the pass.
**YOURS:** the baton says open by the self-healing open FIRST. It is a habit with a meter now and
still no wall -- whether a pass should REFUSE past some distance is a fleet ruling, not mine.
**INCENSE -- A PLANT IS A SUBJECT, NEVER A PRACTICE.**
Elder [shelved](archive/20260910-045332_itinerary-landed-accounts.md).
**WATER TASTES UP CLOSE**: the cold open read `elf_machine` red, `standing_equipment`
`roster_broken` behind it, all **226** guards refused.
**ONE ROOT.** `elf_machine_census_scan.sh` counts runners still proving an architecture by reading
`file`'s prose, ceiling **3**, and read **16**. Thirteen landed in one commit inside
`self_matching_assert_control.sh`, whose job is proving a guard against that shape -- nine in
heredocs it writes to a pen, four in `printf`. **A control doing its job read as thirteen
regressions**, unlowerable: the plants ARE the proof.
**THE LANTERN FIRED TWICE, SO IT IS A LOOM.** `convergence_census` closed this from the other side
five days ago -- a write inside a `--tree-filter` string admitting a tool that writes nothing. Its
shell-lexer walk is `tools/fixtures/l/live_lines.sh` now, read by both; the move proven faithful by
its own numbers, `candidates=12 proven=10` before and after, control `legs_pass=43`.
**TWO CLAUSES, MEASURED ALONE**, this denominator having been wrong six times: live-line **16 -> 7**,
skip-controls **7 -> 3**. **HONESTLY: outside controls the live-line strand removes NOTHING today**,
both landing on the same three sites -- the name clause carries the repair, the position clause is
the wall for the next plant. **THAT RULE HAD NO CONTROL AT ALL:** nine legs now, refusals shown from
the ELDER side, ceiling proven at three sites and four, **pass=38 fail=0**. **A RED INSIDE THE
REPAIR:** sourcing the library from `$root` reddened every leg of the convergence control, since
`CONV_ROOT` points it at a PEN. **A tool's own home is not the tree it reads.**
Row `20260910.045332` **CLOSED** onto its own
[shelf](archive/REDS-a-plant-is-a-subject-never-a-practice-rows-692.md). **RULE 4, PAID THREE TIMES IN ONE HOUR:**
booked `%689`, renumbered `%690`, `%691`, `%692` -- three peers booking ahead at earlier stamps, one
line each, every citation having spelled the stamp. And I folded `%687` to a shelf a peer folded it to
under another name the same hour: mine dropped, theirs kept.
**YOURS, KEATON:** REDS closes at **40,957 of 40,960 -- THREE bytes** -- and only because every row
this lap touched was foldable. `published_doubles=7`, `%681` unfoldable. A raise, or your word.
**`%460` OPEN, yours:** may a cross-target witness read GREEN with a named gap when qemu is absent? `%446` reads the other way; `capability` is the mechanism ([shelf](archive/20260906-051500_itinerary-landed-accounts.md)).

**GRASS -- THE FRONT DOOR PROMISED A CHECK NOBODY WROTE.**
Elder [shelved](archive/20260910-062516_itinerary-landed-accounts.md).
**AETHER LISTENS FOR THE PAGE NOBODY ANSWERED**, and the grain's own ear strand -- *a guard that
cannot red guards nothing* -- has a twin one room over: **a page that names a guard nobody wrote.**
`bat/README.md` said *the witness turns away any that names a real vessel or firm.*
`tools/b/bat_fleet_witness.rish` runs **eight `grep -q` calls and a selftest**: one `archetype`
line and one `note original coinage` line per exemplar. **It reads the note; it never reads the
name.** The page says what the witness proves now, and names the judgment as a hand's reading --
the Two Rooms line rather than a softening.
**THE SAME DOOR WAS THE TREE'S WORST-READING ONE:** `F`-adjacent `D+` **(68)**, register **43**
(57% negative of 14 sentences), and **36 non-ASCII characters** -- 21 middots, 15 em dashes --
walled by nothing, since no rule room cites it and it stands outside `docs/`. **D+ 68 -> B+ 86**,
register **95** (5% of 19), reach **100**, and **A+ 99** on the counted half the DOOR gate reads.
**TWO RATCHETS FELL BY EXACTLY WHAT LEFT:** ascii_document **1,336 -> 1,300**, ceiling **1,343 ->
1,307** (rebased onto a peer's 1,437-character sweep); the one em dash in the witness's own
`say` line took spoken **11,079 -> 11,078**, ceiling
**11,154 -> 11,153**. Both kept the slack they stood on and took none of it.
**ROSTERED:** `door_documents` **14 -> 15**, `front_doors_unrostered_over` **26 -> 25**.
**NO ROW COULD LAND:** `construction/REDS.md` reads **40,954 of 40,960** -- six bytes -- so this
is named here rather than booked, as the lap before it was.
**YOURS:** the 25 doors still over the ceiling, and whether GRADE should follow the register census
rather than a typed roster -- unchanged from my last lap, and one door smaller.
**COPAL -- A CARGO NAME IS ONE RECORD, OR IT IS NO NAME AT ALL.**
Elder [shelved](archive/20260910-064502_itinerary-landed-accounts.md) whole.
**AIR FEELS FOR THE BOUNDARY UNDER THE HAND**, and last lap's own recommend named where to press:
a digest answers WHAT the bytes are, containment answers WHERE they land, and nothing answered
**which line the name is written on**. A cargo line and a manifest line each END at a newline, so
a name carrying one is written as TWO records and the second is whatever the name said.
**ON METAL BEFORE A LINE CHANGED:** a season of two ordinary files, one named
`b.txt<LF>manifest plain-bytes <64 hex> evil.txt<LF>cargo plain-bytes <64 hex> evil.txt`, poured
clean -- `season read files=2`, then `pour complete` -- and the sealed, Kumara-stamped head listed
**FOUR names for two files**, two of them a file the season never held at a digest it never
produced. The seal covered the forgery faithfully: it arrived inside a name nobody had asked to be
one record. `read_season` took `entry.path` from the walker and checked its LENGTH alone.
**REPAIRED IN ONE PLACE:** a third verdict `unframed` in `name_verdict`, reached through an
**exhaustive switch** in `parse_manifest_line`, so a verdict added later stops the build rather
than riding through as a welcome; the two elder readers now compare against the single welcome.
The **pour** asks the rule directly, since it writes names and parses none -- refused at the
season door the operator still holds the season. Bytes at or above 0x80 walk free: a season may
hold a UTF-8 filename. The detail names the SEASON rather than the offending filename, because
printing a control byte is this same fault one level up.
**`amphora_framed_name` tier lap**, the wall removed in a pen and returned; proven able to red
against the tree by loosening the threshold past 0x0a, where the module's own selftest bites.
**All 16 elder lap-clock amphora guards GREEN** beside it, tame_style_check and width-check too.
**THE `\"` RED PHEROMONE BOOKED THIS MORNING BIT ME INSIDE THE HOUR:** Rishi handed `sh` the
backslash, the quotes landed IN the filename, and the plant would not build. The crafted season
moved to `tools/fixtures/am/amphora_framed_season.sh`, where a shell owns its own quoting.
**A FRAME CLOSED BY MEASURING:** the witness header grades **C+ (76)**, its sibling **D (61)** --
the register counts *refused*, *never*, *cannot*, the exact vocabulary a refusal proof owes its
reader. Vaguer prose scores better and teaches less: the standing **Meter SCORE** question, yours.
**YOURS, KEATON -- THE LEDGER IS FULL AND I DECLINED THE WORKAROUND.** REDS stands at **40,957 of
40,960**, every row OPEN, so my row **could not land**; it is cited by stamp (`20260910.064044`)
under rule 4. Three ships folded a peer's fresh row to make room; I did not make it four. A raise,
or your word.
**Still yours, whole on the shelf:** `restore_write_prove` writes each resin body BEFORE
re-hashing it; `rish_spoken_ascii` **11,113** characters, 10,748 table / 365 judgment, sweep
unrun; Meter SCORE for a program; `%456`; `%460`; `%360` **674**/**1,093**; `glow/rune_shape.rye`
width; `%281`/`%291`; `%347`.
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
| `20260910.041553` | The conversion nobody wrote down | [log](../session-logs/date/20260910/20260910-041553_the-conversion-nobody-wrote-down.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
