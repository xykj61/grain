# The number a comment states, and the sweep that read every candidate

**Language:** EN
**Stamp:** `20260905.234408`
**Style:** Gauge, **Field** setting
**Voice:** Kyri
**Room:** Round note -- a survey and its result, rather than an essay
**Opens and closes:** the class REDS `%439` named, which `construction/ITINERARY.md` records as
having no meter

## What this round asked, and what it answers

REDS `%439` found a doc comment in `comlink/topology.rye` holding the universe at 792 while
`universe_points` had read 720 since the inclusive breach. The card's live front drew the general
lesson and left it there: *the class has no meter -- `borrowed_number` reaches a stale figure inside
an assert, and nothing reaches one in a comment.*

Two questions follow from that sentence, and this round answers both by measuring.

**Can the class be gated?** No. Four detectors were built and run over the whole authored Rye
corpus, and the sharpest of them reads one true positive against 158 false ones.

**Does the tree hold a second instance?** No. That sharpest detector's whole residue -- 158 lines --
was read one at a time, and every one is a correct sentence about a different quantity.

Nothing was seated. No witness joined the standing roster, no ceiling moved, and no file changed on
account of this survey.

## The corpus, and one fact about counting it

Measured `20260905` at git nib `3081533648`: `git ls-files '*.rye'` lists **1,939** paths, of which
**227** are symlinks and **1,712** are distinct files. The tree writes a shared module once and
links it into every room that imports it -- `crypto/sha3.rye` is reached from three rooms and
`mantra/beading.rye` from four -- so 11.7% of the paths carry no bytes of their own.

Two standing meters already know this: `tools/fixtures/r/rye_comment_ascii_scan.sh` and
`tools/fixtures/s/shell_comment_ascii_scan.sh` each skip a link with a written reason, seated
`20260829`, after following both ends counted the same characters twice. Every detector below skips
symlinks for the same reason.

Three other scans enumerate a source glob and read the bytes without skipping links, and each is
fine today for its own reason. `tools/fixtures/l/living_docs_roster_scan.sh` asks which rooms *have*
a module, where a link is exactly the right answer. `tools/fixtures/d/dated_spelling_scan.sh` gates
at zero, and duplicates cannot distort a zero. `tools/fixtures/s/socket_dialect_scan.sh` draws a
corpus of 1,930 carrying 226 links, and measured today **none** of its twenty option hits or twenty
dispatch hits is a link -- so the reading is correct now, and would double the day a shared module
takes a socket option. Named here rather than repaired, since nothing is currently wrong.

## Four detectors

### 1. A trailing comment on a `const` that restates the line's own arithmetic

The tightest form of the class: `pub const star_count: u32 = galaxies_per_universe *
stars_per_galaxy; // 60`. The expression is evaluated from the file's own constants, and the
comment's leading number is compared against it.

**294** const lines carry a trailing comment with a digit. **69** were both resolvable and
comparable; **50** agreed and **19** disagreed. Reading all 19: every one is a false positive, and
they share one shape -- the leading number opens a derivation or carries a unit rather than claiming
the value. `// 1600 bits - 2*256 bits of capacity, in bytes` on a constant of 136. `// 32
whole_digest + 2 whole_len + 2 bead_count` on a constant of 36, which is the sum. `// 6 - 5` on a
constant of 1. `// 64 lines never near this` on 16,384.

**Genuine mismatches: zero.** The subclass is clean today, and it is the one solid foothold here: a
rule that requires the leading number to stand alone -- followed by end of line, ` -- `, or ` (` --
excludes all 19 and keeps all 50. A future lap wanting a floor can seat that in one sitting. This
round declines to, because a gate over 50 clean sites costs every lap of the fleet a guard and
returns a property nothing has yet broken.

**What it cannot reach:** `%439` itself, which lived in a `///` doc comment above a function rather
than on the declaration.

### 2. A comment naming a declared constant exactly, beside a number that differs

**2,978** hits. Unusable, and the reason is plain: a comment near `max_name` may honestly say
"32 bytes" about something else entirely.

### 3. Assertive shapes only -- `NAME is N`, `NAME (N)`, `N NAME`

**150** hits, dominated by short constant names. A file declaring `const w` and `const h` matches
every design-read stamp and every coordinate in its own prose.

### 4. The constant's distinctive first segment, beside a number

`universe_points` is named in prose as *the universe*, so the detector takes each constant's first
underscore segment, requires at least six characters, and looks for a number within 24 characters --
skipping any number reached across an arithmetic or comparison operator, and skipping 0 and 1, which
are indices rather than totals.

**This one catches `%439`.** Run against `comlink/topology.rye` as it stood before the repair, it
answers `universe_points 720 saw 792` on line 113, which is the exact line the row was written
about. It is also the only detector that could: the comment never spells the identifier, and the
sentence is hard-wrapped so that *"past the"* ends one line and *"universe's 792"* opens the next --
the same wrap that walked a fabricated citation past a line-reading guard in `%437`.

Its tree-wide residue is **158** lines.

## The sweep, read whole

All 158 were read one at a time. **Every one is correct.** The pattern is uniform: the constant's
first segment is an ordinary English word -- *digest*, *planet*, *period*, *header*, *summary*,
*sample*, *address*, *scalar* -- and the number beside it belongs to a different quantity in the
same sentence. `digest_len` is 32 and the sentence says `Sha256`. `planet_num` is 267 and the
sentence names galaxy 3.

`comlink/topology.rye`, the module that carried `%439`, contributed eight of the 158, and all eight
are right: the compass sky's 720 and the council sky's 405 each stand beside their own sky, a
galaxy's d60 reads 60, and the tier depths read 0, 1, 2. The module is consistent with itself
everywhere the detector could look.

**So the signal-to-noise is one in 159**, counting the historical true positive. As a gate that is
unusable, and as a one-time review lens it was exactly right -- 158 lines is an hour, and the hour
has now been spent once so no later lap owes it.

## What this round leaves

- **The class stays ungated, on measurement rather than on assumption.** The card's sentence stands,
  and it now has four numbers under it.
- **Detector 1's rule is written down above**, with its base rate, for the lap that wants the floor.
- **Detector 4 is a lens, not a guard.** Re-running it after a breach that changes a derived total
  is cheap and would have caught `%439` on the day it entered.
- **What this does not reach:** a figure in prose that names no constant at all, and a figure about
  code in another file. Both stay a reader's job, and saying so is cheaper than implying otherwise.
