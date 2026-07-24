# Python at the seam

**Language:** EN  
**Stamp:** `20260724.143155`  
**Status:** Seated  
**Counsel:** [`../../counsel/20260724-135312_vanes-shelves-and-the-glow-ladder.md`](../../counsel/20260724-135312_vanes-shelves-and-the-glow-ladder.md)

---

## Census law

| Path | Standing |
|------|----------|
| `classical-vedic-astrology/cast_a_chart.py` | **stays** — external-interpreter seam (ephemeris); exempt by name |
| `tools/fixtures/living_docs_lint_scan.py` | **migrates on touch** → `.rish` |
| `tools/fixtures/dated_guard_scan.py` | **migrates on touch** → `.rish` |

Craft note: Rish `lines(read-file)` ceiling is 256 lines — size and pattern duties lean on the `run` seam (`wc -c`, `grep -c`) rather than in-pipeline line maps over large living docs.

## Ratchet

`living_docs_lint` prints an advisory count of `tools/**/*.py` each run; target **two → zero** (ephemeris seam outside `tools/` and exempt).
