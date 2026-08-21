# Session log — Move 3 std re-fork executed

**Stamp:** `20260628.051500`
**Editor:** Cursor · **Model:** Composer
**Arc:** Thin frontend four moves — Move 3 (std re-fork)

## Thinking trace

Kaeden confirmed sequencing: push `e433eb1` first, then execute Move 3 with two gates held — (1) capture the 17 divergent files in the harvest before symlink, (2) repurpose parity as witness suite + re-fork guard, not a later thought.

The inventory surprise from the prior turn held: 17 real deltas, 535 identical copies. Move 3 is subtraction — symlink pristine std, retire the differential gate, keep 116 witnesses as regression suite.

Execution order followed the gates:

1. **Harvest gate** — Seventeen-file table already appended to `work-in-progress/20260628-044200_call-site-harvest.md` before symlink (diff stats, pass notes, verify flags).
2. **Symlink** — `rye/lib/std` → `../../vendor/zig-toolchain/lib/std` (535 tracked files removed from tree).
3. **Parity repurpose** — `tools/parity.rish` single-arm witness suite; fixed `fold` → `map`/`where`/`length` (Rishi has no `fold`). `tools/parity-selftest.rish` std-overlay guard: symlink check + shadow tamper.
4. **Docs** — `rye/README.md`, `rye-learning-process/ALMANAC.md` Gate Trio, `work-in-progress/ROADMAP.md`, refork plan marked executed, `work-in-progress/README.md`.

## Verification

- `rishi/bin/rishi run tools/parity-selftest.rish` — **GREEN** (symlink confirmed; tamper on shadow caught).
- `rye/bin/rye run rye/tests/*.rye` — **blocked** on host by `DWARF TODO: NoSpaceLeft` panic (pre-existing compiler issue in this environment; not caused by symlink). Full witness suite (`parity.rish`) should be run when `rye run` is healthy.

## Decisions

- Strengthening assertions in the 17 files do **not** return to overlay — harvest to call sites per harvest doc.
- Differential parity gate **retired**; post-re-fork GREEN on old gate would be vacuous.
- Additive gate remains for accidental re-fork detection at commit shape level.

## Files

| File | Why |
|------|-----|
| `rye/lib/std` (symlink) | Pristine overlay — end of 552-file fork |
| `tools/parity.rish` | Witness regression suite (116 programs, single arm) |
| `tools/parity-selftest.rish` | Std symlink + tamper guard |
| `work-in-progress/20260628-044200_call-site-harvest.md` | 17 divergent files captured pre-symlink |
| `work-in-progress/20260628-044300_std-refork-plan.md` | Status → executed |
| `work-in-progress/ROADMAP.md` | Std re-fork done; gate trio wording |
| `work-in-progress/README.md` | Refork row updated |
| `rye/README.md` | Pristine std + new gate semantics |
| `rye-learning-process/ALMANAC.md` | Gate Trio rewritten for thin frontend |
