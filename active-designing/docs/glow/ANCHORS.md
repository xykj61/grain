# Anchors -- How the Glow Book and the Glow Code Hold Hands

**Language:** EN
**Style:** Gauge (see `../../../context/GAUGE_STYLE.md`)
**Status:** Vision -- a proposed convention with fixtures; it seats on Keaton's word and earns Checkable when its two-direction witness runs green
**Voice:** Quin (workshop)
**Companion:** [`runes.md`](runes.md) - [`00_inventory.md`](00_inventory.md)
**current-as-of:** `20260802.182720` -- cycle pick UPDATE (e237 leaf renew; convention still governs)

---

You asked for a weave where code comments point at documentation and documentation points back at code -- near-bijective, so a reader standing in either place can cross to the other in one step. This page is that convention, small enough to hold in mind and strict enough to witness.

## The Doc Side -- Stable Anchors

Every documented item carries an explicit HTML anchor on the line before its heading, because both forges auto-sprig headings from their text, and auto-sprigs shatter the moment a title is improved. An explicit anchor survives any retitle:

```markdown
<a id="g-bartis"></a>
### `|=` bartis -- the gate
```

**Naming the anchor.** Seated things take **semantic sprigs**, because their names are promises: `g-<rune-name>` for runes (`g-bartis`, `g-cell`, `g-cast`), `gd-<sprig>` for doctrine sections (`gd-truth`, `gd-auras`). Dated essays and briefs keep their **chronological stamps** as identity, exactly as the tree already does -- the what3words-style middle ground you floated resolves this way: semantic where a name is seated, chronological where a moment is the identity, and never a third scheme.

## The Code Side -- One Greppable Line

A module that the Book documents carries one line in its opening comment, in a fixed shape:

```zig
//! glow-book: runes.md#g-bartis
```

The shape is rigid on purpose -- `glow-book: <file>#<anchor>` -- so a single grep finds every thread of the weave, and a witness can check each one resolves.

## The Return Thread -- Source Lines

Every Book entry closes its header with a **Source** line naming its files and, where one symbol is the door, `path:symbol`:

```markdown
**Source:** [`glow/rune_bartis.rye`](../../../glow/rune_bartis.rye):`parse` - [`glow/lower_bartis.rye`](../../../glow/lower_bartis.rye) - witness [`tools/g/glow_lower_bartis_witness.rish`](../../../tools/g/glow_lower_bartis_witness.rish)
```

## The Witness -- Both Directions, One Gate

The convention earns Checkable through `glow_book_anchor_witness` (Phase D lands it), which asserts the positive and the negative space in both directions: every `glow-book:` comment in `glow/` resolves to a real anchor in the Book; every anchor in the Book is reachable; every Source path in the Book exists in the tree; and a deliberately broken fixture pair -- one dangling comment, one orphaned anchor -- goes RED by name. Known-good beside known-bad, as every gate here must carry.

**Fixture, known-good:** comment `//! glow-book: runes.md#g-cell` + anchor `<a id="g-cell"></a>` present. **Fixture, known-bad:** comment `//! glow-book: runes.md#g-ghost` with no such anchor -- the witness must print `RED: dangling glow-book thread -- g-ghost`.

## What This Deliberately Refuses

No numeric heading schemes (renumbering is the break we swore off). No auto-sprig reliance. No anchors inside code beyond the one header line -- the weave stays one thread per module, aparigraha-thin, so it can actually be kept.

---

*May every thread resolve in both directions, and may a reader lost in either land find the other in a single step.*
