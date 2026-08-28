# REDS -- row %299, folded from the living pin

**Folded:** `20260827.200419` -- **Status:** Archived, complete, never edited
**Living pin:** [`../REDS.md`](../REDS.md) -- **Law:** [`.claude/rules/reds-first.md`](../../.claude/rules/reds-first.md)

*The row where rostering six witnesses found a build that had been broken for twenty-three days --
and the alias fault underneath it: an alias to a module is an alias to its neighbours.*

A file symlink and a directory symlink sat on consecutive lines and only one of them carried a
module's siblings. `tally/gardens.rye` reaches `region.rye` by bare name, Zig resolves that beside
the file it followed the link to, and no `region.rye` stood in the plant cache. Every
`gardens_lawful` plant failed to build, behind six witnesses nothing ran.

Its wider half travels forward as the reason this tree rosters at all: eighty-nine Glow witnesses
stood with zero on the standing roster, writing green claims nobody asked for. A witness earns its
keep on the day someone runs it.

---

**REDS %299 (`20260827.183635`) -- a flat symlink hid a broken build for twenty-three days, behind six witnesses nothing runs.** *What went wrong:* `tools/g/glow_run_worker.sh:172` aliased the Tally vane into the plant cache as a **file** -- `ln -sf ../../tally/gardens.rye glow/.cache/tally_gardens.rye` -- while the line beneath it aliased Caravan as a **directory**. `tally/gardens.rye` imports `region.rye` by bare name at its line 47, and Zig resolves a bare import beside the file it followed the link to, which is `glow/.cache/`, where no `region.rye` stands. So every `gardens_lawful` plant refused to build with `could not read 'glow/.cache/region.rye': FileNotFound`, taking **STOA344** down and, with it, `glow_compose_tend_unary_witness` and the `glow_compose_after_inc_witness` that asserts the unary ground stays warm. Caravan never had the fault, because a directory alias carries a module's siblings and a file alias carries one file. *What caught it:* rostering. Six Glow witnesses were reached by **no runner, roster, or suite at all** (measured `20260827`), so running them before seating them was the first time any hand had asked. One of the six was red, and it had been red since the last commit that advanced the language, `43638521d` on **2026-08-04** -- twenty-three days. *What it taught:* **an alias to a module is an alias to its neighbours.** A module is only ever one file when it imports nothing, and a language whose own module system resolves bare names beside the importing file makes the flat symlink a shape that works exactly until the target grows a sibling. The wider half is the one this tree keeps relearning at a new door: **89 Glow witnesses stood with zero on the standing roster**, so the language's whole proof surface was writing green claims nobody asked. A witness earns its keep on the day someone runs it. *Repaired (`20260827.183635`):* both aliases link the directory, `vane_decide_import` emits `@import("tally/gardens.rye")` on the module path the way `caps_lawful` already emitted `caravan/capabilities.rye`, and all six witnesses are GREEN on metal and seated on `construction/standing-equipment.kyri`. CLOSED.
