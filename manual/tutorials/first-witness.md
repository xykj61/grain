# Your First Rishi Witness

**Language:** EN
**Last updated:** 2026-07-02
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Parity ground:** **142** — every command below runs green today

---

A **witness** is a `.rish` script that proves one honest fact about the system. Witnesses live under `tools/`, run from the repository root, and end with a `GREEN:` line when they pass. The parity suite runs them all; the manual teaches only what they already show.

## Step 1 — Run an existing witness

From the repository root:

```bash
rishi/bin/rishi run tools/run_record_witness.rish
```

You should see:

```
GREEN: RW-3 — run record pins .ok, .code, .out, and .err for both outcomes.
```

If the line appears, the witness passed. If an `assert` fails, Rishi stops with a plain message on standard error and a nonzero exit.

## Step 2 — Read what it does

Open `tools/run_record_witness.rish`. The shape is the whole discipline:

1. **`let`** — bind a name to a value (here, the result of `run`)
2. **`run`** — execute an external command; receive a four-field record (`.ok`, `.code`, `.out`, `.err`)
3. **`assert … else`** — stop loudly if the fact does not hold
4. **`say`** — print a human line (the GREEN banner)

Every witness checks `.ok` or `.code` before trusting output. RW-3 pins both a success path and a failure path in one script.

## Step 3 — The opening lines (for `.rye`, not `.rish`)

Hosted Rye modules carry a three-line head — `const assert` and `const print` bindings, no qualified `std.debug.*` calls. The opening-lines witness scans the corpus:

```bash
rishi/bin/rishi run tools/opening_lines_witness.rish
```

Rishi scripts (`.rish`) follow the same spirit with `#` comments and `assert`/`say`; they orchestrate builds and gates rather than host module logic.

## Step 4 — Write a tiny witness of your own

Create `tools/fixtures/my_first_witness.rish`:

```rish
# my_first_witness.rish — prove one small fact.
let hello = run ["sh" "-c" "printf 'hello witness\\n'"]
assert hello.ok else "hello command must succeed"
assert hello.out contains "hello witness" else "stdout must carry the greeting"
say "GREEN: my first witness — one run, one assert, one line home."
```

Run it:

```bash
rishi/bin/rishi run tools/fixtures/my_first_witness.rish
```

When it passes, you have the whole pattern: **run, assert, say GREEN**. Negative space works the same way — assert that something *fails*, as in `tools/rs1_args.rish` and `tools/rw4_slc_failure_paths.rish`.

## Step 5 — Where to go next

| Next read | Why |
|-----------|-----|
| [`reference/rishi-language.md`](../reference/rishi-language.md) | Full syntax at parity 142 |
| `tools/rs1_args.rish` | Script arguments and friendly failures |
| `tools/rw4_slc_failure_paths.rish` | Shell meta-command and CLI failure paths |
| `tools/parity.rish` | The full witness suite |

Wire a new witness into `tools/parity.rish` only when the team agrees the fact belongs in the regression gate — parity increments one step at a time.

---

*May your first witness run green, and may every line you add earn its place in the suite.*
