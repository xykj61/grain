# Expanded Prompt — Glow's Non-Vane Strata, the Urbit Fleet Reconciliation, and Mold Nesting

**Language:** EN
**Version:** `20260715.164500` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Runnable plan — three external-research writings, all landed this pass. Register: design/research (Two Rooms — proposals, not bound claims). Addressed to a generic Acme Corporation employee.

---

## The Seed (what was asked, across four turns)

A cluster of Glow design questions, asked in conversation and worth a durable home rather than only a chat: how does **Pond** change under the new Glow vane model, and which vane would it be assigned to? Can **Glow** and **Neth** reconcile with Urbit's own **fleet** idea (searching the code and documentation on urbit.org)? What else do we have that **doesn't nest within a vane**? And how do we resolve Glow's design with **Hoon molds nesting**?

## The Lens Applied

- The vane-parallel mapping (`../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md`) — roles, not renames; its "no analog" verdicts are the starting point.
- The Glow supplement scoping (`../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`) — five design surfaces; mold nesting is the sixth this round adds.
- The Quin vane study (`../external-research/20260714-042545_quin-q-vane-inference-voices.md`) — Pond/Puddle isolation split; the compose-don't-name-a-new-vane instinct.
- Neth's own landed ladder — two-posture root install (graduated trust), apply-step crash safety, deterministic simulation, real Comlink carriage — the settlement engine the fleet reconciliation builds on.
- Witness-before-truth and Two Rooms — every claim below is design register, marked proposal, none bound.

## The Deliverables (three writings, all run this pass)

1. **The non-vane strata, and Pond's narrowing** — [`../external-research/20260715-165000_glow-non-vane-strata-and-pond.md`](../external-research/20260715-165000_glow-non-vane-strata-and-pond.md). Names the three strata that deliberately sit outside the vane frame (substrate: Rye · Bron · Aurora · Tally; enclosure/build: Pond · Puddle · Maze · Brix; shell: Rishi), maps each onto Urbit's own non-vane layers (Hoon · Nock-noun · Vere · Dojo · Ford), names the unclaimed Zuse-stdlib slot, and records how Pond narrows under Glow — shedding its apps floor to Pool and its ephemeral multi-whole role to Puddle, left as the pure isolation-policy substrate, closest to Jael's permissions half if placed in the Arvo frame at all.

2. **Glow, Neth, and the Urbit fleet** — [`../external-research/20260715-165500_glow-neth-and-the-urbit-fleet.md`](../external-research/20260715-165500_glow-neth-and-the-urbit-fleet.md). Reconciles the sponsorship hierarchy and the `%fleet` monitoring app with Glow's Rhyz (identity/membership, Jael's role), Neth (settlement of the shared status ledger), Pool (the monitor app), and Comlink (carriage), and names honestly the one real divergence: Urbit keeps sponsorship lightweight by design, so layering Neth's consensus under a fleet adds a settlement dimension Urbit deliberately omits — a fork to choose with eyes open, not a free parallel.

3. **Glow mold nesting — bounded normalizers, decidable nest, bounded recursion** — [`../external-research/20260715-170000_glow-mold-nesting-bounded.md`](../external-research/20260715-170000_glow-mold-nesting-bounded.md). Proposes the sixth Glow-supplement surface: a mold stays a normalizing function yet names its own bound; `nest` stays structural subtyping yet stays decidable in bounded time; recursive molds carry an explicit depth/size bound (`list:N`, never unbounded `list`), the structural analog of "`u32`, never bare `usize`."

## Why This Serves the Roadmap

Each writing turns a chat insight into a citable design artifact the roadmap can plan against. The strata doc sharpens the naming-mapping proposal's architecture before any rename PR is sized. The fleet doc names a real, composable Glow application lap (Rhyz × Neth × Pool × Comlink) and the design choice it hinges on. The mold-nesting doc names the sixth surface a future Glow supplement must cover, keeping the language-design thread whole. All three stay proposals, gated behind Keaton's word before anything is seated or built.

## Related

- [`../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md`](../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md) — the mapping the strata doc refines.
- [`../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`](../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md) — the five surfaces the mold-nesting doc extends to six.

---

Three chat threads become three citable studies; each stays a proposal until Keaton's word seats it.
