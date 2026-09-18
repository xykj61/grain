# One argument, read two ways

**Stamp:** `20260912.042043` - **Status:** Landed - **Room:** checkable - **Voice:** Kyri
**Style:** Gauge, Field - **Lane:** Mantra
**Module:** [`mantra/src/weave.rye`](../mantra/src/weave.rye) -
**Witness:** [`tools/m/mantra_weave_apply_witness.rish`](../tools/m/mantra_weave_apply_witness.rish)
**Kin:** [the bound that counted and never measured](20260912-003734_the-bound-that-counted-and-never-measured.md) -
[Mantra was named for the weave](20260905-153729_mantra-was-named-for-the-weave.md)

`Weave.apply` takes one argument from its caller and reads it in two halves. The insert half
reads its bounds at the edge and hands back a named error. The delete half stated three
conditions of its own, in the same contract paragraph, and asserted all three -- so the same
caller, handing the same kind of mistake, got an error from one half and `exit 134` from the
other.

## What was measured

Proven on metal before anything was written, in a pen under `.lap/`, against the module exactly
as it stood at `c06efa03a4`:

| The caller's mistake | What `apply` did |
|---|---|
| a delete naming a line already deleted | `exit 134` at `weave.rye:1078`, the parity assert |
| a delete naming a line the weave never held | `exit 134` at `weave.rye:1087`, the hit-count assert |
| two deletes naming one line | `exit 134` at the distinctness assert |
| inserts carrying the weave past its ceiling | `TooManyLines`, handed back |
| inserts on a counter at the ceiling | `CounterPastCeiling`, handed back |

All five readings live inside one function, and three of them ended the process.

## Why the asymmetry survived

Because each half was right about a different question, and the two questions were asked on different laps.

The insert half was repaired on `20260912.003734`, one lap before this one, when
`max_weave_lines` turned out to bound a count while a position's value went unread. That lap
read the insert half closely and left the delete half exactly as it found it -- which is the
ordinary shape of a careful repair, and the reason this one is worth writing down. A function
whose two halves are audited on two different laps drifts to two different standards, and
each lap did its own job well.

The delete half's own defence was reasonable too. `diff.rye` builds a `Diff` by walking a
weave's `current` view, so every target it writes names a live line the weave holds, exactly
once. A diff applied to the weave it was read from satisfies all three conditions. The
asserts held for every diff the module itself built.

## What breaks them is the case the module exists for

A **stale diff**. Read against one state, applied to another -- which is what a branch is.
Two hands drop one line, the second delete to arrive finds it gone, and the process ends.

That is the common case rather than an edge. Mantra was named for the weave because two histories that touched one
document should be *shown* doing so rather than handed back as two opaque blobs. The delete
path aborted on precisely the arrival a version store is built to meet.

The module had already written down the right reading, one constructor over. `CounterPastCeiling`
carries it in its own doc comment: *read at the edge rather than asserted, since a record arrives
from disk where the caller vouched for nothing.* A `Diff` is a caller's data on both halves of `apply`.
The sentence was there; it had only been applied to the half that arrives from disk.

## The repair, and the part of it that is not the error names

Three named errors -- `DeleteNamesGoneLine`, `DeleteNamesNoLine`, `DeleteNamesOneLineTwice` --
are the visible half, and the cheap half.

The half that took the thinking is **when** they are read. The elder walk bumped each matched
line's generation as it went and checked the hit count afterward, so turning that check into a
`return` would hand a caller a named error over a weave with part of the diff already applied.
That is worse than the abort it replaces: an abort tells a caller nothing happened after it,
where a named error tells a caller nothing happened at all -- and one of those two would have
been a lie.

So the walk records **where** each target sits and mutates nothing; the generations rise in a
second short loop, past the last refusal. A refused `apply` leaves the weave byte for byte as it
arrived. The cost is one `u32` per delete and a loop over at most the delete count, which is the
same order the pass already ran at.

## What proves it

`Weave.apply` is the module's one mutation, and of its five public functions it was the one still
waiting for a guard -- `merge`, `annotate`, `from_v1` and `from_v2` each have a witness; `apply` was
proven wherever a lap happened to be standing. That is the structural reason this went unread,
and it is closed here rather than named:
[`mantra/src/weave_apply_witness.rye`](../mantra/src/weave_apply_witness.rye), nine claims, under
[`tools/m/mantra_weave_apply_witness.rish`](../tools/m/mantra_weave_apply_witness.rish).

Two of the nine carry the weight. **Claim 6** presses each refusal against a weave read field for
field -- lines, both counters, and the sum of every generation -- before and after, because a
named error is an improvement on an abort only if the call it refuses did nothing. **Claim 7**
presses a delete block whose first target is good and whose second is not: the refusal must come
back by the right name *and* leave the good target still present.

The control breaks the contract eight ways in a pen
([`tools/fixtures/m/mantra_weave_apply_control.sh`](../tools/fixtures/m/mantra_weave_apply_control.sh)),
every refusal planted and then lifted, and each of the three checks planted twice -- deleted, and
kept under the wrong error name -- since a refusal proven only by its absence is proven in one
direction.

The **ninth** leg is the one to read. `mutation_early` keeps every refusal exactly where it is and
every error name right; only the moment the generation rises moves, back into the walk. Claims 1
through 6 all print GREEN under it. Claim 7 is what fires. A control without that phase would
pass a module whose named errors lie, which is the failure this repair was aimed at rather than
the one its error names describe.

## What this does not reach

`merge` and `annotate` reach the weave's two counters through `@max` alone and name no ceiling of
their own. Both inputs stand inside the bound by every constructor's own check, so the maximum
does too -- yet each function leaves that unsaid, and a reader auditing `merge` derives the
postcondition rather than reading it. That is an unstated invariant rather than a live defect, and it is the
next lap in this lane.

Whether a delete should be able to name a line **between** two existing ones is a seam rather
than a lap, and `annotate`'s own header already names it: every insert takes a position from the
end of the counter, so the reading tells what each side did to each line, and where a new
line sits against the other side's delete stays open. That wants an anchor per insert, which widens `Diff`.
