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
living_pin_max_bytes[construction/ITINERARY.md] = 40960  // the live front holds one open state per ship, and the fleet is eight
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

### Raised to 40,960 on Keaton's word, `20260906.001901` -- and only one of the three parts moved

**The live front is a per-ship quantity, and the fleet went from three ships to eight.** Measured on
the card the night of the raise, beside the same three parts as above:

| Part | `20260904` | `20260906` | What moved |
|---|---|---|---|
| **Standing block** | 7,008 | **7,008** | nothing -- still fourteen directives, byte for byte |
| **The live front** | 5,161 | **12,814** | 2.5x, and it is the only part that grew |
| **The durable spine** | 12,406 | **12,927** | 521 bytes, ordinary drift |

**Per ship, the live front is steady:** 5,161 over three ships is 1,720 each; 12,814 over eight is
**1,602 each**. Two independent measurements of the same unit, five ships apart, so the live front
is not swelling -- it is being multiplied. That is what makes this derivable rather than granted.

So the live front is allocated the way the standing block already was, by counting what it holds and
rounding to a power of two above the measurement: **8 ships at 2,048 bytes each is 16,384**, where
2,048 leaves each ship room to say more than 1,602 bytes without forcing a rewrite. The other two
parts keep exactly the allowances they were given, because neither moved.

`8,192 + 16,384 + 16,384 = **40,960**` -- ten kibibytes, about **10k tokens**. It is deliberately
**not** a power of two: 32,768 was one only because the three parts happened to sum to it, and
inflating to 65,536 to keep the shape would be granting a number rather than deriving one.

**What forced it, counted rather than felt.** `construction/CHECKPOINTS.md` records **six** sweeps
whose stated reason is the card standing at or over 32,768 -- at 32,744, 32,765, 32,838, 33,165,
34,086 -- and **eight checkpoints were written on `20260905` alone**, by more than one ship, several
within the same hour. A bound that forces a condensation once is a bound doing its work; one that
forces six, and twice in one evening on two different ships, is a bound sized for a smaller fleet.

**The cost is named, since the card is read WHOLE every lap by every body.** At eight ships this is
roughly 10k tokens per lap per ship rather than 8k -- about 16k more per lap across the fleet. The
measured alternative is what the evening actually cost: four condensations of a single entry by one
hand, plus a peer's fold of two closed accounts one hour earlier, all to fit one round's work.

**The honest limit, and it is not solved here.** The live front scales with the fleet, so a
twelve-ship fleet re-opens this arithmetic at 8,192 + 24,576 + 16,384 = 49,152. Raising the ceiling
each time the fleet grows is a treadmill, and the exit is not a bigger number -- it is a live front
that does not hold one region per ship, which is a design question rather than a bound. Named here
so the next raise is met with that question rather than with more arithmetic.

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
