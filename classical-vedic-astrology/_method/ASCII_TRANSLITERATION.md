# ASCII Transliteration -- the map this room converts by

**Stamp:** `20260823.201533` - **Style:** Gauge, Field setting - **Status:** Living
**Rule:** [`../../.claude/rules/ascii-first.md`](../../.claude/rules/ascii-first.md)

Every file in this room reads as plain 7-bit ASCII, and this page is the map it was converted by,
so a reader can see exactly what changed and a later writer can stay consistent.

## Why plain ASCII, in a room full of Sanskrit

**Plain ASCII survives every tool, terminal, diff, and re-encoding intact.** This tree learned that
the hard way: its operator card silently triple-encoded itself into 2,797 runs of unreadable bytes
before anyone noticed (REDS %83), because one tool read a UTF-8 file as Latin-1 and rewrote it. A
room whose value is a roster of names is exactly the room where that failure costs the most.

**The convention was already here.** `seat_nakshatra.rye` has always written `Krittika`,
`Ashlesha`, and `Shatabhishak` in plain ASCII, with a comment saying so. The prose disagreed with
the code for months. This converges them, and the code's choices win, because a name a program
can compare is worth more than a name only a font can render.

## The map

Diacritics follow the standard romanization of IAST, matching what the module already wrote.

| IAST | ASCII | | IAST | ASCII |
|---|---|---|---|---|
| `a-macron` | `a` | | `s-acute` | `sh` |
| `i-macron` | `i` | | `s-underdot` | `sh` |
| `u-macron` | `u` | | `t-underdot` | `t` |
| `r-underdot` | `ri` | | `d-underdot` | `d` |
| `n-underdot` | `n` | | `m-underdot` | `m` |
| `n-tilde` | `n` | | `h-underdot` | `h` |

So `Krttika` reads **Krittika**, `Asles.a` reads **Ashlesha**, and `Sravan.a` reads **Shravana** --
the same spellings the module compares against.

## Typography

| Was | Now | | Was | Now |
|---|---|---|---|---|
| em-dash, en-dash | `--`, `-` | | arrows | `->`, `<-` |
| middle dot | ` - ` | | degree sign | ` deg` |
| curly quotes | `'` and `"` | | prime | `'` |
| ellipsis | `...` | | minus sign | `-` |
| box drawing | `-`, `\|`, `+` | | Greek in prose | spelled: `theta`, `lambda` |

## The one file that keeps its glyphs, and how

`templates/reading-template.html` renders a chart, and its planet and sign glyphs are the visual
language of the craft rather than decoration. Spelling them out would change what the page draws.
So the file holds them as **HTML numeric character references** -- `&#9737;` for the Sun, `&#9789;`
for the Moon, twenty-one in all. The file is 7-bit ASCII on disk and renders exactly as it did,
which is the answer that costs nothing on either side.

## What did not change

**No name, number, deity, degree, or claim.** This was a character-level conversion, and the
`claim_preserve` discipline applies: a register pass holds numbers, paths, stamps, and proper nouns
exactly. `seat_nakshatra_witness.rish` runs GREEN across the conversion, which is the check that the
roster still says what it said.

**The count still starts at Krittika**, per the Taittiriya Brahmana's own order, corrected the same
day.
