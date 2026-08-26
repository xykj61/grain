# The Rune Says Its Own Name -- plain words for Glow's eight categories

**Language:** EN
**Version:** `20260826.170617`
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Design -- a naming proposal for Glow's rune surface. Every file and every line stays
exactly where it is; the cut discipline is at the tail and waits for Keaton's word.
**Silo:** our own modules and RISC-V only. The ancestry this replaces is studied, with attribution,
at [`../external-research/20260826-170617_the-syllable-that-taught-nothing.md`](../external-research/20260826-170617_the-syllable-that-taught-nothing.md).

---

## What this proposes, in one line

**Every Glow rune gets a plain warm name that says what it does, the glyph stays exactly as written,
and the name is what a person says out loud.**

Three things, kept apart on purpose:

- **The glyph** is the written form -- `|=`, `^-`, `?:`. Unchanged. Every line of Glow already
  written stays byte-identical.
- **The name** is the spoken and documented form -- what a module is called, what a heading says,
  what one engineer tells another across a desk.
- **The category** is the first glyph, which still groups its family. That compression is the reason
  the surface is learnable, and it survives this proposal whole.

## The eight categories

Glow curates a closed set of eight, seated in
[`date/20260716/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](date/20260716/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md).
Each takes the plainest word for what its family builds:

| Glyph | Proposed category name | What the family builds |
|---|---|---|
| `\|` | **shop** | the things that hold work -- Glow gates, traps, doors |
| `^` | **fit** | adjust a value's shape without breaking it |
| `=` | **bind** | name a value, change a leg, alias without copying |
| `?` | **ask** | branch, test, and refuse |
| `%` | **call** | invoke a Glow gate |
| `:` | **build** | assemble a pair, triple, quad, or list |
| `$` | **shape** | name a type (already this tree's seated word) |
| `~` | **aside** | inert hints -- acceleration names and tracing |

Read the column aloud: *shop, fit, bind, ask, call, build, shape, aside.* Eight one-syllable English
words a newcomer already owns, standing where eight syllables named punctuation. **Every one is a
word before it is a term**, which is the whole test.

`shape` is picked rather than coined -- it stands seated in `../context/LEXICON.md` for the bounded
normalising type, and `$` is the glyph that names one, so the category and the concept wear the same
word on purpose.

`shop` is the one that wants its plain function named on first use, which Gauge asks of any coined
term: **a shop is where work is held ready to run** -- a Glow gate waiting for its argument, a trap
waiting for its bound. It beat *core* (already spoken for by the microkernel work), *forge* (promises a
heat this has), and *house* (holds anything, so it says everything and therefore nothing).

## The rune names

The specialisation still lives in the second glyph, so a rune's full name is its category plus what
it does. The full curated set, with the two-syllable form the study measured beside it for one
release of overlap:

| Glyph | Proposed name | Does |
|---|---|---|
| `\|=` | **shop-gate** | a Glow gate with a named, typed argument |
| `\|-` | **shop-loop** | a bounded trap -- the bound is stated and checked |
| `\|^` | **shop-nest** | a shop whose argument nests under a stated shape |
| `\|%` | **shop-arms** | a shop with several named arms |
| `^-` | **fit-stated** | fit to a shape written at the site |
| `^+` | **fit-like** | fit to the shape of another value |
| `^=` | **fit-name** | bind a name to a value's shape |
| `=/` | **bind-let** | name a value, typed at the site |
| `=.` | **bind-leg** | change exactly one leg |
| `=*` | **bind-alias** | a second name, no copy |
| `?:` | **ask-if** | if, then, else |
| `?~` | **ask-null** | is it empty |
| `?-` | **ask-all** | exhaustive switch -- every case named |
| `?+` | **ask-else** | switch with a default |
| `?=` | **ask-shape** | does this match that shape |
| `?>` | **ask-holds** | assert true, refuse otherwise |
| `?<` | **ask-fails** | assert false, refuse otherwise |
| `%-` | **call-one** | call with one argument |
| `%+` | **call-two** | call with two |
| `%^` | **call-three** | call with three |
| `%*` | **call-named** | call with named arguments |
| `:-` | **build-pair** | two |
| `:+` | **build-triple** | three |
| `:^` | **build-quad** | four |
| `:~` | **build-list** | a list literal |
| `+$` | **shape-top** | a shape at the top level |
| `$:` | **shape-tuple** | a tuple shape |
| `$%` | **shape-tagged** | a tagged union |
| `~%` | **aside-fast** | name an accelerated path |
| `~/` | **aside-trace** | name it, and trace it |

Thirty names, each readable on sight. `ask-all` says exhaustive where a syllable stayed silent;
`shop-loop` says bounded loop where a syllable said "pipe hyphen."

## What the tree already did without being told

The proposal is mostly a ratification. Measured `20260826.170617` over `glow/`: of thirty-two
`lower_*.rye` modules, **thirty already carry a plain functional name** -- `lower_cast.rye`,
`lower_conditional.rye`, `lower_switch.rye`, `lower_trap.rye`, `lower_call2.rye`. Exactly **two**
reached for a syllable: `lower_barket.rye` and `lower_bartis.rye`.

So this document ratifies a convention rather than proposing one. It names what the tree has been
following in thirty places out of thirty-two, and closes the two that drifted.

## How it lowers, and why the lens matters

This proposal stops at the surface, and that is the point worth stating rather than assuming. A
rune's name is a **surface** fact; its lowering is a **bounded** fact, and the two stay independent
by construction:

- The lowering path is unchanged. `|=` still lowers through the same module, still asserts its
  bounds at the expansion site, still reaches the same RISC-V.
- **A name change that reached the lowering would be a bug in this proposal**, and the witness that
  proves it already stands: leave the emitted code alone, and every `glow/` witness reads exactly
  what it read before. That is the acceptance test -- byte-identical output across the rename -- and
  it is cheap, which is why it is the one to run.

The toroidal Caravan and Tally seams are the **lens** this was thought through rather than a surface
it touches: a supervision spine and a bounded allocator both earned their clarity by naming what a
thing does at the site where it does it, and a rune surface that says `bartis` is the same tree
disagreeing with itself in a different room. **Every Caravan, Tally, and Scribe file stays as it
stands**, which is a lane boundary held on purpose.

## The cost, honestly

**Two module renames**, each with inbound references that must be repointed in the same round --
references are promises. `glow/lower_bartis.rye` -> `glow/lower_shop_gate.rye` and
`glow/lower_barket.rye` -> `glow/lower_shop_nest.rye`, each with its witness beside it.

**Two Lexicon rows**: the *Rune alphabet* row and the *Barket* row, which are living rows and may
sweep.

**Dated testimony keeps every syllable it ever wrote.** Accrete-never-break holds by tier; nothing
dated is rewritten to retrofit this, and a stale reference is resolved rather than edited.

**A rename is measured before it lands, or it is a rename that broke something.** Before any cut:
grep the tree for each name, count the inbound references, repoint every one, and run the `glow/`
witnesses to prove the emitted code is byte-identical.

## What waits for a word

The renames above are **prepped, awaiting a cut**. The fossil rows are booked in
`../construction/SHRED_PREP.md`, and every file in `glow/` stands untouched. Seating the names into
`../context/LEXICON.md` and the two module renames are one lap each, and both wait for Keaton.
