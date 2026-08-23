# Curtis Yarvin -- Nock, Hoon, and the small combinator at the bottom

**Scope of this note, stated first.** This thanks **one body of technical work**: the design of
**Nock** and **Hoon**. It speaks to that design and stops there. The author's writing outside
computing is outside this note, carries no endorsement here, and has no bearing on the ideas
below, which stand or fall on their own merits as language design.

**Honors:** the design of a combinator calculus small enough to specify on a page, and a language
that compiles to it while staying readable by people.

**Role for us:** Glow descends from these ideas the way any language descends from the ones its
authors read. We study the design and write our own, per
[`../context/SILO_TECHNIQUE.md`](../context/SILO_TECHNIQUE.md). `glow/nock/` exists so Grain can
meet that world and be checked against it.

**What we carry**

- **A specification small enough to hold in your head.** A reduction rule set that fits on one
  page can be implemented independently, checked against itself, and trusted for decades. Our own
  bounded, asserted discipline aims at the same property from a different direction.
- **Referential transparency as a working promise rather than a slogan.** The same input yields
  the same output, always, and a system built that way can be replayed, audited, and reproduced.
  **Mantra** is our answer to that promise: ask for a name, receive the same bytes forever.
- **Runes as a terse vocabulary of structure.** Short symbolic heads naming the shape that follows,
  learnable as a small alphabet rather than a large keyword list. Glow's grammar is our own
  version of that idea, with our own runes and our own semantics.
- **A frozen kernel as a foundation.** A base layer that stops changing lets everything above it
  make promises it can keep.

**What we leave**

- **Nock and Hoon themselves.** Glow is its own language with its own semantics, lowering to
  **Rye** and to RISC-V rather than to a virtual machine.
- **The vocabulary.** Our words are our own, chosen by the plainest-warmest-safest test in
  [`../.claude/rules/comlink-tendency.md`](../.claude/rules/comlink-tendency.md).
- **Everything outside the language design**, as the scope line above says plainly.

**Sources (public study doorways):** the published Nock specification and the public Hoon
documentation. Read as concepts, restated in our own words.
