# Session logs archive — Rye core and Rishi witnesses

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260704.203100

**Prompt:** Kaeden asked to turn the archive fold into Rishi scripts with tests confirming correctness and idempotency.

## Thinking trace

Replaced shell-only fold with `tools/session_logs_archive.rye` — pure helpers (`dayFromLogFname`, `shouldFoldFlat`, `rewriteReadmeLink`), `fold` + `selftest` subcommands, fixture sandbox under `tools/fixtures/session_logs_archive/`. Rishi layer: `session_logs_archive.rish` (production fold), `session_logs_archive_witness.rish` (selftest), `rishi/tests/session_logs_archive.rish` (integration). Selftest proves: one prior-day file moves, today stays flat, README link rewrites, second fold moves=0 and README stable. Updated ORGANIZING + session-logs README.

## Files

| File | Why |
|------|-----|
| `tools/session_logs_archive.rye` | Core fold logic + unit tests + selftest |
| `tools/session_logs_archive.rish` | Production entry (builds bin, runs fold) |
| `tools/session_logs_archive_witness.rish` | Witness — selftest GREEN |
| `rishi/tests/session_logs_archive.rish` | Integration test |
| `tools/fixtures/session_logs_archive/*` | Fixture tree for selftest |
| `.gitignore` | `_sandbox/`, `tools/.build/` |

## Recommend

**Keep going** — wire `session_logs_archive_witness.rish` into `tools/parity.rish` if archive hygiene should gate every push; otherwise run witness at each day's close before fold.
