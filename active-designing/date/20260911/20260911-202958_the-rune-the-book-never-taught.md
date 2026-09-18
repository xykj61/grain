# The rune the book never taught

**Stamp:** `20260911.202958`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every count below is printed by an instrument named beside it, and the binding it argues for is rostered and GREEN
**Kin:** [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) - [`../foundations/20260826-021733_fire-the-row-that-sees.md`](../foundations/20260826-021733_fire-the-row-that-sees.md) - [`../foundations/20260830-011530_a-rune-is-earned-by-a-law.md`](../foundations/20260830-011530_a-rune-is-earned-by-a-law.md)
**Witness:** [`../tools/g/glow_rune_alphabet_witness.rish`](../tools/g/glow_rune_alphabet_witness.rish)

Glow's lexer accepts thirty two-byte rune heads. Its pronunciation roll names twenty-eight of them,
and a guard has held those two lists against each other since `20260909.155028`. Its reference page
-- the one whose own audience line reads *a careful beginner writing their first Glow, and any LLM
asked to help them* -- taught **twenty-seven**, and nothing in this tree had ever asked it that
question.

## The mechanism, first

[`tools/g/glow_rune_alphabet_worker.sh`](../tools/g/glow_rune_alphabet_worker.sh) derives the rune
population from `glow/tokens.rye`'s `match_rune2` table on every pass, and then asks each of four
documents about each head. Three of those bindings stood already: the closed pronunciation table,
the three G1 briefs, and the family index in `context/TAME_GUIDANCE.md`. The fourth is new -- a loop
over the same derived heads asking whether
[`active-designing/docs/glow/runes.md`](docs/glow/runes.md) writes the glyph backticked, which is
how every entry on that page spells its own digraph. It publishes `book_named`, `book_unnamed` and
`book_unnamed_glyphs`, and refuses any unnamed head that stands on no exemption.

## What the reading found

**`|+` barlus.** Named on `20260822`, seated as the twenty-eighth pronunciation row, parsed in
`glow/rune_shop_gate.rye`'s `parse_body`, lowered in `glow/lower_shop_gate.rye`, carrying laws
STOA332 through STOA336, and folded by seven gate sources under `src/gate/`. Measured
`20260911.202958`: **no page of the Glow Book named it** -- not the reference, not the primer, not
the inventory, not the machine-reading page or the value model. Twenty days.

The other two unnamed heads, `?&` and `?|`, are the ancestor's own spellings of `and` and `or`,
seated as peer names by alias-sameness on `20260830.010901`. They carry the same exemption the
pronunciation roll already grants them, and they carry it for the same cause rather than a second
one: every entry in the reference leads with its spoken name, so a glyph the closed table cannot
pronounce is a glyph the reference cannot head an entry with. One custody question holds both
pages, and one word of Keaton's answers both.

## Why three bindings could all pass while a rune stood outside them

Each of the three elder bindings holds the lexer against a **name**. That is one honest question,
asked three times of three documents, and a rune with a name answers all three. Whether a reader can
learn the rune is a different question, and no instrument was asking it -- so `|+` earned its name,
its laws and its desks, and remained untaught in the one place a newcomer looks.

This is `%532`'s shape one document over, with the sharper edge fire's row is drawn for: the three
enumerations that guard agreed perfectly, and the agreement lived in a person's memory. Here the
four documents did **not** agree, and the disagreement had also lived nowhere -- which is worse,
because a silent gap reads exactly like coverage from every side.

## What landed

- The fourth binding in the worker, gated by name rather than by count, so a thirty-first head that
  no page teaches reds on the lap it arrives.
- The **barlus** entry in the reference, written against `rune_shop_gate.rye:parse_body` read whole:
  two arities, four named refusals, the `max_prodto_bound = 12` wall, and the empty-fold identities.
- An inbound `glow-book: runes.md#g-barlus` thread on the module that parses it, so
  `glow_book_anchor_witness.rish` still reads both directions whole.
- Two more plants in
  [`tools/fixtures/g/glow_rune_alphabet_control.sh`](../tools/fixtures/g/glow_rune_alphabet_control.sh)
  -- a taught head struck from the reference, and the reference itself gone -- each refused and each
  lifted. **Pen 26 -> 32 legs, two whole-wall mutations bitten.**

## The control's own repair, which the lap forced

The pen is `git worktree add --detach HEAD`, and it copied exactly one file from the working tree:
the worker under test. So a lap repairing one of the **documents** the worker binds is proven
against HEAD's elder copy -- which is what happened the first time this control ran with the
widened worker, and eighteen checks failed for a fault the working tree had already fixed. Copying
only the worker made the pen half-current, which is worse than either whole. Every file the worker
reads is copied in beside it now.

## What this does not reach

**Whether an entry teaches well.** The binding asks whether the page writes the glyph, and stops
there. A backticked digraph in a sentence about something else would satisfy it, and only a reader
can tell that from an entry.

**The other pages of the Book.** The primer, the inventory and the machine-reading page name no rune
this binding checks. Whether they should is their own lap.

**Naming `?&` and `?|`.** A rune is earned by a law and a name by Keaton's word. The exemption holds
the two glyphs still and refuses a third; the day the word comes, the list empties and both gates
tighten to zero by deletion.
