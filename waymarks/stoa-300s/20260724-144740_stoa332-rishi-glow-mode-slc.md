# STOA332 — Rishi `glow` mode SLC stub

**Language:** EN  
**Stamp:** `20260724.144740`  
**Waymark:** STOA332  
**Status:** Checkable — GREEN  
**Witness:** `rishi/bin/rishi run tools/glow_repl_witness.rish`  
**Room:** Checkable

---

## Claim

`rishi glow` opens a Glow-speaking prompt. Each seated single-line rune head (sixteen digraphs) is written to a desk, lowered and run through `tools/glow_run_worker.sh`, and the result printed. `:quit` ends the session. Any other line receives a gentle named refusal; the session lives on.

## SLC

- **Simple** — tokenize (head gate) → lower → run → print; `:quit` clean  
- **Lovable** — warm one-line greeting; refusals named  
- **Complete** — stdin fixture: one accept per head family, one refusal, quit — GREEN  

## Bounds

`glow_max_line_bytes = 256` · `glow_max_session_lines = 64` · u32 widths · asserts at seams.

## Next

Rung-1 digraph-table twin — seated STOA333 (`20260724.181200`).
