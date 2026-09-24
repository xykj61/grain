# A parked fix behind an existing path

**Language:** EN
**Style:** Gauge, Meter setting
**Status:** CLOSED -- checkable recovery record
**Stamp:** `20260909.072646`

The record below keeps the failure, its reproducer, and the recovered source together.
The original stash remains in Petrichor.

---


**REDS %675 (`20260909.072646`) -- an existing file concealed its parked repair.** *What went wrong:* Petrichor's stash `93a5246debe0` held the fifth demo and a matching announcement-scan repair; the current scan and control still matched the stash's base. A zero source-orphan count measured path presence while both edits remained parked. The scan treated quoted scan results as new announcements by the quoting page. *What caught it:* comparing the saved changes with current bytes, then running the recovered control against both scans: current source 16 pass / 3 fail, recovered source 19 pass / 0 fail. *What it taught:* recovery needs content comparisons; a resolving path cannot prove a saved edit landed. *Repaired:* restore the scan and control byte for byte, recover the demo with freshly run outputs, and preserve later teaching-page edits. The quoted report passes; a bare announcement beside it still counts and refuses when short. **CLOSED.**

*Landed `20260909.173000` by the seat that parked it. **The row's number moved five times before the spine
took it** -- booked `%660`, re-seated `%664`, `%667`, `%671`, `%673`, published here as `%675` --
while its stamp never moved once. Five renumberings and one key, inside a single evening, on a pier
where eight ships allocate from their own copy of the spine: that is the derived-spine law's whole
argument, and it is why rule 4 says cite the stamp until the row is shared. The recovery was re-proven on
metal before landing rather than taken from the parked log: the recovered control reads **19 pass /
0 fail** against the recovered scan and **16 pass / 3 fail** against the scan standing in `HEAD`,
the three failures being exactly the quotation checks the repair adds.*
