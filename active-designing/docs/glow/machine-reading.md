# Reading Glow for Machines

**Language:** EN
**Style:** Gauge (see `../../../context/GAUGE_STYLE.md`)
**Status:** Checkable, with one marked exception -- every rule below is drawn from [`glow/tokens.rye`](../../../glow/tokens.rye) read whole (STOA83-97 - 176 - 180 - 183 - 216-217) and from the per-rune parsers; the closing *guidance for generation* section is counsel, and says so
**Voice:** Quin (workshop)
**Audience:** an LLM (or any parser author) asked to read, explain, or write Glow

---

This page is the machine's door into Glow. A model that internalizes it can tokenize any desk in one pass, predict every refusal, and -- most importantly -- generate Glow that the real front end accepts, because everything here is the real front end, restated.

<a id="gm-bounds"></a>
## The Bounds Come First

Glow's lexer is bounded before it is anything else, and the bounds shape how you should think about the language:

| Bound | Value | Meaning for a machine |
|---|---|---|
| `max_tokens` | **64** | a desk is at most sixty-four tokens -- *desks are tiny by law*; never plan a long file |
| `max_name_len` | 64 | idents, tags, faces |
| `max_src_len` | 64 KiB | hosted desk read ceiling |
| `max_cord_lit_bytes` | 1024 | interior of a `'cord'` literal |
| `max_hex_lit_digits` | 64, **even only** | digits after `@ux` |

Overflow refuses as `TooManyTokens`; anything unclassifiable is `BadToken`; an empty source is `EmptySource`. Those three are the lexer's entire error surface.

<a id="gm-kinds"></a>
## The Fifteen Token Kinds

`newline - ident - decimal - aura - cord_lit - hex_lit - rune2 - percent_tag - lparen - rparen - lbracket - rbracket - equals - tilde - double_equals`

A token is a kind plus a byte span `(start, len)` into the source, with the invariant `start + len <= src.len` asserted at every read. **Newlines are significant tokens**; spaces, tabs, and `\r` are skipped; a `::` comment consumes its entire line *including* the newline, so comments and comment-lines produce no tokens at all.

<a id="gm-digraphs"></a>
## The Twenty-Seven Digraphs

The rune table, verbatim from `match_rune2`, longest-match tried before bare `=` or `%`:

```
+$  $%  $:  ^-  =/  =.  =*  |-  |%  |=  |^  ++  --
/+  ?:  ?>  ?<  ?-  ?~  :-  :+  :^  :~  %-  %+  %^  %*
```

Note that `++` (an arm) and `--` (a core close) are rune tokens, and `==` is its own kind (`double_equals`, closing `$:`/`$%` bodies) matched *before* the rune table. This table has a byte-twin witness against Rye's own copy (STOA333), so it cannot silently drift.

<a id="gm-order"></a>
## The Lexing Order, Exactly

At each position after space-skip, the lexer tries, in order: **newline** -> **`::` comment** (skip line) -> **`==`** -> **rune2** (the table above) -> **single punctuation** `( ) [ ] = ~` -> **`%`** opens a `percent_tag` (a cold atom like `%mint`; the call runes `%-`/`%+`/`%^`/`%*` were already taken by the rune table, and a bare `%` with nothing nameable after it refuses) -> **`@`** opens an aura or hex literal -> **`'`** opens a cord literal -> **digit** opens a decimal -> **ident start** (`a-z A-Z _`, continuing with `- _ 0-9`) opens an ident -> otherwise `BadToken`.

Aura rules deserve their own breath: `@t` is the cord aura; `@u<digits>` is a width aura (`@u8` `@u16` `@u32` `@u64` seen in the tree; the *shape-field* admitted set is narrower -- see below); `@ux` followed by hex digits becomes a **hex_lit** whose digit count must be even and at most 64, while a bare `@ux` stays an aura; and an ident character glued onto the end of any aura refuses -- `@u32x` is `BadToken`, never two tokens. Cord literals take no escapes and no newlines; `''` (empty) refuses.

<a id="gm-dispatch"></a>
## How `glow_run` Decides What a Desk Is

Before any rune parser runs, three token-level *peeks* classify the whole desk, and their shapes are exact: **cross-desk named-cast** -- exactly two Glow lines, `/+ <stem>` then `^- <mold>`; **same-desk named-cast** -- 4-12 lines, head `+$`, last line `^- <name>` with nothing after it (the 12 is `field_count + 3` under the nine-field freeze); **shape-only** -- 3-11 lines, head `+$`, last line *not* `^-` (named-cast wins first). A "Glow line" here is counted from tokens: any run containing at least one non-newline token. Everything else falls through to the head-rune dispatch -- the first content token's digraph chooses the parser.

<a id="gm-parsers"></a>
## What Each Parser Accepts

The per-rune shapes and their complete refusal sets live in the [Rune Reference](runes.md); machine-relevant regularities across all of them: every parser is a **front half** that claims one exact shape and names its frontier as an error (`BodyGateNotYetLowered`, `AuraNotYetLowered`, `NamedShapeNotYetLowered` -- these are honest *not-yet* words, not bugs); face/ident rules repeat everywhere (never digit-led, <=64, alphabet `a-zA-Z0-9-_`); `TrailingJunk`/`ExtraTail` refuse extra words, because arity is meaning; and the multi-body parsers (`bartis`, `barket`, `core`, `shape`) walk the token stream directly with asserted cursor invariants.

<a id="gm-comments"></a>
## Comments as Documentation Protocol

A `::` comment is invisible to the parser and load-bearing to the reader. Two shapes matter to machines: the desk-head convention (first comment line states what the desk *is*, second states which lower serves it and its STOA seat) and the module-head convention in `.rye` (an `//!` block that is itself a STOA ledger, plus the [`glow-book:`](ANCHORS.md) anchor thread when documented). When you read a desk, read its comments first -- they name the claim the code then keeps.

<a id="gm-generation"></a>
## Guidance for Generation -- Counsel, Marked as Such

When asked to *write* Glow today: stay inside sixty-four tokens; use two spaces after a rune (`|-  32`, the house gap); pick from the **closed sets** rather than inventing -- demo gates `double - inc - dec - flip`, shape names on the `amount...nona` allowlist plus `kind - xact - xfer`, shape-field auras from `admitted_shape_auras` (`@u32 - @t - @ux - @u64`); give every desk its `::` head comment naming intent and lower; keep one form per desk (this front end parses desks, not programs -- composition happens across desks and through `/+`); and when the user's wish exceeds a closed set, say so in the language's own honest words -- *that gate is `BodyGateNotYetLowered`* -- and offer the nearest desk that is real. A model that fakes past a frontier teaches its user to distrust GREEN, which is the one sin this tree has no room for.

---

*May every machine that reads this parse in one pass, refuse where the language refuses, and never claim a rune the ledger has not seated.*
