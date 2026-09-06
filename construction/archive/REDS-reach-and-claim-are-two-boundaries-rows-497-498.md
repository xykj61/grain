# REDS shelf -- what an instrument examines and what it claims are two different boundaries

**Language:** EN
**Style:** Gauge, Meter setting (see [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Shelf -- immutable once written
**Folded:** `20260906.141607` from [`../REDS.md`](../REDS.md)
**Rows:** `%497` `%498`

Two rows from one lap, folded together because they are the same fault pointing opposite ways, and
because the pin stood 9 bytes under its bound before either was written.

**What they taught together, in one line.** An instrument makes two promises -- *this is what I
examined* and *this is what I am telling you about* -- and nothing in a green reading holds them to
each other. `%497` is that gap too NARROW: a witness calling two functions forces two bodies
through analysis, walks past every other declaration, and prints green over the whole module it is
named for. `%498` is the same gap too WIDE: a reading matched every script that spells a Rye path
and reported them as harnesses whose stem lists it could not read, so its ceiling rose whenever
anybody wrote an ordinary census.

**Why the wide one is the harder to see.** A narrow instrument fails to catch things, and a planted
fault exposes it in one try. A wide one catches too much and calls the excess a *residue* -- an
honest-sounding word for a number nobody has to explain -- and it grows on correct laps, which is
exactly when nobody is looking. `%498`'s residue had a ceiling, and a ceiling that rises on honest
work is a ratchet turned backwards.

**And the narrow question was already being asked one file downstream.** The consumer of `%498`'s
scan weighed the same residue by *does this script compile* and held it at 1, while the producer
published and gated the unfiltered 10. One question, two readings, two files, and only the far one
correct -- which is `%470`'s sentence, that five guards asking the same kind of question are no
safer than one, met from the other side: two guards asking genuinely different questions, and the
one nearer the subject asking the looser.

**Both numbers moved before they landed.** These rows were booked as `%492`/`%493`, then `%493`/`%494`, then `%496`/`%497`, and again as
`%493`/`%494` while peers published their own at earlier stamps; the derived-spine law gives a
published number to whoever reached the anointed spine first, and confines renumbering to the
unshared. A third row from the same lap was **withdrawn whole rather than renumbered** -- it booked
the `sow_allow_reach` guard, and a peer had booked exactly that at `20260906.133724`, which stands
published as `%493`.

---

**REDS %497 (`20260906.131501`) -- a witness proves what it CALLS, and prints GREEN over the module it claims.** *What went wrong:* Zig analyses lazily, so a witness importing a module and calling two of its functions forces exactly those two bodies through semantic analysis and walks past every other declaration. A public function carrying a flat type error therefore rides through the build untouched while the witness, its claims, and its own control all read GREEN. *What caught it:* planting one. A `pub fn` assigning a `u32` to a `[]const u8` was appended to `mantra/src/weave.rye`, nothing else was touched, and `tools/m/mantra_weave_merge_witness.rish` read **GREEN** -- including the five-break control that exists to prove that witness can red. **The file next door to `%470`'s**, guarded by the sibling of the witness whose own header names this gap: *the tree-wide instrument for this question is a peer's lap*. *What it taught:* **`%470` said five guards are no safer than one when all ask the same KIND of question; this is the same sentence one level up -- 130 witnesses asked the same kind, and one asked a different one.** A green is a claim about what ran, and a witness's name is a claim about a module; only a walker makes the second follow from the first. *The measurement:* of **134** tracked `*_witness.rye`, **130** import a tracked sibling, **121** name a subject, **9** are ambiguous -- and `walked` stood at **1**. *Repaired:* the four-line comptime walker landed in `mantra/src/weave_merge_witness.rye` (**walked 1 -> 2**), proven three ways on metal -- the elder sails past the plant, the new one reds on it, and the new one still greens on honest bytes. `rye_witness_walker_scan.sh` gates `unwalked` at **119, no slack**, so the next unwalked witness reds on the lap it arrives; `rye_witness_walker_witness.rish` rostered `tier lap` at **24s**; control **37 behaviors**, the ceiling proven both ways by planting 120 pairs rather than by an override the scan does not offer. *Three faults the control found in the census itself, each a lesson this tree had already paid for:* the `@typeInfo(m).@"struct".decls` pattern read the tree's only real walker as **absent**, since the quoted field name's own letters defeat a character class trying to skip it; the stem rule read `weave_merge_witness.rye` as claiming **nothing**, so the very file the census was built from fell outside it, fixed by crediting a witness that imports exactly one sibling; and two refusals **exited before printing what they read**, which is `%480` one guard over. *The residue, published rather than dropped:* `ambiguous` names the 9 that do not say which module they prove, and `unreached` carries the walker's own condition -- a walker in a file no build compiles forces nothing -- gated at zero and reading **-1** where the compile-reach resolver cannot answer, since an unknown belongs published as unknown (`%488`). **BOOKED** *(the ratchet is the remainder: 119 witnesses claim a module they only partly analyze, and each falls on touch).*

**REDS %498 (`20260906.140206`) -- a reading named for harnesses had grown into a count of every script that mentions a Rye path, and its ceiling rose whenever anybody wrote a census.** *What went wrong:* `tools/fixtures/r/rye_harness_roster_scan.sh` decided what a harness is with one regex -- `${A}/${B}.rye` appearing anywhere in a tracked shell source -- and every match whose directory and stem list it could not read became `unresolved`, a ratchet gated at **10**. Handing that path to the rye driver was never checked, so a census resolving a module path in order to **read** it landed in the same bucket as a suite that builds 116 programs. *What caught it:* my own lap. `rye_witness_walker_scan.sh` (`%497`) resolves a subject as `$dir/$stem.rye` and builds nothing, became the eleventh site, and took the guard one over its ceiling on the cold open. *The measurement:* of the **eleven** sites standing, **ten invoke no builder at all** -- six roster guards comparing a directory against a page, three pens planting a corpus, one witness census. Only `caravan_reply_control.sh` both assembles and builds. *What it taught:* **a ceiling meant to bound an instrument's blindness was bounding the tree's ordinary work, so it rose on honest laps and told nobody anything.** And the narrow question was already being asked one file downstream: `rye_compile_reach_scan.sh` weighs `harness_unresolved_compiling` at a ceiling of **1** -- the consumer filtered the residue by *does this script compile* while the producer published and gated the unfiltered number, which is one question with two readings in two files and only the far one correct. *Repaired:* the predicate is the scan's **own** build-site awk program, lifted out of count-mode and run over each candidate, so a build is whatever this scan already says a build is rather than a second spelling that could drift. A non-building assembler is counted in the open as `assemblers_not_harnesses` and named by `--list`, never dropped (`%463`). Ceiling **10 -> 1**. *Two faults the repair found in the instrument it reused:* the census read **shell spellings only** -- it stripped quotes from the driver token and the target and not from the VERB, so Rishi's `run ["env" rye "build" "x.rye"]` was invisible, **47 sites** of 3,127 scripts (2,120 -> 2,167), a blind spot that grows as operational shell molts to Rishi by standing law; and the three site classes **were never disjoint**, since `${dir}/${s}.rye` matches both the literal and the assembled pattern, so it was counted twice and `sites_unparsed` absorbed the difference as if it were prose -- understated **9 -> 26**. The elder arithmetic could only understate, never go negative, so it looked like a small honest residue until the Rishi spelling landed and the residue read **-2**: **a count that cannot go below zero cannot tell you it is wrong.** *Proven:* control **32 -> 41** behaviors, the narrowing shown by two pens holding the same script under the same name differing in one line, the ceiling planted both ways at 1 and 2, and the consumer's own control carried across (case 23 reads 0 where it read 1, and both witnesses stand GREEN). **CLOSED.**
