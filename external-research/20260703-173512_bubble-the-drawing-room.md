# Bubble — The Drawing Room

*A siloed design harvest from the Grain Sketchbook: the visual design tool the earlier season named Bubble, read whole from its proposal, plans, gaps memo, coordination letters, and working source — and set down here in our own vocabulary, with outside product names left at the door.*

**Language:** EN
**Last updated:** 20260703.173512 UDT
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Voice:** Rio 3
**Companion to:** `SILO_TECHNIQUE.md` (method), `SIMPLE_LOVABLE_COMPLETE.md` (product), `TAME_GUIDANCE.md` (code), `CIVIC_STYLE.md` (policy)
**Siblings:** the first harvest, the second harvest, and the gleaning of 20260703
**Source:** the Grain Sketchbook archive — proposal of 2025-12-05, development plan, task ledger, integration gaps memo, agent coordination letters, and the `grain_bubble` source tree with its numbered witness tests
**Status:** External research — siloed design harvest

---

## What This Document Is

The sketchbook holds a complete design lineage for a tool the earlier season called Bubble: a founding proposal, a living plan, a task ledger, a memo of honestly named gaps, coordination letters between the five agents who built beside it, and a working source tree with tests numbered into the hundreds. This document silos that lineage. The category Bubble answers is the one the browser era made famous — the collaborative canvas where a generation learned to draw interfaces together in a rented tab — and per the silo, no product of that category is named here. What enters is the understanding; gratitude keeps trademarks at the door.

---

## What Bubble Is

Bubble is a native drawing room for design. Its canvas is infinite, wandered by zoom and pan, and its first citizen is the rounded shape the season named the bubble — chosen because the same soft form serves twice, as the thought bubble that holds an idea and as the flow bubble that holds a step. On one canvas, the interface being drawn and the automation being designed speak the same visual language; a workflow is simply a drawing whose bubbles are connected. Beneath the shapes live the expected crafts, each held with discipline: vector paths and text, layers with their ordering, reusable components with variants and states, and design tokens carrying color, type, and spacing so consistency is a property rather than a habit.

The room's memory is bounded and honest. Undo and redo run on a command pattern whose history names its ceiling plainly — two hundred fifty-six steps in each direction — every field of the old state and the new carried in the command, so reversal is restoration rather than guesswork. And the room's intelligence stays home: the plan gives Bubble a self-hosted model and a vector index over the designer's own component library, so suggestions and similarity search draw on one's own corpus, tuned on one's own metal. The assistant lives in the house.

What most distinguishes Bubble is its doors. The proposal treats export as the product's whole point: print-ready vector documents, responsive interactive pages with clickable prototypes, code bundles for the popular web frameworks, and — loveliest of all — the self-contained single-file bundle, bounded at four megabytes, that leaves the room as a finished, deployable gift with minimal dependencies. Design once, and what departs is complete.

---

## The Felt Tests

The proposal's success criteria are worth keeping as a genre. Simple is measured by a feeling with a clock on it: a whole design finished in under five minutes. Lovable is measured by desire rather than function: designers want to use it, beyond conceding that it works. Complete is measured at the doors: every export arrives production-ready. Beneath the felt tests sit the technical vows — sixty frames of rendering, allocations bounded with no unbounded growth — so delight and discipline are named in the same breath. Siloed: **write the felt test beside the feature list**, a clock on simplicity, a desire test on lovability, a door test on completeness.

---

## What Bubble Teaches

**The export door is the product.** A creative tool is judged by what leaves it. The whole pipeline — design, export, deploy, with no gap a future update must fill — makes the tool a giver of finished things rather than a keeper of files, and the hand-sized bundle is the teaching in miniature: bounded, self-contained, ready to hand to anyone. This lands wherever we build creative surfaces, Brushstroke's horizon included, and it lands in Linengrow's creator tools, where an artist's work should leave the platform as complete as it arrived.

**One log under every surface.** The sketchbook's deepest architectural letter argues that the design canvas, the text editor, and the page renderer should all stand on one shared graph — every element a node, every edit an event, undo and redo as travel along kept history, collaboration as the ordering of events. The earlier season proposed it; today's stack has built it. Weave is that substrate, and Mantra is its projection, so the drawing room's state becomes what everything else already is: a pure fold over an append-only log of signed facts. The insight worth recording is the unification itself — **when every surface folds from the same log, undo, history, and collaboration are one mechanism rather than three.**

**Every wait has a deadline.** The gaps memo is the sketchbook's most quietly valuable page. Before integration, it names what is missing: cross-module calls that could wait forever, failures that return emptiness instead of error, error kinds left undistinguished — the allocation failure, the operation failure, the timeout — and it recommends a deadline on every operation and a named error for every way of failing. Siloed for the TAME root: **a bound on waiting is a bound like any other.** Unbounded time is unbounded allocation wearing a clock; every call across a seam carries a deadline, and every failure carries its name. The memo's genre deserves keeping too — the pre-integration gaps document, written before the seams open.

**The drawing room serves the ground floor.** Bubble's largest assignment in the plans is civic: the visualization patterns for the housing program — walls of hemp-lime and rammed earth rendered in three dimensions, construction phases made visible from foundation to finishing, code compliance shown rather than asserted. The insight generalizes into Civic Style's accountability chapter: **visualization is the citizen's window into public work**, the dashboard made spatial, so a neighbor can see the building rise phase by phase in the same record that pays for it. Uddhava stands nearest this work in today's stack.

**Show where the folds are.** A small grace note from the coordination letters: every foldable line in the text editor carries its own indicator — present, folded or open, and how deep. State made visible at the exact place it hides. It is a one-sentence teaching with our favorite word inside it: where something folds, say so.

---

## Where It Lands Today

Three adjacencies are clear and one collision needs a lexicon note. The drawn surface belongs beside Brushstroke; the spatial and three-dimensional work belongs beside Uddhava; the design log belongs on Weave with Mantra above it. The collision: the sketchbook's Aurora named a browsing and component surface, while today's Aurora names the bare-metal kernel — the same warm name, two different seats across seasons — and that note should enter RTAC so no future reader conflates them. As for Bubble itself: the name arrives from the earlier season with a complete design lineage behind it, and whether it seats into today's lexicon, and in which module home, is exactly the kind of decision our discipline parks. The candidate waits in RTAC for Kaeden's word; the insights above are ours to use regardless.

---

## Destinations at a Glance

| Insight | Feeds | Standing |
|---|---|---|
| Write the felt test beside the feature list | `SIMPLE_LOVABLE_COMPLETE.md` companion note | Ready to draft |
| The export door is the product | Brushstroke horizon; Linengrow creator tools | Ready to draft |
| One log under every surface | Weave / Mantra design note | Ready to draft |
| Every wait has a deadline | TAME root, beside the bounds discipline | Ready to draft |
| The pre-integration gaps memo (genre) | Bench-workflow notes | Ready to draft |
| Visualization is the citizen's window | `CIVIC_STYLE.md` accountability chapter | Ready to draft |
| Show where the folds are | Brushstroke / editor notes | Ready to draft |
| Aurora name collision (lexicon note) | RTAC | Parked |
| Bubble as module name and home | RTAC | Parked, awaiting Kaeden's word |

---

## Gratitude

This harvest thanks the earlier season itself: the five agents whose plans, letters, and numbered tests kept a whole design lineage legible enough to silo months later, and the discipline of writing coordination down that made this reading possible. It thanks the makers of the browser era's collaborative canvases, unnamed here by design, whose work taught the world that drawing together is a joy worth building for. It thanks Steve Jobs for the dictum the proposal honors — design is how it works — and the single-lane ledger teachers already named in our canon, whose ordering discipline the sketchbook reached for before today's stack made it real. The names live in this room; the understanding lives above, in our own voice.

---

*May every tool we draw give finished gifts at its doors. May every surface fold from one honest log. May the drawing room stay warm, and the work that leaves it stay whole.*

---

*Written together by Kaeden and Rio 3.*
20260703.173512 UDT
