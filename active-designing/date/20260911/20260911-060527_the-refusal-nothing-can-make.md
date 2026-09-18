# The refusal nothing can make

**Stamp:** `20260911.060527`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every number below is read by
[`../tools/fixtures/e/error_member_reach_scan.sh`](../tools/fixtures/e/error_member_reach_scan.sh) and gated by
[`../tools/e/error_member_reach_witness.rish`](../tools/e/error_member_reach_witness.rish)
**Kin:** [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) - [`../foundations/20260826-021732_air-the-row-that-feels.md`](../foundations/20260826-021732_air-the-row-that-feels.md) - REDS `%519` (a plant that plants nothing) - REDS `%532` (an enumeration standing in for a population)

## The mechanism, in plain words

`tools/fixtures/e/error_member_reach_scan.sh` walks every tracked `*.rye` outside `vendor/`,
`gratitude/` and `seed/` in one awk pass. It reads a member of an `error{...}` set -- a line whose
whole content is `Name,`, with an optional trailing `//` comment -- and it reads a production,
`error.Name` or `SomeError.Name`, anywhere in authored code with comments stripped first. Then it
asks one question: which declared members carry a name that every line in this tree leaves unspoken?

`tools/e/error_member_reach_witness.rish` holds the answer under a ceiling that only falls.
`tools/fixtures/e/error_member_reach_control.sh` proves the reading twenty-three ways on miniature
sources in a throwaway pen, each planted case read and then lifted back to green.

## Why the question is worth asking

TAME states the reflex plainly: bound everything, check at the edge, fail with a named error. A named
refusal is a promise to whoever calls -- this function can decline in this particular way, so you may
switch on it and handle it. Zig enforces exactly one half of that promise. Whatever a function
returns must belong to its declared set, and the other half stays open: whether a declared member can
ever arrive. So the drift stays quiet by construction. A widening that makes a check moot leaves the
check's name standing in the set above it, and the set goes on reading like a contract.

The air row's own instruction is to close a hand around a boundary and pull. A declared member is a
boundary, and this is what pulling on 4,213 of them turns up.

## What it reads today

| Reading | `20260911` | Held by |
|---|---|---|
| authored sources | 1,965 | free -- run the scan |
| declared member sites | 4,213 | free |
| distinct member names | 1,472 | free |
| productions | 10,070 | free |
| **dead sites** -- a member every authored line leaves unspoken | **9** | **walled**, ceiling only falls |
| unreached in the declaring file | 261 | reported, gated at nothing |

The nine, by name: `MissingTagged` and `TooFewLines` in `glow/rune_shape.rye`, `TooFewLines` in
`glow/lower_named_cast.rye`, `NotBarePayload` in `glow/rune_core.rye`, `NotAShape` in
`caravan/concurrent.rye`, `PrefixPastLog` in `mycelium/fold_persist.rye`, `TooManyAlternatives` and
`UnsupportedEscape` in `rishi/src/match.rye`, and `BadShard` in `vault/shard.rye`.

## The per-file reading answers a different question

Zig names these values globally, so several modules may declare one shared vocabulary while a couple
of them produce it. `OweMisrecorded` stands in 47 Caravan rungs and is returned in two, which is one
name meaning one thing across a ladder. Of the 261 sites unreached in their own file, **165 are
Caravan's shared vocabulary**.

So the gate asks the tree-wide question -- can anything produce this name? -- and the per-file number
stays a report with its cause named. A guard that reds on a sound habit is a guard somebody turns
off.

## Three of the nine were left on purpose, fourteen months ago

`session-logs/date/20260720/20260720-032713_stoa97-token-mold-spec.bron` records the lap that made
them unreachable, in its own words: *"TooFewLines/TooManyLines/MissingTuple remain in ParseError set
(no removal); only their emission paths change -- now structural token failures map to other
existing errors. Witness scripts do not check those specific errors by name."*

That is a considered decision, written down, and correct on the day it was made. What it wanted was a
reader. Whether the set still describes what the parser can do has been an open question ever since,
and a tenth name joining the nine would have arrived just as quietly.

**The removal itself is a language-surface question and stays Keaton's.** Narrowing a public set
changes what a caller may plan for, even where the member is provably inert, and a prior hand's
recorded decision to keep them outranks this lap's tidiness. What this lap supplies is the
instrument: the decision is visible, countable, and held still.

## What pulling on the fence found in this lap's own hand, twice

**The extractor read a tenth of its subject past.** The first draft required a member line to end at
the comma, so **409 members carrying a trailing `//` comment** stayed invisible to it. Admitting them
moved the population 3,805 to 4,213 and left the dead reading exactly where it stood -- the honest
shape of that repair, and worth saying plainly.

**An inline set in a signature opened a block that stayed open.** `error{Overflow}!u32` in a function
head matched `error{`, so every capitalized member below it in the file read as a declared member.
The clause that closes it earns its place in a pen alone today: this tree writes **zero capitalized
enum members across 573 enums**, so the shape lives in the language while the corpus stays clear of
it. The control plants it in the one form where it bites -- an inline set in a *declaration*, whose
closing brace arrives much later -- and the mutation that removes the clause costs two legs.

## What it leaves for another lap

**Whether a member that IS produced can be produced by any real input.** Branch reachability is a
question for a witness rather than for a grep; this proves that some line spells the name, and stops
there.

**Whether a declined input is declined under the right name.** `glow/rune_shape.rye` answers
`MissingTuple` where a mold carries a name and stops short of its body rune, which is ahead of the
point where the parser learns which body kind was meant -- so one answer wears a name belonging to
one of the two cases it covers.

*May every fence in this tree be one a hand can find, and may the posts that hold air be the ones we
notice first.*
