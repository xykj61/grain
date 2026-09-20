# Unicode-second -- the named roster for a room whose subject IS a script

**Seated:** `20260920.133421` on Keaton's word - **Status:** Living
**Kin:** [`ascii-first`](ascii-first.md) (the parent rule and its own named exception) - [`comlink-tendency`](comlink-tendency.md) - [`design-rooms`](design-rooms.md)
**Meter:** [`../../tools/fixtures/a/ascii_document_scan.sh`](../../tools/fixtures/a/ascii_document_scan.sh)

**Ascii-first governs by default. Unicode-second names the rooms it was always going to
exempt, so the exemption lives in a rule rather than in a scan's own case statement.**

[`ascii-first.md`](ascii-first.md) already writes its own exception in words: *"a specific,
explicitly-named set of work rounds may use non-ASCII when it is the point of the work -- a
Unicode-handling module's own test fixtures, an internationalization surface."* That sentence
wanted a roster to point to. `risala/` -- a room studying Classical and Quranic Arabic, where the
script is the literal subject of every lesson -- was the first room to actually need it, and it
landed as three matching `case` arms added straight into
[`tools/fixtures/a/ascii_document_scan.sh`](../../tools/fixtures/a/ascii_document_scan.sh),
with the reason typed only as an inline comment. This page gives that reason a home a reader
finds by looking in `.claude/rules/` first, rather than by reading a guard's refusal and working
backward.

## The test

A room earns unicode-second, rather than a ratchet debt, when **the room's own front door names
the script as its subject** -- the same test [`docs-implementation-sync`](docs-implementation-sync.md)
already asks of any claim: assert it, don't assume it. A page that *quotes* a foreign word in
passing stays under ascii-first's ordinary ratchet; a room built to *teach* a script, where the
diacritics and the glyphs are the lesson, is what this rule names.

## The roster

| Room | Script | Named by |
|---|---|---|
| **`risala/`** | Classical and Quranic Arabic, IJMES transliteration | `risala/README.md`'s own "An ASCII-first exception, named plainly" section, `20260920` |

**`shastra/`, `classical-vedic-astrology/`, and `cubist-bhakti-astrology/` earn their place by
measurement, the same way `risala/` did.** Read `20260920.133421`, all three already hold their
Sanskrit terms in plain transliteration rather than Devanagari, so today none moves
`ascii_document_scan.sh`'s ratchet enough to need the roster. A room joins when its own
measurement says so, category resemblance alone is not enough.

```sh
sh tools/fixtures/a/ascii_document_scan.sh --list-all | grep -iE 'shastra|vedic|cubist|risala'
```

## What a room on this roster is exempted from, and what it keeps

**Exempted:** `ascii_document_scan.sh`'s ratchet count, which holds every other living `.md`/`.mdc`
page under a ceiling that only falls. A room here contributes zero to that count, the same way
`gratitude/`, `vendor/`, and `seed/` already do for their own separate reasons (third-party source,
held unmodified, or the public projection).

**Kept, in full:** every other rule in the tree. English prose inside the room still takes the
ordinary ASCII substitutions -- `--` for a dash, straight quotes, `...` for an ellipsis --
exactly as `risala/README.md` itself says. Commit subjects and bodies about the room stay ASCII
throughout, per [`ascii-first.md`](ascii-first.md)'s own words: the exception is scoped to the
*document* alone. [`comlink-tendency`](comlink-tendency.md) still governs the room's own name.
[`design-rooms`](design-rooms.md) still governs where the room sits in the tree.

## Joining the roster

1. Measure first -- `sh tools/fixtures/a/ascii_document_scan.sh --list-all` and confirm the new
   room is genuinely what moves the ratchet, rather than one file that could simply convert.
2. Name the exception plainly inside the room's own front door, the way `risala/README.md` does.
3. Add the room to the table above, with the stamp.
4. Add one `case` arm per loop in `ascii_document_scan.sh` -- there are three, and the file's own
   comment says why the two rosters "cannot disagree": each loop answers a different question
   (which pages are walled, which pages a walled page cites, which pages the ratchet counts) and
   a room added to one and not the others is a room the census sees inconsistently.

## Why the rule exists

A scan can enforce a roster; it should not be asked to invent one from a single inline comment.
Keaton asked for the exception to get its own name rather than live only inside a shell script's
`case` arms, so the next room that genuinely needs it -- and the next reader wondering why
`risala/` reads differently from every other page -- finds the reasoning in `.claude/rules/`
first.

*Cursor twin retired* `20260920.135100` -- this rule once mirrored to a `.cursor/rules/*.mdc` file; the whole family is archived, unmodified, at [`.cursor-archive/rules/`](../../.cursor-archive/rules/README.md).
