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

**Git nib:** `8aa384e0ea` -- HEAD's parent, resolvable everywhere (%401).

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
**PATCHOULI -- THE FLAPPING GUARD WAS CAUGHT IN THE ACT, WAITING ON A PACKET FOREVER.**
Elder [shelved](archive/20260911-003518_itinerary-landed-accounts.md).
**%700 ENDS ON *the cause is inference, never observation*.** My hot pass stopped dead on that very
guard: `recall-tablecloth-query-delivery selftest` sat **29 minutes** in
`__skb_wait_for_more_packets`, **two voluntary context switches**, one socket, load 14.1.
**MECHANISM:** `recv_wire` in `mantra/recall_tablecloth_query_delivery.rye` called `recvfrom` with
no `SO_RCVTIMEO`. A localhost datagram is still a datagram -- drop one and the wait never ends.
**Its two siblings have carried that bound for chapters**; this module alone never received it.
It now sets a **5s** timeout from a named constant with three `invariant:` asserts, matching
`recall_subscribe_poll_delivery.rye`. Wire, tame and width GREEN. **A red and a hang are
one defect:** lose the datagram and the host hangs, win the race and it passes.
**FIRE SEES** (row 2, hand-advanced), the keystone: `assert p2.out contains "1"` proves the product
identity in `tally_a2_list_reducer_witness.rish` while the same file's sibling leg expects **105**,
so a desk answering 105 passes both; `1` sits inside `15` too, and `6` inside `36` one witness over.
**58 legs tree-wide, 21 mine.** Yesterday's sibling guard could not see this half **by
construction** -- it counts only needles the `EXIT:0` trailer supplies. `silent_leg_scan.sh` grows a
**second reading** over the same runners, **disjoint by construction**, lane **zero**, tree **37**;
**control 43 legs, 0 failing, three mutations each biting their own leg.** Nine witnesses GREEN.
**ALSO, both merged with a peer's own lowering in the rebase:** `shim_reason` **949 -> 936**,
spoken ASCII **10585 -> 10536** on touch.
**YOURS, the fleet's:** REDS stood at **40,960 of 40,960**, to the byte, so my row could be seated
only by folding -- `%701` and this lap's own row, its only two BOOKED, to one shelf. It reads
**38,967** now. A pin that seats a row only by shelving one is at the end of its rope, and only
two of its sixteen rows were ever foldable.


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
**PETRICHOR -- THE ROOM THAT WAITS FOR A NEW GENRE SLEPT THROUGH ONE.**
Elder [shelved](archive/20260911-025732_itinerary-landed-accounts.md).
**FIRE SEES** (2).
**THE MARK:** `docs-geode/etc/README.md`, held for a genre not yet arrived, named **eleven** rooms
beside it. **Twelve stood** -- `lessons/` landed `20260910`. My `7c4378380` read past it.
**THE ROOT:** `crushed_index` was built for this fault and reads **membership**, rows against the
room. **A count typed in PROSE is read by nothing**; my shelf holds five more.
**MECHANISM:** `**Neighbors:**` becomes a declared key, as `**Style:**` is; the scan walls
`missing`, `phantom`, `no_target`, `absent` at zero. **PROVEN** 39 legs, four mutations bitten.
**7,632 -> 143ms.**
**REDS FIRST, three, all mine, none caught by me:** `tool_letter_room` (filed by FAMILY where the
law files by the NAME's letter), `fold_shelf_link_repoint` (shelved links lost a level),
`shell_dialect_touch` (GNU-only `sed -i`). **A new file answers laws its subject never names.**
**YOURS:** `# Blog -- one piece stands` goes false the day it grows. A number in the key?

**PHEROMONE -- MY LANE'S SLOWER CLOCK HAD NEVER TURNED, FOR ANY OF ITS 29 GUARDS.**
Elder [shelved](archive/20260911-023422_itinerary-landed-accounts.md).
**FIRE SEES** (row 2, N=4612): the fact most laps route around. Cold open
**251/249/0 red**, hot close **253/251/0 red, 2 gated, `tree_moved=no`**. No lane red I may close -- `%680`, `%689`,
`%678` each OPEN on your word.
**THE FACT AT THE DOOR.** The roster writes the slower clock's reason itself -- **a cadence is a
clock, never an exemption** -- and the run card read **74 cadence guards, 65 never run here**;
`witness_reach_scan.sh` files such a witness under `reached` and reads no card.
**I TURNED IT FOR MY LANE.** 29 cadence guards across Glow, Mantra, Comlink and Tablecloth, run by
name through the roster's own runner: **all 29 GREEN**, 1,583s whole, median 13s, slowest
`glow_desk_run` 472s, **13 at or under 4s**. `cadence_never_run_here` **65 -> 36**,
`guards_never_run_here` **70 -> 41** -- moved by the work rather than by editing a number.
**MECHANISM:** the scan states its convention three times -- *named and bounded, the question is
which guards to look at, never how many* -- and `cadence_never_run_here` was its last reading
printing a quantity and naming nobody, the defect `%592` repaired one reading over. It prints
`cadence_never_run_oldest:` now, bounded at 8, **OLDEST first**: the ratchet beside it rises on a
blank tier so its NEWEST row holds the context, where this rises when nobody turns the clock, so its
oldest is the longest-unkept promise. Read today: **`sow` seated `20260823.134057`**.
**PROVEN:** ten control legs both sides -- named with stamps, the ran guard absent, a kept clock
naming nobody, the bound holding, an unseated row under a zero stamp. **Four mutations each bit
their own leg.** Witness GREEN.
[Paper](../active-designing/20260911-023422_the-clock-that-turned.md) A 94.
**YOURS, two:** (1) **36 still read never run here** and the runner takes `--tier cadence`; the tree
lacks a hand or a rhythm that turns it. (2) Thirteen of my 29 answer in four seconds, under guards
the lap clock carries -- each has a reason beyond cost at its row, so whether cost alone decides a
tier is your word, measurement in hand.

**GRASS -- THE ROOM THAT HOUSES THE LAW WAS THE LAST ROOM TO ANSWER IT.**
Elder [shelved](archive/20260911-041810_itinerary-landed-accounts.md).
**AIR FEELS** (row 1, lap 4620, hand-advanced past a row read twice today): press every post.
**REDS FIRST:** cold **250 green, 1 red** -- `standing_equipment` reading `dated_path` off the run
card, which is `%626`, OPEN and gated on Keaton's word. Nothing mine.
**PRESSED, AND IT HELD:** the DOOR roster of `prose_register_scan.sh` is 19 hand-typed paths against
115 living front doors, and it already publishes `front_doors_unrostered_over` with a `candidate:`
line each, so the blind spot carries a live number. 120 read.
**THE POST THAT GAVE:** the living reading of `two_rooms_doorway`, opened at 90 last lap. The 23
living `context/` pages naming no room are this tree's core guides -- `GAUGE_STYLE.md`,
`TAME_CORE.md`, `LEXICON.md`, the three registers, the voice notes -- so the room housing
`TWO_ROOMS.md` was the last to answer it, one reading past the lap that repaired its `specs/` shelf.
**MECHANISM:** each page takes a `**Room:**` line beside what its Status already said, judged from
the body rather than the title -- **6 `checkable`**, **8 `mixed`**, **9 `vision`**. Three are
mirrored documents, so `document_mirror_scan.sh write` carried the line to `ember-voices/KYRI.md`,
`spellbook/README.md` and `biochemistry/README.md` in the same commit.
**MEASURED:** `context/` 99 pages, **0** living-silent; living ceiling **90 -> 67**, slack zero,
`fails=3` unmoved. Witness GREEN over 70 behaviors; mirror, doorway-touch, prose-register and
ascii-document GREEN beside it. Cards **A 91 to A+ 98**.
**THE DOOR IS `%642`'s:** a room joins free by being repaired; the remainder whole reads as a gate.
**YOURS:** the 67 -- 33 `active-designing`, 20 `manual`, 8 `docs-geode`, 6 silo. And whether a
living door should end up GATED.
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
**COPAL -- A DISCOVERY READING WAS ITERATING A LIST SOMEBODY TYPED.**
Elder [shelved](archive/20260911-031057_itinerary-landed-accounts.md).
**AIR FEELS** (row 1, N=4616): press every post; the row's test is to pull a part and see if it
comes free. **REDS FIRST:** none at open -- cold **253/251 green, 0 red, 2 gated**. **MID-LAP,
BOTH MINE, BOTH CLOSED:** hot read `readme_metrics` (four plant `.rye` files, 1735 -> 1739,
regenerated) and `shim_reason` **+2 over its ceiling** -- my two new legs written with a bare
`else` string, the wall biting at write time rather than a week later. Both took the interpolated
`${v.err}` form. A peer lowered that ceiling to **936** on the rebase, already counting my repair,
so the reading meets it exactly. **HOT scoped 222 run, 221 green, 0 red, `tree_moved=no`.**
**THE POST THAT GAVE.** `amphora_bounds_agree` states four relations, and the FIRST is a discovery
rather than a declaration: *when two roofs carry one name, either they agree or the name is doing
two jobs.* Its scan iterated `NAMES="max_vessel_len max_cargo digest_hex_len"` -- a list a hand
typed. The other three are declared by a marker above a const, which is their point. A discovery
reading a typed roster is where the tree grows past the instrument in silence.
**MECHANISM:** `discovered_names()` takes the scan's own `rg` pattern over the root and keeps every
identifier declared as a spelled `u<N>` const in **two or more distinct files**; the roster is that
unioned with the seated three, which stay seated because a seated name VANISHING from the room is a
fault this reading must still name. Four `same_name_*` readings print every run.
**MEASURED `20260911.022245`: derived and seated both answer three, `same_name_unseated=none`** --
`digest_hex_len` in 4 roofs, `max_vessel_len` in 3, `max_cargo` in 2. The widening lowers nothing
today and holds the door for the fourth family.
**THE MUTATION BIT.** Two plant roofs declaring `max_frame_len` at 4096 and 2048 answer
`verdict=ok` and **exit 0** the moment the roster stops being derived -- the false GREEN shown from
the failing side. Both directions land as plants; the family stands at **twelve pairs**.
**ON TOUCH, three docs resynced:** the roster note said *one `covers:` declaration stands today*
where the scan reads **two**; `amphora/README.md` named the readings *path C - alias - couples*,
passing over covers; the scan's header named the typed three. All three point at the instrument.
**`20260908`'s SHAPE, ONE ROOM OVER:** `opening_lines`, `tame_check` and `rune_assert_sweep` each
took a lap that week for it. **A 91 / B+ 87 / B+ 86.**
**YOURS:** the other three readings are opt-in by design, and `covers:` stands at **two
declarations over 37 bounds**. Whether an undeclared ORDER should be inferred and reported -- never
gated -- I decline without your word, since inference is what this guard was built to refuse.
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
