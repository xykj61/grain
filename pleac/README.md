# PLEAC — the cookbook stdlib

**Language:** EN
**Status:** Living — strings `20260811.190026` · lists `20260811.190458` · numbers `20260811.190916` (SOON)
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

## Lists (`lists.rye`, landed `20260811`)

The grouping trio over a bounded list of `u32`:

- **`chunk(xs, size, out)`** — consecutive, non-overlapping groups of `size` (the last may be shorter), zero-copy slices into `xs`.
- **`window(xs, size, out)`** — every overlapping run of `size`, in order; count `len - size + 1`, or none when shorter than a window.
- **`flatten(lists, out)`** — concatenate a list of lists into one; refuses a too-small output.

`flatten(chunk(xs, n)) == xs` (grouping is lossless), proven by `prove_lists`, with the window count, the short-list-yields-none case, and the zero-size / too-small refusals. Bounded by `max_groups` and `max_flat`.

```
rye build pleac/lists.rye -femit-bin=tools/.build/pleac_lists
tools/.build/pleac_lists selftest
rishi/bin/rishi run tools/pleac_lists_witness.rish
```

## Numbers (`numbers.rye`, landed `20260811`)

The number primitives over `u32`, total (every bad input a named refusal):

- **`clamp(x, lo, hi)`** — bound a value to `[lo, hi]` (the bound must be well-ordered).
- **`parse(s)`** — a decimal string to `u32`, refusing empty · non-digit · past the ceiling.
- **`to_str(n, out)`** — a `u32` to its decimal string, the inverse of `parse`; refuses a too-small buffer.

`parse(to_str(n)) == n` across the range, proven by `prove_numbers`, with clamp's edges and every refusal. Bounded by `max_digits`.

```
rye build pleac/numbers.rye -femit-bin=tools/.build/pleac_numbers
tools/.build/pleac_numbers selftest
rishi/bin/rishi run tools/pleac_numbers_witness.rish
```

## Wired into the interpreter

The cookbook primitives also live as **Rishi builtins**, so a `.rish` script calls them directly beside `sort`/`unique`/`upper`:

- **`clamp <x> <lo> <hi>`** — `20260811.192204` (`do_clamp`; test `rishi/tests/clamp.rish`).
- **`chunk <list> <size>`** / **`window <list> <size>`** / **`flatten <list>`** — `20260811.193451` (`do_chunk`/`do_window`/`do_flatten`, list-of-lists zero-copy; test `rishi/tests/chunk.rish`). Rishi indexes one level at a time, so a `.rish` binds an inner list (`let g = cs[0]`) before indexing it.

- **`parse <string>`** (string → int) / **`str <int>`** (int → string) — `20260811.195012` (`do_parse`/`do_str`; test `rishi/tests/parse.rish`). The `^-` cast validates a kind; `parse`/`str` convert between the two, inverse at the value level (`parse (str n) == n`). `str` yields a string *value* (usable in a list, then `join`ed), where interpolation `"${n}"` only renders inside a literal.

Full suite 23/23 GREEN — the whole cookbook (strings · lists · numbers) now reaches the interpreter as builtins.

## Horizon

Further chapters grow one witnessed primitive at a time; each cookbook function reaches the interpreter as a builtin once its suite test is green.

---

*Every language owes the same small tasks; the cookbook is where it pays them, one proof at a time.*
