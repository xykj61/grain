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

**Git nib:** `5045d579f3` -- HEAD's parent, resolvable everywhere (%401).

**BAKERY -- A PROBE PERFORMED THE ACT AND WAS WRONG ABOUT WHICH ACT IT PERFORMED.** `%516` CLOSED;
`%510` [shelved](archive/REDS-a-guard-that-reads-a-proxy-rows-510.md). The `jail_nesting` arm ran
`bwrap ... /bin/true`, and this pier ships **one entry in `/bin`, `sh`** -- so bwrap built the
namespace and then failed to EXEC, and exit 1 read as a refused namespace. `agent_jail_enclosure`
was skipped here every pass since `013116`, while `%446`'s head promised *a bench where the legs
would work always runs them* and named this bare bench as the one. Run by hand, the four legs
pass GREEN: host home invisible, `/etc` denied. **The root is in the seating log** -- the probe was
tested inside a jail, where both failures are true at once, so it was right for the wrong reason.
Payload is `/bin/sh -c :` now and runs OUTSIDE first; only a DIFFERENCE is evidence. Control **+14
legs**; the missing-tool answer plants a pen of 1,028 symlinks. **Residue pinned:** a
third-reason failure still skips; the two refusal wordings this pier prints differ.

**BAKERY -- THE SCAN TITLED *CAN THE LEDGER STILL ACCEPT A ROW?* PRINTED `rows_that_fit=0` AND
ANSWERED `verdict=ok`.** `%517` CLOSED, and it is **GRASS's `%515` from the other side** -- that row
asks why the wall did not run, this one why the instrument reading capacity said `ok` while it
stood there. Capacity never reached its verdict; three shelf and recital conditions did. Caught by
the cold pass answering `guards_red=4` with **two of them one page**, `equinox_e123` and
`declared_ceiling`, neither naming a remedy. The pin's bound was derived that morning for the OPEN
set, which stood at **58% of its allowance**: the overflow was **18,153 bytes of already-foldable
rows**. The verdict now crosses headroom against foldability, gates the cell that is both with the
fold command inside the refusal, and leaves the cell beside it reported -- only your word raises a
bound. Control **31 -> 39**, every neighbouring cell shown free. **It fired on this lap's own
rebase** and I obeyed it. **Residue:** a deadlocked pin still reads `ok`.
**Recovered, not authored:** `%516` came whole out of `stash@{0}`, a signed lap a round open parked
-- **`%499` in my own tree** -- and `skipped_capability` fell **1 -> 0** when it landed, four
enclosure legs running here for the first time since `013116`. **Withdrawn on the rebase:** my
`487-512` fold, since peers folded `%487`, `%508` and `%509` to their own shelves in the same hour.
**Sibling:** `reds_citation` reads `git ls-files`, so it read GREEN over a wrong shelf link until
the file was staged.

**YOURS, MEASURED WHOLE AND NOT TAKEN: THE DATED-PATH CENSUS GATES A CLASS IT WAS NEVER BUILT FOR.**
`dated_path_witness` reds at `refs_lost=169` against a ceiling of **165** only a debride may raise.
Classified by two independent readers agreeing exactly: **139 backticked mentions, 15 bare, 15
links** -- and crossed with living-versus-testimony, **all 30 promises sit in dated testimony**, so
the repairable count is **ZERO**. The largest population, **86 rows in two `20260722` shelves, is a
deliberate repair** a hand made on `20260823.184309`, dropping links whose logs never landed
*because a link promises a file a reader can open*; the census reads it as 86 units of damage.
**The shape:** print `lost_mentioned` / `lost_promised` / `lost_promised_living`, subtraction
signed, gate the cell that is both -- zero today, steady where the elder reading rises on ordinary
work. Whether a gate may move to the class it was built
for, when the elder ceiling can only fall, is your word.

**BAKERY and DIFFUSER accounts, CLOSED and folded** to the [`173444` shelf](archive/20260906-173444_itinerary-landed-accounts.md): `%499`/`%503` (a discriminator that was a tautology), `%501` and its two answers (the Moore bound asked in the direction that decides, then the abelian floor beneath it).

**PATCHOULI -- a park is not a landing.** `%505`'s sibling, `%507` CLOSED and whole on its [shelf](archive/REDS-a-park-is-not-a-landing-rows-507.md): `reader_refs` excludes the `pier/` namespace, `parked` reports beside the gate, control **22 -> 34**. `%510` above is the drawer beneath it.

**`%506` CLOSED**, [folded](archive/REDS-the-property-nobody-named-rows-506.md): `Weave.annotate`
and `mantra_weave_head_scan.sh`, ten claims GREEN, roster `runs_unrostered` **1 -> 0**. **Yours:**
the identity gap stays unblocked, and closing it wants a fourth field on `Line`.

**DIFFUSER -- A FINISHED LAP DIED IN THE BOX TWICE, AND ITS PAPER REVERSES THE ARGUMENT.** My cold
pass read **5 red**; three roots, two of them this lane's own stranded work. `stash_record` read
`records_unlanded`: lap 4095 wrote a paper, witness, scan and control; lap 4096 recovered them and
**died before its own commit** when the fleet set down at 20:48. Both land here, re-proven on metal.
**The paper:** one walk from the identity IS the routing table -- **719 entries at 3 bits = 270
bytes, the SAME 270 at every node** against 194,130 per-node, proven over all **517,680** pairs from
all **720** sources, `wrong=0`. **Two address spaces route optimally holding NOTHING** -- torus by
coordinate subtraction, star by sorting the difference. The circulant's ring-gap rule reaches **609
of 719**, and **depths 1, 2 and 3 all total 4,786 hops** while depth-2 takes a different first hop on
**162** -- different paths, identical lengths -- so the gap is the POTENTIAL's and closes for 270
bytes or never. **THE REVERSAL:** the circulant holding no table still beats the seated torus routed
perfectly -- **12 against 14**, **6.6565 against 7.2100**, on **10 bits** against 11. The torus case
now rests on legibility alone, priced. Paper
`20260906-195719_what-it-costs-to-decide-the-next-hop.md` A/93; elder
`20260906-152821_the-floor-you-can-stand-on.md` (A/96) whole in its file. `tlb_reach` closed on lap
4095's eight `.$$` pen repairs. **My REDS fold WITHDREW WHOLE:** peers took %489, then %487, and
their folds already put the pin under bound -- parked at `pier/diffuser-20260906-212539`. **Yours,
fifteenth firing:** should an OPEN row carry a claim and seat at START?

**PETRICHOR -- `%512` BOOKED,** [folded](archive/REDS-a-pen-one-path-wide-for-eight-ships-rows-512.md):
eight ships share one `TMPDIR`, so a pen named by a constant lets one delete another's mid-build --
**`%291` reaches past the checkout**, 9 collidable pens across five lanes, and the two-legs-two-
failures reading is what tells a race from a flake. `%511` CLOSED,
[folded](archive/REDS-a-guards-reach-is-a-claim-rows-511.md): reach **66 -> 219 of 284**.
**Yours:** of **607** reachable pages **82 lead nowhere**, scored **100** by a ceiling with no floor.
**PHEROMONE -- A PROOF TWO LIVING PAGES CITE, AND NOTHING EVER COMPILED IT.** `%506` BOOKED,
`%463` CLOSED. **63 Glow witnesses took the comptime declaration walker in one pass** -- `walked`
**2 -> 65**, `unwalked` **119 -> 56** with no slack -- and **all 63 built**. The `unreached` leg
then named `glow/nock/nock_glow_mirror_witness.rye`, *"the seam's first witness-backed pin"* in two
living pages, **built by no runner**: `asserted` is `never` intersected with **runner** mentions,
and a Markdown page claims just as loudly. Runner written, GREEN. **Yours, sized not taken:**
widening that predicate to living Markdown re-grades the whole `never` set at once (17 files, 4
doc-named) -- `%496`'s own reason for holding a numerator.

**YOURS, AND IT COSTS THE FLEET A LAP A DAY: THE ROUND-OPEN PARKS AN ORDINARY LOST RACE.** `%499`
OPEN. `fleet_round_open.sh` classifies by two `is-ancestor` tests and **two states fail both** -- a
real upstream rewrite, where parking is right, and the fleet's own ordinary outcome, where a peer
pushed on the base you built on and `git rebase` re-derives you whole. Its own header prescribes
re-derivation for the push refusal and parking for that same state one step earlier. Measured on
`xy`: **11 `pier/diverged-*` branches, 33 distinct subjects since `20260828`; 23 later reached main
by a hand, TEN never did** -- one of them the tablecloth find this card carried below as open, and
two more parked within twenty minutes of the reading. **The discriminator is local:** the merge-base
equals the parent of the oldest commit in `xy/main..HEAD` exactly when the local line's base still
stands upstream. **Not taken** -- six ships run that file. **A park keeps every byte and still costs
the lap.** *My third row of this lap was **withdrawn rather than renumbered**: it booked
`sow_allow_reach`, and a peer had booked exactly that at `20260906.133724`, which stands published
as `%493` above -- the fourth time in one day that a finding and its peer met in the same hour.*


**Landed recitals, all shelved** -- each shelf names its own rows: [`145647`](archive/20260906-134234_itinerary-landed-accounts.md), [`140206`](archive/20260906-140206_itinerary-landed-accounts.md), [`092312`](archive/20260906-092312_itinerary-landed-accounts.md).


**Yours, one question; law, so INCENSE may own it.** The five negatives `mycelium` keeps are its
**subject**: two Meter claims, a *no real key, no funds, no network, no custody* disclaimer, and the
benediction [`radiant-wishes-ending`](../.claude/rules/radiant-wishes-ending.md) asks for. **A Door
page obeying both floors at four: 16% of a 20% ceiling.**

**PHEROMONE -- my own `41 orphans` is WITHDRAWN**, `harness_roster` landed gating both halves at zero, and the three-firing lantern's spec stands -- whole on the [`20260906.090312` shelf](archive/20260906-090312_itinerary-landed-accounts.md).

**`%481` CLOSED, both accounts folded** to the [`20260906.133957` shelf](archive/20260906-133957_itinerary-landed-accounts.md) -- **a marker makes a pin longer, so the one meter aimed here read the damage as growth.** It fired a third time on this lap's own rebase, in this very file; the guard caught it before the push.
**AND THE EQUALITY ARC HAD NO RUNNER FOR 7 OF 8** -- `%482` **BOOKED**
([shelf](archive/REDS-a-proof-nobody-runs-rows-482.md)). `src/gate/README.md` called it closed 8/8;
the four Mantra gates build GREEN, **unheard rather than rotted**, now `tier cadence` 92s, while
Aurora's three and Caravan's one stay unheard in their lanes. **Yours:** that page graded Truth
**100 on twelve resolving paths** over seven unrun proofs.
**TWO RECORDS CAME BACK OUT OF THE BOX**, whole in `%479`'s shelf. **The instrument built to report
a duplicated lap was itself one of the duplicates**, its number moving five times: *a number booked
from a parked stash is invisible to `--next` twice over.*
**The identity gap** -- two branches inserting collide at one small integer and merge refuses them
`PositionTextDisagrees`, since `pos` counts inside one weave. Closing it wants a wider `Line`; the
guard said to lock that is `%500` above, and it now reds honestly.
**`%440` fired eight times across two laps** -- a peer's row low at the cold open, then every rebase auto-merging the shelf; one dedupe-and-sort each time, run by hand. **Yours.**



**Five Pheromone accounts closed on metal, all shelved** -- `%454`/`%464`/`%488` on the [`132007`](archive/20260906-132007_itinerary-landed-accounts.md) and [`488`](archive/REDS-the-doubt-published-in-the-wrong-frame-rows-488.md) shelves, `%497`/`%498` on [their own](archive/REDS-reach-and-claim-are-two-boundaries-rows-497-498.md).

**PHEROMONE -- `%460` STILL OPEN at the emulator**, its landed half on the
[`20260906.051500` shelf](archive/20260906-051500_itinerary-landed-accounts.md). **Yours, one
sentence:** may a cross-target witness read GREEN with a named gap when qemu is absent? Its head
promises that limit, `%446` reads the other way, and the roster's `capability` field is the
mechanism.

**GRASS -- SILENCE AND CLEANLINESS READ ALIKE.** `20260906.211015` CLOSED
([shelf](archive/REDS-silence-and-cleanliness-read-alike-rows-514.md)): two comment meters ran awk
under `2>/dev/null` and read empty as zero, **both AT their ceilings**, where a silent zero reads
as their largest sweep. Proven both ways on the pre-repair files. **10 of 244** scans still
drop awk's stderr; not taken.
**AND THE PIN ARRIVED PAST ITS BOUND WITH A WALL STANDING.** `20260906.211529` **OPEN.** `REDS.md`
opened at **41,153** against **40,960** before I touched it, two guards refusing. Rule 3,
`tools/hooks/pre-commit` fires at `git commit` and `--amend`; **rebase skips it and `post-commit`
owes a debt for rule ONE only**, so the twice-pulled send walks around the wall. **Six of the last
120 commits** shipped that pin over its declared bound. Instance repaired -- `%487` folded, pin
**37,317**, both GREEN. **Class sized, NOT taken: eight ships run that file. Yours.**
**Carried: 890** depth-lost links.

**COPAL -- `%502` CLOSED** ([shelf](archive/REDS-a-number-and-a-path-name-two-rows-rows-502.md)):
existence and agreement are two questions, and a `%N` that OPENS a real shelf holding another row
resolves and never reds -- four shipped in one day, `readme_reach` named one. `%494` CLOSED
([shelf](archive/REDS-the-verdict-travelled-and-the-reason-did-not-rows-494.md)), ratchet 43 of 52.
**`%493` still OPEN, not mine.** **Yours from `%485`:** `source_port` is still the machine's.

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

**`%481` recurred on `CHECKPOINTS.md`** -- same shelf; the seam is the hook, not the scan.

**Sibling find, measured both sides:** `dated_path_witness.rish` reds at `refs_lost=166` against a
ceiling of **165** -- and it reads **166 on the pre-lap tree too** (`d9a10c18c`, measured in a
throwaway worktree), so no lap added it. Only `dated_path_repoint` is rostered, so nothing has
run the census guard; `%360`'s family, one over and unheard. The scan prints no list, which is
why nobody can name the reference -- a listing leg is the cheap next move.

**Sibling finds:** `tame_style_long_fn_one.sh` resets its awk on any indented `fn `, so a long function holding an inline comparator reads clean. Mystery's module-label guard fails open on BSD grep; portable, it finds elder
labels in `tools/gen/chapter/fascia_metric_v0.rish`. **Tablecloth, one, cross-lane:** its name desk
reads one of `max_name`'s two call sites (`parse_manifest` reads it too, over the same fixed
`[max_name]u8`). *The four uncontrolled `*_example_missing` verdicts are no longer a find: the work
stands written at `cc1da84f7`, parked by a round-open and unlanded since `20260905` (`%499`).* **Dream's parked packages:**
`xy/pier/diverged-20260831-{064342,115245}`, neither landed, neither mine. **CION:** `drey`'s rung marks are the retired form (%329). **Fleet loop (%387):** should a
round's opening stash stop an in-flight pass in its own tree.

**Bounds raised `20260906`, both derived, both yours:** the operator card to 40,960 (8 ships x 2,048 live front) and the REDS pin to 40,960 (8 x 4,096 OPEN set + 8,192 header). **Each is sized per ship, so both re-open at twelve** -- and the pin's is also sized by how fast reds close (`%360`, 8,213 bytes, open since `20260830`).
**`%456` OPEN -- eight ships share ONE login, so one credential is a fleet-wide outage** (mechanism read from `agent-jail.sh` source, so `%458` leaves it standing; the pier half is unmeasured from inside the enclosure). Seven died 3 laps each in ten seconds on `OAuth session expired and could not be refreshed`; `agent-jail.sh` seeds every tree from the pier's single credential. The refresh token had **27 days** left, so expiry is excluded -- the leading read is **rotation**: first refresher strands the rest and the pier's own copy. **Falsifier is cheap:** watch whether the pier's refresh value changes after a ship refreshes. Landed: `claude_refresh_dead()` names a dead credential instead of seeding it, proven 3 ways, and `sh tools/fixtures/f/fleet_login_scan.sh` answers it in one command. **Yours, gate 3:** one login per ship is the fix. **A resource shared by every ship has no blast radius smaller than the fleet.**
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
sites, none -- and not POSIX since 2008.** The cure is written, `tools/fixtures/s/shell_portable.sh`,
and **38 files source it, 1.3%.** Three tiers -- **granted** (POSIX), **carried** (we ship it),
**borrowed** (probe, fall back, announce). **The reflex LANDED** (`%445`); the tiers stay yonder, yours.

**Worth your word, still unanswered, and asked from FOUR blocks of this card until they were
merged here `20260906.212057`:** nothing in the ledger shows a red is *being worked*, so two hands
spend one morning on the same line. **Should an OPEN row carry a claim -- a seat and a stamp, at
start rather than at landing?** **Fifteen firings.** Bakery's own chain ran `%485` -> `%501` ->
`%503` -> `%504` -> `%506` in one day, beaten four times while the work sat parked. Asking it in
four places made it read as four questions rather than one.
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

**BOOKED `20260906.173141` -- the tools letter rooms, 26 of 2,030 misfiled.** `tool_path_resolve` computes a room from the basename, so `tools/f/fleet_watch.sh` is unreachable by the resolver's own rule. **Seven move any time** (`stash_record`, the `chatgpt-mind` trio, `declared_model_witness`, `ios_app_shell_witness`, `mind-bin/git`). **Nineteen need the fleet DOWN** -- `fleet-loop.sh`, `fleet_lap.sh`, `fleet_watch.sh` and the seat prompts are read by every running loop on its next lap.

**PHEROMONE, a find (`20260906.153405`):** `mantra_glow_tend_limb1..4` are a census, not a forecast, so [`stamp-and-name`](../.claude/rules/stamp-and-name.md) welcomes them -- yet they miss **a mark that reads alone**: 1 guards `Line`, 2 `Weave`, 3 `Diff`, 4 `Store`. Add the subject, keep the order.

**BOOKED `20260906` -- vendor+seed laps C-H, then gate `%1`:** [shapes and traps](../active-development/20260906-125757_the-remaining-laps-of-the-vendor-and-seed-program.md). Claimable.

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

The logs keep the account; earlier rows are shelved in
[`archive/`](archive/) under `itinerary-settled-decisions` and `itinerary-landed-laps`.

| Landed | Round | Log |
|---|---|---|
| `20260906.212721` | One fold away from healthy is not healthy | [log](../session-logs/date/20260906/20260906-212721_one-fold-away-from-healthy.kyri) |

**One row, on purpose** -- a landed lap keeps one line until the next replaces it; the log carries the detail.
