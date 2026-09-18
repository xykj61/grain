# The bound that counted, and never measured

**Stamp:** `20260912.003734`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every claim below is a run, and the refusals are proven from both sides
**Room:** checkable
**Kin:** [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) -- [`../foundations/20260826-021732_air-the-row-that-feels.md`](../foundations/20260826-021732_air-the-row-that-feels.md) -- [`../context/TAME_CORE.md`](../context/TAME_CORE.md)
**Module:** [`../mantra/src/weave.rye`](../mantra/src/weave.rye)

## The mechanism, first

`mantra/src/weave.rye` gains one named error, `CounterPastCeiling`, and three edge
checks that return it. `from_v1` refuses a `V1Row` whose `pos` stands at or above
`max_weave_lines`, read before the line `next_pos = row.pos + 1`. `from_v2` refuses a
`V2Record` whose `next_pos` or `next_run` stands above it, each read separately.
`apply` refuses a diff whose inserts would carry `next_pos` past it, written as
`diff.inserts.len > max_weave_lines - self.next_pos` so the arithmetic is a
difference rather than a sum, and refuses an inserting diff on a weave whose
`next_run` already stands at the ceiling. Two entry asserts state the invariant the
subtraction rests on. The doc comment on `max_weave_lines` now names the second unit
it bounds.

## What the boundary was

`max_weave_lines` is `1 << 20`, and it bounded the **count** of lines. It said nothing
about the **values** those lines are named by. A position and a run are each a `u32`,
so a record could carry one line at position 4,294,967,295, pass every reading the
module had, and meet the next rise of the counter as an integer overflow.

Two sites, proven on metal `20260912` in a pen, both exit 134:

| Site | Line | What reached it |
|---|---|---|
| `from_v1` | `weave.rye:592`, `next_pos = row.pos + 1` | one `V1Row` at `maxInt(u32)` |
| `apply` | `weave.rye:1063`, `self.next_pos += 1` | a `V2Record` whose header stood at the ceiling, then one insert |

Every other malformed record this module meets is a refusal that speaks its own name
-- `V1PositionsDoNotRise`, `V2IdentityRepeated`, `V2CounterBelowLine`. These two were
the same class of blob arriving at the same edge, and they aborted the process.

## Why the ceiling on the value is derived rather than invented

A lawful weave can never carry a counter near the u32 ceiling, and the reason is the
module's own construction rather than a hope about how it is used:

- A position comes off a counter that rises **once per line**, in `apply`.
- A run comes off a counter that rises **once per inserting edit**, so at most once
  per line.
- `merge` takes the **maximum** of two counters rather than their sum, so merging
  histories cannot lift a counter above the highest either side reached alone.
- Every weave stands inside `max_weave_lines` lines, refused at every edge.

So a weave inside the line bound is inside the counter bound by construction. The
number was already true; it had simply never been written down, and a bound nobody
writes down is one nothing checks.

## The one case the line bound cannot see

`from_v1` accepts a record whose positions **rise** without being dense -- the rule is
strictly rising, and a gap breaks nothing. So a record of two rows, at positions 0 and
`max_weave_lines - 1`, lifts to a weave holding **two lines** whose counter has spent
to the ceiling. The line reading passes at two against a bound of a million; the
counter reading is the one that refuses. That is the whole reason the counter check in
`apply` is written beside the count check rather than folded into it -- they are one
bound said in two units, and the units come apart exactly here.

This case is a claim in `weave_v1_lift_witness.rye`, asserted at both halves: the
sparse lift **stands**, and the insert on it **refuses by name**.

## What is proven, and from which side

`mantra/src/weave_v1_lift_witness.rye` gains `prove_counter_ceiling_refused` -- a row
at the u32 ceiling refused, and the sparse-counter insert refused. Eleven claims, six
refusals by name. `mantra/src/weave_v2_witness.rye` gains one of the same name -- both
header counters refused apart, **and a counter standing exactly at `max_weave_lines`
welcomed**, because a bound proven only in the refusing direction cannot be told from a
bound that refuses everything.

Three mutations were planted and each bit, which is what says the checks are load-bearing
rather than decorative:

| Mutation | Witness | Outcome |
|---|---|---|
| `from_v1` ceiling check to `if (false)` | lift | exit 134 -- the original overflow returns |
| `apply` position guard to `if (false)` | lift | exit 134 |
| `from_v2` position-counter check to `if (false)` | v2 | exit 134 |

## What this does not reach

**The CLI's own disk path was already guarded, and the module's published edge was
not.** `mantra/src/store.rye` recomputes a blob's SHA3-256 digest on every read and
refuses a name that disagrees, so a hand-edited blob under `.mantra/` is caught before
`from_v1` or `from_v2` ever sees it. What this repair reaches is the module's own API
-- published to any caller, and the door a peer's weave arrives through, which is the
door `merge` exists to open.

**Whether `run` wants its own ceiling.** Both counters take `max_weave_lines` here,
which is exact for positions and generous for runs, since a run costs at least one
line. One number for both was chosen over a second constant nobody could derive more
tightly without measuring a real history.

**The two open mantra seams stand where they stood** -- `%680`'s document-versus-merge
ordering and `%689`'s trailing byte both want Keaton's word, and neither is touched here.

## The pen the repair did not reach, closed `20260912.012000`

**The module gained two refusals and its pen gained none.** The round above was cut
mid-send and stood in the stash; recovering it meant reading it again from the outside,
and from there the gap was plain. Three mutations had been planted **by hand** to prove
the new checks bite -- which proves them once, on one afternoon, for whoever watched.
`mantra_weave_v1_lift_control.sh` and `mantra_weave_v2_control.sh` held no leg for any of
them, so from the next lap forward a deleted ceiling check and a live one read the same.

**Three faults, one cause -- a widening that reached the module and stopped there.**
The wrappers did not assert the new refusal claims, so a claim that vanished would go
unheard. Their closing lines spelled the module's counts as a **copy**, and the copy was
already stale: `ten claims, four refusals` against a module printing `eleven` and `six`.
And the controls planted nothing at the new edge.

**Closed, each by the mechanism that makes the fault structural rather than careful.**
Five pen legs added -- `ceiling_removed`, `ceiling_misnamed` and `apply_ceiling` on the
lift; `ceiling_pos` and `ceiling_run` on the record, each header counter read apart since
one check standing for two is a check that proves one. All five exit **134**, which is the
original panic naming itself. Both controls now **count their own legs out loud**, declaring
`legs_expected=18` beside the phase list and `legs_ran` at runtime, and each witness asserts
the declared number -- so a leg deleted here reds rather than passing with less proof than
the run before it. Both wrappers assert the new refusals by name, and both stopped spelling
the module's counts: the closing line is now the module's own `GREEN:` sentence, read back
out of its own output, so the number lives in **one** place.

**Two mutations bitten, in the repair's own direction.** Renaming the module's ceiling
claim reds the wrapper at the new assert; deleting a pen leg and lowering the declared
count to match -- so the control itself still passes -- reds the wrapper at the tally.

## How it was found

The air rota's own touch test, read on its threshold page: *a claim of a boundary is
tested by pressing on it. If the hand passes through, the boundary was a wish.* The
hand went looking for the fence around `max_weave_lines` and found a fence around one
of the two things that number governs.

*May every bound in this tree be stated in the unit the machine actually counts in.*
