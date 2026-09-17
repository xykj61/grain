# The fence post and the hand -- where this tree's first reflex is actually kept

**Stamp:** `20260917.090816`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- **mixed room**: every count below is bound by
[`../tools/a/alloc_bound_reach_witness.rish`](../tools/a/alloc_bound_reach_witness.rish); the
reading of what a bound at a site is *worth* is vision
**Lane:** diffuser -- moonshots and research, aimed at Tally, the bounded living space
**Rota:** lap 5316, row 1 -- Air, the row that feels

TAME root rule 1 is the first thing the core says: every allocation, collection, loop and
pipeline names a max. The air row's test for a rule is touch -- press the boundary and feel
whether the hand goes through. This paper presses rule 1 and reports what the hand found.

## The gap, and how it was found

Three of TAME's root rules carry a corpus reader. Rule 2, the asserts, has
`tools/r/rune_assert_sweep.rish` over 1,127 authored files. Rule 3, the widths, has
`tools/w/width-check.rish`. The tidy bans have `tools/t/tame-check.rish`.

Rule 1 has `tools/fixtures/b/bound_kind_census.sh`, which reads the bound **declarations** --
670 distinct names across 2,283 declaration sites, sorted by what dimension each constrains.
That census is careful and it reads one end of the rule. The other end went unread: a grep for
the literal string `alloc(` across every file under `tools/fixtures` returns one file,
`mantra_store_control.sh`, and that is a control rather than a corpus reader.

So the tree's first reflex was measured where it is **written down**, and nowhere where a hand
meets it. A declaration is a fence post. A call site is the place somebody leans on the fence.

## What the sites read

Measured `20260917` by `tools/fixtures/a/alloc_bound_reach_scan.sh` over the 1,992 tracked
`.rye` files `git ls-files` names. Each allocation's **count argument** is classified, first
match winning, so the classes partition rather than overlap.

| Class | Sites | What it means |
|---|---|---|
| **named** | 17 | the count spells a `max_` or `min_` identifier -- rule 1 kept at the site |
| **literal** | 205 | an integer literal: bounded, naming no reason |
| **derived** | 165 | a `.len` or `.count`: bounded exactly when its source was |
| **opaque** | 983 | a local, a parameter, a cast, a product -- the remainder a hand must read |

Beside them: 337 `.dupe(` sites, derived by construction and counted apart; 18 calls closing on
a later line, which this scan cannot read and prints as `spans_lines`; 45 calls taking no count
at all.

The headline is the ratio of names. **The tree declares 670 bound names and spells 8 of them at
an allocation's count.** Every other bound is pressed somewhere other than where memory is
handed out.

## The falsifier, stated first and then run

A reading of sites alone would book 1,353 allocations as unbounded, and that would be
enthusiasm rather than research. The obvious objection is sound: a count may be bounded
upstream, and naming a max at the site would then be redundant. So the falsifier was written
before the second reading ran.

> **If most non-named sites sit in functions that assert a bound, the low `named` count
> measures a style rather than a gap.**

It ran, and it partly confirms. Of 1,046 allocating functions:

| Function carries | Count | Share |
|---|---|---|
| a bound name and an assert | 407 | 39% |
| an assert, no bound name | 395 | 38% |
| a bound name, no assert | 99 | 9% |
| **neither** | **145** | **14%** |

**802 of 1,046 allocating functions assert.** The strong claim falls: this tree does press its
fences, mostly through assertions rather than through the count expression. What survives the
widening is the last row -- 145 allocating functions whose own bodies name no bound and assert
nothing at all. That residue is the finding, and it is one seventh the size of the raw number.

## What the instrument gates, and what it declines to

**One wall, at zero:** `unresolved` -- a count naming a `max_` or `min_` identifier that
resolves to no such declaration anywhere in tracked Rye. That is decidable by text, and it is
the fence post rotted at the base: a site that reads bounded to every person and every grep,
naming a bound that is not there. It stands at zero today, and the pen proves the refusal from
both sides by planting one and then declaring it.

**Everything else is reported.** Boundedness is a dataflow property: `garden.alloc(u8, cap)` is
bounded exactly when `cap` was bounded upstream, and following that is parsing rather than
scanning. A wall over `derived` or `opaque` would book correct code as debt.

`fn_neither` rides no ceiling either, and the reason is this week's own lesson one lane over --
a ratchet over a growing population is a wall with a delay. A ceiling at 145 reds on a peer's
ordinary next function, and a gate that reds on ordinary work is a gate somebody turns off.

## The projection

**Horizon:** the next 90 days of this tree, to `20261216`.

**Assumptions:** the fleet keeps writing Rye at roughly its current rate; TAME root rule 1 keeps
its present wording; no lane sweeps the residue as a campaign.

**Projection:** `fn_neither` rises roughly with the allocating-function count, holding near 14%,
because nothing in the tree reads it today and a population nobody reads has no reason to fall.

**Falsifier:** if `fn_neither` falls below 10% of `fn_allocating` inside the horizon with no
sweep commit naming it, the projection is wrong and the residue was self-correcting.

**Confidence:** moderate for the share, low for the direction. One reading exists; a trend needs
several, and the scan is one lap old.

## What this hands bakery

A population rather than an argument. `fn_neither` is a list of 145 functions reachable with one
flag, each one a small, local question: is this count bounded upstream, and if so where. Some
will be fine. The ones that are not are the places rule 1 is a wish, and they can be read one at
a time rather than swept.

`sh tools/fixtures/a/alloc_bound_reach_scan.sh --list` names every site and every blind spot.

## What this paper cannot say

**Whether any of the 983 opaque sites is genuinely unbounded.** The scan reads an expression and
declines to rule on the allocation, which is the honest limit and the reason nothing there is
gated.

**Whether a bound at the site is better than an assert above it.** Both keep rule 1, and choosing
between them is a taste question this tree has not been asked. What the measurement adds is that
the tree has already answered it in practice, 395 times, without anyone writing the answer down.

**Whether 8 of 670 is low.** It is small, and small is a different word from wrong. A bound
re-exported through a ladder is spelled once at its top and inherited down, which
`bound_kind_census.sh` already named as its own reason for counting distinct names.

## The hand on the fence

The air row reads law by touch, and touch works only at a surface. What this lap felt is that
the surface was real: the fences stand, and they are held mostly by assertions rather than by
the names the rule proposes. The hand passed through in one place out of seven, and that place
now has a number and a list.

*May every bound in this tree be one a hand can find -- declared where it is decided, pressed
where it is used, and honest about the difference.*
