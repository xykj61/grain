# `.sh` migration — tame_style_scan bans half

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.214500

**Prompt:** `kg` — `.sh` migration first target per counsel `214012`.

## Thinking trace

Ported TAME **bans half** to `tools/tame_style_scan_bans.rish` — nine fixed-string patterns via `where` + `read-file` + `contains`; compound assert still uses one grep seam; find for roster enumeration. Added fixture + `tame_style_scan_bans_selftest.rish`. Wired `tame_style_check.rish` and `tame_style_scan.sh bans` (legacy grep kept as `bans-legacy`). Parity gains selftest stanza.

Witnesses GREEN: `tame_style_scan_bans_selftest`, `tame_style_scan_bans`, `tame_style_check`.

## Files

| File | Why |
|------|-----|
| `tools/tame_style_scan_bans.rish` | Native bans scanner |
| `tools/tame_style_scan_bans_selftest.rish` | Idiom proof |
| `tools/fixtures/tame_style_ban_violation.rye` | Intentional violation fixture |
| `tools/tame_style_check.rish` | Calls native bans |
| `tools/fixtures/tame_style_scan.sh` | `bans` delegates; `bans-legacy` retained |
| `tools/parity.rish` | Selftest stanza |

**Recommend:** **`go`** to ship — or **`kg`** for advise-half proof-of-accumulation before porting ratchet counts.
