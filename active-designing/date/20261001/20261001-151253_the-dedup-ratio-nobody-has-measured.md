# The Dedup Ratio Nobody Has Measured -- a Fourth Moonshot for the Diffuser Lane

**Stamp:** `20261001.151253`
**Room:** vision -- a proposal page. Nothing below runs today; it names a measurement a future lap
can run and a bound it can fail against.
**Status:** Proposed -- vision.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

Mantra's content-defined beading is proven **correct** -- a bead-index reassembles to the exact
bytes it named, a missing or tampered bead refuses before a byte is trusted -- and it is proven
**efficient** only at the edges of the question: every test in this tree asks whether at least one
bead dedups and at least one is new, and the fraction of a resin's bytes a real edit actually
forces to re-deposit stays open.

## Observation: what is built, and what the existing tests actually assert

`mantra/beading.rye` splits a resin into content-addressed beads two ways. Fixed-size beading
cuts at constant offsets. Content-defined beading cuts where a gear hash over the running bytes
meets a mask -- the FastCDC method, credited in the module's own header -- so a boundary follows
the content rather than the offset, and an edit shifts only the beads near it while the rest
re-sync and dedup for free. The constants are pinned in the source: `max_resin_bytes = 512`,
`cdc_min_bead = 64`, `cdc_max_bead = 256`, a five-zero-bit mask giving an **average bead near 80
bytes**, `max_beads = 8` per resin.

`beading.BeadReport` already carries the number this moonshot wants: `beads_deposited` and
`beads_deduped` per call. So the instrument exists, and what runs against it so far tests a floor
rather than a ratio. Fourteen call sites across `pond/apps/` assert `beads_deduped == bead_count`,
which is the **identical-content** case: resave the same text, and every bead was already held.
One test, `mantra/recall_beaded.rye:263`, touches the harder case -- a three-byte edit near the
front of a 400-byte resin -- and asserts only `beads_deduped >= 1` and `beads_deposited >= 1`.
That proves dedup happened and something new was stored; the share of the 400 bytes that actually
re-synced is a separate, still-open number.

## Inference: the gap sits exactly where content-defined chunking either earns its keep or does not

Content-defined chunking's whole argument over fixed-size chunking is that a boundary shift from
one small edit stays local -- fixed-size beading would re-deposit every bead after the edit point,
while content-defined beading re-syncs within roughly one average bead length (~80 bytes) of the
edit and leaves the rest untouched. That argument rests on this tree's own module and awaits this
tree's own test: the one existing edit case plants its change at byte 30 of 400 and leaves the
fixed-size path's cost on that same input for a future lap to compute, so the comparison the whole
design rests on is still to run.

Three variables the one test holds fixed, each one plausibly able to move the ratio and each one
waiting for its own measurement:

- **Edit position relative to a chunk boundary.** A three-byte edit that falls inside one 80-byte
  chunk costs one chunk under CDC; the same edit landing near a boundary could cost two.
- **Number and spread of edits.** One edit near the front is the easiest case for any chunker.
  Mantra's own revisions (a session store, a spool, an edit store -- all named in `pond/apps/`)
  more plausibly see edits scattered across a resin's whole length over many revisions.
- **Edit size relative to `cdc_min_bead`.** An edit shorter than 64 bytes and one longer than 256
  each meet the boundary-finding mask differently, a difference the existing suite leaves
  untouched.

## Projection: the measurement, its floor, and its falsifier

**What to build.** One scan, built on the existing module alone: a synthetic revision-sequence
generator producing N resins of `max_resin_bytes` from one seed by applying K edits of size S at
position P (drawn from named distributions -- front-loaded, uniform, clustered), run through both
`beading.bead_fixed_size` and `beading.bead_content_defined`, reading `beads_deduped /
bead_count` from each `BeadReport` across the sequence.

**The bound worth comparing against.** `cdc_min_bead = 64` sets a hard floor: a single-byte edit
costs at least one bead under any chunker, so the best possible ratio for a K-edit sequence over
an N-resin, 8-bead-per-resin history is bounded above by `1 - K*max_edits_touched/(8*N)`,
computed per sequence rather than asserted once. The question worth the scan is less whether
content-defined beading beats fixed-size (the module's own comment already claims it will) and
more **by how much, and whether the gap closes or widens as edit count rises** -- the shape the
one-edit test leaves unseen.

**Horizon.** One lap, one scan script (`tools/fixtures/m/mantra_beading_dedup_ratio_scan.sh`
or similarly named), reading `mantra/beading.rye` as a library and staying inside it: the same
witness class, the same wire, the same storage already proven.

**Assumptions, named plainly.** The gear table is deterministic and seeded (read at
`mantra/beading.rye`'s `gear_table` comptime block), so a synthetic sequence stays reproducible
across runs -- already true of the module, carried rather than added by this proposal.
What stays genuinely assumed: that Mantra's real callers (`pond/apps/*`) produce edit patterns
resembling one of the three named distributions above, where the existing fourteen tests already
cover the identical-content case well.

**The falsifier.** Content-defined beading's dedup ratio landing within a few points of
fixed-size beading's, on a scattered, multi-edit sequence, would mean the module's own stated
reason for carrying two chunking strategies (*"shifts only nearby beads and the rest re-sync and
dedup"*) spends complexity the workloads this tree actually runs never collect on -- `max_beads =
8` is small enough that the two methods may simply lack room to diverge. A large gap that widens
with edit count would stand as the first real evidence for the design the comment already asserts.

**Confidence.** Moderate that the gap stays small rather than large: with only 8 beads and a
512-byte resin ceiling, content-defined chunking's resync advantage has little room to show
before beading's own size ceiling forces a new resin regardless. That smallness is itself worth
knowing -- it would place the real benefit, if any, at `spool.rye`'s scale (the spool's own
comment names 64 resins of 2 beads each, 128 beads), a second, larger lap of its own.

## Why this is a fourth angle rather than a restatement

The closed torus ladder measured **geometry** -- wrap, distance, placement on a grid. The closed
energy study measured **power**. The closed radial/polar study measured **coordinate systems**.
This proposal measures a fourth quantity, **dedup efficiency**: it asks whether an already-built,
already-correct deduplication scheme is *efficient* on the workloads this tree's own modules
actually produce, using an instrument (`BeadReport`) the module already emits and a test suite
that has so far asked it a yes/no question alone.

*May the next edit land where the gear hash already expected it, and cost only the bytes it
actually touched.*
