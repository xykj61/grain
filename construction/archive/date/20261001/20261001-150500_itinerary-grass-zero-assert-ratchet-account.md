# Shelved account -- GRASS, the last zero-assert file took its two invariants

**Status:** Archived -- shelved whole from `construction/ITINERARY.md` on `20261001.150500` under
[`the-writer-sheds`](../../../../.claude/rules/the-writer-sheds.md). Living pointer stands on the card.

---

**GRASS -- THE LAST ZERO-ASSERT FILE TOOK ITS TWO INVARIANTS.** `tame_style_check`'s own ratchet
named one file standing outside every honest exemption: `comlink/roster_pairs_seal.rye`, a 29-line
self-test sealing the four roster pairs and opening them back. It carried no `assert(` call at all,
relying only on `if (...) return error.X;` for its round-trip checks. Added the opening triad
(`std`, `assert`, `print`) and two `// invariant:` asserts naming what the test itself never
checked -- the four pairs fit the protocol's `max_message` bound before sealing, and the sealed
length never exceeds the buffer it was sealed into -- leaving the round-trip's own `if` checks as
they were, since failing those is the test's actual subject rather than a construction invariant.
`tools/co/comlink_roster_pairs_seal_witness.rish` GREEN on metal after the edit; `zero assert(
files remaining` fell **1 to 0** and `tame_style_check` stays GREEN. **No YOURS here** -- the
ratchet's one open file is now zero.
