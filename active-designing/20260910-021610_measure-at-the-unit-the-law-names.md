# Measure at the unit the law names

**Stamp:** `20260910.021610`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Living -- **checkable room**: every figure here comes from
[`../tools/fixtures/i/invariant_coverage_scan.sh`](../tools/fixtures/i/invariant_coverage_scan.sh)
or from a grep spelled in the text
**Kin:** [`../context/TAME_CORE.md`](../context/TAME_CORE.md) -- [`20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md) -- [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md)

TAME root rule 2 asks for asserts at construction, mutation, and postcondition, and the SLC
Definition of Done spells the aim in one line: **aim >= two per function**. The unit in that
sentence is the function. Every instrument this tree has ever pointed at the rule reads a
different unit.

## The three units, and what each one can see

| Instrument | Unit | What it answers |
|---|---|---|
| `assert_gap`, `invariant_gap` | **file** | does this source assert at all, does it name a reason |
| `unnamed_assert`, `invariant_coverage_scan` bins | **assert** | does this assert carry a stated reason |
| *nothing, until `20260910.021610`* | **function** | does this function assert at all |

A file passes the file reading with one assert and eighty functions. That is the shape the air
row calls a fence post firm to the eye and loose to the hand: the boundary stands on the diagram,
and a hand running along it passes straight through.

## What the function unit reads

Measured `20260910.021027` over 1,734 authored modules, on the contract population the scan
already defines -- a function the proof spread of its own file did not reach, in a file that is
neither a witness nor a selftest:

```
contract_functions=23319
fn_with_no_assert=16214
fn_with_one_assert=3291
fn_with_two_or_more=3814
fn_meeting_the_aim_percent=16
fn_nested_unread=1224
```

Read that beside the per-assert reading from the same run, `contract_coverage_percent=97`.

**Both numbers are true, and they answer different questions.** Nearly every assert this tree
writes names its reason, which is a real achievement of the *say why* habit. And roughly one
contract function in six asserts at all. Neither reading is a correction of the other; the second
is simply a question nobody had asked.

Every figure above is **free** -- held by no gate. Run the scan rather than reading them here:

```
sh tools/fixtures/i/invariant_coverage_scan.sh
sh tools/fixtures/i/invariant_coverage_scan.sh functions   # per module, worst first by count
```

## Why it gates nothing

The law says **aim**, and an aim is not a wall. A three-line accessor returning a field states no
invariant worth writing down, and a ceiling at 16 percent would red the whole tree on the lap it
was seated -- a gate that reds on ordinary work is a gate somebody turns off. The reading is a
census, and its use is local: `functions` mode tells one module which of its own functions stand
unguarded, so a hand already touching one closes the nearest gap.

## Two limits, both counted rather than described

**The nested declaration.** The scan anchors `fn` at column 0, so a function declared inside a
struct body is invisible to the walk and its asserts are attributed to the top-level function
around it. Tree-wide a plain grep reads **1,839 indented declarations of 34,241**, 5.4 percent;
over the contract population the scan bins, the field `fn_nested_unread` reads **1,224**. Two
populations, two figures, both printed. Widening the anchor would move the proof classification
the control's fifteen elder legs were built around, so this lap counts the blind spot and leaves
the anchor alone.

**The line, not the call.** Both readings count assert *lines* rather than assert *calls*, so two
calls on one line read as one. That is deliberate: a second counting rule would be a second answer
to *what is an assert*, which is the braid `single-stranded` names. The tree writes one per line --
a grep for two calls on a single line reads **2** across 1,964 authored sources -- so the
granularity is exact within those two, and control leg `12a` keeps the limit visible if the
convention ever moves.

## Why one instrument rather than a sibling

The function walk, the proof-reachability spread, and the five exclusions that tell an assert call
from a comment, a generated string, a declaration, and a printed line all already stood inside
`invariant_coverage_scan.sh`. Copying that classifier into a new scan would give the tree two
implementations of *what a contract function is*, free to drift. The reading joins the instrument
whose parse it needs, and the control grew from 22 legs to 37 with every elder leg still green --
which is what proves the elder readings did not move when the new one arrived.

## What it does not reach

**Whether a function should assert.** The census counts what stands; a reader decides what a
particular function owes. And **whether an invariant line says anything useful** stays what the
scan's own header already declared it: presence is the check, a reason a reader can use is the
standard.

*May every law this tree keeps be measured at the unit it was written in, so a hand walking the
fence meets the same line the rule drew.*
