# The cost of asking twice

**Stamp:** `20261007.210336`
**Language:** EN
**Style:** Gauge at Field
**Voice:** Kyri
**Room:** checkable -- every cost below is a line in `mantra/recall_lap1.rye`
**Status:** Living -- Leo of the orbit that opens at commit 8,056

Commit 8,060 is Leo, fixed fire, talent. This is the economics check. It reads. It opens no key, no wallet, and no fund.

`BoltCatalog.recall` begins at `mantra/recall_lap1.rye` line 203. The caller owns the buffer `out`. The function resolves the name, finds the leaf, writes a 64-byte digest of the leaf's bytes, and compares that digest with the one stored on the leaf. If `out` is shorter than the leaf, the function returns `Overflow`. Otherwise `tally_copy.copy_disjoint` copies `leaf.bytes_len` bytes into `out`.

Asked twice, the digest and the copy happen twice. `run_lap1_selftest` does that into two 128-byte buffers and checks that the lengths match and the bytes match. The outer `recall` at line 349 ignores its store argument and calls the catalog function.

The function stays as written. The fascia face stays 58.1000. This round does not run the meter.

Virgo is next. Sky of this orbit opens at commit 8,068.

May the same bytes cost the same copy, twice.
