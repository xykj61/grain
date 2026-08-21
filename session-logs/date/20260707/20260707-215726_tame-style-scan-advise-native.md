# tame_style_scan advise half — native Rishi

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.215726

## Prompt

`kg` — close out the advise half of `.sh` → `.rish` migration for `tame_style_scan` (continuation from prior session).

## Thinking trace

The prior lap left `tools/tame_style_scan_advise.rish` running GREEN with ratchet lines matching legacy shell. This pass wired it into the witness chain:

1. **`tame_style_check.rish`** — advise half now calls native `tame_style_scan_advise.rish` instead of `tame_style_scan.sh advise`.
2. **`tools/fixtures/tame_style_scan.sh`** — `advise` delegates to Rishi; prior shell body renamed `advise-legacy` for parity selftest.
3. **`tame_style_scan_advise_selftest.rish`** — asserts native and legacy agree on key ratchet lines on the clean tree.
4. **`rish_count_selftest.rish`** — documents the map+join+sh sum idiom (`for-each` cannot accumulate).
5. **`parity.rish`** — two new stanzas before the existing bans selftest.
6. **Docs** — `TASKS.md` and `context/TAME_GUIDANCE.md` mark advise half complete; count idiom noted.
7. **Hygiene** — removed probe fixtures (`rish_accumulate_probe`, `rish_map_sum_probe`, `rish_where_not_probe`).

Individual witnesses GREEN: `rish_count_selftest`, `tame_style_scan_advise_selftest`, `tame_style_check`. Full `parity.rish` stops early at SLC-1 Step 2 (`mantra build failed`) — pre-existing environmental gap, unrelated to TAME migration.

## Observations

- The `>70`-line ledger remains a deliberate shell seam (`tame_style_long_fn.sh`) because `$f` inside `.rish` run strings breaks the parser.
- All ratchets print zero on the clean tree; `@memcpy` canonical count in `tally/copy.rye` still reported as intentional.
- `tools/bin/` remains untracked — do not commit.

## Files

| File | Why |
|------|-----|
| `tools/tame_style_scan_advise.rish` | Native advise (prior session; wired this lap) |
| `tools/tame_style_scan_advise_selftest.rish` | Native vs legacy ratchet parity |
| `tools/rish_count_selftest.rish` | Accumulation idiom proof |
| `tools/fixtures/tame_style_long_fn.sh` | Shell seam for long-fn ledger |
| `tools/fixtures/tame_style_scan.sh` | `advise` → Rishi; `advise-legacy` retained |
| `tools/tame_style_check.rish` | Wired native advise |
| `tools/parity.rish` | New selftest stanzas |
| `work-in-progress/TASKS.md` | Advise half checked off |
| `context/TAME_GUIDANCE.md` | Native advise + count idiom |
| `tools/fixtures/rish_*_probe.rish` | Deleted — superseded by `rish_count_selftest` |

**Recommend:** keep going — say **`go`** to commit and push this lap; next bench per counsel `214012` is Kaeden's snapshot lap 4 or astrology source material, not more `tame_style_scan` work.
