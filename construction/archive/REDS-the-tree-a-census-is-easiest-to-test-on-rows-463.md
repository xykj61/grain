# REDS shelf -- the tree a census is easiest to test on is the tree its worst defect hides in

**Language:** EN
**Style:** Gauge, Meter setting (see [`../../context/GAUGE_STYLE.md`](../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Shelf -- immutable once written
**Folded:** `20260906.150954` from [`../REDS.md`](../REDS.md)
**Rows:** `%463`

One row, opened `20260906.045552` and closed `20260906.150954`, folded alone because the pin stood
498 bytes over its bound the moment the row that succeeded it was written.

**What it taught, in one line.** A census that has read nothing answers *nothing is wrong*, and on a
healthy field that answer is indistinguishable from the truth. The `NR==FNR` idiom holds while the
first file is read, and an empty first file is never read at all -- so in a tree carrying no
symlinks every corpus path fell into the link table and five readings, the graph walk among them,
printed zero. This field's link map holds 227 entries, so all five read correctly and nothing
showed. The control's pens caught it on their first run: 19 of 50 planted behaviors failed at once,
every one from that root, because **a pen small enough to read is a pen built without symlinks.**

**The second half, sharper than the first.** The census disarmed its own gate by being committed.
Its source carries the compiler-detector patterns as literal strings and named the accused module in
a comment, so the moment `git ls-files` began listing it, the scan classified **itself** as a
compiling runner and credited every path it mentions. `asserted` fell 1 to 0 on the commit that
added the file, with nothing about the accused module changed. It read green because it was reading
its own reflection and reporting the room empty -- this row's own lesson turned back on the
instrument that found it. The scan and its control are excluded by name, and a control case plants
an orphan inside the scan's own comments and holds it accused.

**How it closed.** The row stayed open on one condition: the accused file wanted a probe beside it,
and the comptime declaration walker was the instrument. `mantra/src/diff_witness.rye` carries that
walker; `tools/m/mantra_diff_witness.rish` breaks the module seven ways in a pen and reads GREEN;
the census answers `asserted=0`. The walker then spread -- 63 Glow witnesses took it in one pass on
`20260906.150954`, all 63 built, and what its `unreached` leg found on the way is `%504`.

**The measurement it delivered, kept here because the numbers are the finding.** Of 1,940 tracked
`.rye`, 227 symlinks and 1,713 distinct; 1,535 reached by a build root or an import from one; 178
not -- 41 planted specimens under `fixtures/`, 114 tests in `rye/tests/` no runner names, and one
carrying a runner's claim while nothing compiles it. Every count is a floor, since a runner touching
the compiler credits every path it names. Resolution comes before accusation: without it, 17
symlinks read never-compiled and 16 pointed at a file that IS compiled. `rye_compile_reach_control.sh`
proves 53 behaviors across sixteen real repositories, the ceiling both ways and the pen proven
innocent.

**What it did not answer, said plainly.** This census answers only the graph question -- which files
no build reaches -- and nothing about whether the reached ones are sound. A probe built by importing
a module and reading a signature is blind: Zig analyses lazily and walks past a planted type error,
which was proven by planting one. That blindness is `%470`, and the walker above is its answer.

**REDS %463 (`20260906.045552`) -- a census that reads two files answers *nothing is wrong* when it has read nothing, and on this field that fault is invisible.** *What went wrong:* the first draft of `tools/fixtures/r/rye_compile_reach_scan.sh` -- the census `%449` booked -- loaded the symlink map with awk's `NR==FNR` idiom before walking the corpus. `NR==FNR` holds while the **first** file is read, and an empty first file is never read, so in a tree carrying no symlinks every corpus path fell into the link table and nothing was printed: `distinct=0`, `asserted=0`, `verdict=ok`, exit 0. **Five places in one scan** used it, the graph walk among them. This field's link map holds **227** entries, so all five read correctly and nothing showed. *What caught it:* the control's pens on their first run -- **19 of 50** planted behaviors failed at once, every one from that root, because a pen small enough to read is a pen built without symlinks. *What it taught:* **the tree a census is easiest to test on is the tree its worst defect hides in**, and a census answering zero of everything is indistinguishable from a healthy tree. `%442`'s family with the reading at **zero** rather than partial. Repaired by naming the file (`FILENAME == linkfile`) rather than counting records. *The measurement it delivered:* of **1,940** tracked `.rye`, **227** symlinks, **1,713** distinct; **1,535** reached by a build root or an import from one; **178** not -- **41** planted specimens under `fixtures/`, **114** tests in `rye/tests/` no runner names, and **one** carrying a runner's claim while nothing compiles it, `mantra/src/diff.rye`. **Every count is a floor:** a runner touching the compiler credits every path it names, since a root arrives by literal, variable, and function parameter. **Resolution before accusation:** without it, 17 symlinks read never-compiled and **16 pointed at a file that IS compiled**; links resolve through `git ls-files -s` and `git cat-file`, so no `readlink` is wanted. *And a claim of my own, retracted before it shipped:* I built `diff.rye` through an importing probe and called it type-checked. **That probe is blind** -- Zig analyses lazily and walks past a planted type error, proven by planting one. A peer measured the same blindness the same night against `%449`'s own broken bytes, where `rye build-lib` exits **zero**; the comptime declaration walker that answers is theirs. **This census answers only the graph question -- which files no build reaches -- and nothing about whether the reached ones are sound.** `rye_compile_reach_control.sh` proves **50 behaviors** across sixteen real repositories, the ceiling both ways and the pen proven innocent; witness rostered `tier lap` at **5s**. *Repaired further (`20260906.054500`), and this one is the sharpest of the three:* **the census disarmed its own gate by being committed.** Its source carries the compiler-detector patterns as literal strings and names `mantra/src/diff.rye` in a comment, so the moment `git ls-files` began listing it, the scan classified **itself** as a compiling runner and credited every path it mentions -- `asserted` fell **1 -> 0** on the commit that added the file, with nothing about the accused module changed. It read green because it was reading its own reflection and reporting the room empty, which is this row's own lesson turned back on the instrument that found it. The scan and its control are excluded **by name**, and a control case plants an orphan inside the scan's own comments and holds it accused -- proven from the failing side, where removing the exclusion answers `control_verdict=broken`. **53 behaviors now.** **CLOSED** (`20260906.150954`) *(the probe stands beside the accused file and is proven on metal: `mantra/src/diff_witness.rye` carries the comptime declaration walker, `tools/m/mantra_diff_witness.rish` breaks the module seven ways in a pen and reads GREEN, and the census answers `asserted=0`. The walker then spread: 63 Glow witnesses took it in one pass, all 63 built, and `%504` is what its `unreached` leg found on the way).*
