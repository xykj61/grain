# REDS shelf -- a projection names its coverage inputs

**Language:** EN
**Style:** Gauge, Meter
**Voice:** Kyri
**Status:** Shelf -- checkable; the recovery is proven by local controls

**REDS %660 (`20260909.071647`) -- a coverage reader compared a saved projection with newer inputs.** *What went wrong:* the parked control in Bakery's `ce363e5093` stash expected a projection receipt, while the landed reader and producer carried none. A newly allowed room was called a projector omission even when the projection predated its admission. The Rishi witness also replaced any scan failure with a success-shaped line through its shell OR branch. *What caught it:* the six-file stash review recovered the control and ran it against the landed reader. The final 50-check control reports 13 failures there; disabling the new freshness comparison produces six failures. *What it taught:* a coverage check needs provenance for the inputs it counts. A commit identifier alone also refuses unrelated changes and misses changes still in the index. *Repaired:* `tools/fixtures/s/sow_reach_inputs.sh` derives one receipt from manifest bytes and tracked paths under its allow entries. The projector removes the prior receipt before copying and writes a new one only after its coverage inputs agree at both ends. The scan refuses absent, unreadable, or changed inputs before naming an omission. The Rishi witness propagates the scan's exit status and prints its diagnostic before asserting. The recovered control runs under the restored `sow_allow_reach_control` roster name, including on checkouts without a seed. Fifty checks pass, including real producer runs, staged additions, unstaged manifest edits, failed inventory reads, failed copies, changed inputs during copying, and a second identical projection. A direct Rishi refusal also exits 1 and names the absent receipt. **CLOSED.**

The receipt says which coverage inputs were read. It makes no claim about current file contents,
privacy, or permission to publish. The full projection witnesses retain those duties, and the
scrub-cache design and public seed push keep their existing gates.
