# STOA333 — Digraph-table twin (rung 1)

**Language:** EN  
**Stamp:** `20260724.181200`  
**Waymark:** STOA333  
**Status:** Checkable — GREEN  
**Witness:** `rishi/bin/rishi run tools/glow_digraph_twin_witness.rish`  
**Room:** Checkable

---

## Claim

The twenty-seven-row Glow digraph table and Rye `match_rune2` agree byte-for-byte. A Glow desk seats the table as data (`rows=@t`); a fixture pins the order; each digraph tokenizes as `Kind.rune2`.

## SLC

- **Simple** — one desk · one fixture · extract cmp · tokenize check  
- **Lovable** — first rung of `glow.glow` ladder: sameness without self-hosting the lexer  
- **Complete** — Glow desk extract == fixture == Rye extract; 27× rune2 GREEN  

## Bounds

Glow holds the table as one `@t` cord (space-separated). Separate `@t` faces per digraph wait a capacity raise (`max_fields` / `max_face_lits` = 9). Glow does not reimplement `match_rune2` this lap — that is rung 2.

## Files

| Path | Role |
|------|------|
| `glow/gen/shape-digraph-table.glow` | shape |
| `glow/gen/sample-digraph-table.glow` | face=lit sample |
| `tools/fixtures/glow_digraph_table.txt` | pin (27 lines) |
| `glow/digraph_twin_check.rye` | tokenize face |
| `tools/glow_digraph_twin_witness.rish` | twin witness |

## Next

Rung 2 — one lowering arm in Glow — stays a season. SETU remains hand-seated; jam/cue outward held; vere/old waits siblings.
