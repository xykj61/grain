# What a Roster Owes a Run

**Language:** EN
**Stamp:** `20260825.092953`
**Voice:** Kyri
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- every number below was measured on this pier on `20260825` and is named with what produced it
**Kin:** [`the roster that decides what gets measured`](20260824-080208_the-roster-that-decides-what-gets-measured.md) (which booked this question) - [`reds-first`](../.claude/rules/reds-first.md) - REDS %219
**Meter:** [`../tools/w/witness_reach_witness.rish`](../tools/w/witness_reach_witness.rish) over [`../tools/fixtures/witness_reach_scan.sh`](../tools/fixtures/witness_reach_scan.sh)

---

## The question, and where it came from

[`construction/standing-equipment.kyri`](../construction/standing-equipment.kyri) opens on a
sentence about itself: *a guard that is never run guards nothing either.* The roster names what
stands. What stands outside it went uncounted until this lap.

On `20260824` a design note named that gap and left it open, in these words: *"whether every witness
on disk is reached by something, since a witness nobody runs guards nothing. Answering it means
tracing reachability rather than comparing counts, which is a round of its own."* This is that
round.

## What was measured

Four readings, taken on the staged tree at `20260825.092953` by
`sh tools/fixtures/witness_reach_scan.sh`:

| Reading | Before this lap | After | What it means |
|---|---|---|---|
| **total** | 1,690 | **1,690** | tracked `*_witness.rish` files on disk |
| **standing** | 56 | **167** | reachable from the roster, transitively -- sung on every lap |
| **sung** | 512 | **513** | named in an invocation position by any runner on disk |
| **unheard** | 1,178 | **1,177** | named by no runner at all |

So a little under a third of this tree's witnesses are named by something that could run them, and
**56 of 1,690 ran on an ordinary lap** when the meter first read the tree. One roster row moved that
to 167: seating `caravan_suite_witness` carried its 111 rungs with it, which is what the `standing`
column is for.

The largest unheard families, by name prefix, on the shipping tree: `ales` 239, `equinox` 123,
`hunk` 86, `mycelium` 69, `glow` 61, `font5x7` 45.

## The distinction the whole meter rests on

A path **named** and a path **run** are two different things, and telling them apart is the entire
difficulty. Three shapes read like calls while remaining mentions, and every one turned up in a real
source here while the meter was being written:

```
grep -oE '...' tools/cr/crypto_suite_witness.rish     a file read as DATA (crypto_count_guard:73)
"**Ran:** `rishi/bin/rishi run ..._witness.rish`"     a string a script PRINTS (the almanac)
#   rishi/bin/rishi run tools/x/foo_witness.rish      a comment's usage line, in every witness
```

The first of those would have been the expensive one. `crypto_count_guard_witness.rish` greps the
crypto choir's text to check a bijection, and a meter reading that as a call would have reported the
whole crypto family -- 74 witnesses -- as reached by the standing roster. The roster reaches exactly
two of them, `crypto_count_guard_witness` and `crypto_module_roster_witness`.

So the rule is **command position**, applied uniformly: a comment line is skipped, a quoted span is
data, and what is left is split at the shell's own separators. A `-c` payload is unwrapped first and
read by the same rule, because `run ["sh" "-c" "rishi run x"]` genuinely calls `x` while `run ["sh"
"-c" "grep x"]` reads it as text. This is [REDS
%218](../construction/archive/REDS-a-citation-in-a-comment-rows-218.md) read one direction over:
there, a citation in a comment was a promise the tree had to keep; here, a citation in a comment is
a mention the meter reads past.

## What it cost while nobody was counting

The meter's first act was to surface a guard that had been reading red for two laps.

`tools/fixtures/caravan_ladder_carry_scan.sh` holds the Caravan ladder's carried-line count under a
ceiling that only falls, seated at **58,532** on `20260825.010500`. Measured this lap, it read
**58,550**. Two commits crossed it, each adding one more byte-for-byte copy of the same nine-line
study-rung door:

| Commit | Round | carried |
|---|---|---|
| `2a9ccea972` | one region body where five stood | 58,532 |
| `053dba9e5f` | the seven bounds a protection domain runs under | **58,541** |
| `c10334408c` | twelve parts of an address space | **58,550** |

Both laps recorded a green cold roster, and both were telling the truth. The carry meter is reached
by `tools/ca/caravan_suite_witness.rish` alone, and that choir stood off the roster. Booked as REDS
%219 and closed on metal: the door lifted into
[`../caravan/study_door.rye`](../caravan/study_door.rye), carry fell to **58,496**, the ceiling fell
with it, and the choir took a roster row.

**The inference:** an unheard choir is a red nobody receives, and the tree keeps 1,177 witnesses in
that condition today.

## What hearing a choir costs, measured

The obvious repair -- roster every choir -- has a price, and the price is why the answer is a design
call rather than a sweep. Measured on this pier, wall time for one run:

| Choir | Rungs it sings | Wall time, idle pier | Per witness |
|---|---|---|---|
| `caravan_suite_witness` | 111 | **8m 31s** | **4.6s** |
| `crypto_suite_witness` | 74 | **9m 06s** | **7.4s** |

**The first reading of that first row was wrong, and how it was wrong is the useful part.** A run
of 2m41s was taken and nearly published. That run had **aborted early** on the very red this lap went
on to close, so it sang a fraction of the roster and stopped. Re-measured on an idle pier after the
fix, the same choir takes **8m31s**. A wall-clock number belongs to the work that actually completed,
and a failing run is faster than a passing one by construction.

At 4.6 seconds a witness, Caravan's choir is the better bargain of the two, and both cost several
minutes. Rostering Caravan was still right: that choir had been holding a live refusal for two laps,
and eight and a half minutes buys 111 witnesses. It is paid **twice** on a lap that reads the roster
cold and hot, so seating the two choirs together would add roughly thirty-five minutes a lap -- which
is what turns the second tier below from a tidiness proposal into what decides whether the next choir
can be heard at all. Crypto reads GREEN today, so leaving it off hides nothing; at 9m06s it is exactly
the case the tier exists for. *The roster's own total wall time went untimed this lap and is left
unclaimed rather than estimated.*

## What is settled, and what is proposed

**Settled, and proven on metal:**

- The four readings, and the meter that takes them, gated at a ceiling that only falls.
- The call/mention line, proven on planted git repositories from both sides -- eighteen behaviors,
  eight call shapes heard, five mention shapes refused, and the ceiling read from three positions.
- `caravan_suite_witness` on the standing roster, at a cost measured in seconds and named on the card.

**Proposed, and waiting on Keaton's word:**

- **A second tier on the roster.** Every-lap guards and on-touch choirs are different jobs, and one
  file naming both with a `tier` field would let a lap run the first in minutes and the second when
  it touches that module. Today the roster has one tier, so a
  choir either runs every lap or waits for a hand.
- **A choir for `ales`.** 239 unheard witnesses in one family is a fifth of the whole unheard count,
  and the family already has the shape a choir wants.

## The honest limit

The meter reads invocations it can see. `tools/hooks/pre-commit` runs `rishi/bin/rishi run
"$generator"` through a variable, and a static rule resolves that only where the path is spelled, so
the generators it runs stay outside this reading. That makes **`unheard` an upper bound on what is
truly unrun**: every name in it is worth reading before it is believed, and each of the five read
so far stands genuinely unrun.

It proves a witness is *named* by a runner, and stops there. Whether that runner itself runs is the
`standing` reading beside it, and the roster is what answers that one.

## A falsifier

Find a witness this meter calls **unheard** that some standing process actually runs. One would show
the invocation rule has a gap rather than a bound, and the three shapes above would want a fourth.
The search so far has been narrow: five unheard names traced by hand out of 1,177 --
`ad_walk_sample`, `dated_classify`, `place_paint`, `crypto_suite`, and
`equinox_copy_sameness_almanac`. Each is genuinely named by no runner.
