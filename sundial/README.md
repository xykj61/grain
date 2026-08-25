# Sundial — the health face

**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)

A sundial tells the **time** of day by a shadow. This one tells the **health** of the day: point it at a set of module readings — each module and whether its witness stands green — and it shows the tree's state at a glance.

```
rye build sundial/sundial.rye -femit-bin=sundial/bin/sundial
sundial/bin/sundial selftest    # prove the counts, the percent, the all-green
sundial/bin/sundial emit        # render a Ledgerworks health roll-up
rishi/bin/rishi run tools/s/sundial_witness.rish
```

## What it shows

Add a module reading with `add(name, green)`, and the Sundial answers:

- **`green_count()`** — how many modules stand green
- **`all_green()`** — whether every one does
- **`health_percent()`** — the health of the day, green of total (empty-safe: an empty face reads 0, never divides by zero)
- **`fascia`** — the tree's connective-health metric, set by the caller

Bounded by `max_modules`, asserted at every edge, zero heap.

## One indicator, two faces

Sundial is an **indicator** — a bounded set of readings shown at a glance, like the model or effort marks a baton carries. It wears two faces:

- **The health face** *(public, this module)* — module witnesses green or red. This is what ships.
- **The nakshatra face** *(private study)* — which of the 27 d27 outfits a point wears. Same mechanism, a different roster; that reading lives in the pilot's own private record, never here.

## It emits a Ledgerworks roll-up

`emit` renders the health face as a **`format baton-v1` · `archetype ledgerworks`** document — the bat fleet's portfolio archetype, which the Scribe reader validates. So the recursion batons can carry the tree's health, and Scribe can read it back:

```
format baton-v1
archetype ledgerworks
member vault green
member basin green
roll 4 of 5 green
health 80% fascia 41
next keep watch
```

## The redeemed word

The old `sundial` fixture generated fund dedications and was rightly withheld from the public seed. This Sundial's dharma is honest — a status face anyone can read, and a health line the batons can hold. Same word, an earned purpose.
