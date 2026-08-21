**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

# Ed25519 ratchet scan precision — publicKeyFromEd25519 exclusion

**Stamp:** 20260708.030200

## Thinking trace

Kaeden verified Cursor's correction independently and owned the prior error: he'd folded `rye/tests` into a manual check though only `rye/src` is in the scan roster; the real four were `publicKeyFromEd25519` (capital **F**) in `comlink/wire_format.rye` and `aurora/src/posted.rye`, two apiece — excluded from lowercase `fromEd25519` filter only.

Kaeden directed: take the hygiene now (not on-touch) — two-line exclusion fix in the lint tool, fix TASKS label to "X25519 conversion seams."

Applied:
- `tools/tame_style_scan_advise.rish` — third `where` excludes lines containing `FromEd25519`
- `tools/fixtures/tame_style_scan.sh` — legacy advise uses `grep -vi fromed25519` (case-insensitive)
- `tools/tame_style_scan_advise_selftest.rish` — pinned **0**
- `context/TAME_GUIDANCE.md`, `work-in-progress/TASKS.md` — ratchet **0**, accurate labels

Verified: native + legacy advise agree at **0**; `tame_style_check.rish` GREEN.

## Observations

- Kumara extraction arc now has an honest **0** application ratchet — identity routes through `tally/kumara.rye` everywhere in the scan roster.
- Two independent checks (Kaeden + Cursor) caught a label/evidence mismatch before it calcified — healthy pattern.

## Files

- `tools/tame_style_scan_advise.rish` — `FromEd25519` exclusion
- `tools/fixtures/tame_style_scan.sh` — case-insensitive legacy exclusion
- `tools/tame_style_scan_advise_selftest.rish` — ratchet **0**
- `context/TAME_GUIDANCE.md` — Kumara ratchet closed
- `work-in-progress/TASKS.md` — arc closed, X25519 seam wording

**Recommend:** keep going is done for Kumara — check in with Kaeden before **SLC-L3** when he chooses to open settlement.
