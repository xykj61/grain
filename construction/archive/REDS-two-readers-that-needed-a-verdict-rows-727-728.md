# REDS %727-%728 -- two readers that needed a verdict

**Language:** EN
**Status:** Historical shelf -- checkable room; both rows closed before this fold
**Room:** checkable
**Folded from:** `construction/REDS.md` on `20260913.203000`

Both faults gave an unavailable reading the shape of evidence. The first reader treated a missing
search command as an empty population. The second lap treated a transcript still in flight as a
finished receipt. A tool and a run each need their own explicit verdict before their output can
support a decision.

---


**REDS %727 (`20260912.172929`) -- a missing search tool made a disagreement scan report agreement.** *What went wrong:* `amphora_bounds_agree_scan.sh` sent four failed `rg` calls to `/dev/null`; on this pier, every planted directory became an empty population and `verdict=ok`. Its wrapper then pinned the living derived roster at three families although Amphora now carries six. *What caught it:* the cold roster's disagree plant, which expected failure and received exit 0. *What it taught:* **a discovery command that cannot run must never look like an empty discovery.** *Repaired:* the scan uses available recursive `grep` for directory and file readings, and the wrapper names all six current families so a later change is reviewed rather than silently absorbed. Thirteen planted pairs pass in both directions; the living room reads six agreeing same-name families. **CLOSED.**

**REDS %728 (`20260913.200226`) -- this lap moved the tree while its cold roster pass was still running.** *What went wrong:* the detached runner had printed no `run_verdict`, yet the lap published its fleet claim and began the moved-proof instrument. *What caught it:* the runner's live lock and process, read after the edits had begun; its final tree check must reject the mixed reading. *What it taught:* **a transcript path is a receipt only after its verdict lands.** *Repair in this lap:* the mixed pass is evidence of this fault alone. A fresh full pass runs over one held-still tree before the lap uses a roster result. **CLOSED.**
