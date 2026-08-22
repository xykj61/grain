# Rishi -- the language reference

*Every form the shell understands, each with a line that was run before it was written down -- and the edges, which are the part a reference usually leaves out.*

**Language:** EN - **Style:** Radiant - **Voice:** Kyri
**Written:** `20260821.185852` - **Status:** Living - **Kind:** crushed API surface
**Source it compresses:** [`../../rishi/README.md`](../../rishi/README.md) (the tour) and `rishi/tests/*.rish` (the proofs). This page is the *reference*: what to reach for, what it returns, and where it refuses.

---

## Values

Five kinds, composed side by side and never tangled -- the one value model TAME asks for.

| Kind | Written | Note |
|---|---|---|
| string | `"a string"` | interpolation with `${...}` |
| integer | `42`, `-2` | `+ - * /`, correct precedence, `( )` groups |
| bool | `true`, `false` | from comparison and the predicates below |
| list | `["a" "b" "c"]` | space-separated; a quoted element may hold spaces |
| record | `{ a: 1, b: "x" }` | read with `r.a`, nested with `r.inner.y` |

## Bindings and flow

```
let name = value            # bind; rebinding a name is how a value moves forward
say expr                    # speak one value, or a string with ${...} holes
assert expr else "reason"   # a fact as a gate: false stops the script, non-zero exit
if cond then A else B       # else optional
for-each xs as x do BODY    # iterate
exit exit-ok                # also exit-temporary, exit-permanent, exit-could-not-begin
```

## Strings

Every line below was run; the output is what it printed.

| Form | Example | Prints |
|---|---|---|
| `trim` | `let a = trim "  Grain  "` | `Grain` |
| `length` | `let b = length "hello"` | `5` |
| `slice` | `let c = slice "YYYYMMDD-HHMMSS_slug.kyri" 0 8` | the first eight characters -- a day |
| `index-of` | `let d = "a/b/c" index-of "/"` | `1` (`-1` when absent) |
| `split` | `let p = split "a/b/c" "/"` | a list of `3` |
| `join` | `let f = join p "-"` | `a-b-c` |
| `starts-with` | `let g = "grain" starts-with "gr"` | `true` |
| `ends-with` | `let h = "x.kyri" ends-with ".kyri"` | `true` |
| `contains` | `let i = "radiant" contains "dia"` | `true` |
| `lines` | `lines text` | splits on newlines into a list |
| `matches` | `text matches pattern` | bounded regex; **`matches` is a reserved word** |

## Lists

| Form | Example | Prints |
|---|---|---|
| `length` | `let j = length ["b" "a" "c"]` | `3` |
| `contains` | `let k = xs contains "a"` | `true` |
| `map` | `let ys = map xs as x: "<${x}>"` | `<b><a><c>` when joined |
| `where` | `let zs = where xs as x: x != "b"` | `a,c` when joined |

Index with `xs[i]`, where `i` may be a **bound name** doing arithmetic -- `let n = length xs` then `xs[n - 1]`. See the edges.

**`.len` is the other spelling.** Lists and strings both answer it: `let n = xs.len` gives `3`, and `let n = s.len` gives `5`. This page missed it until the elder conformance reference was read against the tree and turned out to be right about it (`20260821.191504`) -- a reference checked against the language found by a reference checked against the language.

## Running commands

```
let r = run ["echo" "ok"]
# r.ok = true   r.code = 0   r.out = "ok\n"   r.err = ""
```

`run` returns a record: `out`, `err`, `code`, and `ok` (true when the code is zero). **Check `ok` before trusting `out`** -- a command that exits non-zero is an ordinary result, not a stop. A spawn that cannot begin at all stops the script and says why.

## Files and environment

| Form | Returns |
|---|---|
| `read-file path` | contents as a string |
| `write-file path value` | writes a value to a path |
| `list-dir path` | entry names as a list |
| `env "NAME"` | the process environment; empty string when unset |
| `args` | the script's arguments as a list; `args[0]` is the first, and `args.len` counts them |
| `flag` | `flag args "--name"` scans for `--name value` and returns the value -- **two arguments**, the list and the name; `flag "name"` alone raises `FlagNeedsName` |

---

## The edges

A reference that lists only what works teaches half. Each of these cost a real round to find.

**Interpolation takes a name, a field path, or a literal -- not an expression.** `${"a/b/c" index-of "/"}` prints the text back at you rather than `1`. Bind first, then interpolate:

```
let d = "a/b/c" index-of "/"
say "found at ${d}"
```

**There is no ordering operator.** Only `==` and `!=`. To say "more than one", let the larger case stand and correct it: set the answer to the many-case, then override for `0` and for `1`.

**There is no newline escape and no multi-line string.** `"a\nb"` is a literal backslash and an `n`. When a real newline is needed, ask the shell for the one character:

```
let nl = (run ["printf" "\n"]).out
let block = "first${nl}second"
```

**`slice` refuses an out-of-range end** rather than clamping. Check the length first, or take the shape apart with `split` and read the piece you want.

**A `let` inside `for-each` does not escape the loop.** There is no accumulator; reach for `map`, `where`, and `join`, or let a `run` do the folding.

**Strings are bounded.** An 18 KB file read into one value overruns the bound (`StringTooLong`). Keep the claim in Rishi and hand the byte-shuffling to a small shell fixture -- the language that checks the fact owns the fact.

**`matches` is a reserved word.** `let matches = where ...` binds a name the parser already owns, and every later use reads `UndefinedName`.

**`say` writes to stdout; a Rye program's `print` writes to stderr.** A tool whose whole output is one value must put that value where a caller captures it.

---

## The other reference

[`../../manual/reference/rishi-language.md`](../../manual/reference/rishi-language.md) is the **conformance** reference: fifteen numbered sections, *must* and *should* carrying their plain weight, pinned to the witness corpus at parity 142. It answers *what is the language obliged to do*. This page answers *what do I reach for, and where will it surprise me* -- and the two were read against each other on `20260821.191504`, which is how `.len` and `flag` arrived here. Neither supersedes the other; a language wants both a contract and a field guide.

## Where this is proven

`rishi/tests/*.rish` holds a test per feature, and `tools/rish_*_witness.rish` proves the exit vocabulary, the environment lookup, and the regex primitive on metal. Run one:

```sh
rishi/bin/rishi run tools/rish_exit_codes_witness.rish
```

```
GREEN: Rishi exit vocabulary -- pre-bound names and exit statement.
```

## Kin

- [`../tutorials/the-first-hour.md`](../tutorials/the-first-hour.md) -- from nothing to five lines of your own
- [`../../rishi/README.md`](../../rishi/README.md) -- the tour, and how Rishi is built
- [`../libraries/README.md`](../libraries/README.md) -- what else this tree offers a script

*May the edges above save you the rounds they cost, and may the reference stay as true as the day each line was run.*
