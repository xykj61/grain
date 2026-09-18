# The branch-cursor ring checked -- the third idiom also comes back negative

**Stamp:** `20260918.052643`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- the named falsifier checked, negative
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260918-050444_bitmask-ring-checked-no-torus-closes-the-falsifier.md`](20260918-050444_bitmask-ring-checked-no-torus-closes-the-falsifier.md) --
this piece answers that account's own named blind spot, and closes the thread.

## The one sentence this piece is for

The prior account named the one idiom its five patterns still could not see -- a ring cursor
written as a branch, `if (i == N - 1) i = 0 else i += 1`, rather than a modulus or a bitmask. This
piece runs that search, and the thread that opened nine accounts ago now closes with all three
known wraparound idioms checked.

## What was checked

Every tracked `.rye` source outside the closed testimony, vendored, and seed shelves, first widened
to any comparison-then-reset shape, then narrowed to the names a real ring cursor would carry:

```
grep -lnE '\+\s*1\s*==|==\s*[a-zA-Z_.]+\s*-\s*1\s*\)' <every .rye file> | xargs grep -lE '=\s*0\s*;'
grep -lE '(idx|cursor|pos|head|tail|next|ring|write_at|read_at)[a-zA-Z_]*\s*==\s*[a-zA-Z_.]+\s*-\s*1'
```

The first pass returned 93 files on the loose shape alone -- too broad to read one by one, and a
measure of how common "compare to length-minus-one" is in ordinary bounds-checking code. Narrowing
to names a ring cursor would actually carry (`idx`, `cursor`, `pos`, `head`, `tail`, `next`, `ring`)
cut that to four.

## What was found

All four stand as postcondition **asserts**, each stating what a value equals once a loop or an
edit has finished:

- `brushstroke/edit_filmstrip_track.rye:342` -- `assert(track.jump.cursor.position == edits.max_edits - 1)`, a bound check on where a cursor landed.
- `image/cluster_minimum_spanning_tree.rye:147` -- `assert(edge_idx == n - 1)`, a loop-completion postcondition.
- `pond/apps/dexter_prompt.rye:122` -- `assert(rendered.cursor_col == row_cols - 1)`, a rendering position check.
- `pond/apps/scooter_input.rye:172` -- `assert(ch.post_count == channel.max_posts - 1)`, a count postcondition.

Every one states a final value; the comparison is a fact the code asserts about itself, and the
search closes here.

## What this closes

**Three wraparound idioms are now checked: modulus (`%`), bitmask (`& (N-1)`), and branch-reset
(`if (i == N-1) i = 0`).** The search ran across this tree's whole authored `.rye` surface. Every
one turns up ordinary bounded code -- never a torus, a cyclic aether, or a ring topology. Ten
accounts stand in this thread (`20260917-235220` through this one), and the finding holds through
every one of them: the words *wrap*, *ring*, and *cycle* in this codebase name ordinary bounded
structures. Caravan's supervision queues, Tally's arenas, Amphora's vessels -- each does ordinary
work, plainly, and none is a geometric topology.

## What stays open past this search

A search is bounded by the shapes it names. One idiom stays untried: a ring cursor written with a
**subtraction** guard, `if (i == 0) i = N - 1 else i -= 1`, walking backward. It mirrors the branch
checked here. It is worth naming for a later reader, though a fourth search over the same
population is likely to carry small value after three straight negatives.

## Why the thread closes rather than continues

A falsifier earns its keep by getting checked. Each account here closed one blind spot more
honestly than a first, unqualified reading would have. Ten accounts and three wraparound idioms
together are enough evidence: this tree's own code holds exactly the ordinary bounded structures it
always claimed, and nothing shaped like a half-built ring topology waits to be named. The next
honest move in this line is the one the ninth account already pointed to. **A toroidal-aether or
radial-coordinate scheme, if it is worth proposing to Caravan or Aurora, is new design work.** It
stands on its own, rather than resting on anything already built under a different name. That is a
different kind of paper -- one that starts from first principles rather than from a grep.
