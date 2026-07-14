# The Run Record and Friendly Failures

**Language:** EN
**Last updated:** 2026-07-02
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Rio 3
**Parity ground:** **142** — RW-3 and RW-4 green today

---

Tutorial one introduced the witness shape. This room goes deeper into the **run record** — the four fields every gate trusts — and the **failure paths** RW-4 pins beside success.

## Step 1 — The four fields

Every `run` returns one record:

| Field | Meaning |
|-------|---------|
| `.ok` | `true` when exit code is zero |
| `.code` | the subprocess exit code |
| `.out` | captured stdout |
| `.err` | captured stderr |

Run RW-3:

```bash
rishi/bin/rishi run tools/run_record_witness.rish
```

Open the script and read both branches: success captures stdout on `.out` with empty `.err`; failure preserves code `7` and places the message on `.err`.

## Step 2 — Assert every field you rely on

RW-3 teaches the discipline the whole tree uses:

```rish
assert ok_run.ok else "success path must report ok"
assert ok_run.code == 0 else "success path must exit zero"
assert ok_run.out contains "RW-3 stdout" else "stdout must carry the fact"
assert ok_run.err == "" else "stderr must stay empty on success"
```

On failure, flip the expectations: `(fail_run.ok == false)`, match `.code`, assert `.err contains` the friendly message.

## Step 3 — Friendly failures in the shell (RW-4)

Shell meta-commands and CLI mistakes must **survive** — the session continues, stderr names the problem kindly:

```bash
rishi/bin/rishi run tools/rw4_slc_failure_paths.rish
```

RW-4 pins: unknown meta-command · bad `:recall` · doomed `run` script · unknown CLI subcommand. Each asserts `.ok` or exit code **and** the human-readable fragment on stdout or stderr.

## Step 4 — Compose success and failure in one witness

When you write the next gate, pair paths in one file when they share one seam — exactly as RW-3 and RW-4 do. Negative space is proof: `(v.ok == false)` asserted on purpose.

## Step 5 — Where to go next

| Next read | Why |
|-----------|-----|
| [`first-witness.md`](first-witness.md) | The opening pattern |
| [`reference/rishi-language.md`](../reference/rishi-language.md) | Full syntax |
| [`../../work-in-progress/20260702-200109_rw1-mirrored-pair-contract.md`](../../work-in-progress/20260702-200109_rw1-mirrored-pair-contract.md) | Mirrored pairs at the history seam |

---

*May every subprocess answer with four honest fields, and may every failure name itself kindly enough to learn from.*
