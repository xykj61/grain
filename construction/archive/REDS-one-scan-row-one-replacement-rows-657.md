# One scan row, one replacement

**Language:** EN
**Style:** Gauge, Meter
**Voice:** Kyri
**Status:** Closed -- checkable
**Stamp:** `20260909.042650`

The scan counts link occurrences. The writer now applies one visible occurrence per row,
so repeated targets finish and inline examples keep their original text.

---


**REDS %657 (`20260909.042650`) -- a repointer replaced every occurrence while its queue counted each occurrence separately.** *What went wrong:* recovering `construction/archive/20260907-182522_itinerary-landed-accounts.md` produced five repair rows, three naming the same broken target. `tools/f/fold_shelf_link_repoint.sh` used Python `str.replace` over the whole file. The first row changed all three occurrences; the next identical row asserted that its old target still existed and exited 2, leaving the other repairs unfinished. The same replacement also changed an inline-code example when a real link shared its spelling. *What caught it:* the actual recovery stopped inside the repointer. A new control planted three repeated links after a quoted example and read **21 passes, 4 failures** against the old tool. *What it taught:* **a queue and its writer must agree on the unit of work.** This scan emits one row per visible Markdown occurrence, so a row authorizes one replacement outside the closed inline-code spans the scan excludes. *Repaired:* the writer splits out those spans and replaces one matching occurrence per row. The control checks completion, the verdict, three reported repairs, exact output including the unchanged code span, and convergence on a second run. All **25 checks** pass, and `tools/f/fold_shelf_link_repoint_witness.rish` is GREEN. **CLOSED**.
