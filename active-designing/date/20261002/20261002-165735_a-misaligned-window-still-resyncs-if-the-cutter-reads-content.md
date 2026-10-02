# A misaligned window still resyncs, if the cutter reads content

**Style:** Gauge at Field - **Room:** vision -- a reading of tracked source, proven on scratch
metal outside the tracked tree ([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Stamp:** `20261002.165735`
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra
**Kin:** [the split itself never resyncs](../20261001/20261001-190906_the-split-itself-never-resyncs.md) -
[`../../../mantra/spool.rye`](../../../mantra/spool.rye) - [`../../../mantra/beading.rye`](../../../mantra/beading.rye)

## The question left open

The kin essay found that `mantra/spool.rye`'s own resin split falls at a fixed, absolute byte
offset, and named a falsifier it left untried: a `spool_content` variant threading
`bead_content_defined` through each resin's own beading. The natural guess favors an unchanged
outcome -- a resin window drawn from a shifted stream hands a chunker exactly the bytes it finds at
that fixed offset, whatever the chunker then does with them. This essay builds the smaller half of
that falsifier -- the inner-beading swap alone, the resin split held exactly as fixed as
`spool.rye` draws it -- and measures what actually happens.

## Method

A scratch file, `mantra/_scratch_spool_cdc_inner.rye`, reused `beading.rye`'s own
`bead_content_defined` and `BeadStore`, leaving both exactly as landed. It copied
`spool_content`'s fixed resin-split loop verbatim: `beading.max_resin_bytes`-wide absolute strides
from position 0. It changed one call inside that loop, from `beading.bead(store, resin,
spool_bead_size, ...)` to `beading.bead_content_defined(store, resin, ...)`. That is the one swap
`spool.rye`'s own header already names and leaves untried.

The sweep matched the kin essay's own scale. A 2048-byte base artifact, four resins. A 40-byte
insert or delete, planted early (offset 50), mid (straddling the resin 0/1 boundary), or late (near
the end). Each config wound the base, then the edited revision, into one shared store, and read the
second winding's own dedup.

The build used `vendor/zig-toolchain/zig` via `tools/fixtures/r/rye_build.sh`, and ran on this
host. The scratch file was removed once this essay was drafted. `spool.rye` and `beading.rye`
stayed exactly as landed throughout, and every byte of the scratch file is now gone from the tree.

To confirm the baseline rather than quote it from memory, the already-landed
`mantra/spool_dedup_ratio.rye` was built and run fresh in the same session.

## Observation: the fixed-fixed baseline, re-confirmed

```
insert early=0  mid=111  late=777   (ratio_pm, bead_count=9 each)
delete early=0  mid=125  late=875   (ratio_pm, bead_count=8 each)
```

These match the kin essay's own printed numbers exactly.

## Observation: fixed resin, content-defined bead

```
insert early=391  mid=538  late=857   (ratio_pm, bead_count=21-26)
delete early=521  mid=652  late=950   (ratio_pm, bead_count=20-23)
```

Every one of the six readings rose. The sharpest change sits at `early`, the case the kin essay
called a total loss: insert climbed from 0 to 391 permille, delete from 0 to 521. At `mid`, the
position straddling the fixed resin boundary itself, insert rose from 111 to 538 and delete from
125 to 652. At `late`, where almost the whole artifact sits upstream of the edit, the fixed-fixed
baseline already sat close to the substitute floor (777-875), and the content-defined swap closed
most of the remaining gap (857, 950).

## Inference: a shifted start still carries real content inside it

`bead_content_defined`'s own comment names the reason: "the hash resets per bead, so a bead
depends only on its own bytes." A fixed resin window, drawn from a shifted stream, opens at a
mislanded absolute offset. Yet it still carries mostly the base artifact's own bytes, read through
a differently-placed frame. The gear-hash walk inside that frame crosses some leading stretch, then
reaches a real content boundary. From there it finds the same local byte patterns the base winding
found, and cuts in the same place. The bead it produces reads identical to one already in the
store, even though the resin holding it reads, as a whole, differently from the resin it held
before the edit.

A fixed splitter lacks this option entirely. Its boundaries are decided before a single byte is
read, so a window shifted by even one byte compares its old fixed-size slices against new ones
starting one byte later. A match arrives only when the content happens to realign with the fixed
stride by coincidence -- the kin essay's own `mid` reading, 111-125 permille, is exactly this
coincidence.

## What this leaves standing, read plainly

**This stays silent on whether `spool.rye` should change.** The fourth-angle essay's own closing
crux still holds its ground: every live caller in this tree writes a spooled artifact exactly once,
so today's cost and this recovery both stay uncollected by any caller that exists. This essay
answers only the mechanical question the kin essay named and left open.

**This measures beads, rather than bytes saved.** `ratio_pm` here counts the fraction of *beads*
deduped, and the two regimes produce different bead counts from the same content -- 8-9 fixed-size
256-byte beads against 20-26 content-defined beads averaging roughly 80 bytes each (`beading.rye`'s
own `cdc_mask` comment: "average bead near 80 bytes"). A higher permille over a larger,
finer-grained population and a lower permille over a smaller, coarser one answer two different
questions until a reading counts bytes rather than beads -- named here as the gap a next reading
would close before this result could stand as a byte-for-byte efficiency claim rather than a
resync-happens claim.

**This builds half the falsifier.** The kin essay named two variants: this inner-beading swap, and
a resin-boundary split that itself tracks content. Only the first stands built here. Whether a
content-defined resin boundary would recover further, or whether the inner-beading swap alone
already captures most of the available recovery, stays the open half.

## Falsifier

**Claim:** swapping `beading.bead` for `beading.bead_content_defined` inside a fixed-offset resin
loop recovers real dedup at every position this sweep tested, including `early`, where the
fixed-fixed baseline reads exactly zero. **Falsifier:** re-running this sweep at a wider edit size
(200 bytes, matching the kin essay's own substitute-size variant) or at a smaller `base_len` would
settle whether the recovery holds generally or is an artifact of this one scale; this essay runs
only the 40-byte scale. **Confidence:** high that the mechanism is real, since it follows from
`bead_content_defined`'s own per-bead hash reset rather than from a sampled coincidence, and all
six readings move the same direction; moderate on magnitude, since the bead-count mismatch named
above leaves the exact byte-level recovery still to measure.

## Bound

One scratch build and run, outside the tracked tree, against two already-landed library modules
(`beading.rye`, `spool.rye`) left exactly as they stood. No new witness, no new module, no Swift
file. Graded A/96 at Field.

*May the next window this tree draws carry a cutter that reads what is actually inside it.*
