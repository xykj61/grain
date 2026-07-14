# Writing the Recursion Prompt — A Craft Guide for Guiding Cursor and the Design

*Every autonomous run this project has enjoyed came from one artifact: a single prompt that a Cursor agent reads once and then lives inside for hours. This guide names what makes those prompts work, drawn from the ones that ran well — the loop that closed a whole open itinerary, the land-then-hold pass that closed Door 1 — and from the disciplines already written in `context/`. It closes with the anatomy as a checklist, so the next prompt is a form to fill rather than a page to invent.*

**Stamp:** `20260703.013412` · refreshed `20260704.030300` (itinerary vocabulary)
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · CIVIC · SLC · Gall's Law · the silo principle
**Ground:** [`../expanding-prompts/20260704-030300_cursor-recursion-prompt-v4.md`](../expanding-prompts/20260704-030300_cursor-recursion-prompt-v4.md) · [`../work-in-progress/ready-to-ask-claude.md`](../work-in-progress/ready-to-ask-claude.md) · [`../context/LEXICON.md`](../context/LEXICON.md) · [`../context/specs/20260704-030300_itinerary-retires-diet.md`](../context/specs/20260704-030300_itinerary-retires-diet.md)

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice.*

---

## The One Principle Beneath All of It

CIVIC's first law governs prompts as surely as policy: **every prompt rewards something — name what, exactly.** An agent given "keep working" is rewarded for motion, so it goes off-route. An agent given a named **itinerary**, a witness discipline, and a stop-and-park rule is rewarded for *finished, proven, bounded* work — and that is what comes back. Writing a recursion prompt is designing an incentive, and the whole craft is keeping the reward pointed at the good.

## The Eight Load-Bearing Parts

**One — the hard bounds come first, and they are named boxes.** Everything the agent must never touch is listed by tag, never by vibe: the `(Kaeden …)` boxes, the sealed directories, the naming budget. A bound stated as a tag is checkable; a bound stated as a mood is negotiable. This is TAME's safety-first as prompt structure — the unwelcome space asserted before any welcome work begins.

**Two — the stops are exhaustive, and journey's pause closes the itinerary.** Name every stop: each task with its file, its witness, its parity arithmetic. Then say the sentence that makes the whole thing safe: *journey's pause is a question, never permission to go off-route.* The **STOPS** block turns autonomy from an open field into a named route, and journey's pause means the fence holds even when the itinerary is bare.

**Three — every branch is pre-decided.** The best prompts read like a switch statement over Kaeden's future words: Door 3 *for* means these exact commits at these exact numbers; Door 3 *against* means those. An agent should never stand at a fork Kaeden did not already resolve on paper. Where a genuine fork is possible and unresolved, the prompt says *stop-and-park* — the fork itself is the deliverable.

**Four — method is witness-first, red-then-green, in the same round.** The prompt names the proof before the work: which witness, what it asserts, what green looks like, and that the red must be seen before the cure is trusted. Definition of done travels inside every stop, never as a general exhortation at the end.

**Five — the tripwires are enumerated.** Parity red twice on one witness; any module-home or seam decision; anything touching keys, custody, or sealed lanes; any round wanting a new name. Each tripwire's landing place is the same: park it in RTAC with the question stated, and end the round. Tripwires convert surprises from improvisations into agenda items.

**Six — the clock and the ledger are settled in advance.** Who supplies stamps and in what frame; how commits batch (by aspect, log in the same commit); which remotes; what signs. An agent that must guess at bookkeeping will guess differently every round, and the history pays for it.

**Seven — every round ends in a summary with a Questions section.** The summary is the agent's account in the house voice; the Questions section is the standing interface back to Kaeden and Claude. A round without questions is a round that decided things silently.

**Eight — a budget bounds the whole run.** So many commits or so many rounds, whichever comes first. Everything in this tree carries a named maximum; the run itself is no exception.

## Guiding the Design, Rather Than Only the Work

The prompt steers execution; the *design* is steered by what the prompt makes the agent read. Three practices carry that weight.

**Load the lenses by reference, at the top.** One line — *read `context/` before large decisions* — puts TAME, SLC, CIVIC, the silo law, and the graduation rule into every judgment the agent makes, at the cost of a sentence. The disciplines were written to be loaded this way; a prompt that restates them drifts from them.

**Route ideas through their proper doors.** New outside material goes to external-research with its names, then silos inward as concepts. New shapes go to active-designing as counsel, never as code. Anything wanting a name parks. The prompt should say where each *kind* of arrival lands, so the agent files rather than decides.

**Keep design moves as small as Gall allows.** The prompt's stops should never contain "design X"; they contain "write the contract on paper," "record the verdict," "seat the definition in the lexicon" — each a finished, checkable artifact one Gall-step from something already running. When a design question is genuinely open, the deliverable is the *question written well*, parked in RTAC for the kitchen table.

## Anti-Patterns, Named

A prompt fails four ways. **The open field** — "continue on best judgment" with no itinerary; the agent manufactures work to justify the run. **The silent fork** — a branch left unresolved without a park instruction; the agent picks, and the pick is now precedent. **The thick edge** — witnesses demanded only at the end of the run rather than inside each round; reds arrive in bundles with no single name. **The borrowed clock** — stamps computed by the agent in a frame nobody ruled; the one-order law breaks quietly and the tree sorts wrong forever.

## The Skeleton

Land anything pending, with verification named. State the hard bounds by tag. Give the **STOPS**, item by item, each with file, witness, and arithmetic — then journey's pause. Pre-decide every branch of every expected ruling. Name the tripwires and their parking place. Settle clock, commits, signing, remotes. Demand the round summary with its Questions section. Cap the budget. Close with the benediction — because the prompt is a document of ours, and it should sound like one.

---

*May every prompt reward exactly the work we mean. May every fork be resolved on paper or parked with grace. And may the agent, reading it, find the named route generous — every stop inside it green, every gate outside it named.*
