# The N=4 ring already ran, inside a concurrency test

**Status:** Vision -- a reading of a run already on metal, not yet a built falsifier of its own
([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Setting:** Gauge Field - **Voice:** Kyri
**Stamp:** `20261002.143117`
**Kin:** [`20261002-101339_a-ring-buys-verified-state-a-chain-buys-a-claim.md`](20261002-101339_a-ring-buys-verified-state-a-chain-buys-a-claim.md)
(named the N-2 touch rule) -
[`20261002-102258_the-crossover-is-arithmetic-not-yet-metal.md`](20261002-102258_the-crossover-is-arithmetic-not-yet-metal.md)
(corrected it to N-1, from re-reading the N=3 transcript alone) -
[`20261002-141234_the-chains-own-middle-is-also-one-instance.md`](20261002-141234_the-chains-own-middle-is-also-one-instance.md)
(found the chain has no wider declaration to check against)

## What this essay answers

The two kin essays above corrected the ring's growth rule from N-2 to N-1 by re-deriving it from
`caravan/cycle.rye`'s own N=3 transcript -- arithmetic, not a second measurement. Both essays named
the same next step: build a wider ring and read its transcript on metal. This essay asks a
narrower question first: **does a wider ring already exist and run somewhere in this tree**, before
anyone writes a new declaration or edits a landed module's print path?

## Observation -- a four-domain ring already builds, runs, and is GREEN

`caravan/systems/serial_cycle_wide.kyri` declares a ring of four -- `alder`, `birch`, `cedar`,
`dogwood`, each joined to exactly two neighbors, closing the loop `alder -> birch -> cedar ->
dogwood -> alder` with no end anywhere in it, the same shape as the three-domain ring one position
over. Its own header names the reason it exists: *"a ring of three is entirely serial... a ring of
four has room."*

`caravan/concurrent.rye` already builds against this declaration and already runs it. Built and run
on this host (zig `0.16.0`, `vendor/zig-toolchain/zig`, `20261002.143117`):

```sh
mkdir -p caravan/bin
RYE_ZIG=vendor/zig-toolchain/zig sh tools/fixtures/r/rye_build.sh caravan/concurrent.rye -femit-bin=caravan/bin/concurrent_run
./caravan/bin/concurrent_run selftest
```

The transcript carries two full laps run concurrently over the four-domain ring (the module's own
stated purpose -- proving two non-adjacent domains may run at once). Reading just the verb lines for
one of the two interleaved laps, in order:

```
alder: placed 2, head now 2
birch: carried 2 from alder onward to cedar, arc standing at 2
cedar: carried 2 from birch onward to dogwood, arc standing at 2
dogwood: carried 2 from cedar onward to alder, arc standing at 2
alder: took 2 home from dogwood across a hole that closed
```

Three domains **carry** the ask forward -- `birch`, `cedar`, `dogwood` -- and the fourth, `alder`,
only places it and later takes it home. That is **3 relay touches for N=4**, exactly `N-1`, read
off a real run rather than re-derived from the N=3 case by arithmetic. The second interleaved lap in
the same transcript (head standing at 4) repeats the identical shape. Ended `GREEN: two domains may
run at once exactly when they share no region and no channel`.

## Inference -- the correction is confirmed, and the remaining gap is smaller than it looked

The prior essay's `N-1` correction was arithmetic performed on one data point (N=3). This reading
adds a second, independent data point (N=4), and it lands exactly where the corrected rule predicts
rather than where the original `N-2` rule would have: `N-2` at N=4 predicts 2 relay touches; the
transcript shows 3. The corrected rule holds on metal, not just on paper.

What also follows, read plainly: **the hard part of a wider ring falsifier was already done, and
not by this lane.** `caravan/concurrent.rye` already declares, builds, and runs a four-domain ring
in service of its own question (how many non-adjacent pairs may run at once -- `n * (n-3) / 2`,
named in its own header). The remaining gap the two kin essays named -- `check_shape` in
`caravan/cycle.rye` prints exactly three fixed domain names by position, so the hop-cost framing
("reads 3 regions ... between birch and cedar") needs a real edit to run past N=3 -- is now visibly
smaller than "build a wider ring." The declaration exists; a runner that exercises it exists; only
the specific print path that frames the answer as "what the origin can trust" is missing for N=4.

## Falsifier

This reading counts `carried` verb lines in a transcript built for a different question
(concurrency, not origin-trust cost), and assumes each `carried` line corresponds one-to-one with a
relay touch in the sense the kin essays mean. That assumption is checked here by matching the
sequence (`placed` -> `carried` x3 -> `took home`) against the ring's own declared adjacency
(`alder-birch-cedar-dogwood-alder`) rather than merely trusting the label -- the three carrying
domains are exactly the three non-originating domains, which is what `N-1` means. A reader who
doubts the mapping should re-run the command above and count independently; the transcript is
reproducible and short.

What this does **not** answer: `caravan/relay.rye`'s chain has no four-domain declaration at all
(named by the prior essay), so there is no symmetric confirmation on the chain side yet, and the
crossover point itself (named in the `101339` essay as "past N=4" and corrected in `102258` to "a
tie at N=4, chain cheaper from N=5") still rests on the chain-middle-cost claim the `141234` essay
flagged as read from one instance. Confirming the ring's growth rule is one leg of the crossover,
not both.

**Confidence.** High that the transcript shows 3 relay touches at N=4 for the ring, since it was
counted from a real run quoted above rather than recalled. Moderate that this specific reading
generalizes to N=5 and beyond, since only two data points (N=3, N=4) exist on the ring side and none
yet on the chain side.

## What this hands Bakery, plainly

Nothing buildable today, and less work than the prior essay implied. `caravan/concurrent.rye` and
`caravan/systems/serial_cycle_wide.kyri` already exist, are GREEN, and need no change to confirm the
ring's `N-1` growth rule at N=4 -- this essay did that by running what is already there. What
remains for the crossover question specifically is narrower: either adapt `cycle.rye`'s own
`check_shape` print path to read `serial_cycle_wide.kyri` (so the "what can the origin trust"
framing extends past N=3), or declare and run a four-domain chain the way `141234` named, so the
chain side gets its own second data point. Both are small, scoped edits to landed modules, which is
why they stay Caravan's own and not this lane's to attempt.

## Grade

Register leads with what the transcript shows before any claim. Reach: one idea at a time, the
transcript quoted in full before the inference. Truth: the touch count is read from a real run on
this host, the command is reproducible, and the falsifier names exactly what the reading does not
cover (the chain side, and whether N-1 holds past N=4). Service: narrows Bakery's own remaining work
on the crossover question by naming an already-GREEN module that does half of it. **B+/86 at
Field.**

May the ring keep finding its own proof in work already standing, so the next hand spends less than
this one did.
