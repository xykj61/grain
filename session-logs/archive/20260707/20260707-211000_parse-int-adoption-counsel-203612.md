# parse_int adoption — counsel 203612

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.211000

**Prompt:** `@files (33).zip` — apply parse_int adoption bundle.

## Thinking trace

Unzipped `20260707-203612_parse-int-adoption.zip` at repo root (symlinks preserved for `linengrow/parse_int.rye` and `mantra/parse_int.rye`). Filed counsel and apply-prompt.

First parity run failed at SLC-L2 device wire: `comlink/receipt_core.rye` symlinks to `linengrow/receipt_core.rye`, which now imports `parse_int.rye` relative to the build directory — added `comlink/parse_int.rye → ../tally/parse_int.rye` (same pattern as `tally_copy.rye`).

Witnesses GREEN: `tally_parse_int`, `tame_style_check` (parseInt ratchet **12**), `slcl2_receipt`, full parity **EXIT:0** (~149s).

## Files

| File | Why |
|------|-----|
| `tally/parse_int.rye` | TigerBeetle stdx port + selftest |
| `tools/tally_parse_int.rish` | New witness |
| `tools/parity.rish` | Stanza after no_padding |
| `tools/fixtures/tame_style_scan.sh` | parseInt ratchet + grep -c fix |
| `linengrow/receipt_core.rye`, `mantra/snapshot_export.rye` | 3 call sites migrated |
| `comlink/parse_int.rye` | Symlink gap fix for guest builds |
| `counsel/20260707-203612_…`, `expanding-prompts/20260707-203612_apply-parse-int.md` | Filed bundle |
| `context/TAME_GUIDANCE.md`, `counsel/README.md`, `TASKS.md` | Ratchet + season standing |

**Recommend:** **`go`** to commit and push — bundle applied and parity GREEN; include `comlink/parse_int.rye` symlink in the commit.
