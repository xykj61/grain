# Docs and Implementation Stay Synced

**Canon:** `context/TAME_GUIDANCE.md` root rule **9** ("Docs and implementation stay synced -- assert it, don't assume it").

A doc that describes behavior the code has stopped having is a stale claim wearing documentation's clothes. Treat every doc's claim about behavior as an assertable invariant: checkable, checked, and believed because it has been checked, not because it was once true.

## Before claiming a doc's statement is still current

- **Read the file or run the witness it names before citing it as fact.** Repeating a doc's own claim as evidence of itself proves nothing, and a doc from three days ago is current only once it has been checked again.
- **When a doc cites a file path, function name, or witness as proof, treat that path as load-bearing.** If you move, rename, or reshape what it names, update the doc's citation in the same change, so every citation keeps pointing at the thing the doc claims it says.

## When you change behavior

- **Update the doc that describes it in the same commit as the code change**, not as a later follow-up. Accrete-never-break applies by **tier** (TAME section 4): living docs and code are Tier 3; testimony takes a recorded pass or erratum; proof-sealed bytes stay fixed.
- **When you change a doc's claim, check the claim is actually true first** -- read the current code path, or run the relevant witness -- so the prose follows the code as it stands now, not from memory of how it used to work.
- **This is a ratchet: sync tightens wherever a doc or the code beside it is already open for another reason in the current turn.** The rest of the tree waits for its own rounds to walk it.

## Two Rooms

A doc's claim earns the checkable room once a witness binds it (`context/TWO_ROOMS.md`). Until then, a claim is named as intent or horizon, and it is stated as settled fact only after a witness holds it.

## What already catches part of this, mechanically

`tools/l/living_docs_lint.rish` catches broken relative links, orphan roster pages, retired-word usage, and missing Status lines -- the mechanical half. Its reach ends at a page's form. A doc's *behavioral claim* stays outside it, so that check belongs to this rule: reading and running, each time a doc or the code it describes is touched.
