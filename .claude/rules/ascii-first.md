# ASCII-First -- plain ASCII for documents and commits

**Seated:** `20260816.214652` on Keaton's word - **Status:** Living - **Kin:** [`reds-first`](reds-first.md) - [`standfast`](../foundations/20260816-214652_standfast-the-stopped-line.md) - REDS #83

Write every new document, code comment, and commit message in **plain 7-bit ASCII**. A non-ASCII character no reader needs is a corruption waiting to compound -- REMEMBER.md silently triple-encoded itself into 2,797 runs of unreadable mojibake bytes (the classic capital-A-tilde garble) before anyone caught it (REDS #83), because a tool read the UTF-8 file as Latin-1 and rewrote it. ASCII-first is how that never happens again.

## The substitutions

| Instead of | Write |
|---|---|
| em-dash, en-dash | `--`, `-` |
| middle dot separator | `-` or `,` or `;` |
| curly quotes | straight `'` and `"` |
| arrows | `->`, `<-`, `<->` |
| ellipsis | `...` |
| `<=` `>=` `!=` | `<=` `>=` `!=` (ASCII already) |
| Greek / subscripts in prose | spelled: `gamma_2`, `sigma`, `alpha` |

## The exception

A specific, **explicitly-named set of work rounds** may use non-ASCII when it is the point of the work -- a Unicode-handling module's own test fixtures, an internationalization surface, a font codec's glyph tables. Name the exception in the round; do not let it leak into the operator card, commit subjects, or general prose.

## What this does not change

- **Dated artifacts are never rewritten** to retrofit this -- the one-clock law and accrete-never-break protect every dated log and testimony. This governs prose written from here forward, and repairs a *corruption* (mojibake) wherever found as a red, which is a fix, not a style rewrite.
- **Code strings and identifiers** already ASCII stay ASCII; this simply names the habit.
- **Math-heavy design notes** may spell Greek and operators in ASCII (`gamma_2`, `-> `) rather than reaching for Unicode -- clearer in a terminal and diff, and safe from re-encoding.

## Prevention, not just cure

A living-card non-ASCII witness stands (REDS #83): `tools/living_card_ascii_witness.rish` over `tools/fixtures/living_card_ascii_scan.sh` greps the operator card and the REDS ledger for bytes above 0x7F and fails hard if any appear (the ENFORCE roster), while the pins still holding legacy dated non-ASCII are reported as an advisory ratchet to sweep down on touch rather than force-rewritten. A planted mojibake control proves the RED path on metal. Measurement beats memory -- the guard catches the next mojibake on the lap it enters, not months later.

## Why the rule exists

Plain ASCII survives every tool, terminal, diff, and re-encoding intact. Keaton asked that documents and commits prioritize it after the operator card corrupted itself in the dark. Canonical Cursor twin: `.cursor/rules/ascii-first.mdc`.
