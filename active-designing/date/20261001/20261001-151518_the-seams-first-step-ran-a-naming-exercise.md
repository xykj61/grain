# The seam's first step ran -- a naming exercise, not a new hash

**Language:** EN
**Style:** Gauge, Field setting (see `../../../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Design, landed -- **Room:** checkable -- the falsifier ran on metal and both outcomes
it names in the chart below are accounted for
**Stamp:** `20261001.151518`
**Kin:** [`../20260921/20260921-071008_the-weave-meets-tablecloth-by-content.md`](../20260921/20260921-071008_the-weave-meets-tablecloth-by-content.md)
-- the chart this page answers -- [`../20260905/20260905-153729_mantra-was-named-for-the-weave.md`](../20260905/20260905-153729_mantra-was-named-for-the-weave.md)

## What was asked

The seam chart named one falsifier: render a stored weave, hash the document, and compare against
the catalogue's resin for the same bytes. If the two agree, the seam is a naming exercise rather
than a build, and the honest outcome is a page recording that with its numbers. This is that page.

## What ran

`mantra/weave_tablecloth_seam_witness.rye` lifts a three-line `V1Row` record into a `Weave`, calls
`current()`, and joins the returned lines' `text` fields with `\n` -- the exact inverse of
`mantra/src/diff.rye`'s `split_lines`. It hashes the joined bytes with the same SHA3-256
lower-hex-64 function `mantra/recall_lap1.rye`'s private `digest_hex_of` computes, kept private to
that module and so reproduced here by hand. It then appends the identical bytes as a `BoltCatalog`
leaf through `append_leaf`, which computes its own `digest_hex` the same way, and compares the two
64-character strings.

```
mantra-seam: current() renders the lifted bytes exactly -- 3 lines, 45 bytes
mantra-seam: weave digest and catalogue digest agree -- 88932ddc777a20eacae31c67578ca420fbb81a7d587f663a2d45a7e28d5210f3
mantra-seam: an edited weave's digest still agrees with the catalogue's -- 4a407573dbc6c731539d1bf2037dc05670d37b86fb9adf66fd4232c7ec71c866
GREEN
```

Run it yourself:

```sh
./rye/bin/rye build mantra/weave_tablecloth_seam_witness.rye -femit-bin=mantra/bin/weave_tablecloth_seam_witness
./mantra/bin/weave_tablecloth_seam_witness
```

## The answer

The two digests agree, on the first document and on an edited second one, so the match holds past
one input rather than describing a lucky coincidence of the first. They agree by construction:
both paths hash the same bytes under the same algorithm, SHA3-256 lower-hex. `current()`'s output
asks exactly what the catalogue already asks of any byte string.

So the chart's falsifier lands on its "it already works" branch. The seam is a naming exercise
rather than a new hash, a new store, or a new wire shape -- exactly what the chart predicted for
this branch, now measured rather than reasoned about.

## What is still unbuilt, and why it is the next crux rather than this one's

Agreement between two independently computed digests over the same bytes is a fact about the hash
function, and the build still waits on its own small function. Today the tree keeps `current()`,
`append_leaf`, and `write_blob` apart; drawing one small function that calls the first and hands its
result to the other two is what remains. That function is a seam over two modules this page proves
compatible; naming it the next crux rather than building it here keeps this lap's frame at depth 1,
per [`../../../.claude/rules/quality-assurance.md`](../../../.claude/rules/quality-assurance.md).

## What stays whole

Nothing moved. The catalogue, the weave, and `split_lines` all stand exactly where they stood; this
page adds one witness and one reading, and the chart it answers keeps every word it wrote
(accrete-never-break -- a dated design page is testimony).

## Where this sits in the arc

The seam's first step is the chart's own name for this movement, and it has now run. The next
movement is the small wiring function named above; the reading that follows it -- one foundation
naming both of Mantra's promises as one promise wearing two clothes -- still waits on that wiring.
