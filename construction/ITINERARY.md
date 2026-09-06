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
- **Fleet re-arm helper**: `sh tools/f/fleet_rearm.sh` -- status, reason, paste.
- **SEATED -- Pond completes the enclosure** (`20260826`): the quest retiring ai-jail; docs accrete-only until the replacement is audited; switchover and jail debride gated (%5). Plan: `expanding-prompts/20260826-033051_pond-completes-the-enclosure.md`.
- **STANDFAST -- the Dexter orbit** (`20260826`): 15 rounds; door `dexter/README.md`.
- **Seated `20260826`, each behind its own door:** the **cubist sweep** (`cubist-bhakti-astrology/README.md`); the **Linengrow Design Theme** (gate %6); the **WADE journey** double-seat (plan in `expanding-prompts/`).
- **Seated names and breaches** rest on the [third shelf](archive/20260831-023122_itinerary-settled-decisions.md), each walk-back in [`CHECKPOINTS.md`](CHECKPOINTS.md). Live clause: the debride grant (`20260823.045448`) covers renames, message rewrites, force push, reclone; a deep debride takes Keaton's word naming its target.
- **The crypto spine** (`20260815`) -- four decisions whole on the [first shelf](archive/20260824-130807_itinerary-settled-decisions.md). Live clause: the identity key is the gate, the library is agent-doable.
- **Caravan -- semi-standfast, raised priority.** A touched module gets its opening comment as **Door** prose and its bound comments as **Meter**, per *Grade what you touch*. %163 one layer down.

### Now -- the live front

**Git nib:** `c99395f831` -- HEAD's parent, resolvable everywhere (%401).

**DIFFUSER** -- **my own published sentence named its cause by proximity, and proximity is not a
measurement.** Adopted a lap off this tree's stash (`%321`), added the arm it skipped:
*"the L3 boundary, 4 MiB to 32 MiB, costs 7.87x"* reads **8.26-8.71x** at 4 KiB, **5.81-6.16x** at
2 MiB -- mostly cache, **yet its largest step, 8 MiB and 2,048 pages, past the knee at 1,280-1,408,
is page walk**: 1.70-2.67x against 1.04-1.10x, inside the 16 MiB L3. Five pairs; the elder takes an
erratum. **`%476`: a bound declared by `assert` in a build that deletes asserts -- booked, folded.**
[Paper](../external-research/20260906-061229_the-address-that-does-not-fit.md) A/93.
**AND THE SAME RED FOUND TWICE IN ONE HOUR, FROM TWO TREES.** I proved `standing_equipment` counts
its own last verdict -- one red absorbing, no pass able to clear it -- by flipping that row green in
a copy: `runs_red=0`, all 134 others green. My row was numbered and withdrawn on the rebase:
**`%475` had already booked it AND fixed it**, with `self_guard`, `red_self` and `runs_red_self`.
Two hands, one hour, one defect, one proof method. My `%472` renumbered to `%476` the same way --
theirs was published, mine was not, which is exactly what the derived spine is for.

**Now.** **A path outlives its content, so presence is the cheaper question wearing the expensive one's answer.**

**`%467` and `%468` CLOSED, folded whole** to one [shelf](archive/REDS-presence-where-the-claim-was-content-rows-467-468.md) -- **presence is the cheaper question wearing the expensive one's answer**; the account is on the [`20260906.090312` shelf](archive/20260906-090312_itinerary-landed-accounts.md).

**Same shape one room over: an instrument can be green because it cannot see enough of its subject to disagree.** `%451` BOOKED, `%469` CLOSED, on the [blind-to-half shelf](archive/REDS-blind-to-half-its-subject-rows-451-469.md); the account is on the [`20260906.090312` shelf](archive/20260906-090312_itinerary-landed-accounts.md).

**Yours, one question; law, so INCENSE may own it.** The five negatives `mycelium` keeps are its
**subject**: two Meter claims, a *no real key, no funds, no network, no custody* disclaimer, and the
benediction [`radiant-wishes-ending`](../.claude/rules/radiant-wishes-ending.md) asks for. **A Door
page obeying both floors at four: 16% of a 20% ceiling.**

**`%440` fired THREE times in this lap** -- a peer's row low at the cold open, then each rebase
auto-merging the shelf. **Fifth through seventh across two laps** -- the writer, run by hand, while
the nib writer put the nib right twice with none.


**`%459` and `%446` CLOSED**, whole on the [`20260906.042754` shelf](archive/20260906-042754_itinerary-landed-accounts.md). **A pen that plants an absolute tests a snapshot of the law; one that plants a ratio tests the law.**
**Measured rather than argued: should an OPEN row carry a claim, a seat and a stamp, at START?**
**PHEROMONE -- `%466` CLOSED and folded whole** to its own
[shelf](archive/REDS-the-harness-the-census-could-not-see-rows-466.md). **The label was not softened
-- the census was taught to see what it was mislabelling.** `rye_harness_roster_scan.sh` grew
**`--paths`**, printing each `harness_path <script> <path>`, and the compile-reach census reads it:
**one resolver, two readers**, the credit CONDITIONAL on that script compiling anything, which is the
seam -- one scan answers *what a harness assembles*, the other *whether it compiles*. **`never` 178
-> 64**, all 116 on disk. *What the pen taught that the plan did not:* the refusal phase expected
`asserted=3` and read **0** -- that reading wants a **literal** name and a harness spells none, so a
program only a harness names can **never** enter the gate, built or not. Bound written down;
`files_unlisted` is the guard that does reach it. **`harness_unresolved` publishes the residue**, so
*floor* carries a number. Two refusals rather than a silent credit, since **a tree with no harness and
a copy that cannot answer look identical in the paths alone**. Four `%453` citations repaired to
`%449`. Controls **67** (was 54) and **27** (was 20).
**And my own `41 orphans` is WITHDRAWN**, `harness_roster` landed gating both halves at zero, and the three-firing lantern's spec stands -- whole on the [`20260906.090312` shelf](archive/20260906-090312_itinerary-landed-accounts.md).

**THE WEAVE MERGES** (`20260906.001728`, Patchouli) -- the charter's movement *the weave, and its
order*. `Weave.merge` in `mantra/src/weave.rye` is a union over positions where the **higher
generation wins**: union, max on `gen`, max on `next_pos`, each commutative-associative-idempotent,
so the merge is too by construction, and sorting the union makes `a.merge(b)` and `b.merge(a)` equal
**field for field** rather than merely as documents. `weave_merge_witness.rye` proves **eight claims
by doing** -- three states in all six orders giving one weave, associativity alone, idempotence,
delete-wins, an interleaving union, both refusals by name -- and its control breaks the law **five
ways in a pen**, catching each, with `clean` and `bound_shrunk` proving the pen innocent. Rostered
`tier lap`, **10s**. First named max in a module 120 files reach toward: `max_weave_lines`, read at
the edge by `apply` and `merge` alike.
**`%449` BOOKED -- the module those four `tier lap` guards read had not compiled since the toolchain
moved, because all four read it with `grep`.** `Weave.empty()` returned the elder `.{}` ArrayList
form where Zig 0.16 wants `.empty`; proven by building the HEAD blob in a pen, *missing struct
field: items*. Nothing anywhere builds `weave.rye` -- `main.rye` and the test each **inline their
own copy**, and the test's copy reads `.empty` because the test is compiled and the module is not. **A test that inlines its subject migrates with the toolchain while the subject
rots, and every guard stays green.** The new guard builds it. Booked: a census of authored `.rye`
nothing ever compiles.
**The identity gap is the next movement, and it wants your word.** Two branches that both insert
collide at the same small integer, and merge **refuses** them `PositionTextDisagrees` rather than
dropping a line: `pos` comes from a per-weave counter, so it names a line inside one weave and not
across two. Closing it wants a wider `Line`, and **`mantra_glow_tend_limb1` locks `Line` to three
fields against a Glow shape.** A seam, so it waits.
**`%450` CLOSED, both halves** -- the rule with `%461` on [one shelf](archive/REDS-correct-alone-wrong-at-the-seam-rows-450-461.md), the nib writer that ended the typing on [another](archive/20260906-055737_itinerary-landed-accounts.md).
**`%479` and `%464` CLOSED**, on shelves ([479](archive/REDS-the-instrument-that-was-in-the-box-rows-479.md), [464](archive/REDS-the-box-nobody-opened-rows-464.md)). **The instrument built to report unlanded work was itself unlanded:** the round-open stashed a finished lap 13 minutes before the next read the tree, and that lap carried `stash_record`, its scan, control and roster row -- proven, complete, without effect. What pointed at the box was `runs_unrostered=1` naming a guard that existed nowhere. The four logs held aside read `unlanded=4`: it would have refused that open, had its roster row not been in the box too. Rostered `tier lap`, gated at zero; green by putting a log back, never by dropping a stash. **THIRD HAND ON `%475`:** one hour, one defect, three trees, three withdrawals -- and this row itself took `%472`, `%477`, then `%479`. **An OPEN row wants a claim, a seat and a stamp, at START.**
**`%440` fired three times in one lap**, and once more on this rebase; one dedupe-and-sort each time. **Yours.**

**`%445` and the `%439` class, whole on the [`20260906.001820` shelf](archive/20260906-001820_itinerary-landed-accounts.md)** -- the view moved twice and the key did not; four detectors over 1,712 Rye files found one genuine site in 159, so no gate.

**Four accounts CLOSED, whole on the [`20260906.040933` shelf](archive/20260906-040933_itinerary-landed-accounts.md)** -- `%453` twice (the doc line measuring between outfits, and the floor that stopped biting, [REDS shelf](archive/REDS-the-floor-that-stopped-biting-rows-453-453.md)), `%458` the scan that called this ship's credential the pier's, and `%444`/`%431` the seed publisher that travels with the field. **A rule that states its reason can be checked.**

**PHEROMONE -- A PUBLISHED DISTANCE PROMISES A ROAD, AND A THIRD OF THE SKY HAD NONE.** `%454`
CLOSED, whole on its [shelf](archive/REDS-a-published-distance-and-the-road-it-promises-rows-454.md)
with the `%470` account on the [`20260906.090503` shelf](archive/20260906-090503_itinerary-landed-accounts.md).
`route_hops` answered two questions; `Sky.point_hops` now sits BESIDE it, untouched, so a peer's
just-landed `%452` reading stands. 172,524 of 518,400 ordered pairs unreachable -> **0**, 132
isolated -> 0, **diameter unmoved at 5** by an awk walk sharing no code. **That prices the paper's
torus:** it bought reachability at diameter 14; the point reading buys it at 5, so the torus's case
is degree, cut points and the angle alone. **Yours, the ruling that remains:** which metric Comlink
actually routes on.

**PHEROMONE -- `%460` STILL OPEN at the emulator, its landed half folded** to the
[`20260906.051500` shelf](archive/20260906-051500_itinerary-landed-accounts.md), `%451`'s bound half
beside it. File half proven on metal, ten sites. **Yours, one sentence:** may a cross-target witness
read GREEN with a named gap when qemu is absent? Its head promises that limit, `%446` reads the
other way, and the roster's `capability` field is the mechanism.

**GRASS -- A DEAD LAP'S STASH RECOVERED, AND TWO REDS FOUND INSIDE THE RECOVERY.** Three rows,
each closed or booked on its own shelf.
**`%472`/`%473`** ([shelf](archive/REDS-the-copy-that-was-counted-against-itself-rows-472-473.md)):
`copy_lag` gives all **108** basenames held both ways the rule `copy_sameness` kept for one, and my
published *108 byte-identical, 5 differ* had counted **108 originals against themselves** -- the real
population is **5, none agreeing**. **Then the meter swallowed its own instrument:** its index listing
piped into `awk` under `|| true`, so a refused checkout and a tree holding no Rye reached one verdict
at **exit 0**, the fault its own header exists to name. **`instrument_refusal` refused it at 07:20 and
nobody read it for eighty minutes** -- the lap died, `%321` stashed the set, and the evidence went to
`standing-equipment-reds/`, **untracked by `.gitignore:384`**. It surfaced through a *different*
instrument: `standing_equipment` read `runs_unrostered: copy_lag`. 31 pen behaviors.
**`%474` BOOKED** ([shelf](archive/REDS-a-fold-done-by-hand-loses-its-depth-rows-474.md)):
`reds_fold.sh` re-anchors a row's links for the directory it lands in; **the live front folds to the
same `construction/archive/` by hand and nothing re-anchors.** Five of eight shelves carried
**sixteen** links one level short, and **three guards read that room and none reads this**. All
repaired, bounded to links resolving under exactly one correction -- and it then fired on **three
consecutive hand-folds in this same lap**, the last two by the hand describing the mechanism.
**The loom is the booked lap.**
**`%475` CLOSED, the one that blocked the send**
([shelf](archive/REDS-a-guard-that-reads-its-own-verdict-rows-475.md)): `standing_equipment` is itself
rostered, so the runner writes its verdict into the card it reads and counts. **Its first red was
absorbing** -- one variable on metal, that row present reads `roster_broken`, that row alone removed
reads `ok`. **A guard's own verdict is its output, never its evidence**, and the loop is invisible for
as long as the guard is green. Reported at `runs_red_self`, never counted, **one name wide**.
**Yours, sized not taken:** a guard's refusal is written where nothing tracked can read it, so a lap
that dies takes its own red with it. Mand's twelve untraced refusal sites stay named
([audit](../active-designing/20260906-003146_the-refusal-that-leaves-no-trace.md), Caravan parked Dream's).

**COPAL -- the same stash, the other half.** Grass's `%464` recovery above is this tree's too: the
untracked run card outlived the reset and alone remembered three amphora guards, landed now
(`%477`). **Then RUNNING them found what reading could not:** `vessel_fetch_delivery.rye` closed
its socket between datagrams and bounded no receive, so one lost datagram stalled it forever --
**2 in 20 on HEAD's bytes against 0 in 40 repaired** (`%478`). It binds before it sends now, holds
one socket per exchange, names and bounds every receive, and takes the port pair under a **host**
lock, since eight trees reach for one machine's ports.


**The live front** (condensed `20260831.023122`; the day shelves hold every landed lap):
- **Tri-OS:** LOCA pins pass and reject tampering. Pier proof awaits `libwayland-client` and
  `libxkbcommon`; installs and Apple gates stay Keaton's.
- **CION Tier C** RULED quality-first (`20260830.004431`,
  [campaign](../expanding-prompts/20260829-221841_cion-resumes-the-rung-mark-molt-campaign.md)).
- **DirtySet** RULED `20260830.183102`: shares the nine (seat 0 = whole-surface
  invalidation); duplicate marks idempotent; refusal only out-of-range.
- **Pond live:** `duties_undeclared` **1**; `env` seated at `env_disagreements` zero, enforced.
  Only `entry` is left, and it IS the switchover: a gate, not a lap.
- **Language custody:** growth law
  [a-rune-is-earned-by-a-law](../foundations/20260830-011530_a-rune-is-earned-by-a-law.md); the
  first core LANDED `20260830.224500` -- `|%`, GREEN; nesting OPENED `20260830.221500`.

**MANY HANDS** (`20260828`): custody MANUAL, one writer per checkout. Root `SKILL.md`; every
clone seats `ww` (gate %1) and `.git/ssh_config_jail`.

**Sibling finds:** `tame_style_long_fn_one.sh` resets its awk on any indented `fn `, so a long function holding an inline comparator reads clean. Mystery's module-label guard fails open on BSD grep; portable, it finds elder
labels in `tools/gen/chapter/fascia_metric_v0.rish`. **Tablecloth, two, cross-lane:** its name desk
reads one of `max_name`'s two call sites (`parse_manifest` reads it too, over the same fixed
`[max_name]u8`), and four `*_example_missing` verdicts carry no control case -- deleting the
`example` line lands on `placard_wrong` one reading earlier. **Dream's parked packages:**
`xy/pier/diverged-20260831-{064342,115245}`, neither landed, neither mine. **CION:** `drey`'s rung marks are the retired form (%329). **Fleet loop (%387):** should a
round's opening stash stop an in-flight pass in its own tree.

**Petrichor's `%424`**, the `grep`-shim finding, and the restored stash are on the
[landed-accounts shelf](archive/20260905-131102_itinerary-landed-accounts.md). That row took four
numbers and its stamp took none -- as `%451` just did again, six laps running now, which is
**the standing evidence for your open question**: should an OPEN row carry a claim, a seat and a
stamp, at start rather than at landing. Take the number from `--next`, never from the row.
**Bounds raised `20260906`, both derived, both yours:** the operator card to 40,960 (8 ships x 2,048 live front) and the REDS pin to 40,960 (8 x 4,096 OPEN set + 8,192 header). **Each is sized per ship, so both re-open at twelve** -- and the pin's is also sized by how fast reds close (`%360`, 8,213 bytes, open since `20260830`).
**`%456` OPEN -- eight ships share ONE login, so one credential is a fleet-wide outage** (mechanism read from `agent-jail.sh` source, so `%458` leaves it standing). **Its pier half is unmeasured from inside the enclosure.** Seven died 3 laps each in ten seconds on `OAuth session expired and could not be refreshed`; `agent-jail.sh` seeds every tree from the pier's single credential (*one login per pier*). Refresh token had **27 days** left, so expiry is excluded -- the leading read is **rotation**: one shared token, first refresher strands the rest and the pier's own copy. **Falsifier is cheap:** watch whether the pier's refresh value changes after a ship refreshes. Landed: `claude_refresh_dead()` names a dead credential instead of seeding it (proven 3 ways -- dead trips, expired ACCESS does not, missing field fails open), and `sh tools/fixtures/f/fleet_login_scan.sh` answers it in one command. **Yours, gate 3:** one login per ship is the fix. **A resource shared by every ship has no blast radius smaller than the fleet.**
**Landed `20260905`, whole on their shelves** -- `%430` and `%438` on the [235749 shelf](archive/20260905-235749_itinerary-landed-accounts.md); `%435`, `%427`-`%429`, `%423`-`%426`, `%420`, `%413`/`%412`, `%411`/`%410`, `%409`, `%408`, Mantra's 20 guards, the ripgrep fetch, the aroma breach, the baton and the three berths, and the bound grant itself on the [192154 shelf](archive/20260905-192154_itinerary-landed-accounts.md); `%442`/`%443` and `%445` on the [001800 shelf](archive/20260906-001800_itinerary-landed-accounts.md).
**`shell_dialect` re-diagnosed:** the `sed -i` repair stands; it reds on ONE case of 47 -- *a guard
without its instrument names rg rather than a file*. `shell_portable_control.sh` takes `rg` off PATH
by dropping every entry holding an executable `rg`, and this NixOS pier keeps `rg` and `sh` in one
directory, so the scan under test cannot start. A pen of symlinks to every tool but `rg` is the fix.
**Hot pass `20260906.102004`: 138 guards, 135 green, 0 red, 3 gated, 789s** -- `tree_moved=no`; the cold open's one red was `standing_equipment`, closed as `%475`.
**`%439`-`%441` FOLDED** to one [shelf](archive/REDS-what-no-meter-was-reading-rows-439-441.md): three claims where no instrument reads.
**`%360` advanced twice more** (`compass_rose`, `standing_equipment`): `unheard` **674** of ceiling
**1,093** -- 419 of slack; the elder *14 under* is superseded. **Yours.**
**Still open:** `glow/rune_shape.rye` width custody; `%281`/`%291`. **(%347):**
`pond/enclosure_policy.kyri` 8,120/8,192; yours.
**Landed this chapter** -- `%374`'s gate build, six utility fetches with their thanks, the naming
study, the seed publisher, and rows `%408`, `%414`-`%424`: whole on the
[landed-accounts shelf](archive/20260905-131102_itinerary-landed-accounts.md). **Petrichor's mark-law weave LANDED** (`20260905.224930`): `study/reading-a-name.md` teaches both
marks a name carries; the account is whole on the [001820 shelf](archive/20260906-001820_itinerary-landed-accounts.md).
**THE LIVE FRONT NOW FOLDS** (`20260905.130819`): landed accounts shelve like REDS rows, so the
card holds what is OPEN and what waits on your word.
**All three ships sail** (`20260905`). **Gate 3 stands:** `.gnupg-rye/` holds
`private-keys-v1.d/`, and **per-tree GNUPGHOME is the only shape that works jailed** -- yours.
**52 external utilities across 2,969 tool scripts. `rg`: 992 sites, ONE probe. `mktemp`: 353
sites, none -- and not POSIX since 2008.** The tree already wrote the cure,
`tools/fixtures/s/shell_portable.sh`, and **38 files source it, 1.3%.** The design names three
tiers -- **granted** (POSIX), **carried** (we ship it), **borrowed** (probe, fall back, announce) --
seated in Tally as a bounded grant, carried by Caravan as a capability, declared through Mantra.
**The reflex itself LANDED** (`%445`, folded above); the three tiers and the roster stay yonder, yours.

**Worth your word, still unanswered** (condensed out under the old ceiling `20260904`, carried
back now that there is room): nothing in the ledger shows a red is *being worked*, so two hands
spent one morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
start rather than at landing?**
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

Seated ladders: **HAWM - TUBE - ZETA - JABS - LULU - STOA - SETU - SUNN - POLE** (elder) - **SOON - JARL - BUHR - TACT** (Compass Chapter). Draw before you number: `.claude/rules/waymark-ladders.md` - `tools/w/waymark_derive.rish`. Claims: `waymarks/`.

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

Ranked Lindy-first and crux-first, with costs, gates, and falsifiers, in
[`../expanding-prompts/20260823-124407_the-ranked-remainder.md`](../expanding-prompts/20260823-124407_the-ranked-remainder.md);
the measurement class behind it is
[`../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md`](../active-designing/20260824-080208_the-roster-that-decides-what-gets-measured.md).

**Named and waiting on their own lap:** the **fascia weave** (39 browsed `active-designing/`
documents); ten pages wanting a
Status line; the **`constels/`** room and the **kres/kresfa chapter** (seated
`20260823.122619`). Two i10 ratchets, migrate-on-touch: 26 `parseInt(` sites, 14 over-70
functions. Third mitra shed prepped (`SHRED_PREP.md` Class H), cut RED until circled.

## Prior laps -- landed, with the detail in the log that recorded it

The logs keep the account. Earlier rows are shelved at
[`archive/20260824-130807_itinerary-settled-decisions.md`](archive/20260824-130807_itinerary-settled-decisions.md)
and [`archive/20260825-003210_itinerary-landed-laps.md`](archive/20260825-003210_itinerary-landed-laps.md).

| Landed | Round | Log |
|---|---|---|
| `20260906.100141` | The harness the census could not see | [log](../session-logs/date/20260906/20260906-100141_the-harness-the-census-could-not-see.kyri) |

**One row, on purpose.** A landed lap keeps one line until the next replaces it, its detail left in the log that recorded it, so this card stays single-stranded. (`TASKS.md` and `ROADMAP.md` fused in here `20260823.103804` and are pointers now.)
