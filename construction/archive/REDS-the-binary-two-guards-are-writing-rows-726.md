# REDS -- the binary two guards are writing

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- a ledger row, its class measured on metal and held by a rostered witness
**Folded:** `20260912.020211` from [`../REDS.md`](../REDS.md)

One row, born on its shelf because the pin had no room for it -- `reds_pin_capacity_scan.sh` read
`pin_deadlocked=1`, `rows_that_fit=0`, `pin_foldable_rows=0`, the same door `%718`, `%720` and
`%723` came through on the laps before it. Booked `%724` from a spine read at the lap's open and
**renumbered to `%726` on the send's rebase**, since `xy` bound `%724` and `%725` while this lap
ran -- the derived spine's own rule, and it cost one file, because every other citation of this row
already spelled its stamp.

The row below is the harness room's reading of a question nobody had asked: a guard that builds a
binary has to put it somewhere, and 110 of 125 emit sites put it in the tree.

---

**REDS %726 (`20260912.020211`) -- a guard's build output lands at a path no other reader knows is busy,
and 110 of 125 emit sites do it.** *What went wrong:* `tools/fixtures/b/build_target_scan.sh` reads
`construction/standing-equipment.kyri` and the 353 witness sources it names: **60 guards pass a
`-femit-bin=` argument to `rye build`, across 125 emit sites, and 110 of those name a fixed path
inside the tree** rather than a directory the run made for itself. Fifty-one distinct paths stand
behind those 110, and **six are written by two or more distinct guards** -- `amphora/bin/vessel-seal`,
`amphora/bin/vessel-core` and `amphora/bin/amphora` by **eighteen apiece**. The cost is measured
rather than argued: `rye build` writes **through** its output file, proven by the inode surviving a
rebuild, so a concurrent reader executes a partial binary. Over 400 executions of a tiny program on
this pier, a reader whose own path was written by nobody failed **0** times, by one other build
**335**, by three **275** -- shell codes 126 and 127, *cannot execute*. *What caught it:* asking
where a guard's build output goes, which no instrument in this tree had asked. The occasion was
`%700`, a rostered guard reading red and then green on one unchanged tree, whose own row named two
builds into fixed tree paths as a suspicion and could not price it. *What it taught:* **the lock that exists is drawn on the other
axis.** `rye build` already serializes builds against builds -- `.rye-build.lock`, which `%281`
booked and `tools/r/rye_build_lock_reach_witness.rish` holds -- so the three-writer reading above
did not race at all; all three took that lock and went in turn. The **single-writer** reading, where
no build race exists whatever, is the worst of the three at **335**, because one uninterrupted build
holds the file open longer than three taking turns. Nothing anywhere serializes a build against a
**run**. And `standing_equipment_run.sh` holds a
directory lock so no second roster pass opens over the first, and that lock reaches neither a hand
running a guard by name -- which the baton and the read-scope law both tell every ship to do -- nor
a detached pass from a dead lap still working the roster, which **this lap met at its own open**.
With eighteen guards on one path, a hand running any one of them can be executing the file a pass is
building for any of the other seventeen reasons -- eighteen chances over one filename rather than
one. *Standing:* two walls at **zero, enforced** --
`emit_tracked`, a build output the repository carries, and `emit_unignored`, one git would show and
which would move the runner's own tree digest -- and two ratchets under ceilings that only fall,
`emit_fixed` at **110** and `shared_paths` at **6**, so a NEW guard building into a fixed tree path
reds on the lap it lands. The named escape is one line: `d=$(mktemp -d)` and `-femit-bin=$d/<name>`,
which 15 sites already spell. Proven by `tools/fixtures/b/build_target_control.sh` -- **33 legs** on
real git repositories in a throwaway pen, every refusal planted and then lifted, two mutations
bitten. *And the scan's own first draft was wrong in the loud direction:* a literal that itself
holds a variable, `let elder_dir = "${home}/elder"` where `home` reaches a real pen through two
further bindings, read as a fixed tree path, and **ten amphora sites already doing the right thing
were counted as tree writes**. The resolution iterates now, bounded at four hops, and the control
plants that exact shape. *Not taken:* the 110 standing sites are a per-lane sweep rather than this
lap, and the cheapest first move is the amphora family. *Not proven:* whether `%700` is this fault.
That guard's two paths are written by no other guard, so what this row adds to `%700` is that the
mechanism it guessed at is real and large -- and that it is not the mechanism that row pictured,
since no second build is needed for it. **BOOKED** -- the class is
measured, both walls hold, and the remainder is a ratchet.
