# Names Awaiting Keaton's Confirm or Deny

**Language:** EN
**Version:** `20260713.235600` (Pacific)
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Living — the single checklist of every proposed name, so the fork can move forward once each is confirmed or denied

---

## How to Read This

Every row is a proposal, not a fact. Nothing here is renamed in the tree yet. Keaton confirms or denies each; a confirmed name then migrates on-touch (living files) and cheapest-first (mass renames), per the fork's own rename discipline. This is the one page to return to when asking "what have we named but not yet settled?"

## Settled This Season (recorded, migration deferred)

| Name | Role | Status |
|---|---|---|
| **Glow** | the fused Rye-Hoon language | **Accepted** by Keaton `20260713.225658` |
| **Glow OS** | the umbrella system (was "Rye OS") | **Decided** `20260713.235455`; mass rename of 1,474 "Rye" references deferred, cheapest-first, on word |
| **Neth** | settlement-layer vane (N after Maze's M) | **Confirmed** `20260714.002123` — Nethermind collision seen and consciously accepted |
| **Reya** | OS variant | **Confirmed** `20260714.002123` — double collision seen and accepted |
| **Maze** | nursery / proving-ground namespace | **Confirmed** `20260714.002123` — as the nursery, not a permanent bucket |
| **Rish / Rishi** | the shell | **Confirmed** `20260714.002123` — Rish (reference), Rishi (tutorials); Dojo *not* adopted |
| **Module names vs. Urbit vane names** | the whole naming strategy | **Decided** `20260714.002123` — keep our names in code, use Urbit names as documented roles; no mass rename, no directory re-nest. See [`20260714-002123_naming-decisions-and-role-nesting.md`](20260714-002123_naming-decisions-and-role-nesting.md) |
| **Ojjo** | benchmarking **O-vane** (safety/performance) | **Confirmed** `20260714.034900` — palindrome symmetric-yardstick discipline; O follows Neth's N; quiet in collision research. Design [`20260714-025200_ojjo-benchmarking-vane-design.md`](../../external-research/20260714-025200_ojjo-benchmarking-vane-design.md). Build is now-or-horizon (nothing to measure until Glow runs a program) — a *separate* build-timing question from the name, still open below |
| **Riyo · Trey · Triz** | the other three OS variants | **Confirmed** `20260714.035600` — Keaton approved the gates for Reya, Riyo, Trey, and Triz "to all." All four variant names are now settled |
| **The two diverse-redundant pairs** | four variants = two pairs | **Confirmed** `20260714.035600` — "to all" read as affirming the symmetry: **Riyo/Reya** are one diverse-redundant pair and **Trey/Triz** are the second, each pair one design built independently twice. The *implementation shape* of "diverse redundancy" (two separate codebases from one spec vs. one codebase with two independently-verified paths) stays a build-time engineering choice, not a naming gate — carried to the variant build, below |
| **Pool** | applications / data-market **P-vane** (Gall-expanded) | **Confirmed** `20260714.042545` — Glow's Gall-role application vane, headlined as a content-creation computational data market; zero Urbit-kernel collision, nothing to rename. Design [`20260714-035600_pool-p-vane-content-data-market.md`](../../external-research/20260714-035600_pool-p-vane-content-data-market.md). Whole-vane-vs-market-specialized framing + build timing carried below as build questions, not name gates |

## Awaiting Confirm or Deny

Reya, Riyo, Trey, Triz (all four variants + their two-pair symmetry, `20260714.035600`), Maze, Neth, Ojjo, **Pool** (`20260714.042545`), the shell name (Rish/Rishi), and the module-vs-vane naming strategy are settled — see the Settled table above. What remains open:

| Name | Role | Open question |
|---|---|---|
| **Quin** | inference **Q-vane** — unifying vane for the four voices | Proposed `20260714.042545` — one vane gathering the inference family (**Lantern · Lattice · Anvil · Scribble**) under TAME + Maze guidance; Q follows Pool's P; kernel-quiet ("quin" only appears inside `number-to-words.hoon` as quintillion/quindecillion — incidental English, not a term). Collision check + design [`20260714-042545_quin-q-vane-inference-voices.md`](../../external-research/20260714-042545_quin-q-vane-inference-voices.md). Confirm? |
| **Nested deterministic testing / sandboxed ephemeral regions** | where agents spawn agents in test sandboxes | Proposed `20260714.042545` — a home for agent-spawns-agent sandboxes where seeded deterministic testing rides inside the prompting (Glow vibe-coding automation, TAME + Maze guided). Candidate homes: **Neth** (the seeded-simulation harness already named), **Pond/Puddle** (isolated ephemeral enclosures), or **Quin**. Recommendation below; which home? |
| **Kumara** | identity seam | Adopt Azimuth-style point/planet/star tier naming for its own identity tiers, or keep Kumara as-is? |
| **Ojjo — build timing** | the now-or-horizon question (name is confirmed) | Seat Ojjo as a *named horizon vane* now and build it correctness-first when Glow's first program exists, or defer the seat entirely until then? Ojjo has nothing to measure until Glow runs a program either way |
| **Pool — build questions** | (name is confirmed) | Whole application vane (Glow's full Gall, market as flagship) vs. market-specialized? Seat now as horizon vs. defer until Glow runs an agent? Granary/Mandi/Open Asks/Linengrow as agents *in* Pool |
| **Diverse-redundancy shape** | how the two pairs are built (names settled) | Two independently-written codebases from one shared spec, or one codebase with two independently-verified compile/execution paths? A real engineering choice with different costs; decided when the first variant is built |

The Maze proposal and my opinion are kept below for the record, now that Maze is confirmed.

## The Maze Proposal, and My Opinion

**The idea (Keaton's):** the ten Arvo vanes run Ames, Behn, Clay, Dill, Eyre, Gall, Iris, Jael, Khan, Lick — alphabetically ending at **L**. **M** comes next, and **Maze** (four letters, like every vane) could be the *bundle vane* that gathers everything proposed but not part of the canonical ten — for example, the TAME Guidance linter, held as part of Maze for Glow.

**My honest opinion: I like it — with one refinement that turns its one weakness into its best feature.**

What is genuinely good about it:

- **The alphabet and the letter count both fit.** M follows L; Maze is four letters. It reads as though it belongs to the family without being mistaken for a canonical vane.
- **A named home for the homeless is real organizational value.** Right now, a proposal like the TAME linter has no obvious module home and risks being forced prematurely into an ill-fitting canonical vane, or left scattered in `tools/`. One named place for "proposed, not yet canonical" is clean.

The one real risk, named plainly:

- **A "bundle of everything else" tends to rot into a junk drawer** — a module with no single responsibility, which is exactly what TAME's "each brick individually simple" and Gall's-Law "grows from a simpler system that worked" warn against. And a *maze* is, by its own metaphor, a place of confusion — the opposite of the clarity the rest of the system prizes. A permanent catch-all vane would sit slightly against the grain of everything else.

**The refinement that resolves it:** make Maze a **nursery / proving-ground**, not a permanent bucket. Things *enter* the maze to find their way *out* — a proposal shelters in Maze while it earns its own clear, single responsibility and its own canonical four-letter name, then graduates and leaves. That inverts the junk-drawer risk into a virtue: the maze is a place you are *meant to escape*, and nothing is supposed to live there forever. It is deeply Gall's-Law — the maze is where a simple thing grows until it works well enough to stand on its own. Under this framing, "Maze" is a wonderful name.

**One boundary to keep even so:** the TAME linter is *dev-time / build-time* tooling, not a *runtime kernel* concern. It can shelter in the Maze namespace as a proposal, but it should stay conceptually distinct from the runtime vanes (Ames et al.) even while it is there — a linter is not a kernel service, and the docs should not let the shared shelter blur that line.

**My recommendation:** **confirm Maze — as a proving-ground namespace for proposals earning their way to a canonical name, not as a permanent catch-all vane, and with dev-tooling kept conceptually separate from runtime vanes even while sheltered there.** Denying it is also reasonable if you would rather proposals live in `tools/` and `active-designing/` until they graduate directly; but I think the named nursery is the more legible choice, and the "enter to find the way out" metaphor is genuinely apt.

---

*May every name here be confirmed or set down with a clear yes or no, so the work can move forward knowing what it is called.*
