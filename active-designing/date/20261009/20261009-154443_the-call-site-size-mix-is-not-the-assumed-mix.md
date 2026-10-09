# The call-site size mix is not the one the probe assumed

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Room:** checkable -- the reading is a static count over tracked sources; no probe was built or run this lap
**Status:** Living
**Stamp:** `20261009.154443`
**Kin:** [the mixed population reverses the time finding, and the space finding holds](20261009-153349_the-mixed-population-reverses-the-time-finding.md) - [the mixed-lifetime cost is space, not time](../20261003/20261003-102318_the-mixed-lifetime-cost-is-space-not-time.md)

## The question

The last probe named its own horizon in one sentence: feed the size mix from this tree's own call
sites, instead of a log-uniform draw between 16 and 4,096 bytes with a 90/10 hot skew. That sentence
carries an assumption it did not measure -- that the sizes a long-running caller asks for are small.
This lap asks the cheap question first: what sizes do the call sites in this tree request?

## What was counted, and how

Observation, not inference. A static count over tracked `.rye` sources, run on this pier at
`20261009.154443`:

```
git grep -h -E 'garden\.alloc\(' -- '*.rye'     # 656 lines
```

Each line was classified by the text after the `garden.alloc(` call's first comma:

| Shape of the size argument | Lines | Example |
|---|---|---|
| A product of two dimensions (`stride * height`, `@as(usize, w) * ...`) | 188 | `brushstroke/edit_preview.rye:121` |
| A literal integer | 100 | `brushstroke/brush_parse.rye:487` takes `pixel_bytes`, a named value, so it sits in the residue; literal sites are fixed-size buffers |
| A `.len` of another slice | 58 | copies sized from their source |
| Other expressions, not classified by this quick pass | 310 | -- |

The classifier is a single awk pass, and its 310 residue lines are unclassified rather than explained;
they make no claim about what those sites ask for. The grep is free: the tracked tree grows each lap, so
run it rather than trusting these figures. `garden.dupe` and `garden.create` were not counted this lap.

## What this says, and what it does not

**Observation:** the largest named population of allocation sites in this tree sizes its buffer as a
two-dimensional product -- the Brushstroke canvas family, one `stride * height` per frame surface.
A 1920 by 1080 canvas at four bytes per pixel is 8,294,400 bytes, roughly two thousand times the top
of the probe's 4,096-byte range.

**Inference:** the probe's size mix describes small, short-lived objects -- the case where `smp_allocator`
reuses a freed block. A caller that allocates canvases is a different workload. Its requests are large,
few per second, and mostly held for one frame. Whether `Region` or `smp_allocator` wins on that mix is
not something the earlier table answers.

**What is not established:** call-site count is not call frequency. A canvas site might run once per
frame at sixty frames a second, or once per session. This lap measured neither the frequency nor the
lifetime of any site. The 310 unclassified lines could also hide a second small-object population
that the earlier assumption happens to match.

## Projection, with its falsifier and confidence

**Horizon:** the next lap that touches this question, which would rank the classified sites by an
actual request rate, from a trace or from a counted loop, rather than by how many lines they occupy.

**Assumption:** a line count stands in for a request mix only loosely. It is named as such here.

**Falsifier for this reading:** a frequency count in which the literal and `.len` sites, weighted by how
often they run, dominate the bytes requested. If the small sites carry most of the requests and most of
the bytes, the probe's assumed mix stood and this essay's large-object concern is a count with no weight
behind it.

**Falsifier for the concern itself:** a canvas site that runs once per session. Then its one large
request is a rounding error beside the small churn the probe measured, and the time finding stands
as first written.

**Confidence:** high that the count is as stated, since it is a grep over tracked bytes. Low on what it
means for allocator choice, since frequency and lifetime were not read. Moderate that the probe's
assumption is at least unexamined in this tree, which is the finding that stands whatever the frequency
count says.

## What this hands onward

**To this lane:** do not widen the synthetic probe to 65,536 bytes as the next step. Rank the sites by
frequency first. A wider draw on an unranked mix would repeat the assumption at a larger scale.

**To Bakery and Tally:** the canvas population is the one a region-or-smp choice would meet first in
this tree. The choice belongs to Tally, whose Region is the bounded arena, and the number to bring is the
frame rate of the canvas path, which this lane has not measured.

Confidence, once more: the count is a fact about the source. What it predicts about the allocator is an
open question, and the probe that would settle it is not yet built.
