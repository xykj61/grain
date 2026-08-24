# The Style Sweep Before Send -- Why an Autonomous Loop Reads Its Voice From the Prompt

*A design-research note on one small discipline added to the autonomous-loop recursion prompt: a Radiant (or Twilight) pass over the round's prose before every commit. It studies the craft -- what a recursion prompt rewards, and why a rule that is always-on for a hand still has to be named again for a loop -- and points at the tree's own technique note for the shape we adopted.*

**Stamp:** `20260816.205019` - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Kin:** [`20260703-013412_writing-recursion-prompts.md`](20260703-013412_writing-recursion-prompts.md) (the craft guide) - [`../recursion-prompts/README.md`](../recursion-prompts/README.md) (the cellar) - [`../active-designing/20260816-205019_style-sweep-and-lenses-by-reference.md`](../active-designing/20260816-205019_style-sweep-and-lenses-by-reference.md) (our own technique)

---

## The one principle a recursion prompt lives by

Every recursion prompt rewards something, and the whole craft is keeping the reward pointed at the good. A prompt that rewards *finished, proven, bounded* work will pull a loop toward finishing, proving, and bounding; a prompt that rewards *motion* will pull it toward motion. This is the craft guide's single load-bearing idea, and it is worth stating plainly to any employee reading this: whatever you name in the prompt is what the unattended run will optimize, so name the good on purpose.

## Why a rule that is always-on still has to ride in the prompt

A person at the keyboard carries the tree's style rules whether or not any single task restates them -- the rules are loaded into every session. An unattended loop is different. It reads its whole law from one artifact, once, and then lives inside that reading for hours. A discipline that lives only in the always-on rules, and never in the prompt the loop actually re-reads each round, is a discipline the loop can quietly drift from.

That is the gap this note closes. Prose quality -- clear code comments, warm Markdown, a benediction only where earned -- was always the house style. Yet the loop's prompt never named it, so an unattended send could ship prose written in a flatter register than a waking hand would have allowed. Naming the **style sweep before send** inside the prompt means every autonomous commit carries the day voice on purpose.

## The shape, studied against prior art

The move borrows a familiar idea from careful writing pipelines everywhere: separate the *drafting* pass from the *editing* pass, and make the editing pass a named step rather than a hope. What this tree adds is a guardrail specific to a codebase -- the sweep changes **register, never a claim**. A style pass over technical prose must hold every number, path, stamp, and modality count exactly, or it stops being an edit and becomes a rewrite of the record. The tree already carries a witness for exactly this invariant (`claim_preserve_witness`), so the sweep inherits a checkable boundary rather than a vibe.

Two further borrowings keep the sweep honest:

- **Spend the benediction only where earned.** Ordinary and technical prose ends plainly; the warm close belongs to devotional and foundational pieces. An unearned flourish cheapens the earned ones -- a lesson any employee who has read too many triumphant changelog entries already knows.
- **Load the lenses, do not restate them.** The prompt names the style guides by path (`context/RADIANT_STYLE.md`, `context/TWILIGHT_STYLE.md`) rather than paraphrasing them inline, because a paraphrase drifts from its source the moment the source moves. Reference is a promise the tree keeps; restatement is a copy the tree has to maintain.

## What an employee adopting this should take away

If you are wiring an autonomous agent that commits its own work, name the editing pass in the prompt, bound it so it cannot alter facts, and reward the finished-and-proven over the merely-moved. The technique this tree settled on -- the sweep plus the set of paths a loop most often forgets -- is written up as our own method in the companion active-designing note, so it can be lifted whole rather than rediscovered.

The craft is small and the payoff compounds: a tree tended in the dark still deserves prose that reads like daylight.
