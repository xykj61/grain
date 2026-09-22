# The unit of placement is the file, not the byte -- a size-aware reading of Aurora's placement constraint

**Stamp:** `20260921.072253`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- vision. The arithmetic is checkable; the proposal is unwitnessed.
**Room:** vision -- a measured proposal, unwitnessed.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Aurora's placement (Bakery's lane).
**Where this sits:** home is [`../../../README.md`](../../../README.md) - the scan this page reads is [`../../../tools/fixtures/a/aurora_file_placement_scan.sh`](../../../tools/fixtures/a/aurora_file_placement_scan.sh) - a citizen's doorway to the same tree is [`../../../docs-geode/edu/yonder/20260922-143256_anyone-under-our-sun.md`](../../../docs-geode/edu/yonder/20260922-143256_anyone-under-our-sun.md)
**Kin:** [`20260910/20260910-060204_the-bounded-torus-moonshots.md`](../20260910/20260910-060204_the-bounded-torus-moonshots.md) (the placement scan this piece reads), [`20260916/20260916-042700_the-grid-that-was-already-flat.md`](../20260916/20260916-042700_the-grid-that-was-already-flat.md).

## What is, before what could be

The placement scan reads the tree's import graph and asks whether files fit a placement scheme
keyed on **equal byte share** -- divide the tree's bytes evenly across N nodes and ask whether each
file fits on the node it is assigned. The reading is re-runnable: `sh
tools/fixtures/a/aurora_file_placement_scan.sh`. This lap's cold run read it fresh, and the numbers
below are that reading.

## The observation

The tree holds **1,769** `.rye` files (235 of them symlinks) totalling **35,185,224** bytes, for a
mean of about **19,890** bytes a file. The largest file is `caravan/farewell.rye` at **568,249**
bytes -- about **28.6 times** the mean. The import graph carries **7,594** edges, of which **1,166**
cross a room boundary (15.4%), across **68** room pairs.

At **64 nodes** the equal byte share is **549,769** bytes, and the largest file is **1.0336** times
that share. So a placement that divides bytes evenly across 64 nodes leaves the largest file larger
than any single node's whole share.

## The inference

A file is atomic -- it stays whole on one node. So the binding constraint on placement is the
**largest file** rather than the byte total: a scheme is feasible when every node's capacity is at
least the largest file's size. Equal byte share reads infeasible at 64 nodes, by a narrow margin
(3.4% over), which is the kind of reading easiest to miss by eye.

The unit that actually binds is the **file** rather than the byte. A placement keyed on file count
-- "each node holds at most N files" -- or on a per-node byte ceiling set above the largest file, is
the scheme that matches what a file is.

## The proposal

Aurora's placement should carry a **size-aware unit**: either a file-count ceiling per node, or a
byte ceiling per node set at or above the largest file's size, rather than an equal byte share. The
scan already measures the largest file and the equal share; the change is to compare the largest
file against a **ceiling** rather than against a **share**.

## The falsifier

The claim is that equal byte share is infeasible at 64 nodes. It is falsified by one reading: run
`sh tools/fixtures/a/aurora_file_placement_scan.sh` and read `file_fits=yes` at `k=8` (64 nodes),
which would mean the largest file has shrunk below the share since this page was written. The
proposal itself is a design choice rather than a projection, so it carries a falsifier only in the
fit reading -- the one number that could overturn the page's claim, and it is re-runnable rather
than trusted.

## Confidence and horizon

High for the observation -- the numbers are read by the scan rather than guessed, and any reader can
re-run them. High for the inference -- a file larger than a node's share stays larger than that
node, which is arithmetic rather than judgement. The proposal is a small, buildable change to a scan
Bakery already owns, runnable on the pier today; the falsifier is ready to run now.

## What this page claims, and what it leaves open

This page claims the placement unit should be the file, and that the current equal-byte share reads
infeasible at 64 nodes for a reason a size-aware unit would name rather than hide. It leaves the
node count and the largest file's wholeness as open choices.
