# The `bat/` Fleet — baton archetypes

A **baton** is a carry between hands: a `.kyri` document (`format baton-v1`) that holds *state · gaps · next* so a context reset, a break, or a fresh turn loses nothing. The Scribe reader already recognizes one (`is_baton`). What the fleet adds is **shape** — a named set of expected fields for a *kind* of carry, so a reader can say not just "this is a baton" but "this is a **Galleon**, and its cargo is all here."

Each archetype is still `format baton-v1`; it adds one head field, `archetype <name>`, that the reader validates and the dashboard reads. No new format tag, no new extension — one notation, many shapes.

## The six shapes

| Archetype | The carry it names | Required fields (beyond `format` · `stamp`) |
|---|---|---|
| **Galleon** | the full vision handoff — everything to disk | `manifest` · `seated` · `aspiration` · `gap`+ · `next` |
| **Cutter** | the one-keystone lap — small on purpose | `state` · `next` |
| **Barque** | the round in progress — doors open, none closed | `state` · `gap`+ · `witness` · `next` |
| **Holdfast** | the checkpoint — stop before you cross this gate | `state` · `gate` · `hand` · `next` |
| **Corsair** | the audit sweep — what was probed, what held, what fell | `state` · `probe`+ · `held`+ · `red`* · `next` |
| **Ledgerworks** | the portfolio roll-up — many modules under one head | `member`+ · `roll` · `stamp` · `next` |

(`+` repeatable, `*` optional.) Each `bat/<name>.kyri` is a **fake-data exemplar** — a shape the reader parses, exactly as the reader's own `sample_baton` is fake. No exemplar holds a real key, a real person's decision, or a real company's state.

## The copyright discipline

The names are drawn from the plain nautical and mercantile commons — a *galleon*, a *cutter*, a *corsair*, a trading-*house* — **common nouns no one owns**. None is a named ship or company from any book, show, or game; none parses as a real network address; each greps to zero across the tree. Every exemplar carries a `note original coinage; no named ship or company` line, and the witness turns away any that names a real vessel or firm. The register is honored without ever borrowing a single owned name.

## Proving the fleet

The Scribe reader validates each shape: `validates_galleon`, `validates_cutter`, and their kin each ask *is this a baton, does its archetype name the shape, and are the required fields present?* — the pattern of `is_session_log`, one predicate per shape. A short baton (a required field removed) is refused, so "required" means required.

```
rishi/bin/rishi run tools/b/bat_fleet_witness.rish
```

*Six shapes for the carries the tree already makes — the grand handoff, the tiny lap, the working round, the checkpoint, the audit, and the roll-up — each read and validated by the one reader.*
