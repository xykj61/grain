# The study room -- what comes in, and how

**Language:** EN - **Style:** Bhakta at the Door setting, with Radiant warmth (see `../../context/BHAKTA_STYLE.md`)
**Written:** `20261018.220007` - **Status:** Living - **Kind:** study guide

---

## What the study room is

`study/` is where this tree keeps texts it has read and learned from -- books, papers, essays,
specifications. Each text lives in its own directory with a study note and a checksum, so a reader
can see exactly what was admitted, when, and under what license.

The room sits beside `gratitude/`, which records what this tree learned from other projects. The
difference is the object: `gratitude/` holds lessons drawn from codebases and tools, while `study/`
holds the texts themselves, verified to the byte.

## The three-condition gate

A text enters `study/` only when all three conditions hold:

1. **Public domain or CC0.** The text carries no copyright restriction at all, or it has been
   released under CC0 (Creative Commons Zero), which gives the same freedom.

2. **No share-alike clause.** A share-alike license (such as CC BY-SA) requires that anything
   built on the text carry the same license. This tree's own work is licensed separately, so a
   share-alike clause would bind it.

3. **No non-commercial clause.** A non-commercial license (such as CC BY-NC) forbids commercial
   use. This tree may serve commercial work, so a non-commercial clause would bind it.

All three conditions protect the same thing: the freedom to learn from a text without inheriting
its terms. A text that passes one condition and fails another stays outside the gate.

## What the directory looks like

```
study/
  README.md          -- the gate description (this is described here)
  MANIFEST.md        -- a table of every admitted text
  texts/
    <name>/
      study-note.md  -- title, author, source, license, retrieval date, notes
      SHA256SUMS     -- one checksum per file, so the bytes are provable
  refusals/          -- a record of texts that were considered and refused
```

Each text gets its own directory under `texts/`. The directory name is a short, descriptive,
hyphenated string -- `"the-wealth-of-nations"` rather than a date or an abbreviation.

Binary files (`.pdf`, `.epub`, `.mobi`, `.djvu`) are untracked by `.gitignore` inside the room.
The checksum in `SHA256SUMS` is what proves the file is the one that was admitted, even though git
does not carry it.

## A text that passes: one worked example

Suppose you find a paper released under CC0 -- the author has waived all copyright. You check:

- **Public domain or CC0?** Yes -- CC0 is an explicit waiver.
- **No share-alike?** Yes -- CC0 carries no conditions at all.
- **No non-commercial?** Yes -- CC0 places no restriction on use.

All three hold. You create `study/texts/the-paper-name/`, write a `study-note.md` naming the
title, author, source URL, license (quoted from the source), and retrieval date, then run
`sha256sum` on the file and record the result in `SHA256SUMS`. Add a row to `MANIFEST.md`. The
text is admitted.

## A text that fails: one worked example

Suppose you find a handbook released under CC BY-NC-SA 4.0. You check:

- **Public domain or CC0?** No -- it carries conditions.
- **No share-alike?** No -- SA (share-alike) is in the license name.
- **No non-commercial?** No -- NC (non-commercial) is in the license name.

Two conditions fail. The text stays outside the gate. If the reasoning is worth keeping, record
it in `study/refusals/` so the next person who finds the same text can see it was already
considered.

## Where external-research fits beside this

`external-research/` is a different room with a different purpose. It holds this tree's own
analysis of things in the world -- studies, comparisons, license reads -- written in the tree's
own words, never carrying the source text itself. A study in `external-research/` may cite a text
that lives in `study/`, and often does, yet the two rooms hold different things: one holds the
text, the other holds the thinking about it.

---

*May the gate stay plain, so a newcomer reading it for the first time knows exactly what it asks.*
