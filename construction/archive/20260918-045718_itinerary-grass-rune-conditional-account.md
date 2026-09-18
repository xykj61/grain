# Shelved GRASS account -- rune_conditional.rye gained three asserts, same shape

**Status:** Historical -- shelved whole from `construction/ITINERARY.md` on `20260918.045718` under
[`the-writer-sheds`](../../.claude/rules/the-writer-sheds.md). The living card holds a two-line
pointer to this file; nothing here is rewritten.

---

**GRASS -- `glow/rune_conditional.rye` GAINED THREE ASSERTS, SAME SHAPE.**

Continuing the rune-family TAME sweep that took `glow/rune_bounded_trap.rye` and
`glow/rune_cell.rye` (its elder, same lap), this lap took `glow/rune_conditional.rye` -- the `?:`
if/then/else rune head parser. Three bare `assert()` calls added across two functions:

1. `test_slice`'s postcondition -- the trailing-NUL scan never returns a length past the buffer's
   own `max_test_len` ceiling.
2. `parse`'s precondition after the missing-test check -- a line accepted past that check names a
   real, non-empty remainder.
3. `parse`'s postcondition on the constructed `IfSpec` -- the copied test text never claims more of
   the fixed buffer than the length check already proved fits.

`const assert = std.debug.assert;` was newly imported; the file previously carried zero asserts.

**PROVEN:** `rune_conditional_witness` GREEN unchanged, all six claims passing byte-for-byte the
same as before the asserts (parenthesized test, trailing then/else arms, bare identifier, NotAnIf,
MissingTest, and the three MalformedTest shapes). `tame_style_check`'s zero-assert-files ratchet
fell by one; `glow/rune_conditional.rye` no longer appears in its "functions past 70 lines / zero
assert" review list. `width-check` clean, no change to the width surface.

Claim `grass-rune-conditional-asserts` was opened and pushed (paths
`glow/rune_conditional.rye`) before the build, per the baton's ABSENCE clause -- the claim board
read `verdict=clear` both before and after a round-open pull brought the tree current -- and closed
after the work landed.

**YOURS:** nine zero-assert `glow/` files remain in the same shape -- `rune_face.rye`,
`rune_list.rye`, `rune_mutate.rye`, `rune_null.rye`, `rune_quad.rye`, `rune_switch.rye`,
`rune_triple.rye`, `lower_alias.rye`, `lower_cast.rye` -- agent-doable next lap.
