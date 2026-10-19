# Order -- the one ordering that TAME core, the rota, and the stamps share

**Status:** Living
**Room:** checkable

The single statement of the ordering rules this tree follows. The pages that use an order
point here rather than restating it. Referenced from the clean-slate tree's `context/order.md`
(`grain-ww/20261015-grain`), adapted for petrichor's existing rule pages.

## The shared rules

1. **One clock.** Every order reads one clock. For dated files that clock is the one-clock
   stamp, `YYYYMMDD-HHMMSS`, read in `America/New_York` on this pier. For rounds it is the
   commit count, `git rev-list --count HEAD`.
   **Rule home:** `context/specs/20260627-102012_one-clock-naming-law.md`

2. **Later is larger.** A later stamp or a higher count is a later state. Nothing is ordered
   by a label that could be reordered.
   **Rule home:** `.claude/rules/stamp-and-name.md`

3. **Count, do not number.** A count is read from the clock when it is needed. It is never
   typed into a name or carried as a fixed total. A total is derived by measurement --
   `git log --oneline | wc -l` -- so it stays true as the work grows.
   **Rule home:** `.claude/rules/stamp-and-name.md`

4. **Living and dated are different.** A living file has no stamp in its name and is edited
   in place. A dated file keeps its stamp and its words; a correction goes in an errata
   beside it, or in a living mutant at a fresh stamp.
   **Rule home:** `.claude/rules/stamp-and-name.md` - `.claude/rules/molt.md`

5. **Each number is bounded and says why.** A bound states the largest value a loop, buffer,
   or count may reach, and the reason for it sits beside it, as TAME core asks.
   **Rule home:** `context/TAME_CORE.md` - `.claude/rules/tame-guidance.md`

## Where each rule is used

- **Rounds and orbits** read rule 1 and rule 3 through the commit count. See `context/SPELLBOOK.md`
  (Calfive planning).
- **Dated files and their versions** read rule 1, rule 2, and rule 4. See `.claude/rules/stamp-and-name.md`.
- **Code and its bounds** read rule 5. See `context/TAME_CORE.md`.
- **A Rye version** is chronological by its stamp, and a living source keeps its plain name.
  See `context/specs/rye-versioning-style.md`.
