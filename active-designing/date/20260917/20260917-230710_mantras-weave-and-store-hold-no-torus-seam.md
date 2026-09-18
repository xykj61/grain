# Mantra's weave and store answer to one clock each -- a second checked negative

**Stamp:** `20260917.230710`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- checked negative, no build item claimed
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`session-logs/date/20260917/20260917-224056_aurora-deciding-and-sealed-hold-no-torus-seam.kyri`](../session-logs/date/20260917/20260917-224056_aurora-deciding-and-sealed-hold-no-torus-seam.kyri)
(Aurora's own checked negative, the same pattern one module earlier; recorded as a session log
rather than a dated essay since the reading found nothing to propose) -
[`20260826-021136_caravan-rearchitected-the-optimization-spine.md`](20260826-021136_caravan-rearchitected-the-optimization-spine.md)
(Move one, "wrap where the quantity is genuinely periodic, assert where it is linear") -
[`../mantra/src/weave.rye`](../mantra/src/weave.rye) - [`../mantra/src/store.rye`](../mantra/src/store.rye)

## The one sentence this piece is for

The prior diffuser round closed Aurora's boot and handshake code as a control case. That code sits
near the toroidal thread and holds a genuinely linear quantity. Its closing line pointed the next
round at Mantra's weave and store modules, ahead of any proposal there. This piece is that reading.
It answers the same way: each of the two modules grows toward its own ceiling and stops there, the
linear shape rather than the periodic one.

## What was read, and what it measures

Read in full on this tree, `20260917.230710`: `mantra/src/store.rye` (204 lines) and
`mantra/src/weave.rye` (2,179 lines, grepped for `%`, `wrap`, `ring`, `cycle`, and every `max_`
constant, the same discipline the prior round used on Caravan).

**`store.rye` runs a single straight line.** A blob's name is its SHA3-256 digest. The store writes
once under that name and keeps it. HEAD points at one blob. The module addresses one flat directory
by content name alone. `aurora/src/sealed.rye` carries the same shape: one exchange, written once,
standing where it landed.

**`weave.rye` carries exactly one `%` and one ceiling, and both answer a question a ring does not
ask.** The one modulo is `left_gen % 2 == 1` and its mirror `right_gen % 2 == 1`
(`weave.rye:726,731`). It reads the low bit of a generation counter as a tombstone: odd means
present, even means gone. The counter itself (`self.left_gen`, `self.right_gen`) climbs once for
every edit and keeps climbing. `gen()`'s own comment says why: *"Parity is the tombstone, and zero
is even, so a side that never saw the position answers false."* The low bit alone alternates, so it
carries a period of two in the narrowest technical sense. The field it decides is a boolean. Past
that one bit, the generation's plain climb carries every other answer the module needs.

**The one ceiling, `max_weave_lines = 1 << 20` (`weave.rye:142`), states a maximum rather than a
period.** All twenty-three of its call sites (`grep -n max_weave_lines mantra/src/weave.rye`)
compare a count or a counter (`next_pos`, `next_run`, `lines.items.len`) against the ceiling. Each
one returns `WeaveError.TooManyLines` or `WeaveError.CounterPastCeiling`, or asserts the bound
already holds. `next_pos` and `next_run` rise toward the ceiling and rest there. This is TAME's own
rule in Move one, made concrete: wrap where the quantity is genuinely periodic, assert where it is
linear. The grep proves it at every site it found, rather than a claim resting on one citation.

## The seam that exists, and why this piece names it and stops

`Place.less_than` (`weave.rye:337-363`) orders a document by four keys in sequence: `run`, then
`site`, then `ord`, then `pos`. The file's own comments show that ordering under live repair today.
`%807` and its kin, read on `construction/ITINERARY.md` at this same stamp, weigh whether `site`
should part from `run`. The comment at line 344 already carries the memory of one answer tried and
returned within the hour. Four fields naming one position is a coordinate in the loose sense. Each
of the four climbs on its own axis and rests at its own bound. The ordering serves one total order
over a document, rather than a point on a bounded periodic space. A moonshot proposed here today
would land inside a row another ship holds open under an active standfast, exactly the collision
`%745`'s own board discipline exists to prevent. The honest move is to name the seam plainly and
leave it for the hand already holding it.

## What this closes, and what it leaves

**Closed:** the candidate the prior round named -- Mantra's weave and store modules -- reads as
linear growth bounded by a ceiling, the same honest shape Aurora's boot and handshake code carried.
Both stand as control cases: code that sits near the torus thread and, read in full, answers to a
straight line rather than a ring.

**Left open, named rather than guessed:** three real Caravan modules await this same grep-then-read
discipline -- `unhand.rye`, `confer.rye`, `revoke.rye`, the supervised-process trio cited in
[`vocabulary-dependent.md`](../.claude/rules/vocabulary-dependent.md). So does `caravan/`'s
remainder beyond `queue.rye` and `cycle.rye`. The torus thread's own two live rings turned up by
grepping the whole of `caravan/`, `tally/`, and `mantra/src/` for real modulo arithmetic, per the
prior round's log. A third search of that same kind, repeated as the tree grows, costs less than
reading any one remaining file cover to cover.

## The falsifier

A real wraparound in either module overturns this reading -- concretely, any array indexed by a
value taken modulo a bound, anywhere in `store.rye` or `weave.rye`. The grep this piece ran (`% `,
`wrap`, `ring`, `cycle`, every `max_` constant) stands printed above in full, rather than
summarized. A future reader re-runs it in one line:

```
grep -n "% \|%=\|wrap\|ring\|cycle\|max_weave_lines\|max_blob_bytes" mantra/src/weave.rye mantra/src/store.rye
```

**Confidence.** High that the reading is complete for these two files at this stamp. Every `%` and
every `max_` constant in both modules stands accounted for above, and both files were read whole
rather than sampled. Medium on whether the two files keep this shape. `weave.rye` is under active
repair this same day (`%807`), and a future field or a future ordering key could bring a bounded,
wrapping quantity that this reading found absent only because the day had yet to write it.

## Why a second checked negative earns its place

A single control case could be an accident of which file a round happened to open. Two readings
change that. Aurora's boot and handshake code, and now Mantra's weave and store, come from two
different modules for two different reasons, and both land on the same finding. Together they name
where this tree's genuine periodicity actually lives: inside the small, purpose-built rings
(`queue.rye`'s buffer slot, `cycle.rye`'s domain lap, `tally/gardens.rye`'s three named gardens),
standing apart from the many modules that merely carry a bound. A tree that keeps only its positive
findings loses this shape. The negative readings are what let a future round trust that the torus
thread's remaining candidates are genuine, standing in files somebody actually checked.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line and leaves
`construction/ITINERARY.md` exactly as it stands, given the card's own tight headroom this stamp.
