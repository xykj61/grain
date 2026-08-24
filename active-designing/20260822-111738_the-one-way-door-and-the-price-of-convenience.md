# The One-Way Door, and the Price of Convenience

**Stamp:** `20260822.111738` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Checkable -- every number below is printed by a meter that runs, and asserted by a witness that runs beside it
**Meter:** [`../tools/fixtures/ladder_reach_visibility_scan.sh`](../tools/fixtures/ladder_reach_visibility_scan.sh) `sink` - **Witness:** [`../tools/caravan_ladder_reach_visibility_witness.rish`](../tools/caravan_ladder_reach_visibility_witness.rish)
**Kin:** [`reds-first`](../.claude/rules/reds-first.md) - [`Two Rooms`](../context/TWO_ROOMS.md) - REDS %130 - REDS %137

---

## The shape of the door

The Caravan ladder has a harness, `caravan/ladder_checks.rye`, and a hundred and ten rungs that hand themselves to it. When a check body stands identical across many rungs, it lifts: one copy moves into the harness, and each rung keeps a stub that calls it.

One rule bounds which bodies may lift. A rung the harness imports stands **below the fold line**, and a body in such a rung can never lift, since the harness would then reach back through a rung it already reaches for. Seventeen rungs stand below the line today.

That makes a harness-level import a **one-way door**. It is opened for a good reason -- a lifted body reaching a shared module directly needs no comptime rung parameter, which is cleaner -- and once opened, that rung's remaining bodies are home for good.

## What the door was said to cost, and what it costs

Lifting `read_own_line` this morning met the door. The body reached two names, `queue_store` and `serve`, each binding one shared file. Importing both into the harness would have let the lift drop its rung parameter, exactly as the lift before it had. The parameter was kept instead, and the reason written down read:

> a cost the widening column does not price, paid by every family those two rungs might yet join

That sentence shipped into a witness's own GREEN line and onto the operator card. It was never measured. Reaching for the number found it small:

| Reading | Lines |
|---|---|
| Foldable-family bodies across the whole ladder | **65,995** |
| Foreclosed by the entire fold line, all seventeen rungs | **247** |
| Held by `queue.rye` | **3** |
| Held by `serve.rye` | **3** |
| Held by `farewell.rye`, still above the line | **3,901** |

The claim was true and roughly a thousand times smaller than its sentence implied. It is booked as **REDS %137**, and it is the second time this arc has priced a fold in prose rather than in a measurement -- **REDS %130** was the first. A lantern that fires twice becomes a loom, so the door has a meter now.

## Why the total is small, and why the total is the wrong reading

A rung the harness imports tends to be a **shared helper** -- a system reader, a parser, a capability table -- and a shared helper writes few duplicated bodies, because there is only one of it. The fold line therefore forecloses very little, and that will keep being true for as long as the rungs crossing it are helpers.

The spread is the reading that matters. Three lines and three thousand nine hundred and one lines are both real holdings on the same ladder, three orders of magnitude apart. So **both** general rules are wrong:

- *Always keep the rung parameter* pays ceremony on every lift to protect a holding that is often three lines.
- *Always import* is cheap almost every time, and one day sinks a rung holding a quarter of the ladder's foldable carry.

What survives is a rule of thumb with a measurement under it: **price the sink before you reach for the door.** One command answers it, and the answer is sorted so the expensive rungs read first:

```
sh tools/fixtures/ladder_reach_visibility_scan.sh sink
```

## The transferable part

A one-way door is exactly the kind of decision that attracts prose. It sounds weighty, it is genuinely irreversible, and the reasoning is satisfying to write -- which is precisely why it earns a number before it earns a sentence. Irreversibility describes the *shape* of a cost and says nothing at all about its *size*, and a design that confuses the two will guard a three-line holding as carefully as a four-thousand-line one.

Two Rooms already draws this line. A claim about the tree's behavior belongs in the vision room until a witness binds it; this claim wore the checkable room's clothes, in a GREEN line, with nothing behind it. The repair is the same one the room prescribes: build the door a meter, assert both ends of its spread, and let the sentence recite what the meter reads.
