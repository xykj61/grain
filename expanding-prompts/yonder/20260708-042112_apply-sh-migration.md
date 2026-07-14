# Cursor Apply-Prompt — Two `.sh` Migrations, One Real Wall Documented

**Stamp:** `20260708.042112 UDT` · **Parent:** `9300d35` · **Voice:** Rio 3
**Bundle:** `20260708-042112_sh-migration-two-wins-one-wall.zip`

Read all 25 remaining `tools/fixtures/*.sh` scripts before picking targets. Two landed and verified; one real language limitation found and documented rather than worked around.

## What Lands

- **`tools/fixtures/rs1_args_max.rish`** — native repoint, 65 literal arguments (Rishi has no accumulating loop). `tools/rs1_args.rish` wrapper updated to call it; **full four-assertion RS-1 witness verified GREEN** on the real interpreter.
- **`tools/fixtures/rw1_exact_probe.rish`** — native repoint using genuine list indexing (`expr[n]`, `.len` — confirmed real and general, a correction to this bench's own earlier claim that indexing didn't exist). Core logic verified against a built two-blob fixture (match + non-match). `tools/rw1_history_contract.rish` wrapper updated to call it — **the full witness chain needs a metal check**, since building `mantra/bin/mantra` hit an unrelated, pre-existing wrapper-staging limitation on this bench (`mantra/src/main.rye`'s own `../parse_int.rye` import) that was not touched or fixed here.
- **`context/TAME_GUIDANCE.md`** — two corrections recorded: list indexing is real and general; `say` writes to stdout while runtime `print`-based messages (argument rejection, file-not-found) are hardcoded to stderr — a script capturing another Rishi process's result needs to know which field carries which.
- **A real wall, named precisely**: `where`'s input must be a bound name, not a complex expression — confirmed by direct testing, not assumed. Blocks `opening_lines_scan.sh` and `tame_check_mantra.sh`, both needing multi-condition-per-item checks. A `let…in` or block-body form for `for-each`/`map` would close it — proposed and parked as a new-name question, not built.
- **`TASKS.md`** — full recalibrated census: regex-dependent scripts (same class as camelCase), the wall-blocked pair, an untested stdin/REPL question (`slc1_accept.sh`), and the smaller remainder not yet attempted.

## Steps

1. Tree at `9300d35`; unzip at root.
2. `rishi/bin/rishi run tools/rs1_args.rish` — expect GREEN.
3. `rishi/bin/rishi run tools/rw1_history_contract.rish` on metal — this is the one check this bench could not complete; confirm the full chain including `mantra`'s own build.
4. No parity count change from `rs1_args_max` alone; `rw1_history_contract`'s existing stanza should still cover the repoint once confirmed.

## Held

`opening_lines_scan.sh`, `tame_check_mantra.sh` — wait on the `let…in`/block-body language feature, itself waiting on your word. `chrono_version_scan.sh`, `identity_shape.sh`, `two_rooms_doorway_scan.sh` — genuinely regex-dependent, stay `.sh`. `slc1_accept.sh` — untested whether `run` can express stdin redirection at all.

---

*May the next script that needs to know which stream carries which message never have to learn it the hard way again.*
