# One language, two answers for `007`

**Stamp:** `20260908.141152`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- **mixed room**: the census and the two metal readings are checkable, and the
question of which way the language should rule is vision, waiting on Keaton's word
**Kin:** [`../foundations/20260830-011530_a-rune-is-earned-by-a-law.md`](../foundations/20260830-011530_a-rune-is-earned-by-a-law.md) -
[`../tools/g/glow_literal_law_witness.rish`](../tools/g/glow_literal_law_witness.rish) -
[`../tools/fixtures/t/tame_style_app_sites.sh`](../tools/fixtures/t/tame_style_app_sites.sh)

Glow reads a decimal literal in fourteen places, and on `20260908` those fourteen gave two
answers. Thirteen accept `007` and read it as seven. One holds a leading zero back, and calls that
check **the house parse law** in its own comment. A seated law choosing between them is what the
language still owes itself.

## What was measured, and how

Both ends were run rather than read, through the modules' own public entries, on the tree at
`b60a45c1f`:

```
?:  (gth a b)  007  1     rune_shop_gate.parse_source        refused    (MalformedBody)
?:  (gth a b)  7    1     rune_shop_gate.parse_source        accepted
=.  root  007             lower_mutate.lower_line_welcome    lowered `root = 7`
```

A lap writing a leading zero into a conditional arm meets the house parse law. The same lap writing
one into a mutation gets seven. The two sites sit eleven files apart, and each behaves as though it
were the only reader in the room.

The census behind those two readings is
[`../tools/fixtures/g/glow_literal_law_scan.sh`](../tools/fixtures/g/glow_literal_law_scan.sh):

| Reading | Count |
|---|---|
| decimal-literal readers under `glow/` | **14** |
| of those, hand-rolled `* 10 + ` accumulators | 11 |
| of those, `std.fmt.parseInt` calls | 3 |
| readers holding a leading zero back | **1** |
| readers accepting one | **13** |

**Run the scan rather than reading the table.** A stamp says when somebody looked, and this row is
free -- the guard below now holds its last line still, and every other figure moves as the room
does.

## How it was found, and what that says about the instrument

The finding arrived through a TAME advise ratchet, and the ratchet's advice turns out to fit
another kind of room. `parseInt(` sites are counted as debt to migrate to `tally/parse_int.rye`,
whose default holds a leading zero back. Glow carries three such sites. Migrating them **on touch**
would have moved the language from thirteen-against-one to ten-against-four -- widening the split,
one file at a time, in whatever order laps happened to open files.

**A lint ratchet is a fine instrument for an application and a blunt one for a language.** In an
application a stricter parser is a local improvement, and every call site may take it separately.
Inside a compiler the same edit changes what the language accepts, and it changes it for exactly
the programs whose literals pass through that one rune. So the three sites read as a question that
has yet to be asked, rather than as debt.

## What was built, and what it settles

[`../tools/g/glow_literal_law_witness.rish`](../tools/g/glow_literal_law_witness.rish) holds
**`disagreement`** -- `min(strict, permissive)`, the size of the minority -- at a ceiling of one
that only falls. The reading was chosen so that **both lawful answers close it**: extending the
house parse law to the thirteen drives it to zero, and so does dropping it from the one. A ceiling
on the permissive count alone would have ruled out half the possible answers, and a guard standing
in the way of a correct repair is a guard somebody turns off.

Fifteen behaviors stand proven on real git repositories in a throwaway pen, both rulings shown
lawful, and the elder counting rule put back to prove the program-position reading load-bearing:
under a naive count, the 79 lines where `glow/lower_shop_gate.rye` writes `parseInt` **into the Rye
it generates** read as calls the compiler itself makes.

The rung leaves the language exactly as it stands. It holds the split still and names every site,
so whichever way the word falls the repair is one pass.

## The question, for Keaton

**Does Glow accept a leading zero in a decimal literal?**

Two honest answers, and the tree already carries an argument for each:

- **Hold it back**, extending the house parse law to the other thirteen. A leading zero is a
  warning sign nearly everywhere -- a truncated value, a copy-paste seam, a number wearing another
  number's shape -- which is the reasoning `tally/parse_int.rye` was written on and the reasoning
  `rune_shop_gate.rye` already follows. Cost: thirteen readers change, and Glow source carrying
  `007` asks for one edit before it compiles again.
- **Accept it**, and let the one reader join the thirteen. Cost: one reader changes, and Glow keeps
  a footgun that `tally/parse_int.rye` exists to close.

Standing pat is the one answer worth setting aside, since a language answering two ways about its
own literals teaches two things to whoever reads it next.

## What this leaves for another lap

Whether the fourteen agree about anything else -- overflow, a sign, an empty string, a base. Those
stayed unread, and the readers are close enough in shape that a second census looks worth the hour.

The emitted half is the other one. `glow/lower_shop_gate.rye` writes
`std.fmt.parseInt(u32, argv[1], 10)` into the Rye it generates, so a lowered Glow program reads
**its own command line** with the permissive reader whatever the front half decided. That is a
second seam wearing the same question, and it wants its own lap.
