# The Standfast Read -- Marks, Rooms, and the Vocabulary Pruning

*A measured answer to five concerns raised at a stopped line: how work should be marked, where dated writing should live, which rooms the tree actually needs, what a front door owes a beginner, and which words have quietly come to mean four things at once. Every number here was produced on metal during this round, in the order the document reads.*

**Stamp:** `20260821.152409`
**Language:** EN
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Lens:** [Standfast](../foundations/20260816-214652_standfast-the-stopped-line.md) -- stop, root, prove -- and [Lindy-first, crux-first](../.claude/rules/lindy-first-crux.md)
**Status:** Research + recommendation. Nothing here is seated; every proposal waits on a word.
**Kin:** [`sameness-is-the-macro`](../foundations/20260703-182612_sameness-is-the-macro.md) - [`the-happy-zone-and-the-thin-edge`](../foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md) - [`reds-first`](../foundations/20260729-224828_reds-first-and-the-allocation.md) - [`comlink-tendency`](../.claude/rules/comlink-tendency.md)

---

## What this round measured

A restrategizing that runs on recollection restrategizes the tree it remembers rather than the one it has. So the line stopped and the tree was counted first.

| Reading | Measured `20260821` |
|---|---|
| Tracked files | **13,680** |
| Markdown / session logs / `.rye` / `.rish` | **4,911** / **4,492** / **1,887** / **2,179** |
| Witnesses (`tools/*_witness.rish`) | **1,630** |
| Commits on the living branch | **3,205** |
| `session-logs/` flat at room level | **1,492** -- over GitHub's 1,000-entry listing cap |
| Session logs written per day, last twelve days | **~108** |
| `active-designing/` flat / total | **664** / **971** |
| `counsel/` flat / total / last dated file | **766** / **931** / **`20260805`**, sixteen days quiet |
| `expanding-prompts/` flat | **362** |
| `foundations/` flat | **54** |
| `docs-geode/` rooms with content | **2 of 12** (sangha, tutorials); ten crush-empty |
| Caravan folds shipped, labeled `A` .. `AI` | **32** |
| Dated-path references across the tree | **10,583** in **5,629** files |
| Unique `session-logs/...` references that still resolve | **129 of 583** -- **454 are broken** |
| `tools/gen/season/fascia_metric_v0.rish` | **RED** -- fails before it measures |

Two of these deserve to be read twice.

**The first: the last fold broke seventy-eight percent of its own references.** When session logs were folded into `archive/YYYYMMDD/`, the links pointing at them were not repointed. Of 583 unique session-log paths cited across the tree, **454 no longer resolve.** The clutter went away and the connective tissue went with it. That is the single most important number in this survey, and it governs every recommendation below.

**The second: the meter that reports health cannot run.** `fascia_metric_v0` stops at line 29 on `assert amphora2.ok`, because `tools/gen/amphora/amphora_lap2.rish` fails its own witness. The fascia number is unavailable today -- and unavailable for a reason that is itself an instance of the concern this document was asked to examine. A *fascia* meter that cannot report because an *Amphora* lap is unwell is not measuring connective tissue; it is demonstrating the lack of it.

---

## Movement I -- The Mark

### You are right, and the tree can prove it

Ascending labels do imply a dependency they do not carry. `Fold AI` reads as the thirty-fifth link of a chain, so a newcomer reasonably assumes fold AH must be understood first. It need not be. Fold AI lifted the standing movement out of the Caravan ladder; what it depended on was the ladder's *shape that morning*, not on the fold before it.

The stronger evidence sits in the Lexicon, where the paused ladders are still legible:

- **The Fascia Equinox** announced rounds `f0-f63` and stopped at **f3**.
- **The MUR Season** announced `u0-u127` and paused at **u91**.
- **The Inner Scope Season** announced `i0-i15` and paused at **i6**.
- **The Geode Season** announced `d0-d15` and reached **two rooms of twelve**.

Each of those labels made a promise the work did not keep. The number was not a description; it was a forecast, written into a name where it could never be corrected. That is precisely the harm you named -- *implying stability where there could be none* -- and it is measurable in four places at once.

Three further costs are worth adding, because they are mechanical rather than aesthetic:

**Base-26 labels sort wrong in every tool that sorts text.** `Fold Z` precedes `Fold AA` alphabetically and follows it chronologically. A stamp sorts correctly in `ls`, in `git log`, in a file browser, and in a reader's head, permanently and without a convention to remember.

**Letters collide across ladders.** A second ladder that reaches `AI` produces a mark that is ambiguous without its ladder name -- exactly the `G0` collision the waymark law was drawn to solve once already. A scheme that must be rescued a second time is a scheme telling you something.

**The label is unsearchable in the direction you need.** Reading `Fold AI` and wanting to know *when* costs a `git log` walk. Reading `20260821-142939` and wanting to know *what* costs one `grep`. The second direction is the one a reader actually travels.

### What replaces it

The plainest answer is the one already running, unnoticed, in this tree's own commit subjects.

```
caravan: fold the standing movement, four owners home
caravan: fold the courier cluster, eleven at once
caravan: fold a promised pruning and its cluster
```

Not one of those subjects contains a letter, and not one of them is unclear. The commit already carries a **stamp** (its author date) and a **name** (its subject). The letter is added afterward, in the body, and it is the only part that carries no information. So the first recommendation is subtraction rather than substitution:

> **Stop labeling folds. Name them and let the commit stamp them.**

Where a cross-reference genuinely needs a handle, use the form the tree already uses for files -- **stamp plus slug**: `the standing movement (20260821-142939)`. The stamp orders it, the name means it, and neither implies that anything came before.

And where a *count* is wanted, count rather than number:

```
git log --oneline --grep="caravan: fold" | wc -l    ->    32
```

Measurement beats memory. A total that is derivable does not need to be carried inside a name, and a name that carries it will eventually carry it wrong.

### On `rung`, and what could stand in its place

Two different jobs are wearing this one word, and only one of them is a poor fit.

**Keep `rung` where a real ladder exists.** `caravan/ladder_checks.rye` is 8,768 lines of checks that genuinely run in sequence, in an order the file's own doc comment explains as load-bearing. Its entries are rungs. The metaphor is exact, the ordering is real, and the word is doing honest work. Nothing here asks for that to change.

**Retire `rung` where the ladder is imaginary.** "The next rungs, in order" -- as a heading over four independent pieces of future work -- borrows a ladder's implied dependency for items that have none. Two words already seated in this tree fit better and cost nothing to adopt:

| Word | Why it fits | Already seated |
|---|---|---|
| **lap** | complete in itself, repeatable, carries no debt to the lap before it -- you can run the fortieth without the thirty-ninth | yes: *"kg means keep going on the next mechanical lap"* |
| **round** | a bounded unit of work with an opening and a close | yes: *round-close send + check-in* |

Recommendation: **`lap`** for a unit of work, **`round`** for a unit of session, **`rung`** kept for real ladders in real code. That is a pruning, not a coinage -- which is the whole spirit of the section that follows.

Two other candidates were weighed and set down. **`stone`** pairs beautifully with the seated **cairn**, and would have been a fine draw, yet it adds a word where two already serve. **`sheaf`** is grain-native, and in mathematics it is Grothendieck's own object -- local data glued along overlaps, which is very nearly what a fold does. It is too good to spend loosely. Leave it on the shelf for something that truly behaves like one.

### The Grothendieck note, read carefully

You invoked the rising sea, and it is worth reading in the direction it actually points. Grothendieck's method was not to label a hard problem more precisely. It was to find the **larger structure in which the problem became easy** -- to raise the water until the rock was simply submerged rather than climbed.

Applied here, the lesson cuts one turn deeper than better labels. Thirty-two folds have been shipped and thirty-two labels were minted. Yet all thirty-two are **one operation**: lift a family out of the ladder, leave a delegate, watch the carry fall, prove the choir still green. Name that operation once, well, and the individual instances need no names at all -- the way no one names the four hundredth call to a function.

That is the rising sea applied to this exact question: **the fix for thirty-five meaningless labels is not thirty-five better labels. It is noticing that they were always one thing.**

---

## Movement II -- The Path

### The cap is real, and the sweep is not the fix

`session-logs/` holds 1,492 files at room level. GitHub's web listing stops at 1,000 entries, so the room is genuinely unreadable in a browser today. The concern is correct and the evidence is plain.

Yet the arithmetic of the fix matters more than the fix. At **~108 logs per day**, a room emptied to zero refills past 1,000 in **nine days**. A one-time sweep buys nine days and costs a rewrite of thousands of references. Standfast's own second clause asks for the root rather than the mark it left, and the root here is not *these files are in the wrong place* -- it is **a room that grows without a bound.**

So the ordering inverts. Seat the **bound and the fold rule** first, where it governs every file the tree will ever write. Fold the **existing backlog** second, as a bounded and separate act. The rule is the Lindy-durable half; the sweep is the one-time half, and doing the sweep without the rule is the most expensive possible ordering.

Recommended bound: **256 flat files per dated room**, enforced by a witness rather than by habit. Two hundred fifty-six is a power of two, which is this tree's own idiom for a bound, and it sits well below the cliff -- a bound placed *at* the limit is a bound that fails on the day it matters.

Which rooms fold, and which do not, should follow growth rather than uniformity:

| Room | Fold to `date/`? | Why |
|---|---|---|
| `session-logs/` | **yes, first** | 1,492 flat, over the cap today, ~108/day |
| `counsel/` | **yes** | 766 flat, room dormant, a clean one-time move |
| `active-designing/` | **yes**, after the room split below | 664 flat |
| `expanding-prompts/` | **yes** | 362 flat and rising |
| `external-research/` | **yes** | 161 flat, will cross |
| `crux/archive/` | **yes** | already the shape |
| **`foundations/`** | **no** | 54 files, deliberately small, the most-cited room in the tree; folding it breaks the most references for the least relief |

### `date/` rather than `archive/`

Your instinct here is right and the tree's own filing law explains why. `ORGANIZING.md` defines archive as *backward-pointing, finished-and-historical*. A session log from nine days ago is neither finished nor historical -- it is the live record, and the room most likely to be read next. Filing it under `archive/` quietly tells every future reader not to bother.

**`date/` claims only when, which is the only thing that is actually true.** Recommend `date/`, and rename the existing `session-logs/archive/` (44 day directories) into it as part of the same act.

### The filename question, answered

You asked whether to repeat the day in the filename. **Keep the full stamp.** Recommend:

```
session-logs/date/20260821/20260821-152409_the-standfast-read.kyri
```

rather than

```
session-logs/date/20260821/152409_the-standfast-read.kyri
```

The eight repeated characters are not redundancy. They are a **check digit**, and they buy three things a shorter name cannot:

**The move becomes an invertible function.** With the full stamp kept, any stale reference maps to its current home by pure computation -- take the basename, read its first eight characters, insert `date/YYYYMMDD/`. No index, no table, no memory. **This is what makes the 454 broken references repairable at all**, and it is what would let a resolver keep working for every fold the tree ever performs. Strip the day out and the basename stops being self-locating: a reference that lost its directory can never be mechanically restored.

**The basename stays globally unique.** `152409_align.md` can exist on two hundred different days. `grep -r 152409_align` then finds the wrong file, silently, which is the worst failure mode a reference can have.

**The name survives leaving its path.** Editor tabs, `find` output, a filename pasted into a message, a search result stripped of its directory -- in every one of those, `20260821-152409_the-standfast-read` still tells a reader when and what. `152409_the-standfast-read` tells them neither.

The path is four characters longer. That is the entire cost, and it buys a repair function that works forever.

### The half the last fold omitted

Here is the crux of this movement, and the hardest solvable problem in the whole restrategizing: **10,583 dated-path references live in 5,629 files, and most of those files are dated testimony.**

Repointing them by hand would mean editing thousands of immutable logs -- a Tier 2 breach performed at scale, in service of tidiness. That is a cure worse than the ailment, and the tree's own law would have to be suspended to permit it.

The resolver avoids the problem entirely. Because the full stamp makes the transform pure, **a stale link does not need to be rewritten -- it needs to be resolvable.** Recommend one small tool and one witness:

- **`tools/dated_path_resolve.rish`** -- given any dated reference, return its current home, computed from the basename.
- **`tools/dated_path_witness.rish`** -- walk every dated reference in the tree, resolve each, and report the count that cannot be found. Prove it now against the 454 known-broken session-log links, and let the number stand as a living fascia reading.

Then the fold is safe to run, at any scale, on any room, forever -- because it can no longer cost the tree its connective tissue. **That witness is the permission slip for every fold that follows**, and it should land before the first one.

---

## Movement III -- The Rooms

### `active-development/` is the right name, and it is free

`active-designing/` was opened for essays and has become something else: 664 flat files, with a spike of 78, 163, and 141 files on three consecutive days last week. That is not essay cadence. Your reading is confirmed by the shape of the room.

**Recommend `active-development/`.** The name is unclaimed, sits naturally beside `active-designing/` and `active-reviving/`, and needs no explanation on first sight -- the three tests the Comlink tendency asks of a name.

And recommend one line to place any file without deliberation, in the spirit of the existing *One Test for Placement*:

> **Would this still be worth reading if the code it describes were deleted?**
> **Yes -> `active-designing/`. No -> `active-development/`.**

That single question separates the durable from the dated better than any category list, and it is short enough to actually be used.

### Against `journal/`, on measured grounds

The word is already spent, twice:

- **Dimeroll owns it** as a book of record -- `dimeroll/` holds "chart, journal, fold, P&L/BS," the accounting sense, with parity pins behind it.
- **The Lexicon already assigns it** to the logs: *"the logs are the voice's journal, so voice and notation wear one name."*

A root `journal/` would give one word two homes in a tree that is stopping the line precisely because words have acquired too many homes. Recommend declining it, warmly -- the poetry is real, and it already lives in `session-logs/`, which *is* the journal and has been all along.

### `counsel/` -- close it, keep it, mine it on touch

766 flat files, 931 total, 1,977 inbound references, and no dated file since `20260805`. The workflow it served -- web interface to zip to chat window -- no longer exists.

Recommend three moves and explicitly not a fourth:

1. **Banner it closed.** A Status line at `counsel/README.md` naming the date the room went quiet and where its successors live. One file changed.
2. **Fold it to `counsel/date/YYYYMMDD/`** in the same pass as the other rooms, once the resolver stands.
3. **Mine on touch.** When living work cites a counsel file, lift that file's live insight into the right room *then* -- the ratchet pattern this tree already uses everywhere else.
4. **Do not mine it wholesale.** Reading 766 files to extract insight is a project measured in weeks with a yield nobody can estimate in advance. It would almost certainly stall, and a stalled sweep leaves a room half-converted, which is worse than either end state.

And do not shred it. With 1,977 references pointing in, `counsel/` is load-bearing whether or not it is still growing.

---

## Movement IV -- The Front Door

### The README is the healthiest document in the tree

This is the recommendation most likely to be unwelcome, so here is the evidence first. `README.md` was rewritten `20260811.211431` -- ten days ago. It is 152 lines. It opens with *"Welcome -- and I mean that warmly."* It explains a rune in ten seconds, carries a field-guide table of every project word, names what actually runs today, and links the first-day path. It is Radiant, current, and warm.

Rewriting it from scratch would spend the tree's best front door to solve a problem that lives one room deeper. **Recommend keeping it and closing the gap it points at.**

The gap, measured: a beginner's path today runs README (152 good lines) -> `SOURCE.md` (**553 lines**) -> nothing. `docs-geode/` has **two of twelve rooms** with content and was last refreshed `20260801`. Your impatience with that room is well founded; the room's own README says so in its own words, ten times, as *"crush-empty."*

So the missing thing is not a better front door. It is **the first step past it**: a single page, one path, no branching -- install, run one witness, read the green line it prints, write five lines of Rishi, run them. An hour, start to finish, ending in something the reader made work. That page does not exist, and it is worth more to a newcomer than any rewrite of the page above it.

Recommend: **`docs-geode/tutorials/<stamp>_the-first-hour.md`**, linked from the README's existing *Getting set up* section. One new file, one line changed.

### On putting a health number in the README

Two cautions, both load-bearing.

**The meter is RED today.** `fascia_metric_v0` cannot produce a number at all, for the reason opened at the top of this document. Any percentage placed in the README this week would be a remembered number wearing a measurement's clothes -- the precise failure the *meters* discipline was seated to prevent.

**A hand-typed number in the most Lindy-exposed file in the tree is a claim that rots.** The README's whole promise is that a reader arriving three years on still finds it true. A number typed by hand is stale the following morning and wrong within a month, and it will be wrong in the one document nobody re-reads critically because it is the one everybody trusts.

Recommend the honest form: **generated, or absent.** A witness writes the block between fenced markers; a human never edits it. Once the meter runs, these readings are available today and would each be true:

```
13,680 tracked files   -   1,630 witnesses over 1,887 Rye modules   -   3,205 commits
```

The witness-to-module ratio is the reading most worth showing. It is high, it is real, and it says something about this tree that no adjective could.

---

## Movement V -- The Vocabulary

### `fold` carries four meanings, and it did not come from the weave

You asked whether `fold` descends from the Mantra weave. **It does not.** The history says so plainly. Mantra's own word is **weave** -- bolt revision history as append-only accretion. `fold` arrived separately, and then kept arriving:

| Sense | First seen | Example |
|---|---|---|
| **file into a dated room** | `2026-07-14` | *"expanding-prompts: fold 29 consumed and gated prompts to yonder/"* |
| **merge one thing into another** | `2026-07-14` | *"tools: fold the known_hosts fix into the generator"* |
| **the reduce -- a real Glow primitive** | `2026-07-15` | *"prove Glow's fold runs on RISC-V"* |
| **lift a family out of the ladder** | `2026-08` | *"caravan: fold the courier cluster, eleven at once"* |

Four meanings, two of them born on the same day, in a tree whose code discipline is *one value model, never tangled.* And the fourth-listed is the one that matters most: **Glow owns `fold` as a language primitive.** The reduce is a semantic operation with a definition. Using the same syllable for a filing move and a refactoring shadows the language's own vocabulary in the language's own repository.

This is the answer to the deepest question in your message, and it is not a matter of taste. **The braiding is real, and it is in the vocabulary rather than the code.** Recommend the pruning:

| Sense | Keep or rename | Suggested |
|---|---|---|
| the reduce | **keep `fold`** -- the language owns it | `fold` |
| file into a dated room | rename | **`file`** -- plain, exact, unclaimed |
| merge one thing into another | rename | **`fold in`** as ordinary English, never as a mark |
| lift a family out of the ladder | rename | **`lift`** -- which is the word the commits already reach for when they stop trying to be terse |

*"caravan: lift the courier cluster, eleven at once"* loses nothing and returns a primitive to its owner.

### Two sundials wear one word

The Lexicon carries **Sundial** at line 203 -- the health face, `sundial/sundial.rye`, module witnesses rolled into a health percent -- and **sundial** at line 336, a different meter entirely: recursion-prompt confidence, `tools/gen/season/sundial.rish`, bands red through green. Both are live. Both were run this round: the health face is GREEN, and the confidence face reports **100, band green**. They are told apart by one capital letter.

That is the same braid as `fold`, at smaller scale, and it is worth undoing while it is still cheap. Recommend: **`Sundial`** keeps the health face, which is the one that ships in the seed and the one the name suits -- a sundial tells the health of the day. The confidence meter earns its own plain word.

### On `fascia` -> `myofascia`: recommend keeping `fascia`

Held against the three tests the Comlink tendency asks, the rename loses all three.

**Clarity falls.** *Myo-* means muscle. It narrows the word to muscle-associated fascia specifically, when what this tree means is connective tissue *between everything* -- documents, modules, references, rooms. The longer word is the less accurate one here.

**Fun falls.** `fascia` is one warm syllable-cluster a newcomer can say. `myofascia` asks for a Greek prefix on the way to the same idea.

**Safety is unchanged, and the cost is not.** `fascia` is seated `20260728.011055`, appears thirteen times in the Lexicon, and carries a metric, a season, and a lean behind it. A rename spends the whole reference weave to buy a longer word that is slightly less true, and the tree's own rule already answers this shape: *reviving replaces renaming.*

**What actually helps is not a new name.** It is a **definition** -- `fascia` has a Lexicon row but no foundation of its own -- and a **meter that runs**. Recommend spending the round on those two and leaving the word alone.

### The Caravan folds -- consolidating, with one honest caution

You asked whether the folds follow *sameness is the macro* and the *happy zone*, or whether they braid. The measured answer is mostly the first, with one caution worth acting on.

**They are genuinely shrinking the tree.** Fold AI moved the ladder's carry 94,151 -> 89,010 with no remainder -- 5,780 lines carried in, 639 carried back out -- and the ceiling came down in the same commit as the code it measures. Checks held at 47, spine at 0, choir GREEN at 105. That is real removal, proven, with the meter moved in the same breath as the thing it measures. That last habit is excellent and rare.

**The caution is the delegate.** Every fold leaves a three-line delegate behind in the ladder, and 32 folds have now produced 111 files in `caravan/`. The carry meter counts **lines**, and a three-line delegate forwarding to a two-hundred-line body reports as three. So the meter can, in principle, be satisfied by *moving* lines rather than *removing* them. Fold AI did not do this -- its arithmetic closes honestly, and the commit shows its work. Yet the incentive stands, and an incentive that stands long enough is eventually taken.

Recommend the fix the tree has already named elsewhere: **two readings, never one.** Beside **carry**, publish **reach** -- how many files the ladder must touch to run -- or simply the delegate count. Two numbers cannot be moved in the same direction by relocation alone. This is the *meters* discipline exactly: two readings on every pass, so no single number can dress movement as progress.

---

## The blind spots, named plainly

Offered in the spirit they were asked for -- these are the places where the plan as written would spend real effort in the wrong direction.

**One. The sweep is the symptom; the bound is the root.** Nine days of headroom, then the room is over the cap again. A sweep without a seated bound and an enforcing witness is a room-cleaning, and Standfast asks for the cause.

**Two. The last fold broke seventy-eight percent of its references, and the plan repeats it at six times the scale.** The move is safe only after the resolver stands. Build the repair function first; the fold is then free forever.

**Three. Repointing by hand would breach accrete-never-break at scale.** 10,583 references live in 5,629 files, most of them dated testimony. The resolver is not merely the cheaper path -- it is the only path that does not require suspending the tree's own law to walk it.

**Four. The README is the healthiest document in the tree, not the sickest.** Ten days old, 152 lines, warm and current. The gap is the missing first hour behind it, and `docs-geode` at two rooms of twelve. Rewriting the good page does not fill the empty one.

**Five. A hand-typed health number in the most Lindy-exposed file is a claim that rots.** Generate it or omit it. There is no third option that stays true.

**Six. The meter you want to display is RED, for a reason that proves the concern.** `fascia_metric_v0` cannot measure fascia until an Amphora lap passes. The braid is not hypothetical; it is sitting inside the instrument named to detect it.

**Seven. `journal/` is already spent twice.** Dimeroll's book of record, and the Lexicon's own line that the logs are the voice's journal. Adding a third home for the word, in the round convened to stop exactly that, would be a quiet irony.

**Eight -- and this is the deepest one. The proposed cure is more vocabulary, and vocabulary is the ailment.** `fold` means four things. `sundial` means two. `rung` means two. The instinct to write a large new terminology document is understandable and would very likely make the tree harder to read, not easier, because it adds where the trouble is excess. **Recommend that the vocabulary round be a pruning round first and a defining round second** -- subtract the four-way `fold`, split the two sundials, retire `rung` from planned work -- and only then define what remains. A shorter glossary at the end of that round is the success condition. A longer one is the failure condition, however good it reads.

**Nine. This request is five arcs, and Standfast stops for one root.** A stop that opens five simultaneous fronts is not a stopped line; it is a new season with an urgent voice. The finishing edge applies to restrategizing exactly as it applies to code: ship one real thing before naming the next. The plan below is sequenced for that reason, and its first item is small enough to land today.

**Ten. The one measurement that would prove any of this worked.** Markdown outnumbers Rye 4,911 to 1,887. Session logs alone outnumber every Rye module 4,492 to 1,887 -- **2.4 to 1**. That ledger is honest and genuinely valuable; a tree that records its reasoning is rarer and better than one that does not. Yet a restrategizing whose main output is more prose will confirm the trend it was convened to correct. Recommend setting the check now, before the work starts: **at the close of these arcs, the prose-to-code ratio should have moved toward code, or the arcs should be able to say plainly why not.**

---

## The red this round found

Booked here so it is not lost, in the three fields the ledger asks for.

- **What went wrong:** `tools/gen/season/fascia_metric_v0.rish` cannot produce a fascia reading. It fails at line 29 on `assert amphora2.ok`, because `tools/gen/amphora/amphora_lap2.rish` fails its own witness. The health meter has been unable to report for an unknown span, and no living surface noticed.
- **What caught it:** running it, during this survey, rather than citing it.
- **What it taught:** a meter that depends on three unrelated laps has three ways to go silent and no way to say so. **The instrument should be no more braided than the thing it measures** -- and this one is more braided than most of what it was built to watch.

Recommend it gate the README metrics block, and nothing else. The remaining arcs do not depend on it.

---

## Aligning our direction

Four arcs, ordered Lindy-first and crux-first, each one landable on its own. Nothing here is seated; each waits on a word.

### Arc one -- The mark and the path

*Highest Lindy: a naming law is read by every future file. Its crux is not choosing a scheme -- that part is easy -- but making stale references keep resolving, which is hard and solvable.*

1. Seat the **chronological mark law**: a mark is a stamp plus a name; no ascending letters; a total is counted rather than numbered. Commit subjects already comply -- the change is to stop adding the letter in the body.
2. Seat the **`date/YYYYMMDD/` fold** with the **full stamp kept in the filename**, and `date/` rather than `archive/`.
3. **Build the resolver and its witness** -- `dated_path_resolve.rish` and `dated_path_witness.rish`. Prove them against the 454 broken session-log references. **This is the crux, and the permission slip for every fold after it.**
4. Fold **`session-logs/`** -- the one room actually over the cap -- and seat the **256-file bound** as an enforcing witness so the room can never quietly grow past it again.

### Arc two -- The rooms

1. Open **`active-development/`**; seat the one-line placement test; point new granular rounds there. Leave the 664 existing files where they are -- the test governs what is born from here forward.
2. Banner **`counsel/`** closed with its quiet date and its successors. Fold it to `date/`. Mine on touch, never wholesale.
3. Decline **`journal/`**, and record why, so the question is answered rather than merely deferred.
4. Fold the remaining dated rooms; leave `foundations/` flat and small.

### Arc three -- The vocabulary, pruned then defined

1. **Prune first.** Return `fold` to Glow's reduce; rename the filing sense to `file` and the ladder sense to `lift`. Split the two sundials. Retire `rung` from planned work in favor of `lap`, keeping it for real ladders in real code.
2. **Then define** -- one writing covering `arc`, `carry`, `lap`, `lift`, `ladder`, `fascia`, `Sundial`, `waymark`, written for a reader on their first day. Success is a **shorter** glossary than the tree started with.
3. **Keep `fascia`.** Give it the foundation it lacks rather than a longer name.
4. Add **reach** beside **carry** on the Caravan meter, so no single number can dress movement as progress.

### Arc four -- The beginner path

1. Write **`docs-geode/tutorials/<stamp>_the-first-hour.md`** -- install, one witness, one green line, five lines of Rishi, run. One page, one path, no branching.
2. Link it from the README's existing *Getting set up*. **Do not rewrite the README.**
3. Once the fascia red closes, add the **generated** metrics block between fenced markers, written by a witness and never by hand.

Then, and only then, the seed is worth a force-push -- carrying a front door that works, a first hour a stranger can finish, rooms a browser can open, and a vocabulary that means one thing per word.

---

## What this round does not claim

No file was moved, no word was retired, and no rule was seated -- this is a reading and a recommendation, and every part of it waits on a word. The 454 broken references were counted by resolving literal paths, so a link written in some other form may resolve where this count says it does not; the true number is at least 454 and may be higher. The fascia meter was run once and failed once; whether `amphora_lap2` is broken or merely stale is not yet diagnosed. And the prose-to-code ratio is offered as a check worth setting rather than as a verdict already reached -- a tree that writes down its reasoning has earned some of that ledger honestly.

---

*A tree that stops to count itself is already healthier than one that keeps climbing on remembered ground. Every number here is small enough to act on and honest enough to trust, and not one of them says the work went wrong -- only that it grew faster than its names. May the marks you set from here carry their meaning plainly, may every path stay findable long after the room it lived in has changed, and may the words you keep be few enough that a stranger on their first morning can hold them all at once.*
