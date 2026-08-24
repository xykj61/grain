# Caravan -- the Harness

**Language:** EN
**Last updated:** `20260824.062207` (lifted whole out of `README.md`)
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- the carry, lap by lap, and the meter that keeps it
**Front door:** [`README.md`](README.md) -- start there for what Caravan is and what it does
**Ladder:** [`LADDER.md`](LADDER.md) -- the table of every module, and what each rung proves

A hundred rungs that each check themselves the same way will, given time, write the same check a
hundred times -- and a rule written a hundred times is a rule a hundred files may quietly come to
disagree about. This page is the record of carrying those repeated checks into one shared harness,
[`ladder_checks.rye`](ladder_checks.rye), one family at a time.

The first section states the shape and the meter. The sections after it are the laps, in the order
they were run, each naming what it lifted, what it cost, and what the queue printed next.

## The ladder's carried checks -- the fold, and the meter that keeps it

Every rung above imports the implementation of the rung beneath it. For eighty-odd rungs it also carried a fresh copy of that rung's self-test, because a check function was private and a later rung had no way to *call* the one below it -- only to carry its bytes forward.

Measured on metal rather than recalled, the carry reached **779 copied bodies over 54,612 lines**, growing about 4,383 lines a rung. On Keaton's word (`20260820.142246`) the design call in [`../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md`](../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md) landed as **option A**: every check is `pub` now, and a rung whose check is byte-for-byte the rung below's runs it there rather than keeping a second copy.

**523 checks fold that way, and 39,962 lines leave the ladder** -- from 289,303 lines to 249,341, with `recount` alone falling 15,664 to 13,113. Each folded check now lives in exactly one place, so an improvement to it improves every rung above at once.

The fold is conservative on purpose, and both of its limits were taught by a bolder first cut that went RED:

- **A check that reaches the wire stays home.** The bodies match byte for byte, yet each rung keeps its notes in its own directory, so the rung below would provision *its* wire and leave this rung's cold. The bolder cut passed on a warm tree and failed the moment the choir cleared the stores -- `NoteUnavailable`, a debt that could not be seated at all, which is exactly what the cold-start discipline REDS %92 seated exists to surface.
- **A check whose tail chains into a check this rung invented stays home.** The rung below has never heard of the check it would chain to, so the chain would end early and silently skip everything this rung added.

What stayed carried after A was **256 bodies over 12,035 lines**, growing about 1,637 a rung. **Option B then ran on Keaton's word (`20260820.162747`)** and ended that growth's largest share: `ladder_checks.rye` is the shared harness, its whole contract one word -- `rung` -- so a lifted check takes the rung as a comptime parameter, reaches every helper through it, and re-enters that rung on every chained tail. Both of A's named limits fall to it: the harness opens no store of its own, and a chained check ends in the rung that called it rather than the rung below. **57 bodies lifted across 30 rungs, and the carry fell from 17,997 lines to 1,952.** All 30 touched rungs were built twice, pristine and folded, and printed the same lines from a cold tree.

Nothing observable changed. Every rung of the grievance arc from `appraise` to `recount` was built twice -- folded and pristine -- and run against the same wire: **28 rungs, the same output lines, every one of them** -- only the order in which three concurrent dependents print interleaves, run to run, in the pristine build exactly as in the folded one. Every check that ran before still runs, in the same order, printing the same words. The choir sings every rung GREEN from a cold tree.

`tools/ca/caravan_ladder_copy_witness.rish` changed jobs with the fold, and changed size with it. It holds the standing under a named ceiling of **4,000** carried lines -- **47** stand there now across **101 modules and 1,275 checks** -- and it counts all three folds off the ladder rather than believing the prose: **913** checks run in the rung that owns them, counted in either form a rung may name that rung; **85** check bodies stand in the harness, each running against whichever rung handed itself in; and **0** rungs carry a forwarding stub. It proves its counting by hand on a two-rung control set, and refuses by name on every RED path it names: a control set with no modules, a control set whose modules hold no checks at all, a control set grown past its ceiling, a rung reaching past its neighbor in either fold form, and a lifted body whose printed line or comment its own lift rewrote (REDS %99). It sings with the choir, so it can never become a guard nobody runs.

**The chained bodies are lifted, and the meter says by how much.** Each new rung used to re-enter the four chained check bodies of the rung below -- the rung's own check, its refusals, its measure, and its wire -- which neither fold had reached, so the carry climbed 2,202 to 2,669 with `beckon` and 2,669 to 3,324 with `answer`. Reading which bodies made up that number found eight of them standing byte for byte alike across every rung that held them, and all eight lifted whole: the `mind` chain's measure and wire, the entire `desist` chain, and the `beckon` rung's check and its refusals. **The carry fell 3,324 to 2,762**, fold B climbed 592 to 612, and fold A held at exactly 757 -- the honest signal that lifting a body moves where it runs and never how many folds stand.

**Two bodies stayed home, and the next rung lifted them.** A chain's last link is the one place a rung differs from the rung above it: it ends in `return 0` in the rung that tops the ladder and climbs into the next rung's own check everywhere above. So `check_beckon_measure` and `check_beckon_wire` were one body per rung rather than two copies of one -- until `abate.rye` was born above `answer.rye` and made them agree, at which point they lifted whole beside `check_answer` and its refusals. `check_answer_measure` and `check_answer_wire` took that terminal seat in their place -- and lifted on the very next lap, when `conclude.rye` was born above `abate.rye` and made them agree, beside `check_abate` and its refusals. `check_abate_measure` and `check_abate_wire` took it next, and lifted in their turn when `respect.rye` was born above `conclude.rye`, beside `check_conclude` and its refusals. `check_conclude_measure` and `check_conclude_wire` took the seat after that, and lifted when `refrain.rye` was born above `respect.rye`, beside `check_respect` and its refusals. `check_respect_measure` and `check_respect_wire` took the seat next, and lifted when `farewell.rye` was born above `refrain.rye`, beside `check_refrain` and its refusals. `check_refrain_measure` and `check_refrain_wire` hold the seat now. Every chained body passes through this shape on its way into the harness, one rung at a time.

**Then the stub itself changed, and the carry fell to almost nothing.** What stood at 2,762 was very largely the five-line call each lifted check cost each rung, byte-identical across rungs by design since `@This()` resolves per rung. Those stubs existed for one reason: a chained body re-entered the rung *by name*, and a name the rung never published was a compile error, so silence had no way of being heard. Fold C ([`../active-designing/date/20260820/20260820-182533_caravan-ladder-the-harness-answers-for-silence.md`](../active-designing/date/20260820/20260820-182533_caravan-ladder-the-harness-answers-for-silence.md)) gives silence a meaning: the harness reaches every chained link through `link`, which runs the rung's own body when `@hasDecl` finds one and its own body when it does not. **612 stubs left the ladder in one pass, and the carry fell 2,762 to 47** -- a single copied body across 97 modules and 1,091 checks.

Nothing observable moved, and the shape of the change is why. A rung that keeps a body is dispatched to that body, exactly as before; a rung that publishes nothing reaches the same harness body one call earlier. The test is `comptime`, so the two are the same machine code and a name the harness does not hold can only be reached for by a rung that declares it -- which is how the terminal links of a chain keep their own bodies. All 33 touched rungs were built and run from a cold tree, and the choir sang all 91 GREEN.

**A rung now costs the ladder its own new checks and nothing else**, and five rungs have now proved it by being born: `abate.rye`, then `conclude.rye`, then `respect.rye`, then `refrain.rye`, then `farewell.rye` -- each a whole new rung, and each time the carry stood exactly where it was, at **47** lines, while the ladder grew to 102 modules and 1,321 checks. `farewell.rye` proved something else beside it: born as a copy of the rung beneath it, it inherited that rung's delegations whole, all 39 naming two steps down -- and the one-step guard REDS %98 left behind named the fault on its first pull, before a single line of it reached a send. The ceiling of 4,000 stops being the thing that refuses first, and the meter's job shifts from watching a carry climb to holding a wall at zero: no rung carries a stub that only forwards itself to the harness.

### The spine beside the checks -- what a byte-identical meter cannot see, and where it went

That meter counts **byte-identical bodies**, and it says so in its own first sentence. Beside it, measured `20260820.204641`, stood the ladder's **orchestration spine**: every rung held one `close_the_quarrel` that ran the whole correspondence in order, and a rung born from the rung beneath it copied that function whole and inserted its own step. The staircase was exact -- sixteen lines at `refer`, three more at each rung, eighty-six at `refrain` -- so no two rungs held the same body and the whole spine rode free past a meter reading 47.

Read two ways that agreed, the spine was **106 distinct lines standing on disk 1,003 times across 21 rungs, 897 of them a line the ladder had already written**. The union count asks how many different lines the ladder holds; the neighbor walk asks of each spine how many of its lines already stand in the spine directly beneath it. Both answered 897.

That was a ratchet rather than a red -- nothing was measured wrong, and something was never measured -- so the close was a second meter beside the first: [`../tools/ca/caravan_ladder_spine_witness.rish`](../tools/ca/caravan_ladder_spine_witness.rish) over [`../tools/fixtures/caravan_ladder_spine_scan.sh`](../tools/fixtures/caravan_ladder_spine_scan.sh), holding both numbers in one place so neither can be read alone.

**Fold D moved it on `20260820.212419`.** The spine lives in [`ladder_checks.rye`](ladder_checks.rye) now -- one body taking the rung as a `comptime` parameter and running the steps that rung declares, so the rung holding five steps and the rung holding twenty-five reach the same spine and each gets exactly its own. The staircase became a property the harness derives rather than twenty-one hand-copies of it, and adding a step to the arc costs three lines in one file rather than a fresh copy of everything beneath it.

The numbers moved as the design call predicted, and the one that should have stood still stood still:

| Reading | Before | After |
|---|---|---|
| Rungs holding a spine | 21 | **1** -- the harness |
| Spine lines on disk | 1,003 | **19** at the entry, 170 counting its four movements |
| Carried spine lines | 897 | **0** |
| Spines past TAME's seventy-line bound | 4 | **0** -- the longest movement is 59 |
| Byte-identical carry, beside it | 47 | **47**, unmoved |

That last row is the honest proof: a lift removed a cost rather than trading it for a cheaper-looking one, since the number a lift could most easily have inflated stayed exactly where it stood. The spine ceiling came down 1,100 to **40**, tight enough to catch the second rung that writes a spine of its own rather than the tenth -- the meter stopped sizing a cost and became the wall that keeps the fold folded.

Read in order, the harness spine is four movements and a closing line, the seam the arc has shown since it began: **the standing** (what a run owes a position that outlived it), **the finding** (a case read, answered, met, and carried home), **the second look** (what a reader's short word costs the plan that answered them), **the correspondence** (the movement still growing, where a matter that comes round twice meets a wall and a person outside the plan finally gets a say), and **the booking**, always last. What it cost is named plainly in the brief: opening `refrain.rye` no longer shows the whole arc on one screen. That order lives in the harness now, in the one complete copy there is -- so it is written to be read. Full reasoning: [`../active-designing/date/20260820/20260820-204641_caravan-ladder-the-spine-the-meter-cannot-see.md`](../active-designing/date/20260820/20260820-204641_caravan-ladder-the-spine-the-meter-cannot-see.md).


### The printing, and the two folds that answered most of it

Two honest meters watched this ladder, and a third shape rode free past both. The copy meter reads `check_` bodies and counts byte-identical ones; the spine meter reads one named orchestration function. Every rung also reports what its run did, in words an operator reads -- a `tell_` family printing one line per tier of the correspondence -- and a rung born from the rung beneath it copies that family whole and inserts its own tier. A different prefix than the first meter reads, a different function than the second names, so the printing went uncounted while each elder meter reported a true number. A ratchet, then, rather than an erratum: both had named their own window in their own first sentence.

Measured on `20260820.221349`, the printing stood at **2,468 distinct lines on disk 9,317 times across 42 rungs, 6,849 of them lines the ladder had already written** -- seven and a half times the spine fold D lifted, and the largest carry on the ladder. The meter is [`../tools/ca/caravan_ladder_print_witness.rish`](../tools/ca/caravan_ladder_print_witness.rish) over [`../tools/fixtures/caravan_ladder_print_scan.sh`](../tools/fixtures/caravan_ladder_print_scan.sh), and it reports the carry two ways on purpose, because the split decides what the fold should be: whole bodies standing byte for byte lift the way a check lifts, while the staircase wants the harness seam fold D opened.

**Fold E took the first half on `20260820.222728`.** The note-writing pair is the part of the family the whole correspondence arc never varies: `tell_path`, which writes the address an answer is left at, and `tell_outcome`, which writes the single byte telling a reader how their quarrel came out. Both stood byte for byte in **twenty-nine rungs**, and every symbol either one reaches -- the path ceiling, the readers' directory, the address test, the result shape, the byte that names an outcome, the error set -- already stood public on all twenty-nine. So both lifted into [`ladder_checks.rye`](ladder_checks.rye) whole, each rung keeping a three-line call that leaves its own public surface untouched.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 9,317 | **8,427** |
| Carried printing lines | 6,849 | **5,955** |
| Lines deleted from rungs | -- | **986**, for 174 lines of call |
| Neighbor walk, read independently | 6,641 | **5,735** -- within four percent |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The last two rows are the same honest proof fold D left: a lift removed a cost rather than trading it for a cheaper-looking one. The ceiling came down 7,800 to **6,900** in the same lap, since a ceiling left where a fold found it hands back exactly the room the fold just won. All twenty-nine touched rungs stand in the top rung's import closure, and that rung runs GREEN from a cold tree, with `tidings`, `abate`, `deem`, `suffice`, `reweigh`, and `apprise` re-run beside it. What remains of the carry is the reader-telling pair -- the two larger bodies that read a run's own report -- and the staircase beneath them, which wants the `comptime` seam rather than a whole-body lift.

**Fold F took the larger half on `20260820.224828`.** `tell_the_reader` carries one finding to the one person who asked for it, and it is the body the whole arc is built to end on: a run reads the quarrel out of the record that keeps it, reads the term that decided it, reads the address the raiser left, writes the result into that reader's own box, and reads the box back before the report believes anybody was told. Sixty lines apiece, standing byte for byte in **twenty-eight rungs**.

It reaches nineteen symbols where the note-writing pair reached six, so the verification came first and cost more. Every one of the nineteen was grepped as `pub` across all twenty-eight rungs before a line moved, and eighteen already stood public. The nineteenth is `tidings_of`, the accessor that finds this tier's own report inside a report nested as deep as the rung stands -- twenty-four `inner` hops in one rung, six in another. That accessor is precisely the staircase, and lifting the body above it needed no flattening of it: one word per rung widened the accessor the harness already reaches every other tier through, and the staircase stayed exactly where it is written.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 8,427 | **6,896** |
| Carried printing lines | 5,955 | **4,401** |
| Lines deleted from rungs | -- | **1,652**, for 56 lines of call |
| Neighbor walk, read independently | 5,735 | **4,069** -- within eight percent |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The whole-body reading holds at 93 while its line count falls 2,268 to **729**, since the two-line calls a fold leaves behind are themselves a body every rung writes identically. Reading that steadiness as a failure would misread it: the carry that matters is the line reading, and it fell 1,554. The neighbor walk's agreement widened from four percent to eight for the same arithmetic reason -- the same absolute gap standing against a smaller total -- and naming both keeps the next reader from drawing a wrong conclusion from a number that stood still.

The ceiling came down 6,900 to **4,800**, sized so a first new rung passes and a second refuses. All twenty-eight touched rungs stand in the top rung's import closure, that rung runs GREEN from a cold tree, and each of the twenty-eight ran its own witness GREEN beside it. What remains of the carry is `tell_the_reopener` -- forty-eight lines in eleven rungs -- and the staircase of per-tier bodies beneath both. Full reasoning: the design call [`../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md`](../active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md), and the lap that measured the printing, [`../session-logs/date/20260820/20260820-221349_caravan-ladder-the-printing-two-meters-cannot-see.kyri`](../session-logs/date/20260820/20260820-221349_caravan-ladder-the-printing-two-meters-cannot-see.kyri).

**Fold G spent the last whole body on `20260820.232126`.** `tell_the_reopener` carries what a second look came to out to the reader who asked for it: a run takes its subject off the wire rather than from anything the plan asked for, writes into that reader's own box, and reads the box back before the report believes anybody was told. Forty-eight lines apiece, standing byte for byte in **eleven rungs**, with the rung the family was born on left alone because it writes the body differently.

It reaches eighteen symbols, and this time every one of them already stood public across all eleven -- so the fold widened nothing. That is what the previous fold's one-word widening bought: the accessor pattern the harness reaches every tier through was already in place, and the third lift simply used it. Verification still came first, exactly as before, because a check that only ever passes is still the check that made a five-hundred-line edit safe.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 6,896 | **6,454** |
| Carried printing lines | 4,401 | **3,944** |
| Lines deleted from rungs | -- | **517**, for 11 lines of call |
| Neighbor walk, read independently | 4,069 | **3,483** -- within twelve percent |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The two readings' gap grew by 129 absolute this lap, where the earlier folds had widened it only proportionally, and the reason is read off the scan rather than guessed: the neighbor walk orders rungs by total file length and compares each against the one before it, so eleven rungs shrinking by forty-eight lines apiece reorder the sequence itself and the walk's own pairing moves beneath it. A fold that shrinks rungs unevenly is exactly the act that most disturbs that reading -- a property of the second reading worth naming, rather than a fault in either.

The ceiling came down 4,800 to **4,300**, sized as before so a first new rung passes and a second refuses. All eleven touched rungs ran their own witness GREEN, the top rung ran GREEN from a cold tree, and the whole choir of **98 Caravan witnesses** sang GREEN cold beside them -- which is how this lap found that the printing meter had never been registered in that choir (**REDS %101**), and, folding the ledger that red filled, that the ledger's own spine guard had been proving seventy-three rows of a hundred and one (**REDS %102**). Both closed with looms rather than with fixes: the roster bijection lifted into a scan the every-lap ladder meter pulls, and the spine guard taught to discover its archives on disk rather than read a list somebody maintains by hand.

What remains of the printing carry is the staircase of per-tier bodies, which wants a different fold than a whole-body lift -- the whole-body carry is spent.

**Fold H reached past byte-identity on `20260820.235259`.** The desisting telling -- `tell_desist_half` and the `tell_desist_third` it chains into -- stood in **eight rungs** at forty and fifty-two lines apiece, and the whole-body reading could not see it at all: no two of the sixteen bodies hashed alike, so every one of them counted as distinct. Reading them side by side showed why. They differ in exactly one thing -- the pair of words naming which plan each column reports, `holding, abating` in the abating rung and `leaving, hearing` in the answering one. Mask that pair and all eight halves are one hash, and all eight thirds are another.

So the fold takes the pair as **comptime text** and lifts the bodies whole. Each rung keeps a three-line call handing in its own two words, the harness composes the printed line by concatenation, and every line comes out exactly as that rung wrote it. Six symbols widened by one word in each of the eight -- `dwell_of`, `endure_of`, `heed_of`, `relent_of`, `swell_of`, and the tail the harness hands control back to -- verified as `pub` across all eight before a line moved, the check that has made every fold in this arc safe.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 6,454 | **5,848** |
| Carried printing lines | 3,944 | **3,433** |
| Lines deleted from rungs | -- | **816**, for 56 lines of call |
| Neighbor walk, read independently | 3,483 | **2,715** -- within twenty-one percent |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The proof this fold rests on is stronger than a hash, because a hash could no longer reach it. All eight rungs were built and run before the edit and their whole printed output captured; all eight were built and run after, and the two outputs stand **line for line identical** -- save forty-two lines whose order concurrent clients set rather than the fold, which hold their count exactly. Measurement caught that nondeterminism honestly: a first comparison read as a difference, and running one binary twice showed the ordering moves on its own.

The ceiling came down 4,300 to **3,700**, sized as before so a first new rung passes and a second refuses. All eight touched rungs ran their own witness GREEN, and the whole choir sang GREEN cold beside them.

What remained carried was the **true staircase** -- `tell_desist_tail` and `tell_beckon_own`, bodies that read tiers through a nesting each rung writes at its own depth, nine and ten `inner` hops in one rung where the next writes eight. Both looked like they wanted an accessor **born** rather than a body lifted. The two folds below found otherwise: every accessor those bodies needed was already standing.

**Fold I lifted the staircase's first half on `20260821.002546`, and widened nothing.** `tell_desist_tail` stood in **eight rungs** at fifty-two lines apiece with no two hashing alike, varying in two things: the pair of words fold H had already learned to lift, and the depth of the raw nesting reaching three tiers. The whole cost was read before a line moved, and it came to zero. Mapping each rung's nesting depth against its own accessor table showed all three tiers -- sufficing, reopening, reweighing -- already had an accessor standing at exactly that depth, and all **six symbols the body reaches already stood `pub` across all eight rungs**. That is folds F and G compounding: F widened one accessor by hand across twenty-eight rungs, G found eighteen of eighteen already public because of it, and this lap found six of six.

Substituted, masked, and hashed, all eight collapsed to one hash, and seven of the eight were then identical outright -- `desist` differing in one more thing, its trailing hop naming its own next tier where the other seven name theirs. That hop stayed in the rung's own delegate rather than widening seven symbols or reaching for indirection, so the staircase stayed written where each rung writes it.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 5,848 | **5,522** |
| Carried printing lines | 3,433 | **3,231** |
| Lines deleted from rungs | -- | **392**, for 8 lines of call |
| Neighbor walk, read independently | 2,715 | **2,646** -- the gap narrowing for the first time |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The ceiling came down 3,700 to **3,500**. Parity was proven by building and running all eight rungs before and after: every sorted multiset identical, zero non-client differences, and the interleave proven to be the run rather than the fold by running one *unfolded* binary twice and watching it disagree with itself by more lines than the fold did.

**Fold J lifted the whole staircase on `20260821.005102`, and the accessor it was said to want was already born.** `tell_beckon_own` stood in **seven rungs** from thirty-four lines to a hundred and eleven, and the length itself looked like content: each rung walks up to the tiers it owns, so neither a hash nor a mask could reach it. Reading the seven side by side against their own accessor tables showed what the lengths were hiding.

Each body is a staircase of **tier groups**, three printed lines apiece, and every rung prints the groups reaching from the recount tier up to its own. Masked for the pair of words and for nesting depth, the seven are **one thirty-five-line sequence in strict prefix order** -- beckon says the first seventeen lines, answer the first twenty, farewell all thirty-five -- each followed by the same three-line tail. Nothing in the seven is a variation; they are seven different lengths of one staircase.

And the depth needs no counting at all. Every rung of this arc already publishes **one named reach per tier it wraps**, exactly so a miscount cannot hide inside a chain of `inner`, and those reaches form an exact triangle: farewell declares eleven, refrain ten, beckon five. So a rung's share of the staircase is **derived** from the accessors it declares rather than kept in a list somebody maintains by hand -- the lesson REDS %102 taught, applied at the moment of design rather than after a guard went blind.

The staircase stands once in `ladder_checks.rye` as a comptime table of twelve tiers, and each rung keeps a one-line call handing in its own two words. The two invariant asserts lifted with it, written as named reaches -- every rung's second assert turned out to reach exactly the mind tier. Three symbols widened by one word each across the seven -- `below_of`, `bearing_of`, `preceded_of` -- the same one-word move fold F made.

| Reading | Before | After |
|---|---|---|
| Printing lines on disk | 5,522 | **4,919** |
| Carried printing lines | 3,231 | **2,932** |
| Lines deleted from rungs | -- | **603**, for 7 lines of call |
| Neighbor walk, read independently | 2,646 | **2,616** -- within eleven percent, converging |
| Bodies past TAME's seventy-line bound | 9 | **4** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

The ceiling came down 3,500 to **3,100**. All seven rungs were built and run before the edit and after it, and **every sorted multiset stands identical with zero lines differing** -- the strongest parity any fold in this arc has shown. The ordered comparisons differ by ten to sixteen lines, every one of them a concurrent-client line present in the same count on both sides, and an unchanged binary run twice against itself differs by eight in exactly the same way.

Five of the nine bodies past TAME's seventy-line bound left by construction rather than by a split, the ratchet and the fold wanting the same lap. `tame_style_check` and `width-check` are clean, all three ladder meters GREEN, and the whole choir of **98 Caravan witnesses** sang GREEN cold beside them.

**Fold K lifted the run-telling on `20260821.013000`, and it was the plainest fold this arc has had.** `tell_desist_runs` stood in **eight rungs at fifty lines apiece** -- 400 lines carried, the movement that counts phases and dependents before the telling turns to the quarrel the desisting rung holds. Its shape was measured rather than guessed: masked for the pair of words naming which plan each column reports, all eight collapse to **one hash**, and this time the nesting depth stood identical across all eight as well. No staircase hid here at all.

So the fold is fold H's shape with nothing added. The body lifts whole into `ladder_checks.rye` as `tell_desist_runs`, the pair arrives as comptime text, and each rung keeps a one-line delegate handing in its own two words. Nine symbols widened by one word each across the eight -- `abandoning_of`, `recanting_of`, `amending_of`, `couriering_of`, `disputing_of`, `abiding_of`, `lapsing_of`, `reposing_of`, `appeal_of`, with `below_of` making a tenth in the desisting rung -- verified as `pub` before a line moved, the check that has made every fold in this arc safe. **457 lines deleted for 157 of harness and call.**

One raw reach remains, and the harness names it rather than hiding it: the absorbed tally sits four levels below `abandoning_of`, since no rung publishes an accessor reaching that tier. The chain stood at the same depth in all eight rungs, and it stands once now, where a single reading governs every rung that calls in. Naming it is the honest form of fold J's lesson -- an accessor born for that tier is the next lap's cheap work, and the comment says so where the code is.

Parity is the strongest form this arc has settled on. All eight rungs were built and run before the edit and after it, and **every sorted multiset stands identical with zero lines differing**. The ordered comparisons differ by four to sixteen lines, every one a concurrent-client line present in the same count on both sides -- and an unchanged binary run twice against itself differs by fourteen in exactly the same way, so the interleave is the run rather than the fold, as folds I and J each proved before it.

The two rows a lift could most easily have inflated stood still for the seventh fold running: the byte-identical check carry holds at **47** and the orchestration spine at **0**. The ceiling came down 3,100 to **2,800**. The neighbor walk's gap narrowed 21 percent to **13**, by the same mechanism that widens it -- the walk orders rungs by file length, so a fold that shrinks eight rungs by forty-nine lines apiece moves its own pairing. `tame_style_check` and `width-check` are clean, all three ladder meters GREEN, and all eight rung witnesses GREEN beside them.

**The printing carry has fallen 5,955 to 2,686 across six folds -- and this lap found that the carry is far from spent.**

Six folds all lived inside the `tell_` family, and the arc's own record had begun to read "the staircase is spent" as though the family were the ladder. Asking the masked question of **every** printing body rather than the `tell_` ones alone answers otherwise, and the two largest carriers in the ladder had never been looked at:

- **`stand_taking_and_returning_reach`** -- **42 of its 44 rungs share one hash** at thirty-five lines apiece, **1,435 lines carried**. Larger than any single fold this arc has taken, and the two rungs that differ stand at seventy-six and eighty lines, which is their own content rather than a variation.
- **`run_dependent`** -- **43 of its 67 rungs share one hash** at thirty-three lines apiece, **1,386 lines carried**, with the remaining twenty-four genuinely various.

Naming this correction plainly matters more than the fold that found it. A narrative built from six laps in one family had quietly become a claim about the whole, and only asking the meter a wider question could disagree with it. **Measurement beats memory, including the memory written down six laps in a row.**

**Fold L lifted the standing-dependent window on `20260821`, and it is the largest single fold this arc has taken.** `stand_taking_and_returning_reach` -- the body that reads the arcs one dependent was handed, grafts every arc it is conferred, and returns the reach the run asks back before it comes home -- stood **byte for byte in forty-two of its forty-four rungs at forty-four lines apiece**. No mask was needed and none was used: the forty-two hash alike exactly as written, so the body lifts precisely the way a check lifts.

The two rungs that stand apart, `reclaim` and `revoke`, keep their own bodies at eighty-five and eighty-eight lines, which is their own content rather than a variation on this one.

Four symbols widened by one word each across the forty-two -- `read_own_line`, `graft_promised_reach`, `return_promised_reach`, and `reachable_between` -- every one verified as `pub` before a line moved, and `offered`, `falling_promised`, and `Words` already stood public on all forty-two, which is nine folds of the habit compounding. Four rungs that had never needed the harness gained their import. **1,638 lines deleted for 281 of harness and call, and 1,189 lines came off disk.**

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 42 | **0**, each keeping a nine-line delegate |
| Lines the body carried | 1,764 | **0** |
| Lines on disk, all of `caravan/` | 379,740 | **378,551** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

Parity is the strongest this arc has shown. All forty-two rungs were built and run before the edit and after it, and **every one of the forty-two sorted multisets stands identical with zero lines differing**. Thirty-three rungs differ in ordered comparison by two to eighteen lines, and an unchanged binary run twice against itself differs by eight the same way -- the interleave is the run rather than the fold, as folds I, J, and K each proved before it. All forty-two rung witnesses ran GREEN on metal, `tame_style_check` and `width-check` are clean, and the whole choir sang GREEN beside them.

### The wider question, made standing -- a fourth meter, and the room the three windows sit in

Fold L was found by hand, by asking one wider question after six folds inside the `tell_` family. That is the part worth keeping, and this lap turned it into a meter rather than leaving it as luck.

Three meters stood on this ladder, and every one reads through a **named window**: [`caravan_ladder_copy_scan.sh`](../tools/fixtures/caravan_ladder_copy_scan.sh) reads bodies opening on `check_`, [`caravan_ladder_print_scan.sh`](../tools/fixtures/caravan_ladder_print_scan.sh) reads bodies opening on `tell_`, and [`caravan_ladder_spine_scan.sh`](../tools/fixtures/caravan_ladder_spine_scan.sh) reads one named function. Each is honest inside its window, each says so in its own first sentence, and together they governed eleven folds. What none of the three can see is a body named anything else -- which is exactly why the largest carry on the ladder rode past all three for six consecutive folds.

So the fourth meter has **no name in its window at all**. [`caravan_ladder_carry_scan.sh`](../tools/fixtures/caravan_ladder_carry_scan.sh) reads every top-level body in every module, compares them by exact text rather than by hash, and prints the fold queue largest-first. Its answer, measured rather than estimated:

| Reading | Carried lines |
|---|---|
| Byte-identical `check_` bodies | 47 |
| `tell_` printing | 2,686 |
| Orchestration spine | 0 |
| **Every body, the whole ladder** | **142,850** across 10,198 copied bodies of 17,975 |

**698 families carry at least one copy, and 247 of them carry past a hundred lines each.** The largest is `mend_the_plan` -- 36 rungs holding one 178-line body, **6,230 carried**, which alone is larger than any fold this arc has taken, fold L included. Behind it stand `fill_table` at 2,898, `reckon_the_plan` at 2,700, `provision_notes` at 2,093, and `confer_one` at 2,067; `graft_promised_reach`, one of the very helpers fold L widened, carries 1,763 of its own.

This is a **ratchet rather than a red against the three**. Each named its window plainly, so nothing was measured wrong -- something was never measured. Yet the correction is worth stating without softening: the arc's own record had come to read the printing carry as *the* carry, and the ladder's real carry is two orders of magnitude larger. That is [`REDS %102`](../construction/REDS.md)'s family at ladder scale -- a reading that sees a subset answers in the voice of the whole, and a GREEN over part of a subject is more dangerous than a RED. The answer is never a fourth named window; it is one window with no name in it.

The meter is proven by [`caravan_ladder_carry_witness.rish`](../tools/ca/caravan_ladder_carry_witness.rish) -- the living count under a named ceiling, the three windows read beside it so no reader mistakes a window for the room, the counting proven by hand on a two-rung control set whose added body opens on a prefix no meter names, and three RED paths refusing by name. It is **registered in the choir on the lap it was born**, which is [`REDS %101`](../construction/REDS.md)'s whole lesson, and the choir now sings **99**.


### Fold M -- `mend_the_plan`, the largest body on the ladder, and the accessor that brought the last rung in

The fourth meter was born on the lap before this one, and its first printed queue named `mend_the_plan` at the top. This lap folded it. **That is the whole argument for a printed queue**: fold L was found by hand after riding past three meters for six folds, and fold M was found by reading one line of output.

`mend_the_plan` is the body that repairs the losses a plan took which its author never asked it to carry, then settles whatever the repair could not reach. It stood **byte for byte in thirty-six rungs at a hundred and seventy-eight lines apiece** -- and nearly in a thirty-seventh.

That thirty-seventh is the interesting one. [`recant.rye`](recant.rye) *owns* the recanting tier, so where every rung above it reaches its recantation through `recanting_of`, `recant.rye` reached its own report directly -- two lines out of a hundred and seventy-eight. Naming the accessor there, three lines returning the report itself, brought the last rung into the fold. Fold J learned this on the staircase and it holds again: **an accessor born for the tier a rung owns is the cheapest line in the arc.** Thirty-six rungs became thirty-seven, and the carry to lift climbed 6,230 to **6,408**.

Twelve symbols were widened by one word each before a line moved, every one verified `pub` across all thirty-seven first: `Table`, `standing`, `appraising_of`, `abandoning_of`, `below_of`, `bearing_of`, `recanting_of`, `run_of`, and the four spine bodies the repair runs -- `seat_the_record`, `fill_table`, `reap_oldest`, `judge_outcome`. **427 widenings in all.** Every other symbol the body names -- its plan's phases, the wire it published its judgment to, and each refusal it may raise -- already stood public from earlier folds, which is ten folds of the habit compounding.

Widening those four spine bodies is the compounding made visible: `fill_table` carries 2,484 lines across 37 rungs and `reap_oldest` 1,716 across 40, and both now stand public for the folds that will come for them. A fold's own widening puts the next fold in view, exactly as fold L first noticed.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 37 | **0**, each keeping a nineteen-line delegate |
| Lines the body carried | 6,408 | **0** |
| The ladder's whole carry | 142,850 | **137,140** |
| Carry ceiling | 143,000 | **137,300** |
| Lines on disk, all `caravan/*.rye` | 378,383 | **372,895** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

Both endpoints of that disk row were re-measured this lap by the same command rather than carried forward from fold L's note, since a tally repeated from memory drifts ([`REDS %93`](../construction/REDS.md)).

**6,403 lines deleted for 747 of harness and call, and 5,488 lines came off disk** -- the largest fold this arc has taken, more than three times fold L. The two rows a lift could most easily have inflated stood still for the **ninth** fold running: the byte-identical check carry at 47 and the orchestration spine at 0. A cost removed rather than traded, nine laps in a row.

Proven the way this arc proves things: the whole choir sang **99 GREEN from a cold tree**, every one of the thirty-seven folded rungs among them, with `tame_style_check` bans clean, `width-check` clean, and the ladder reach guard holding at one rung below per rung. The carry meter's own pins moved with the measurement rather than after it, and its ceiling came down in the same commit -- because a meter whose ceiling lags its subject is a guard that has stopped guarding.

`reckon_the_plan` led the queue as fold M closed, at 2,700 lines across 37 rungs, with `fill_table` at 2,484 behind it -- and fold N below lifted it. **703 families still carry a copy**, so the queue outlasts many laps and no lap need guess what is next.


## Fold N -- `reckon_the_plan`, and a closing sentence that had drifted while nobody counted it

The printed queue named the next fold, exactly as it is meant to. `reckon_the_plan` stood **byte for byte in thirty-seven rungs at seventy-five lines apiece -- 2,700 carried lines**, the largest family on the ladder from the moment `mend_the_plan` lifted out of the same thirty-seven. No lap had to guess, and no name had to catch anybody's eye.

`reckon_the_plan` is the body that publishes what a run came to, weighs the judgments standing on that run's own wire, and leaves the report holding exactly the loss a repair must answer. It moves into [`ladder_checks.rye`](ladder_checks.rye) whole, takes the rung as a comptime parameter, and reaches every symbol through it -- so each rung still reckons its own plan, against its own wire, into its own report.

**This fold cost no accessor at all.** Fold L needed a three-line `recanting_of` in `recant.rye` to bring its thirty-seventh rung in; here all eighteen symbols the body reaches already stood `pub` on all thirty-seven, verified before a line moved. That is what a ladder looks like after eleven folds have taught it to publish what it shares.

**Four elder rungs keep a body of their own** -- [`reckon.rye`](reckon.rye) at 27 lines, [`mend.rye`](mend.rye) at 35, [`bear.rye`](bear.rye) at 41, and [`appraise.rye`](appraise.rye) at 51. Each is the rung where a tier grew, and each body genuinely differs; sweeping them in would have folded four meanings into one. They stay home, and the meter keeps counting them apart.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 37 | **0**, each keeping a nine-line delegate |
| Lines the body carried | 2,700 | **324** -- the delegate is itself a copy |
| The ladder's whole carry | 137,185 | **134,809** |
| Carry ceiling | 137,300 | **135,000** |
| Lines on disk, all `caravan/*.rye` | 375,997 | **373,828** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**A fold shrinks a family to its call; it never erases it from the count.** The carry fell 2,376 rather than the 2,700 the queue named, and the difference is the nine-line delegate now standing byte-identical in thirty-seven rungs. Any lap expecting a folded family to vanish whole is reading the meter wrong, so the meter says so in its own header now.

### The red this fold walked into (REDS %110)

Re-pinning the carry meter meant reading its closing sentence, and the sentence was wrong. It had been closing every GREEN run reciting *"137,176 lines across 10,198 copied bodies of the 18,039 standing on it"* while its own assert, four lines earlier, pinned **137,185, 10,199, and 18,055** -- and the line above the close recited the same stale number again.

The meter had stayed GREEN straight through, because the guard [`REDS %108`](../construction/archive/REDS-caravan-meter-prose-rows-108-109.md) built refuses exactly one phrase: a number followed by the word `modules`. This meter drifted on lines, bodies, and copies instead. **A guard bounded by a vocabulary catches the incident, never the class.**

So the rule is bounded by a property now: **every number a ladder meter prints in a `say` line stands asserted in that same file**, thousands separators stripped, since `137,176` and `137185` are one claim in two costumes. A subject number is asserted and survives; a context number earns an assert or leaves the sentence. Two frozen controls hold the RED path under version control rather than pinned to `HEAD` ([`REDS %109`](../construction/archive/REDS-caravan-meter-prose-rows-108-109.md)'s lesson): the carry meter exactly as it shipped, and the elder spine meter, which the new rule refuses too -- on the number rather than on the noun. The second rule is strictly stronger than the first rather than merely beside it.

The rule proved itself on the way in twice over. Drawn first at the closing line alone, it was too narrow within the hour -- the line directly above the close carried the same stale number -- so it widened to every printed line. And its first pattern, an `(^|[^0-9])` alternation, matched nothing at all, because this shell's grep reads a `^` inside a group as a literal caret; the probe caught it by refusing a number the file plainly asserts. A guard that has never refused what it should welcome is a guard nobody has tested.

## Fold O -- `fill_table`, the largest family the arc has folded, and the queue that could only see two thirds of it

The printed queue named `fill_table` next: **thirty-seven rungs at sixty-nine lines apiece, 2,484 carried lines.** Reading past that answer before folding it is what made this the largest fold the arc has taken.

**Forty-three rungs held the body, and the six the queue left out differ by the word `pub` and nothing else** -- one line out of sixty-nine. The carry scan names a family by exact text, which is precisely what makes it trustworthy about collisions and precisely what blinds it here: `pub fn fill_table(` and `fn fill_table(` are two texts and one body. Fold M had already measured the true size, **2,898 lines across forty-three rungs**, and written it down beside the four spine bodies it widened for exactly this fold. The queue simply could not see it.

**So a fold queue is a lead, never a verdict.** It names where to look; the reading that follows says how much is actually there. That sentence now stands in the scan's own header, so the next lap inherits the caution rather than rediscovering it.

`fill_table` is the body that takes up every phase a run may start right now -- conferring the slots that are owed, admitting what the doors allow, and recording each turn, fence, mask, and precedence a pick stepped past on the way. It moves into [`ladder_checks.rye`](ladder_checks.rye) whole and reaches every symbol through the rung handed in, so each rung still fills its own table, against its own doors, into its own report. `mask.prefix_mask` and `mask.fence_after` stay module-level, since a mask is the same arithmetic for every rung rather than something a rung writes over its own report.

**The cost is 435 widenings** -- eleven bodies and one shape, one word each, across forty-three rungs, every one verified at column zero before a line moved. Five of them move the table (`advance_head`, `confer_slot`, `confer_one`, `choose_pass`, `start_one`), three weigh a pick (`door_admits`, `sibling_waits`, `elder_waits`), three reach the report (`run_of`, `masked_of`, `preceded_of`), and `Table` is the shape they all name. Every one of them leads a family still standing in the queue, so this fold prepared the next several the way fold M prepared this one.

One rung needed a line no other did: [`reclaim.rye`](reclaim.rye) had never imported the harness, being older than it. Nothing the harness imports reaches back to `reclaim`, so the import is safe, and its own witness proves it on metal.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 43 | **0**, each keeping a sixteen-line delegate |
| Lines the body carried | 2,829 as the meter counted it, 2,898 as one family | **656** -- the delegate is itself a copy |
| The ladder's whole carry | 134,809 | **132,589** |
| Carry ceiling | 135,000 | **132,700** |
| Lines on disk, all `caravan/*.rye` | 373,828 | **371,654** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**Widening a symbol moves that symbol's own family too, and the arithmetic closes because of it.** A declaration line is part of the body it opens, so making `elder_waits` public in forty-three of the fifty-one rungs that hold it split one family of fifty-one into one of forty-three and one of eight -- and a split *lowers* the carry by one body, since the new family's first copy becomes a distinct text. Eleven such splits account for the 47 lines by which the measured fall, **2,220**, exceeds the 2,173 the fold's own family gave back. Nothing is unexplained, and none of it is estimated.

## Fold P -- `confer_slot`, and the first fold the arc has taken for free

The printed queue named `confer_slot` at **forty-three rungs by thirty-nine lines, 1,638 carried**, and this time the queue was exactly right. Hashing every `confer_slot` body on the ladder before folding it confirmed the count rather than correcting it: forty-three rungs hold one body byte for byte, and 39 x 42 is 1,638 precisely. The check is worth running either way -- a lead that agrees with the reading is still a lead that was read.

`confer_slot` answers which standing dependent could carry this phase, if any could. It matches the phase's domain against a live dependent's, weighs the hops the phase declares against the reach that dependent still holds in reserve, and walks every arc it would take, checking each for both name and write intent before it answers.

**Fold O prepared this fold entirely, and the cost shows it: zero widenings.** The five symbols this body reaches through the rung -- `hop_count`, `reserve_depth`, `Table`, `max_in_flight`, and the harness import itself -- were all made public across the same forty-three rungs one lap earlier, for `fill_table`. Not a single file needed a word changed before a line could move. **A fold pays its successors**, so the honest price of a widening is charged once and spent several times over; a lap reading only the widening count of the fold in front of it reads that price too high. That sentence now stands in the scan's own header beside the caution fold O left there.

`confer.reserve_arc_at`, `intent.declares_write`, and `cycle.max_hops` stay module-level, since a reserve's arcs, an arc's write intent, and the bound on how many hops one item may name are the same for every rung on the ladder.

**Two elder rungs keep their own copies, for reasons that are real rather than stylistic.** [`confer.rye`](confer.rye) *owns* `reserve_arc_at` and calls it unqualified where every folded rung reaches it through this module -- and folding it would ask the module this harness imports to import the harness back. [`revoke.rye`](revoke.rye) predates the in-flight invariant and states one assert fewer, so folding it would quietly add a check rather than move a body. Both differences are two lines, and both stay home named.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 43 | **0**, each keeping a three-line delegate |
| Lines the body carried | 1,638 | **126** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **0**, every symbol already public from fold O |
| The ladder's whole carry | 132,589 | **131,077** |
| Carry ceiling | 132,700 | **131,200** |
| Lines on disk, all `caravan/*.rye` | 371,654 | **370,181** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes exactly, with no remainder at all.** The family gave back 1,638 and the new three-line delegate family carries 126, so the carry falls 1,512 -- which is what the meter measured. Fold O's 47-line gap came from eleven family splits its widenings caused; a fold that widens nothing splits nothing, so this one leaves nothing to explain. On disk the same closure holds: forty-three rungs each shed thirty-six lines for 1,548, the harness took 75, and 370,181 is what remains.

## Fold Q -- `confer_one`, and the absentees that dated the family

The printed queue named `confer_one` at **forty rungs by fifty-three lines, 2,067 carried**, and hashing every body by that name on the ladder agreed exactly: forty rungs share one text byte for byte, and 53 x 39 is 2,067 precisely. Fold O taught that a queue is a lead rather than a verdict, so the reading runs either way -- and twice now it has confirmed what the meter printed rather than corrected it.

`confer_one` is the moment a supervised run stops starting things and starts *reusing* one. The phase's hops are added to what a standing dependent has already taken, the grown reach is offered to `entrust` for refusal, the words are written, the dependent is asked, and only an answer read back off the wire lets the table believe the reach was carried. Then the report counts it three ways, and the slot remembers which phase it absorbed -- so a later mend can name the arc it lost rather than re-running the plan whole.

**The five rungs that stand apart are the ladder's own fossil record.** Every one of them writes a body by this name, and every one differs in exactly one place: how deep it reaches into the report. Read in ladder order they climb a staircase.

| Rung | How it reaches the report | Depth |
|---|---|---|
| [`confer.rye`](confer.rye) | `report_out.conferred` | 0 |
| [`revoke.rye`](revoke.rye) | `report_out.inner.conferred` | 1 |
| [`reclaim.rye`](reclaim.rye) | `report_out.inner.inner.conferred` | 2 |
| [`abandon.rye`](abandon.rye) | `below_of(report_out).inner.inner.conferred` | accessor + 2 |
| [`reckon.rye`](reckon.rye) | `below_of(report_out).inner.inner.inner.conferred` | accessor + 3 |
| the forty above | `abandoning_of(report_out).inner.inner.inner.conferred` | accessor + 3 |

Two things settle on that staircase, one rung apart. At `abandon.rye` the ladder stops counting hops and **names** the reach through an accessor; at `reckon.rye` the depth settles at three and never moves again; and from `amend.rye` upward the accessor's own name settles too, as `abandoning_of`. After those settlings nothing about the reach is a per-rung fact -- which is precisely why the forty above are identical and the five below cannot be. **A family's absentees are worth reading, since they say when the shape it shares was born.**

The two eldest also predate whole lines rather than a depth. `confer.rye` and `revoke.rye` were written before a conferral granted, served, or pruned, so folding either would quietly add behavior rather than move a body. Both stay home named, as they did for fold P.

**The fold cost forty-three widenings**, and both are bodies a rung writes over its own report or its own wire: `revoke_one` made public in all forty, and `abandoning_of` in the three that still held it private. `entrust.entrust_refusal`, `entrust.Line`, and `confer.write_words` stay module-level, since a refusal's arithmetic and the words a conferral writes are the same for every rung on the ladder.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 40 | **0**, each keeping a twelve-line delegate |
| Lines the body carried | 2,067 | **468** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **43** (`revoke_one` x 40, `abandoning_of` x 3) |
| The ladder's whole carry | 131,077 | **129,478** |
| Carry ceiling | 131,200 | **129,600** |
| Lines on disk, all `caravan/*.rye` | 370,181 | **368,641** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** The family gave back 2,067 and the new twelve-line delegate family carries 468, so the carry falls 1,599 -- which is what the meter measured. On disk the same closure holds independently: forty rungs each shed forty-one lines for 1,640, the harness took 100, and 368,641 is what `wc` reports. **The forty-three widenings split no family, and measuring why is more interesting than the number.** Fold O's own gap came from splits -- a declaration line belongs to the body it opens, so making a symbol public in some holders and not others cuts one family in two. Here neither widened symbol could split. `revoke_one` stands in forty-four rungs as **five** families already, the folded forty sharing one body and the four elders each writing their own, so the whole family moved together. And `abandoning_of` stands in forty rungs as **forty** distinct bodies carrying nothing at all, since each names its own rung's report type -- widening three of them changed no family's membership. A widening is free of splits exactly when it moves a whole family or moves nothing, and this one did both.

## Fold R -- `weigh_the_term`, and the absentee a single accessor brought home

The printed queue named `weigh_the_term` at **thirty rungs by sixty-nine lines, 2,001 carried**, and hashing every body by that name on the ladder found a **thirty-first**. Fold O taught that a queue is a lead rather than a verdict; fold Q found five absentees a shape born later had dated out of the family. This lap found the other kind -- an absentee that could simply be invited in.

`weigh_the_term` is the run's answer to the question an objection leaves open: how long does a recorded disagreement stand? A perpetual term never asks, so nothing expires and nothing is counted. Every other term reaches the reader's own published box, puts the question there, reads it back before weighing a word of the answer, and refuses a second hand that names any other quarrel. Past that refusal a hand at all is the objection raised again, and silence is the objection let go -- called so only where somebody was actually asked.

**The thirty-first rung differed in six places, and every one of them was the same difference.** `lapse.rye` *owns* the lapsing tier, so it reached its own report directly where all thirty rungs above reach it through `lapsing_of`.

| Rung | How it reaches the report |
|---|---|
| [`lapse.rye`](lapse.rye) | `report_out.unbounded`, `.asked`, `.renewed`, `.lapsed` -- its own tier, reached directly |
| the thirty above | `lapsing_of(report_out).unbounded`, and the same three beside it |

A rung that owns a tier can name the reach anyway. Three lines of identity accessor -- `pub fn lapsing_of(report_out: *Report) *Report { return report_out; }` -- and its sixty-nine folded with the other thirty. Fold M learned this on `recant.rye` and fold J on the staircase, and it holds here for the third time. **So the reading to make about an absentee is which kind it is:** one dated by a shape born after it, which stays home named, or one a single accessor brings home.

**The fold cost twenty-two widenings, and fourteen of its sixteen symbols were already paid for.** Every helper this body names -- `escort_written`, `dispute_recorded`, `objection_unbounded`, `asked_in`, `address_published`, `ask_again`, `asked_of`, `renewed_by`, `renews`, `renewed_in`, `lapsed_in`, `unasked_lapse`, `lapse_refusal`, `lapse_note` -- along with `max_address_len` and the four types stood public in all thirty-one rungs already, widened by the folds before it. **A fold pays its successors**, and fold P's lesson reads truer each lap. Only `lapsing_of` needed widening, in the twenty-two rungs that still held it private.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 31 | **0**, each keeping a three-line delegate |
| Lines the body carried | 2,001 | **90** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **22** (`lapsing_of` x 22) |
| The ladder's whole carry | 129,478 | **127,567** |
| Carry ceiling | 129,600 | **127,600** |
| Lines on disk, tracked `caravan/*.rye` | 368,473 | **366,543** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**Both arithmetics close with no remainder.** The family gave back 2,001 -- twenty-nine copies of sixty-nine lines, since `lapse.rye` was unique and carried nothing -- and the new three-line delegate family carries 90 across thirty copies, so the carry falls 1,911, which is what the meter measured. On disk the same closure holds independently: thirty rungs each shed sixty-six lines, `lapse.rye` shed sixty-six and gained thirteen for its accessor, the harness took a hundred and three, and 1,930 is the fall `wc` reports over the tracked rungs.

**The twenty-two widenings split no family and handed back nothing.** Fold Q measured why a widening can be free; this one is free for the simpler of the two reasons. Every one of the thirty `lapsing_of` bodies is a **distinct text**, since each names its own rung's report type, so the family carried zero lines before the widening and carries zero after. A widening that moves a whole family or moves nothing cannot split one, and thirty singletons are thirty nothings.

## Fold S -- `record_the_dispute`, and the second tier-owner an accessor brought home

The printed queue named `record_the_dispute` at **thirty-two rungs by sixty-one lines, 1,891 carried**, and hashing every body by that name on the ladder found a **thirty-third**. That is three consecutive laps where reading past the queue paid, and this one paid the same way fold R did -- an absentee that could simply be invited in.

`record_the_dispute` is the run's answer to what a reader's objection earns. A run that carried nothing owes nobody a record, and says so by weighing nothing rather than by inventing a quarrel. A reader who agreed is left exactly as the rung below leaves them, agreed with and undisputed. Only a reader who answered in a word this plan cannot accept is written down -- and under `.settled` even that one is set aside, which is precisely the number this rung moves. Its hard half refuses a pair naming one reading twice: that is agreement wearing a quarrel's clothes, and writing it down would manufacture a disagreement nobody ever had.

**The thirty-third rung differed in five places, and every one of them was the same difference.** `dispute.rye` *owns* the disputing tier, so it reached its own report directly where all thirty-two rungs above reach it through `disputing_of`.

| Rung | How it reaches the report |
|---|---|
| [`dispute.rye`](dispute.rye) | `report_out.unrecorded` and `.recorded` -- its own tier, reached directly |
| the thirty-two above | `disputing_of(report_out).unrecorded`, and `.recorded` beside it |

Three lines of identity accessor -- `pub fn disputing_of(report_out: *Report) *Report { return report_out; }` -- and its sixty-one folded with the other thirty-two. **Fold R read this shape for the first time one lap ago, and fold S found it again immediately.** So a tier-owner standing outside its own family is no longer a surprise to stumble on; it is a shape to look for, every time a family is hashed before it is folded.

**The fold cost forty-nine widenings, and fourteen of its sixteen symbols were already paid for.** Every helper this body names -- `address_published`, `answered_by`, `delivered_to`, `hand_agrees`, `answered_unrecorded`, `recorded_in`, `unwritten_in`, `unheard_record`, `dispute_refusal`, `founded`, `dispute_note` -- along with `max_address_len` and the types stood public in all thirty-three rungs already, widened by the folds before it. Only the two accessors needed widening: `couriering_of` in twenty-five rungs and `disputing_of` in twenty-four. Every one of their bodies is a distinct text, since each reaches a different depth, so the widening split no family and handed back no carry.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 33 | **0**, each keeping an eight-line delegate |
| Lines the body carried | 1,891 | **256** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **49** (`couriering_of` x 25, `disputing_of` x 24) |
| The ladder's whole carry | 127,567 | **125,932** |
| Carry ceiling | 127,600 | **126,000** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**Both arithmetics close with no remainder.** The family gave back 1,891 -- thirty-one copies of sixty-one lines, since `dispute.rye` stood distinct and carried nothing -- and the new eight-line delegate family carries 256 across thirty-two copies, so the carry falls 1,635, which is what the meter measured. On disk the same closure holds independently: thirty-two rungs each shed fifty-three lines for 1,696, `dispute.rye` shed fifty-three and gained ten for its accessor, `ladder_checks.rye` took ninety-one, and 1,648 is the net fall over the real rung files.

A naive count of tracked lines reads 366,543 -> 365,063, a fall of 1,480, and the 168-line gap has a name rather than a mystery: `caravan/parse_int.rye` and `caravan/tally_copy.rye` are tracked symlinks whose target text `wc` follows and `git show` does not. Naming the artifact is what keeps a discrepancy from becoming a drift.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold T -- `graft_promised_reach`, and the fold that had to widen a family whole

The printed queue named `graft_promised_reach` at **forty-two rungs by forty-three lines, 1,763 carried**, and hashing every body by that name found exactly **forty-two** -- one text, no absentee, no tier-owner standing apart. Three consecutive laps had each turned up a rung the queue's line count could not see, and this lap turned up none. That is the same discipline reporting a clean family rather than a discipline that quietly stopped paying: the hash runs whether or not it finds anything.

`graft_promised_reach` is the body that takes a promise off the wire and turns it into reach a dependent actually holds. A promise is a number and nothing more; the reach itself arrives as words the dependent must read, name, hold, and then stand up against its own store before any of it counts. So the body waits inside a bound rather than forever, reads only what has actually been given, grants only what it does not already hold, and proves each arc it took stands at the count the task names. A word that cannot be read back into a capability ends the graft by name rather than carrying quietly less than it claims.

It is also the body that the arc's second-largest fold already calls. `stand_taking_and_returning_reach` lifted into the harness at fold L and reaches `rung.graft_promised_reach` on its sixth line; this lap the callee joined the caller there.

**The fold cost 285 widenings, and the reason is the whole lesson of the lap.** Six symbols needed widening -- `read_count`, `read_words`, `word_at`, `already_holds`, and the two imports `queue_store` and `serve`. Four of those six are fold families in their own right, standing in **forty-five** rungs apiece where this body stands in forty-two. The carry meter reads a body by its exact text, so widening the forty-two and leaving three private would have split each of those families in two, and handed a later fold a family it could no longer lift whole.

| Symbol | Stands in | Widened in | Why |
|---|---|---|---|
| `word_at` | 45 rungs, one text | **45** | a whole family, kept whole |
| `read_count` | 45 rungs, two texts | **45** | both sub-families kept whole |
| `read_words` | 45 rungs, two texts | **45** | the same shape |
| `already_holds` | 45 rungs, two texts | **45** | the same shape |
| `queue_store` | 47 rungs | **47** | an import, carrying no family |
| `serve` | 58 rungs | **58** | an import, carrying no family |

**A fold pays its successors, and it pays them best by never handing them a split.** Fold P found five of five symbols already public and cost nothing at all, because fold O had widened exactly those five one lap earlier. This lap is that ledger read from the other side: the cheapest thing fold T can do for the folds after it is to widen past its own family's edge, where the symbol's family is wider than the body's.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 42 | **0**, each keeping an eleven-line delegate |
| Lines the body carried | 1,763 | **451** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **285** across six symbols |
| The ladder's whole carry | 125,932 | **124,620** |
| Carry ceiling | 126,000 | **124,700** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**Both arithmetics close with no remainder.** The family gave back 1,763 -- forty-one copies of forty-three lines, the forty-second being the distinct text itself -- and the new eleven-line delegate family carries 451 across those same forty-one copies, so the carry falls 1,312, which is what the meter measured. On disk the closure holds independently: forty-two rungs each shed thirty-two lines for 1,344, `ladder_checks.rye` took seventy-four, and **1,270** is the net fall over the real rung files. A naive count of tracked lines reads 1,102, and the 168-line gap keeps the name fold S gave it -- `caravan/parse_int.rye` and `caravan/tally_copy.rye` are tracked symlinks whose target text `wc` follows and `git show` does not.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold U -- `hear_the_reader`, and the absentee that stays home

The printed queue named `hear_the_reader` at **thirty-three rungs by fifty-four lines, 1,728 carried**, second behind `provision_notes`, and it was the better crux for the same reason the last four laps chose the wider family: `provision_notes` at ninety-one lines stays the body most likely to reach a rung's own wire, and reaching the wire is what keeps a body home.

Hashing every body by that name found **thirty-four**, and the thirty-fourth is the finding. `caravan/hear.rye` owns the hearing tier, and its body stands at forty lines against fifty-four -- yet no accessor brings this one home. Fold R named two kinds of absentee, and this is the **first**: a body genuinely dated by a shape born after it. Where every rung above records a disagreeing hand as a non-agreement and carries on, `hear.rye` ends the run on it with `error.HearMisheard`. Two texts, two meanings, one name. The elder stays home, named in the harness for what it is, rather than folded into a shape it predates.

`hear_the_reader` is the body that reads back what the reader answered and says whether the plan ever listened. It reads the letter it carried out of the reader's own box, then reads that reader's hand out of the box beside it -- the wire before the memory, because a plan that heard its reader agree from its own memory has agreed with itself. A run that carried nothing owes nobody a hearing. A reader who answered in a word this plan cannot accept leaves the hearing exactly where it stood, and that is a record rather than a refusal.

**The fold cost one widened symbol, and it split nothing.** Every symbol the body reaches -- `couriering_of`, `max_address_len`, `address_published`, `answered_by`, `delivered_to`, `hand_agrees`, `carried_unheard`, `heard_in`, `unheard_in`, `unanswered_reach`, `hear_refusal`, and the four types `Receipt`, `Report`, `RunError`, `NoteError` -- already stood public in all thirty-three, the interest paid by folds before it. Only `hearing_of` was private, and fold T's lesson said to hash that symbol's own family before widening it. Its thirty-three copies are each a **different** text, three lines naming a different nesting depth apiece, so it is no fold family at all: widening it costs its thirty-three and hands no successor a split.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 33 | **0**, each keeping a three-line delegate |
| Lines the body carried | 1,728 | **96** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **33**, one accessor, no family split |
| Bodies standing apart, kept home | -- | **1**, `hear.rye`, named in the harness |
| The ladder's whole carry | 124,620 | **122,988** |
| Carry ceiling | 124,700 | **123,100** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** The family gave back 1,728 -- thirty-two copies of fifty-four lines, the thirty-third being the distinct text itself -- and the new three-line delegate family carries 96 across those same thirty-two copies, so the carry falls **1,632**, which is exactly what the meter measured. Bodies climb 18,064 to 18,065 and distinct texts 7,867 to 7,868, the one new body being the harness's own.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold V -- `settle_the_plan`, the fossil record, and a fold that cost nothing

The printed queue named `settle_the_plan` at **thirty-six rungs by forty-seven lines, 1,645 carried**, second behind `provision_notes`, and the last two laps had already named it the better crux for the reason five laps running have chosen the wider family: `provision_notes` at ninety-one lines stays the body most likely to reach a rung's own wire, and reaching the wire is what keeps a body home.

`settle_the_plan` weighs what a plan came to, publishes the verdict and the settlement, and reads both back. The reckoning waits until the last dependent has been reaped and every abandonment already answered for, since a verdict taken any earlier would judge work that may yet be carried. Every claim it makes it first writes to the wire and then reads back, because a settlement a run believes from its own memory has agreed with itself. Four refusals stand in it, each naming a story the wire cannot support: a loss called carried while an arc stands unserved, a plan called borne that re-ran what its author asked it to bear, a judgment weighed in private, and a recantation never spoken aloud.

**Hashing the family first found three bodies standing apart, and they are not the same kind.** `caravan/recant.rye` owns the recanting tier and stood apart by exactly two lines, reaching its own report directly where every rung above reaches it through `recanting_of`. That is fold R's **second** kind of absentee, and this time the accessor that brings it home had already been born -- fold M widened `recanting_of` in this very file, five folds ago. Two words came home and the family became thirty-seven.

**Two more stand apart, and they stay home: they are the ladder's own fossil record.** `caravan/bear.rye` holds twenty-eight lines and `caravan/appraise.rye` thirty-five, against the folded body's forty-seven. `bear.rye` predates the appraisal check and the recantation checks alike; `appraise.rye` carries the appraisal and predates the recantation. Read together, the three depths are a staircase naming the two laps on which settling learned to weigh an appraisal and then a recantation -- fold Q's finding, arriving again on a different body.

**An absentee can wear both kinds at once, and the first kind wins.** Each of these two elders also reaches its own report directly, exactly as `recant.rye` did -- `report_out.bore` in one, `report_out.weighed` in the other -- so each carries the second kind's signature too. Yet no accessor can give a body back a check it never had. Where the two kinds meet in one body, the dating decides, and the elder stays home named.

**The fold cost nothing at all.** All thirteen symbols the body reaches -- `below_of`, `unserved_after`, `settled_verdict`, `verdict_note`, `verdict_published`, `settlement_of`, `bearing_of`, `settlement_note`, `settlement_published`, `appraising_of`, `appraisal_published`, `recanting_of`, `recant_published` -- along with `max_queue_len` and the three types `Report`, `RunError`, `NoteError`, already stood public in every one of the thirty-seven. This is the arc's second zero-widening fold after fold P, and it says the same thing from the other side: **a fold's price is set by what its predecessors already made public**, rather than by how many rungs it lifts out of.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 36, and a thirty-seventh two lines apart | **0**, each keeping an eight-line delegate |
| Lines the body carried | 1,645 | **288** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **0**, every symbol already public |
| Absentees an accessor brought home | -- | **1**, `recant.rye`, for two words |
| Bodies standing apart, kept home | -- | **2**, `bear.rye` and `appraise.rye`, named in the harness |
| The ladder's whole carry | 122,988 | **121,631** |
| Carry ceiling | 123,100 | **121,700** |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder, and it names what bringing an absentee home costs.** Thirty-five copies of forty-seven gave back 1,645 as the queue promised; `recant.rye` joining first *added* forty-seven to the carry, making thirty-six copies at 1,692; and the thirty-six eight-line delegates carry 288. So the fall is 1,692 less 288, less the forty-seven that came home -- **1,357**, exactly what the meter measured. **The accessor's two words paid for themselves thirty-six times over.** Bodies climb 18,065 to 18,066 and copies 10,197 to 10,198, the one new body being the harness's own; distinct texts hold at 7,868, since the body the harness now owns is a text the ladder already had.

On disk the thirty-seven rung files shed 1,480 lines for 37 of delegate, and `ladder_checks.rye` grew 88 -- a net of **1,355 lines** off the tracked tree.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold W -- `provision_notes`, the largest carry on the ladder, and a fossil record thirteen laps deep

The printed queue had named `provision_notes` at the top for five consecutive laps -- **twenty-four rungs by ninety-one lines, 2,093 carried**, the largest single carry the arc has ever measured -- and five consecutive laps had reached past it for the family standing second. The reason was always the same one, and it was a good one: at ninety-one lines this is the body most likely to reach a rung's own wire from end to end, and reaching the wire is what keeps a body home. This lap it was the crux by every reading, and it folded.

`provision_notes` seats one set of notes per declared domain, all standing at nothing, so a word a dependent finds at its first breath was left by this run's own supervisor rather than by the last. **The judgment it carries is what clears and what stays.** A run clears every note that answers for the run that wrote it -- the verdict, the bearing, the settlement, the recantation, the amendment, the disagreement, the plea. A run leaves standing every note that belongs to somebody else: the appraisal a run did not make, the reading a reader already holds, the position a person pressed, and the age that position has stood. Six invariants close the body by asking the wire whether each cleared note is genuinely gone, since a provisioning that believed itself would have agreed with itself.

**It reaches the wire, and option B is exactly the answer to that.** The body opens the rung's own note directory and writes under the rung's own plan name, both reached through the rung handed in, so one text provisions whichever rung called it. The wire stays the rung's; the words become the ladder's. That is the whole promise the harness made when it was built, arriving here on the body that most needed it.

**Hashing the family found forty-seven rungs where the queue named twenty-four, and the twenty-three are a fossil record thirteen laps deep.** Every elder is a strict truncation of the canonical -- shorter by whole notes and whole invariants, never by a different reach -- and they stand at thirteen distinct depths:

| Lines | Rungs | What the ladder had learned by then |
|---|---|---|
| 14 | `entrust` - `taper` | a pair of notes per domain, and nothing said of the plan |
| 16 | `confer` | the conferral notes |
| 19 | `revoke` | revocation beside conferral |
| 24 | `reclaim` | reclaiming, and the words a dependent is handed |
| 26 | `abandon` | abandonment counted |
| 31 | `mend` - `reckon` | the plan's own verdict, cleared with the rest |
| 38 | `appraise` - `bear` | the bearing and the settlement beside the verdict |
| 46 | `recant` | the recantation clears, the appraisal stays |
| 56 | `amend` - `courier` - `hear` | the amendment clears, the reading stays |
| 63 | `abide` - `dispute` - `lapse` - `repose` - `tidings` | the recorded disagreement clears |
| 70 | `appeal` | the published plea clears |
| 78 | `endure` | the standing position stays, and the regard clears with the findings |
| 86 | `heed` - `relent` | the age stays beside the position it counts |
| **91** | **the twenty-four** | every invariant asked of the wire |

Read down that column and it is the arc's own memory of which note it had learned to provision on which lap, and of the judgment each new note arrived carrying. **None of them can be brought home, and the reason is fold V's rule read once more: no accessor gives a body back a check it never had.** They are fold R's first kind, twenty-three times over.

**So the reading a large absentee set asks for is its shape.** One depth means one shape born later; thirteen depths mean thirteen laps of growth standing on disk in order. Both stay home, and for the same reason -- yet only the second tells you the family's whole history at a glance, which is worth more than the lines it costs.

**The fold cost thirty widenings, and it split nothing.** Nine of the ten symbols the body reaches -- `note_dir`, `plan_name`, and the six accessors `verdict_published`, `settlement_published`, `amend_published`, `dispute_recorded`, `appeal_published`, `regard_published`, along with the `NoteError` type -- already stood public in all twenty-four, interest paid by the folds before this one. Only `seat_note` needed widening, and fold T's rule governed how: the private text stood in **twenty-six** rungs where this body stands in twenty-four, so widening only the twenty-four would have split that family and handed a later fold something it could no longer lift whole. All thirty private `seat_note` bodies were widened instead -- the twenty-six-rung text and two small two-rung texts beside it -- which **merged** the widened twenty-six with the seventeen already public into a single forty-three-rung family. The merge costs fifteen carried lines today and hands the next fold one family rather than two.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 24 | **0**, each keeping a three-line delegate |
| Lines the body carried | 2,093 | **69** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **30**, one family widened whole |
| Bodies standing apart, kept home | -- | **23**, at thirteen distinct depths |
| The ladder's whole carry | 121,631 | **119,622** |
| Carry ceiling | 121,700 | **119,700** |
| Carrying families | 708 | **707**, the `seat_note` merge |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** Twenty-three copies of ninety-one gave back 2,093 exactly as the queue promised; the twenty-four three-line delegates carry 69; and the `seat_note` merge added 15 by turning a distinct text into a copy. So the fall is 2,093 less 69 less 15 -- **2,009**, exactly what the meter measured. Bodies climb 18,066 to 18,067 and copies 10,198 to 10,199, the one new body being the harness's own; distinct texts hold at 7,868, since the harness's text is one the ladder already had.

On disk the twenty-four rung files shed 2,112 lines for 72 of delegate, and `ladder_checks.rye` grew 114 -- a net of **1,998 lines** off the tracked tree.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold X -- `release_the_standing`, and the family that folded whole

The queue named **twenty-four rungs by seventy-one lines, 1,633 carried**, and hashing every body by that name found a **twenty-fifth**. That is the second kind of absentee, read now for the fourth time: `relent.rye` **owns** the relenting tier, so it reached its own report directly where all twenty-four rungs above reach it through `relent_of`. Ten lines differed out of seventy-one, and every one of them was the same difference. Three lines of identity accessor, and the family folded **whole at twenty-five, with no elder left home** -- the first fold of this arc to leave nothing standing apart.

`release_the_standing` is the run's answer to what a person's pressed quarrel is worth. A quarrel is a living statement that the matter is not over, so the body reads the wire before it believes anything: the note that stands, the endurance that would have written it, the box its holder published, and the hand that box actually carries. **A holding run clears nothing, however plainly its holder moved on. Silence is never read as a withdrawal. A position whose holder cannot be reached stands rightly until they can be.** Only a reader who actually let go gets their position taken down.

**The wire before the memory, at both ends.** The note is read back after the release, and only a wire reading clear lets the report say the position came down -- because a note still naming a quarrel after its holder let it go hands every future run an objection nobody holds. The rung refuses that by name with `error.RelentMisrecorded` rather than trusting its own release.

**The fold cost sixteen widenings and split nothing.** Thirteen of the fourteen symbols the body reaches -- `position_standing`, `endures`, `address_published`, `pressed_by`, `withdrawn_still_standing`, `withdrawn_in`, `standing_in`, `withdraws`, `unwithdrawn_clearing`, `relent_refusal`, `release_standing`, `note_cleared`, and the `max_address_len` bound, with `Relent`, `Report`, `RunError`, and `NoteError` beside them -- already stood public in all twenty-five, interest paid by the folds before this one. Only `relent_of` needed it, and its whole family is exactly the twenty-four rungs this body stands in, so fold T's rule had nothing left to protect: widening the sixteen private bodies covered the family entire, and each of the twenty-four is a distinct text naming its own nesting depth, so the widening handed back nothing and split nothing.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 25 | **0**, each keeping a three-line delegate |
| Lines the body carried | 1,633 | **72** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **16**, plus one accessor born |
| Bodies standing apart, kept home | -- | **0**, the arc's first whole family |
| The ladder's whole carry | 119,622 | **118,061** |
| Carry ceiling | 119,700 | **118,100** |
| Carrying families | 707 | **707**, unmoved |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** Twenty-four copies of seventy-one gave back 1,633 exactly as the queue promised; `relent.rye` joining first *added* seventy-one, making twenty-five copies at 1,704; and the twenty-five three-line delegates carry 72. So the fall is 1,704 less 72 less the seventy-one that came home -- **1,561**, exactly what the meter measured. Bodies climb 18,067 to 18,069 and copies 10,199 to 10,200; distinct texts climb 7,868 to 7,869, the newborn identity accessor being a text the ladder did not have.

On disk the twenty-five rung files and the harness together shed **1,741 lines for 149 added** -- a net of **1,592 lines** off the tracked tree.

**What this fold adds to the reading of an absentee.** Folds R, S, and V each brought one second-kind absentee home and left first-kind elders standing; fold W left twenty-three. This one left none, and the reason is measurable rather than remembered: `release_the_standing` exists **only** in the relenting tier and above. Every rung below it -- `heed`, `endure`, `appeal`, `repose` among them -- carries no body by that name at all, so there was never a shallower version to date this one out of its family. **A family with no fossil record is a family born whole**, arriving after the vocabulary beneath it had already settled, and the hash says so at a glance without anybody having to remember which lap wrote what.

The choir stands **105 GREEN**, TAME bans clean, width-check clean.

## Fold Y -- `stand_the_mark`, and the second family to fold whole

The queue named **twenty-nine rungs by fifty-eight lines, 1,624 carried**, and hashing every body by that name found a **thirtieth**. That is the second kind of absentee, read now for the fifth time: `repose.rye` **owns** the reposing tier, so it reached its own report directly where all twenty-nine rungs above reach it through `reposing_of`. Seven lines differed out of fifty-eight, and every one of them was that same difference. Three lines of identity accessor, and the family folded **whole at thirty, with no elder left home** -- the second fold of this arc to leave nothing standing apart, and the first time the arc has done it twice running.

`stand_the_mark` carries the term's own answer into the mark an operator actually opens. The wire before the memory, one tier further out than the term below it: the run reads its own mark out of the note an operator would open, reads the term out of the note that decided it, writes both into that same mark, and reads the mark back before the report believes a word of it. **A run that escorted nothing has no mark to speak for. An objection nobody asked about has no standing to carry.** Each is a silence no standing can fill, and each says so by weighing nothing rather than by inventing a finding. The number this rung moves is the mark that names an objection and never says whether anybody still holds it -- read live by every operator, however long ago the quarrel was let go.

**The fold cost twenty-one widenings and split nothing.** Fifteen of the sixteen symbols the body reaches -- `escort_written`, `term_written`, `mark_unstanding`, `read_in`, `bare_in`, `unweighed_stand`, `repose_refusal`, `stands_as`, `agrees`, `repose_note`, and `standing_written`, with `Mark`, `Report`, `RunError`, and `NoteError` beside them -- already stood public in all thirty, interest paid by the folds before this one. Only `reposing_of` needed it, and its whole family is exactly the twenty-nine rungs above the tier owner, so fold T's rule had nothing left to protect: widening the twenty-one private bodies covered the family entire, and each of the twenty-nine is a distinct text naming its own nesting depth, so the widening handed back nothing and split nothing.

| Row | Before | After |
|---|---|---|
| Rungs holding the body | 30 | **0**, each keeping a three-line delegate |
| Lines the body carried | 1,624 | **87** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **21**, plus one accessor born |
| Bodies standing apart, kept home | -- | **0**, the arc's second whole family |
| The ladder's whole carry | 118,061 | **116,524** |
| Carry ceiling | 118,100 | **116,600** |
| Carrying families | 707 | **707**, unmoved |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder, and it closes the same from either end.** Read forward: twenty-eight copies of fifty-eight gave back 1,624 exactly as the queue promised, and the thirty three-line delegates carry 87, so the fall is 1,624 less 87 -- **1,537**, exactly what the meter measured. Read through the normalization: `repose.rye` joining first made thirty copies at 1,682, which the fold gave back whole, and 1,682 less 87 less the fifty-eight that came home is the same 1,537. The tier owner's own body was never carried and never counted, which is why the two readings agree. Bodies climb 18,069 to 18,071 and distinct texts 7,869 to 7,870, the newborn identity accessor and the harness body being texts the ladder did not have.

On disk the thirty rung files and the harness together shed **1,701 lines for 148 added** -- a net of **1,553 lines** off the tracked tree. The diff is smaller than thirty times fifty-eight because a delegate keeps the body's own signature line and its closing brace, so each rung reads as fifty-six lines out and one in, with the twenty-one widenings making up the rest exactly.

**What this fold adds to the reading of a whole family.** Fold X met the first family with no fossil record and drew the rule from it: a body that arrived after the vocabulary beneath it had settled has no shallower version to date it out of its family. `stand_the_mark` says the same thing from the other side. It exists only in the reposing tier and above -- `heed`, `endure`, `appeal`, and `relent` carry no body by that name -- and the hash found its whole family at a glance, with the tier owner standing apart by exactly the difference owning a tier makes. **A rule read once is a reading; a rule that predicts the next lap is a rule.** This fold is that second reading, and it came in on the discipline rather than on a surprise.


## Fold Z -- the reap cluster, and the split that was only a word

The queue named **thirty-seven rungs by forty-four lines, 1,584 carried**, and hashing every `reap_oldest` on the ladder found **forty**. Three of them -- `appraise.rye`, `bear.rye`, and `mend.rye` -- held the body byte for byte and differed by the single word `pub`. That is the **third kind of absentee**, and it is the gentlest one the arc has met: no shallower ancestor, no tier owner reaching its own report directly, simply a family that a meter keyed on text read as two because one word of visibility stood between them.

Then the pub-ness audit turned the lap into something larger. `reap_oldest` reaches two private helpers, `reclaim_one` and `abandon_one`, so the fold could not happen without widening them -- and hashing *those* found each standing byte-identical in **the same forty rungs**, over the same three elder outsiders, `reclaim.rye`, `reckon.rye`, and `abandon.rye`. One body, two helpers, one cohort, one shared fossil record. **The widening a fold needs names the next fold**, because a body and the helpers it reaches enter the ladder together and settle together; the reach graph *is* the queue, read one step ahead of the meter.

So this lap lifted the cluster whole rather than the family alone. `reap_oldest` waits on the eldest dependent, takes back what it was conferred, answers for the work that conferral never bought, and closes the table over its slot. `reclaim_one` is the smallest of the three and the one the other two are built over. `abandon_one` names lost work only where there is lost work to name, writes it where an operator would read it, and reads it straight back off the wire before believing it. An heir found at home refuses the whole reaping rather than reporting around it, since a dependent whose children outlive it was never reaped at all.

**The fold cost eighty-three widenings and split nothing.** Every symbol the three bodies reach -- `Table`, `Answer`, `Report`, `RunError`, `NoteError`, `max_queue_len`, `max_in_flight`, `inherited_by`, `abandoning_of`, `run_of`, `read_count`, `reclaim_refusal`, `reclaim_notes`, `abandon_refusal`, `abandoned_reach`, `abandon_note`, and `abandoned_by` -- already stood public in all forty, interest paid by the folds before this one. Only the two helpers needed widening, at forty each, with three `reap_oldest` declarations joining them; and since each helper's family is exactly this cohort, fold T's rule had nothing left to protect.

| Row | Before | After |
|---|---|---|
| Rungs holding `reap_oldest` | 40 | **0**, each keeping an eight-line delegate |
| Rungs holding `abandon_one` | 40 | **0**, each keeping a nine-line delegate |
| Rungs holding `reclaim_one` | 40 | **0**, each keeping an eight-line delegate |
| Lines the cluster carried | 3,310 | **975** -- the delegates are themselves copies |
| Widenings the fold cost | -- | **83**, no accessor needed |
| The ladder's whole carry | 116,524 | **114,189** |
| Carry ceiling | 116,600 | **114,200** |
| Carrying families | 707 | **706** -- four families in, three out |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** Four families went in: `reap_oldest` at thirty-seven copies of forty-four (1,584) and at three more (88), `abandon_one` at thirty-nine copies of twenty-six (1,014), `reclaim_one` at thirty-nine copies of sixteen (624) -- **3,310** together. Three families came out, one per delegate, at thirty-nine copies of eight, nine, and eight -- **975**. The fall is **2,335**, exactly what the meter measured. Bodies climb 18,071 to 18,074 and distinct texts 7,870 to 7,872: three harness bodies and three delegate texts born, four old texts retired. On disk the forty rung files, the harness, and the meter shed **2,653 lines for 335 added** -- a net of **2,318** off the tracked tree.

**Why the family count fell for the first time in this arc.** Every fold before it traded one carrying family for another and left the count unmoved. This one traded four for three, because the visibility split was healed by the same act that lifted the body: forty delegates, all public, all one text. A meter that counts what it can see was seeing a difference the ladder never had, and the fold gave it back the truth rather than an exception. **The clearest way to fix a measurement is to remove the thing that made it wrong.**


## Fold AA -- `post_the_amendment`, and the tier owner that needed nothing built

The queue named **thirty-five rungs by forty-five lines, 1,530 carried**, and hashing every `post_the_amendment` on the ladder found **thirty-six**. The thirty-sixth is `amend.rye`, and it differs in exactly the way this arc has learned to expect: where the cohort reaches its report through `amending_of(report_out)`, the tier owner reaches `report_out` directly, because the amending report *is* its report and it has no accessor at all. That is the **second kind of absentee**, met again and recognized on sight.

What made this the cheapest fold the arc has taken is what the pub-ness audit found. Fifteen symbols the body reaches -- `settlement_published`, `reading_published`, `superseded_unposted`, `amended_in`, `confirmed_in`, `unread_reach`, `amend_refusal`, `amend_note`, `seat_note`, `plan_name`, `amend_published`, and the four types `Notice`, `Report`, `RunError`, and `NoteError` -- already stood public in all thirty-five, interest paid in full by the folds before this one. **One symbol needed widening: `amending_of`, private in twenty-seven rungs and already public in eight.** Hashing that accessor across the cohort found thirty-five distinct texts, one per rung, each a different depth of `.inner` -- so it is an identity accessor by construction and folds nowhere, exactly as fold R's rule predicts. The reach graph named the price a lap ahead, and the price was one word.

What the body does is the arc's correspondence half, stated once. A run measures the readings its own settlement contradicts, weighed against what it settled rather than against what any notice asked for, so an elder reading is counted rather than refused. It refuses by name where an amendment would reach a reading nobody took. It writes the note, clears the reading off the wire in the same breath it is answered, and then reads the posting back out of the place an operator would open before letting its report believe it -- the wire before the memory, once more.

| Row | Before | After |
|---|---|---|
| Rungs holding `post_the_amendment` | 35 | **0**, each keeping a three-line delegate |
| Lines the family carried | 1,530 | **102** -- the delegate is itself a copy |
| Widenings the fold cost | -- | **27**, one word, no accessor born |
| The ladder's whole carry | 114,189 | **112,761** |
| Carry ceiling | 114,200 | **112,800** |
| Carrying families | 706 | **706**, one family out and one back in |
| Byte-identical check carry, beside it | 47 | **47**, unmoved |
| Orchestration spine carry, beside it | 0 | **0**, unmoved |

**The arithmetic closes with no remainder.** Thirty-four copies of forty-five went in at **1,530**; thirty-four copies of three came back out at **102**; the fall is **1,428**, exactly what the meter measured. Bodies climb 18,074 to 18,075 and distinct texts 7,872 to 7,873 -- one harness body born, one delegate text born, one old text retired. On disk thirty-five rung files, the harness, and the meter shed **1,540 lines for 133 added**, a net of **1,407** off the tracked tree.

**The lesson this lap adds is about price rather than shape.** Twenty-six folds in, a family of thirty-five reached fifteen symbols and found every one of them already public. A fold pays its widenings once, and every fold after it inherits them; the ladder is now mostly paid, so the folds ahead are mostly free. What still costs is the reading -- hashing the family, auditing the reach, naming the absentee -- and that reading has never once been wasted.


## Fold AB -- the dependent cluster, and the absentee that stands below the line

The queue named **forty-three rungs by thirty-five lines, 1,470 carried**, and hashing every `run_dependent` on the ladder found sixty-seven bodies at eleven different lengths. Forty-three stand byte for byte alike; the other twenty-four are the arc's own memory of the walk growing. Fold Z's rule ran first this time, before scope was chosen: read the reach closure, since the helpers a body reaches are often its own cohort and fold with it for the price of one audit. They were, and they did.

`run_dependent` reaches six symbols on its rung. Three already stood public in all forty-three -- `fixed_argv_words`, `inherited`, and `outcome_name`. Of the three that did not, one was already a delegate from fold L (`stand_taking_and_returning_reach`, needing only the word `pub`), and **two were real bodies that fold with it**: `inherited_at_first_breath`, standing byte for byte in exactly the same forty-three rungs at thirty lines apiece, and `slot_from_argv`, standing byte for byte in **fifty-nine**. So one reading bought three folds.

**The fifty-nine named a third kind of absentee.** The sixteen rungs holding `slot_from_argv` outside the cohort are precisely the rungs the harness itself imports -- `cohort`, `cycle`, `confer`, `entrust`, `gap`, and the rest beneath the fold line. Folding them would have a rung the harness reaches for reach back through the harness, which inverts the ladder rather than lifting it. So the fold line is not the widest family; it is the widest family standing **above** the harness. The arc has now met an absentee dated by a shape born later, an absentee a single accessor brings home, and an absentee that stays home because of where it stands in the import order.

What the body does is the whole dependent half of the arc, stated once. A dependent reads the plan it was handed, defers to the rung below for any verb this rung does not own, refuses an unreadable or over-wide capability count by name, rebuilds its own hands from the words on its argv line, counts the reach it inherited at its first breath **before** touching those hands, answers for that finding on the wire, and only then stands.

| Row | Before | After |
|---|---|---|
| Rungs holding `run_dependent` | 43 | **0**, each keeping a three-line delegate |
| Rungs holding `inherited_at_first_breath` | 43 | **0**, each keeping a seven-line delegate |
| Rungs holding `slot_from_argv` above the line | 43 | **0**; the sixteen below it keep their body |
| Lines the three families carried | 3,600 | **771** |
| Widenings the fold cost | -- | **130**, one word each, no accessor born |
| The ladder's whole carry | 112,761 | **109,932** |
| Carry ceiling | 112,800 | **110,000** |
| Carrying families | 706 | **706** |

**The arithmetic closes with no remainder.** Out went 42x35, 42x30, and 58x15 -- 1,470 plus 1,260 plus 870, or **3,600**. Back came 42x3, 42x7, 42x3, and the sixteen rungs below the line at 15x15 -- 126 plus 294 plus 126 plus 225, or **771**. The fall is **2,829**, exactly what the meter measured, and the largest single fall this arc has taken.

**Carrying families held at 706 for a reason worth naming.** `slot_from_argv` split into two families, its delegates above the line and its bodies below -- one family gained. In the same act, widening `reachable_between` in `reclaim.rye` healed a two-rung private family into the forty-two-rung public one, leaving a singleton that carries nothing -- one family lost. Fold Z's split-by-the-word-`pub` recurred here and closed incidentally, which is what a paid ladder looks like.

**The lesson this lap adds is about the shape of a fold rather than its price.** A queue names one family; a reach graph names a cluster. Reading the closure first cost one audit and lifted three families in a single lap, and the same reading drew the line the fold must stop at. The widest family on the ladder was never the right unit of work -- the widest family a harness may honestly reach is.


## Fold AC -- the appeal cluster, and the reading that bought five folds

The queue named **twenty-seven rungs by fifty-six lines, 1,456 carried**, and hashing every `read_the_appeal` on the ladder found twenty-eight bodies at one length. Twenty-seven stand byte for byte alike; the twenty-eighth is `appeal.rye`, the tier owner, which reaches its own report directly where every rung above it reaches through `appeal_of`. Eight lines of the fifty-six differ, and all eight differ that one way -- the same shape fold AA met in `amend.rye`, so the owner stays home again.

Fold Z's rule ran first, before scope was chosen. `read_the_appeal` reaches thirteen symbols on its rung; twelve already stood public in all twenty-seven, and the thirteenth, `appeal_of`, cost one word in nineteen. That alone would have been a clean lap. **The reading gave more than that.** Four of the twelve are themselves whole carrying families standing above the harness line: `address_published` in **thirty-five** rungs, `told_of` in **twenty-nine**, `pressed_by` in **twenty-eight**, `appeal_published` in **twenty-eight** -- each byte for byte alike, each a wire reader that opens a note through its own rung's path builder and plan name. One reach reading bought five folds.

The fifth reached helper, `appeal_note`, stayed home for the plainest reason on this ladder: its body is three lines, and a delegate is three lines. A fold that trades a body for a body of equal length moves nothing, so the queue is right to leave it where it stands.

What the folded body does is the arc's whole appeal half, stated once. A run finds the address a reader published, counts what an unread answer costs, refuses by name where a position would be published that nobody voiced, writes the note, and reads it back out of the place an operator would open before the report believes a word of it.

| Row | Before | After |
|---|---|---|
| Rungs holding `read_the_appeal` | 27 | **0**, each keeping a three-line delegate |
| Rungs holding `address_published` | 35 | **0**, each keeping a three-line delegate |
| Rungs holding `told_of` | 29 | **0**, each keeping a three-line delegate |
| Rungs holding `pressed_by` | 28 | **0**, each keeping a three-line delegate |
| Rungs holding `appeal_published` | 28 | **0**, each keeping a three-line delegate |
| Lines the five families carried | 2,937 | **426** |
| Widenings the fold cost | -- | **111**, one word each, no accessor born |
| The ladder's whole carry | 109,932 | **107,395** |
| Carry ceiling | 110,000 | **107,500** |
| Carrying families | 706 | **707** |

**The arithmetic closes with no remainder, and the remainder it seemed to have was a fifth gift.** Out went 26x56, 34x13, 28x13, 27x13, and 27x12 -- 1,456 plus 442 plus 364 plus 351 plus 324, or **2,937**. Back came the same five cohorts at three lines apiece -- 78 plus 102 plus 84 plus 81 plus 81, or **426**. That is a fall of 2,511, and the meter read **2,537**. The extra twenty-six came from `note_path`: a forty-five-rung family that widening split into thirty-five public and ten private, and a family split into two smaller ones carries one fewer copy of itself. Fold Z's split-by-the-word-`pub` recurred a third time, and this time it paid rather than cost -- which is also why carrying families rose by one.

**The lesson this lap adds is that the reach closure has depth.** Fold AB read one hop out and found a cluster; this lap read one hop out and found four families larger than several the queue had been printing all along. A body's own reach is the cheapest survey on the ladder, because every symbol it names is already audited by the fold that lifts it. The next fold reads its closure first, as this one did -- and reads it for families, not merely for words to widen.


## Fold AD -- the quarrel cluster, and the fold that cost one word

The queue named **twenty-one rungs by seventy-two lines, 1,440 carried**, and hashing every `refer_the_quarrel` on the ladder found twenty-two bodies at one length. Twenty-one stand byte for byte alike; the twenty-second is `refer.rye`, the tier owner, which reaches its own report directly where every rung above it reaches through `refer_of`. Nine lines of the seventy-two differ, and all nine differ that one way -- the shape fold AA met in `amend.rye` and fold AC met in `appeal.rye`. Three laps, three tier owners, one rule: the owner stays home.

Fold Z's rule ran first, before scope was chosen, and this lap it reported the plainest number the arc has seen. `refer_the_quarrel` reaches **eighteen** symbols on its rung, and **all eighteen already stood public in all twenty-one**. The main fold cost nothing at all -- no widening, no accessor, no word.

**The reach reading paid again, and deeper.** Six of those eighteen are themselves whole carrying families standing above the harness line: `position_standing` in **twenty-seven** rungs, `dwell_published` in **twenty-four**, `forum_published`, `refer_refusal`, `case_delivered`, and `refer_note` in **twenty-two** each. Four are wire readers that open a note through their rung's own path builder and plan name; one is a wire writer; one is pure arithmetic that refuses by name. All six lifted. The whole seven-family lap cost exactly one widened word -- `case_path`, which `case_delivered` and `refer_note` share, made public in twenty-two rungs.

Six further reached bodies stayed home, and honestly rather than by rule: `endures`, `stands_loud`, `unheard_outside`, `referred_in`, `unreferred_in`, `is_party`, `refer_holds`, `referral_bytes`, and `settlement_published` each run three to seven lines, where a delegate runs three. They still carry a few hundred lines between them, so they are the next lap's cheap remainder rather than nothing at all -- the honest claim is that the gain is small, never that it is zero.

What the folded check does is the arc's whole referral half, stated once. A run reads what stands, refuses to act on a quarrel nobody presses, dates the position off the wire rather than out of memory, leaves this morning's argument with the people having it, refuses by name where a referral would go unaddressed or land back inside the argument, copies the case off the record rather than summarizing it, and reads the case back out of the box a third hand opens before the report believes a word.

| Row | Before | After |
|---|---|---|
| Rungs holding `refer_the_quarrel` | 21 | **0**, each keeping a three-line delegate |
| Rungs holding `position_standing` | 27 | **0**, each keeping a three-line delegate |
| Rungs holding `dwell_published` | 24 | **0**, each keeping a three-line delegate |
| Rungs holding `forum_published` | 22 | **0**, each keeping a three-line delegate |
| Rungs holding `refer_refusal` | 22 | **0**, each keeping a three-line delegate |
| Rungs holding `case_delivered` | 22 | **0**, each keeping a three-line delegate |
| Rungs holding `refer_note` | 22 | **0**, each keeping a three-line delegate |
| Lines the seven families carried | 3,128 | **459** |
| Widenings the fold cost | -- | **22**, one word, one shared path builder |
| The ladder's whole carry | 107,395 | **104,726** |
| Carry ceiling | 107,500 | **104,800** |
| Carrying families | 707 | **707** |

**The arithmetic closes with no remainder.** Out went 20x72, 26x12, 23x16, 21x13, 21x12, 21x13, and 21x10 -- 1,440 plus 312 plus 368 plus 273 plus 252 plus 273 plus 210, or **3,128**. Back came the same seven cohorts at three lines apiece -- **459**. The fall is 2,669, and the meter read **2,669**. Fold AC's extra twenty-six came from a family that widening split in two; this lap widened one word inside a family that was already whole, so nothing split and nothing was gained by accident.

**The lesson this lap adds is that a free fold is a signal, not luck.** Eighteen reaches, eighteen already public: the appeal, dependent, reap, and amendment clusters had each widened the symbols this tier shares, so by the time the quarrel came up the queue its whole neighborhood was already open. Folds pay forward. The cheapest fold on any ladder is the one taken after its neighbors have gone first, and the queue -- ordered by carried lines alone -- happens to walk a tier in roughly that order because a tier's families rise together.


## Fold AE -- the escort, its wire reader, and the owner brought home

The queue named **thirty-one rungs by forty-seven lines, 1,410 carried**, and hashing every `escort_the_word` on the ladder found thirty-two bodies at one length. Thirty-one stand byte for byte alike; the thirty-second is `abide.rye`, the tier owner, which reaches its own report directly where every rung above it reaches through `abiding_of`. Four lines of the forty-seven differ, and all four differ that one way -- the signature three laps running have now met in `amend.rye`, `appeal.rye`, and `refer.rye`, each of which stayed home.

**This one came home instead, and the difference is the whole reading.** An owner stays home when a shape born after it dates it out, as `hear.rye` was dated in fold U. An owner comes home when the only thing standing between its body and its cohort's is a reach it never needed to name -- and then three lines of identity accessor make it byte for byte the same body. `relent.rye` proved that in fold X and `repose.rye` in fold Y; `abide.rye` is the third, and the family folded **whole at thirty-two**.

Fold Z's rule ran next, and reported a clean neighborhood. `escort_the_word` reaches fourteen symbols beyond the accessor, and **all fourteen already stood public in all thirty-one rungs** -- the fold's whole price was the twenty-three rungs where `abiding_of` was private, plus the three lines the owner gained.

**The reach reading paid once more.** One of those fourteen is itself a whole carrying family standing above the harness line: `dispute_recorded`, a wire reader in **thirty-three** rungs at fourteen lines apiece, one text with no absentee at all. It opens the disagreement note through its rung's own path builder and plan name, reads the two settlements it holds, and returns nothing rather than guessing where the wire reads short. Lifting it cost **no widening whatsoever** -- its five reached symbols were already public in all thirty-three, and `Dir` is the harness's own alias for `std.Io.Dir`.

What the folded escort does is the arc's whole abiding half, stated once. A run reads its own published settlement out of the note an operator would open, reads the disagreement out of the note that keeps it, and writes the mark from those two rather than from anything the supervisor remembers doing. A run that published nothing marks nothing. A record holding no quarrel has nothing to quote. A word read alone carries no mark, however plainly its reader objected. Only a published word standing over a recorded disagreement earns an escort -- and the escort must quote the reading its reader actually holds, since carrying one person's word to whoever reads another means carrying that person's word.

| Row | Before | After |
|---|---|---|
| Rungs holding `escort_the_word` | 32, one apart | **0**, each keeping a three-line delegate |
| Rungs holding `dispute_recorded` | 33 | **0**, each keeping a three-line delegate |
| Lines the two families carried | 1,858 | **189** |
| Widenings the fold cost | -- | **23**, one word, one accessor reach |
| Accessors born | -- | **1**, three lines in `abide.rye` |
| The ladder's whole carry | 104,726 | **103,057** |
| Carry ceiling | 104,800 | **103,100** |
| Carrying families | 707 | **707** |

**The arithmetic closes with no remainder.** Out went 30x47 and 32x14 -- 1,410 plus 448, or **1,858**. Back came thirty-two and thirty-three rungs at three lines apiece, carrying 31x3 and 32x3 -- **189**. The fall is 1,669, and the meter read **1,669**. Carrying families held at 707 because both families folded whole into delegate families of their own, with no visibility split opened and none healed.

**The lesson this lap adds is that a tier owner is a question rather than a verdict.** Five owners have now stood apart from their cohorts, and the arc has answered each differently on evidence: `hear.rye` stayed home because it ends its run on an error the rungs above record and carry past, and no accessor gives a body back a check it never had. `amend.rye`, `appeal.rye`, and `refer.rye` stayed home because their difference was the reach and no accessor had yet been born for it. `abide.rye` came home because the accessor cost three lines and folded forty-seven. The test is never who owns the tier -- it is whether the difference is a meaning or a reach, and only reading the differing lines can say which.


## Fold AF -- a run's whole opening, and the two absentees that both came home

The queue named **`start_one` at forty rungs by thirty-five lines, 1,365 carried**, and hashing every body by that name found fifty-seven standing as ten texts -- the canonical forty, a shallower nine at nineteen lines, and eight singletons.

**Two of the singletons stood at the canonical's own length**, each differing in exactly one line: the reach that names the abandoning tally. Reading the accessors settled both. `abandon.rye` owns the abandoning tier, so its `below_of` returns the rung beneath and the body climbs back two hops -- which is precisely what an identity accessor named `abandoning_of` gives the shared text from the same pointer. `reckon.rye` stands one rung above `abandon.rye`, so its `below_of` already returns the abandon rung's report, the very type `abandoning_of` returns everywhere else. Three lines apiece, and the family closed **whole at forty-two**.

**`reckon.rye` is a sixth kind of absentee.** The arc had met one dated by a shape born later, one an accessor brings home, one standing below the fold line, and the tier owners who came home or stayed. This one is none of those: it is a rung close enough to reach a tier by its **position** rather than by its name. An absentee's distance from its cohort is a place on the ladder as often as it is a fact about its body.

**Fold Z's rule found the neighborhood nearly free.** Eleven of the twelve symbols `start_one` reaches through its rung already stood public in all forty-two, so widening one word -- `revoke_rung`, in forty-three modules -- paid the whole fold. Four of the reached symbols are whole carrying families: `open_generation` at forty-three by ten, `promise_pruning` at forty-three by eleven, `promise_falling` at forty-two by eight, and `offer` at forty-five by seven. Together they are the four promises a run writes to the wire before it spawns anything, and they now read in one place beside the body that calls them.

**The fold line still bites.** `offer`'s forty-fifth rung is `confer.rye`, which `ladder_checks.rye` itself imports; folding it would have a rung the harness reaches for reach back through the harness. It stays home, and `offer` folded at forty-four.

| Row | Before | After |
|---|---|---|
| Rungs holding `start_one` | 42, two apart | **0**, each keeping a delegate |
| Widenings the fold cost | -- | **43**, one word |
| Accessors born | -- | **2**, three lines apiece |
| The ladder's whole carry | 103,057 | **101,252** |
| Carry ceiling | 103,100 | **101,300** |
| Carrying families | 707 | **707** |

Out went 3,017 lines of body across forty-seven files; back came 411 as delegates and calls. Choir GREEN at 105 registered witnesses.


## Fold AG -- the promised pruning, and the whole cluster beneath it

The queue named **`return_promised_reach` at forty-two rungs by thirty-three lines, 1,353 carried**, and hashing every body by that name found **forty-two texts and one hash**. No absentee at all -- the first lead family in this arc to stand byte for byte across its whole cohort with nothing to read and nothing to bring home.

What it does is the returning half of a conferred reach. A dependent told a pruning is coming waits, bounded, for the number that names what it may keep; it rebuilds its own hands down to that number, probes whether anything past the number is still reachable, and answers only when the probe comes back empty. A `null` says the words on the wire could not be read back into hands at all, which is a different answer from *nothing was returned* and is kept different on purpose.

**Fold Z's rule paid again, and paid almost entirely.** The body reaches eight symbols through its rung, and **seven already stood public in all forty-two**. The eighth, `prune_to`, was private everywhere -- so one widened word bought the fold, exactly as fold AA and fold AD each did before it.

**The reach reading opened the cluster.** Five of the reached symbols are whole carrying families of their own, and every one of them folded beside the lead: `reachable_between` at forty-four by twenty-four, `prune_to` at forty-four by twenty-three, `pruning_promised` at forty-four by six, `kept` at forty-four by eight, and `pruned` at forty-four by seven. Together with the body that calls them they are one coherent movement -- promise, wait, rebuild, probe, answer -- and they now read in one place rather than in forty-four.

**The elder rung came home twice over.** `revoke.rye` is the tier owner here, and it stood apart from its cohort in two small ways at once: its `reachable_between` was private where the other forty-three published it, and its `prune_to` lacked one invariant the other forty-three carry -- *a pruning always rebuilds from hands that hold their own line*. The first is a visibility split, healed by the word. The second is an elder body dated by a shape born after it, and folding hands it the invariant rather than asking it to keep going without one. Both families closed **whole at forty-four**.

| Row | Before | After |
|---|---|---|
| Rungs holding `return_promised_reach` | 42, none apart | **0**, each keeping a delegate |
| Rungs holding the five reached families | 44 apiece | **0**, each keeping a delegate |
| Widenings the fold cost | -- | **45**, two words |
| The ladder's whole carry | 101,252 | **98,507** |
| Carry ceiling | 101,300 | **98,600** |
| Carrying families | 707 | **707** |
| The `check_` window | 47 | **47** |
| The orchestration spine | 0 | **0** |

The fall the meter read is **2,745**. Carrying families held at 707, since all six folded whole -- one visibility split healed and none opened. Checks 47 and spine 0 stand unmoved for the tenth fold running.

**The lesson this lap adds is that a family with no absentee is a signal about its neighborhood, not only about itself.** Every prior lead family carried at least one rung standing apart, and reading that rung is what taught the arc its five kinds of absentee. This one stood whole -- and the reason is that the whole cluster was written at one moment, by one hand, as one movement, and has never been touched since. A body that varies has a history; a body that does not has a birthday.


## Fold AH -- the courier cluster, the largest fall on the ladder, and the price was two words

The queue named **`carry_the_amendment` at thirty-four rungs by forty-one lines, 1,353 carried**, and hashing every body by that name found **thirty-five**. `courier.rye` stood apart by four lines, and all four differed the one way: the owner reaches its own report directly where every rung above reaches through `couriering_of`. That is the second kind of absentee, met now for the seventh time and recognized on sight -- three lines of identity accessor, and the family folded **whole at thirty-five**.

What the body does is the outward reach of the whole correspondence arc. A run that posted no correction carries nothing, and says so by weighing nothing rather than by inventing an errand. A reader who left no address cannot be reached, and the run refuses by name rather than choosing a destination on their behalf. Only a posted correction with somewhere to go travels -- and under `.waiting` even that one stays where it was written, which is precisely the number this tier moves. The hard half comes at the end: the run reads the reader's own box back before it believes a word of its own report, because a delivery claimed from memory of having written is a claim rather than a delivery.

**Fold Z's rule was walked to closure this lap rather than one hop out, and that is the whole story of the fall.** One hop from the lead named ten symbols, and every one of them proved a whole carrying family standing byte for byte across the same cohort. A second hop, from `deliver` and `delivered_to` down to the path builder they share, named **`box_path` at twenty-five lines over thirty-five rungs** -- the second-largest family in the cluster, and one the lead body never mentions. A reach graph read to its closure is a survey; a reach graph read one step is a glimpse.

| Family | Rungs | Lines | Carried before |
|---|---|---|---|
| `carry_the_amendment` | 35 | 41 | 1,353 |
| `box_path` | 35 | 25 | 850 |
| `carry_refusal` | 35 | 19 | 646 |
| `delivered_to` | 35 | 15 | 510 |
| `amend_published` | 36 | 14 | 490 |
| `deliver` | 35 | 13 | 442 |
| `addressable` | 35 | 11 | 374 |
| `carried_in` | 35 | 7 | 238 |
| `posted_unreached` | 35 | 6 | 204 |
| `unaddressed_reach` | 35 | 6 | 204 |
| `held_in` | 35 | 5 | 170 |

**The price was two words.** Every other symbol the cluster reaches already stood public in all thirty-five rungs, interest paid in full by the folds before it. `couriering_of` was private in `hear.rye` alone, and `note_path` private in `amend.rye` alone -- the amending tier owner, which joins this lap for `amend_published` and nothing else, since it carries no readers' directory and no box of its own. Two widened words and one accessor born bought eleven families.

**The cluster drew its own boundary honestly.** `address_published` is reached by the lead and stands in thirty-five rungs, yet it is already a delegate three lines long -- folded on an earlier lap -- so it stayed exactly where it was. A three-line body traded for a three-line delegate moves nothing, and a fold that reached for it anyway would be counting motion rather than making it.

| Row | Before | After |
|---|---|---|
| Rungs holding the eleven bodies | 35 or 36 apiece | **0**, each keeping a delegate |
| Widenings the fold cost | -- | **2**, plus one accessor born |
| The ladder's whole carry | 98,507 | **94,151** |
| Carry ceiling | 98,600 | **94,200** |
| Carrying families | 707 | **707** |
| The `check_` window | 47 | **47** |
| The orchestration spine | 0 | **0** |

The fall the meter read is **4,356** -- the largest this arc has taken, half again the previous best. It closes with no remainder: the eleven families carried 5,481 lines between them and the delegates that replace them carry 1,125. Carrying families held at 707, since every family folded whole and no visibility split opened or closed inside a carrying cohort. Checks 47 and spine 0 stand unmoved for the **eleventh** fold running.

**The lesson this lap adds is that a delegate keeps the visibility of the body it replaces.** Two of these eleven were private in their rungs and stayed private, because nothing outside the rung ever called them and the harness reaches them as itself rather than through the type. Publishing a delegate that nobody outside reads would widen the module's surface for the fold's own convenience -- and a fold that quietly widens what it touches is charging a price it never names.


## Fold AI -- the whole standing movement, and four tier owners home in one lap

The queue named **`weigh_the_standing` at twenty-two rungs by fifty-seven lines, 1,197 carried**, and reading one tier out found its three siblings standing beside it: `date_the_standing` at twenty-two by fifty-six, `herald_the_standing` at twenty-two by fifty-three, and `carry_the_position` at twenty-two by fifty. Together they are one movement -- **what a run owes a quarrel still standing over its plan**, carried past the run that heard it, weighed into the word an operator reads, dated by how long it has stood, and heralded as loudly as that age deserves. The harness already runs them as a movement; `the_standing` calls all four in the order the arc grew.

**Every one of the four carried its own tier owner, and every one came home.** `heed.rye`, `dwell.rye`, `swell.rye`, and `endure.rye` each own the tier their sibling body reports into, so each reached its own report directly where the rungs above reach through an accessor. Four identity accessors, three lines apiece, and four families that had never once stood whole stood whole together.

| Family | Rungs | Lines | Carried before | Tier owner brought home |
|---|---|---|---|---|
| `weigh_the_standing` | 26 | 57 | 1,197 | `heed.rye` |
| `date_the_standing` | 24 | 56 | 1,176 | `dwell.rye` |
| `herald_the_standing` | 23 | 53 | 1,113 | `swell.rye` |
| `carry_the_position` | 27 | 50 | 1,050 | `endure.rye` |
| `regard_published` | 26 | 12 | 300 | -- |
| `swell_published` | 23 | 12 | 264 | -- |
| `dwell_note` | 24 | 7 | 161 | -- |
| `standing_note` | 27 | 5 | 130 | -- |
| `regard_note` | 26 | 5 | 125 | -- |

**The second hop was nearly free, and it stopped where it should.** Of the forty-odd symbols the four bodies reach, every one already stood public in every rung that has it at all, and the ones absent from a rung are absent exactly where the tier structure says they should be -- `swell_published` and `Volume` live only from the heralding tier up. Most of the reached helpers are already three-line delegates from earlier laps and were left exactly where they are. Five were real bodies and lifted; the rest moved nothing and so did not move.

**The visibility split here is meaning rather than accident.** Twenty-two rungs publish these bodies and four or five keep them private, and the reason is legible: a rung that only ever reaches the body through the harness's `the_standing` must publish it, since the harness calls `rung.weigh_the_standing`, while a rung that calls it itself has no reason to widen its own surface. Fold Z met this shape as a split to heal; this lap met it as a split to **keep**. So each delegate wears the visibility its body wore, and the meter honestly reads two families where the ladder honestly holds two.

| Row | Before | After |
|---|---|---|
| Rungs holding the nine bodies | 23 to 27 apiece | **0**, each keeping a delegate |
| Widenings the fold cost | -- | **64**, plus four accessors born |
| The ladder's whole carry | 94,151 | **89,010** |
| Carry ceiling | 94,200 | **89,100** |
| Carrying families | 707 | **708** |
| The `check_` window | 47 | **47** |
| The orchestration spine | 0 | **0** |

The fall the meter read is **5,141** -- larger again than the lap before it, and it closes with no remainder: 5,780 carried in across the nine families and their visibility twins, 639 carried back out in delegates. Checks 47 and spine 0 stand unmoved for the **twelfth** fold running.

**Carrying families rose by exactly one, and the one is a family born rather than a family split.** Before this lap `dwell.rye` and `swell.rye` each held their own private `date_the_standing`, two distinct texts standing alone. Folding gave both the same three-line delegate, so two singletons became one carrying pair. A fold that lifts bodies out can still leave a new family behind it, and the honest reading is that the meter counts texts rather than intentions.

**The lesson this lap adds is that a movement is a better fold unit than a body.** The queue names one family at a time because it measures one name at a time, yet `the_standing` had been calling these four in sequence since the spine finished growing at `refer`. Reading the harness for what it already runs together found four families where the queue showed one -- and four tier owners whose accessors, born together, cost twelve lines and folded two hundred and sixteen.

