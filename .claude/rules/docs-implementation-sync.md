# Docs and Implementation Stay Synced

**Canon:** `context/TAME_GUIDANCE.md` root rule **9** ("Docs and implementation stay synced — assert it, don't assume it").

A doc that describes behavior the code no longer has is a stale claim wearing documentation's clothes. Treat every doc's claim about behavior as an assertable invariant — checkable, and checked, not merely believed because it was once true.

## Before claiming a doc's statement is still current

- **Read the file or run the witness it names before citing it as fact.** Do not repeat a doc's own claim as evidence of itself; a doc from three days ago is not automatically current.
- **When a doc cites a file path, function name, or witness as proof, treat that path as load-bearing.** If you move, rename, or reshape what it names, update the doc's citation in the same change — never leave a citation pointing at something that no longer says what the doc claims it says.

## When you change behavior

- **Update the doc that describes it in the same commit as the code change**, not as a later follow-up. Accrete-never-break applies to docs exactly as it applies to code.
- **When you change a doc's claim, check the claim is actually true first** — read the current code path, or run the relevant witness — rather than editing prose from memory of how the code used to work.
- **This is a ratchet, not a sweep.** Do not go looking for unrelated drift across the whole tree; tighten sync wherever a doc or the code beside it is already open for other reasons in the current turn.

## Two Rooms

A doc's claim belongs in the checkable room only once a witness actually binds it (`context/TWO_ROOMS.md`). A claim that has not yet earned a witness is named as intent or horizon — not stated as settled fact.

## What already catches part of this, mechanically

`tools/living_docs_lint.rish` catches broken relative links, orphan roster pages, retired-word usage, and missing Status lines — the mechanical half. It does not and cannot check whether a doc's *behavioral claim* is still honestly true; that check is this rule's job, done by reading and running, every time a doc or the code it describes is touched.
