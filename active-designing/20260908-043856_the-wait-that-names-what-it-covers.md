# The wait that names what it covers -- six patience budgets in Caravan, one of them checked

**Stamp:** `20260908.043856`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- **mixed room**: the census below is counted and every count names the
command that produced it; the invariants proposed in movement four are bound by no witness yet
(see [`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Room:** mixed
**Lane:** DIFFUSER, aimed at Caravan and handed to BAKERY
**Kin:** [`../external-research/20260905-232224_the-bound-that-names-a-joule.md`](../external-research/20260905-232224_the-bound-that-names-a-joule.md) -- the parent paper, whose addendum named this study as its one cheap unbuilt move

## What this is, and what it is not

Caravan sleeps in sixteen places. Each sleep sits inside a loop with a look-bound, so every wait in
the module is finite by construction -- that part is already sound, and this study proposes no change
to it. What this study measures is a different property: whether each finite wait runs long enough for
the thing it waits for.

**One of the six budget families answers that question in the source. The other five leave it to
the reader.**

The observation is a count. The inference is that the five unchecked budgets already encode a
relation their authors held in mind. The proposal is that naming the covered quantity is the
work, and that the assert then writes itself.

## Movement one -- the census

Measured `20260908.043856` on this pier, at git nib `718166c8a`, against the working tree.

```
git ls-files '*.rye' | xargs grep -c 'std\.Io\.sleep' | grep -v ':0'
```

**16 sleep sites across 7 files, all seven of them in `caravan/`.** Caravan holds the whole
question, since every sleep in the tree is one of these sixteen.

Pairing each site with its enclosing look-bound gives six distinct budget families:

| Family | Root value | Rest | Budget | Declared at |
|---|---|---|---|---|
| `max_poll_sweeps` | 8,000 | 2 ms | **16,000 ms** | `caravan/harvest.rye:126` |
| `max_patience_looks` | 600 | 2 ms | 1,200 ms | `caravan/entrust.rye:161` |
| `max_prune_looks` | 600, borrowed | 2 ms | 1,200 ms | `caravan/revoke.rye:131` |
| `max_confirm_looks` | 500 | 2 ms | 1,000 ms | `caravan/entrust.rye:153` |
| `max_listen_looks` | 500 | 2 ms | 1,000 ms | `caravan/taper.rye:128` |
| `max_ack_looks` | 400 | 2 ms | 800 ms | `caravan/taper.rye:135` |

Both root `note_rest_ms` constants read 2 ms -- one in `entrust.rye:145`, one in `taper.rye:122` --
and every other declaration of the name re-exports one of them along the rung chain. `grep -rn 'pub
const max_confirm_looks' caravan/*.rye` returns **46 declarations**, of which exactly one carries a
number and forty-five inherit it.

**Exactly one comptime assert in the tree binds a rest budget to a duration it must cover:**

```zig
// caravan/harvest.rye:134
assert(max_poll_sweeps * poll_rest_ms > max_linger_ms);
```

The only other product assert under a `comptime` block in these files is
`caravan/confer.rye:138`, which sizes a buffer rather than a wait, and so belongs to a different
family. Found by `grep -n 'assert(.*\*' caravan/*.rye` and read one at a time.

## Movement two -- why harvest can make the claim, and the others cannot

Harvest's assert reaches past discipline into structure. It is possible there and out of reach
elsewhere, for a reason worth naming, since that reason is what the proposal has to supply.

Harvest carries three parts in one file:

1. **The wait.** `while (sweeps < max_poll_sweeps)`, resting `poll_rest_ms` between sweeps
   (`harvest.rye:415`, `harvest.rye:449`), answering `error.DependentNeverExited` when it runs out.
2. **The waited-for, as a named constant.** `max_linger_ms = 2000` (`harvest.rye:113`) -- the
   longest a dependent may hold on before exiting.
3. **The refusal at the edge.** A dependent asking for a longer linger is turned away twice, at
   `harvest.rye:324` with `error.LingerTooLong` and at `harvest.rye:764` with
   `Outcome.malformed` -- and the second of those sits three lines above the sleep that performs
   the linger.

Because part two is a named quantity and part three refuses anything past it, part one's assert is
a real theorem: the wait outlasts the longest legal linger, by a factor of eight, and the compiler
checks it on every build.

**The other five families are missing part two.** The source names a constant for the wait and one
for the rest, and stops there: how long a dependent may take to publish `.taken`, and how long a
supervisor may take to reach its listen, are quantities the running system has and the source
leaves unnamed. An assert needs something to point at, so the missing name is the finding rather
than the missing assert.

## Movement three -- the relations the numbers already encode

Two pairs sit in the same file, chosen together, and they run in opposite directions.

**In `taper.rye`, the listener outlasts the speaker.** A dependent waits 400 looks for its handback
to be read back (`wait_for_ack`, `taper.rye:545`); a supervisor listens 500 looks for a handback to
arrive (`listen_until_heard`, `taper.rye:757`). The listening window exceeds the speaking window by
200 ms.

**In `entrust.rye`, the speaker outlasts the listener.** A supervisor waits 500 looks for a
dependent to publish `.taken` (`confirm`, `entrust.rye:656`); a dependent loops 600 looks while it
carries entrusted arcs (`entrust.rye:1230`). The dependent's window exceeds the supervisor's by
200 ms.

Both files pick 500 and pair it with a second number 100 looks away, in a deliberate-looking way,
and the pairing is inverted between them. **Inference:** at least one of the two directions runs against
what the other teaches, so a reader who learns the rule from `taper.rye` carries the opposite rule
into `entrust.rye`.

**A second tell, and a plainer one.** `revoke.rye:131` reads
`pub const max_prune_looks: u32 = confer.max_patience_looks;` -- a prune budget defined as a
patience budget. That is a constant borrowing a neighbor's number in place of an argument for
its own. The borrow is harmless today, and it records that the number arrived by inheritance.

**The limit of the claim.** Both pairings stand here as unstated relations rather than as defects. `entrust.rye`'s supervisor
waits for the dependent's *first* `took_on` rather than its whole loop, since the dependent
publishes each time it carries (`entrust.rye:1240`), so a 1,000 ms confirm window covers a first
carry rather than a whole 1,200 ms patience window. The exhaustion path is a legitimate outcome in every one of the five:
`confirm` answers `false`, the run reports `EntrustUnheard`, and the run carries on. **The risk is a
false negative rather than a fault** -- a run reporting work unheard that was in fact one look away from
being taken -- and this study has not reproduced one.

## Movement four -- what BAKERY could build, and its cost

Three moves, cheapest first. All three are compile-time only, so none of them costs a cycle at run
time.

**Move one -- name the covered quantity.** For each of the five families, add one `pub const`
naming the longest legal duration of the thing being waited for, in milliseconds, sited beside the
budget it justifies. This is the whole of the work; movements two and three fall out of it. It is
also the move that wants Caravan's own judgment rather than a research lane's, since the number is
a claim about the protocol.

**Move two -- state the coverage assert.** One line per family, in the `comptime` block already
present in each file, in harvest's exact shape:

```zig
// invariant: the patience of a confirm covers the longest legal take-on
assert(max_confirm_looks * note_rest_ms > max_take_on_ms);
```

**Move three -- refuse at the edge.** Harvest's assert is load-bearing because
`harvest.rye:324` turns away a longer linger. Where an edge enforces the named quantity, the assert speaks about the running system; where the
edge is absent, it speaks about two constants, and its comment should say which of the two it is
rather than borrow harvest's authority.

**Cost, bounded.** Five constants, five asserts, and five edge readings. Every one is inside a file
Caravan already owns, and none changes a running code path. **A build that fails is the successful
outcome of move two**, since a failing comptime assert names a pair of numbers that never covered
what they were chosen to cover.

## The falsifier

**This study falls if each of the five unchecked budgets already names its covered quantity
somewhere beyond the four rooms I read.** The measurement that would show it: a reader of `caravan/entrust.rye`,
`caravan/taper.rye`, `caravan/revoke.rye`, and `caravan/reclaim.rye` finding, for any of the five
families, a named constant or documented protocol bound on how long the awaited party may take. I
read the declaration comments of all six budgets and the bodies of all sixteen sleep sites, and
found the bound stated only for `max_linger_ms`. A single counter-example reduces the finding from
five families to four.

**It falls more weakly if the pairings are conventional rather than accidental** -- if
`taper.rye`'s and `entrust.rye`'s opposite directions are both derived from a rule written
somewhere in Caravan's design record. I searched the four module rooms rather than the whole tree,
which is the honest limit of the search.

**Horizon:** the census holds while `caravan/` keeps sixteen sleep sites. Any lap adding one
moves the count and leaves the argument standing.

**Confidence:** high on the census, which is counted and reproducible from the commands quoted.
Moderate on the inference that the pairings encode an intended relation. Low on any claim that a
false negative has occurred in practice, since this study observed none.

## What this hands the next hand

A count, six file-and-line citations, and one exemplar already in the tree that shows the shape
whole. The pattern harvest carries -- **wait, named quantity, edge refusal, comptime assert** -- is
worth more than the five asserts it would generate, because it is the form every future bounded
wait in this tree can be written in from its first line.
