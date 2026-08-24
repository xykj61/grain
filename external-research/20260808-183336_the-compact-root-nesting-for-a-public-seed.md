# The Compact Root -- Nesting the Grain for a Public Seed

**Language:** EN
**Last updated:** `20260808.183336`
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Voice:** Riyo
**Status:** Mixed -- **Proposal** -- a *designed, unbegun breach* per [`../context/BREACH.md`](../context/BREACH.md), and the companion to [`20260808-045124_two-grains-template-breach-and-code-distillation-plan.md`](20260808-045124_two-grains-template-breach-and-code-distillation-plan.md). Nothing here moves a file until the maintainer speaks the word.

---

## What this plan is

The two-grain plan answered *where* the public template lives -- a fresh seed, grown beside the private field, carrying none of the field's private harvest. This plan answers the next question: *what shape does that seed present at its front door?* Today the repository greets a newcomer with **forty-four root directories** and a `MAP.md` that admits, in its own words, "sixty-some doors face you at this root." A public template earns its first impression in the first ten seconds of a stranger's first clone. This plan makes that impression simple, lovable, and complete (`../context/SIMPLE_LOVABLE_COMPLETE.md`) without breaking a single promise the tree already keeps.

Where this plan says *you*, it means whoever picks the work up -- the maintainer today, a contributor tomorrow, an Acme Corporation employee reading this a year from now to understand how the root was compacted and why some doors were left exactly where they stood.

---

## The one fact that sets the clock

`../context/BREACH.md` names a window, and it is the hinge of this whole plan:

> The breach window closes at the **first outside consumer of a path** -- a fork, a published link, an apprentice with a clone. Until then the whole cost is internal and mechanical.

**Publishing `grainos/grain` is exactly that first outside consumer.** The day the seed goes public, every path it exposes becomes a promise to strangers, and the cheap hour for moving addresses is over forever. So the honest order is the reverse of how it first feels: **compact the root *before* the seed exists, not after.** This pier has running witnesses and no dependents -- a rare and temporary hour, and the right one to spend on shape.

That said, a breach must also be *measurably better* (promise 5) and must not become a *restyling campaign* (the law's own closing warning). The measurements below decide which moves clear that bar and which do not -- and the surprising answer is that most of the compaction is free, one move is cheap, and the largest-looking move is not worth making at all.

---

## Movement I -- Does `nock/` deserve the root?

**No -- and it is the single cleanest demotion in the tree.**

`nock/` is Glow's *second backend*, never its execution floor. Its own README says so plainly: the primary path is Glow -> Zig -> RISC-V, and "this interpreter exists for one purpose only: Urbit-world interop and verification." A root directory is a claim of first-rank importance; Nock's own documentation ranks it second, beside Glow rather than beside the language core.

The measurements confirm the demotion is nearly free:

- **Zero code imports** of `nock/` from any other module. Nothing in `rye/`, `glow/`, `tally/`, or the rest reaches into it.
- **Seventeen inbound references total**, and once dated logs and consumed prompts are set aside, the living, repointable set is small: seven witness scripts in `tools/` (`nock_core_witness.rish`, `nock_lap2/3_witness.rish`, `nock_jet_dec_witness.rish`, `glow_riscv_target_witness.rish`, `glow_g5_nock_family_notes_witness.rish`), and a handful of doc citations (`MAP.md`, `LEXICON.md`, `TAME_GUIDANCE.md`, the truth-seam spec, one interop-seam design page).

**Proposed move:** `nock/` -> `glow/nock/`, so the interop backend sits inside the language it serves. This is a textbook breach -- declared, every byte relocated, every one of those ~13 living references turned in the same motion, its witnesses red-before-green-after. It leaves the far side simpler: one fewer root door, and a truer picture of the architecture, since a reader now *sees* that Nock lives under Glow rather than beside it.

*The destination name `glow/nock/` is a proposal, not a seating.* Per the counsel-cell discipline, the maintainer and the Lexicon own the final word.

---

## Movement II -- What else leaves the root, and how

The forty-four doors fall into three honest classes. Only one class wants a physical breach; the other two compact for free.

### Class 1 -- Leaves the template entirely (free, by projection)

The largest root reduction for the *public seed* costs nothing in the private field, because the two-grain manifest already excludes it. These directories never appear in `grainos/grain` at all -- the projection tool simply refuses to copy them:

`keys/`, `session-logs/`, `counsel/`, `bron-resins/`, `press/`, `classical-vedic-astrology/`, `work-in-progress/` (live cards), `saga/` (one steward's season narratives), `rye-learning-process/`, and the personal config siblings (`GLOW_HOST.bron`, `GLOW_PROFILE.bron`, `PUBKEYS.md`). That is roughly **ten root doors gone from the seed** without moving a byte in the private tree -- subtraction by projection, exactly the additive-privacy posture Movement I of the two-grain plan recommended.

### Class 2 -- Nests physically (cheap only where the reference count is small)

Here the measurements refuse the tempting move. Gathering the whole "module ring" under one parent -- the instinct behind *"more compactly nest our most important work"* -- looks tidy and is, in fact, a thousands-of-references breach:

| Module | Inbound refs | | Module | Inbound refs |
|---|---:|---|---|---:|
| `rishi/` | 1252 | | `pond/` | 182 |
| `rye/` | 674 | | `mantra/` | 122 |
| `tally/` | 115 | | `comlink/` | 107 |
| `brushstroke/` | 70 | | `caravan/` | 76 |

A breach must be *measurably better*. Moving `rishi/` alone means turning 1,252 references correctly, in one motion, with no miss -- and the far side is no simpler to *use*, only differently spelled. That fails the bar. **The big module gather is a horizon, not this season's work**, and this plan recommends against it before the seed exists. The compass already teaches the reason: *references are promises*, and a canonical path that a thousand files cite keeps its stable name and is affirmed in place rather than renamed.

What *is* cheap enough to do now, beside `nock/`:

- **The smallest leaf modules** with both few files and few references may nest under a natural parent where one already exists conceptually -- yet even the smallest here (`lattice/` 48, `oven/` 34, `dimeroll/` 24, `cellar/` 23) carry enough inbound weight that each wants its own witnessed, measured motion rather than a batch sweep. **Recommendation: `nock/` this season; every other module stays at its stable path**, and the front door is compacted by Class 3 instead.

### Class 3 -- Compacts for free, in prose (the real win)

The largest lovable improvement moves *no files at all*. The forty-four doors already group cleanly into a handful of named wings -- `MAP.md` half-does this today. Finish it: let `README.md`, `MAP.md`, and `llms.txt` present the root as **seven rooms**, so a newcomer reads a small map even though the directory listing stays long and stable underneath:

1. **The Why** -- `foundations/`
2. **The Law** -- `context/` (TAME, Radiant, SLC, Civic, Lexicon, specs, identity-as-role)
3. **The Language & the Machines** -- `glow/` (with `glow/nock/` nested), `src/`, and the module ring named as a *ring*, not twenty loose doors
4. **The Teaching** -- `docs/`, `manual/`, `edu/`
5. **The Workrooms** -- `active-designing/`, `active-reviving/`, `waymarks/`, `tools/`
6. **The Reading Room** -- `external-research/`, `gratitude/`, `vendor/`
7. **The Front Matter** -- the allow-listed root files that orient before a reader dives

A newcomer holds *seven* things in mind, not forty-four. This is Simple-Lovable-Complete delivered on day one, at zero reference cost, and it is the move this plan most wants the maintainer to say yes to.

---

## Movement III -- Cleaning the workrooms

*"How can we clean up active-designing and active-reviving?"* The compass already wrote the rule; this movement only applies it.

### `active-designing/` -- yonder the consumed, keep the foundational

The bench holds **199 dated briefs at its top level**, beside a `yonder/` that already carries 296. `ORGANIZING.md`'s own "Sort as Priority" law says a brief rests one level deep only *while it drives present implementation*; it moves to `yonder/` once it has become "future, dormant, consumed, or realized-as-code." Many of those 199 are hammocks whose laps have long since gone green and landed their claims in `waymarks/` -- they are realized-as-code, and belong at the horizon.

The discipline, kept honest:

- **This is a ratchet, not a sweep.** Move a brief to `yonder/` when you are already touching its neighborhood, by `git mv` so history stays whole, repointing any inbound reference. Do not carve the whole bench in one afternoon -- that is the restyling campaign the breach law forbids.
- **Relevance outranks age.** A brief that other living files still cite -- the grain-and-the-crossing index, the single-stranded value model, the docs-compression design -- stays one level deep however old it reads.
- **The test is one question:** *does this brief still drive work in front of us, or does a green witness already hold what it planned?* The second kind goes to `yonder/`.

A reasonable target: bring the top of `active-designing/` down to the briefs a reader *needs now* -- the active SLC ladders, the open design questions, the canonical indices -- and let the realized hammocks rest at the horizon they earned.

### `active-reviving/` -- already tidy; keep it, do not fold it

`active-reviving/` holds four briefs and a README. It is not sprawling; it is *small on purpose*, and it names a distinct discipline the tree relies on -- grow-beside-never-rename, the pattern by which Pond superseded ai-jail. Folding it into `active-designing/` to save one door would blur a boundary the project deliberately drew. **Keep `active-reviving/` as the sibling it is**, and let the compact `MAP.md` simply list both benches under one "Workrooms" heading -- the free Class-3 compaction, again, doing the work a file move should not.

---

## The compact root, pictured

The far-side shape this plan proposes for the **public seed** -- one physical move, ten free subtractions, and a seven-room map over stable paths:

```
grainos/grain  (the seed)
+-- README - MAP - SOURCE - CLAUDE - CONTRIBUTING - ORGANIZING - licenses - .template files
+-- context/         # The Law
+-- foundations/     # The Why
+-- glow/            # The Language  (nock/ now nested inside)
|   +-- nock/
+-- src/             # Glow userland
+-- <the module ring, at stable paths>   # rye rishi tally caravan comlink mantra ...
+-- docs/ manual/ edu/     # The Teaching
+-- active-designing/ active-reviving/ waymarks/ tools/   # The Workrooms
+-- external-research/ gratitude/ vendor/                 # The Reading Room
```

Absent by projection, never subtracted from the private field: `keys/`, `session-logs/`, `counsel/`, `bron-resins/`, `press/`, `classical-vedic-astrology/`, `saga/`, the live `work-in-progress/` cards, and the personal config.

---

## Milestones, each witnessed

When the maintainer gives the word, this files forward as a dated prompt in `../expanding-prompts/`, gated so each keystone closes on a witness rather than a claim:

1. **C1 -- The seven-room map (free).** Rewrite `MAP.md`, the `README.md` root intro, and `llms.txt` to present seven rooms. Witness: every root directory names its room; no path changes.
2. **C2 -- Nock nested (cheap breach).** `git mv nock/ glow/nock/`; repoint all ~13 living references in one motion. Witness: the Nock witnesses run GREEN at the new path, and no reference points at the old one (red-before, green-after per breach promise 4).
3. **C3 -- Personal doors excluded (free, in the seed).** The projection tool (`sow.rish`, proposed) refuses every Class-1 path; the projected seed's root shows only the template rooms. Witness: no Class-1 directory appears in the seed.
4. **C4 -- Bench cleaned on-touch (ratchet).** As briefs are touched, realized hammocks move to `active-designing/yonder/`; `active-reviving/` stays whole. Witness: `living_docs_lint.rish` GREEN (no broken links from the moves); the top of the bench reads as present work.
5. **Deferred horizon -- the module gather.** Named, costed at thousands of references, and explicitly *not undertaken* before the seed. It reopens only if a future need makes it *measurably better* than the promises it would break.

### Galaxy Pitch (draft, to ride the eventual expanded prompt)

Per `../.claude/rules/azimuth-galaxy-proposal-format.md`:

> **For:** any Urbit-adjacent builder cloning a disciplined project template -- one whose root they can hold in mind in a single glance, with the interop backend sitting honestly beneath the language it serves.
> **Ask:** none; informational only, until the public seed exists.
> **Scope:** small. One cheap file move (`nock/`), a documentation compaction, and an on-touch bench tidy -- none of it the thousands-of-references module gather, which this plan deliberately leaves at the horizon.

---

## What waits for a word

- **The `nock/` -> `glow/nock/` breach** -- designed here, unbegun by law.
- **The seven-room map rewrite** -- free of churn, yet still the maintainer's to approve, because a front door is a voice and the voice is theirs to set.
- **The bench cleanup cadence** -- a ratchet the maintainer turns on by touching the neighborhood, never a sweep run unasked.

The measurements did the arguing: most of the compaction is free, one move is cheap and clean, and the grand renaming that first tempts the eye would cost thousands of promises for a tidiness a good map delivers for nothing. Compact the front door, nest the one backend that was always Glow's, exclude the personal by projection -- and let the stable paths a thousand files trust keep the names they earned.
