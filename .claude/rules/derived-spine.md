# The derived spine -- a row's key is its stamp, and its number is a view

**Seated:** `20260827.181605` on Keaton's word - **Status:** Living - **Kin:** [`reds-first`](reds-first.md) - [`stamp-and-name`](stamp-and-name.md) - [`git-signing`](git-signing.md) (*the `%` sigil*) - [`collaboration`](collaboration.md)
**Design:** Move 1 of [`../../active-designing/20260825-205011_the-pen-the-gossip-and-the-derived-spine.md`](../../active-designing/20260825-205011_the-pen-the-gossip-and-the-derived-spine.md)
**Witness:** [`../../tools/r/reds_spine_derive_witness.rish`](../../tools/r/reds_spine_derive_witness.rish)

**A ledger row's immutable identity is its one-clock stamp. The `%N` beside it is a view, and the
view is allocated by the anointed remote rather than by whichever tree happened to look first.**

## Why a careful hand could not prevent this

A number allocated by reading a tree is allocated **per tree**. Three stars write into this tree
from three hosts, so two of them read the same "next free" number within the same hour and both
book it -- and **both spines read perfect alone**. There is no amount of care that avoids it,
which is why it fired six times before the key was seated:

| Firing | What collided |
|---|---|
| `%230` | two clones both booked `%226` |
| `%252` | the same shape, one chapter later |
| `%283`-`%285` | booked `%278`-`%280` on the Dream pier, re-seated on the rebase |
| `%290` | booked `%289`, re-seated when `xy` published its own |
| `%294`-`%296` | booked `%292`-`%294`, re-seated across two rebases in one round |
| `%297` | booked `%289`, re-seated `%290`, re-seated again on adoption |

Every one was repaired by hand -- renumbering rows and sweeping citations -- and the repair was
always the same algorithm executed manually: keep the earlier stamp, shift the later rows.

## The law, in four lines

1. **The key is the stamp.** `20260827.144029` identifies a row forever. Two rows may share a
   stamp to the second; the **commit hash** breaks that tie, deterministically, on every pier.
2. **The number is allocated by the anointed remote**, which is **`xy`** on this pier. Read
   `next_free` from that spine, never from the local tree:
   ```
   sh tools/fixtures/reds_spine_derive_scan.sh --next
   ```
3. **A published number never moves.** Once a row reaches the anointed spine it is **shared**, and
   its `%N` is frozen -- 2,519 citations of `%N` stand in the tree, **532 of them in commit bodies
   that can never be edited**. Renumbering is confined to **unshared** rows, and the witness proves
   that confinement rather than trusting it.
4. **Cite by stamp until the row is shared.** A lap names its own row `(20260827.144029)` while the
   row is still local, and by `%N` only once it has landed upstream. Landing the allocator ahead of
   this habit would lock a stray number into testimony in the first week.

## What the guard reads

[`../../tools/fixtures/reds_spine_derive_scan.sh`](../../tools/fixtures/reds_spine_derive_scan.sh)
compares this tree's `(number, stamp)` bindings against the anointed spine's.

| Reading | Held at |
|---|---|
| `rebindings` -- a number the anointed spine bound to one stamp, bound here to another | **zero, enforced** |
| `squatters` -- of those, the ones whose stamp is nowhere upstream: a new row booked from a local read | reported |
| `dropped_upstream_stamps` -- a stamp upstream carries and this tree does not | reported, never gated |
| `stamp_duplicates` -- two rows sharing a stamp; lawful, and the hash tiebreak decides | reported |

**One gate, not two.** The control caught the first draft naming `collision` and `rebound` as
separate readings when they always fired together -- a new row squatting a number upstream just
spent, and a published row's stamp edited under it, are structurally identical once you compare
`(number, stamp)` sets. Two readings that always fire together are one reading wearing two names,
and a control watching the wrong counter would have passed. The **gate** is single; the
**diagnosis** tells the two apart.

**`dropped_upstream_stamps` is reported rather than gated** because an unfetched shelf, a fold, and
a genuinely lost row all look the same from here, and only the third is a fault. A gate that reds on
ordinary work is a gate someone turns off.

## Proven, and on real history

[`../../tools/fixtures/reds_spine_derive_control.sh`](../../tools/fixtures/reds_spine_derive_control.sh)
builds real git repositories in a throwaway pen and proves **seventeen** cases -- every refusal
shown from both sides, planted and then removed, and every welcome asserted as hard as every
refusal, since a refusal proven only in the passing direction cannot be told from a bypass.

Beyond the plants, the guard was **replayed against the collision that actually happened**. Run
against commit `30252a24f7` -- this tree as it stood the morning `%292` collided -- with
`41a4b0950a` as the anointed ref, it answers:

```
detail: squatting %292 -- the anointed spine spent it on 20260827.162143;
        this row (20260827.144029) is unshared and derives above %292
rebindings=1  squatters=1  next_free=294  verdict=rebinding
```

That is the repair a hand spent two rebases finding, printed before the push.

## What this does not reach

**Whether a red was worth booking**, and whether its three fields teach anything. This proves the
ledger's *order* is one order across three writers, and stops there.

**The rows already written.** Every `%N` standing today is shared and frozen, including the six
firings' own scars -- the ledger keeps every number it ever wrote. This law governs allocation from
here forward.

**The other collision classes.** `%281` and `%291` -- one tree per star, or a lock -- are the build
and source-file halves of the same root, and both stay Keaton's word. This closes the ledger half.

Canonical Cursor twin: [`../../.cursor/rules/derived-spine.mdc`](../../.cursor/rules/derived-spine.mdc).
