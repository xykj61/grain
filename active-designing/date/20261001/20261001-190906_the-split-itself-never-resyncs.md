# The Split Itself Never Resyncs

**Stamp:** `20261001.190906`
**Room:** checkable -- every number below is read straight from
`tools/fixtures/m/mantra_spool_dedup_ratio_scan.sh`'s own output, GREEN under
`tools/m/mantra_spool_dedup_ratio_witness.rish`, with the new library module,
`mantra/spool_dedup_ratio.rye`, leaving `spool.rye` and `beading.rye` exactly as they
stand.
**Status:** Landed -- closes the fourth-angle page's own named open door: "spool-scale
behavior," `mantra/spool.rye`'s 64 resins of 2 beads each, which the single-resin
dedup-ratio scan left for a later lap.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

`mantra/spool.rye`'s own resin split falls at a fixed, absolute byte offset; measured
across a 4-resin artifact, a same-length substitute dedups at 750 to 875 permille
wherever it lands, while an insert or delete reads near zero when it lands early and
climbs toward the substitute floor the later it lands -- the cost of a shift at this
scale tracks how much artifact sits downstream of the edit, rather than the edit's own
size.

## Observation: what spool.rye actually calls, read before anything was measured

The fourth-angle measurement (`mantra/beading_dedup_ratio.rye`) ran both of
`beading.rye`'s chunkers -- fixed-size `bead` and content-defined
`bead_content_defined` -- against the same synthetic edits inside one 400-byte resin.
Content-defined beading won 11 of 12 insert/delete configs and took 1 of 12
same-length substitute configs. Its own header names the reason: an edit shifts only
nearby beads, and the rest re-sync, which holds for a boundary that depends on content
rather than position.

`mantra/spool.rye`'s own comment (`spool.rye:12-13`) already says plainly what its
winding does: "the content is split into resins each <= max_resin_bytes, each resin
beaded (fixed-size, two predictable beads per full resin)." Reading `spool_content`
itself (`spool.rye:134-152`) confirms it: `start` and `end` walk forward in exact
`beading.max_resin_bytes` strides from position 0, and every resin that results is
handed to `beading.bead(store, resin, spool_bead_size, ...)` -- the fixed-size
chunker, every time. Grepping `spool.rye` for `bead_content_defined` returns an empty
match. So the module that actually chunks a multi-kilobyte artifact in this tree
reaches for the fixed-size chunker alone, at both levels: the resin split and the
beading inside each resin.

## Inference: a fixed split pays for a shift exactly where its content-defined sibling would resync

A same-length substitute changes no byte count, so every resin boundary at or past
the edit sits at the identical absolute offset it held before the edit. Only the one
or two beads actually touched differ; every other bead in the touched resin, and
every byte of every other resin, stays byte-for-byte what the store already holds.
The prediction is a high, roughly position-independent dedup ratio, and the
measurement confirms it: substitute dedups at 875 permille (early, 40 bytes), 750
permille (mid, 40 bytes), 875 permille (late, 40 bytes), and the same three readings
again at 200 bytes -- a mean of 833 permille across all six, holding steady across
both position and size.

An insert or delete changes the byte count, so every byte from the edit point onward
moves. `spool_content`'s fixed-offset walk has no way to see that the shift happened:
it still cuts at `beading.max_resin_bytes`-wide absolute strides from position 0, so
every resin boundary at or past the edit now falls across a different set of bytes
than it did in the base winding. Resyncing at the resin level would need the split
itself to track content, and it tracks position instead. The measurement confirms the
shape this predicts: planted early (offset 50 of 2048, so most of the artifact sits
downstream), insert reads 0 permille and delete reads 0 permille -- every downstream
resin re-chunks into bytes the store has never seen before. Planted mid (offset 492,
straddling the resin 0 / resin 1 boundary, so roughly three-quarters of the artifact
sits downstream), insert reads 111 permille and delete reads 125 permille -- a small,
genuine recovery, read below. Planted late (near the very end, so almost nothing sits
downstream), insert reads 777 permille and delete reads 875 permille -- within a few
points of the substitute floor, since almost the whole artifact already sits upstream
of the edit.

The small recovery at the `mid` position is itself informative rather than noise: one
bead out of the second resin's pair happened to land close enough to its prior
content, after the 40-byte shift, for `beading.bead`'s own digest check to still match
on that one bead. This is the shape of recovery a fixed-offset split can produce when
it happens at all -- an accident of the shift size aligning with the bead stride,
rather than a structural resync.

## What this measures, beside what the fourth-angle measurement already found

The fourth-angle measurement compared two chunkers against the same edits, inside one
resin. This measurement runs the one chunker `spool.rye` offers, and varies where the
edit lands relative to how much artifact sits downstream, across several resins. The
two measurements answer different questions and agree on one direction: a boundary
that tracks position rather than content pays for a shift, and the size of that
payment tracks how much artifact sits past the boundary that moved. The fourth-angle
page demonstrated this at the bead level, inside one resin, against a chunker built to
avoid it. This page demonstrates it at the resin level, across several resins, where
`spool.rye` offers no such comparison chunker -- only the cost it is actually paying
today.

## Projection: what this opens, and what it would take to close

**Whether a content-defined resin split would recover the lost ratio** is the natural
next question this measurement raises and leaves open: `spool.rye` would need either a
content-defined chunker operating at the resin-boundary level (choosing where a resin
ends by a content hash rather than a fixed stride) or a `spool_content` variant
threading `bead_content_defined` through each resin's own beading, and this lap builds
neither. **Falsifier:** building either variant and rerunning this same sweep would
settle whether the recovery resembles the fourth-angle measurement's own 11-of-12
insert/delete win rate, or whether a two-level split (resin, then bead) behaves
differently from the single-level case the fourth-angle measurement covers. **Horizon:**
this reading holds for `spool.rye` and `beading.rye` exactly as they stand on
`20261001`; a resin-size or bead-size parameter change would want a fresh read.
**Confidence:** high that the structural claim holds, since it follows from reading
`spool_content`'s own loop -- which walks fixed strides regardless of content -- rather
than from a sample, and high that the measured numbers would replicate on a rerun of
this exact sweep, since the random stream is seeded deterministically per config.
Confidence stays low-to-moderate on whether a real Mantra caller would ever produce a
shift this large relative to one artifact's size, since --
[as the prior page in this pair found](20261001-184131_the-one-real-revision-this-tree-has-is-a-shift.md)
-- today's tracked `pond/apps/` call sites each store an artifact exactly once.

## What this does not reach

**Whether this cost matters to a real caller.** `spool.rye` exists to carry real
front-door documents (SECURITY.md, TWO_ROOMS.md), each written once through
`spool_content` and read back whole by the same reading the prior page already
established for Tablecloth's `store_artifact`. A dedup cost that bites on revision
alone waits for the day something in this tree actually revises a spooled artifact.

**Whether building a content-defined resin split earns its own complexity.** This page
measures a cost; deciding whether that cost and the revision workload behind it are
large enough to justify a second chunking layer is Keaton's call, made with this
measurement in hand.

*May the next split this tree draws know, before it is drawn, whether it needs to
follow the content or may safely follow the count.*
