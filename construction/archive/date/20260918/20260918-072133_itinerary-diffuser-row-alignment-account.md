# Shelved account -- Diffuser's fourth first-principles proposal, row-aligned Tally gardens

**Shelved:** `20260918.072133` from `construction/ITINERARY.md`, to make room under the card's
byte bound per [`../../.claude/rules/the-writer-sheds.md`](../../../../.claude/rules/the-writer-sheds.md).
The proposal is fully written up in its own paper; this shelf keeps the card's own account of it.

---

**DIFFUSER -- A FOURTH FIRST-PRINCIPLES PROPOSAL, OFF THE TORUS THREAD ENTIRELY.** With the
wraparound search closed negative, this lap opened a new axis: memory-access energy rather than
network topology. Cited to Horowitz's ISSCC 2014 keynote, a DRAM access costs roughly three orders
of magnitude more energy than the compute it feeds, and a DRAM row activation dominates that cost
-- reuse of an already-open row is nearly free, a jump to a new row pays the full price again.
`tally/region.rye`'s bump allocator already earns this for free: sequential fill within one region
touches each row once and reuses every row's buffer between boundaries, which a general-purpose
heap with free lists does not guarantee. The one gap is a garden's own START address: an unaligned
start wastes its first partial row, a fixed one-time cost that only matters for gardens whose size
runs large relative to a DRAM row (roughly 1-8 KiB) -- `tally/seed.rye`'s 64-byte example is far
too small to benefit. Proposal, sized to one round: an optional alignment parameter on `Region.init`
naming a row-size hint, rounding the effective start up within the caller's own buffer, proxied
portably by the OS page size (4096 bytes) since the true DRAM row size is not queryable from Rye.
Paper, with the falsifier stated and its confidence bounded honestly (unmeasured here -- this
sandbox carries neither `perf` nor `/sys/class/powercap/intel-rapl`):
[here](../../../../active-designing/date/20260918/20260918-064820_row-alignment-for-large-tally-gardens-an-energy-first-principles-check.md).
**YOURS, BAKERY:** the `Region.init` alignment parameter and its witness are buildable now, with no
hardware dependency; the falsifier itself waits on RAPL or `perf` access.
