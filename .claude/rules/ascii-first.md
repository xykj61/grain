# ASCII-First -- plain ASCII for documents and commits

**Seated:** `20260816.214652` on Keaton's word - **Status:** Living - **Kin:** [`reds-first`](reds-first.md) - [`standfast`](../../foundations/20260816-214652_standfast-the-stopped-line.md) - REDS %83

Write every new document, code comment, and commit message in **plain 7-bit ASCII**. A non-ASCII character no reader needs is a corruption waiting to compound -- the operator card (then named `REMEMBER.md`) silently triple-encoded itself into 2,797 runs of unreadable mojibake bytes (the classic capital-A-tilde garble) before anyone caught it (REDS %83), because a tool read the UTF-8 file as Latin-1 and rewrote it. ASCII-first is how that never happens again.

## The substitutions

| Instead of | Write |
|---|---|
| em-dash, en-dash | `--`, `-` |
| middle dot separator | `-` or `,` or `;` |
| curly quotes | straight `'` and `"` |
| arrows | `->`, `<-`, `<->` |
| ellipsis | `...` |
| typographic minus (U+2212) | `-` |
| `<=` `>=` `!=` | `<=` `>=` `!=` (ASCII already) |
| Greek / subscripts in prose | spelled: `gamma_2`, `sigma`, `alpha` |

## The exception

A specific, **explicitly-named set of work rounds** may use non-ASCII when it is the point of the work -- a Unicode-handling module's own test fixtures, an internationalization surface, a font codec's glyph tables. Name the exception in the round; do not let it leak into the operator card, commit subjects, or general prose.

## What this does not change

- **Dated artifacts are never rewritten** to retrofit this -- the one-clock law and accrete-never-break protect every dated log and testimony. This governs prose written from here forward, and repairs a *corruption* (mojibake) wherever found as a red, which is a fix, not a style rewrite.
- **Code strings and identifiers** already ASCII stay ASCII; this simply names the habit.
- **Math-heavy design notes** may spell Greek and operators in ASCII (`gamma_2`, `-> `) rather than reaching for Unicode -- clearer in a terminal and diff, and safe from re-encoding.

## Prevention, not just cure

**Four guards stand over four subjects, and the fourth is one the opening sentence above never
named.** All four are rostered in `construction/standing-equipment.kyri`. Each current reading
below carries the guard that holds it still -- the fifth thing `context/GAUGE_STYLE.md` asks a
figure to name -- and each dated figure is testimony from the lap that measured it, free to move
since. Run the scan rather than trusting either; every one is named here so you know where.

**The living card** (REDS %83): `tools/l/living_card_ascii_witness.rish` over `tools/fixtures/l/living_card_ascii_scan.sh` greps the operator card and the REDS ledger for bytes above 0x7F and fails hard if any appear (the ENFORCE roster), while the pins still holding legacy dated non-ASCII are reported as an advisory ratchet to sweep down on touch rather than force-rewritten. A planted mojibake control proves the RED path on metal.

**Documents** -- the subject this rule names FIRST, and the last to earn a meter over its whole
subject (seated `20260906.133344`): `tools/a/ascii_document_witness.rish` over
`tools/fixtures/a/ascii_document_scan.sh`. It gates `.claude/rules/*.md`, `.cursor/rules/*.mdc`,
and -- from `20260910.043000` -- `docs/*.md` at zero, reading **104 pages, 0 characters** on the
lap it was seated, and holds every other living tracked `.md` and `.mdc`
under a ceiling that only falls: **3,331 of 3,331** across 72 of 334 pages, read `20260908.052550`.
Dated basenames, the `date/`, `archive/` and `yonder/` shelves, `gratitude/`, `vendor/`, `seed/`,
and every `fixtures/` path are read past, each for its own named reason -- the planted mojibake
control above MUST keep its high bytes, or its own `prove-red` leg proves nothing.
`tools/fixtures/a/ascii_document_convert.sh` makes the substitutions the table above spells and
proves a sweep moved nothing else by **re-deriving each page from its committed bytes**.

**The wall is drawn around the room that writes the law, and the law is a graph.** That ENFORCE
roster is two directory globs, so a page an enforced rule names as its own canon stands outside it.
Measured `20260908.052550`: of the 13 living `context/` pages the rule rooms cite, four were dirty --
`RADIANT_STYLE.md` 80, `TWILIGHT_STYLE.md` 61, `TAME_CORE.md` 51, `REMOTE_ROSTER.md` 18 -- and
`CLAUDE.md`, the root file that loads every one of those rules, held 38. `tame-guidance.md` was
walled at zero while the page it tells a reader to **read first** carried 51. All five stand at zero
from this stamp: the mechanical part proven by re-derivation, and the fifteen check and cross marks
in `RADIANT_STYLE.md` read one at a time into the tree's own **Prefer** and **Rather than** words.
**The roster was widened `20260909.220333`, and the wall now follows the citations rather than the
directories.** `ascii_document_scan.sh` derives its enforced set from the rule rooms' own links and
backticked paths, keeps every living tracked page it finds, and reads past what the ratchet reads
past -- dated testimony, closed stacks, vendored sources, fixtures, and a citation this tree does
not carry. It stood at **110 globbed plus 33 derived, 143 pages, zero characters**; with the compressor shelf below it reads **125 globbed plus 33 derived, 158 pages, zero characters**.

**Derived rather than typed, for the reason the globs are globs:** a page the law begins citing
tomorrow is walled the day it lands, where a name list waits for somebody to remember it. The one
thing derivation can do that a glob cannot is let a page fall out of the wall by an edit made
somewhere else, so the two memberships are **printed separately** -- `enforce_globbed` and
`enforce_derived` -- and a drop is legible in the census rather than silent.

**What the five hand-swept pages had holding them, between the two stamps: seven characters of
ratchet slack.** They were repaired on `20260908` and then priced by a total naming no page, so one
em dash in `context/RADIANT_STYLE.md` reddened nothing and eight of them reddened something a reader
could not locate. The widening also refused two pins the elder reading called clean --
`session-logs/CHAPTERS.md` at 50 characters and `construction/SHRED_PREP.md` at 49, every one a form
the table above spells -- both swept and proven by re-derivation from their committed bytes. The
ratchet fell **3,324 to 3,225** as those characters left it, and the ceiling fell **3,331 to 3,232**,
keeping the seven of slack it already stood on and taking none of the ninety-nine.

**Then the wall reached past the law, and the two rosters came apart** (`20260910.043000`). The
compressor shelf of [`docs/`](../../docs/README.md) is the room `MAP.md` sends a newcomer to, and it
carried **452 characters across 12 of its 15 pages** -- 14 percent of the whole tree's remaining
ratchet in one small teaching room, held by nothing, since no rule page cites a compressor and the
derivation therefore could never reach it. All 452 are gone: **450** were forms the table above
spells, converted and proven by re-derivation from their committed bytes, and **two** were read by
hand, a section sign becoming the word and a multiplication sign becoming `x` in a screen
resolution. `docs/*.md` joined the wall, the ratchet fell **3,225 to 2,773** and the ceiling
**3,232 to 2,780**, keeping the same seven of slack and taking none of the 452.

**Then one page held more than the whole rest of the tree** (`20260910.042550`).
`rye-learning-process/GLOW_ALMANAC.md` carried **1,437 characters, 52 percent of the remaining
2,773**, and **1,350 of those were a single form** -- the middle dot separator the table above has
spelled since this rule was seated, standing in the almanac's own header separators. **All 1,437
are gone:** 1,435 converted by the table and proven by re-deriving the page from its committed
bytes, and **three read by hand** -- a multiplication sign in *four chapters x sixteen entries*, and
two half-episode numbers, `ep031.5` and `ep037.5`, whose ASCII form the tree had already written
twice in its own waymarks. The ratchet fell **2,773 to 1,336** and the ceiling **2,780 to 1,343**,
keeping the same seven of slack.

**Then the class was read instead of the page** (`20260910.061813`). Every sweep before this one
took the biggest single file; this one took the biggest single **kind**. Living `README.md` pages --
the front doors, the page a newcomer meets first -- carried **573 characters across 26 of them, 43
percent of the remaining 1,336**, spread thin enough that no page-at-a-time reading would ever have
reached them: the largest held 133 and the median 19. **All 573 are gone:** 564 converted by the
table and proven by re-deriving each page from its committed bytes, and **nine read by hand**, every
one taking a spelling the tree had already written elsewhere -- `3x39` from the very filename the
sentence links, `(2^8/2^16/2^32)` from `kumara/tilak.rye:23`, the module source that page describes,
and `a^254` from the form `crypto/` writes throughout. The ratchet fell **1,336 to 763** and the
ceiling **1,343 to 770**, keeping the same seven of slack. **The lesson is which axis to read
along:** a ratchet sorted by file names the loudest page, and a ratchet sorted by KIND names the
readers being served badly.

**The one character a hand had to read twice was one the table already named.** The rule's table
has spelled the **typographic minus** since seating, the Rye comment sweep converted 1,164 of them
on `20260908.224742` on exactly that authority -- and neither `ascii_document_scan.sh` nor
`ascii_document_convert.sh` carried the row. The scan called it **unnamed**, meaning *a reader must
choose*, about a form the law spells one way; the converter could not reach it at all. Both tables
carry it now, and three legs in the pen prove it from both sides -- `minus_counts_named`,
`convert_applies_minus`, `minus_reaches_zero_named`, the last of which reads yes either way and so
earns its place only beside the first. Removing either row reds two legs; the pen stands at **85**.
**A law and its instrument agreeing is a thing to measure rather than assume**, and this one had
disagreed by exactly one row for the whole life of the document meter.
**A front door outside every roster carried 36 more** (`20260910.054344`). `bat/README.md` sat in
the ratchet alone -- unwalled, since no rule room cites it and it stands outside `docs/` -- holding
21 middots and 15 em dashes across its head, its table and its body. All 36 are gone, every one a
form the table above spells; the ratchet fell **1,336 to 1,300** and the ceiling **1,343 to 1,307**,
keeping the same seven of slack. The page joined the `DOOR` roster of
[`../../tools/fixtures/p/prose_register_scan.sh`](../../tools/fixtures/p/prose_register_scan.sh) in
the same commit, which is the register wall rather than this one -- **a page can be walled for its
characters, for its negatives, or for neither, and those three memberships are decided in three
different files.** The lap that swept it also fixed the one em dash in
[`../../tools/b/bat_fleet_witness.rish`](../../tools/b/bat_fleet_witness.rish)'s own `say` line, so
the spoken meter's ceiling fell **11,154 to 11,153** beside it.

**The wall names who is HELD; the seed names whose citations are CANON.** One roster served both
jobs while it held only law rooms, and widening it made the difference matter: seeded from `docs/`,
every page a compressor links would have become canon. A rule room tells a reader which page to
read **first**, and that is a claim about law; a teaching room's links are links. So the scan
carries `ENFORCE_GLOBS` and `DERIVE_GLOBS` apart, and the derived roster still reads the two rule
rooms alone.

**Widening also found the fault that only widening could find.** Three readers asked whether a page
was walled -- the enforce loop, the derived roster, the ratchet -- and each answered by **typing the
roster again**. So the first widened run counted `docs/ZETA.md` in both rosters and priced its 43
characters **twice**. The set is enumerated once now, from the tracked listing, and all three ask it
the same question. Two further hazards rode in the elder spelling, each proven in the pen by
mutation: `for f in docs/*.md` **splits a path on a space**, so a spaced page inside a walled room
falls out of the wall in silence; and a `case` pattern's `*` **crosses a slash** where pathname
expansion's does not, so `docs/<subroom>/<page>.md` would leave the ratchet for a wall that never
enumerated it. **A walled room also reads dated testimony past** -- accrete-never-break outranks the
wall, and a teaching shelf may hold a dated page where a rule room never does.

**And the pen was speaking to a gate that heard 46 of its 82 readings.** `control_verdict=ok` says
only that the control reached its last line, so every one of the sixteen legs proving the derived
canon -- written the day before, and the whole substance of that widening -- could have read `no`
under a GREEN witness. The control tallies its own legs now and the witness asserts
`control_failed=0` beside the named readings, so a leg written tomorrow is heard the day it lands.

**Code comments**, in every comment syntax this tree authors: `tools/as/ascii_comment_witness.rish` holds three meters under ceilings that only fall -- `tools/fixtures/r/rye_comment_ascii_scan.sh` for `//`, `///`, and `//!` in Rye, `tools/fixtures/s/shell_comment_ascii_scan.sh` for `#` in Rishi and shell, and `tools/fixtures/g/glow_comment_ascii_scan.sh` for `::` in Glow. Each refuses to count **program content**, which is the distinction that makes a sweep safe: a Rye `\\` multiline string and a shell heredoc body are what a program prints or feeds onward, so converting them would change behavior rather than register. Glow needs no such exclusion, and the reason is the language's own: `glow/tokens.rye:239` refuses a newline inside a cord literal, so no Glow literal reaches a second line to open one with `::`. All three are proven on planted repositories, and every ceiling is proven from both sides -- one character past it refuses, and removing the plant returns the reading to green -- since a refusal proven only in the passing direction cannot be told from a bypass.

The reach was won by measuring, twice. The comment meter read `*.rye` alone for its first day, so 2,243 tracked Rishi sources and 580 shell sources stood outside a law that governs them, carrying **10,468** non-ASCII characters (measured `20260825.084500`). A sweep of the six forms this rule's own table names -- em dash, en dash, middle dot, two arrows, ellipsis -- converted 2,163 files and brought that to **505**, all of it notation the table leaves to a reader's judgment. Then two comment marks read as full coverage for a fortnight while **Glow**, an authored language of this tree's own, stood outside the law entirely: **942** non-ASCII characters across **342** of its 451 tracked sources, measured `20260907.141019`, and **all 942 inside a `::` comment with none in program content**. Of those, 921 are forms the table above names outright and 21 are the one form it leaves to judgment. **The sweep landed the same day** (`20260907.161048`): 342 files rewritten, **942 to zero**, every changed line a `::` comment and no program content moved -- so Glow's ceiling is a **wall**, and the next non-ASCII character to enter one of its comments reds on the lap it arrives. The 21 were read one at a time rather than guessed at, and both readings took an option this rule already names: thirteen sentences with a subject took the word **is**, eight parentheticals without one took **`==`**. **A finished sweep is also what taught the control its own fault** -- a pen planting three characters to give the counting readings a subject was the same pen asked whether it sat under the tree's ceiling, and at zero those two jobs part: three planted characters over a ceiling of nothing read as a failure for a tree that was clean. The ceiling legs run on a cleared pen now, and the two sibling meters will meet the same wall on the lap that finishes them. Measurement beats memory: a guard catches the next one on the lap it enters, rather than months later -- and a guard that names its languages by counting them catches the language nobody thought to name.

**The Rye half then met the question a table answers, and answered it once** (`20260908.224742`). Its residue stood at **3,772 characters across 310 files**, and the largest single class was the **typographic minus**, U+2212, at **1,164** of them -- every one in arithmetic prose a reader writes plainly, `2^255 - 19` and `n - (n-1)/3`. The other classes need a reader: a section mark, a multiplication sign, and a superscript each have two or three honest ASCII forms, and a script choosing among them guesses. A minus has exactly one, so the table above names it and the sweep made it -- **3,772 to 2,608 across 129 files**, ceiling lowered to meet it, every rewritten file **re-derived from its committed bytes** to prove nothing but a `//` line moved. **The lesson the table teaches is which work a script may do:** a form belongs in it once the answer stops being a judgment, and a form that stays out is a lap a person owes.

**What a guard says out loud** -- the fourth subject, and the one the opening sentence does not
name (seated `20260907.075500`): `tools/s/spoken_ascii_witness.rish` over
`tools/fixtures/r/rish_spoken_ascii_scan.sh`. Both comment meters decline program content because
converting a string changes what a program prints. A `say` line is what a program says **to a
person**, on their terminal and into `session-output/`, so converting one changes register, which is
exactly what this rule governs. **11,151 characters across 1,515 of 2,416 Rishi sources** stand
under a ceiling of 11,154, read `20260908.052550` -- very nearly the 10,468 the comment surface
itself carried the day its own meter was built, in the same files, under the same law, one sweep of
attention less.

**And that subject is about SPEECH rather than about Rishi**, which the heading said and the
instrument did not (seated `20260908.214712`): `tools/r/rye_spoken_ascii_witness.rish` over
`tools/fixtures/r/rye_spoken_ascii_scan.sh` reads what a **Rye** program prints. Rye speaks through
`print`, the Rye comment meter declines program content for the same one reason its Rishi sibling
does, and the tree therefore held a guard over what a Rishi program says and none over what a Rye
program says -- in the language it writes most of its own modules in. Measured on the seating lap
over the same 1,730 tracked `.rye` sources the comment meter opens: **3,996 characters in 809 of
them**, against the 3,794 the comment meter counts and holds. **A line-oriented reading would have
missed half its own subject**, since this tree writes a claim line as a chain of string literals
joined by `++` across four or five lines -- 2,480 characters stand on lines holding the call and
2,235 more on its continuations -- so the scan reads parenthesis depth outside string literals and
counts the whole region. `tools/fixtures/r/rye_spoken_ascii_convert.sh` reaches exactly what that
meter reads and nothing beside it, proven off the bytes rather than off its own report, and the
seating lap swept `mantra/` and `tally/` to zero -- 25 files, 101 characters -- and set the ceiling
at what remained.

**The residue that lap named is closed, and it was an escape hatch rather than a blind spot**
(seated `20260908.232949`): a `//` comment TRAILING a line of code was counted by neither meter,
since the comment meter reads only a line whose first non-blank is `//`. Its header excluded the
case for a reason about **capability** -- *finding it needs to know whether a `//` sits inside a
string, which is parsing rather than scanning* -- and that capability arrived one lap earlier in
the spoken meter, which walks parenthesis depth outside string literals over the same sources and
already steps past this exact `//` as the sibling's room.

**What made it worth a lap is the direction nobody had pressed.** Moving an own-line comment onto
the end of the preceding code line removes every character it carries from the numerator, converts
nothing, and reads as a sweep. The comment meter's own ceiling arc records the reverse move
happening by accident on `20260828.134500`, when three em dashes promoted from trailing comments to
their own lines made the count RISE. The same door swings both ways, and one direction lowers a
ratchet for free.

**Measured `20260908.232949`** over the same 1,730 tracked `.rye` sources: **1,319 characters
across 372 files**, roughly one comment character in four standing outside every meter. First
resident swept mantra and tally to zero -- 8 characters in 5 files -- and
`tools/fixtures/r/rye_comment_ascii_scan.sh` now prints a **second reading with its own ceiling at
1,311**, `trail_ceiling_ok`, spelled so no `case` pattern can catch one reading while matching the
other. **The elder ceiling stays exactly 3,794 with its arc intact**, because two gated numbers
close the hatch where one merged number would need a ceiling of 5,083 and read as a raise: a
comment moved between the positions lowers one reading and raises the other, so neither can be
improved by moving a character. Ten legs prove it under
[`../../tools/as/ascii_comment_witness.rish`](../../tools/as/ascii_comment_witness.rish), the
`https://` case planted from the shape standing at `tools/rye/session_logs_archive.rye:311`, and the
**pre-repair numerator run over the same move and shown calling it a fall** -- since a repair proven
only by the new number cannot be told from a number that was always there.

**The question was already asked one meter over.** `tools/fixtures/g/glow_comment_ascii_scan.sh`
named this blind spot on `20260907.141019`, printed its size as `trailing_unread`, and wrote that
*both siblings name the same blind spot in prose and neither prints it, so a reader there cannot
tell an empty blind spot from a large one.* Glow's was genuinely **zero**; Rye's was 1,319. The
third sibling, `tools/fixtures/s/shell_comment_ascii_scan.sh`, still carries the hole unclosed, and
its **upper bound is 90 characters across 40 of 3,353** tracked Rishi and shell sources, read the
same stamp -- an upper bound rather than a count, since a `#` inside a shell string needs the same
walk to tell from a comment. Small, and open; the shape of the risk differs by language.

**And a FIFTH surface stood behind all four, which every meter above reads past by construction**
(seated `20260911.215028`): what a program **assembles into a buffer and hands onward** -- to a
file, a wire frame, or a generated page. Each meter above reads what a source COMMENTS or what a
program PRINTS. None reads what it WRITES, and that is the surface this law was born on, since REDS
%83 was a persisted document a tool rewrote into mojibake. **The exclusion covered two
populations:** `rye_spoken_ascii_scan.sh` steps past every literal outside a `print` call and gives
its reason -- *a module testing a decoder must contain the character it decodes* -- which is exactly
right about a decoder's own fixture and says nothing about a header a program writes into every
artifact it pours. `tools/r/rye_written_ascii_witness.rish` over
`tools/fixtures/r/rye_written_ascii_scan.sh` reads the half that reason does not cover: non-ASCII
inside a `bufPrint`, `bufPrintZ`, `allocPrint`, or `writeFile` region, by parenthesis depth outside
string literals, every call name read as a WHOLE identifier -- the trap is sharper here than in the
sibling, because the names this meter opens on END IN the name that one opens on. Measured on the
seating lap over the same 1,743 tracked `.rye` sources: **292 characters across 49 files, and all
292 are forms the table above spells** -- unlike the comment ratchet, where notation needs a reader
to choose the word, assembled text is a sentence somebody wrote for somebody to read. **Two of them
stood in a file that also writes one**, and that reading is a **wall at zero** rather than a
ratchet, because both were repaired on the seating lap: `amphora/src/main.rye` assembles the header
inside every sealed vessel this tree pours, and `tools/rye/enrich/enrich_file.rye` assembles
Markdown and writes it into documentation pages -- **a generator feeding the gated document meter,
standing outside every meter.** Two tracked pages in a `yonder/` shelf carry that character on disk
still; the generator is what was repaired, so the next regeneration is clean. The persisted reading
is a **file-level proxy named as one** in the scan's own header, since where a buffer lands is
dataflow a scanner does not follow. Forty-one behaviors stand proven on real git repositories in a
throwaway pen under
[`../../tools/fixtures/r/rye_written_ascii_control.sh`](../../tools/fixtures/r/rye_written_ascii_control.sh),
every refusal planted and then lifted, two mutations asserted to bite, and the control's own leg
tally asserted beside its verdict. **The shell half stays open** and its size is named rather than
guessed: `tools/fixtures/a/amphora_pour.sh` writes a vessel header carrying an em dash and
`tools/fixtures/a/amphora_vessel_lap1.bron` is a stored vessel carrying one -- 2 characters in 2
files, both inside `fixtures/`, which every meter in this family reads past by design.

## Why the rule exists

Plain ASCII survives every tool, terminal, diff, and re-encoding intact. Keaton asked that documents and commits prioritize it after the operator card corrupted itself in the dark. Canonical Cursor twin: `.cursor/rules/ascii-first.mdc`.
