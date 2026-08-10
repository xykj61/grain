# Scribe — the Kyri voice's home

**Language:** EN
**Status:** Living — the Kyri reader, lap 1 seated `20260810.041230`
**Voice:** Riyo (Kyri, coming)
**Kin:** counsel [`../active-designing/20260810-035305_scribe-shape-and-the-structure-mapping.md`](../active-designing/20260810-035305_scribe-shape-and-the-structure-mapping.md)

Scribe is where the flagship voice keeps its records — session logs, batons, and inventory — and every one of them is a **Kyri** document. This first lap is the foundation the rest of Scribe stands on: a **zero-copy Kyri reader**.

## The reader (`reader.rye`)

A Kyri document is `format <name>` on the first line, then `key value` fields — one per line, `#` comments and blanks ignored, no quotes and no braces. [`reader.rye`](reader.rye):

- **Parses** a document into its fields, **zero-copy** — a field is a pair of slices *into the source text*, never a copy. The document borrows the bytes; the caller keeps them.
- **Dispatches by format** — `is_session_log` and `is_baton` tell a `format session-log-v1` from a `format baton-v1` with one honest reader. This is the seated counsel made real: **one notation, many formats** — never a sprawl of extensions.
- Reads a field by key (`get`, first occurrence) and counts a **repeatable** key (`count_key`, every occurrence — `think`, `file`). Bounded: `max_source_len`, `max_fields`.

```
rye build scribe/reader.rye -femit-bin=scribe/bin/reader
scribe/bin/reader selftest
rishi/bin/rishi run tools/scribe_reader_witness.rish
```

## Horizons

- The **settings / preferences dashboard** for batons and inventory (rendered on Skate).
- **Tilak-typing** of fields — the shared type-marks (its own design sitting), so a field is not merely a string but a typed value.
- A **baton archetype** library (`format baton-v1`), and Murr · Mala MMT accounting, TigerBeetle-compatible.

---

*May the voice read its own records in one honest hand — one notation, many formats, every field borrowed and none copied.*
