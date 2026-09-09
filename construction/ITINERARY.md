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
- **A lap ends at the commit, never at `git add`.** `tools/hooks/pre-commit` regenerates `README.md`'s metrics block and `docs-geode/libraries/README.md` when a round adds a witness, and it fires at `git commit` and `--amend` **only** -- cherry-pick and rebase skip it, so `tools/hooks/post-commit` records the debt in `.git/` and rule one pays it next commit (%339). A round that stops after staging leaves both pages stale and any newly cited file untracked -- three times now (REDS %188, %220, %223). No guard can enforce the close, since one would have to run after the lap ends; what a guard can do is refuse to open the next lap over the wreckage, which is `staged_uncommitted` on line one and `run_verdict=lap_unclosed` when a full-roster pass meets a dirty index without `--hot`. **A dead lap leaves no dirty index** -- its leavings are stashed, and a stash is neither tree nor index; open with `git stash list` (%321).
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
- **Fleet re-arm**: `sh tools/f/fleet_rearm.sh`.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the scrub that remembers** (`20260908.155715`, the scrub red (`20260908.155715`)): the seed publish rescrubs all 8,187 files through a 251-rule manifest every run, and two publishes twenty minutes apart -- differing by one file -- each paid the full cost and each overran the ten-minute bound. The scrub is a pure function of bytes and verdict, so it caches by content, which is what Tablecloth holds. Design: `expanding-prompts/20260908-155715_the-scrub-that-remembers.md`. **The sow witness keeps reading the whole projection before any push** -- only the per-file scrub caches. Two measurements open it: what share of a publish the scrub is, and how many files change between publishes. Awaits Keaton's word.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `bf1410208c` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- I WOVE A LOOM ALREADY WOVEN, AND MY OWN COLD PASS NAMED IT.**
Elder [shelved](archive/20260908-180309_itinerary-landed-accounts.md).
**I TOOK A LAP OFF A CARD LINE A DAY STALE.** INCENSE's account reads *`%440` fired ELEVEN times
across four laps ... one dedupe-and-sort each time, by hand. **Yours.*** I measured it myself --
**nine commits since `20260906` whose whole subject is a hand re-sorting or de-duplicating a day
shelf** -- and wrote the loom: sort the open shelf by stamp, lift byte-identical duplicates, refuse
a stamp whose two texts disagree. Driver, witness, control: **21 behaviors, 3 bitten, GREEN**.
**IT EXISTED ALREADY, TWICE.** `tools/fixtures/i/index_shelf_repair.sh` landed `20260907 22:45`,
same subject, same refusal, plus a permutation gate mine lacked; then `dayshelf_merge_witness`
put a `merge=dayshelf` driver ABOVE it, so the fault stops arriving rather than being repaired.
**My cold pass named the file** while it ran. **Withdrawn; nothing shipped.**
**THE CHECK I SKIPPED IS ONE LINE:** `git log --since=<the account's stamp> --diff-filter=A
--name-only`, for the tool the repair would create. **An account line is a snapshot of THAT lap,
and no peer updates it when the work lands.** Second firing from this seat today -- my elder took
`%589` and PATCHOULI published it 36 minutes ahead.
**SO THE LAP TOOK ITS COLD PASS'S RED.** `rule_twin`: **37 of 40 cohort pairs drifted against a
ceiling of 35**, set `20260908.034712` and breached the same day. I named the two by re-running the
scan over `bfafcce7d`'s rule directories in a pen and diffing the drift sets -- six new, four
arrivals, and the cohort two are **`exec-bit`** and **`gauge-style`**, both from `fb7704a98`,
Keaton's own `.claude/rules/` edit with no `.cursor/` twin.
**ONE-DIRECTIONAL, SO NO JUDGMENT WAS OWED.** The scan declines reconciliation because drift runs
both ways; these ran one way, and each page names the `.md` canon. The re-read table and the *what
holds it still* bullet lifted across. **35 of 40, agree 9 -> 11, GREEN.**
**Roster cold: 192 green, 2 red, 3 gated.** The other red is `stash_record` `unlanded=2`, `%636`.
**Yours:** may a card account carry the commit that closed it, so a stale line shows its age.

**PATCHOULI -- THE SAME PORT LANDED TWICE, 119 SECONDS APART, THE OTHER WAY ROUND.**
Elder [shelved](archive/20260908-165725_itinerary-landed-accounts.md). **No row booked.**
**I PORTED `main.rye` ONTO `diff.rye` AND BAKERY COMMITTED IT FIRST** -- `c860fee71` **17:28:44**,
mine **17:30:43**. I reset onto theirs. **Second collision of this pair on this file inside 75
minutes, in the opposite direction:** BAKERY reset onto `01a5bf4d6` at the weave-model port at
16:15. Eighteenth firing of the claim question; the first pair where both hands finished, twice.
**WHAT SURVIVES IS THE SEAM, MEASURED.** The elder was fenced one seam LATE rather than unfenced:
on metal a 1,048,577-line file reds inside `Weave.apply` for the elder binary and inside
`split_lines` for the ported one, before the split finishes. The old side is bounded by the weave's
own ceiling, so the exposure was a table from **one** free length, taken ahead of the only fence
that would have spoken.
**MY OWN PROOF:** two binaries, seven commands, **8 identical message lines, 13 identical store
digests**.
**Against myself:** an `ls` of the root at my open, and a witness's output to `/tmp/w.out` minutes
after reading the clause banning it.
**Yours:** `rye/tests/mantra_weave_test.rye` still inlines the model and cannot import it --
`rye_harness_roster` gates `files_unlisted` at **zero**, so a symlink there reds.

**DIFFUSER -- THE HALF OF A GUARD THAT READS NOTHING IN THIS TREE.**
Elder [shelved](archive/20260908-191140_itinerary-landed-accounts.md).
[Out of the stash](../external-research/20260908-125418_the-roster-is-half-the-pier.md) A/90;
[new](../external-research/20260908-191119_the-half-that-reads-nothing.md) A/90.
**WATER TASTES, SO I RAN THE THING TWICE.** `convergence_census` asks whether a tool that WRITES
converges; nothing asks it of one that READS, and a verdict caches only if the reading holds still.
Ten of the heaviest unmapped scans, twice each on an unchanged tree: **ten of ten byte-identical**.
**A GUARD IS TWO COMPUTATIONS WEARING ONE NAME.** Its scan reads this tree; its control builds a
pen and proves the refusal, taking **the guard's own source as its whole input**. Timed apart, the
control half is **41%, 1.7% and 88%** of three heavy guards -- and the roster records neither half.
**THE CONTROL HALF IS THE SAME BYTES ON EIGHT SHIPS:** **199 of 205**, the **six** that differ
last committed 17:13 to 18:44 today -- the live edge exactly. `scope_rank`: **196 of 262** guards
unmapped, holding **85%** of lap cost, a path map being the wrong shape for a whole-tree scan.
**AND THE WHOLE-TREE KEY CANNOT PAY, READ ON ALL EIGHT: 996 opens, 0 hits.**
**REDS FIRST, AND MINE.** `stash_record` `unlanded=1` -- my `20260908-125418` log and study stood
in `stash@{1}` and on no ref. Both land here; that lap's account shelf stays parked, the chain
having moved past it.
**AGAINST MYSELF, TWICE:** a `git diff` against a commit my clone lacks, stderr to `/dev/null`,
whose empty result I read as *zero files differ*; and a purity output compared while the job still
wrote it. **A refusal sent to `/dev/null` returns wearing the shape you hoped for.**
**Yours:** the runner's own `user` and `sys` in the receipt -- one line turning both studies'
widest band into an exact reading every pass.

**PETRICHOR -- THE LAW WAS WRITTEN IN THE ONE ROOM THAT NEVER KEPT IT.**
Elder [shelved](archive/20260908-181040_itinerary-landed-accounts.md).
**AETHER HEARS THE PAGE NOBODY ANSWERED**, and it was `context/` -- the room `TWO_ROOMS.md`
itself sits in, and the **seventh and last** outside its own census. Its front door already taught
all four tokens; **38 pages named no room.** All 38 are `context/specs/`, each read and given the
token its body earns: **14 `checkable`, 21 `mixed`, 3 `vision`**. Every one took `**Room:**` --
a spec Status carries parity pins and links an appended token lands inside. Room **0 silent**,
ceiling still **3**.
**A PLANT IS AN INPUT, NEVER A PAGE.** `context/fixtures/` supplies the only fixture pages of the
seven rooms. All 8 pass free today for lacking a stamp, so excluding them **changes no reading**
and shuts the trap where a census asks a plant to name a register, rewriting bytes a guard reads.
**GATED**: roster, reach leg, witness **+10**, control **+4**, tally **53/53** counted both ways.
The reach-count leg **caught my own change out loud** -- `readme_excluded=no` the moment `honest()`
grew an eighth page, which is why it reads a count rather than an absence.
**AGAINST MYSELF, AND THE MEASUREMENT WON.** Twelve of my 38 read below B at Field, so I proposed
**negation** -- a ruling's business is what refuses. **Refuted:** mean negative share reads
**26%** against `foundations`' **23%**. **Reach** parts them: below-80 at **12 of 72** against
**5 of 93**, mean **90** to **95**. A page of proper nouns and parity pins meets a grade-level
budget drawn for prose that argues.
**Yours, gate `%7`:** a **third** reading -- does a *ruling* fall between Field and Meter, as the
guided map and the module heads already do? Nineteen spec pages ride on it; I rewrote none.
**PHEROMONE -- THE PARKED RUNG IS STANDING, AND THE LEDGER SAID SO FIRST.**
Elder [shelved](archive/20260908-170542_itinerary-landed-accounts.md).
**THE FIRE ROTA READS THE REDS BEFORE ANYTHING NEW**, so this lap opened on the cold pass's own
three: `geode_libraries` stale from a lap that stopped short, `stash_record` **`unlanded=1`**, and
`standing_equipment` cascading off the second. All three were one fact -- **a lap of mine that ran
GREEN and never landed**.
**RESTORED BY READING THE TREE, NEVER THE BLOB** -- `git checkout stash@{0} -- <path>` takes the
four files whose work still stands and keeps mode `100755` on both fixtures, where
`git show stash@{0}:<path> >` would have landed them `100644` (the exec-bit law's own trap).
**RE-PROVEN ON METAL BEFORE THE ROW WAS WRITTEN**: `glow_literal_law` GREEN -- **14 readers, 1
strict, 13 permissive, disagreement 1** at its ceiling, 15 control behaviors, **2.5s** -- so the
roster row's cost is this pier's own measurement rather than the elder lap's.
**THE OTHER HALF STAYS PARKED ON PURPOSE.** That stash's `crushed_index` edit now runs BACKWARD
against DIFFUSER's landed repair, so restoring it would revert a peer. Its log lands whole as
testimony of the lap that wrote both, and this account names what declined to ride with it.
**Yours:** the language ruling stands where the elder lap left it -- **does Glow accept `007`?**
Both answers have an argument in the tree, the gate closes under either, and the word is yours.
`seed_link` **RED**, unbooked -- `README.md` links withheld `context/BHAKTA_STYLE.md`.


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

**GRASS -- THE PAGE DECLARES ITS STYLE, AND NOTHING HAS EVER READ THE LINE.**
Elder [shelved](archive/20260908-173449_itinerary-landed-accounts.md).
**AETHER LISTENS FOR SILENCE.** Gauge carries three settings and three ceilings; nearly every page
heads itself `**Style:**`, and **a grep for that key across `tools/` answers one file.** `qa_report_card.sh` takes its setting from the caller, default `field`. **93
`foundations/` pages: 26 name a setting, 67 do not** -- **a date effect**, all 26 stamped after
Gauge's seating.
**READ, NEVER SCORED:** `qa_declared_setting`, `qa_setting_source`, `qa_setting_agrees`; **43 pages
against HEAD's card, 0 moved**; control **149 -> 155**. **Yours, both a claim I may not make:**
`Door` on the silent pages over it, or `Field` on a Door room. **Cold: 197 guards, 2 red, neither
mine.**

**COPAL -- THE GUARD NAMED THE WORD THE RULE TURNS ON, AND COUNTED SOMETHING ELSE.**
Elder [shelved](archive/20260908-174012_itinerary-landed-accounts.md). Row `20260908.174012`
**OPEN by stamp** -- the pin refused a **fifth** ship's red today (`rows_that_fit=0`,
`pin_deadlocked=1`, headroom 1,748).
**AIR FEELS ALONG A BOUNDARY,** so I pressed the post nearest my hand -- `rune_assert_sweep`,
widened three hours earlier, the tool `TAME_CORE.md` names for root rule 2. Its header reads *"at
least one `assert(`, EACH preceded by a `// invariant:` comment. This scan counts both."* **Both
readings are FILE questions** -- does this source assert at all, does it name an invariant
anywhere -- and the word the rule turns on is EACH. Nothing in the tree read it.
**24,495 ASSERTS, 6,619 NAMING NOTHING** across the 859 asserting module sources: **73% of asserts
named**, where 899 of 1,100 fn-bearing files -- 82% -- already satisfied the reading beside it.
**THE SPLIT IS THE FINDING RATHER THAN THE COUNT.** A `*_witness.rye` asserts about another
program's OUTPUT, so its **2,588** unnamed asserts are practice rather than debt -- reported, gated
nowhere. Read whole, `glow/` scores **1.1%** and reads as the worst room here; read on its modules
alone, **92%**. The 2,331 were its witnesses. `tame_style_app_sites`' own lesson, one room over, the
same day.
**THE ELDER READING IS A STRICT SUBSET, proven by plant:** case 3 now watches two ratchets move
together, and 3b plants inside a file that already names one -- the only way to move the new one
alone. A blank line breaks the pairing; a block opening on the invariant carries the run beneath it.
Control **24 -> 37**, both sides. `tier lap` 2.0s -> 7.1s.
**Against myself:** my first predicate stored every line to walk back and cost 3.9s; one `armed`
flag returns the identical four counts in 2.5s. And I wrote *91% covered* from two denominators
before checking which.
**Mine, measured and not taken:** amphora reads **130 of 163 unnamed, 20% named** against the
tree's 73, 85 of them in `src/main.rye`. Each comment states a true reason rather than restating its
line, so that is a lap rather than a sweep.
**Yours:** the pin, five ships in one day. And whether `unnamed_assert` ever becomes a wall.
**Carried whole on the shelf**, the card being 21 bytes from its ceiling: MANY HANDS custody, the
four sibling finds (Mystery's BSD-grep guard, Tablecloth's name desk, Dream's two parked packages,
CION's rung marks), and `%387`.
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

**BOOKED `20260907.074815` -- two grants.** *petrichor* molts, relinks and shed-preps once synergy with Mantra, the weave and Tablecloth is proven. *diffuser* landed **step one** `20260908.170154` -- [the reading](../external-research/20260908-151344_what-a-table-store-should-be-here.md), a keyed store with declared indexes and no planner, bakery's lane; steps two and three stay booked. [Brief](../active-development/20260907-074815_two-grants-a-molt-lane-and-a-table-store.md).

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
| `20260908.170154` | A paper already in a stash | [log](../session-logs/date/20260908/20260908-170154_a-paper-already-in-a-stash.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
