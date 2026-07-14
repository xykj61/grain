# Handoff — SLC-1 lap closed, bench for the next session

*A continuity letter for the next Reya 2 session after the first Simple, Lovable, Complete lap seals on metal.*

**Stamp:** `20260629.031512`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Git tip at close:** `06de97f` — `tools: Cursor in ai-jail launcher — cursor-jail.sh and launch-cursor.rish.`

---

## What Is True Now

**SLC-1 is done** on its functional promise. A person can open a terminal in this repository, type Rishi at a `rishi> ` prompt, run lines in-process, weave the session into Mantra with `:version`, and recall a prior line with `:recall <n>` or `!<n>`. The four verbs compose in one acceptance pass. Parity carries **120 witnesses** (116 `rye run` + four SLC-1). The central spine claim — state as a fold over an append-only log — is **shipped as a thing used**, not only argued.

The dev-loop scaffold is landed: `./tools/cursor-jail.sh` (POSIX flags today) and `tools/launch-cursor.rish` (editable `apprun` let). `squashfs-root/`, `.cursor-state/`, and `Cursor-*.AppImage` stay gitignored; the scripts are tracked.

---

## What Landed (metal-green)

| Piece | Witness / proof |
|-------|-----------------|
| Type + run | `tools/slc1_repl_step1.rish` |
| Version | `tools/slc1_version_step2.rish` (+ fixture shell for isolated `.mantra/`) |
| Recall | `tools/slc1_recall_step3.rish` |
| All four together | `tools/slc1_accept.rish` |
| Suite | `rishi/bin/rishi run tools/parity.rish` |

**Implementation home:** `rishi/src/main.rye` — `History`, `Transcript`, `runInputLine`, `recallByIndex`, `doVersion`, `runMantra` via `std.process.run`, `RISHI_MANTRA` override.

**Settled rulings carried in code:** transcript v1 = prompt + input + caught errors (stdout horizon); lazy `.mantra/` on first `:version`; stdin lines **duped into the arena** before the history lap stores them.

---

## What SLC-1 Claimed vs What Waits Beside It

SLC-1 closed on the **four-verb loop**, not on full TAME width hygiene:

- `width-check.rish` is still the **unrefined** substring gate (ruling #1 refinement not built).
- `mantra/*` Phase 1b width migration, `rishi/*` width pass, first `tame-check` lints, `.brix` dead-path mend — all named as the **TAME-hardening milestone** in `work-in-progress/TASKS.md` and `ROADMAP.md`.
- Do not mistake a finished loop for a finished width pass on every touched seed.

---

## The Bench (honest order)

1. **Rishi script arguments** — `runFile` reads only `args[2]` today; expose `args[3..]` to `.rish` scripts as an `args` list; witness a flag-reading script; then a parse helper. **First beneficiary:** `launch-cursor.rish` takes `--appimage`; `cursor-jail.sh` flag layer graduates out of POSIX shell.
2. **TAME hardening** — width-check refinement (ruling #1), then `mantra/*`, then `rishi/*`, then `tame-check`, then `.brix` mend. Travels with script arguments because both live in Rishi.
3. **SLC-2 (Pond GUI)** — after **Skate text rendering**; same four verbs in a window.
4. **Foundations visions** — filed (`foundations/`); stablecoin law and Mantrapod investor hardening **deferred** until Kaeden reopens them.
5. **SLC-L1 (Linengrow)** — scope note still open on the bench.

---

## Build and Gates (unchanged habits)

```sh
export HOME=/home/xy/veganreyklah2/.build-home
export ZIG_LOCAL_CACHE_DIR=/home/xy/veganreyklah2/.zig-cache
export TMPDIR=/home/xy/veganreyklah2/.zig-cache/tmp

rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
rye/bin/rye build mantra/src/main.rye -femit-bin=mantra/bin/mantra

rishi/bin/rishi run tools/parity.rish
rishi/bin/rishi run tools/parity-selftest.rish
# additive-gate.rish only when rye/lib/ changes in HEAD
```

Host `/home/xy` tmpfs is full — keep `HOME` and caches on project disk.

---

## Pitfalls the Last Passes Proved

1. **Rishi string literals do not unescape `\"`** — nested quotes in `run ["sh" "-c" "..."]` reach the shell with literal backslashes. Use a **fixture shell script** (Step 2 / acceptance pattern) or keep quoting out of `.rish` strings.
2. **REPL stdin buffer** — trimmed lines are slices into reused memory; **dupe into the arena** before `history.record`.
3. **Witness `split`** — surface is `split text sep`, not `split text by sep`.
4. **`say` writes stdout** — subprocess witnesses read markers from `result.out`.

---

## Open Ruling (surface, do not assume)

**Garden vs arena lexicon:** pristine std uses `init.arena`; agent rules and `context/TAME_GUIDANCE.md` now match. `garden` remains the warm local binding and Tally's future concept; a short `context/` lexicon note awaits Kaeden's ruling.

---

## Where to Read

| Doc | Role |
|-----|------|
| `active-designing/20260628-071012_slc-1-rishi-mantra-shell.md` | Parent scope (update status to done) |
| `work-in-progress/TASKS.md` | Granular bench |
| `work-in-progress/ROADMAP.md` | Order and horizons |
| `rishi/README.md` | REPL meta-commands |
| `SOURCE.md` Step 9 | Cursor in ai-jail |
| `expanding-prompts/20260629-030912_cursor-rishi-args-and-dev-loop.md` | Script-args aspiration |

---

## Start Signal for the Next Session

When Kaeden returns to build:

> The first lap is whole. Read `context/specs/20260629-031512_slc1-lap-closed-handoff.md` and `work-in-progress/TASKS.md`. Lead with **Rishi script arguments** unless directed otherwise. Do not reopen SLC-1 unless a witness regresses.

---

*May continuity hold across the reset. May the bench stay as honest as the lap that closed it. And may the next session find its home in the store already woven.*
