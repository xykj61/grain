# Urbit-Parallel Naming -- A Mapping Proposal, Not Yet a Rename

**Language:** EN
**Version:** `20260713.214400`
**Style:** Gauge (see `../GAUGE_STYLE.md`)
**Status:** Proposal -- no file has been renamed; every count below is grep-measured, so migration PRs can be sized honestly

Radiant pass `20260725.035955`

---

## What This Answers

Kaeden asked for a full rename of Rye OS's modules toward Urbit-parallel identity -- Arvo, Zuse, Gall, and the vane tradition -- following Hoon and Nock naming conventions. Before any file moves, this proposes, module by module, either a real parallel or an honest "no analog" verdict, and names the actual size of each future rename as an inbound-reference count so the Urbit-grants-style small-PR discipline Kaeden asked for has real numbers to plan against.

**The central finding, stated first:** Arvo's ten vanes (Ames, Behn, Clay, Dill, Eyre, Gall, Iris, Jael, Khan, Lick) are a *kernel-level OS design* -- every vane manages one system-wide concern (networking, timers, filesystem, terminal, HTTP, userspace apps, HTTP client, security/PKI, off-network compute, low-level IPC). Rye OS's own module list mixes that same kernel layer with **product-layer** concerns (Linengrow's civic commerce, Dimeroll's books, the Inference Track's Lattice/Lantern/Scribble/Anvil stack) that have no vane parallel at all -- they parallel **Gall agents** (userspace apps like Landscape, Groups, Talk), not vanes. Naming this distinction plainly, rather than forcing every module into a vane-shaped box, is itself the proposal's first decision.

---

## Kernel-shaped modules -- proposed vane parallels

| Rye OS module | References (grep, `.md`/`.rye`/`.rish`) | Proposed parallel | Reasoning |
|---|---|---|
| **Comlink** | 265 | **Ames**-parallel | Both are the sealed, peer-to-peer networking layer -- Comlink's sealed datagram over shared-memory/UDP plays exactly the role Ames plays in Arvo (encrypted point-to-point packets between ships) |
| **Mantra** | 290 | **Clay**-parallel | Both are the versioned, content-addressed log underlying everything above them -- Mantra's weave + referential namespace is this project's Clay: a revision-controlled store other modules read through |
| **Rishi** | 625 | **Dojo**-parallel (not a vane -- Dojo is Arvo's own shell app, one layer up) | Rishi is the typed shell/REPL; Dojo is Urbit's shell. The naming parallel is real, but Dojo itself is not a vane, so this is a language/app parallel rather than a kernel one |
| **Caravan** | 169 | **Gall**-parallel (partial) | Caravan's supervision tree + capability table is the closest existing analog to Gall's job of managing running agents/processes, though Caravan's capability-table model is more explicit than Gall's current direct-kernel-interaction model -- see the Foundation's own `gall-2026` "Future of Userspace" post, which is *moving Gall toward* something closer to what Caravan already does |
| **Tally** | 206 | No clean vane analog -- **stays Rye-named** | Tally is a memory/allocator concept (named gardens, bounded regions); Arvo has no vane for this because Nock's noun model handles memory implicitly at the VM level, not the kernel level. Forcing a vane name here would misrepresent what Tally actually is |
| **Brix** | 100 | **Ford**-adjacent (Ford is deprecated/folded into Clay in modern Arvo) | Brix's declarative `.brix` descriptor (one file, one role, no logic) most resembles Ford's old job of resolving build dependencies declaratively, though Ford itself has been absorbed into Clay in recent Arvo -- worth naming as a historical parallel rather than a live one |
| **Bron** | 152 | Structurally closer to **Nock's noun** than to any vane | Bron's one-value model (string, int, bool, list, record, composite -- never tangled) is Rye OS's own version of "everything is a noun" -- the universal single data type Nock builds on. This is a *language/VM-level* parallel, not a kernel one, and arguably the single cleanest parallel in this whole table |
| **Aurora** | 110 | Closer to **Vere** than to any vane | Vere is the runtime/VM that boots and interprets Arvo; Aurora's freestanding six-stage relay + deciding stage plays the boot-and-host role Vere plays, though Vere also interprets Nock at runtime, which Aurora does not yet do |
| **Pond** | 322 | No vane analog -- **stays Rye-named, and the name itself already fits Urbit's own convention** | Pond is a sandbox/enclosure concept (ai-jail's TAME-style reimplementation); Arvo has no equivalent because ships don't sandbox their own kernel this way. Worth naming directly: every one of Arvo's ten vanes -- Ames, Behn, Clay, Dill, Eyre, Gall, Iris, Jael, Khan, Lick -- is exactly **four letters**, confirmed by direct count. `Pond` is also four letters. Even with no vane role to fill, `Pond` already reads as if it belonged to this family, which is a real point in its favor should this project ever want a vane-shaped name for it rather than a Rye-native one -- the four-letter fit costs nothing to keep in mind, even while Pond stays Rye-named today |
| **Kumara** | 111 | Deliberately Urbit-adjacent already | Kumara's Ed25519 identity seam already echoes Urbit's own point-identity model (every ship is a keypair). This one needs no rename to *become* Urbit-parallel -- it already is one in spirit; the open question is whether it should adopt Azimuth-style point/planet/star naming for its own identity tiers, which is a Pass-2 Azimuth-integration question, not a naming one |

## Product-shaped modules -- proposed Gall-agent parallels

| Rye OS module | References | Proposed parallel | Reasoning |
|---|---|---|---|
| **Linengrow** | 210 | Gall-agent-parallel, closest to a **Bitcoin-Hoon-native commerce app** | No single named Urbit app matches Linengrow's civic-commerce shape; it is a Gall agent by role (userspace, stateful, event-sourced) regardless of rename |
| **Dimeroll** | 39 | Gall-agent-parallel (books/ledger app) | Same reasoning -- a userspace app, not a kernel concern |
| **Lattice / Lantern / Scribble / Anvil** | 93 / 93 / 57 / 30 | Gall-agent-parallel (the Inference Track's own app cluster) | These are ML-forge tooling, not kernel concerns; renaming them toward Urbit convention means giving each a Gall-agent-style name, not a vane name |
| **Granary / Mandi / Amphora** | 60 / 35 / 67 | Gall-agent-parallel (weave/exchange/vessel apps) | Same reasoning |
| **Realidream** | 18 | Proposed as the **Landscape parallel** -- the unified viewer | This is the one Kaeden explicitly asked to merge -- Realidream + Brushstroke + Comlink + Kumara into one unified-DAG editor-browser, playing the role Landscape plays as Urbit's own desktop web UI over Gall agents |
| **Dexter / Skate** | 18 / 10 | Landscape-tile-parallel (small, young lanes) | Both are early; a rename here is cheap (lowest reference counts in this whole table) and could be the very first, lowest-risk migration PR if Kaeden wants a concrete first step |
| **Brushstroke** | 92 | Folds into the Realidream-parallel unified app per Kaeden's merge request, rather than getting its own separate vane-style name | Brushstroke is the compositor; in the merged app it becomes the rendering layer inside the Landscape-parallel, not a standalone module |

---

## The rename-cost ladder, cheapest first

Ordered by reference count, since this is the number that determines PR size under the Urbit-grants small-PR discipline:

1. **Skate** (10 refs) -- cheapest possible first migration PR
2. **Dexter** (18), **Realidream** (18) -- natural second and third PRs, already conceptually paired with Skate
3. **Anvil** (30), **Mandi** (35), **Dimeroll** (39)
4. **Scribble** (57), **Granary** (60), **Amphora** (67)
5. **Brix** (100), **Brushstroke** (92), **Lattice/Lantern** (93 each)
6. **Aurora** (110), **Kumara** (111) -- Kumara needs no file rename, only a naming-tier decision, so its count is a ceiling, not a real migration cost
7. **Caravan** (169), **Bron** (152)
8. **Tally** (206, staying Rye-named -- zero migration cost), **Linengrow** (210)
9. **Comlink** (265), **Mantra** (290)
10. **Pond** (322, staying Rye-named -- zero migration cost)
11. **Rishi** (625) and **Rye** itself (1,474) -- by far the largest, and the ones this proposal recommends deferring longest, since they are the language and shell names cited everywhere else in the tree

---

## What This Proposal Deliberately Does Not Decide

- **The actual new names.** This document maps *roles*, not final names -- "Comlink plays Ames's role" does not mean Comlink should literally become named `Ames`; Kaeden's word on whether renames adopt Urbit's literal vane names or a fused Rye-flavored variant (as asked for the language itself: "merging Rye and Hoon... keeping the Hoon rune tradition") is the next decision, module by module.
- **Whether Rye and Rishi rename at all.** Given their reference counts (1,474 and 625) dwarf every other module combined, renaming either is a different order of project than the rest of this table -- worth a dedicated future pass and its own explicit go-ahead, not a default assumption.
- **Timing.** This document orders modules by migration cost; it does not commit to doing any of them yet.

---

*May every name we choose carry its role honestly, and may the cheapest, clearest changes go first -- so the harder ones are attempted only once the pattern is proven small and true.*
