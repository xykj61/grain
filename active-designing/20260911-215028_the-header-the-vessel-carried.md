# The header the vessel carried, and the meter that could not read it

**Stamp:** `20260911.215028`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every claim here names the scan, the control, or the witness that binds it
**Kin:** [`../.claude/rules/ascii-first.md`](../.claude/rules/ascii-first.md) -- [`../tools/fixtures/r/rye_spoken_ascii_scan.sh`](../tools/fixtures/r/rye_spoken_ascii_scan.sh) -- [`../tools/fixtures/r/rye_comment_ascii_scan.sh`](../tools/fixtures/r/rye_comment_ascii_scan.sh) -- [`../amphora/src/main.rye`](../amphora/src/main.rye)

## The one sentence

`tools/fixtures/r/rye_written_ascii_scan.sh` counts non-ASCII characters inside a Rye program's
**assembling** calls -- `bufPrint`, `bufPrintZ`, `allocPrint`, `writeFile` -- reading parenthesis
depth outside string literals so a multi-line call is read whole, and reporting two numbers: a
ratchet over all assembled text and a **wall at zero** over the subset standing in a file that also
writes a file. `tools/r/rye_written_ascii_witness.rish` gates both over
`tools/fixtures/r/rye_written_ascii_control.sh`, which proves 41 behaviors on real git repositories
in a throwaway pen, every refusal planted and then lifted and two mutations asserted to bite.

## What the law names, and what its meters read

The ASCII-first law names four subjects and each has a meter. The living card, the documents, the
code comments, and what a guard **says out loud**. Read the list again with one question in hand and
the shape appears: every meter reads what a source **comments** or what a program **prints**.

Nothing reads what a program **builds into a buffer and hands onward**.

That is the surface the law was born on. REDS %83 is a persisted document a tool read in the wrong
encoding and rewrote into 2,797 runs of mojibake -- a file's own bytes, not a comment and not a
terminal line.

## The exclusion that covered two populations

The gap was not an oversight. `rye_spoken_ascii_scan.sh` names it and gives a reason:

> every line outside a print call -- a `const` binding, a struct field, a `std.mem.eql`
> comparison. A test asserting that a decoder handles an em dash must CONTAIN one, so counting
> those would ask the tree's own modules to stop being able to test what they decode.

That reason is exactly right about a decoder's own fixture. It says nothing at all about a header a
program writes into every artifact it pours. **One line was drawn across two populations**, and the
half the reason does not cover had no meter.

## What the reading found

Measured `20260911` over the same 1,743 tracked `.rye` sources the sibling meters open, symlinks
skipped for the sibling's reason (REDS %340):

| Reading | Count |
|---|---|
| assembled non-ASCII characters | **292** across 49 files |
| of those, forms the rule's table spells | **292** -- all of them |
| standing in a file that also writes a file | **2**, in 2 files |

After the two repairs below the ratchet reads **290 across 47 files** and the wall reads **zero**;
the ceiling fell to 290 in the same commit, since a ceiling only falls and the lap that sweeps is
the lap that lowers it.

**Every one of the 292 is mechanically convertible.** That parts this class from the comment
ratchet, where notation -- a section sign, a superscript, a Greek letter -- needs a reader to choose
the ASCII word. Assembled text is a sentence somebody wrote for somebody to read, and the six forms
the table spells are what people reach for when they are writing a sentence.

## The two that reach a disk

**`amphora/src/main.rye:651`** assembles the header of every sealed vessel this tree pours:

```
const head = std.fmt.bufPrint(&text, "# amphora vessel -- season poured for crossing\n...
```

Three bytes of that line were an em dash. The vessel is a `.bron`-family artifact: it is cut into
340-byte chunk frames, ferried to a far dock, reassembled, and demanded byte-equal. Nothing was
broken -- the crossing moves bytes and compares bytes. What stood was a persisted record in the
tree's own notation carrying a character the tree's own law retires, in the one place the law's
founding red actually happened.

**`tools/rye/enrich/enrich_file.rye:25`** is the sharper one. It assembles a Markdown sentence in a
raw multiline string and writes it into documentation pages:

```
\\**Authored:** `{s}` -- not an inherited `std` function. Width migration is Tier A in `992`.
```

Two tracked pages carry that character on disk today,
`external-research/yonder/strengthening-compiler/9989_tally_gardens.md` and `9990_mantra_seed.md`.
`tools/fixtures/a/ascii_document_scan.sh` gates and ratchets exactly that population of pages, and
reads nothing of the tool that puts characters into it. **A generator feeding a gated meter, sitting
outside every meter**, is the shape the wall exists to close. Those two pages keep their bytes --
they stand in a `yonder/` shelf every document meter reads past, and the generator is what was
repaired, so the next regeneration is clean.

## Why a wall rather than a ratchet

Both characters were repaired on this lap, so the persisted reading stands at **zero**, and a
population at zero is walled. A ceiling above zero on an empty class is decoration: it refuses
nothing and teaches a reader that some number of characters is acceptable there.

The reading is a **proxy and is named as one in the scan's own header.** Where a buffer lands --
a file, a terminal line, a wire frame -- is dataflow a scanner does not follow. A file that also
calls `writeFile` is the closest a scanner gets to *these bytes reach a disk*, and it is file-level:
a module writing one page and assembling an unrelated terminal line would be counted here wrongly.
Measured today it reads exactly the two, both genuinely written to disk. A false refusal costs one
line of explanation and a conversion the rule's own table already spells.

## What the pen proves

The control plants each behavior, counts it, lifts it, and counts again, because a refusal proven
only in the passing direction cannot be told from a bypass. The legs worth naming here:

**The identifier trap is sharper in this meter than in its sibling**, because the names this one
opens on **contain** the name that one opens on. `bufPrint` ends in `print`. Both directions are
proven: `parent_bufPrint(` opens nothing, and a mutation reading the name as a suffix makes it fire.

**A character is never charged to two ceilings.** An assembling call nested inside a `print(` is
already counted by the spoken meter, so this one steps past it; a mutation dropping that tracking
makes the nested case count, which is what proves the tracking is a mechanism rather than a
coincidence of fixtures.

**A raw multiline string is counted inside an assembling call and refused outside one.** Standing
alone it is a parser's input and its bytes are behavior -- the spoken meter's line, kept. Inside a
`bufPrint`, it is a page being written, which is this meter's whole subject. The one at
`enrich_file.rye:25` is exactly that shape, and a meter drawing the line the other way would have
missed the sharpest instance in the tree.

**A meter that cannot open its subject says so.** A `000` file makes the scan print
`instrument=failed` and `under_ceiling=no`, because an empty answer from a refused read is
byte-identical to an empty answer from a clean file, and the second is the one everyone hopes for
(REDS %513).

**The control tallies its own legs and the witness asserts the tally.** A verdict says only that the
control reached its last line, so a leg written tomorrow would pass unheard under it -- the fault
`ascii_document_control` booked one meter over on `20260910`.

## What this does not reach

**The shell half.** `tools/fixtures/a/amphora_pour.sh` writes a vessel header carrying an em dash,
and `tools/fixtures/a/amphora_vessel_lap1.bron` is a stored vessel carrying one. Both sit in
`fixtures/`, which every meter in this family reads past by design -- the planted mojibake control
must keep its high bytes or its own prove-red leg proves nothing. The residue is 2 characters in 2
files, named here rather than guessed at, and a shell writer's meter is its own lap.

**Text assembled through a variable.** `bufPrint("{s}", .{msg})` counts the literal text; the value
of `msg` is followed by nobody. Following a value is parsing rather than scanning, so this meter
undercounts on purpose, the same way all three siblings do.

**Whether the 292 should fall.** They are assembled for screens, for generated Glow comments, for a
terminal's status line. Each is a form the table spells, so each is a sweep rather than a judgment
-- and a sweep is a lap, taken by whichever lane owns the room.
