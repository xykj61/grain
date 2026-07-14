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

## Awaiting Confirm or Deny

| Name | Role | Open question |
|---|---|---|
| **Reya** | one of four OS variants | Double collision: ReyaChain (a live Ethereum DeFi project) **and** this fork's own retired "Reya 2" voice identity. Confirm as-is, or pick a replacement? |
| **Riyo** | one of four OS variants | Quiet in collision research. Confirm? |
| **Trey** | one of four OS variants | Quiet in collision research. Confirm? |
| **Triz** | one of four OS variants (replaced "Tera") | Low-stakes soft collision with TRIZ (the innovation methodology). Confirm? |
| **Riyo/Reya + Trey/Triz pairing** | diverse redundancy | Riyo/Reya are named as a diverse-redundant pair. Do Trey/Triz mirror that? And does "diverse redundancy" mean two independent codebases, or one codebase with two independently-verified paths? |
| **Rishi → Dojo?** | the shell | Keep "Rishi," adopt Urbit's own "Dojo," or coin a new Glow-OS shell name? |
| **Module → vane parallels** | Comlink≈Ames, Mantra≈Clay, Caravan≈Gall, Aurora≈Vere, Bron≈noun-level, Brix≈Ford | Are these *literal* renames (Comlink becomes "Ames") or Glow-flavored variants keeping their own names in a vane *role*? Which modules actually rename at all? |
| **Kumara** | identity seam | Adopt Azimuth-style point/planet/star tier naming for its own identity tiers, or keep Kumara as-is? |
| **Maze** | proposed new bundle/nursery namespace | New `20260713` — see the dedicated section below and my opinion. Confirm, deny, or refine? |
| **Neth** (N-vane, after Maze's M) | settlement-layer sequencer — a Glow-TigerBeetle replicated state machine evolved from the existing WOV/MALA money work | New `20260714` — **real close-domain collision** with Nethermind (top-two Ethereum client; `spaceneth`/`NethDev` shorthand), which bites hardest because Neth's own purpose is Ethereum interop. Options: keep **Neth**; use **Neith** (the weaver goddess — beautiful, ties to the Weave, but five letters); or pick another four-letter N-name. My lean is Neith or another name over Neth. Full reasoning + the whole L1/L2 architecture: [`../../external-research/20260714-001017_neth-mala-settlement-l1-l2-design.md`](../../external-research/20260714-001017_neth-mala-settlement-l1-l2-design.md). |

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
