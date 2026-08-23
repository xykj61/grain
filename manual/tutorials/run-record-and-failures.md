# The Run Record and Friendly Failures

**Language:** EN
**Last updated:** 2026-07-18 (Voice Quin · Acme audience)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Audience:** an Acme Corporation employee reading run-record fields after first-witness
**Parity ground:** **142** — RW-3 and RW-4 green today
**Law:** [`../../context/TAME_GUIDANCE.md`](../../context/TAME_GUIDANCE.md)

---

Tutorial one introduced the witness shape. This room reaches deeper — into the **run record**, the four fields every gate trusts, and the **fault paths** RW-4 pins beside the successful ones.

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
rishi/bin/rishi run tools/r/run_record_witness.rish
```

Open the script and read both branches: success captures stdout on `.out` with empty `.err`; a fault preserves code `7` and places the message on `.err`.

## Step 2 — Assert every field you rely on

RW-3 teaches the discipline the whole tree uses:

```rish
assert ok_run.ok else "success path must report ok"
assert ok_run.code == 0 else "success path must exit zero"
assert ok_run.out contains "RW-3 stdout" else "stdout must carry the fact"
assert ok_run.err == "" else "stderr must stay empty on success"
```

On a fault, flip the expectations: `(fail_run.ok == false)`, match `.code`, assert `.err contains` the friendly message.

## Step 3 — Friendly failures in the shell (RW-4)

Shell meta-commands and CLI slips leave the session **running**, and stderr names what happened kindly:

```bash
rishi/bin/rishi run tools/r/rw4_slc_failure_paths.rish
```

RW-4 pins: unknown meta-command · bad `:recall` · doomed `run` script · unknown CLI subcommand. Each asserts `.ok` or exit code **and** the human-readable fragment on stdout or stderr.

## Step 4 — Compose success and failure in one witness

When you write the next gate, pair paths in one file when they share one seam — exactly as RW-3 and RW-4 do. Negative space is proof: `(v.ok == false)` asserted on purpose.

## Step 5 — Where to go next

| Next read | Why |
|-----------|-----|
| [`first-witness.md`](first-witness.md) | The opening pattern |
| [`reference/rishi-language.md`](../reference/rishi-language.md) | Full syntax |
| [`../../construction/archive/20260702-200109_rw1-mirrored-pair-contract.md`](../../construction/archive/20260702-200109_rw1-mirrored-pair-contract.md) | Mirrored pairs at the history seam |

---

*May every subprocess answer with four honest fields, and may every failure name itself kindly enough to learn from.*
