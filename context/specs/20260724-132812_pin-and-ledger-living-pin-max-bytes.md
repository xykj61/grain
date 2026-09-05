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
living_pin_max_bytes[construction/ITINERARY.md] = 32768  // the operator card carries the fleet's operating law
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

## The second exception -- the operator card (accretion `20260904.204611`, Keaton's word)

**`construction/ITINERARY.md` carries 32,768 bytes rather than 24,576**, and it earns the raise on
a different argument from the first one, because **only half of that argument is available to it.**

**The half it cannot borrow.** `session-logs/README.md` is read *from the top*; the card is read
**whole**, every lap, by every body -- its own seat prompts say so in those words. So the reading
that rescued the index -- *a bound written for a page read whole, applied to a lookup table* --
says nothing here. The card is exactly the page the general bound was written for. What changed is
not how it is read but **what it now has to hold.**

**The half it does borrow: the number is derived rather than granted.** Measured on the card
`20260904.204611`, at 24,575 of 24,576 bytes:

| Part | Bytes | What forces its size |
|---|---|---|
| **Standing block** -- 14 directives a lap applies | 7,008 | one row per standing law, ~500 bytes each |
| **The live front** -- this round's open state | 5,161 | one line per open red, gate, and cross-lane find |
| **The durable spine** -- head, seated, arcs, waymarks, pier, custody gates, open doors, habits | 12,406 | fixed structure; it does not grow with laps |

So: **16 directives at 512 bytes** is 8,192 -- sixteen because fourteen stand today and a power of
two leaves room for two more without a rewrite; **8,192 for the live front**, the same prose
allowance the index earned; and **16,384 for the durable spine**, which measures 12,406 and is the
only part with genuine slack. `8,192 + 8,192 + 16,384 = 32,768`, a power of two and about **8k
tokens** against the general bound's ~6k -- still a page an agent reads in one breath.

**The cost is named rather than waved past.** A page read whole by six bodies every lap costs its
bytes every lap: this raise is roughly **+2k tokens per lap per body**, and nothing recovers them.
It is worth paying because the measured alternative is worse. On `20260904` one session condensed
the card **seventeen times across two laps** to fit three ledger rows and a launcher, closing at
**one byte** under the ceiling -- and *which* prose got condensed was decided by whoever happened
to be typing, not by anyone weighing it. Three cairns in
[`../../construction/CHECKPOINTS.md`](../../construction/CHECKPOINTS.md) record what those sweeps
removed. A pin with one byte of headroom does not bound a page; it taxes every lap a judgment call
nobody asked for, and spends it in a hurry.

**What this does not do.** It does not raise the general bound, which stands at 24,576 for every
other page. It does not retire the fold: when the card next approaches 32,768 the answer is to
shelve a closed part of the live front, exactly as `REDS.md` folds, and the day shelves already
hold every landed lap. And it does not touch `SHRED_PREP.md`, which sat at **210 bytes free** on
the same day and was repaired by folding a completed shed's record rather than by a raise -- a
finished section belongs on a shelf, and only a page whose *living* parts have outgrown the number
earns a new one.

**One reading answers both.** [`../../tools/fixtures/living_pin_max_bytes.sh`](../../tools/fixtures/living_pin_max_bytes.sh)
takes an optional page path and returns that page's bound, so no meter spells either number and no
second reading exists to disagree with the first (REDS %199).

Today’s healthiest working surface pin already passes: `glow/README.md` sits near 21 KB. Chapter ledgers that wore living names — `session-logs/README.md`, `work-in-progress/TASKS.md`, `work-in-progress/ROADMAP.md` — keep the current season in place and roll the rest onto dated archive shelves the index already ignores.

Nothing is deleted. Everything moves to the dated home it was already promised.

---

## Three-level growth (accretion `20260725.040520`)

Living pin → season index under `archive/` → seasons roster (one line per season).
Full law: [`append-only-growth-law.md`](append-only-growth-law.md).
Fold when the pin nears its bound — measured, matching the responsive rhythm.

## Lint

`tools/living_docs_lint.rish` carries a **sixth, ratchet-advisory duty**: flag any living document past `living_pin_max_bytes`, and advise when a pin is near the bound (at or over 90% of the page's OWN bound) naming the fold, the genre seasons roster, and the bytes still free. **The set it weighs is the docs roster joined to the seated pin roster** [`../../tools/fixtures/l/living_pin_guard_roster.txt`](../../tools/fixtures/l/living_pin_guard_roster.txt), deduplicated, with `weighed=<n>` printed beside the verdict: the duty kept a docs roster of its own until REDS %396, so four of the seven seated pins -- `EQUINOX_SEAT_MAP.md`, `REDS.md`, `SHRED_PREP.md` and `prin_scope.rish` -- had never been weighed by it, while the ledger stood at 21 bytes free. One roster and one bound reading is the whole of this law, and a duty that borrows the number while keeping its own list has taken half of it. Gated by [`../../tools/l/living_pin_near_bound_witness.rish`](../../tools/l/living_pin_near_bound_witness.rish). Printed every parity run; never fails the witness.

---

## Sources

Counsel: [`../../counsel/20260724-132812_the-workshop-and-the-warehouse.md`](../../counsel/20260724-132812_the-workshop-and-the-warehouse.md) - Expanding prompt: [`../../expanding-prompts/yonder/20260724-132812_workshop-and-warehouse-context-economy.md`](../../expanding-prompts/yonder/20260724-132812_workshop-and-warehouse-context-economy.md)

---

*May every living name stay light enough to lift, and every closed season keep its shelf.*
