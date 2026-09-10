# The `bat/` fleet -- baton archetypes

**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)

A **baton** is a carry between hands: a `.kyri` document (`format baton-v1`) holding *state - gaps -
next*, so a context reset, a pause, or a fresh turn hands the whole thread on. The Scribe reader
already recognizes one (`is_baton`). What the fleet adds is **shape** -- a named set of expected
fields for a *kind* of carry, so a reader can say "this is a **Galleon**, and its cargo is all
here."

Each archetype stays `format baton-v1` and adds one head field, `archetype <name>`, which the reader
validates and the dashboard reads. One notation, many shapes.

## The six shapes

| Archetype | The carry it names | Required fields (beyond `format` - `stamp`) |
|---|---|---|
| **Galleon** | the full vision handoff -- everything to disk | `manifest` - `seated` - `aspiration` - `gap`+ - `next` |
| **Cutter** | the one-keystone lap -- small on purpose | `state` - `next` |
| **Barque** | the round in progress -- doors open, none closed | `state` - `gap`+ - `witness` - `next` |
| **Holdfast** | the checkpoint -- stop before you cross this gate | `state` - `gate` - `hand` - `next` |
| **Corsair** | the audit sweep -- what was probed, what held, what fell | `state` - `probe`+ - `held`+ - `red`* - `next` |
| **Ledgerworks** | the portfolio roll-up -- many modules under one head | `member`+ - `roll` - `stamp` - `next` |

(`+` repeatable, `*` optional.) Each `bat/<name>.kyri` is a **fake-data exemplar** -- a shape the
reader parses, exactly as the reader's own `sample_baton` is fake. Every exemplar holds stand-in
text alone -- a module name, an open door, a one-word verdict -- so a real key, a real person's
decision, and a real company's state all stay outside `bat/`.

## The copyright discipline

The names come from the plain nautical and mercantile commons -- a *galleon*, a *cutter*, a
*corsair*, a trading-*house* -- **common nouns anyone may use**. Each is an ordinary word rather than
a named ship or firm out of a book, show, or game. Each also falls outside the three-letter
syllable shape a real `@p` address takes. Every exemplar carries this line, and the witness reads it on all six:
`note original coinage; no named ship or company`.

**Where the guard stops, said plainly.** The witness holds the *note*; a person holds the
*judgment*. Whether a coined name belongs to some real vessel or firm is a reading a hand does at
coinage, against the commons, and the tree records that reading here rather than in a check.

## Proving the fleet

The Scribe reader validates each shape. `validates_galleon`, `validates_cutter`, and their four kin
in `scribe/reader.rye` each ask one question. Is this a baton, does its `archetype` field name this
shape, and are the required fields present? That is one predicate per shape, on the pattern
`is_session_log` already set. A short baton, one required field away from whole, is refused, so
*required* means required.

```
rishi/bin/rishi run tools/b/bat_fleet_witness.rish
```

*Six shapes for the carries the tree already makes -- the grand handoff, the tiny lap, the working
round, the checkpoint, the audit, and the roll-up -- each read and validated by the one reader.*
