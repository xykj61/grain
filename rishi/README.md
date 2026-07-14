# Rishi — the shell of the Rye ecosystem

**Version:** `20260620.153812` (Rye chronological stamp)
**Last updated:** 2026-07-10 (Radiant Style pass round 2)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — shell, small and growing

---

Rishi is the interactive-and-scripting shell of the Rye ecosystem: terse for the
hand, typed for safety, a sibling of Rye that shares its value model. The name
is a seer who hears the human and speaks faithfully to the machine — which is a
shell's whole work. Scripts carry the `.rish` extension. The reasoning behind
the name and the design lives in `../active-designing/yonder/20260619-051312_the-faithful-hand.md`,
`../active-designing/yonder/20260618-184912_growing-a-language.md`, and this README. (Historical:
`../external-research/20260621-051612_rishi-shell-redirect.md` is a redirect stub.)

## What This First Version Does

This version is honest about its size. It reads a `.rish` script and runs it,
supporting:

- **Comments** — a line beginning with `#`.
- **`let` bindings** — `let name = "a string"`, `let name = 42`, `let flag = true`,
  or `let copy = other` to carry an earlier value forward.
- **`say`** — `say "text with ${expr} woven in"`, evaluating each `${expr}` (a
  name, a field path, or a literal), or `say expr` to speak one value. Each `say`
  ends with a newline.
- **Lists** — `let xs = ["a" "b" "c"]`, written space-separated; a quoted element
  may hold spaces of its own. `say xs` shows `[a b c]`, and two lists are equal
  when their elements match in order.
- **Records** — `let r = { a: 1, b: "x", inner: { y: 2 } }`, comma-separated
  `name: value` fields. Read a field with `r.a`, nested with `r.inner.y`. `say r`
  shows `{a: 1, b: x, inner: {y: 2}}`, and two records are equal when they hold the
  same fields and values, in any order.
- **String interpolation** — any quoted string with a `${expr}` hole composes a new
  value: `"${dir}/${name}.zig"` builds a path, `"${n} items"` weaves an integer into
  text. The same `${…}` that `say` speaks now builds string values everywhere.
- **Comparison** — `a == b` and `a != b` yield a boolean; unlike kinds simply
  differ. The operator is found outside any quoted string, so `==` inside `"text"`
  stays text.
- **`contains`** — `list contains value` yields a boolean for list membership;
  `string contains substring` checks whether a substring appears anywhere in the text.
- **`run`** — `let result = run ["echo" "hello"]` executes a command and returns a
  record: `out` and `err` (the captured text), `code` (the exit status), and `ok`
  (true when the code is zero). A command that exits non-zero is an ordinary
  result; a spawn that fails to begin stops the script and says why.
- **`map` and `where`** — `map xs as x: <expr>` transforms each element into a new
  list; `where xs as x: <pred>` keeps the elements whose boolean predicate holds.
  The body can project a field (`map people as p: p.name`), compare, or even
  `run` a command per element; the loop binding lives only inside the pipeline.
- **`assert`** — `assert <expr>` makes a fact a gate: when the expression is a
  false boolean, the script stops, says why, and exits non-zero. An optional
  `else "message"` gives the reason to show.
- **Integer arithmetic** — `+`, `-`, `*`, `/` on integers, with correct operator
  precedence (`*`/`/` before `+`/`-`) and left-to-right associativity. Negative
  number literals work as operands (`3 + -2` is `1`).
- **Parenthesized expressions** — `(expr)` groups its contents, overriding
  precedence: `(2 + 3) * 4` is `20`, and `assert (xs contains y)` parses the
  membership test as a single expression.
- **File I/O** — `read-file path` returns file contents as a string;
  `write-file path value` writes a value to a path; `list-dir path` returns
  entry names as a list (`tests/file_io.rish`).
- **`env`** — `env "NAME"` reads the process environment; empty string when unset
  (`tests/env.rish`; witness `tools/rish_env_witness.rish`).
- **Exit vocabulary** — pre-bound `exit-ok`, `exit-temporary`, `exit-permanent`,
  `exit-could-not-begin`; `exit EXPR` ends the script (`tools/rish_exit_codes_witness.rish`).
- **`lines`** — `lines text` splits a string on newlines into a list of strings.
- **`starts-with`** — `text starts-with prefix` checks whether a string begins
  with a given prefix (used in gates and tests).
- **`ends-with`** — `text ends-with suffix` checks whether a string ends with a
  given suffix (file extensions, line endings in filters).
- **`index-of`** — `text index-of needle` returns the byte index of the first
  match, or `-1` when the needle is absent.
- **`join`** — `join list sep` composes string list elements with a separator.
- **`split`** — `split text sep` decomposes a string into a list on a separator.
- **`length`** — `length text` or `length list` returns byte length or element count.
- **`trim`** — `trim text` removes leading and trailing whitespace.
- **`slice`** — `slice text start end` returns a bounded substring `[start, end)`.

## Interactive REPL (`rishi` / `rishi repl`)

Start the loop with bare `rishi` or `rishi repl`. Each ordinary line is evaluated
in-process; bindings carry forward. Meta-commands begin with `:` (or `!` for recall shorthand):

| Command | What it does |
|---------|----------------|
| `:quit` / `:q` | End the session |
| `:history` | List recent input lines, numbered from 1 |
| `:version` | Write the session transcript to `.mantra/session.log` and weave it into Mantra (`mantra add`) |
| `:recall <n>` | Re-run history entry *n* as if freshly typed |
| `!<n>` | Shorthand for `:recall <n>` |

The history lap holds the last 50 input lines (meta-commands are not stored).
`RISHI_MANTRA` overrides the Mantra binary; default is `mantra` on `PATH`.

A short example, `tests/hello.rish`:

```
let who = "Rye"
let year = 2026
say "hello from Rishi, sibling of ${who}!"
say "the year is ${year}"
```

## Build and Run

Rishi is written in Rye (`src/main.rye`) and built by Rye itself — `rye build` —
against Rye's own standard library, so the language we are growing, the language
we write it in, and the language that builds it are one and the same:

```sh
mkdir -p rishi/bin
export RYE_ZIG="$PWD/vendor/zig-toolchain/zig"   # the toolchain Rye builds with
rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi

rishi/bin/rishi version
rishi/bin/rishi run rishi/tests/hello.rish
rishi/bin/rishi run rishi/tests/checks.rish   # booleans, comparison, and assert
rishi/bin/rishi run rishi/tests/lists.rish    # lists, contains, and equality
rishi/bin/rishi run rishi/tests/records.rish  # records, field access, and equality
rishi/bin/rishi run rishi/tests/run.rish      # running commands, results as records
rishi/bin/rishi run rishi/tests/map_where.rish # transforming and filtering lists
rishi/bin/rishi run rishi/tests/strings.rish      # composing strings by interpolation
rishi/bin/rishi run rishi/tests/arithmetic.rish   # integer arithmetic and grouping
rishi/bin/rishi run rishi/tests/file_io.rish      # read-file, write-file, list-dir
rishi/bin/rishi run rishi/tests/env.rish          # env process lookup
rishi/bin/rishi run rishi/tests/lines_startswith.rish  # lines and starts-with
rishi/bin/rishi run rishi/tests/ends_with.rish         # ends-with suffix checks
rishi/bin/rishi run rishi/tests/join.rish              # join list with separator
rishi/bin/rishi run rishi/tests/split.rish             # split string on separator
rishi/bin/rishi run rishi/tests/contains_string.rish   # contains for lists and strings
rishi/bin/rishi run rishi/tests/index_of.rish          # index-of substring search
rishi/bin/rishi run rishi/tests/parser_hyphens.rish    # hyphenated ops vs subtraction
rishi/bin/rishi run rishi/tests/string_builtins.rish   # length, trim, slice
```

### The gate trio

Rishi orchestrates Rye's strengthening safety net — all `.rish`, no `.sh`:

```sh
rishi/bin/rishi run tools/parity.rish           # behavior: witnesses via rye run, 21 programs GREEN
rishi/bin/rishi run tools/parity-selftest.rish  # gate turns RED on tamper
rishi/bin/rishi run tools/additive-gate.rish    # shape: assertions-only std diff
```

Each test is a run of facts that all hold — comparison and `assert`, lists and
membership, records and field paths, a command run as a record, a list transformed
and filtered, a string composed. A false `assert` instead stops the script, names
the broken fact, and exits non-zero: the gate behavior `parity.rish` leans on.

## How It Grows

The first version was the seed; **`parity.rish` now runs** and guards the whole strengthened witness set (`../tools/parity.rish`). **`parity-selftest.rish`** proves the gate turns RED on a real divergence. **`additive-gate.rish`** classifies std diffs as assertions-only or REVIEW. Together they are the gate trio documented in `../rye-learning-process/ALMANAC.md`.

Two north stars guide further growth. `tests/hello.rish` is what runs today;
`examples/pond.rish` is where we are headed — an illustrative sketch of Rishi
composing a sandbox policy as a value and opening a **Pond** enclosure over
Caravan's isolation and Tally's bounded gardens. The reasoning lives in
`../external-research/20260618-180812_pond-foundation.md`.

`say` writes to standard output. When a Rishi script is run as a child via
`run ["rishi" "run" "child.rish"]`, the child's `say` output appears in
`result.out` and can be read, compared, and asserted like any other value.

---

*May Rishi hear us truly and speak without distortion — small today, and growing
gently into a shell worth living in.*
