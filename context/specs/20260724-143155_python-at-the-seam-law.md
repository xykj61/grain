# Python at the seam

**Language:** EN  
**Stamp:** `20260724.143155`  
**Status:** Seated  
**Counsel:** [`../../counsel/20260724-135312_vanes-shelves-and-the-glow-ladder.md`](../../counsel/20260724-135312_vanes-shelves-and-the-glow-ladder.md)

Radiant pass `20260725.041039`

---

## Census law

| Path | Standing |
|------|----------|
| `classical-vedic-astrology/cast_a_chart.py` | **stays** -- external-interpreter seam (ephemeris); exempt by name |
| `tools/fixtures/living_docs_lint_scan.rish` | **migrated** `20260724.210602` -- body `living_docs_lint_scan.sh` via run seam |
| `tools/fixtures/dated_guard_scan.rish` | **migrated** `20260724.210602` -- body `dated_guard_scan.sh` via run seam |

Craft note: Rish `lines(read-file)` ceiling is 256 lines -- size and pattern duties lean on the `run` seam (`wc -c`, `grep -nE`) rather than in-pipeline line maps over large living docs. Historical `.py` paths remain readable in dated logs; living prose names the `.rish` homes.

## Ratchet

`living_docs_lint` prints an advisory count of `tools/**/*.py` each run. From `20260724.212805` the count is also a **blocking** ban in `tools/tame_style_scan_bans.rish` (scan body `tools/fixtures/tools_py_ban_scan.sh`). Named exempts: `tools/fixtures/tools_py_exempt.txt` (reason comment per entry). Negative: `tools/tame_style_tools_py_ban_selftest.rish` plants under `context/fixtures/tools_py_ban_tree/` and expects FAIL. Ephemeris seam `classical-vedic-astrology/cast_a_chart.py` stays outside `tools/` and needs no exempt entry.
