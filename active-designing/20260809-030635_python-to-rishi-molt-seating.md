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
| `expanding-prompts/yonder/remember_pin_habit_count.py` | 61 | Counts pure REMEMBER-nib follow-up commits over a fixed `f291d96a74..HEAD` range (subprocess + regex) | **Shred candidate, not a clean port** — two of its four rules lean on `re.match` with `\s+`, which Rishi has no regex for; and it is a one-shot measurement of the very pin-habit the seated `remember-git-nib` rule now *prevents*. Its finding already lives in policy. *(Verdict revised `20260809.030748` after reading the source — see Order note.)* |
| `tools/fixtures/dated_classify.py` | 134 | Shared dated-vs-living classifier — one definition every roof calls | **Port, with care** — pure path + header logic, yet load-bearing; every consumer stays green through the port |
| `classical-vedic-astrology/cast_a_chart.py` | 65 | POSIX seam for `cast_a_chart.rish` via pyswisseph / Swiss Ephemeris (C library) | **Seam-gated** — Rishi has no path to the Swiss Ephemeris C library; this waits on a Rye/Zig binding, exactly as `usize` waits at the inherited-std seam |
| `tools/comlink_r1_dual_bind_probe.py` | 15 | Dual-stack loopback socket bind probe for the cut Comlink R1 | **Shred, not port** — Comlink R1 was cut; the probe is a fossil with no live caller. REDS 64. Rishi has no socket primitive, and none is wanted for a dead feature |
| `context/fixtures/tools_py_ban_tree/tools/planted.py` | 4 | The planted target the Python-ban negative selftest scans | **Keep as fixture** — the ban needs one real `.py` to prove it fires; molting it would blind the very check that drives this molt |

## The order of work

*Order revised `20260809.030748` after reading each source: the first candidate turned out to want a ruling, not a mechanical port.*

1. **Port `dated_classify.py`** first — pure path + header logic with no regex, genuinely living, called by many roofs. It is the strongest true showcase of a Rishi port. Trace every consumer (`git grep dated_classify`) and run each roof's witness after, so the shared classifier changes language without changing a single verdict. This is a focused round of its own, not a tail-of-session lap.
2. **Rule on `remember_pin_habit_count.py`** — reading it revealed a regex dependency Rishi has no primitive for, and a one-shot purpose whose finding the seated `remember-git-nib` rule already encodes. It is a **shred candidate**, not a clean port. A faithful port would need either a new Rishi match primitive or a verbose prefix/keyword rewrite that loses the `\s+` flexibility. Recommendation: shred it as a solved-problem fossil in `yonder/`, on a circled word — rather than port a counter for a habit that no longer happens.
3. **Shred `comlink_r1_dual_bind_probe.py`** — the honest close of REDS 64. A cut feature's probe wants removal, not a port; this waits for a circled shred word, since Rishi cannot host a socket bind and the feature it served is gone.
4. **Hold `cast_a_chart.py`** at the seam — record it as seam-gated until a Rye/Zig Swiss-Ephemeris binding exists, then port the caller and retire the Python seam in the same lap.
5. **Never touch `planted.py`** — it stays Python by design, named here so a future reader never mistakes it for an unfinished port.

Two of the five, then, are not ports: one shred candidate (`remember_pin_habit_count.py`) joins the two already named for shred or seam. The single clean, living port to take first is `dated_classify.py` — and if a Rishi **match / regex primitive** is ever wanted, that is its own SOON rune-or-builtin decision, named here so the gap is on the record.

## What landed (`20260809.031114` → progress)

- **`remember_pin_habit_count.py` — shredded** on the circled word. Gone from the tree, kept in git history; a solved-problem one-shot the `remember-git-nib` rule already retired.
- **`dated_classify.py` — ported.** The living mutant `tools/fixtures/dated_classify.rish` seats the interface in Rishi over a POSIX-sh regex seam (`dated_classify_seam.sh`) holding the two `rg` patterns Rishi has no native regex for — the same delegation the Python made to `re`, now without the Python runtime (`python3` is not even on this pier's PATH). Proven: the `census` output is **byte-identical** to the elder `.py`, and `classify` agrees on every tested path. Witness `tools/dated_classify_witness.rish` GREEN. A new Rishi `lower` builtin (case-insensitive compare) landed alongside, witnessed.
- **One consumer repointed** — `dated_pattern_scan.sh` now calls the Rishi mutant instead of `python3`. Its calls are proven correct; the scan's *full* green is gated by a pre-existing, unrelated `census_control_scan` red on this pier (that subsystem is itself mid-port to Rishi), not by this change.
- **`dated_classify.py` stays on disk** as fossil-pending. Two consumers still import it in-process via `runpy` — `shed_census_scan.sh` and `fascia_health_scan.sh` — and those are themselves Python-embedded shell scans, part of this same molt. De-Pythoning them (and the divergence roof) is the **next lap**; only when every consumer is off the `.py` does it become a Class H fossil. Touching `fascia_health` — a load-bearing health meter — wants its own careful round.

## What landed (`20260809.041500` → the dated subsystem is Python-free)

The whole dated-classification subsystem now runs without Python, and it had to, because `python3` is absent from this pier's PATH — the elder witnesses were silently red:

- **`census_control` fixed first.** Its `census_control_h1_seam.sh` embedded a `python3` heredoc counting H1 headings outside code fences; ported to `awk` (fence-state toggle, `^#\s` count). GREEN again, prove-red still fails.
- **`fascia_health_scan.sh` de-Pythoned.** Its `runpy` block became one call to a new seam `health` command reproducing the whole per-room report — controls, global tally, and every room with dated testimony sorted by live-percentage — **byte-identical** to the elder Python.
- **`shed_census_scan.sh` de-Pythoned.** Its `runpy` block became a seam `shed` command reproducing the orphan-floor census — the C1/C2 mention controls, the whole-tree basename mention scan, per-room orphan counts in `Counter.most_common` order, and the health-sketch formulas — **byte-identical**. A real bug surfaced and was fixed in the proving: the orphan set must apply the living-header rescue, exactly as `classify` does, or a `.bron` log that merely quotes "living ledger" is miscounted.
- **`dated_pattern_scan.sh` and `dated_roof_divergence_scan.sh`** repointed to the Rishi mutant; all three roofs now agree (`dated_testimony` identical by construction) and the divergence witness is GREEN.
- **Performance held.** A `header_files` helper collapses thousands of per-file `head | rg` spawns into one bulk `rg -l` narrowed by a handful of byte-bound confirmations, keeping the 8000-byte semantics exact while bringing the divergence roof back from a 2-minute timeout to ~36 seconds.

Every living consumer of `dated_classify` now speaks Rishi. The `.py` is kept only because dated equinox witnesses (e116/e117/e118) assert its existence — an accrete-never-break pin, not a live dependency.

## The molt frontier that remains

Roughly ten more `.sh` witnesses still embed `python3` heredocs — `claim_preserve_*`, `date_dialect_scan`, `living_docs_lint_scan`, `markdown_structure_scan`, `oldness_census_scan`, `radiant_h1_fence_scan`, and several dated `equinox_*` scans. Each is its own small port (awk or a Rishi seam), and each is already silently red on this pier. They are the continuing molt, to be taken as convenient laps — the dated `equinox_*` ones only where a recorded pass is warranted, since they are Tier-2 testimony.

## The Rishi language gap this port surfaced

Building the port proved that Rishi, today, cannot express a per-file census natively: `for-each` does not accumulate (proven in `rish_count_selftest.rish`), there are no user functions to share `classify` between commands, and there is no regex. The faithful shape is therefore Rishi-as-conductor over `git`/`rg`/`awk` seams — legitimate for a shell, and a real improvement (no Python), yet a marker that **loop accumulation, user functions, and a match primitive** are the SOON language features that would let a future classifier live natively in Rishi's own value model rather than in a seam.

## What the molt keeps

- **Prep, never cut.** This seating opens no shred. Each port lands with its own witness; each fossil joins `SHRED_PREP.md` only once its Rishi mutant is green, and the shred itself stays RED until circled.
- **Witness before claim.** A port is done when the Rishi script runs green on metal and every prior consumer still passes — not when the Python file is deleted.
- **The ban is the ratchet.** `tools/tame_style_check.rish` already flags authored `tools/*.py` (TOOLS_PY_BAN). As each port lands, that red clears itself; the seating simply makes the whole census legible at once rather than one lint failure at a time.
- **Seams are honest, not debt.** A file that wraps a C library Rishi cannot reach stays a named seam, the same way the inherited-std `usize` casts are correct Tiger code rather than a fork waiting to happen.

## Why seat it now

Rishi has grown enough to earn the scripts. Its value model, its `run` seam, its list and string builtins, and now its rune heads cover everything the portable Python here does. Naming the whole census in one place turns a scattered handful of lint reds into a short, ordered walk — and marks, plainly, which two files are not ports at all: one seam that waits on a binding, one fixture that must stay exactly as it is.
