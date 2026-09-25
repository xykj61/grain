# Reading Glow for Machines

**Language:** EN
**Style:** Gauge (see `../../../context/GAUGE_STYLE.md`)
**Status:** Living, checkable -- rules follow [`glow/tokens.rye`](../../../glow/tokens.rye) and the rune parsers; the final section is counsel
**Voice:** Quin (workshop)
**Audience:** an LLM (or any parser author) asked to read, explain, or write Glow

---

This page shows how the Glow front end reads a desk. Follow the token rules first, then the desk dispatch, then the rune parser. The same steps help a model write Glow that the real front end accepts.

<a id="gm-bounds"></a>
## The Bounds Come First

Glow's lexer checks these bounds before a rune parser sees the desk:

| Bound | Value | Meaning for a machine |
|---|---|---|
| `max_tokens` | **128** | a desk is at most 128 tokens; the fifteen-field receipt desk fits inside this bound |
| `max_name_len` | 64 | idents, tags, faces |
| `max_src_len` | 64 KiB | hosted desk read ceiling |
| `max_cord_lit_bytes` | 1024 | interior of a `'cord'` literal |
| `max_hex_lit_digits` | 64, **even only** | digits after `@ux` |

The lexer returns `TooManyTokens` for overflow, `BadToken` for an unknown byte, and `EmptySource` for an empty desk. These are its three error names.

<a id="gm-kinds"></a>
## The Fifteen Token Kinds

`newline - ident - decimal - aura - cord_lit - hex_lit - rune2 - percent_tag - lparen - rparen - lbracket - rbracket - equals - tilde - double_equals`

A token has a kind and a byte span `(start, len)` into the source. Every read asserts `start + len <= src.len`. **Newlines are tokens.** Spaces, tabs, and `\r` are skipped. A `::` comment consumes its whole line, including the newline, and yields zero tokens.

<a id="gm-digraphs"></a>
## The Twenty-Seven Digraphs

The lexer checks this `match_rune2` table before bare `=` or `%`:

```
+$  $%  $:  ^-  =/  =.  =*  |-  |%  |=  |^  ++  --
/+  ?:  ?>  ?<  ?-  ?~  :-  :+  :^  :~  %-  %+  %^  %*
```

`++` opens an arm and `--` closes a core. Both are rune tokens. `==` closes a `$:` or `$%` body; it has its own kind, `double_equals`, checked before the rune table. A byte-twin witness compares this table with Rye's copy (STOA333).

<a id="gm-order"></a>
## The Lexing Order, Exactly

After skipping spaces, the lexer tries these forms in order:

1. Newline, then a `::` comment, then `==`.
2. A rune from the table above, then single punctuation: `( ) [ ] = ~`.
3. `%` plus a tag name, such as `%mint`; `@` plus an aura or hex value; `'` plus a cord literal.
4. A digit starts a decimal. A letter or `_` starts an ident, which may continue with letters, digits, `-`, and `_`.

An unmatched byte returns `BadToken`. The rune table takes `%-`, `%+`, `%^`, and `%*` before the tag rule sees `%`. A bare `%` needs a tag name.

`@t` is the cord aura. `@u<digits>` is a width aura; the tree uses `@u8`, `@u16`, `@u32`, and `@u64`. Shape fields admit a smaller set named in the rune reference. `@ux` plus an even count of up to 64 hex digits is a `hex_lit`. Bare `@ux` is an aura. `@u32x` returns `BadToken` because an ident touches the aura. Cord literals hold bytes on one line with no escapes; an empty `''` returns an error.

<a id="gm-dispatch"></a>
## How `glow_run` Decides What a Desk Is

Three token peeks classify a whole desk before rune parsing. A **cross-desk named-cast** has exactly two Glow lines: `/+ <stem>`, then `^- <mold>`. A **same-desk named-cast** has 4-12 lines, starts with `+$`, and ends with `^- <name>`. A **shape-only** desk has 3-18 lines, starts with `+$`, and ends with a line other than `^-`; named-cast has first claim. The 18-line limit lets a sixteen-field desk reach the parser's named refusal. A fifteen-field shape desk has 17 Glow lines. A Glow line contains at least one token besides newline. The other desks use head-rune dispatch: their first content token chooses the parser.

<a id="gm-parsers"></a>
## What Each Parser Accepts

The [Rune Reference](runes.md) gives each rune's shape and errors. A parser claims one exact front-end shape. `BodyGateNotYetLowered`, `AuraNotYetLowered`, and `NamedShapeNotYetLowered` name the edges of the current language. Faces and idents start with a letter or `_`, use `a-zA-Z0-9-_`, and fit in 64 bytes. `TrailingJunk` and `ExtraTail` refuse an extra word. The `bartis`, `barket`, `core`, and `shape` parsers walk tokens with asserted cursor bounds.

<a id="gm-comments"></a>
## Comments as Documentation Protocol

A `::` comment gives a reader context while the parser skips it. At a desk head, the first comment names the desk and the second names its lowering path and STOA seat. A `.rye` module head uses `//!` for its STOA ledger. Documented modules also carry a [`glow-book:`](ANCHORS.md) anchor. Read those comments first to learn the claim the code must keep.

<a id="gm-generation"></a>
## Guidance for Generation -- Counsel, Marked as Such

When you write Glow, stay inside 128 tokens and put two spaces after a rune, as in `|-  32`. Choose a seated demo gate: `double`, `inc`, `dec`, or `flip`. Choose a seated shape name from `amount...nona`, `kind`, `xact`, or `xfer`. The shape-field auras in `admitted_shape_auras` are `@u32`, `@t`, `@ux`, and `@u64`. Give the desk a `::` head comment naming its intent and lowering path. Keep one form per desk; composition crosses desks and `/+`. When a request reaches a frontier, name that error, such as `BodyGateNotYetLowered`, and offer a form the front end accepts.

---

*May every machine that reads this parse in one pass and speak only for the runes the ledger has seated.*
