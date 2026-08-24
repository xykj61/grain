# SAFE

**Language:** EN - **Style:** Gauge (see `context/GAUGE_STYLE.md`)
**Seated:** `20260730` by Keaton's word - **Spec:** `context/specs/oldness-cycle.md`
**Cycle:** 1 - **Rows:** 0 of 64 - **Last census:** `20260731.142025` (e107 seat map - orphan floor held - shred RED)

---

This list names paths that no shred may touch. It is append-only, and every shred consults it before it moves. A shred whose plan reaches a listed path **refuses whole and names the row that stopped it**, since a shred that silently skips a protected file and one that quietly destroys it look identical in a log.

The bound holds at **sixty-four rows**, because a list a reader cannot review in one sitting stops being a safeguard and becomes a formality. Past the bound, protection consolidates by directory rather than by file, and the consolidation earns a row of its own.

Each shred commencement opens with an oldness census: the rows counted, each path's age printed from its founded stamp, and every row lacking a current-cycle relevancy marker flagged. The census informs a word; it never replaces one. At the shred's close every row is re-affirmed by Keaton's word, or moves to **review**, where it stays fully protected while awaiting attention. Nothing departs by silence and nothing departs by expiry -- a row leaves only by an explicit word, and its departure appends rather than deletes.

---

## Rows

| Path | Founded | Reason | Cycle | Word |
|---|---|---|---|---|
| *(none yet -- the list opens empty and grows only by Keaton's word)* | | | | |

---

*May the old pages keep every protection they earned. May each row carry a reason a stranger could read. May no cut ever move without a word behind it.*
