# Checkpoints -- the walk-back markers before every debride

**Language:** EN
**Status:** Living ledger -- append-only
**Voice:** Kyri
**Rule:** [`../.claude/rules/checkpoint.md`](../.claude/rules/checkpoint.md) - [`../.cursor/rules/checkpoint.mdc`](../.cursor/rules/checkpoint.mdc)
**Kin:** **debride** removes; a **checkpoint** marks the way back before it does.

---

A **checkpoint** is a stacked-stone trail marker. In this tree it is one row recorded **before a seated debride sweeps a living card** -- the git nib and the live stamp at that moment, plus one honest line naming what stood there. Where **remember** reprints the *current* card, a checkpoint pins the *departing* one, so a good idea folded into an old REMEMBER, THREADS, or work-in-progress file is never truly lost -- it waits at a named commit, one `git show` away.

**How to walk back to a checkpoint:**

```
git show <nib>:work-in-progress/REMEMBER.md      # read the whole departing card
git show <nib>:work-in-progress/THREADS.md
git log --oneline <nib>                          # browse the tree as it stood
```

The nib is the HEAD **before** the debride's own commit -- so the old files live at that commit and every commit before it.

---

## The ledger (newest first)

### `20260823.094410` -- Skate becomes Surf, and the social layer is named Surf Social

**Walk-back nib:** `06d7169f81` -- pier and both remotes. A **breach**, so nothing is rewritten.

**Swept:** the `surf/` directory becomes `surf/` (4 fixture files), the name **Surf** is seated in
`context/LEXICON.md`, and living prose naming the module is repointed. **Surf Social** is seated as
the social layer's name, with the domain `surf-social.com` claimed `20260823`.

**What is deliberately NOT swept, and why.** Nineteen code files carry the elder name --
`brushstroke/skate_grid.rye`, `brushstroke/image_skate.rye`, `linengrow/skate_grid.rye`,
`pond/apps/skate_circle.rye` and their kin -- along with dozens of Rye identifiers
(`skate_base`, `skate_cell`, `brush_skate_cols`, `image_skate_version`). They keep their names.

This is the Comlink tendency's own seated rule rather than a shortcut: *"A module earns a new name
by being re-grown beside its elder, born-named, not by a mass rename... it does not license
churn."* So **Surf is the born name from here forward**, and the elder tissue is renamed when it
is re-grown, module by module, with witnesses green -- rather than by a sweep that would touch
2,816 word uses and dozens of symbols in one pass. Thirty-one dated filenames also carry `skate`
and, as always, keep every letter.

### `20260823.090034` -- checkpoint becomes checkpoint, and one word carries both senses

**Walk-back nib:** `560448ab11` -- pier and both remotes. A **breach**, so nothing is rewritten and
`git show 560448ab11:construction/CHECKPOINTS.md` reads this ledger at its old name.

**Swept:** `construction/CHECKPOINTS.md` becomes `construction/CHECKPOINTS.md`, `.claude/rules/checkpoint.md`
becomes `checkpoint.md` with its Cursor twin, and 821 occurrences of the word across 255 files are
repointed in the 28 **living** ones. The 227 files of **dated testimony** keep every word.

**What waits there, worth recalling, and the honest note.** `checkpoint` was a good name -- a
stacked-stone trail marker, plain and warm, and it did one job cleanly. It is retired on Keaton's
word `20260823.090034`.

The measurement worth keeping: **`checkpoint` was already seated** in `context/LEXICON.md` as *a
named stop-before-cross gate*, with its own closing form `check in (checkpoint)` and 858 uses. So
this rename **merges two senses into one word** rather than moving a name into empty space, which
is the opposite of what `crux -> construction` did an hour earlier. That merge is a decision
rather than a drift: both senses are **a marked place where you stop** -- one before you cross
forward, one so you can walk back -- and the Lexicon entry now carries both readings side by side.
If the two ever need separating again, `trailhead` measured zero uses in the whole tree on this
date and is the free word waiting.

### `20260823.085309` -- the manual's onboarding room becomes grain-os

**Walk-back nib:** `e90f314dc7` -- pier and both remotes. A **breach**, so nothing is rewritten and
`git show e90f314dc7:manual/grain-os/README.md` reads any departing file at its old path.

**Swept:** `manual/grain-os/` becomes `manual/grain-os/` -- 5 tracked files, with 173 occurrences
of the name across 89 files. The 16 **living** files are repointed; the 73 files of **dated
testimony** keep every word they wrote.

**What waits there, worth recalling:** the room was named for **Glow**, the rune language, at a
time when the language was the thing a newcomer met first. The system's own name is **Grain**, and
the room is where a reader arrives to learn the system rather than the language -- so the elder
name sent every newcomer to the wrong noun on their first click. The language keeps its name
everywhere it is actually the subject; only the onboarding room moves.

### `20260823.082418` -- the crux room becomes construction

**Walk-back nib:** `06d7d487a3` -- pier and both remotes. This is a **breach** rather than a debride, so
nothing is rewritten and the walk-back stays reachable everywhere. `git show 06d7d487a3:construction/REMEMBER.md`
reads any departing file at its old path.

**Swept:** the `construction/` room is renamed to `construction/` -- 109 tracked files, with 1,442 path
occurrences across 620 files. The 144 **living** files are repointed; the 476 files of **dated
testimony** keep every word they wrote and their references stand as written.

**What waits there, worth recalling:** `crux` was itself the breach target of `20260815`, when
`work-in-progress/` became `construction/`, and that breach cost two reds -- `REDS %153`, where an
untracked `work-in-progress -> crux` compatibility symlink blinded a whole class of guard for
eight days, and `REDS %155`, where 116 path literals inside tracked tool sources were found still
reading the elder room a lap after the documents were swept. **Both lessons are applied here: no
compatibility symlink is left behind, and the machinery is swept in the same pass as the prose.**

**Why the name moves.** The **word** `crux` is a seated Lexicon term meaning the hardest solvable
problem, and it stays exactly as it is in all 4,162 living uses. The **room** wanted a plainer
name: `construction/` says what the room holds -- the live operator card, the ledgers, the work
under way -- to a reader meeting it on their first day, which is what the Comlink tendency asks of
every name. One word doing two jobs was the thing worth separating.

### `20260823.072824` -- the deep debride: personal material leaves the history

**Walk-back nib:** `52393ae830` -- **and this one is different from every checkpoint above it.** This is
a *deep* debride, so after the force-push the walk-back commit is **unreachable on both remotes**.
The pre-debride history survives in two places instead: a verified full bundle at
`.debride-safe/pre-debride-52393ae830.bundle` (559 MB, untracked, on this pier), and any clone
taken before `20260823.072824`.

```
git clone .debride-safe/pre-debride-52393ae830.bundle recovered   # the whole tree as it stood
git -C recovered log --oneline 52393ae830                          # browse it
```

**Swept:** four paths removed from all 3,313 commits --
`foundations/20260730-022147_keaton-livermore-resume-draft.md`,
`foundations/20260730-022147_personal-ontology.md`,
`foundations/20260730-022147_cover-letter-co-authored.md`, and the `twilight/` room. Twenty-five
commits touch them. Every rewritten commit is re-signed in the same pass, so the tree stays fully
signed; the honest cost is one reclone for every downstream.

**What waits there, worth recalling:** the resume draft, the personal ontology, and the
co-authored cover letter are a real record of one person's thinking in `20260730`, and the
`twilight/` room holds the poems that are the private source of the fifteen Twilight themes --
`context/TWILIGHT_STYLE.md` names them as archetype in-tree while the poems themselves stay
withheld. **All four survive on disk, untracked**, exactly as `letters/` does, so the work is
still available to its author and simply out of every repository.

**Why now, and why this target.** `REDS %162` named three resolutions for a depersonalisation that
protected an already-public field. Keaton took the first on `20260823.045448` -- make the field
private -- which closed the immediate exposure and left the content sitting in history. This is
the third resolution taken deliberately afterward, so the material is gone rather than merely
unreachable. A survey for other debride targets on `20260823.072824` found none: every filename is
honest, every commit message was true when written, and the 2,783 `.bron` logs are protected by the
one-clock law.

### `20260823.041442` -- the two temperatures become one room and a fold

**Walk-back nib:** `be94f7ab82` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** the `expanded-prompts/` room is removed. It held **two** tracked files against
`expanding-prompts/`'s 584 -- one dated record and its own README -- and its seating row is
amended in `context/LEXICON.md`, `construction/TASKS.md`, and `construction/REMEMBER.md`.

**What waits there, worth recalling:** the room was seated `20260810` on Keaton's word to file
intent by **temperature** rather than only by stamp -- `expanding-prompts/` hot and live,
`expanded-prompts/` cold and at rest -- and its README says that well, in one page worth reading
before anyone proposes the split again. The idea is kept rather than dropped: the
`date/YYYYMMDD/` fold that arrived after it (`.claude/rules/stamp-and-name.md`) already encodes
exactly the same distinction structurally -- flat at the room root is hot, folded under `date/`
is cold -- so the second room became a second way of saying one thing. That is the whole reason
for the unify, and it is the thing to re-read if the temperatures ever want separate rooms again.

```
git show be94f7ab82:expanded-prompts/README.md
git show be94f7ab82:expanded-prompts/20260810-054332_green-witness-record-seed-ready.md
```

### `20260822.234745` -- the standing roster leaves prose for a file

**Walk-back nib:** `518cf4098a` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** two living cards. `construction/REMEMBER.md` gave up its **standing-equipment paragraph** -- the long prose chronicle that opened *"Seventeen stood green when this line was written"* and then named sixteen witnesses across the sentences after it, each with the stamp and story of its own seating -- replaced by a short line pointing at [`standing-equipment.kyri`](standing-equipment.kyri), which twenty machine-readable records now hold. The card's **Now** block moved from the banner-and-path lap to this one. And `construction/REDS.md` folded rows **%148** and **%149** to [`archive/REDS-the-banner-and-the-unrun-bound-rows-148-149.md`](archive/REDS-the-banner-and-the-unrun-bound-rows-148-149.md) as rows %150-%151 carried it past its 24,576-byte bound.

**What waits there, worth recalling:** the departing paragraph is the only place each guard's **seating story** was ever written -- why `nib_honesty` was rewritten after two days red, why `radiant_negation` reports `foundations/` against a register of 0.40, why `rye_bridge_cycle` is the first guard ever pointed at our own compiler. The roster file keeps each guard's name, path, and seating stamp; it deliberately keeps no story, because a roster that carries prose becomes a paragraph again. Those stories live on in each guard's own header comment and in the dated session logs that seated them. `git show 518cf4098a:construction/REMEMBER.md` reads the departing card whole.

### `20260822.195336` -- the ledger folds two closed rows as the queue is ranked

**Walk-back nib:** `f798693b85` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** two living cards. `construction/REDS.md` shed the four paragraphs of rows **%142** and **%143** -- the line-citation red and the spelled-number red, opened and closed -- to [`archive/REDS-line-citation-and-spelled-number-rows-142-143.md`](archive/REDS-line-citation-and-spelled-number-rows-142-143.md), because booking row **%145** pushed the living pin past its 24,576-byte bound and the e123 guard said so. Every byte is kept; the archive file holds the four paragraphs unchanged. And `construction/REMEMBER.md` replaced its **Now** block, the `bearing_note` lift giving way to the `appraisal_note` lift and the ranked queue that came with it.

**What waits there, worth recalling:** row %142's own reasoning about why a **line citation** cannot survive its file -- the honest citation is the one that points at something still there after forty lines land above it -- and row %143's spelled-number reader with its bound at ten, where a spelled word below ten is a determiner rather than a measurement. Both lessons now stand as running guards rather than as prose, which is why the prose could fold. `git show f798693b85:construction/REDS.md` reads the ledger whole; `git show f798693b85:construction/REMEMBER.md` reads the departing card.

### `20260822.192044` -- three lift laps condense into one live row

**Walk-back nib:** `8aecfffb6a` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card's **Now** block as it read after the `read_the_reply` lap stands whole at this nib, together with the two laps of prose that accreted beside it.

**Swept:** `construction/REMEMBER.md` -- the **Now** block, roughly nine paragraphs, replaced by one live row naming the `bearing_note` lift and the queue it leaves. Three laps of departing detail leave the card: `read_the_reply` (the row free of every priced column), `asked_of` (the constant that answered from above), and `found_path` (the fall as a product).

**What waits there, worth recalling:** the eleventh-rung reading of `allay.rye`, which declares the same name and writes `report_out.read_back` directly rather than through `allay_of(report_out)` -- a different body rather than a copy, and the cleanest example the arc has of what the meter means when declarations outnumber identical bodies. Also the `asked_of` reading that a private alias of a shared type is a false price: thirty-one rungs each wrote `const Dir = std.Io.Dir` privately, the meter honestly counted thirty-one openings, and a hand-read before the lift turned that price into zero. Every one of the three laps keeps its own dated log in `session-logs/`, so this row marks the card rather than the record.


### `20260822.054053` -- the ten glyph-note and note-path folds condense into one row

**Walk-back nib:** `9f3e807c23` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read through the ten-fold arc stands whole at this nib: the per-fold live-edge rows for `press_path`, `bearing_published`, `appraisal_published`, `recant_published`, the roster round, and the laps between them, each in the words its own round wrote.

**Swept:** six live-edge rows fold into one. The INNER LOOP directives, the guard roster, every seated law, and the season table stay untouched.

**What waits there, worth recalling:** the arithmetic each fold published as it landed -- the predicted fall, the realized fall, the delegate count, and the widening cost it believed it was paying. That last number is the one worth walking back for, because this lap proved it was measured against the wrong thing for four laps running (REDS %130), and the departing rows are the record of exactly what was believed and when.

**Why now:** the outer loop reads this card first each lap and takes the door it names. Ten rows of finished folds push the live work-front below a reader's first screen, and a card that has to be scrolled to find *what is next* has stopped being the live card.

### `20260821.203501` -- the operator card condenses a day of folds and takes the Standfast edge

**Walk-back nib:** `9714cf1a85` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read through the Caravan ladder arc stands whole at this nib: nineteen live-edge rows, `fold AI` at the front, and the full narration of every fold from D through AI in the words each round wrote for itself.

**Swept:** nineteen live-edge rows fold into two -- one for the Standfast day that has become the edge, one condensing the Caravan ladder arc that produced them. The card is 58,608 bytes and carries a standing condensation debt named in its own INNER LOOP; this pays part of it. The INNER LOOP directives, the guard roster, and every seated law stay untouched.

**What waits there, worth recalling:** the per-fold reasoning. Each row explains *why* that fold chose the family it chose -- the harness read before the meter, the visibility split kept rather than healed, the cohort measured at the head of the lap rather than re-queried. That reasoning is the Caravan arc's real teaching and it is not summarised well by a count. It also lives in the session logs of each fold, so the walk-back is a convenience rather than the only copy.

**Why now:** the outer recursion loop reads this card first each lap and takes the door it names. Its live edge pointed at `fold AI` and would very likely have opened `fold AJ` -- a mark the mark law seated today explicitly retires. A card eight hours stale is not merely untidy; it is an instruction to contradict the tree.

### `20260821.165133` -- the four advisory rooms fold, and living code is repointed

**Walk-back nib:** `30ad234a08` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. `counsel` (764 flat), `active-designing` (629), `expanding-prompts` (359), and `waymarks` (290) read at this nib exactly as they stood before the fold, and so does every living file before the repointer touched it.

**Swept:** no file is removed. Each room's flat dated files `git mv` into `<room>/date/<day>/`, and each room's own `README.md` is repointed in the same pass. Then, for the first time, **living files are rewritten**: a reference in code or a living document whose target moved into a date fold is repointed in place. **Every file whose own basename carries a one-clock stamp is left byte-identical** -- that rule is what keeps this from becoming a rewrite of dated testimony, and it is proven on metal by `tools/dated_path_repoint_witness.rish` before it ran.

**What waits there, worth recalling:** the last look at four rooms that grew past what a browser can list, and the reason each fold was safe to make -- roughly a thousand functional references inside `tools/` pointed at flat paths in these rooms, counted before the move rather than discovered after it. The walk-back also holds every living file exactly as it read before any automated edit touched it, which is the thing worth being able to return to when a tool has rewritten three thousand candidates in one pass.

### `20260821.161758` -- the session-log room folds flat to `date/YYYYMMDD/`

**Walk-back nib:** `66875be46b` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The whole session-log room as it stood flat -- 1,492 dated files at room level, 892 `.bron` and 600 `.kyri`, beside the elder `archive/` holding 3,000 more across 44 day directories -- reads at this nib exactly as it read for the two months it grew that way.

**Swept:** no file is removed and no byte is lost -- this is a `git mv` of every flat dated log into `session-logs/date/<day>/`, plus a rename of the elder `archive/` to `date/` so one room has one shape. `session-logs/README.md` is a **living** index, so its 1,491 flat links and its `archive/` links are repointed in place; every other reference in the tree is left exactly as written, to be **resolved** rather than rewritten (`tools/dated_path_resolve.rish`).

**What waits there, worth recalling:** the flat room is the last look at what two months of daily logging looks like in one `ls` -- and the honest reason the fold happened, since GitHub's web listing stops at 1,000 entries and the room held 1,492. The elder `archive/` name waits here too; it retires because ORGANIZING defines archive as finished-and-historical while a log from nine days ago is the live record.

**Why a checkpoint for a move rather than a debride:** the checkpoint rule asks for one before a *debride*, and this is not one -- nothing is destroyed. It is recorded anyway because it is the largest structural move the tree has made, and a walk-back to the room's departing shape costs one line and answers a question a future reader will certainly ask.

### `20260821.073606` -- the reply and edge live edges condense as fold N lands

**Walk-back nib:** `b356c54b8e` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read while the refusal agenda was closing stands whole at this nib.

**Swept:** `construction/REMEMBER.md` -- the two full live-edge bullets for `caravan/reply.rye` (`20260821.071421`) and `caravan/edge.rye` (`20260821.063720`) condense into one pointer bullet, roughly 6 KB of card, as fold N takes the live edge. Both arcs are recorded in full in `caravan/README.md` and in their own dated session logs.

**What waits there, worth recalling:** the reply bullet holds the four-stage reading order and the muted-table RED path in the card's own words, and the edge bullet holds why seL4's alphabetical error listing is a reading order rather than a checking order -- both facts now living in `caravan/README.md`, yet stated more briefly there than the departing card stated them.

### `20260821.020803` -- the fold-L live edge folds as fold M lands and the printed queue proves itself

**Walk-back nib:** `445da815d9` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when the fourth meter had just opened stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for **fold L** and the bullet naming the loom that outlived it, folded into the condensed-pointer line beneath them, and the **Now** block rewritten from `mend_the_plan`, the crux fold M just closed, to the crux the meter names next. Roughly a screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** fold L's full accounting as it was written -- `stand_taking_and_returning_reach` standing byte for byte in 42 of its 44 rungs at forty-four lines apiece with no mask needed, 1,638 lines deleted for 281 of harness and call, four symbols widened by one word each, and every one of the 42 sorted multisets identical with zero lines differing. Beside it stands the birth of the fourth meter and the reasoning that made it necessary: three honest meters each reading through a **named window**, and a ladder whose real carry is two orders of magnitude past all three. Both accounts live on in `session-logs/20260821-014514_caravan-ladder-fold-l-and-the-meter-with-no-name-in-its-window.kyri` and the fold sections of `caravan/README.md`.

**What the departing Now got right, and what the fold added:** it named `mend_the_plan` at 36 rungs by 178 lines, 6,230 carried, straight off the meter -- and the fold found a thirty-seventh rung the meter could not have named, `recant.rye`, which owns the recanting tier and so reached its own report directly in two lines out of a hundred and seventy-eight. One three-line accessor made it byte-identical, and the carry lifted climbed to **6,408**. The departing card's queue was honest and slightly conservative, for the same reason fold L's estimate was: a meter compares exact text, and a body that is *nearly* alike is invisible to it until a hand looks. That is the standing limit of the fourth meter, named here so a later lap reads it as a known edge rather than a surprise.

### `20260821.014514` -- the fold-K live edge folds as fold L lands and the fourth meter opens

**Walk-back nib:** `c352a3b7ee` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when the run-telling had just folded stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for **fold K** and the bullet naming the finding that outweighed it, folded into the condensed-pointer line beneath them, and the **Now** block rewritten from the crux fold L just closed to the crux the new meter names. Roughly a screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** fold K's full accounting as it was written -- `tell_desist_runs` standing in eight rungs at fifty lines apiece with the nesting depth identical across all eight, so only the pair of words naming which plan each column reports varies; the nine symbols widened by one word each and the tenth in the desisting rung; the carried printing falling 2,932 to 2,686 and the ceiling tightening to 2,800; and the one raw reach the harness names rather than hides, four levels below `abandoning_of`. Beside it stands the first statement of the wider finding -- that `stand_taking_and_returning_reach` and `run_dependent` between them carried more than six folds had spent. Fold L closes the first of those two, and the fourth meter now names all 698 carrying families by measurement, so the card need no longer remember any of them by hand. Both accounts live on in `session-logs/20260821-010702_caravan-ladder-fold-k-and-the-carry-that-was-not-spent.kyri` and the fold sections of `caravan/README.md`.

**What the departing Now got right, and how far short it fell:** it named `stand_taking_and_returning_reach` at 42 of 44 rungs and thirty-five lines apiece, and the fold found the body byte-identical at forty-four lines with no mask needed at all -- the estimate was honest and conservative. What it could not name is the room the number sits in: the whole-body reading across every name finds **142,850 carried lines**, where the printing window it had been reading reports 2,686. That gap is why the new meter exists.

### `20260821.010702` -- the fold-I and fold-J live edges fold as fold K lands and the carry proves unspent

**Walk-back nib:** `6f976f31d9` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when the whole staircase had just folded stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullets for **fold J** and **fold I**, folded into the condensed-pointer line beneath them so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly two screenfuls fall away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of **fold J** as it was written -- the seven rungs from thirty-four lines to a hundred and eleven whose length looked like content, revealed under a pair-and-depth mask as one thirty-five-line sequence in strict prefix order, and the discovery that the depth needed no counting at all because every rung already publishes one named reach per tier it wraps, those reaches forming an exact triangle of eleven, ten, and five. That reasoning -- a rung's share **derived** from the accessors it declares rather than kept in a hand-maintained list -- is REDS %102's lesson applied at design time, and it is the single most transferable idea this fold arc produced. Beside it stands **fold I**, whose whole cost came to zero widening because folds F and G had already published every accessor it reached. Both accounts live on in `session-logs/20260821-005102_caravan-ladder-fold-j-the-staircase-and-the-accessor-already-born.kyri`, `session-logs/20260821-002546_caravan-ladder-fold-i-the-staircase-the-accessors-already-reached.kyri`, and the fold sections of `caravan/README.md`.

**One correction the departing card carried:** its closing claim that *the staircase is spent* read a subset in the voice of the whole. Six folds all lived inside the `tell_` family; asking the masked question of every printing body found `stand_taking_and_returning_reach` carrying 1,435 lines across 42 of its 44 rungs at one hash. The claim is corrected in the same commit that folds this card, and the corrected reading is what the new Now stands on.


### `20260821.005102` -- the fold-G and fold-H live edges fold as fold J spends the staircase

**Walk-back nib:** `bbc07cff0c` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when the staircase's first half had just lifted stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullets for **fold H** and **fold G**, folded into the condensed-pointer line beneath them so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly two screenfuls fall away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of **fold H** as it was written -- the mask that found eight twins no hash could reach, the six symbols widened by one word in each of eight rungs, and the parity proven on printed output because byte-identity had run out -- beside **fold G**, which spent the last whole body of the printing family and, by running the whole choir cold, surfaced **REDS %101** and **REDS %102**: a meter that proved itself GREEN yet stood unregistered in its choir for two laps, and a ledger spine guard proving seventy-three rows of a hundred and one while printing `verdict=ok`. Both closures replaced a hand-kept list with something discovered on disk, which is the reasoning fold J then applied at the moment of design rather than after a guard went blind. Both accounts live on in `session-logs/date/20260820/20260820-235259_caravan-ladder-fold-h-the-mask-that-found-eight-twins.kyri`, `session-logs/date/20260820/20260820-233406_caravan-ladder-fold-g-and-the-guards-that-could-not-see.kyri`, and the fold sections of `caravan/README.md`.


### `20260820.232126` -- the fold-F live edge folds as fold G spends the last whole body

**Walk-back nib:** `078135e0da` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when the reader-telling body had just lifted into the harness stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for **fold F**, folded into the condensed-pointer line beneath it so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly one screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of **fold F** as it was written -- the nineteen symbols `tell_the_reader` reaches, the eighteen that already stood public, and the nineteenth being `tidings_of`, the accessor twenty-four `inner` hops deep in one rung and six in another, widened by one word per rung rather than flattened. That widening is exactly what made fold G need none, so the reasoning is worth the walk back. The account lives on in `session-logs/date/20260820/20260820-224901_caravan-ladder-fold-f-the-reader-telling-body.kyri` and the fold sections of `caravan/README.md`.


### `20260820.224901` -- the fold-E live edge folds as fold F lifts the reader-telling body

**Walk-back nib:** `da143b789b` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when the note-writing pair had just lifted into the harness stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for **fold E** and the *prior live edge* bullet for the **printing meter**, folded together into one condensed-pointer line so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly two screenfuls fall away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of **fold E** as it was written -- the six symbols `tell_path` and `tell_outcome` reach, the 29 x 34 arithmetic that predicted 986 deletions exactly, and the three-line call each rung kept -- beside the **printing meter** lap that found the carry in the first place: 2,468 distinct printing lines standing on disk 9,317 times across 42 rungs, 6,849 already written, and the honest naming of why two elder meters could not see it. Both accounts live on in `session-logs/date/20260820/20260820-223110_caravan-ladder-fold-e-the-note-writing-pair.kyri`, `session-logs/date/20260820/20260820-221349_caravan-ladder-the-printing-two-meters-cannot-see.kyri`, and the fold sections of `caravan/README.md`.


### `20260820.220352` -- the fold-D live edge folds as the farewell rung seats

**Walk-back nib:** `1899f68b67` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when the ladder's orchestration spine had just lifted into the harness stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for **fold D**, folded into the condensed-pointer line beneath it so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly one screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of **fold D** as it was written -- the exact staircase of `close_the_quarrel` from 16 lines at `refer` to 86 at `refrain`, 106 distinct lines standing 1,003 times with 897 already written, and the one `comptime` body that took that number to zero while the byte-identical meter stood unmoved at 47. The reasoning for why option A was refused, the four movements the harness spine reads in, and the honest cost -- opening a rung no longer shows the whole correspondence on one screen -- live on in `session-logs/`, `caravan/README.md`, and the brief `active-designing/date/20260820/20260820-204641_caravan-ladder-the-spine-the-meter-cannot-see.md`.


### `20260820.204641` -- the refrain live edge folds as the ladder's spine is measured

**Walk-back nib:** `ae1754ba1a` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when a named ending had just begun to change what the plan does next stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **refrain** rung, folded into the condensed-pointer line beneath it so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly one screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of the **refrain** rung as it was written -- thirteen bytes into `plan.refrain`, the mark echoed whole with this run's own byte last, `RefrainTakenUp` reading the person rather than the plan, and the wire record `osrwsmwbyocrf` carrying eight tiers in thirteen bytes. The numbers it named -- 95 rungs GREEN cold in 323s, the carry holding at 47 across 101 modules and 1,275 checks, fold A climbing 874 to 913 -- live on in `session-logs/` and `caravan/README.md`.


### `20260820.203922` -- the respect live edge folds as the refrain rung seats

**Walk-back nib:** `d3dd720335` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when a run could name the ending it inherited and still write to the reader who made it stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **respect** rung, folded into the condensed-pointer line beneath it so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly one screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of the **respect** rung as it was written -- the run after reading the ending it inherited, the twelve bytes of the mark with every byte save one copied from outside the plan, the naming landing before the inheritance comes down, and `RespectUnended` named as the consent guard mirroring `ConcludeUnended`. The numbers it named -- 94 rungs GREEN in 344s, the carry unmoved at 47 across 100 modules and 1,229 checks, fold A climbing 835 to 874 -- live on in `session-logs/` and `caravan/README.md`.


### `20260820.200710` -- the conclude live edge folds as the respect rung seats

**Walk-back nib:** `139d350123` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when a reader's ending could be written down and no run had yet opened one stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **conclude** rung, folded into the condensed-pointer line beneath it so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly one screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of the **conclude** rung as it was written -- the ending kept where the run after it will look, the eleven bytes of the closure with every byte save one copied from outside the plan, the closure standing where the records beneath it fall, and `ConcludeUnended` named as the consent guard mirroring `AbateUnreleased`. The numbers it named -- 93 rungs GREEN in 310s, the carry unmoved at 47 across 99 modules and 1,183 checks, fold A climbing 796 to 835 -- live on in `session-logs/` and `caravan/README.md`, and REDS %99's whole lesson stands in the ledger.


### `20260820.194003` -- the abate live edge folds as the conclude rung seats

**Walk-back nib:** `286e33b7dd` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when a reader's release could move a wall and their acceptance could move nothing stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **abate** rung, folded into the condensed-pointer line beneath it so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly one screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of the **abate** rung as it was written -- the wall taken down on the word of the reader who released it, the eleven bytes of the abatement with every byte save one copied from outside the plan, the ordering that lands the record before the wall falls, and `AbateUnreleased` named as new in kind for guarding a person's word against a plan eager to mean more by it than they did. The numbers it named -- 92 rungs GREEN in 251s, the carry unmoved at 47 across 98 modules, fold A climbing 757 to 796 -- live on in `session-logs/` and `caravan/README.md`.


### `20260820.180429` -- the beckon live edge folds as the answer rung seats

**Walk-back nib:** `9e892811ce` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The card as it read when the arc had reached a person and not yet heard one back stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **beckon** rung, folded into the condensed-pointer line beneath it so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly one screenful falls away; every word stands at the nib above.

**What waits there, worth recalling:** the inline account of the **beckon** rung as it was written -- the wall carried out of the drawer only the plan opens and into the box its reader already reads, the eight bytes of the call with every byte save one copied from outside the plan, the ordering that puts the wall before the summons so a run falling between the two leaves a boundary standing and uncarried, and the reach guard seated the lap before holding on its first run over 96 modules. The numbers it named -- 90 rungs GREEN in 239s, carry 2,202 climbing to 2,669 -- live on in `session-logs/` and `caravan/README.md`.


### `20260820.171127` -- the mind, desist, and harness live edges fold as the ladder's reach rule seats

**Walk-back nib:** `ae3bc5bee3` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The ladder as it stood before the reach rule -- `desist.rye` folding two rungs down into `forbear.rye`, and the four bodies it copied from `mind.rye` -- stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullets for the **forbear**, **desist**, and **ladder-harness** rungs, plus the wall of eight prior condensed-edge lines beneath them, all folded into one condensed pointer, so the card leads with the round that just landed rather than carrying a second copy of the log index. Roughly nine screenfuls fall away; every word stands at the nib above.

**What waits there, worth recalling:** the inline accounts of the whole correspondence arc as it was written lap by lap -- the **forbear** rung handing a standing matter to a run that has not started, the third note in the arc and the only one that does not fall with the record beneath it; the **mind** rung making the run that inherits an impasse say so where the outcome is read, six bytes into `plan.mind` with every byte but the last copied from outside the plan; the **desist** rung standing a wall before the relay is stayed, so a run falling between the two hands the matter on rather than dropping a question into silence; and the **ladder harness** landing on Keaton's word as option B -- 57 bodies lifting across 30 rungs and the carry falling from 17,997 lines to 1,952. Also the clock erratum (REDS %96, %97), the Two Rooms register sweep across 514 pages (REDS %93, %94), the pier naming its own zone (REDS %90), and the reclaim, mend, heed, owe, and recount rungs, each with the number it moved named inline.


### `20260820.155932` -- the allay and forbear live edges fold as the mind rung seats

**Walk-back nib:** `09bef9a2e7` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullets for the **allay** and **forbear** rungs, folded into the condensed pointer line beneath them, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of the **allay** rung -- the reader's own five-byte reply opened where its writer left it, in `caravan/.readers/desk.rests`, and published as one byte in `plan.rest` where the settlement is read; `AllaySilent` holding that a box saying nothing is a silence and never consent. And the inline account of the **forbear** rung -- the third note in the arc addressed to a run that has not started, the only one that does not fall with the record beneath it, since the whole point is that the next run finds it; `ForbearAllayed` refusing to hand on a question already settled, which would be the prevention wearing the harm's clothes. Both rest whole in `caravan/README.md` and their own dated logs, `20260820-150912` and `20260820-153200`.


### `20260820.143646` -- the recount live edge folds as the ladder-copy fold lands

**Walk-back nib:** `b8427b4d1b` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere. The pre-fold Caravan ladder in full -- all 289,303 lines, every carried check body -- stands at this nib and every commit before it.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **recount** rung, folded into the condensed pointer line beneath it, so the card leads with the fold that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of the recount rung -- the second look receipted where only a later run of this plan looks while the reader who asked for it holds an empty box; the telling landing in `caravan/.readers/desk.knows` rather than under the plan's notes, so the outward reach is visible on the wire; `RecountUnlooked` and `RecountMismatched` refusing by name; and the planted control that printed GREEN over a box that did not exist. Beside it waits **the whole pre-fold ladder**, which is the larger thing this nib holds: 779 check bodies carried byte-for-byte over 54,612 lines, each rung's copy of every check beneath it, exactly as the arc wrote them one lap at a time. Anyone wanting to read a rung as its author left it -- or to check the fold against what it folded -- reads it here. Every word also rests in `caravan/README.md`, the design call `20260820-131713`, and the dated logs `20260820-135055` and `20260820-143646`.


### `20260820.135055` -- the reweigh live edge folds as the recount rung seats

**Walk-back nib:** `c29c698d34` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **reweigh** rung, folded into the condensed pointer line beneath it, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a run that inherits a reopened matter taking the look again -- the reopening having been permanent and ignorable at once, which is the most comfortable thing an open question can be; `ReweighUnsettled` refusing a second look to a run that has published no outcome of its own, since a supervisor with nothing to weigh the matter against would be filing a fresh answer over a question it never re-asked; the receipt naming the matter it looked at, because an older second look left standing beside a fresh matter closes a question nobody opened; the taking down being the act and the receipt only its record, so `plan.anew` lands first and `plan.again` comes down after; and looking again proven not to be deciding again, both runs settling `carried out whole`. Every word of it also rests in `caravan/README.md` and its own dated log `20260820-134309`; the checkpoint is the cheaper walk-back.


### `20260820.134309` -- the reopen and ladder-copy live edges fold as the reweigh rung seats

**Walk-back nib:** `c95d3dedca` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullets for the **reopen** rung and for the **ladder-copy meter**, folded into one condensed line, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a reader who says an answer falls short opening the matter again -- what the plan is told costing it a look it never chose to take, the first rung of its kind in the arc; `ReopenSettled` refusing to book a matter open against a satisfied reader, since doing so would punish a plan for asking and teach every supervisor never to ask at all; the note being the second in the arc addressed forward and the first whose every byte came from outside; and, beside it, the ladder-copy meter's measured numbers -- 88 rung modules, 914 check functions, 277 distinct bodies, 637 byte-identical copies over 46,014 lines, held under a named ceiling of 60,000. Every word of both also rests in `caravan/README.md`, `active-designing/date/20260820/20260820-131713_caravan-ladder-shared-harness.md`, and their own dated logs `20260820-130722` and `20260820-132327`; the checkpoint is the cheaper walk-back.


### `20260820.113447` -- the owe live edge folds as the meet rung seats

**Walk-back nib:** `fcd1d65024` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **owe** rung and the pointer bullet beneath it, folded into one condensed line naming owe, avow, deem, refer, swell, dwell, relent, heed, and endure, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a concession reaching the run that comes after it -- the debt being the only note in the whole arc written for a run that has not started, and that forward address being exactly what makes an admission cost something; `OweUnconceded` refusing to book a debt against a dissent, since booking one would turn holding one's ground into an admission of fault and teach every supervisor to concede nothing; a debt carrying two bytes, the finding conceded and the outcome it was conceded under, because a plan that said `carried out whole` while conceding owes a different look than one already reporting itself short; booking proven not to be repairing; and a debt outliving a provisioning, since one swept every morning would let a plan concede at bedtime and wake owing nothing. Every word of it also rests in `caravan/README.md` and its own dated log `20260820-111803`; the checkpoint is the cheaper walk-back.


### `20260820.111618` -- the avow live edge folds as the owe rung seats

**Walk-back nib:** `8178a12701` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **avow** rung and the pointer bullet beneath it, folded into one condensed line naming avow, deem, refer, swell, dwell, relent, heed, and endure, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a plan being made to answer the finding it published -- a run writing this note and that being the whole rung, since every record the arc reaches outward for is written by a hand the plan does not own precisely so it can never grade the objection against it; `AvowMismatched` refusing a word about some older verdict, because a plan that answered this argument before may still hold its position on a younger one; an avowal carrying two bytes with the finding echoed back exactly; answering proven not to be yielding, with concede and dissent both honest on the wire; and the probe that taught the rung its own shape, where the first cut read the finding before consulting the refusal ladder and an unheard run refused `AvowUnfound` where the ladder promised `AvowUnheard`. Every word of it also rests in `caravan/README.md` and its own dated log `20260820-105456`; the checkpoint is the cheaper walk-back.


### `20260820.105456` -- the deem live edge folds as the avow rung seats

**Walk-back nib:** `42f333eb6c` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **deem** rung and the pointer bullet beneath it, folded into one condensed line naming deem, refer, swell, dwell, relent, heed, and endure, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of the hand a case went to being read back and its finding published -- the finding read off the wire and never written by a run, since a supervisor able to author the word against it has graded its own objection; `DeemMismatched` refusing a verdict about some older argument, because a desk that has heard this argument before may still hold the answer to a younger quarrel; a finding carrying four bytes with the case echoed back exactly, so a verdict is answerable to a particular argument rather than to whatever quarrel a plan happens to hold; and a finding belonging to the hand that wrote it across a provisioning and across the plan clearing its own copy. Every word of it also rests in `caravan/README.md` and its own dated log `20260820-102945`; the checkpoint is the cheaper walk-back.


### `20260820.102945` -- the refer live edge folds as the deem rung seats

**Walk-back nib:** `4c4d3c150e` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **refer** rung and the pointer bullet beneath it, folded into one condensed line naming refer, swell, dwell, relent, heed, and the endure-appeal-tidings-repose-lapse-abide rungs below them, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a long-standing quarrel put before a hand that is neither party -- the forum read off the wire and never chosen by a run, `ReferParty` refusing a case into the box of the reader who raised it, the case copied rather than summarized because a summary is where a supervisor would shade the argument against itself, a case outliving the withdrawal of the quarrel it was built from, and the five refusals `ReferEarly`, `ReferUnaddressed`, `ReferParty`, `ReferMiscounted`, `ReferMisrecorded` each named to what it protects. Every word of it also rests in `caravan/README.md` and its own dated log `20260820-100737`; the checkpoint is the cheaper walk-back.


### `20260820.100546` -- the swell live edge folds as the refer rung seats

**Walk-back nib:** `7f69316945` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **swell** rung and the pointer bullet beneath it, folded into one condensed line naming swell, dwell, relent, heed, and the endure-appeal-tidings-repose-lapse-abide rungs below them, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a long-standing quarrel published where the outcome is read -- the bound named in the module and movable by no run, the reading taken off the wire rather than off memory, the heralding as the last act of the run after the dating whose byte it reads, and the four refusals `SwellEarly`, `SwellUndated`, `SwellMiscounted`, `SwellMisrecorded` each named to what it protects. Every word of it also rests in `caravan/README.md` and its own dated log `20260820-094007`; the checkpoint is the cheaper walk-back.


### `20260820.094007` -- the dwell live edge folds as the swell rung seats

**Walk-back nib:** `d4f6140b85` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **dwell** rung and the pointer bullet beneath it, folded into one condensed line naming dwell, relent, heed, and the endure-appeal-tidings-repose-lapse-abide rungs below them, so the card leads with the rung that just landed rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a standing quarrel finally saying how long it has stood -- the age surviving a provisioning beside the standing note and falling with the quarrel, an age that only ever climbs and holds at the bound of one byte rather than wrapping, the dating as the last act of the run mirroring the relenting's first, and the four refusals `DwellEarly`, `DwellForgotten`, `DwellMiscounted`, `DwellMisrecorded` each named to what it protects. Every word of it also rests in `caravan/README.md` and its own dated log; the checkpoint is the cheaper walk-back.


### `20260820.085311` -- the heed and endure live edges fold as the relent rung seats

**Walk-back nib:** `16ba986cc8` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **heed** rung and the pointer bullet beneath it, folded into one condensed line naming heed, endure, and the appeal-tidings-repose-lapse-abide rungs below them, so the card leads with the record this lap seated rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a plan run under a quarrel it inherited -- the settlement published word for word as it would read had nobody objected, the regard read before the record is taken up and published only at the end, this run's own reader accepting on purpose so nothing it heard itself could account for the word it published, and the wire ending `c` - `p` - `a` - `u`. Its per-rung detail rests whole in `caravan/README.md`, `caravan/heed.rye`, and the dated log `20260820-082858`.


### `20260820.060302` -- the hear live edge folds as the dispute rung seats

**Walk-back nib:** `581ade420e` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **hear** rung, folded into the pointer line beside the courier, amend, and recant rungs the checkpoints below it swept, so the card leads with the record this lap seated rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a correction finished when its reader answers -- the reader's box facing two ways, the plan writing `.told` and the reader writing `.said`, a run reading the second and never writing it, and an answer bound to the reading it answers so a hand naming any other reading is a different sentence. Its per-rung detail rests whole in `caravan/README.md`, `caravan/hear.rye`, and the dated log `20260820-054032`.


### `20260820.054032` -- the courier live edge folds as the hear rung seats

**Walk-back nib:** `c90bee22f7` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **courier** rung, folded into the pointer line beside the amend and recant rungs the checkpoints below it swept, so the card leads with the hearing this lap proved rather than carrying a second copy of the log index.

**What waits there, worth recalling:** the inline account of a correction carried to the reader who never comes back -- the address seated on the wire beside the reading, the delivery landing outside this plan's own wire in `caravan/.readers/desk.told`, the four refusals of the journey named one by one, and the price stated as nothing but the walk. Every word of it rests in `caravan/README.md` and in the dated log `20260820-052038_caravan-courier-a-correction-that-travels.kyri`; the departing card reads whole at `git show c90bee22f7:construction/REMEMBER.md`.


### `20260820.052038` -- the amend live edge folds as the courier rung seats

**Walk-back nib:** `ec5ee6de20` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **amend** rung, folded into the pointer line beside the recant, appraise, and bear rungs the checkpoints below it swept, so the card leads with the delivery and carries one account of this arc rather than five.

**What waits there, worth recalling:** the inline account of a settlement an operator already read being corrected where they read it -- the standing reading named as the second note a run does not clear, the amendment written to a person rather than about a phase in two bytes an operator reads straight, and the honest naming of a wire that is entirely truthful while the belief in the room says otherwise. Every word of it also rests in `caravan/README.md` and its own dated log.

### `20260820.050442` -- the recant live edge folds as the amend rung seats

**Walk-back nib:** `38dd79aff9` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **recant** rung, folded into the pointer line beside the appraise and bear rungs the checkpoint below it swept, so the card leads with the amendment and carries one account of this arc rather than four.

**What waits there, worth recalling:** the inline account of a judgment a run's own evidence disproves being taken back on the wire and repaired -- the standing appraisal named as the one note a run does not clear, the reversal riding one glyph per phase beside the judgment it undoes, and the honest price of a reversal stated as exactly one more dependent. The rung stands whole in `caravan/recant.rye`, its witness, its session log, and the Caravan README.

### `20260820.044313` -- the appraise and bear live edges fold as the recant rung seats

**Walk-back nib:** `c17b4bbcd6` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *prior live edge* bullets for the **appraise** and **bear** rungs, folded into the pointer line the `20260820.014755` checkpoint opened, so the card leads with the recantation and carries one account of this arc rather than three.

**What waits there, worth recalling:** the inline account of a plan naming the loss it would rather carry than repair -- `bear = true` beside the outcome an author already declares, the settlement gaining its third word because two were no longer honest -- and beside it the account of a loss its author left unmarked being weighed by what came home after it, the standard published at the plan and the evidence produced only by the run. Both rungs stand whole in `caravan/bear.rye` and `caravan/appraise.rye`, their witnesses, their session logs, and the Caravan README.

### `20260820.041842` -- the mend live edge folds as the appraise rung seats

**Walk-back nib:** `43cb80dd7e` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *prior live edge* bullet for the **mend** rung, folded into the pointer line the `20260820.014755` checkpoint opened, so the card leads with the appraisal and the bearing it stands on rather than three full accounts of one arc.

**What waits there, worth recalling:** the inline account of a plan reported short being run again for exactly what it lost -- the loss note written glyph by glyph beside the verdict, the repair bounded by the loss and freed of the arrangement it was written for, the price asserted at exactly one more dependent, and four refusals by name. The rung itself stands whole in `caravan/mend.rye`, its witness, its session log, and the Caravan README.

### `20260820.030732` -- the reckon and harvest live edges fold as the clock red closes

**Walk-back nib:** `cf23958a35` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *live edge* bullet for the **reckon** rung and the **REDS %95** closure bullet, folded into the pointer line the `20260820.014755` checkpoint opened, so the card leads with what is next rather than carrying a fourth copy of the arc's chronicle.

**What waits there, worth recalling:** the inline account of completion becoming a verdict a run earns -- `carried` against `short`, the plan-level note written to the wire after the last dependent is reaped and read back before the report believes it, the four refusals named, and the measurement where every number stands still while the completion claimed and never served falls from 1 to 0. Beside it, the harvest rung's own repair: readiness reaping the lowest-indexed ready dependent rather than the one whose going lets the head enter, and the honest second cause that made `idle_key_ready` the number the module can guarantee. Every word of both lives in `session-logs/date/20260820/20260820-024612_caravan-reckon-a-plan-that-lost-an-arc-is-short.kyri`, `session-logs/date/20260820/20260820-031500_harvest-reaps-the-slot-the-head-waits-on.kyri`, the **Reckon** and **Harvest** rows of `caravan/README.md`, and `construction/REDS.md`; the card kept a second copy, and that is what the fold removes. Read the departing card with `git show cf23958a35:construction/REMEMBER.md`.

### `20260820.024612` -- the reclaim rung's live edge folds into the card's condensed pointer

**Walk-back nib:** `05311de906` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- the *prior live edge* bullet for the **reclaim** rung, folded into the pointer line the `20260820.014755` checkpoint opened, so the card carries two live edges and one open red rather than a fifth copy of the arc's chronicle.

**What waits there, worth recalling:** the inline account of a conferral leaving with the dependent it was made to -- inherited reach at a successor's first breath falling from 1 to 0, the generation that made the count exact, and the rung finding its own first error by measuring. Every word of it also lives in `session-logs/date/20260820/20260820-014755_caravan-reclaim-a-conferral-leaves-with-its-holder.kyri` and in the **Reclaim** section of `caravan/README.md`; the card kept a second copy, and that is what the fold removes. Read the departing card with `git show 05311de906:construction/REMEMBER.md`.


### `20260820.014755` -- the operator card condenses its Microkernel-arc live edges to one pointer

**Walk-back nib:** `684f5ade97` -- pier and both remotes; nothing is rewritten, so this walk-back stays reachable everywhere.

**Swept:** `construction/REMEMBER.md` INNER LOOP -- eight *prior live edge* bullets folded to a single pointer line. Roughly 9 KB of prose leaves the living card.

**What waits there, worth recalling:** the full inline record of the commit-message wall (both repositories, 18 planted cases), the percent-sigil molt and its 230 mis-rendered references, the five-reds round (%88 build contention, %89 the assert message that never interpolated, %92 the choir green only on a warm tree), the Caravan `child` -> `dependent` deep debride across 3,090 re-signed commits, and the per-rung prose for the confer, revoke, taper, and unhand rungs. Every one of these also lives in its own dated `session-logs/*.kyri`, in `caravan/README.md`, and in `construction/REDS.md`; the card kept a second copy, and that is what the fold removes. Read the whole departing card with `git show 684f5ade97:construction/REMEMBER.md`.


### `20260820.005542` -- our own record numbers molt from `#` to `%`, and the commit messages are rewritten behind them

**Walk-back nib:** `f98a3e0bb0` -- **local only.** This is a *deep* debride of **commit messages**: `caravan:`-era and every other message carrying `REDS #N`, `gate #N`, `errata #N`, `OQ #N`, `study #N`, or `red #N` is rewritten and force-pushed to `origin` and `xykj61`, so this nib is unreachable on both remotes after the send. It survives on this pier alone, on `pre-percent-debride-20260820`.

**Swept:** the `#` sigil on **our own** numbering, in commit messages across the whole history -- **230 references** that fell on real pull requests `#1`-`#82` in `xykj61/grain` and therefore rendered as live links to unrelated equinox work, spread over **249 commit messages**. `PR #N` keeps its hash everywhere, because there the reference is true. **File blobs are deliberately not rewritten**: GitHub's own documentation is explicit that autolinks are never created in repository files, so historical file content was never a broken link and stays as written -- the rewrite spends itself only where the harm actually was.

**What waits there, worth recalling:** nothing but the elder sigil. The rows, the reasoning, and every three-field lesson read identically before and after; only `#` became `%`. If a future reader wants to see how the ledger cited itself before the renderer forced the question, the messages at this nib are the record.


### `20260819.232254` -- Caravan's whole `child` vocabulary molted to `dependent`, and the history rewritten behind it

**Walk-back nib:** `5f6ec40c39` -- **local only.** This is a *deep* debride: the caravan blobs and the `caravan:` commit subjects are rewritten across the whole history and force-pushed to `origin` and `xykj61`, so this nib is **unreachable on both remotes** after the send. It survives on this pier alone, on the branch `pre-dependent-debride-20260819`. Anyone wanting the departing vocabulary reads it there, or not at all.

**Swept:** every `child` / `children` in `caravan/**` and `tools/caravan_*` -- 2,067 bare `child`, 375 `children`, and the identifier family around them (`ChildSlot`, `ChildId`, `InvalidChild`, `ChildNeverExited`, `max_children`, `max_caps_per_child`, `max_peers_per_child`, `max_restarts_per_child`, `run_child`, `find_child`, `add_child`, `child_count`, `child_of`, `no_such_child`) across 93 tracked files, plus the witness file `tools/caravan_children_a1_gate_bound_witness.rish` renamed to `..._dependents_...`. The `caravan:` commit subjects in history carry the same molt. The `std.process.Child` seam is **kept** -- it is Zig's name, not ours.

**What waits there, worth recalling:** the departing word is the whole point. `child` carried a parent/offspring reading that the ring arc had already outgrown -- by `unhand.rye` and `taper.rye` a supervised process is weighed by *the line it holds*, and by `confer.rye` and `revoke.rye` its reach travels and returns on its own. That is a **dependent**, not a child. The old nib holds every sentence in the elder reading, including the README's fifty-odd ring rows written in it, if a future reader ever wants to see how the vocabulary sounded before it was corrected.


### `20260819.223443` -- REMEMBER's taper chronicle folded to a pointer as the entrust rung lands

**Walk-back nib:** `8f65552046` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/taper.rye` -- why an ordered `stand` means a child always holds a suffix of the line it was handed and a handback is therefore one number, the two-way note the child publishes and the supervisor acknowledges with both sides bounded, `TaperReversed` about direction and `TaperEmptied` about the floor and `TaperWidened` about reach, the channel joint and one-child-per-domain rule standing unchanged, the 9 pairs a silent run reads as the held reading, the 5 children and 1 carried home either way with 2 at once against 3, and the five RED paths each named. Roughly one long paragraph folded into a condensed prior-edge line.
**What waits there, worth recalling:** the departing card carries the taper rung's own honest limit in full -- that a run widens only as far as its children publish, and pays for the chance with a bounded listen at each blocked moment. That trade is the direct counterpart of this rung's own named limit, which runs the other way: an entrustment costs a bounded *wait for an answer* rather than a bounded listen, because a handback is a fact while an entrustment is an act. Read together the two limits describe the whole cost of a line that moves in either direction. Both survive in `caravan/taper.rye`, `caravan/README.md`, and the `20260819.221729` session log.


### `20260819.221729` -- REMEMBER's unhand chronicle folded to a pointer as the taper rung lands

**Walk-back nib:** `96e537f929` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/unhand.rye` -- why a line handed over is a fact about the child a run may weigh as one, `intent.rye`'s own banner naming the channel and the bell as the two reasons the room stayed at the ceiling, the supervisor's new memory of one line per live child shifted on every reaping, `UnhandUnheld` about memory and `UnhandWidened` about reach, the 48 tests at the door against 36, the 7 children and 1 carried home either way with 2 at once against 3 and 8 slots unspent against 1, the widest line reading as the ceiling across all 9 pairs, and the four RED paths each named. Roughly one long paragraph folded into the prior-edges pointer.
**What waits there, worth recalling:** the authored declaration that rung needed and the reasoning behind it -- `serial_three_clients_board.bron`, a board one client writes and its siblings read with no channel joining any of them, written because every elder declaration pairs a written shared region with a channel and the channel refusal dominates there. The departing card also carries the honest note that the narrower room costs *more* to read, which the taper rung inherits and extends.


### `20260819.215403` -- REMEMBER's understudy chronicle folded to a pointer as the unhand rung lands

**Walk-back nib:** `dafef2f30c` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/understudy.rye` -- why the door costs nothing because the arc had already separated what a child was handed from what the record says, the table's new memory of which slot each live child came from, `UnderstudyMoved` about place and `UnderstudyHomed` about time, the 19 tests against 32 and 256, the 0 turns' memory changed against 2, and the 7 places, 7 children, and 2 carried home either way. Roughly one long paragraph folded into the prior-edges pointer.
**What waits there, worth recalling:** at nib `dafef2f30c` the departing card holds the full prose for why a child in flight is judged by what it was handed rather than by what the record says -- the separation that made an understudy safe. That argument is the direct ancestor of this rung's finding, which spends the same separation one step further out: if the line a child holds is a fact about the child, then the door may weigh newcomers against that line rather than against the ceiling its whole domain was granted. Both survive in `caravan/understudy.rye`, `caravan/README.md`, and the `20260819.213726` session log.

### `20260819.213726` -- REMEMBER's replace chronicle folded to a pointer as the understudy rung lands

**Walk-back nib:** `6be544fa1e` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/replace.rye` -- the correction refused by every reading that weighs a newcomer against a record still holding the phase it replaces, the residue as the record both triples want, the danger in a residue that seats itself, the 0 places moved against 5 moved by the sequence, the 32 tests against 256, `ReplacementUnseated` earned by name, and the 1 phase corrected in a run already under way. Roughly one long paragraph folded into the prior-edges pointer.
**What waits there, worth recalling:** at nib `6be544fa1e` the departing card holds the full prose for why the gap between a withdrawal and its enlistment is dangerous precisely because it is lawful -- a record that answers every question a supervisor knows how to ask while holding neither shape. That argument is the direct ancestor of this rung's finding, which is its mirror image: a record may hold *two* shapes of one phase safely for exactly the reason the residue was unsafe holding none, since what a child was handed travels with the child and never with the record. Both survive in `caravan/replace.rye`, `caravan/README.md`, and the `20260819.211527` session log.

### `20260819.211527` -- REMEMBER's withdraw chronicle folded to a pointer as the replace rung lands

**Walk-back nib:** `0ef89d84a7` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/withdraw.rye` -- the three facts an arrival owed the plan read backwards, why exactly those three make a departure invisible downstream to `elder_waits`, `sibling_waits`, and `may_pass`, the shy reading that lets turn 4 go while turn 5 names it so turn 5 waits on nobody with nothing anywhere to report it, the departure that moves nothing, the 2 phases that left a run under way against 5 children of 7 handed whole, and the metal correcting the schedule itself with `WithdrawalStarted`. Roughly one long paragraph folded into the prior-edges pointer.
**What waits there, worth recalling:** at nib `0ef89d84a7` the departing card holds the full prose for why a run must never release a follower whose predecessor never ran -- the failure nothing reports, which is why the rung measured both readings against each other rather than asserting the difference. That argument is the direct ancestor of this rung's finding that the residue is a *lawful* plan, and therefore that a half-finished correction is exactly the state no supervisor can recognize. Both survive in `caravan/withdraw.rye`, `caravan/README.md`, and the `20260819.205940` session log.

### `20260819.205940` -- REMEMBER's enlist chronicle folded to a pointer as the withdraw rung lands

**Walk-back nib:** `9b8a62fd39` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/enlist.rye` -- the reading carrying over whole so a mid-run door needs no new refusal but a memory, the same newcomer refused by name against a record of 6 and welcomed over the 4 still waiting, the 16 tests against 256, the newcomer taking the tail so nothing already granted moves, and the honest 1 pass handed whole against 0 joined while running. Roughly one long paragraph folded into the prior-edges pointer.
**What waits there, worth recalling:** at nib `9b8a62fd39` the departing card holds the full prose for why a run must never forget what it spent -- a supervisor keeping only remaining work runs a phase twice behind its own follower with `out_of_precede` reading zero -- which is the exact argument the withdraw rung's shy reading now mirrors from the other side.

### `20260819.204716` -- REMEMBER's arrive chronicle folded to a pointer as the enlist rung lands

**Walk-back nib:** `45ae32e474` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/arrive.rye` -- an arrival as a claim about one phase costing one walk of the plan, the three facts gathered in a single pass, 6 arrivals at 96 tests against 1536 to seat the plan again, `ArrivalUnseated` answered with 0 children started, the refusal naming a real order since the same phase arriving before its waiter is welcome, and a plan grown one arrival at a time proving to be the plan written whole. Roughly one dense bullet.
**What waits there, worth recalling:** at nib `45ae32e474` the departing card holds the full prose for why a claim about one phase never needs a seating, and why an identity test -- the grown plan against the written one -- is this arc's standing way of showing a rung generalizes its elder rather than rivalling it. Both survive in `caravan/arrive.rye`, `caravan/README.md`, and the `20260819.203403` session log.

### `20260819.201448` -- REMEMBER's mask chronicle folded to a pointer as the precede rung lands

**Walk-back nib:** `9d652c6823` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/mask.rye` -- the honest shape being a set and the fear that a set is a graph, a whole turn fitting inside one `u32` so the plan closes once at the door, a full mask read as the fence and the link exactly, the observation that a turn cut inside one domain could never show the difference, the finding that the run never needs the closing at all, and the masked lap's numbers named measure by measure -- folded into the standing **Prior live edges** pointer beside its elder rungs.
**What waits there, worth recalling:** at nib `9d652c6823` the departing card holds the full prose for why a bound already named for other reasons turned a graph into one machine word, and why the closing earns its single pass by making the *pairwise* reading honest rather than by changing any admission. Both survive in `caravan/mask.rye`'s own doc comment, the caravan README's Mask section, and the dated log `20260819-200013_caravan-mask-a-turn-closes-once.kyri`; the card keeps the pointer so Now holds the live front alone.

### `20260819.200013` -- REMEMBER's fence chronicle folded to a pointer as the mask rung lands

**Walk-back nib:** `a72f696bb6` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/fence.rye` -- the prefix as the shape that fits, `after = step` read as the link exactly and `after = 0` as a phase freed of its siblings, the transitive closure held by construction so a supervisor never walks a graph, and the fenced lap's numbers named measure by measure -- together with the elder rungs' condensed roster, rewritten to lead with the fence.
**What waits there, worth recalling:** at nib `a72f696bb6` the departing card holds the full prose for why a graph is what a queue may not grow, and why one comparison suffices when a prefix already holds every prefix inside it. Both survive in `caravan/fence.rye`'s own doc comment, in `caravan/README.md`, and in the dated log `20260819-194255_caravan-fence-a-prefix-is-one-number.kyri`; the card keeps the pointer.

### `20260819.194255` -- REMEMBER's phases chronicle folded to a pointer as the fence rung lands

**Walk-back nib:** `54e2d94f10` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `caravan/phases.rye` -- the cut riding beside the Task, the link speaking about the queue rather than the document, the concurrency half needing no new word, and the three cost numbers named turn by turn -- roughly 2 KB, folded into the standing **Prior live edges** pointer beside its elder rungs.
**What waits there, worth recalling:** at nib `54e2d94f10` the departing card holds the full prose for why a cut turn needs the queue to see the cut, and why `plan_is_ordered` reads the cut once at the door rather than trusting it forever. Both survive in `caravan/phases.rye`'s own doc comment, the caravan README's Phases section, and the dated session log; the card keeps the pointer so Now holds the live front alone.

### `20260819.183640` -- REMEMBER's rolling and cohort chronicles folded to a pointer as the harvest rung lands

**Walk-back nib:** `07a88280d7` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole inline account of `rolling.rye` (reaping split from reporting, the judge-on-reap control two children deep, head-of-line admission, the same-two-turns finding named turn by turn) and the ~7 KB **Prior live edges** run-on beneath it, which carried `cohort.rye`'s derivation, `concurrent.rye`'s pair predicate, and the `inflight` / `standby` / `gap` rungs each spelled out at length. Roughly 9 KB of two run-on lines, replaced by two short pointers and the live harvest edge.
**What waits there, worth recalling:** at nib `07a88280d7` the departing card holds the full prose for why the safe reaping rule was narrower than the discipline enforcing it, the 2^n-bounded-at-256 cost reasoning for the widest-set derivation, and the account of a tail region carrying no directed flow. Every one of those survives in the module doc comments, the caravan README, and the dated session logs; the card keeps the pointer so Now holds the live front alone.

### `20260819.140253` -- REMEMBER's seven-ring boot chronicle folded to a pointer as the grant begins to do work

**Walk-back nib:** `b9e7b65507` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's inline account of all seven rings -- `capabilities` / `channels` / `regions` / `system` / `read` / `roster` / `boot` each spelled out at length, together with boot's five properties written twice over and the fidelity RED path narrated in full. Every one of those sentences now stands in [`caravan/README.md`](../caravan/README.md) as its own why-section, and each ring carries a dated log in `session-logs/`.
**What waits there, worth recalling:** the phrasing that first named W xor X crossing the argv seam *by absence*, and the account of why a half-booted system is worse than a refused one. Both survive in the module doc comments and the README; the card keeps the pointer so Now can hold the live front.


### `20260819.131316` -- REMEMBER's Microkernel-Target ring chronicle folded to a pointer as the fourth ring lands

**Walk-back nib:** `307f588750` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's per-ring inline chronicle -- `channels.rye` named rung by rung (the canonical low-then-high link, the four refusals, `may_signal` / `refusal_reason` / `degree`) and `regions.rye` likewise (its six refusals spelled out, `holders` and `footprint`, the constructor-and-door account of W xor X). The triad stands whole and green, and a fourth ring now gathers all three into one declaration, so the card keeps a pointer where the chronicle stood and refills Now with the live front.
**What waits there, worth recalling:** at nib `307f588750` the departing card holds the full prose for each ring's refusal vocabulary and the reasoning for why the negative assertions are the load-bearing ones -- two clients on one virtualiser reaching neither each other nor each other's buffers. No fact was lost: each ring carries its dated log in `session-logs/` and a durable row in `caravan/README.md`.

### `20260819.125806` -- REMEMBER's Season-G scene-read chronicle folded to a pointer as the live edge moves to the Microkernel Target

**Walk-back nib:** `784a6c3f07` -- reachable in normal history (a working-tree condense, never a history rewrite); the full departing card is one `git show` away.
**Swept:** the **Live edge** bullet's whole Season-G scene-read chronicle (~5 KB of one run-on line) -- the four selectors named inline (`scene_manifest`, `hit_test`, `region_select`, `lasso_select`), the composing reads (`selection_summary`, `selection_bounds`, `object_relation`, `scene_graph`), and the entire line family rung by rung with its stamps and GREEN notes (`line_distance` through `line_corridor_summary`, `line_pierce`, `line_cross` and its rational meeting point, `line_raycast` and its slab-method entry parameter). The family stands whole and green at 227 image modules; the live front has moved to the Lindy-priority Microkernel Target, so the card keeps a pointer where the chronicle stood and refills Now with the live arc.
**What waits there, worth recalling:** at nib `784a6c3f07` the departing card holds the complete inline prose for the scene-read and line families -- the exact-integer reasoning, the `CrossNotWhole` refusal rather than a rounded intersection, and why `line_raycast` diverges from `line_slice` exactly where a wide box swallows a narrow one. No fact was lost: every rung carries its own dated log in `session-logs/` and a durable entry in `image/README.md`.

### `20260819.104554` -- REMEMBER's three giant prose run-ons (167 KB of a 197 KB card) folded to single-stranded pointers at the line-family set-close

**Walk-back nib:** `8ab8212cd7` -- reachable in normal history (a working-tree condense, not a history rewrite); the full departing card is one `git show` away.
**Swept:** the three accreted run-on lines that had survived every prior condense -- the current **Live edge** chronicle (line 16, ~64 KB: every scene-read module named inline with its stamp and GREEN status, a second copy of the log index), the stale **Latest lap `20260813`** Season-A/HUNK snapshot (line 38, ~56 KB), and the **BUHR OPENED `20260812`** exploration bullet that had drifted *into* the custody-gates numbered list (line 99, ~47 KB). Folded to short pointers naming only the live edge and the next crux, directing to `session-logs/` and `image/README.md` for per-rung detail. The card fell from ~197 KB to under its advisory bound.
**What waits there, worth recalling:** at nib `8ab8212cd7` the departing card holds the complete inline prose for the whole Season G scene-read line and cluster family (line_distance through line_corridor_summary, the selection ladder, object_relation, scene_graph), the full HUNK Season-A opening account, and the whole BUHR intelligence-equinox exploration -- `git show 8ab8212cd7:construction/REMEMBER.md`. No fact was lost: each rung's crux, bounds, and metal-GREEN account lives verbatim in its dated `.kyri` session log, `image/README.md` carries the durable per-module entries, and the season table plus the double-seat itineraries hold the arc-level record. The condense keeps the operator card the live card of what is next, never a second copy of the log index.

### `20260818.225452` -- REMEMBER prior-nib comment wall folded to a pointer; Now reaimed at the roundness + Season G completion boundary

**Walk-back nib:** `79ec36981c` -- reachable in normal history (a working-tree condense, not a history rewrite); the full departing card is one `git show` away.
**Swept:** the ~38-line wall of dead `<!-- prior nib -->` HTML comments in REMEMBER's INNER LOOP (the whole roundness quest -- roundness_universal, roundness, hit_test, scene_manifest, euler_scene, euler_number, and every earlier shape descriptor back through regions -- each a former live edge stacked as a comment), plus the ~4,600-char roundness_universal Git-nib paragraph, folded to short single-stranded pointers naming only the newest rung and directing to `session-logs/` for the per-rung detail. The card had grown back to ~187 KB, over its advisory bound; this is the same condense the `20260818.101851` checkpoint recorded, one boundary later.
**What waits there, worth recalling:** at nib `79ec36981c` the REMEMBER card holds the complete per-nib prose for the entire roundness quest and the earlier shape-descriptor family inline -- `git show 79ec36981c:construction/REMEMBER.md`. No fact was lost: each rung's crux, bounds, and metal-GREEN account is preserved verbatim in its dated `.kyri` session log, and `image/README.md` carries the durable per-module entries. The condense keeps the operator card the live card of what is next, not a second copy of the log index.

### `20260818.101851` -- REMEMBER Now condensed: the giant per-nib live-edge and git-nib paragraphs folded to pointers

**Walk-back nib:** `01b4c302c9` -- reachable in normal history (a working-tree condense, not a history rewrite); the full departing card is one `git show` away.
**Swept:** the two accreted giants in REMEMBER's INNER LOOP -- the **live-edge** bullet (62,361 chars, the per-nib narrative of every Season G open-media rung stacked into one line) and the **Git nib** paragraph (13,064 chars, the convolve_n edge told in full) -- condensed to short single-stranded pointers naming only the newest rung (`image/separable.rye`) and directing to `session-logs/` for the per-rung detail. Every prior rung's full account already lives in its own dated `.kyri` log; the card was carrying a second copy of the log index, exactly what the single-stranded reading (council rota item 11, read this lap) names as the tangle to decline.
**What waits there, worth recalling:** at nib `01b4c302c9` the REMEMBER card holds the complete per-nib prose for convolve_n and the whole open-media family (blur, gaussian, sharpen, edges, convolve, convolve_n, the resamplers, the font families) inline -- `git show 01b4c302c9:construction/REMEMBER.md`. No fact was lost: each rung's crux, bounds, and metal-GREEN account is preserved verbatim in its session log (`session-logs/20260818-*.kyri`), and the README module entries carry the durable per-module descriptions. The condense moves detail to where it belongs, keeping the operator card the live card of what is next.

### `20260818.030354` -- waymark file *content* debrided from all history (deep debride, force-pushed)

**Walk-back nib:** `d2b28a3e25` -- held **LOCALLY only** at the safety tag `pre-content-debride-d2b28a3e25` until git GC; no longer on the remotes after the rewrite.
**Swept:** the last place the superseded marks lived -- the **file content** of dated testimony (kept session logs, the log index, counsel prose, and the historical body of every renamed file), swapped to the living marks (DREY, FORA, WADE, LOWE, Dimeroll) across all history. The corpus fixture `tools/fixtures/flw-four-letter.txt` (which holds several marks as legitimate dictionary words, the derivation source) and the sealed registry were **protected by path exclusion**; vendored trees (`rye/lib`, `gratitude`, `vendor`) were excluded as mark-free. Every rewritten commit re-signed; `origin` + `xykj61` force-pushed.
**What waits there, worth recalling:** at nib `d2b28a3e25` (local safety tag only) every file still reads its superseded mark in prose and code, and `git show` recovers the full pre-content record. The registry (`construction/waymark-registry.bron`) holds every mark ever drawn, sealed and re-derivable (witness GREEN), so nothing canonical is lost. Recovery: `git reset --hard pre-content-debride-d2b28a3e25` locally **before GC**, or re-clone from a machine that still holds the old history.

### `20260818.003328` -- waymark filenames + commit messages debrided from all history (deep debride, force-pushed)

**Walk-back nib:** `55e684485a` -- held **LOCALLY only** at the safety tag `pre-filename-debride-55e684485a` until git GC; no longer on the remotes after the rewrite.
**Swept:** the superseded-mark tissue that the first waymark debride left in git *history* -- the dead tokens in **commit messages** (subjects and bodies across ~130 commits) and in **file paths** (232 historical paths plus 5 in the current tree, renamed to their living marks), together with the sealed registry's notes and the debride's own records. Each dead mark maps to its living successor (DREY, FORA, WADE, LOWE, Dimeroll); the five breach-announcement commits were **reworded** to living terms so no message states what a mark was renamed *from*. Every rewritten commit re-signed; `origin` + `xykj61` force-pushed.
**What waits there, worth recalling:** at nib `55e684485a` (local safety tag only) every commit message and file path still carries its superseded mark, and `git log` / `git show` read the full pre-debride record whole. The registry (`construction/waymark-registry.bron`) holds every mark ever drawn, sealed and re-derivable (witness GREEN), so nothing canonical is lost. Recovery: `git reset --hard pre-filename-debride-55e684485a` locally **before GC**, or re-clone from a machine that still holds the old history.

### `20260817.231456` -- waymark-elder debride: dead marks + 76 dead-mark logs purged (deep debride, force-pushed)

**Walk-back nib:** `d87f9d76b1` -- the last commit that still carried the elder waymark tissue whole, held **LOCALLY only** at the safety tag `pre-elder-debride-d87f9d76b1` until git GC. After the deep debride it is **no longer on the remotes** (origin + xykj61 force-pushed to the rewritten history).
**Swept:** the dead tissue of five superseded waymarks and the retired module name, from the living tree (rules, LEXICON, REMEMBER, `waymark_derive.rish`, SHRED_PREP, the eight-season doc, the Cursor twin) and from **76 dead-mark session logs** (their dedicated logs and transitional records), which were **removed rather than rewritten** and then purged from **all git history** (path removal across every commit + full re-sign, force-push). The living ladders **DREY - FORA - WADE - LOWE** and the module **Dimeroll** carry only their standing names.
**What waits there, worth recalling:** at nib `d87f9d76b1` (local safety tag only) the tree still labels every site with the superseded marks and holds all 76 dead-mark logs whole -- `git show d87f9d76b1:.claude/rules/waymark-ladders.md`, `git log --oneline d87f9d76b1`. **No canonical waymark fact was lost:** every mark ever drawn is sealed and re-derivable in [`waymark-registry.bron`](waymark-registry.bron) (witness `tools/waymark_registry_witness.rish` GREEN), which is exactly why the superseded marks were harmless before this cut. Counsel dated testimony, the REDS ledger, and the earlier CHECKPOINTS walk-back rows were **kept** -- decision record, reds record, recovery markers. Recovery: `git reset --hard pre-elder-debride-d87f9d76b1` locally **before GC**, or re-clone from a machine that still holds the old history.

### `20260817.215539` -- urbit lineage DROPPED: private history re-rooted at Grain's first commit (deep debride EXECUTED, force-pushed)

**Walk-back nib:** `00d7eaff2d` -- the full **38,387-commit** urbit-descended history, held **LOCALLY only** at the safety tag `pre-urbit-drop-00d7eaff2d` until git GC. **It is no longer on the remotes** (origin + xykj61 were force-pushed to the rerooted history `c7b5e614c5`).
**Swept:** the inherited **urbit/urbit + vere lineage -- 35,486 ancestor commits** before Grain's own fork commit `2383c13c` (*"veganreyklah2 content over urbit/urbit history"*). The private history was re-rooted at `2383c13c` (made parentless via graft + `filter-branch --commit-filter git commit-tree -S`), the **2,901 kept Grain commits were all re-signed** (1,774 previously unsigned now signed), tree byte-identical (`f7b6e7e4ca`), then `origin` and `xykj61` force-pushed. **Every clone must re-clone or hard-reset.** Keaton's explicit word; he accepted the re-clone (no dependents).
**What waits there, worth recalling:** at nib `00d7eaff2d` (local safety tag only) the full urbit-descended history reads whole -- `old/` and `vere/` snapshots, every urbit commit and merge. Gratitude to Urbit **survives in the living tree** at `gratitude/Urbit.md` + `gratitude/grain-lineage/` and the honest root-commit message. Recovery: `git reset --hard pre-urbit-drop-00d7eaff2d` locally **before GC**, or re-clone from a machine that still holds the old history. Decision + reframe: [`../.claude/rules/urbit-reframe.md`](../.claude/rules/urbit-reframe.md).


### `20260817.173615` -- Five breach molt debride renames queued (prep, no cut yet)

**Walk-back nib:** `27e1916049`
**Swept:** *nothing yet* -- planted ahead of five newly approved breaches so each keeps its walk-back before it cuts. Four are **waymark redraws** to the living marks (same ladder, same goals, chosen on Keaton's word and reserved in the derive exclude): **DREY** (`season-a-mikrophone-forgetful-capture`, idx 1189), **FORA** (`constel-local-test-constellations`, idx 1594), **WADE** (`dimeroll-hr-and-accounting-entities`, idx 5141), **LOWE** (`cion-molt-living-mutants-and-fossils`, idx 2813). The fifth is a **module rename** to **Dimeroll** (a Comlink-tendency name change, ~147 living refs). Each is a **breach molt debride** that executes as its own signed round; the largest touches ~502 living sites (its rung labels, its `tools/` witnesses, the `mikrophone/` modules, and cross-refs from Constel/Lotus).
**What waits there, worth recalling:** at nib `27e1916049` and every commit before it, the tree still labels every site with the superseded marks. Walk back with `git show 27e1916049:.claude/rules/waymark-ladders.md` or `git log --oneline 27e1916049`. New draws seated in `tools/waymark_derive.rish` (seated-draws comment + exclude) and `.claude/rules/waymark-ladders.md`; retirement noted in `context/LEXICON.md`, `construction/REMEMBER.md` open doors, and `active-designing/date/20260816/20260816-205859_double-seat-expansion-eight-seasons.md`.

### `20260817.172514` -- REMEMBER Prior Git nib stack condensed (the code-edge trail folded to a pointer)

**Walk-back nib:** `d7e7694385`
**Swept:** the verbose `Prior Git nib` / `Older Git nib` / `Oldest Git nib` stack in `construction/REMEMBER.md` (lines 38-209), 81 giant per-nib paragraphs the loop had appended one lap at a time, condensed to a single pointer. The current `Git nib` (line 21, the loop's living code edge) and the lean `<!-- prior nib -->` HTML trail (the seven most recent, lines 23-36) both stay; the live status lines below (Host, crypto refinements, decision wave, latest lap) are untouched. Done on Keaton's word so the card stays single-stranded.
**What waits there, worth recalling:** at nib `d7e7694385` and every commit before it, the full stack reads whole -- `git show d7e7694385:construction/REMEMBER.md`. Every prior living-edge nib it named (the whole Season G image walk -- scrubber, text_subtitle, text_panel, shape, text_caption, text_reel, and dozens more) is a real commit recoverable by `git log --oneline`, and each rung has its own dated log in `session-logs/`. The trail moved to where git already keeps it.

### `20260817.171714` -- REMEMBER Today arc condensed (the done-work wall folded to a pointer)

**Walk-back nib:** `bff58996b3`
**Swept:** the `## Today 20260811 -- a full arc` section of `construction/REMEMBER.md` (lines 228-306), a wall of ~160 dated done-work bullets -- 116 `LANDED`, 24 `OPENED`, 17 `COMPLETE`, 7 `CLOSED`, 5 `SEATED` -- condensed to a single lean pointer that names the big landed arcs and defers every detail to the session logs and git history. Done on Keaton's word so the operator card stays single-stranded: the live work-front, never a second copy of the log index. No other section touched; the INNER LOOP directives, the Compass Season table, Waymarks, gates, and open doors all stand.
**What waits there, worth recalling:** at nib `bff58996b3` and every commit before it, the full arc reads whole -- `git show bff58996b3:construction/REMEMBER.md`. Every bullet it held (Mandate, the Acme DX season, CION labeling, the AHOY front door and WADE surface, the Singularity, the Twilight palette, BUHR's MCP surface, the 1,024-round itinerary, TACT Journeys 1/2/4, the recursion cellar, Season A / HUNK, Constel and Testament) is also recorded in `session-logs/` as its own dated `.bron`/`.kyri` log. Nothing landed is lost; the wall simply moved to where the record belongs.

### `20260816.220634` -- work-in-progress -> crux rename EXECUTED (the breach the 20260815 checkpoint pre-planted)

**Walk-back nib:** `947c592333`
**Swept:** the `work-in-progress/` directory renamed to `construction/` via `git mv`, so the living pins (REMEMBER, REDS, CHECKPOINTS, SHRED_PREP, ROADMAP, TASKS) now sort high alphabetically as Keaton seated. A back-compat symlink `work-in-progress -> crux` is committed so the 2,000+ dated session logs and counsel that cite `work-in-progress/...` still resolve unchanged -- accrete-never-break without rewriting one dated artifact. Only the loop paths (the seed and `tools/launch-claude-season.rish`) and the living rules that name the ledgers were repointed to `construction/`; the dated-bearing ledgers kept their historical `work-in-progress` wording and resolve through the symlink.
**What waits there, worth recalling:** at nib `947c592333` and every commit before it, the tree still holds a real `work-in-progress/` directory -- every path in dated logs is literal there, not a symlink. A future full repoint of living references (dropping the symlink) would be its own ratchet round.

### `20260815.175524` -- Decision-wave breach queue: Bron->Kyri and work-in-progress->crux (prep, no cut yet)

**Walk-back nib:** `00ff3c1d27`
**Swept:** *nothing yet* -- planted **ahead** of two newly approved breaches so each keeps its walk-back before it cuts: **Bron -> Kyri** (unify the notation entirely under Kyri -- `.kyri` takes the responsibility of `.bron`; Kyri is voice - notation - *compressed receipts* - preferred Grain variant, named in gratitude after Kyrie Irving) and **`work-in-progress/` -> `construction/`** (a higher-sorting priority folder -- `construction/REMEMBER.md`, etc.; 902 files reference `work-in-progress/`, every one repointed in the rename round). Each executes as its own signed loop round; the dated `.bron` logs' deep rename stays a separate circled step under the one-clock law.
**What waits there, worth recalling:** the whole tree under the elder folder name `work-in-progress/` and the elder notation name `.bron` -- every REMEMBER/CHECKPOINTS/TASKS path, every `.bron` session log, and the pre-rename reference graph. Walk back with `git show 00ff3c1d27:work-in-progress/REMEMBER.md` or `git log --oneline 00ff3c1d27`. Decisions + flags: [`../active-designing/date/20260815/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md`](../active-designing/date/20260815/20260815-175524_rye-first-crypto-parity-and-the-decision-wave.md).

### `20260813.020035` -- Double-seat expansion breach queue (prep, no cut yet)

**Walk-back nib:** `0a074d5059`
**Swept:** *nothing yet* -- this checkpoint is planted **ahead** of a queue of four approved breaches so each has its walk-back before it cuts: the module rename to **Dimeroll** (bought `dimeroll.com`), **`.myc` -> `.kres`** (Kresfa, supersedes `.myc` + Sui Move), **council sky -> constel sky** (bought `constel.net`), and the **deep debride + seed force-push** (*initial public seed*, again -- depersonalized, `twilight/` kept). The last rewrites history and loses its own walk-back, so this nib is where the whole pre-breach tree lives.
**What waits there, worth recalling:** every module, doc, and notation under its superseded name -- the pre-rename module dir, `.myc` contracts, "council sky" prose -- plus the whole signed commit history before any rewrite. Walk back with `git show 0a074d5059:<path>` or `git log --oneline 0a074d5059`. Queue + gate flags: [`../active-designing/date/20260813/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/date/20260813/20260813-020035_double-seat-expansion-six-seasons.md).

### `20260810.160511` -- Expanding-prompts archive-fold (Option B, safe subset)

**Walk-back nib:** `663b778b38`
**Swept:** moved the **67 zero-inbound-reference** spent recursion-prompts and fusion-batons from `expanding-prompts/` (top level) into `expanding-prompts/archive/`. This is an **accrete-safe move, not a debride** -- every byte stays in the tree and in git history; nothing is deleted. Only files with zero external citations moved, so no dated testimony's links break and no dated file is edited. The 169 still-referenced spent files stay in place (their citations are load-bearing history).
**What waits there, worth recalling:** the moved files are per-round recursion-prompts and closed-arc fusion-batons -- spent working prompts, superseded by their rounds' landed work and session logs. Walk back with `git show 663b778b38:expanding-prompts/<name>` or read them at the new `archive/` path.

### `20260809.024851` -- The Compass Season living-card debride

**Walk-back nib:** `bc90f7fdb0`
**Swept:** `work-in-progress/REMEMBER.md` (471 -> ~75 lines), `THREADS.md`, `TASKS.md`, `ROADMAP.md` -- all rewritten from the elder Equinox-season e-number ladder to the four-equinox Compass Season.
**What waits there, worth recalling:** the full e-number GREEN ladder (e7-e302), the Amphora CLI log (e140-e177), the twelve RESTED nested seasons with their pointers (Equinox - Fascia - Voice - Nona - Kiln - Surface - Generator - MUR - Inner Scope - Constellation - Keeh), the guide 0-2 walk detail, and the old Open-Doors GREEN table. Every green also stands in the code and in the dated counsel; this checkpoint is the fast path to the *shape* of the old cards.

### The Haunted Mound deep debride (recorded after the fact)

**Walk-back nib:** *not preserved on the branch* -- this deep debride rewrote all 37,264 commits with `git-filter-repo` and force-pushed, so no pre-debride commit is reachable. **This is the lesson that seated the checkpoint pattern:** a deep debride that rewrites history must drop a checkpoint *first*, or the walk-back is gone. The tribute content itself was intentionally removed at Keaton's word; what a future checkpoint would have preserved is the surrounding season's card state, now readable only from local reflog if it survived (`git reflog` - dangling commits), not from the shared remotes.

---

*Leave a stone before you cut. The trail you mark today is the one you can walk back tomorrow.*
