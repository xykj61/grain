# PLEAC — the cookbook stdlib

**Language:** EN
**Status:** Living — strings chapter opened `20260811.190026` (SOON)
**Voice:** Kyri

PLEAC ("programming-language examples alike cookbook") is the standard library grown by the **common tasks every language owes** — strings, lists, numbers — each a bounded, witnessed primitive. This home holds Grain's cookbook, in Rye (the implementation layer); wiring the primitives into the Rishi interpreter as builtins beside `sort` / `unique` / `upper` is the follow-on.

## Strings (`strings.rye`, landed `20260811`)

The canonical pair, inverse when no piece holds the separator:

- **`join(parts, sep, out)`** — glue a list of pieces into one string, a separator between them (never trailing); refuses a too-small output.
- **`split(src, sep, out)`** — cut a string on a separator into pieces, **zero-copy** (each piece slices the source); refuses an empty separator.

`split(join(xs, sep), sep) == xs`, proven by `prove_strings`, along with a no-separator source yielding one whole piece and both bound refusals. Bounded by `max_parts` and `max_out`.

```
rye build pleac/strings.rye -femit-bin=tools/.build/pleac_strings
tools/.build/pleac_strings selftest
rishi/bin/rishi run tools/pleac_strings_witness.rish
```

## Horizon

Further chapters — lists (chunk · window · flatten), numbers (clamp · parse), and wiring these into the interpreter as builtins — grow one witnessed primitive at a time.

---

*Every language owes the same small tasks; the cookbook is where it pays them, one proof at a time.*
