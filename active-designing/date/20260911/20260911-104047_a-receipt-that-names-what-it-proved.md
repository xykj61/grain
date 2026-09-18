# A receipt that names what it proved

**Stamp:** `20260911.104047`
**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed -- awaiting Keaton's word on the second half
**Room:** mixed -- the measurement is checkable and stands today; the sharing proposal is vision
**Kin:** `.claude/rules/read-scope.md` - `construction/standing-equipment.kyri` - `tools/fixtures/s/standing_equipment_run.sh` - REDS `%568`

## The reading

`construction/standing-equipment-runs.kyri` records when each rostered guard last ran, and it is
untracked on purpose. Its own header says why: *a fresh clone reads `never run here` rather than
inheriting another machine's memory.* Across machines that is exactly right. A guard green on a Mac
proves nothing about a Linux pier, and a card that travelled would say otherwise.

This pier is one machine. Eight checkouts sit under one home directory on one host, sharing eight
cores, and each keeps its own card. So the same sentence that protects a clone on another machine
also asks eight checkouts on this one to prove the same guard eight times.

**Measured `20260911.104047`, by reading all eight cards on this pier:**

| Reading | Count |
|---|---|
| Guards seated `tier cadence` | 83 |
| Cadence guards holding a receipt in at least one checkout here | 66 |
| Cadence guards no checkout here has ever run | 17 |
| Cadence guards this checkout has never run | 69 |

Per checkout, the clock has been turned for 8, 8, 9, 14, 17, 18, 47 and 64 of the 83. The union is
66, and the union is invisible: every card answers for itself alone, so the pier reads its own
coverage as somewhere between a tenth and three quarters depending on which chair you sit in.

**The cost of one full cadence turn is real.** This lap ran ten of them and spent 2,393 seconds --
`caravan_suite` 776s, `crypto_suite` 681s, `ales_suite` 411s, `sow` 319s, and six more under a
minute each. Turning the remaining 69 here, at that rate, is roughly four hours of one core. Eight
checkouts owe that separately, which is a working day of the pier's whole capacity to prove one
tree's bytes eight times.

## What the guards actually prove

A guard reads bytes and answers about them. Two checkouts standing at the same commit hold the same
tracked bytes, so a guard's answer is the same answer -- and the runner already knows this, because
`construction/standing-equipment-receipt.kyri` records `head` and `digest` beside the verdict, and
`--scoped` uses exactly that pair to reprove only what moved. The machinery for *a receipt that
names what it proved* is already built, one file over.

The run card is the piece that still records only **when** and **where**. A `ran` row reads

```
ran caravan_suite 20260911.093012 green cadence 940546
```

and cannot say whether that green spoke for today's tree or for a tree from four days ago.

## The proposal, in two halves

**Half one, and it wants no word from anyone: a `ran` row carries the head it proved.** That is a
within-checkout improvement with no law to cross. It lets `cadence_never_run_here` grow a sibling --
*never run against these bytes* -- which is the reading a lap actually wants before it trusts a
green. It also makes the second half checkable rather than hopeful.

**Half two is Keaton's word, because it crosses a seated law.** Letting a checkout honour a sibling
checkout's receipt for the same head means reading another ship's state, and
[`read-scope`](../.claude/rules/read-scope.md) says a lap reads its own body's files and leaves
every other body's alone. That rule was written for token economy rather than secrecy, and this
would be a narrow, named exception -- one file, one direction, read-only. It is still an exception,
and the boundary between *bounded reading* and *one ship trusting another's word* is the whole
question.

## The falsifier

If two checkouts of this tree at one commit can differ in bytes a guard reads, then a head is the
wrong key and the proposal fails as written. Two ways that is true today: a guard that reads
untracked state -- `session-output/`, `.lap/`, a built binary under `mantra/bin/` -- and a guard
whose answer depends on the machine's live load, which `%700` has open right now over a witness that
answered red and then green on one unchanged tree. **So the honest form of half two is narrower
still:** only a guard whose watched set is declared and wholly tracked could ever share a receipt,
and the roster does not declare a watched set for most guards.

That narrowing is what makes half one worth doing first. A head on every `ran` row costs one field
and tells the truth about staleness immediately; whether a receipt may ever cross a checkout
boundary is a question that needs the watched sets declared before it can be answered at all.

## What this does not claim

That the cadence clock should turn faster. `--cadence-slice` exists and defaults to 0, and where
that default should sit is already on the card as Keaton's word. This page asks a different
question: when a guard has run, what did it prove, and who else may know.
