**Stamp:** `20261003.090430` - **Status:** Checkable - **Room:** checkable -- a module head, graded and lifted
**Voice:** Kyri - **Lane:** GRASS (auditing)

# `mycelium/fold.rye`'s module head crosses the B floor

`sh tools/fixtures/q/qa_report_card.sh mycelium/fold.rye --service 90` read the head at Door:
`register=63` (37% negative of 8 sentences), `reach=60` (grade 13 against a ceiling of 9),
`composite=78` -- a C+, the next of the nine remaining below-B heads `freight.rye`'s account named.

A missing period was the first fault: the bounds list's closing line, `myc_log_max_facts 1024
(named here: one journey-of-journeys of facts)`, carried no terminal punctuation, so the reading
fused it across a blank line into the next paragraph's own sentence -- one 34-word run-on naming
both the bounds list and the supply invariant at once, and the merged sentence carried the word
`refuses`. `sh tools/fixtures/p/prose_register_scan.sh --explain` named three negative sentences:
that merge, `Unknown kinds refuse whole`, and `stay parked -- this file folds; it does not invent
release or expiry`.

Closed the missing period, which un-merges the two sentences on its own. Rewrote the two true
negatives into affirmative sentences holding the same facts: the supply invariant now reads
"Supply equals issued minus taxed at every prefix and stays non-negative; a tax draw is honored
only up to the supply that already stands, taken whole in a single fact" rather than naming the
overdraw case by its refusal; the kind check now reads "Only the three named kinds fold; every
other kind stops the whole fact as one unit" rather than "Unknown kinds refuse whole"; the policy
line now reads "Policy numbers (genesis - price - ceiling) stay parked for a later file to set;
this file folds only, leaving release and expiry to that future work" rather than "it does not
invent release or expiry."

Every bound name (`myc_fact_max_bytes`, `star_name_max_bytes`, `myc_log_max_facts`), the counsel
citation, and the env usage line moved unchanged. No function, struct field, constant, or import
in the file moved -- only the `//!` head.

Reading after: `register=100` (0% negative of 9 sentences), `reach=80` (grade 11 against 9),
`composite=93`, **A**.

The module's own selftest re-runs GREEN on metal: `env RYE_ZIG=vendor/zig-toolchain/zig
rye/bin/rye run mycelium/fold.rye` answers `GREEN: myc fold -- Check shape * supply=872 *
stars=1 * purity * refuse whole`, and a touching witness one room over,
`tools/m/mycelium_pledge_witness.rish` (which imports `fold.rye`'s public API), re-runs GREEN
unchanged.

**YOURS:** none -- the head crosses B at A. The remaining eight below-B heads from the same
sample (`muster.rye` 72, `purse.rye` 72, `statement.rye` 74, `tenure.rye` 77, `till.rye` 71,
`voucher.rye` 76, `warrant.rye` 71, `rehearsal.rye` 75) stay unread by this account, waiting for
the same lift, one file at a time, per this lane's usual depth-2 bound.
