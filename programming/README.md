# Programming -- the cookbook

**Language:** EN
**Status:** Living -- strings `20260811.190026` - lists `20260811.190458` - numbers `20260811.190916`
**Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Voice:** Kyri

This module is the standard library grown by the common tasks every language owes -- strings, lists, numbers -- each a bounded, witnessed primitive. The lessons sit at `docs-geode/edu/yonder/programming/README.md`. The elder path [`../pleac/README.md`](../pleac/README.md) points here.

## Strings (`strings.rye`, landed `20260811`)

The canonical pair, inverse for separator-free pieces:

- **`join(parts, sep, out)`** -- glue a list of pieces into one string, a separator between them (never trailing); refuses a too-small output.
- **`split(src, sep, out)`** -- cut a string on a separator into pieces, zero-copy (each piece slices the source); refuses an empty separator.

`split(join(xs, sep), sep) == xs`, proven by `prove_strings`, along with a separator-free source yielding one whole piece and both bound declines. Bounded by `max_parts` and `max_out`.

```
rye build programming/strings.rye -femit-bin=tools/.build/pleac_strings
tools/.build/pleac_strings selftest
rishi/bin/rishi run tools/p/pleac_strings_witness.rish
```

## Lists (`lists.rye`, landed `20260811`)

The grouping trio over a bounded list of `u32`:

- **`chunk(xs, size, out)`** -- consecutive, non-overlapping groups of `size` (the last may be shorter), zero-copy slices into `xs`.
- **`window(xs, size, out)`** -- every overlapping run of `size`, in order; count `len - size + 1`, or none when shorter than a window.
- **`flatten(lists, out)`** -- concatenate a list of lists into one; refuses a too-small output.

`flatten(chunk(xs, n)) == xs` (grouping is lossless), proven by `prove_lists`, with the window count, the short-list-yields-zero-windows case, and the zero-size / too-small refusals. Bounded by `max_groups` and `max_flat`.

```
rye build programming/lists.rye -femit-bin=tools/.build/pleac_lists
tools/.build/pleac_lists selftest
rishi/bin/rishi run tools/p/pleac_lists_witness.rish
```

## Numbers (`numbers.rye`, landed `20260811`)

The number primitives over `u32`, total (every bad input a named decline):

- **`clamp(x, lo, hi)`** -- bound a value to `[lo, hi]` (the bound must be well-ordered).
- **`parse(s)`** -- a decimal string to `u32`, refusing empty - non-digit - past the ceiling.
- **`to_str(n, out)`** -- a `u32` to its decimal string, the inverse of `parse`; refuses a too-small buffer.

`parse(to_str(n)) == n` across the range, proven by `prove_numbers`, with clamp's edges and every decline. Bounded by `max_digits`.

```
rye build programming/numbers.rye -femit-bin=tools/.build/pleac_numbers
tools/.build/pleac_numbers selftest
rishi/bin/rishi run tools/p/pleac_numbers_witness.rish
```

## Wired into the interpreter

The cookbook primitives also live as Rishi builtins, so a `.rish` script calls them directly beside `sort`/`unique`/`upper`:

- **`clamp <x> <lo> <hi>`** -- `20260811.192204` (`do_clamp`; test `rishi/tests/clamp.rish`).
- **`chunk <list> <size>`** / **`window <list> <size>`** / **`flatten <list>`** -- `20260811.193451` (`do_chunk`/`do_window`/`do_flatten`; test `rishi/tests/chunk.rish`).

- **`parse <string>`** / **`str <int>`** -- `20260811.195012` (`do_parse`/`do_str`; test `rishi/tests/parse.rish`).

Further chapters grow one witnessed primitive at a time.

---

*Every language owes the same small tasks. This cookbook is where those tasks are proved, one at a time.*
