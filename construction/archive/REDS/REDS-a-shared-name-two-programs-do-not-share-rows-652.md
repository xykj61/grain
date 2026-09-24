# REDS -- a shared name two programs do not share

**Language:** EN
**Status:** Shelf -- one folded row from `construction/REDS.md`, kept whole
**Voice:** Kyri -- **Room:** checkable
**Folded:** `20260908.213230`
**Row:** `%652` (`20260908.212614`) -- CLOSED, and renumbered once. The spine answered
`next_free=647` at this lap's open; peers spent 647 through 651 while the row stood unshared, over
two rebases, so it derives above them (`derived-spine` rule 3). The key never moved -- it is the
stamp, and nothing else in this round had to change with the number.

The row folds on the lap it closed, for the reason its neighbours record one shelf over: the living
pin stands within a few hundred bytes of its bound with almost every remaining row OPEN, and a pin
whose living parts fill it cannot accept a new one.

What the row is for, said once here so a reader arriving from a citation knows before they read.
Two files in this tree carry the same filename stem, and the Glow desk runner reads a stem to
decide where to write a built binary, where to cache a lowering, and whether a file may be handed
a sample argument. Two rows before this one read that sharing as a fault awaiting a ruling about
which file keeps the name. Both files must keep it: one is the language's own desk, the other is
the copy the product binary embeds, and the compiler's own import rule is what forces the second
copy to sit where it sits. The two files are the same bytes, so the shared binary, the shared
cache and the single permission all hold the same program -- and the guard now says so by reading
`cmp` rather than by asking for a ruling.


**REDS %652 (`20260908.212614`) -- a ratchet stood at one for a pair that is correct by construction, so the gate could not see the only fault that pair can have.** *What went wrong:* `tools/fixtures/g/glow_desk_reach_scan.sh` held `stem_collision` at a ceiling of **1**, and both `%539` and `%613` named the remaining pair -- `sample-demo-fact-line-lits.glow` under `glow/gen/s/` and `linengrow/gen/` -- as a language custody ruling about which file keeps the name. **Neither file may leave.** `linengrow/glow_seva_b0_line.rye` binds `lit_desk_embed_relpath = "linengrow/gen/sample-demo-fact-line-lits.glow"` and embeds it into the product binary, and Zig refuses an `@embedFile` that escapes the root file's directory -- the same directory rule that gathers `tools/rye/`. So the second copy is forced by the compiler, and the two files are **byte-identical**, proven by `diff -q` and already witnessed by `tools/s/stoa237_native_embedded_desk_witness.rish`. A ceiling of one over a pair nobody may repair is a ceiling that only ever falls by accident -- and worse, it made this guard blind to the single fault the pair CAN have: had the twin drifted, `stem_collision` would still have read **1** and the verdict would still have read `ok`. *What caught it:* the fire rota, whose test is to look straight at the thing a lap would route around. The custody ruling had been standing in front of the reading for two rows, exactly as `%613` recorded one room over -- *the cure was subtraction rather than a ruling, and the ruling had been standing in front of it.* Asking what the collision actually **costs** is what split it. *What it taught:* **a shared name costs nothing when the two files are the same program.** The cost the reading names -- one built binary at `glow/bin/<stem>`, one cache path, one sample permission matched on the stem alone -- is a cost two DIFFERENT programs pay: identical bytes build the same binary, lower to the same cache, and want the same arity. `cmp` reads that in one command, needing no marker in either file and no ruling about which keeps the name. *Repaired (`20260908.212614`):* the scan splits the shared stems by `cmp` -- `stem_collision` counts stems whose files differ and is **gated at zero**, `stem_twin` counts byte-identical pairs and is reported. The tree reads `stem_collision=0`, `stem_twin=1`. A differing pair now reds on the lap it arrives, **and so does this pair the day it drifts**, which the elder ceiling could never say. `tools/fixtures/g/glow_desk_reach_control.sh` proves **91 behaviors** (was 86): `desk2()` plants bytes differing from `desk()`, so the shared stem is planted BOTH ways -- differing files refuse with a non-zero exit, identical files walk free and count as a twin, and appending one line to a twin turns the pen from green to a refusal. *Not taken:* the three fourth-kind files `%532` named still carry no marker in either name or head, and what declares a desk's kind stays a language custody ruling. **CLOSED** on `glow_desk_reach_witness.rish` GREEN.
