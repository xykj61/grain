# Pin and Ledger — `living_pin_max_bytes`

**Language:** EN  
**Stamp:** `20260724.132812`  
**Voice:** Quin  
**Status:** Seated (Keaton’s align-and-run word on workshop/warehouse counsel)  
**Room:** Checkable — living pins measured; lint duty advisory
Radiant pass `20260725.040520`
**Living pointer:** growth law [`append-only-growth-law.md`](append-only-growth-law.md) seated `20260725.040520`


---

## The law

> **A living document keeps a bounded pin — the current season only — and closed seasons roll into dated files under its `archive/` shelf.**

Named bound (TAME-style):

```
living_pin_max_bytes = 24576  // ~6k tokens: a pin an agent reads in one breath beside its lap
living_pin_max_bytes[session-logs/README.md] = 57344  // an index is read from the top, not whole
```

## The one exception, and why it is one (accretion `20260824.190000`, Keaton's word)

**`session-logs/README.md` carries 57,344 bytes rather than 24,576**, and the number is derived
rather than granted. A room folds past **256 flat files**, the index must hold one row per flat
file, and an index row is bounded at **192 bytes** (`.claude/rules/session-logs.md`). So the rows
alone need `256 x 192 = 49,152`, and 8,192 for prose -- roughly three times the 2,678 the page
carries today -- brings it to **57,344**, a clean multiple of 1024.

**The general bound and this one serve different readings, which is the whole argument.** 24,576 is
*~6k tokens: a pin an agent reads in one breath* -- it bounds a page read **whole**. An index is
read from the **top**: the loop's own instruction is to open a lap on the newest rows and the
newest log's `recommend` line, never on all of them. A bound written for a page read whole,
applied to a lookup table, refuses the table for doing its job.

**Before this accretion the two seated numbers could not both hold.** A meaning-free row still
costs ~123 bytes, so 256 rows needed ~31,500 against a 24,576-byte pin, whatever a row said
(REDS %205). Raising this one page is the resolution Keaton chose; lowering the room bound was the
other, and it would have cost the room its own ceiling rather than the index its own.

**One reading answers both.** [`../../tools/fixtures/living_pin_max_bytes.sh`](../../tools/fixtures/living_pin_max_bytes.sh)
takes an optional page path and returns that page's bound, so no meter spells either number and no
second reading exists to disagree with the first (REDS %199).

Today’s healthiest working surface pin already passes: `glow/README.md` sits near 21 KB. Season ledgers that wore living names — `session-logs/README.md`, `work-in-progress/TASKS.md`, `work-in-progress/ROADMAP.md` — keep the current season in place and roll the rest onto dated archive shelves the index already ignores.

Nothing is deleted. Everything moves to the dated home it was already promised.

---

## Three-level growth (accretion `20260725.040520`)

Living pin → season index under `archive/` → seasons roster (one line per season).
Full law: [`append-only-growth-law.md`](append-only-growth-law.md).
Fold when the pin nears its bound — measured, matching the responsive rhythm.

## Lint

`tools/living_docs_lint.rish` carries a **sixth, ratchet-advisory duty**: flag any living document on its pin roster past `living_pin_max_bytes`, and advise when a pin is near the bound (≥ 90%) naming the fold and the genre seasons roster. Printed every parity run; never fails the witness.

---

## Sources

Counsel: [`../../counsel/20260724-132812_the-workshop-and-the-warehouse.md`](../../counsel/20260724-132812_the-workshop-and-the-warehouse.md) - Expanding prompt: [`../../expanding-prompts/yonder/20260724-132812_workshop-and-warehouse-context-economy.md`](../../expanding-prompts/yonder/20260724-132812_workshop-and-warehouse-context-economy.md)

---

*May every living name stay light enough to lift, and every closed season keep its shelf.*
