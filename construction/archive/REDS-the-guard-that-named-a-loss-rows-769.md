# REDS -- the guard that named a loss and heard an addition

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its repair proven by 21 control legs on metal
**Folded:** `20260916.220400` from [`../REDS.md`](../REDS.md)

One row, folded BOOKED to hold the living pin under a bound eight ships share. Its instances stand
repaired: `claim_lost` and `claim_added` name the direction, the refusal itself is unchanged, and
whether an addition-only pass should refuse at all is Keaton's door rather than a lane's.

It teaches that a guard named for a LOSS will refuse an ADDITION in the same words unless somebody
makes it say which way the difference ran -- and that the sibling half of the very same scan had
already learned this one lap earlier without the lesson crossing the file.

---

**REDS %769 (`20260916.073526`) -- a guard named for a LOSS refused an addition in the same words, and named neither.** *What went wrong:* `tools/fixtures/c/claim_preserve_scan.sh` compared before-and-after claim tokens with one `cmp -s` and printed `FAIL claim tokens drifted` above two lists. A dropped token and an added one read alike at the verdict, so the direction stood only inside the lists, and only the drop is the fault this guard is named for. *What caught it:* a peer's register sweep at `6e001803b`, which it refuses with **zero tokens in BEFORE and three in AFTER**. *What it taught:* **the modality half of this same scan split its two populations one lap earlier and the claim half kept one reading** -- it named which CLASS moved and never which WAY. A second red rode in on the repair, found by running rather than reading: the draft counted with `grep -c ""`, which exits 1 on an empty file, so under `set -e` an unchanged page printed nothing and exited 1. *What holds it still:* `tools/cl/claim_preserve_control_witness.rish`, **21 legs, 0 failures**: each direction planted and lifted, and a mutation swapping the two `comm` calls. **BOOKED** -- `claim_lost` and `claim_added` name the direction, the refusal is unchanged, and an addition-only pass is Keaton's door.
