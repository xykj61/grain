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
- **Stamp and name, never an ascending mark.** Mark a lap by its one-clock stamp and a plain name -- `the standing movement (20260821-142939)` -- rather than `Fold AI`, `f0-f63`, or `X0/X1` for planned work. Count a total with `git log --grep ... | wc -l`. Waymarks stay (names, not counts); `rung` stays where a real ladder exists in code. A room that outgrows a reader folds to `<room>/date/YYYYMMDD/` keeping the WHOLE stamp in the filename, and a stale reference is resolved rather than rewritten -- `tools/d/dated_path_resolve.rish`. No fold ships without `tools/d/dated_path_witness.rish` GREEN, and a REDS fold runs through `tools/fixtures/r/reds_fold.sh`. **Waymark rungs are the retired form too** (%329): mark a rung by waymark, module or plain name, and stamp -- `FORA<N>`-shaped counters red `tools/w/waymark_rung_drift_witness.rish`, whose ceiling only falls. New `equinox_eNNN` guards take stamp-and-name (%330 books the family rename). Rule: `.claude/rules/stamp-and-name.md`.
- **The amend behind the empty-index check and its own target** (%255; %331): between commit and amend, `test -z "$(git diff --cached --stat)"` AND HEAD still equal to the hash read at the commit -- an amend resolves HEAD when it RUNS, and a peer landing between the calls puts your line into their commit.
- **Fetch-before-book** (`20260827`, %230/%252 closed): read a REDS row number only after `git fetch xy`; a collision renumbers to the fetched head.
- **Spelling: American.** `color` never `colour`; normalize on touch.
- **Style sweep before every send** -- Radiant pass over the round's prose (Twilight for a night piece), register only never a claim. Seed section 6.
- **Rota of the canon.** Each lap, deep-read ONE ROW of the 5 x 3 council grid in `recursion-prompts/seed/autonomous-loop.seed.md` section 1 -- lap N reads row N mod 5, three documents, so the canon returns roughly daily.
- **Roster cold, then hot -- and hold still while it runs.** Open the lap with `sh tools/fixtures/s/standing_equipment_run.sh`, let it finish; run again after `git add` as `... --hot` so the green measures the tree the commit ships (%174). A cold open over a dirty index refuses under `run_verdict=lap_unclosed`; `--hot` claims a round's own staged paths, and the flags compose (%223). The runner digests the tree at open and close, refusing `tree_moved` when they differ; editing it mid-run kills the shell (%221). **`--scoped`** (the fusion, granted `20260828`, landed `20260829`): a cold open or rebase re-verify with a FULL green receipt reproves only what moved since its head; skips named per guard, unmapped always runs, hot close and cadence stay full (receipts chain from full greens alone). **Counts come from the scan, never here.** Roster `construction/standing-equipment.kyri`. A `tier` names its clock: absent or `lap` every run, `cadence` the fifth round, when `--all` sings the choirs. A tier is a cadence, never an exemption; an unknown word refuses at zero.
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit` and `--amend` **only** -- cherry-pick and rebase skip it, so `tools/hooks/post-commit` records the debt in `.git/` and rule one pays it next commit (%339). A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard can do is refuse to open the next lap over the wreckage, which is `staged_uncommitted` on line one and `run_verdict=lap_unclosed` when a full-roster pass meets a dirty index without `--hot`. **A dead lap leaves no dirty index** -- its leavings are stashed, and a stash is neither tree nor index; open with `git stash list` (%321).
- **Grade what you touch.** Every document, comment block, or design the lap opens gets one reading: `sh tools/fixtures/q/qa_report_card.sh <path> --setting door|field|meter --service N`. Four readings meaned to one grade -- Register, Reach, Truth (a gate: under 60 reads F), Service (judged against this card, in four questions worth 25 each: named, reached, current, and which side it carries -- public `grain-os/grain`, working `xy`, or both). **B or better stands.** Below B pushes **one** molt frame onto the round's stack, worked down before the sweep resumes; the stack is **bounded at depth 2**, and anything deeper becomes a line here. A dated writing leaves a mutant plus a bannered fossil and a Class M row; a living path molts in place under a checkpoint. **A low grade is not a red** -- Standfast owns what is wrong, this owns what could be better. **Match the setting to the class:** a pointer card reads `meter`, and a program is graded on its comments rather than its code (%276). Rule: `.claude/rules/quality-assurance.md`.
- **Reds first.** Close open agent-closable rows in `construction/REDS.md` before new work; one you cannot close surfaces like a gate.
- **Raw transcripts land in `session-output/`** (gitignored, `20260828`): each loop tees its outer transcript to one per-seat file, overwritten in place -- `mkdir -p session-output && <loop> 2>&1 | tee session-output/<seat>.txt` -- so agents read a peer's full output by path, not by paste.
- **Read scope -- open shelves and closed stacks** (`20260827.155213`): walk the open shelves; fetch a closed stack only by a named path -- every `date/`, `archive/`, and `yonder/` shelf, plus the rule's named roster. Never `ls` the root (`MAP.md` is the walk), never walk `tools/` whole (resolve by name), scope greps to the lane's rooms -- the whole-tree reference sweep before a move stays whole-tree by law. **A jailed inner lap (Mind's Codex) proves scoped witnesses only; the cold/hot roster rides with the pier and the unjailed benches.** Rule: `.claude/rules/read-scope.md`.
- **A fresh clone inits its submodules first, and a global `insteadOf` will stop it.** The vendored rungs need `vendor/{microkit,monocypher,pqclean,sel4}` checked out, and a RED from an empty `vendor/` is an environment fact rather than a tree red. A host that rewrites `https://github.com/` to ssh (this bench does) cannot clone the public third-party submodules at all, since the key has no rights there -- `GIT_CONFIG_GLOBAL=/dev/null git submodule update --init <path>` clones each one over plain https without touching the host's config. `--init --recursive` aborts on the first unreachable repository and leaves the rest untouched, so name the paths.

### Seated, and still live

*The panchanga, the fusion build, and the landed arcs rest on the [fourth shelf](archive/20260831-090000_itinerary-settled-decisions.md).*

- **The counsel campaign, Phase 1 standing** (`20260828`, Keaton's word): a lap may lift counsel insights into their right rooms as fresh-stamped mutants (B-door QA), banner the elders, Class M the rows -- `tools/fixtures/c/counsel_census_scan.sh` orders by citer count (941 pieces, 325 cited, 616 orphans at seating); the fourth shed circles on the word; **deep debride declined**.
- **An operational shell script molts to Rishi on substantial touch** (`20260828`): launchers, loops, tools a hand runs -- the `.sh -> .rish` family the MIND adaptation mapped, generalized; scan and control fixtures STAY sh by the witness convention.

- **The three Earth ships** (`20260904` names): unattended Claude Code; field GUI `~/grain` Cursor. **Incense** law/review/captain, `grain-incense`; **Pheromone** molecular, `grain-pheromone`; **Petrichor** docs-geode and prose-product, `grain-petrichor`. Machines are doors. Captain prompt (two doors, Mac or Dallas pier): `expanding-prompts/20260904-171306_incense-the-field-captain-two-doors.md`. Loop `fleet-loop.sh incense|pheromone|petrichor` from that tree (`tools/l/launch-earth-ships-chapter.rish`). One writer per tree (%291). Parked: `~/grain-mystery`, `~/grain-silence`. Elder charter `20260829.203718` stays testimony.
- **Fleet re-arm**: `sh tools/f/fleet_rearm.sh`.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `fb111516cc` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- I BUILT A WALL FOR `%524` AND WITHDREW IT, BECAUSE A PEER LANDED ONE FOR THE SAME RED IN THE SAME HOUR AND THEIRS PUBLISHED FIRST.**
Elder [shelved](archive/20260907-141249_itinerary-landed-accounts.md). The cold open answered
`guards_red=3`, one root: this card linked `rows-571` where the shelf is `rows-570`. `%524`'s
**fourth firing** -- and a peer repaired the link and landed **rule six** of
`tools/hooks/pre-commit` while my own wall was in flight. Theirs stands; mine is withdrawn whole
rather than roofing one question twice, which is the derived spine's rule applied to a repair
instead of to a number. **Sixth time in two days** that a finding met its peer inside one hour.

**THE TWO WALLS DIFFER, AND THE DIFFERENCE IS YOURS.** Theirs reads the **whole index** (544ms),
so it sees the rebase class that is three of `%524`'s four firings -- the half no staged-set
reading can reach. Mine read `readme_reach`'s own findings and kept only the pages **this commit
staged**, so it could never refuse a commit the roster would accept. **That is the property
`%524` declined the lap for:** *eight ships run that file, and a mistake in it is a fleet that
cannot commit.* Theirs refuses on any broken living link anywhere, so **one hand's break now stops
every ship's commit until somebody repairs it.** I proved the split is buildable -- a pen holding
two breaks at once where exactly one bites, 26 cases, real commits through the armed hook -- and
did not land it. **Should the wall refuse for a peer's break, or only for your own?** The pen is
on `stash@{0}` if the answer is the second.

**LANDED, AND ITS OWN FINDING** (`20260907.153124`, cited by stamp until `xy` binds it) -- booked one number, and a peer had spent it and the one before it by the time my rebase landed; the stamp is what made the re-seat one line. `plant_adoption_scan.sh` decided
adoption by grepping the helper's **path**, in a header arguing that sourcing is exact where
`cmp -s` is a proxy. My control's paragraph explaining **why it does not import the plant law**
counted as an import, raising `sourcing` 12 to 13 and reding `plant`. **A grep for a path reads
every mention of it, including the ones that say the opposite.** The reading is the dot command
now, which all twelve real adopters carry and no comment does. **Still yours:** `remainder=164`
counts every control that never plants at all, so it can never reach zero and nobody can act on
it -- the adoption question its author left for your word.

**AND THE PIER'S OWN CAPACITY, unasked.** Three ships ran full cold roster passes **concurrently**
on this 4-core pier within one hour; mine took **1,527s** cold and **1,304s** hot against a
nominal ~1,139. Eight ships x every lap is the pier's whole capacity spent proving one tree.
`--scoped` exists for exactly this and the cold open does not reach for it.

**PATCHOULI -- FOUR LAPS OF THIS SEAT'S WORK WERE WRITTEN AND NEVER SENT.**
Elder [folded](archive/20260907-155612_itinerary-landed-accounts.md); the account is in the
[log](../session-logs/date/20260907/20260907-155612_the-claim-a-sweep-cannot-follow.kyri).
`stash_record` **red** named four logs parked in round-open stashes; recovered with
`git checkout <stash> -- <path>`, which reads the **tree** so the mode rides. Rows
`20260907.111135`, `.151232` and `.155612` land **CLOSED** and folded, cited by stamp until the
spine binds them -- rule 4, enforced by its own guard on this card.

**THE FENCE THAT WAS MISSING.** `mantra/src/diff.rye` allocated an LCS table of `(m+1) * (n+1)`
`u32` cells from two caller-chosen lengths with **no max, no named error, no edge check** --
two 100,000-line documents would have **asked 40 GB**. `max_diff_lines` now **imports**
`weave.max_weave_lines`, the cell count is **derived** from a byte bound, and `check_bounds` is a
**function** a witness presses at the ceiling and one past. Control 7 to **10**. GREEN, with
`width_check_th3` beside it -- **still unrostered, and I did not roster it.**

**`20260907.155612`: `--next` reads the spine plus this tree's COMMITTED rows, so two parked laps
here both booked one number** -- the derived-spine class with no second host; the fence row
renumbered a **fifth** time mid-send. **`%441`'s erratum never reached the foundation**, which still
calls the weave unbuilt: a claim is copied where a path is not. **A peer's red rides in** --
`reds_ledger_monotone` refuses `number_double_bound` on `%512`, on two shelves upstream and unseen
by `reds_spine_derive`, which reads bindings not shelves.

**Still yours:** the several-line interleave; **`%530`'s two rows**; and **is a
negative-existence claim about a room we own worth a ratchet?**

**DIFFUSER -- THE FREE RULE SURVIVES A REAL MEMBERSHIP, AND WHICH ADDRESSES YOU LEAVE EMPTY IS WORTH MORE THAN HOW MANY.**
Elder and this lap's own detail both [shelved](archive/20260907-145954_itinerary-landed-accounts.md).
Last lap's falsifier, fired -- every reading assumed the shape **full**. Two S(n,k) graphs holed
**sixteen** ways, every live pair routed by three rules against a walk **through live members
only**. **The published rule loses one packet in six** at 95 percent. Neighbour liveness
stops every hole loss and starts **cycling**: the missing thing is **memory, not a table**. A packet
carrying where it has stood **delivers every reachable pair of every configuration** at a peak state
of **25 entries on 840 vertices** -- bounded by the path, never the membership. **THE GEOMETRY IS
WHAT A BUILDER CAN ACT ON.** A far-end class, **120 of 840**, costs **zero** stretch; the **same 120
at the door split the shape into four**, reading *837 of 837 delivered* until the unreachable pairs
stood beside it. GREEN as **`topology_occupied`**,
`tier cadence`; the paper `20260907-144849_the-holes-you-choose.md` reads **A (92)** at Field.
**Yours, one, the falsifier a deployment meets first:** the free geometry is measured only at
**whole** classes; 800 members on 840 leaves 40 holes with no class to hide them in.
**THE LAP WAS PARKED AT A ROUND OPEN AND RECOVERED FROM `stash@{0}`** -- `%499` from the receiving
end: nothing lost, a whole lap spent. Two stale claims corrected at the landing, both on the shelf.
**`live_group_plant`, seventh firing, sharpened**: red on a concurrent hot pass, **GREEN alone**,
twice today -- so it joins `plant`, `shared_pen` and `fleet_watch` in the concurrent-pen family
rather than the launch shape I blamed. Four guards, one cause. **Still yours.**

**PETRICHOR -- THE GRADER'S TWO READINGS DISAGREE ABOUT WHAT PROSE IS.**
Elder [shelved](archive/20260907-144904_itinerary-landed-accounts.md). **Both cold-roster reds were
one broken link here:** line 53 named `rows-571` where disk reads `rows-570`. `%524`'s fifth
firing -- one character, three red rows. **Then the lane's door:** `docs-geode/README.md` opened on
*fascial waves feed this shelf; MUR, Tally and weave rounds crush it* -- four coined words, no plain
function, on the page a newcomer meets first. It now names three doors in order and says **crush
means compile**. **B 84 -> B+ 87.** **AND THE REGRADE FOUND THE ROW:** `20260907.144904` **OPEN**
(a peer took `%572` and `%573` mid-rebase, so the stamp is the key here). The Reach awk in
`qa_report_card.sh` still spells `%451`'s elder bullet rule, so a paragraph opening in **bold** --
how Gauge writes -- leaves grade and link density while Register counts it. My page read **82 words
of 191**, graded 13 against 9. Over 5,549 tracked Markdown files: **22,041 lines in 4,120 files**
counted by one reading, dropped by the other. **I did not widen it** -- it re-grades every page
unmeasured. **Both pins returned from the rebase at their ceilings** -- REDS held 520 bytes
for a three-field row, this card none. **Yours:** may a lap correct its own grader?

**PHEROMONE -- THE ASCII LAW HELD TWO COMMENT MARKS, AND A THIRD LANGUAGE OF OUR OWN SAT OUTSIDE IT.**
Row `20260907.144002` **BOOKED**, [folded](archive/REDS-the-third-comment-mark-rows-575.md).
`ascii_comment_witness` held `ascii-first.md` for `//` in Rye and `#` in Rishi and shell; its head
said **"ONE LAW, TWO COMMENT SYNTAXES"**. **Glow spells a comment `::`**, and its
**451 sources were read by no ASCII meter at all**: **942 characters across 342 files**, where the
elder's `20260825` sweep read 2,163 files, no `.glow`. **The third meter needs no escape
hatch, and the language gives the reason:** where Rye must dodge a `\\` multiline string and shell a
heredoc, `glow/tokens.rye:239` refuses a newline inside a cord. So **all 942 sit in comments and
none in program content**, measured not inherited. **The blind
spot is PRINTED** where the siblings leave theirs in prose: a trailing `::` goes unread and
`trailing_unread` counts it, **zero**. Control **14**, ceiling both ways; ratchet **942**,
falling only. **Next: the sweep.**

**AND THE COLD OPEN'S TWO REDS WERE THIS CARD'S OWN LINK** -- the Bakery line named `rows-571` where
that row folded to **`rows-570`**, **the class firing a line above the paragraph naming it**. Both
GREEN. Three came hot on one root, my row over the REDS pin, closed by that fold; the
rebase then renumbered it off a peer's published number -- the spine's 7th firing. Prior rounds
[folded](archive/20260907-144002_itinerary-landed-accounts.md). **Yours:** a mistyped link here reds
eight ships.

**INCENSE -- THE SAME PROVEN LAP WAS PARKED TWICE, AND THE SECOND PARK COST IT ITS NUMBER.** Elder
[shelved](archive/20260907-154440_itinerary-landed-accounts.md); row `20260907.154440` **BOOKED**
-- the number waits on `xy`, the stamp is the key. `fleet_round_open.sh` stashed this finished round
at `20260907.155144` and **again at `162505`**, before either pass could commit; `git stash apply`
returned all thirteen files whole both times, with three conflicts in the ledger and this card where
**both hands' lines stand**. The row it carries is on the [shelf](archive/20260907-154440_itinerary-landed-accounts.md)
and whole on [its own REDS shelf](archive/REDS-a-guards-own-exemption-rows-582.md). **The row
renumbered TWICE while parked** -- a peer published `%574` on stamp `20260907.144904` between the
parks, and six more rows landed during the rebase -- and **`%513`'s citation half made each move
cost one line**, since every living citation already spelled the stamp.

**And each recovery costs more than the park saved.** Landing it took six repairs no author wrote
-- the ledger headline census, a misordered shelf row (`%440`, twelfth firing), three shelf links,
two unmerged files, this card over its bound -- and on the second pass a seventh and an eighth: the
renumber, and a duplicate `%524` shelf withdrawn because a peer published one for the same row
inside the hour. The rebase also carried the REDS pin 3,521 bytes over its bound, closed by folding
this row. **A parked lap is not a lap kept whole; it is a lap whose bill comes due at a stranger's
desk, once per park.**

**Yours, two:** sixteen files still remove a shared pen, five the Caravan poll family on ONE
sentinel -- may a lap repair a pen it cannot witness? And `rule_twin` has stood red ten days behind
`gate %7` on a **zero-slack drift ceiling over a population that grows whenever a rule is written**,
agreement rising **4 of 40 -> 12 of 51**. A **floor on `pairs_agree`** reads that tree as improving;
changing what GREEN means is yours.

**`%499` OPEN, AND IT HAS NOW PARKED ONE LAP OF MINE TWICE AND COPAL'S ONCE, TODAY** -- the
round-open parks a lost race one local test tells from a rewrite. Discriminator on
[the shelf](archive/20260907-154440_itinerary-landed-accounts.md). **Not taken:** six ships run that
file. **Yours, and COPAL asks it too -- rebase there rather than park?**

**Yours, one question; law, so INCENSE may own it.** The five negatives `mycelium` keeps are its
**subject**: two Meter claims, a *no real key, no funds, no network, no custody* disclaimer, and the
benediction [`radiant-wishes-ending`](../.claude/rules/radiant-wishes-ending.md) asks for. **A Door
page obeying both floors at four: 16% of a 20% ceiling.**


**`%481` CLOSED, both accounts folded** ([shelf](archive/20260906-133957_itinerary-landed-accounts.md)) -- **a marker makes a pin longer, so the one meter aimed here read the damage as growth**, three firings, the last caught before its push.
**AND THE EQUALITY ARC HAD NO RUNNER FOR 7 OF 8** -- `%482` **BOOKED**
([shelf](archive/REDS-a-proof-nobody-runs-rows-482.md)). The four Mantra gates build GREEN,
**unheard rather than rotted**, now `tier cadence` 92s; Aurora's three and Caravan's one stay
unheard. **Yours:** `src/gate/README.md` graded Truth **100 on twelve resolving paths** over seven
unrun proofs.
**The identity gap** -- two branches inserting collide at one small integer and merge refuses them
`PositionTextDisagrees`, since `pos` counts inside one weave. Closing it wants a wider `Line`; the
guard said to lock that is `%500` above, and it now reds honestly.
**`%440` fired ELEVEN times across four laps** -- a peer's row low at the cold open, then every rebase auto-merging the shelf; one dedupe-and-sort each time, by hand. **Yours.**

**PHEROMONE `%460` OPEN** ([shelf](archive/20260906-051500_itinerary-landed-accounts.md)). **Yours:** may a cross-target witness read GREEN with a named gap when qemu is absent? `%446` reads the other way; `capability` is the mechanism.

**GRASS -- A READING OF NOTHING IS NOT A CLEAN TREE.** Elder
[shelved](archive/20260907-153705_itinerary-landed-accounts.md); row `20260907.153705`, by stamp.
Fed an empty pipe, `retired_word_scan.sh` printed `hits=0`, exit 0 -- a swept tree's bytes -- and
its caller supplied the count, so a dead roster published `OK duty1 ... none across 0 pages`. Now
`absent=` beside them, **exit 2** naming `roster_empty` or `roster_all_absent`; PARTIAL reports.
Control **10 -> 14**; the last leg strips the refusal, so it is told from a bypass.

**COPAL -- THE DOOR REGISTER GATES TWELVE PAGES; THIRTY MORE STAND OVER ITS CEILING.**
Elder [shelved](archive/20260907-170601_itinerary-landed-accounts.md). `prose_register_scan.sh`
NAMES its Door roster rather than discovering it, so a page never reds on work it did not agree to
cover. Measured: **80 front doors** carry the eight-sentence floor, **30 read over the 20%
ceiling**, so `door_over_ceiling=0` says *the doors that agreed are inside*. Mine was one of the
thirty at **29% of 41 sentences**; six restated to lead with what is, every claim and path held,
reads **14%**, and `amphora/README.md` joins the roster in the same commit -- **B 84 -> B+ 88**.
The blind spot is printed in the scan's head; **the way in**: sweep, then add the path. **Yours:** `%499` -- **rebase there rather than park?** Standing: arithmetic in the bounds
reader; a `band` word; `ios_app_shell`, LOCA.

**MANY HANDS** (`20260828`): custody MANUAL, one writer per checkout; every clone seats `ww`
(gate %1) and `.git/ssh_config_jail`.

**Sibling finds:** Mystery's module-label guard fails open on BSD grep; portable, it names elder labels in `fascia_metric_v0.rish`. **Tablecloth, one, cross-lane:** its name desk
reads one of `max_name`'s two call sites (`parse_manifest` reads it too, over the same fixed
`[max_name]u8`). *The four uncontrolled `*_example_missing` verdicts are no longer a find: the work
stands written at `cc1da84f7`, parked by a round-open and unlanded since `20260905` (`%499`).* **Dream's parked packages:**
`xy/pier/diverged-20260831-{064342,115245}`, neither landed, neither mine. **CION:** `drey`'s rung marks are the retired form (%329). **Fleet loop (%387):** should a
round's opening stash stop an in-flight pass in its own tree.

**Bounds raised `20260906`, both derived, both yours:** card and REDS pin to 40,960 (8 ships x 2,048 live front; 8 x 4,096 OPEN set + 8,192 header). **Each is sized per ship, so both re-open at twelve** -- and the pin's is also sized by how fast reds close (`%360`, 8,213 bytes, open since `20260830`).
**`%456` OPEN -- eight ships share ONE login, so one credential is a fleet-wide outage** (read from `agent-jail.sh` source, so `%458` leaves it standing; the pier half is unmeasured from inside the enclosure). Seven died 3 laps each in ten seconds on `OAuth session expired and could not be refreshed`. The refresh token had **27 days** left, so expiry is excluded -- the leading read is **rotation**: first refresher strands the rest and the pier's own copy. **Falsifier is cheap:** watch whether the pier's refresh value changes after a ship refreshes. Landed: `claude_refresh_dead()` names a dead credential instead of seeding it, proven 3 ways, and `sh tools/fixtures/f/fleet_login_scan.sh` answers it in one command. **Yours, gate 3:** one login per ship is the fix. **A resource shared by every ship has no blast radius smaller than the fleet.**
**`shell_dialect` re-diagnosed:** the `sed -i` repair stands; it reds on ONE case of 47 -- *a guard
without its instrument names rg rather than a file*. `shell_portable_control.sh` takes `rg` off PATH
by dropping every entry holding an executable `rg`, and this NixOS pier keeps `rg` and `sh` in one
directory, so the scan under test cannot start. A pen of symlinks to every tool but `rg` is the fix.
**Hot pass `20260906.212721`: 155 guards, 152 green, 0 red, 3 gated, 1139s** -- `tree_moved=no`, `skipped_capability` **1 -> 0**.
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
**Yours, two (%417).** A **guided map** fits neither shape offered: `MAP.md` reads **C/74** at 67
links over 913 words -- 7 per 100 against Door's 1 -- where the root README carries 53 over 2,005
and reads B+. **Second instance `20260906`:** `docs/COMPASS.md` reads **C+/79** on reach alone, 4
links over **49 words** of mostly table -- under the index floor, yet declaring `Depth: guide`.
**Yours, one.** Door's ceiling is **9** against module heads running 12-17. Of 163 sampled
programs 115 read below B -- yet **51 sat under the register floor** with nothing measurable,
leaving **64** truly scored at 9-23. That second number owns the ceiling question, and Gauge's own
table seats **witness headers** at Meter where this card grades every program head at Door.
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

**BOOKED `20260907.074815` -- two grants.** *petrichor* molts, relinks and shed-preps in its lane once synergy with Mantra, the weave and Tablecloth is proven; *diffuser with bakery* researches table stores for the most TAME-aligned scheme, then silos and plans. [Brief](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

**BOOKED `20260907.074407` -- petrichor: the operator manual into docs-geode; `manual/` and `docs-geode/` one room or two. [Brief](../active-development/20260907-074407_the-operator-manual-and-two-doc-rooms.md).**

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
| `20260907.153124` | A wall built for a red a peer had already walled | [log](../session-logs/date/20260907/20260907-153124_a-wall-built-for-a-red-a-peer-had-already-walled.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
