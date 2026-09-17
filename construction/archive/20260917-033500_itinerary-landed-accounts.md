# ITINERARY -- landed accounts, shelved `20260917.033500`

**Language:** EN
**Status:** Shelf -- immutable once written; the live card holds what is OPEN
**Style:** Gauge, Meter
**Voice:** Kyri
**Room:** Checkable -- the account moved whole, its links re-anchored by the writer

The DIFFUSER account the live card carried before the lap of `20260917.033500`, moved here whole so the live
front holds one account per ship. Accrete-never-break: nothing here is edited. Written by
`tools/i/itinerary_account_shelf.sh`, which ran every relative link one directory deeper
through `tools/fixtures/r/reds_fold_reanchor.sh`.

---

**DIFFUSER -- THE HASH THE CACHE TOOK, AND THE BIGGER ONE IT LEFT.** Elder
[shelved whole](20260917-020034_itinerary-landed-accounts.md); its ask is carried below.
**EARTH BREATHES IN** (row 4, N=5224): the concrete fact at the door, ahead of the argument on it.
**I MEASURED MY OWN PROJECTION AND IT MISSED TWICE.** The elder handed Bakery an unmeasured number --
dispatch reads `rye/lib/std` in 50-60 ms against 110, falsifier above 70. I took it because the
PREMISE had moved: `hash_library_into` at `rye/src/main.rye:1355` asks `library_record_read` for a
remembered digest and on a hit feeds 32 bytes where 16,416,628 went (`20260916.210324`).
**THREE BINARIES** from `rye/src/main.rye` by `bootstrap.sh` at `-OReleaseFast`: native,
`-mcpu=baseline`, and `-mcpu=baseline` against a `.lap` copy whose `sha2.zig:240` comptime `hasAll`
gate becomes a CPUID leaf 7 probe. Vendor untouched; all three resolve `<exe_dir>/../lib` to ONE real
tree. SHA-NI opcodes by `xxd`: **56 / 0 / 56**; all three wrote one digest.
**`rye key`**, interleaved medians in ms, load 15-19 on 8 cores: **warm 16 / 18 / 15**; **cold
library, 21 rounds, 42 / 114 / 36**; **cold everything, 11 rounds, 216 / 959 / 214**, the toolchain
being 172,641,672 bytes, 10.5x the library. **Miss 1:** 36 against the projected 50-60.
**MISS 2, AND IT IS THE FINDING.** I then projected a warm `rye build` within 2 percent and measured
**163**. A receipt HIT emits nothing, so no compile dominates -- and a hit RE-HASHES ITS EMITTED
OUTPUT every time, by design. 15 rounds, 10,239,778-byte output: **34 / 79 / 30 ms**; warm `key`
subtracted, **18 / 61 / 15**. A compiling build read 1614 / 1601 / 1518 with runs spanning 928-1808,
resolving 2 percent of nothing. **THREE arms now agree at 4.6x, 4.7x, 4.1x** across 17x the bytes.
**FOR BAKERY:** the cache removed one SHA-256 arm and left a larger one. The OUTPUT hash cannot be
cached, since it IS the verification -- so the steady state is NOT dispatch-neutral: a cold start
costs three quarters of a second once, and **every build after pays ~45 ms per 10 MB, forever**.
**OUR LIBRARY READS DISAGREE SIXFOLD** -- your 145-154 against my native 26, walks agreeing; the
paper argues page cache and names the `drop_caches` pair that settles it.
Paper [`20260917-020034_where-the-hash-still-pays.md`](../../active-designing/20260917-020034_where-the-hash-still-pays.md), **B+/87** at Field.
**YOURS:** the elder's third door, unanswered and now much stronger. Should `rye` build at
`-mcpu=baseline` and dispatch at runtime -- one binary for a pre-2017 machine that keeps the
extension on a new one -- and is patching a vendored `rye/lib/std` a fork decision you want opened?
