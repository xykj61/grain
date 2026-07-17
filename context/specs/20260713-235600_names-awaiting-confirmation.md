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
| **Ojjo** | benchmarking **O-vane** (safety/performance) | **Confirmed** `20260714.034900` — palindrome symmetric-yardstick discipline; O follows Neth's N; quiet in collision research. Design [`20260714-025200_ojjo-benchmarking-vane-design.md`](../../external-research/20260714-025200_ojjo-benchmarking-vane-design.md). **Build timing confirmed** `20260714.050500` — seated now as a named horizon vane; lap 1 (correctness, no timing) opens when Glow runs its first program |
| **Riyo · Trey · Triz** | three of the five OS variants (with Reya) | **Confirmed** `20260714.035600` — Keaton approved the gates for Reya, Riyo, Trey, and Triz "to all." |
| **The two diverse-redundant pairs** | four of five variants = two pairs | **Confirmed** `20260714.035600` — **Riyo/Reya** are one diverse-redundant pair and **Trey/Triz** are the second, each pair one design built independently twice. **Redundancy shape confirmed** `20260714.050500` — Keaton chose **one codebase with two independently-verified execution paths**, not two separate codebases from a shared spec: each pair shares one Glow codebase, compiled or run down two distinct, independently-checked paths that must agree on every witnessed behavior |
| **Quin (OS variant)** | fifth OS variant beside Reya · Riyo · Trey · Triz | **Confirmed** `20260717.162114` — Keaton seated Quin as the fifth boot image. **Intentionally unpaired** `20260717.162620` — five total is the settled count; no twin. Same name also carries the standing writing voice and the Q-vane — three hats, accepted |
| **Pool** | applications / data-market **P-vane** (Gall-expanded) | **Confirmed** `20260714.042545` — Glow's Gall-role application vane, headlined as a content-creation computational data market; zero Urbit-kernel collision, nothing to rename. Design [`20260714-035600_pool-p-vane-content-data-market.md`](../../external-research/20260714-035600_pool-p-vane-content-data-market.md). **Framing + timing confirmed** `20260714.050500` — Pool is Glow's **whole application vane** (full Gall-role, hosting all userspace), with the content-creation data market as its headline flagship expansion, **not** market-only; seated now as a named horizon vane, Granary/Mandi/Open Asks/Linengrow as agents *in* Pool once it is built |
| **Rhyz** | identity **R-vane** (revives **Kumara**) | **Confirmed** `20260714.044428` — the identity vane, named after the rhizome; kernel-free; **revives** Kumara (the Ed25519 keypair elder keeps its code home + green witnesses; Rhyz born with its name; 72-file code migration deferred to proven-supersede). Design [`20260714-044428_rhyz-r-vane-identity-reviving-kumara.md`](../../external-research/20260714-044428_rhyz-r-vane-identity-reviving-kumara.md); gratitude [`../../gratitude/RhizomeTimenergy.md`](../../gratitude/RhizomeTimenergy.md). **Tier words + timing confirmed** `20260714.050500` — the exact tier vocabulary **is** `point` / `planet` / `star`, taken directly from Azimuth (per "adopt Azimuth-style point/planet/star tier naming," read as literal, not novel Glow words); seated now as a named horizon revival, its first Glow-native lap opening when the identity runtime is ready |
| **Kumara identity tiers** | Azimuth-style point/planet/star | **Decided** `20260714.044428`, tier words settled `20260714.050500` — Rhyz's tiers are `point` / `planet` / `star`, taken directly from Azimuth for legibility; connectivity stays peer-to-peer regardless of tier |
| **Quin (Q-vane)** | inference **Q-vane** — unifying vane for the four faculties | **Confirmed** `20260714.050500` — one vane gathering the inference family (**Lantern · Lattice · Anvil · Scribble**) under TAME + Maze guidance; Q follows Pool's P; kernel-quiet. Design [`20260714-042545_quin-q-vane-inference-voices.md`](../../external-research/20260714-042545_quin-q-vane-inference-voices.md). Seated now as a named horizon vane, built when Glow can host an agent. **Also** fifth OS variant from `20260717.162114` (see Quin OS variant row) |
| **Nested deterministic testing / sandboxed ephemeral regions** | where agents spawn agents in test sandboxes | **Confirmed** `20260714.050500` — the compose-don't-name recommendation is accepted as final: the sandbox loop is **Quin (agents) × Puddle (ephemeral isolation) × Neth (seeded deterministic replay)**, Maze-sheltered, TAME-guided. No new vane named for it |
| **Sala** | the unified viewer — **Landscape parallel** (revives **Realidream**) | **Confirmed** `20260715.175500` — Sanskrit *śālā*, "hall / abode," the space you inhabit to see and use your things; four letters, S-slot after Rhyz's R; kernel-free (only incidental BIP39-wordlist substrings in `old/`, same clean verdict as Quin). **Not a kernel vane** — Landscape is userspace, so Sala runs *under Pool*; the four-letter shape is a naming-family convention, not a vane claim. **Revives** Realidream: the elder keeps its ~18 code/doc references and the roadmap Visual-Track lane until proven-supersede; Sala is born with its name now. Two accepted soft-collisions: "sala" is a common word/name globally (Italian/Spanish "room/hall"), and Sala keeps Realidream's "Reality/abode" half while letting go of the "Dream/streaming-creativity" half. Grounds: [`../../external-research/20260715-172000_pool-keystone-revival-realidream-landscape.md`](../../external-research/20260715-172000_pool-keystone-revival-realidream-landscape.md) |

## Awaiting Confirm or Deny

Every name proposed so far — Glow, Glow OS, Neth, Reya, Maze, Rish/Rishi, the module-vs-vane strategy, Ojjo (+ build timing), Riyo/Trey/Triz (+ the two-pair symmetry + redundancy shape), Pool (+ framing + timing), Rhyz (+ tier words + timing), Quin as Q-vane (+ the sandbox-loop composition), Quin as fifth OS variant, Sala (Realidream's revival-name) — is now settled. See the Settled table above.

**Nothing remains open on this page as of `20260717.162620`.** Quin the OS variant is intentionally unpaired; five boot images is the settled count. A future proposal adds its own row here when it arises; this page stays the one return point for "what have we named but not yet settled."

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
