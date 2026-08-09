# Python → Rishi — the molt seating

**Language:** EN
**Status:** Living — molt seated `20260809.030635` on Keaton's word · **prep only, no cut**
**Voice:** Riyo
**Rules:** [`../.claude/rules/molt.md`](../.claude/rules/molt.md) · [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) · ledger [`../work-in-progress/SHRED_PREP.md`](../work-in-progress/SHRED_PREP.md) · red [`../work-in-progress/REDS.md`](../work-in-progress/REDS.md) (row 64)

---

## What this seats

Every authored Python script in this tree molts to **Rishi** — Grain's own self-hosted shell, which now speaks four Glow rune heads and a full value model. Rishi is the tree's first language for scripts; Python entered only as a seam to libraries Rishi could not yet reach, and as fixtures the tooling deliberately tests against. This document is the **molt seating**: it walks the census, classifies each file by how it should leave Python, and opens no cut. Each port lands on its own lap with a witness on metal; each fossil then joins the shred-prep list under the accrete-never-break discipline.

The census excludes third-party source under `vendor/`, `gratitude/`, and `old/`, which stay unmodified by policy.

## The census, classified

| Path | Lines | What it does | Verdict |
|---|---:|---|---|
| `expanding-prompts/yonder/remember_pin_habit_count.py` | 61 | Counts pure REMEMBER-nib follow-up commits over a git range (subprocess + regex) | **Port** — pure git + line logic; Rishi's `run`, `lines`, `split`, and comparison operators carry it |
| `tools/fixtures/dated_classify.py` | 134 | Shared dated-vs-living classifier — one definition every roof calls | **Port, with care** — pure path + header logic, yet load-bearing; every consumer stays green through the port |
| `classical-vedic-astrology/cast_a_chart.py` | 65 | POSIX seam for `cast_a_chart.rish` via pyswisseph / Swiss Ephemeris (C library) | **Seam-gated** — Rishi has no path to the Swiss Ephemeris C library; this waits on a Rye/Zig binding, exactly as `usize` waits at the inherited-std seam |
| `tools/comlink_r1_dual_bind_probe.py` | 15 | Dual-stack loopback socket bind probe for the cut Comlink R1 | **Shred, not port** — Comlink R1 was cut; the probe is a fossil with no live caller. REDS 64. Rishi has no socket primitive, and none is wanted for a dead feature |
| `context/fixtures/tools_py_ban_tree/tools/planted.py` | 4 | The planted target the Python-ban negative selftest scans | **Keep as fixture** — the ban needs one real `.py` to prove it fires; molting it would blind the very check that drives this molt |

## The order of work

1. **Port `remember_pin_habit_count.py`** first — small, self-contained, and its git-log-and-count shape is the cleanest showcase of a Rishi port.
2. **Port `dated_classify.py`** next, tracing every consumer (`git grep dated_classify`) and running each roof's witness after, so the shared classifier changes language without changing a single verdict.
3. **Shred `comlink_r1_dual_bind_probe.py`** — the honest close of REDS 64. A cut feature's probe wants removal, not a port; this waits for a circled shred word, since Rishi cannot host a socket bind and the feature it served is gone.
4. **Hold `cast_a_chart.py`** at the seam — record it as seam-gated until a Rye/Zig Swiss-Ephemeris binding exists, then port the caller and retire the Python seam in the same lap.
5. **Never touch `planted.py`** — it stays Python by design, named here so a future reader never mistakes it for an unfinished port.

## What the molt keeps

- **Prep, never cut.** This seating opens no shred. Each port lands with its own witness; each fossil joins `SHRED_PREP.md` only once its Rishi mutant is green, and the shred itself stays RED until circled.
- **Witness before claim.** A port is done when the Rishi script runs green on metal and every prior consumer still passes — not when the Python file is deleted.
- **The ban is the ratchet.** `tools/tame_style_check.rish` already flags authored `tools/*.py` (TOOLS_PY_BAN). As each port lands, that red clears itself; the seating simply makes the whole census legible at once rather than one lint failure at a time.
- **Seams are honest, not debt.** A file that wraps a C library Rishi cannot reach stays a named seam, the same way the inherited-std `usize` casts are correct Tiger code rather than a fork waiting to happen.

## Why seat it now

Rishi has grown enough to earn the scripts. Its value model, its `run` seam, its list and string builtins, and now its rune heads cover everything the portable Python here does. Naming the whole census in one place turns a scattered handful of lint reds into a short, ordered walk — and marks, plainly, which two files are not ports at all: one seam that waits on a binding, one fixture that must stay exactly as it is.
