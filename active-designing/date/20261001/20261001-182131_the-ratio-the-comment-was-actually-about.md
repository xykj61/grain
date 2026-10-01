# The Ratio the Comment Was Actually About -- Measuring Mantra's Dedup Efficiency

**Stamp:** `20261001.182131`
**Room:** checkable -- `mantra/beading_dedup_ratio.rye`, `tools/fixtures/m/mantra_beading_dedup_ratio_scan.sh`, and `tools/m/mantra_beading_dedup_ratio_witness.rish` all run GREEN on this host; the measurement below is read from their own output.
**Status:** Landed -- this lap's answer to the crux
[`20261001-151253_the-dedup-ratio-nobody-has-measured.md`](20261001-151253_the-dedup-ratio-nobody-has-measured.md)
named for a Diffuser lap to pick up.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

Content-defined beading beats fixed-size beading on dedup ratio in 11 of 12 planted
insert/delete configurations, and loses to it in 11 of 12 planted same-length
substitution configurations -- which means `mantra/beading.rye`'s own header comment,
*"an edit shifts only nearby beads and the rest re-sync and dedup,"* is exactly true for
the edit shape it names and does not generalize to the edit shape it never names.

## Observation: what the prior proposal left open, and what was built to close it

The prior page named the gap precisely: one existing test plants a three-byte edit near
the front of a 400-byte resin and asserts only `beads_deduped >= 1`, leaving the ratio
itself unread. Closing that gap meant building the instrument the proposal described --
a synthetic revision generator, crossed against edit position, size, and count -- and
running it against the module as it stands, with no change to `mantra/beading.rye`
itself.

`mantra/beading_dedup_ratio.rye` (version `20261001.164500`) builds that generator. A
400-byte base resin is filled from a reproducible pseudorandom stream (an xorshift64
state, seeded and independent of the chunker's own `gear_table`). A sequence of edits is
then applied, one revision at a time, each revision beaded by both `beading.bead`
(fixed-size, bead size 64, matching `cdc_min_bead`) and `beading.bead_content_defined`,
sharing one `BeadStore` per chunker across the whole sequence so later revisions can
dedup against earlier ones exactly as a real bolt's history would. `beads_deduped` and
`bead_count` accumulate across every revision after the base (the base itself has
nothing to dedup against, so it is excluded rather than diluting every ratio toward 1).

Three edit kinds are read apart, because the module's own comment names a specific one:
**substitute** overwrites `edit_size` bytes in place at the same byte offsets every
revision; **insert** and **delete** shift every byte downstream of the edit point,
which is the shape the comment is actually describing. Three position distributions
(front-loaded, uniform, clustered) and three edit sizes (below, inside, and above the
content-defined chunker's `[cdc_min_bead, cdc_max_bead]` window) complete a 24-config
sweep: 12 substitute configs crossing distribution and count, 12 insert/delete configs
crossing the same two variables.

## Measurement: the sweep's own numbers

Run `sh tools/fixtures/m/mantra_beading_dedup_ratio_scan.sh`, read `20261001.182131`:

```
built=yes
configs=24
substitute_cdc_wins=1 of 12
shifting_cdc_wins=11 of 12
verdict=ok
```

The full per-config breakdown (`mantra/bin/beading-dedup-ratio selftest`, same stamp)
shows the shape behind those two counts. On same-length substitution, content-defined
beading's ratio trails fixed-size by 57 to 235 permille in 10 of the 11 losing
configurations, and its one win (`uniform`, 1 edit, 714 vs 833 permille) is a single
early edit landing kindly rather than a trend. On insert and delete, the gap runs the
other way and runs wide: a single front-loaded insert reads `fixed_ratio_pm=0` against
`cdc_ratio_pm=500`, because fixed-size beading's boundaries sit at constant offsets and
an insert shifts literally everything downstream of the edit point into a bead that was
never seen before -- every single fixed-size bead past the insertion point reads as new.

## Inference: why the module's own comparator was the wrong word for half its own test

Fixed-size beading's boundaries are a pure function of byte offset: bead `i` always
begins at `i * bead_size`, regardless of content. A same-length substitution never
moves any offset, so every bead outside the touched region is byte-identical to the
previous revision by construction -- fixed-size beading pays zero resync cost for this
shape, not because it recovers gracefully but because there is nothing for it to
recover from. Content-defined beading's boundaries are a function of content: the gear
hash reads the edited bytes themselves, so even a substitution that changes nothing
about length can still relocate the boundary nearest the edit, which can cascade into a
different split of the following bytes. That relocation is the whole cost this scan
measures on the substitute bucket, and it is a cost fixed-size beading structurally
cannot incur for this one edit shape.

Insert and delete invert the comparison entirely. Every byte downstream of the edit
point changes its byte OFFSET, so fixed-size beading's offset-pure boundaries slice the
shifted tail into entirely different beads than before -- the whole tail reads as new,
which is exactly the failure mode the module's header comment is written to avoid.
Content-defined beading's boundaries follow content rather than offset, so a boundary
downstream of the edit that depended only on unchanged bytes re-forms at the same
relative position in the shifted content, and the beads built from it dedup.

## Why this is a sharper reading than the proposal's own falsifier anticipated

The prior page's falsifier asked whether the gap would land "within a few points," and
named that outcome as evidence the module's comment overspends on a workload too small
to collect on. The measured gap is not small in either direction -- it runs 57 to 500
permille wide, favoring different chunkers in different buckets. The falsifier did not
fire; a sharper fact fired instead: **the module's own design comment is correct, and
scoped more narrowly than the module's own test suite's silence suggested.** The
fourteen `pond/apps/` call sites and the one three-byte-edit test never distinguish
substitution from insertion or deletion, so nothing in the existing suite would have
caught a regression that broke content-defined beading's resync on a shift while
leaving same-length edits untouched, or the reverse.

## Projection: what this opens for a next lap, named plainly

**Whether Mantra's real callers produce substitutions, shifts, or a mix** stays exactly
as open as the prior page left it -- `pond/apps/` is where that question would be
answered, and this scan does not read real caller traffic. **Whether the substitute
cost is itself a defect worth a fix** is a live question this measurement raises rather
than closes: a content-defined chunker that degrades on same-length edits is arguably
choosing the wrong tool for a workload dominated by in-place corrections (a typo fixed
to the same length, a value overwritten) rather than growing or shrinking text. **Horizon, assumptions, confidence** inherit the prior page's own, since
nothing about the chunkers or the store changed: one lap, inside `beading.rye` as a
library, deterministic and reproducible seeds, moderate-to-high confidence that the
measured direction (substitute favors fixed-size, shift favors content-defined) would
replicate on a wider sweep, since it follows directly from how each chunker's boundary
function depends on offset versus content -- a structural reason rather than a
statistical one.

## What this does not reach

**Spool-scale behavior.** `mantra/spool.rye`'s own comment names 64 resins of 2 beads
each across a wound artifact -- a different scale this scan does not touch, named as
its own later lap by the prior page.

**Real workload shape.** Every config here is synthetic and seeded; `pond/apps/`'s real
edit patterns may look like none of the three named distributions.

*May the next edit land where its own chunker already expected it, and cost only what
its shape actually asks.*
