# The Rishi Language — Reference

**Language:** EN
**Last updated:** 2026-07-02
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Version:** `20260702.184312` — derived from the living witness corpus at parity **142** and the interpreter at `rishi/src/main.rye`
**Versions, all enduring:** `20260702.180812` first page (parity 140) · same-arc revision to parity 142 (`if`, stderr seam) · `20260702.184312` the page's own versioning brought under the chronological law (`../../context/specs/rye-versioning-style.md`)
**Conformance:** *must* and *should* carry their plain conformance weight
**Pledge:** this reference documents only what runs; every example below is drawn from, or shaped exactly like, a witness that passes today

---

## 1. Invocation

The `rishi` binary answers four commands:

```
rishi version              print the version line
rishi repl                 open the interactive shell
rishi run <script> [args]  execute a .rish script with optional arguments
rishi help | --help        print usage
```

A script that completes exits `0`. A failed assertion or a runtime error ends the script immediately with a nonzero exit and a plain message on standard error.

## 2. Lexical Shape

A script is a sequence of statements, one per line. `#` opens a comment to end of line. Whitespace separates tokens. There are no semicolons and no line continuations; a statement *must* fit its line.

**Strings** are double-quoted and interpolate with `${name}` — bindings and record fields alike: `"${bin} metalsmoke 2>&1"`. **Lists** are square-bracketed and whitespace-separated, with no commas: `["a" "b" "c"]`. **Booleans** are `true` and `false`. Integers appear as values (exit codes, lengths) and compare with `==` and `!=`.

## 3. Bindings — `let`

```
let zig = "vendor/zig-toolchain/zig"
let witnesses = ["sha3_256_test" "version_test"]
let build = run ["rishi/bin/rishi" "run" "tools/fixtures/pond_build_drawn_terminal.rish"]
```

`let` binds a name to a value. Bindings do not rebind; a new meaning takes a new name, in the accrete-never-break spirit. Name bindings for what they *are* rather than how they were computed.

## 4. Running Processes — `run`

`run LIST` executes the list as an argument vector and returns a **run record** with four fields:

| Field | Type | Meaning |
|-------|------|---------|
| `.ok` | boolean | the process exited zero |
| `.code` | integer | the exact exit code |
| `.out` | text | captured standard output |
| `.err` | text | captured standard error |

```
let smoke = run ["sh" "-c" "${bin} metalsmoke 2>&1"]
assert smoke.ok else "metalsmoke exited non-zero"
```

A pipeline *must* check `.ok` (or `.code`) before trusting `.out` or `.err`. External programs keep stdout and stderr separate in the run record. When a witness drives **`rishi repl`** or **`rishi run`** as a subprocess, Rishi's own diagnostics land on **stderr** — merge with `2>&1` in the host seam when the witness needs to read them from `.out`, as in `tools/rw4_slc_failure_paths.rish`.

The `["sh" "-c" "…"]` form remains the **host seam** for setting variables, redirection, and globbing; scripts *should* keep each seam to one honest line. For **reading** the process environment, `env "NAME"` returns the value as a string, or the empty string when unset — witness: `tools/rish_env_witness.rish` (run with `RISHI_ENV_WITNESS_TEST=pinned`).

```
let home = env "HOME"
let zig = env "RYE_ZIG"
```

By convention every script runs **from the repository root**; scripts *must not* assume any other working directory.

## 5. File I/O — `read-file`, `write-file`, `list-dir`

```
write-file "tools/fixtures/rish_io/roundtrip.txt" "hello from rishi witness"
let content = read-file "tools/fixtures/rish_io/roundtrip.txt"
let entries = list-dir "tools/fixtures/rish_io"
assert entries contains "roundtrip.txt" else "list-dir missed the file we wrote"
```

| Form | Returns | Effect |
|------|---------|--------|
| `read-file PATH` | file contents as string | reads from the current working directory |
| `write-file PATH VALUE` | none (statement) | renders `VALUE` to text and writes |
| `list-dir PATH` | list of entry names | bounded at 256 entries |

Paths evaluate to strings; integers and other values render through the same `write-file` path as `say`. A missing file stops the script with `ReadFileFailed`; a missing directory stops with `ListDirFailed`. Witness: `tools/rish_file_io_witness.rish`.

## 6. Exit Vocabulary — pre-bound names and `exit`

Every script and REPL session pre-binds four integer names — execline/s6 lineage values Caravan's restart policy reads:

| Name | Value | Meaning |
|------|-------|---------|
| `exit-ok` | 0 | success |
| `exit-temporary` | 112 | temporary failure — restart |
| `exit-permanent` | 111 | permanent failure — do not restart |
| `exit-could-not-begin` | 125 | could not execute — enclosure or spawn failure |

```
exit exit-temporary
let code = exit-permanent
assert temp.code == exit-temporary else "child must speak temporary failure"
```

`exit EXPR` ends the script immediately with the integer code (0–255). Witness: `tools/rish_exit_codes_witness.rish`.

## 7. Gates — `assert … else`

```
assert build.ok else "drawn_terminal build failed for Lap 3 witness"
assert (oob.ok == false) else "out-of-range index must fail"
```

`assert EXPR else "message"` stops the script loudly when the expression does not hold, printing the message on standard error. Parentheses group comparisons. Assertions are the language's whole control discipline: place one after every `run`, before every effect. Negative space is asserted as deliberately as positive — a check that something *fails* is a first-class witness line.

## 8. Conditional — `if … then … else …`

```
if length fails == 0 then say "OPENING LINES GREEN: all hosted files carry the canonical head."
if length fails != 0 then say "OPENING LINES RED: some files missing the head."
```

`if CONDITION then STATEMENT` runs the statement when the condition evaluates to a boolean `true`. An optional `else STATEMENT` arm runs when the condition is false. The condition *must* be boolean — comparisons like `length fails == 0` or `(fail_run.ok == false)` are the usual shapes. Witnesses in parity **142** use `if` for reporting; gates remain `assert … else`.

## 9. Expressions

Equality `==` and inequality `!=` work on strings, integers, and booleans. `TEXT contains "needle"` tests substring presence. Records answer field access with `.name`; lists and strings answer `.len`; lists answer indexing `xs[i]`, and an out-of-range index ends the script with a friendly `out of range` error.

## 10. Comprehensions — `map`, `where`, `length`

```
let runs     = map witnesses as s: run ["env" "RYE_ZIG=${zig}" rye "run" "${dir}/${s}.rye"]
let codes    = map runs as r: r.code
let failures = where codes as c: c != 0
assert length failures == 0 else "a witness failed — the regression suite is RED"
```

`map LIST as x: EXPR` transforms every element; `where LIST as x: PRED` keeps the elements that satisfy the predicate; `length LIST` counts. These three carry much of the parity suite. Branching and iteration with effects live in §11.

## 11. Conditionals and Iteration — `if` and `for-each`

```
if x == 5 then let msg = "yes" else let msg = "no"
if path starts-with "/home" then let is_home = true else let is_home = false
for-each items as i do if i == 3 then say "found three"
```

Conditions may compare with `==`, `!=`, and `starts-with`. The `then` branch runs when the condition is true; `else` is optional. **`for-each`** runs a statement for each list element — effects included. Witness: `tools/rish_conditional_witness.rish`.

## 12. Output — `say`

`say "…"` prints a line with interpolation; lists render inline. The convention across the corpus: a witness's final line begins `GREEN:` on success, and gates upstream test for it with `contains "GREEN"`.

## 13. Script Arguments — `args` and `flag`

Inside a script run as `rishi run script.rish a b c`:

```
assert (args.len == 3) else "expected args.len == 3"
assert (args[0] == "a") else "expected args[0] == a"
let path = flag args "--appimage"
```

`args` is the list of words after the script path. `flag LIST "--name"` scans for `--name value` and returns the value; a missing flag ends the script with `flag not found`, and a flag at list's end with `requires a value` — both *must* remain friendly, single-line messages.

## 14. The Interactive Shell

`rishi repl` reads lines, runs them, and keeps the last **50** inputs. Meta-commands begin with a colon: `:history` lists recent inputs; `:recall <n>` replays one; `:version` prints the version; `:quit` and `:q` leave. Everything else on a line is dispatched as a command. Unknown meta-commands and bad `:recall` arguments answer with a friendly line and the session continues — pinned in `tools/rw4_slc_failure_paths.rish`. The drawn terminal mirrors exactly this session through `sessionLines`, so the shell's contract and the window's content are one value.

## 15. Named Gaps — the Growing Edge

Held openly, so the reference and the roadmap agree: **`if` / `for-each`** in `tools/rish_conditional_witness.rish`; **`env`** in `tools/rish_env_witness.rish`; **file I/O** in `tools/rish_file_io_witness.rish`; **exit vocabulary** in `tools/rish_exit_codes_witness.rish`. The framework-growth witness track for this season is complete at parity **142**; new surface enters only on the day its witness runs green.

---

*May this page and the parity suite never disagree — and when the language grows, may the witness land first and the sentence follow.*
