# The Radius That Keeps a Reading Order

**Language:** EN
**Style:** Gauge, Field setting
**Voice:** Kyri
**Status:** Proposed design study -- **mixed room**: the accepted receipt bounds are checkable; the radial surface and its performance remain projections until a witness runs
**Stamp:** `20260914.002615` (EDT)
**Milestone:** The receipt you can read
**For:** Diffuser surface work, with a build handoff to Bakery's proof graph

## The question

Can a radial or polar arrangement help a person see a receipt as one bounded whole while keeping
the exact reading order required by the accepted product contract?

The useful version of the idea is modest. Radius may group fields visually. Product meaning,
accessibility order, focus order, and replay order remain upstream inputs.

## Observation

The accepted contract at `active-designing/20260912-201126_the-receipt-you-can-read-contract.md`
bounds the Receipt Card at **72 cells wide by 18 rows high**, read on **2026-09-14** from that
living contract. The same contract requires Skate's Still frame and accessibility snapshot to carry
every deciding Linengrow field in the same reading order.

The public `LinengrowReceipt` projection was absent both locally and at `xy/main` when
`tools/fixtures/p/path_absence_scan.sh` fetched and read it on **2026-09-14**. The concrete surface
adapter therefore remains unbuildable in this lap without assigning product meaning outside
Linengrow.

The frame's limiting dimension is its **18-row height** rather than its 72-cell width. A full circle that
fits inside the frame has a radius below **9 rows** before borders, labels, and focus space are
reserved. This is geometry derived from the contract's frame ceiling, not a measured renderer
result.

## Inference

A literal circular text layout spends scarce vertical cells and breaks the natural left-to-right,
top-to-bottom path used by text rendering and accessibility tools. That trade buys decoration while
making the product's required order harder to inspect.

A radial grouping can keep the useful part if the radius stays descriptive. One center label may
name the receipt. Concentric groups may distinguish identity, terms, value, and time. Every field
still occupies an ordinary row in one canonical linear sequence, and the radial metadata only says
which group that row belongs to.

This keeps the surface single-stranded: `LinengrowReceipt` decides product meaning, Brushstroke
describes rows and optional groups, and Skate renders the same ordered rows in Still, Settle, and
Respond. Accessibility reads the row sequence directly rather than reconstructing an angle.

## Proposed implementation floor

Once `LinengrowReceipt` lands, Brushstroke may emit a bounded description with these private
surface values:

```text
ReceiptCard
  rows[18]
  row_count <= 18
  group_of_row[18] = identity | terms | value | time
  center_label = receipt
```

The proposed group value is presentation metadata. It adds no product field and changes no value,
status, or authority. Skate's first renderer should ignore `group_of_row` and prove the complete
linear Still frame. A later renderer may use the group to place a bounded visual guide while keeping
the same row coordinates, focus order, and accessibility snapshot.

For Bakery, the buildable proof seam is content based: the receipt projection, Brushstroke
description, Skate renderer, and accessibility snapshot belong in one declared closure. Changing a
group must rerun surface and accessibility proofs. It must not rerun Mantra replay when the receipt
facts and projection bytes remain identical.

## Projection

Over the first implementation lap after `LinengrowReceipt` lands, a linear Receipt Card with radial
group metadata should fit within **72 cells by 18 rows** and preserve one byte-stable accessibility
order, assuming the accepted field set and frame ceilings stay unchanged. Confidence is **medium**:
the grouping is simple, while no Brushstroke or Skate witness has rendered this receipt yet.

Over a later motion lap, a bounded guide may make the four field groups easier to scan without
changing the settled frame, assuming reduced motion returns directly to Still and every event has a
fixed lifetime. Confidence is **low** until frame time and reader behavior are measured on the
existing Skate path.

## Falsifier

This design is wrong if any radial placement changes field order between the Still frame and the
accessibility snapshot, requires more than **18 rows**, hides a deciding field, changes focus order,
or makes the settled frame differ from Still. Any one result kills the radial renderer. The linear
Receipt Card remains the implementation floor.

## What is buildable now, and what waits

The ordered-row description and equality checks are buildable after the public Linengrow projection
lands. Bakery can then name their proof closure without taking surface ownership.

Angular text, signature palette choices, and expressive motion remain outside this page. They wait
for DJINN's design authority and for measurements showing that a radial guide helps more than it
costs.
