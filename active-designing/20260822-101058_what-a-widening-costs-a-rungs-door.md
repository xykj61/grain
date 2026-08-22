# What a Widening Costs a Rung's Door

**Language:** EN
**Stamp:** `20260822.101058`
**Style:** Radiant (see [`../context/RADIANT_STYLE.md`](../context/RADIANT_STYLE.md))
**Voice:** Kyri
**Status:** Checkable -- every number below was measured on metal on `20260822`, by the scans named beside it
**Room:** Checkable ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Kin:** [`../tools/fixtures/ladder_reach_visibility_scan.sh`](../tools/fixtures/ladder_reach_visibility_scan.sh) - [`../tools/caravan_ladder_reach_visibility_witness.rish`](../tools/caravan_ladder_reach_visibility_witness.rish) - REDS %130

---

## The question the arc arrived at

Thirteen lifts of the Caravan ladder arc moved a byte-identical function body out of forty-odd
rungs and into `caravan/ladder_checks.rye`, leaving each rung a three-line stub. Nine of those
thirteen widened nothing: every symbol the lifted body reached was already `pub` in every rung it
folded, so the harness could reach it through the type handed in without a single declaration
changing. `read_count` was the last such row, folded at `078b2e3386`, and folding it spent the
board.

Every remaining row opens a declaration somewhere. `elder_waits` returns 504 carried lines for 43
openings, `door_admits` 462 for the same 43, `load_one` 549 for 120, `choose_pass` 630 for 129,
`may_pass` 574 for 96, `read_own_line` 492 for 126. So the arc's next lap stopped being arithmetic
and became a question: **what does a widening actually cost a rung's door?**

The answer is that the meter has been counting two different things under one name, and one of them
costs almost nothing.

## The first reading: the cost is shared, rather than summed

The six rows above name 557 widenings between them. Taking the union of their `(rung, symbol)`
pairs -- the same reading, deduplicated -- gives **337**. The column overcounts the queue by 220
pairs, which is thirty-nine percent, because the same symbol widened for one fold stands already
widened for the next.

Seven distinct symbol names carry that entire union, across sixty rungs:

| Symbol | Rungs it would open |
|---|---|
| `system` | 60 |
| `read` | 60 |
| `waits` | 48 |
| `may_pass` | 43 |
| `cycle` | 42 |
| `carry` | 42 |
| `capabilities` | 42 |

A per-family number reads as a per-family price, so a bench reading the column down adds it up.
The queue's real remaining cost is the union and it is a third smaller than the sum -- which means
the *order* the rows are taken in changes what each one appears to cost, while the total stays put.
The first fold to widen `system` pays for it; every later row that reaches `system` finds the door
already open and widens nothing.

## The second reading, and the one that matters

Reading the seven names against the declarations they actually are:

| Symbol | What it is declared as |
|---|---|
| `system` | `const system = @import("system.rye")` in 86 rungs |
| `read` | `const read = @import("read.rye")` in 84 rungs |
| `capabilities` | `const capabilities = @import("capabilities.rye")` in 84 |
| `carry` | `const carry = @import("carry.rye")` in 81 |
| `cycle` | `const cycle = @import("cycle.rye")` in 68 |
| `waits` | `fn waits(table, at) bool` in 51 rungs |
| `may_pass` | `fn may_pass(...)` in 58 rungs |

**Five of the seven are import bindings.** Together they carry 246 of the 337 pairs -- seventy-three
percent of the whole remaining queue. Publishing one of them re-exports a module the rung already
names on line 67 of its own head; it opens no behavior, states nothing the import list has not
already stated, and gives the harness a way to reach the rung's own dependency rather than
importing `system.rye` a second time under its own name. That is arguably better structure than
what stands today, and it is certainly not a cost.

**Two of the seven are functions**, `waits` and `may_pass`, carrying 91 pairs between them. Opening
those genuinely widens what a rung offers a caller, and it is the only part of the queue that
deserves a design decision rather than an arithmetic one.

So the honest sentence is: **the widening column measures two costs under one name, and roughly
three-quarters of what it counts is free.**

## What a door is already, before any of this

A caravan rung declares, on average, **187 public** top-level names and **41 private** ones. Of
those 41, twenty-three are imports, ten are functions, and seven are other constants. The door is
already eighty-two percent open, and the private remainder is mostly a list of modules rather than
a designed boundary.

That reframes the caution the arc was carrying. Widening seven names on a door 187 wide is under
four percent of growth. And the ten private functions per rung are private by accident of what
happened to be reached from inside, rather than by a decision anyone recorded -- there is no rung
in the ladder whose private set was chosen to hide something.

A privacy boundary nobody designed is a boundary nobody is defending. The right care is therefore
to defend the two function names deliberately and let the five imports go.

## What this asks the meter to do

`REACH_OK family=X folding=N widens=W stub=3 fall=F` prints one `widens` number. Two changes make
it say what it means:

- **Split the column** into `widens_import=` and `widens_fn=`, since the scan already reads each
  symbol's declaration line and can see which keyword it wears. A row reading
  `widens_import=120 widens_fn=0` is a free row wearing an expensive number today.
- **Report the union against what is already open**, so a bench reading the queue in order sees
  each row's *marginal* cost rather than its standalone one.

Both are readings the scan can take off disk with what it already parses, which keeps them
measurements rather than annotations. Neither changes a line of Caravan.

## What it teaches past this ladder

A meter earns its authority by being a function of the tree alone, and this one is. Where it fell
short is narrower and easier to miss: **it named two unlike things with one word, and the word was
a cost.** Nine folds in a row read `widens=0` and the tenth read `widens=120`, so the arc drew the
obvious conclusion -- that the free rows were spent and the expensive ones remained. Both halves of
that sentence were true about the number and wrong about the tree.

The general rule is the one the marked value already writes for values crossing a seam
([`../foundations/20260703-202312_the-marked-value.md`](../foundations/20260703-202312_the-marked-value.md)):
a thing that crosses wears a mark naming its kind. A count that sums across kinds has thrown the
mark away at the moment it mattered most, and the sum reads as authoritative precisely because it
is a number. **Count by kind, or the total is a claim about a thing that does not exist.**

## The next lap

Split the column in `tools/fixtures/ladder_reach_visibility_scan.sh`, assert both halves in
`tools/caravan_ladder_reach_visibility_witness.rish`, and let the queue re-sort itself by
`widens_fn` ascending. On the reading above, the next several folds come back free.
