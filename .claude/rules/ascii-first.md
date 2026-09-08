# ASCII-First -- plain ASCII for documents and commits

**Seated:** `20260816.214652` on Keaton's word - **Status:** Living - **Kin:** [`reds-first`](reds-first.md) - [`standfast`](../../foundations/20260816-214652_standfast-the-stopped-line.md) - REDS %83

Write every new document, code comment, and commit message in **plain 7-bit ASCII**. A non-ASCII character no reader needs is a corruption waiting to compound -- the operator card (then named `REMEMBER.md`) silently triple-encoded itself into 2,797 runs of unreadable mojibake bytes (the classic capital-A-tilde garble) before anyone caught it (REDS %83), because a tool read the UTF-8 file as Latin-1 and rewrote it. ASCII-first is how that never happens again.

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

**Four guards stand over four subjects, and the fourth is one the opening sentence above never
named.** All four are rostered in `construction/standing-equipment.kyri`. Each current reading
below carries the guard that holds it still -- the fifth thing `context/GAUGE_STYLE.md` asks a
figure to name -- and each dated figure is testimony from the lap that measured it, free to move
since. Run the scan rather than trusting either; every one is named here so you know where.

**The living card** (REDS %83): `tools/l/living_card_ascii_witness.rish` over `tools/fixtures/l/living_card_ascii_scan.sh` greps the operator card and the REDS ledger for bytes above 0x7F and fails hard if any appear (the ENFORCE roster), while the pins still holding legacy dated non-ASCII are reported as an advisory ratchet to sweep down on touch rather than force-rewritten. A planted mojibake control proves the RED path on metal.

**Documents** -- the subject this rule names FIRST, and the last to earn a meter over its whole
subject (seated `20260906.133344`): `tools/a/ascii_document_witness.rish` over
`tools/fixtures/a/ascii_document_scan.sh`. It gates `.claude/rules/*.md` and `.cursor/rules/*.mdc`
at zero -- **104 pages, 0 characters** -- and holds every other living tracked `.md` and `.mdc`
under a ceiling that only falls: **3,331 of 3,331** across 72 of 334 pages, read `20260908.052550`.
Dated basenames, the `date/`, `archive/` and `yonder/` shelves, `gratitude/`, `vendor/`, `seed/`,
and every `fixtures/` path are read past, each for its own named reason -- the planted mojibake
control above MUST keep its high bytes, or its own `prove-red` leg proves nothing.
`tools/fixtures/a/ascii_document_convert.sh` makes the substitutions the table above spells and
proves a sweep moved nothing else by **re-deriving each page from its committed bytes**.

**The wall is drawn around the room that writes the law, and the law is a graph.** That ENFORCE
roster is two directory globs, so a page an enforced rule names as its own canon stands outside it.
Measured `20260908.052550`: of the 13 living `context/` pages the rule rooms cite, four were dirty --
`RADIANT_STYLE.md` 80, `TWILIGHT_STYLE.md` 61, `TAME_CORE.md` 51, `REMOTE_ROSTER.md` 18 -- and
`CLAUDE.md`, the root file that loads every one of those rules, held 38. `tame-guidance.md` was
walled at zero while the page it tells a reader to **read first** carried 51. All five stand at zero
from this stamp: the mechanical part proven by re-derivation, and the fifteen check and cross marks
in `RADIANT_STYLE.md` read one at a time into the tree's own **Prefer** and **Rather than** words.
What stays open is the roster itself -- widening ENFORCE from two globs to the canon those globs
NAME changes what a gate refuses, so it is named here rather than taken.

**Code comments**, in every comment syntax this tree authors: `tools/as/ascii_comment_witness.rish` holds three meters under ceilings that only fall -- `tools/fixtures/r/rye_comment_ascii_scan.sh` for `//`, `///`, and `//!` in Rye, `tools/fixtures/s/shell_comment_ascii_scan.sh` for `#` in Rishi and shell, and `tools/fixtures/g/glow_comment_ascii_scan.sh` for `::` in Glow. Each refuses to count **program content**, which is the distinction that makes a sweep safe: a Rye `\\` multiline string and a shell heredoc body are what a program prints or feeds onward, so converting them would change behavior rather than register. Glow needs no such exclusion, and the reason is the language's own: `glow/tokens.rye:239` refuses a newline inside a cord literal, so no Glow literal reaches a second line to open one with `::`. All three are proven on planted repositories, and every ceiling is proven from both sides -- one character past it refuses, and removing the plant returns the reading to green -- since a refusal proven only in the passing direction cannot be told from a bypass.

The reach was won by measuring, twice. The comment meter read `*.rye` alone for its first day, so 2,243 tracked Rishi sources and 580 shell sources stood outside a law that governs them, carrying **10,468** non-ASCII characters (measured `20260825.084500`). A sweep of the six forms this rule's own table names -- em dash, en dash, middle dot, two arrows, ellipsis -- converted 2,163 files and brought that to **505**, all of it notation the table leaves to a reader's judgment. Then two comment marks read as full coverage for a fortnight while **Glow**, an authored language of this tree's own, stood outside the law entirely: **942** non-ASCII characters across **342** of its 451 tracked sources, measured `20260907.141019`, and **all 942 inside a `::` comment with none in program content**. Of those, 921 are forms the table above names outright and 21 are the one form it leaves to judgment. **The sweep landed the same day** (`20260907.161048`): 342 files rewritten, **942 to zero**, every changed line a `::` comment and no program content moved -- so Glow's ceiling is a **wall**, and the next non-ASCII character to enter one of its comments reds on the lap it arrives. The 21 were read one at a time rather than guessed at, and both readings took an option this rule already names: thirteen sentences with a subject took the word **is**, eight parentheticals without one took **`==`**. **A finished sweep is also what taught the control its own fault** -- a pen planting three characters to give the counting readings a subject was the same pen asked whether it sat under the tree's ceiling, and at zero those two jobs part: three planted characters over a ceiling of nothing read as a failure for a tree that was clean. The ceiling legs run on a cleared pen now, and the two sibling meters will meet the same wall on the lap that finishes them. Measurement beats memory: a guard catches the next one on the lap it enters, rather than months later -- and a guard that names its languages by counting them catches the language nobody thought to name.

**What a guard says out loud** -- the fourth subject, and the one the opening sentence does not
name (seated `20260907.075500`): `tools/s/spoken_ascii_witness.rish` over
`tools/fixtures/r/rish_spoken_ascii_scan.sh`. Both comment meters decline program content because
converting a string changes what a program prints. A `say` line is what a program says **to a
person**, on their terminal and into `session-output/`, so converting one changes register, which is
exactly what this rule governs. **11,151 characters across 1,515 of 2,416 Rishi sources** stand
under a ceiling of 11,154, read `20260908.052550` -- very nearly the 10,468 the comment surface
itself carried the day its own meter was built, in the same files, under the same law, one sweep of
attention less.

## Why the rule exists

Plain ASCII survives every tool, terminal, diff, and re-encoding intact. Keaton asked that documents and commits prioritize it after the operator card corrupted itself in the dark. Canonical Cursor twin: `.cursor/rules/ascii-first.mdc`.
