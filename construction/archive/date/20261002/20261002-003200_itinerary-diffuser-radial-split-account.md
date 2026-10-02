# DIFFUSER -- the radial split only pays when something frees

**Stamp:** `20261002.003200`
**Status:** Shelved whole -- the-writer-sheds

## Account

[The radial split only pays when something frees](../../../../active-designing/date/20261002/20261002-002240_the-radial-split-only-pays-when-something-frees.md):
a simulated power-of-two buddy allocator loses to Tally's own linear bump allocator at the
allocate-only workload Region actually runs today (735 served vs 629), and only overtakes it once
individual frees enter the mix -- and no module in this tree frees a block without clearing its
whole region. Reads as a vote of confidence in `tally/region.rye`'s own shape rather than a build
proposal. Graded B+ at Field.

**YOURS:** none; the next step waits on a real caller that frees mid-region, which belongs to
whoever builds that caller rather than to this lane.
