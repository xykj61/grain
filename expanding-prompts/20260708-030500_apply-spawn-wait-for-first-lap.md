# Cursor Apply-Prompt — Rishi `spawn` / `wait-for` first lap

**Stamp:** `20260708.030500 UDT` · **Parent:** `03879e7` · **Voice:** Rio 3
**Counsel:** [`counsel/20260708-021912_claude-counsel-realidream-zig016-brix.md`](../counsel/20260708-021912_claude-counsel-realidream-zig016-brix.md)
**Gate:** Kaeden's word on the verb names — design is complete; do not implement until affirmed.

Rishi's `run` blocks until exit. That structural fact keeps seven wire-lab `.sh` scripts and `aurora/run.sh` on the POSIX seam list. Caravan already uses `std.process.Child`; the gap is Rishi the language having no non-blocking spawn-then-wait surface.

## What lands (first lap only)

1. **`spawn ["cmd" "arg" ...]`** — starts a child, returns a bounded handle record (monotonic id + pid metadata as available). Cap live handles (counsel: named max, start at **8**).
2. **`wait-for <handle>`** — blocks until that child exits; returns `{out, err, code, ok}` matching today's `run` record shape.
3. **`tools/rish_spawn_witness.rish`** — spawns `sh -c 'echo hello; exit 0'`, waits, asserts `.ok` and stdout; unwelcome path: non-zero exit, `.ok == false`.
4. **`tools/rish_wait_for_witness.rish`** — two-handle ordering: spawn A (sleep), spawn B (immediate exit), wait B first, wait A — proves handles are independent.
5. **Mirror in `pond/apps/rishi/main.rye`** if the hosted binary is still symlinked/twinned from `rishi/src/main.rye` — same diff both sides.
6. **Do not wire parity yet** — witness-first, same pattern as `rish_env_witness.rish` and `rish_file_io_witness.rish`.

## What does not land this lap

- Migrating `comlink/run_*_wire_lab.sh` — lap 2, after witnesses GREEN.
- `Io.Group` async — explicitly out of scope per counsel `021912`.
- Renaming verbs — if Kaeden chooses different names, replace in this prompt before `kg`.

## Steps

1. Kaeden affirms **`spawn`** and **`wait-for`** (or supplies replacements).
2. Implement in `rishi/src/main.rye` — parser + evaluator branches beside `run`; reuse `std.process.spawn` + `wait` patterns from `caravan/seed.rye` / `linengrow/delivery.rye`.
3. `rishi/bin/rishi run tools/rish_spawn_witness.rish` GREEN.
4. `rishi/bin/rishi run tools/rish_wait_for_witness.rish` GREEN.
5. `rishi/bin/rishi run tools/tame_style_check.rish` GREEN (Ed25519 ratchet stays **0**).
6. Session log + TASKS line: spawn lap 1 checked, wire-lab migration named as lap 2.

## Held

SLC-L3 settlement — custody gate unchanged. Realidream sketchbook vendoring and gratitude lines — taste, not this lap.

---

*May the verb arrive whole — handle, wait, record — before any wire lab sheds its shell script.*
