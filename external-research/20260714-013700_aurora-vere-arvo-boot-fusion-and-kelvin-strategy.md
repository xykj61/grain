# Aurora, Vere, and the Arvo Boot — Fused for Glow's Four Variants, and a Kelvin Strategy That Tells the Truth About a Real Tension

**Language:** EN
**Version:** `20260714.013700`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Vision register — design and research; no rename, no code, no kelvin number committed
**Builds on:** `yonder/20260617-195812_aurora-boot-riscv.md` (Aurora's existing design), `../context/specs/20260713-225658_glow-accepted-riyo-reya-trey-triz-amended.md` (the four kernel variants)

---

## What Was Checked Live, Just Now, Before Writing Any of This

Keaton asked to confirm against the live Urbit blog, and then Tlon's and Zorp's own sites, rather than reason from memory. All three check out, and the facts they confirm are load-bearing for everything below:

- **Urbit's blog** — most recent post is *This Month in Urbit: June 2026*. The **Ares** post (2023) is correctly filed under its original year — Ares is the Urbit Foundation's, Tlon's, and Zorp's real, still-in-progress joint next-generation runtime, built around a Persistent Memory Arena for single-level storage. It is not the same word as our own **Aurora**, and there is no naming collision — Aurora already means something different and older in our own tree (see below).
- **Tlon** (`tlon.io`) — live, currently focused on Tlon Messenger and Tlonbot, an OpenClaw-powered personal agent. This matches the June 2026 post's mention of "Tlon's public launch."
- **Zorp** (`zorp.io`) — live, describes itself plainly as "a Nockchain company," with a real, dated posting history through December 2025.
- **The kelvin number itself, checked at the source rather than estimated** — the current *stable, landed* kelvin is **409** (release `409k-2`, published 2026-03-02). The *next* kelvin, **408**, is in active pre-release testing right now — `408k-rc2`, published 2026-06-12, still tagged pre-release. Kelvin numbers count **down**; a lower number is newer. This is today's real, dated position, not a remembered one.

---

## Aurora Already Exists — This Is Not a New Name

Before any of this fusion work, one thing is worth saying plainly: **Aurora is not being proposed here.** It is already seated in `../context/LEXICON.md`'s Core stack table — "the boot — dawn on open hardware" — and it already has a full design, written 2026-06-17, in `yonder/20260617-195812_aurora-boot-riscv.md`. That document is excellent and does almost everything this fusion needs: it already studies Vere's boot in real depth (the king/serf split, the pill as a recipe of Nock events, the ivory/brass/solid/baby pill family, the functional BIOS formula, the larval phase and breaking symmetry, the mature four-arm kernel) and already re-grounds every one of those stages in a RISC-V-native relay, written in Rye, with **Caravan** waking at the end of the relay as the mature kernel.

What that document could not yet know, because it predates the naming work of just today: **the mature kernel that wakes at the end of Aurora's relay is no longer one thing called Caravan.** It is now a **choice among four Glow-written variants — Riyo, Reya, Trey, Triz** — switchable the way a machine dual/tri/quad-boots. That is the one real gap this document closes.

---

## The Fusion: Extending Aurora's Relay to a Choice of Four

Aurora's existing design already gives the pill a new shape: **a manifest of values** — verified stage images, keys, the device tree, built reproducibly. The fusion this document proposes is narrow and additive, in the spirit of accretion Rye's own versioning already commits to:

**The manifest gains one more named value: which kernel variant to load, verified the same way every other stage image already is.**

Concretely, tracing Aurora's own five stages (runtime startup, the pill, the functional BIOS, the larval phase, the main sequence) forward to their Glow-fused endpoint:

- **The manifest (Aurora's pill-parallel)** now carries, alongside the verified stage images, a **variant selector fact** — a signed, content-addressed value naming which of Riyo, Reya, Trey, or Triz this boot targets. This is not a runtime flag or a config default (Tiger Style's own warning against unstated defaults applies directly here) — it is a value in the manifest, verified before the relay runs, the same as every stage image already is.
- **The privilege relay (Aurora's functional-BIOS-parallel)** folds the variant selector in at the same point Urbit's boot reads the pill kind — before the larval phase begins, since the choice of variant shapes what preconditions the larval phase must gather. A Riyo boot and a Reya boot, being diverse-redundant siblings of one intent, should gather the *same* preconditions through the *same* larval interface, which is itself a useful witness: if Riyo's and Reya's larval phases genuinely diverge in what they need from the hardware, that is a sign the diverse-redundancy pairing is not as clean as hoped, and worth surfacing rather than hiding.
- **The larval phase's "breaking symmetry" moment** — where a fresh boot stops being generic and becomes uniquely this owner's — is unchanged in kind, but now also fixes *which variant* this particular ship is, for this boot. A ship does not have to commit to one variant forever; it can carry manifests for more than one, exactly as a machine that dual-boots keeps more than one bootable image on disk, and Aurora's own existing "dual normal-and-fallback pair" idea (borrowed from ownerboot) already gives us a mechanism for that: **a second variant is simply another verified, named image the relay can fall back to or be told to choose,** not a new concept.
- **The main sequence** wakes whichever of Riyo, Reya, Trey, or Triz the manifest named — and per the still-open question from the kernel-variants doc, whichever pairing turns out to share a witness suite (Riyo/Reya, and possibly Trey/Triz) should be held to **identical external behavior** at this handoff point specifically, since the boot handoff is exactly the kind of narrow, well-defined seam a shared witness can check cleanly.

Nothing here asks Aurora's existing document to be rewritten. It asks for one accretive addition — the variant selector as a manifest value — threaded through stages whose shape Aurora already designed correctly.

## What This Should Not Yet Decide

This document deliberately leaves open the two questions the kernel-variants doc already named as unresolved, because the boot-fusion design does not require answering them yet, and answering them here would be overreach:

- Whether Trey/Triz mirror Riyo/Reya's diverse-redundancy relationship.
- Whether "diverse redundancy" means two independently-written codebases from one shared spec, or one codebase with two independently verified paths.

The boot relay is agnostic to both answers — it only needs a signed value naming which variant to load, and it works identically either way.

---

## The Small-PR Ladder

Following the galaxy grants-format goal — the smallest, most human-checkable, independently mergeable slices — the fusion work above breaks into a natural ladder, each rung landing green on its own before the next begins:

1. **The variant-selector fact alone.** A new small value type in the manifest — signed, content-addressed, naming one of four fixed strings — with a witness proving it round-trips (write, verify, read back the same name) and refuses a tampered or unrecognized name. No relay changes yet.
2. **The relay reads the fact, does nothing with it yet.** Aurora's existing relay gains one new fold step that reads the variant selector and asserts it is one of the four known names, continuing to boot whatever single kernel Aurora already boots today. This proves the plumbing without yet requiring four real kernels to exist.
3. **A second, real, minimal kernel stub.** However Riyo and Reya first come into being — as two genuinely small, boot-to-a-single-asserted-line-and-halt stubs — this rung proves the relay can load *either one*, selected purely by the manifest's fact, with a witness that boots each by name and confirms the right one actually ran.
4. **The fallback pair.** Only once step 3 is green does the "second image as fallback, not just as choice" idea from ownerboot become a real, addable rung — its own small PR, not bundled into step 3.

Each rung is independently reviewable, independently mergeable, and — per this project's own witness-first discipline — each should land green before the next rung's PR is even opened.

---

## The Kelvin Question — Naming a Real Tension Rather Than Papering Over It

Here is the part of Keaton's ask that deserves the most care, because it runs into something this project already decided, on purpose, for good reasons: **`../context/specs/rye-versioning-style.md` already rejected exactly the kind of versioning scheme kelvin represents.** That document is not a passing preference — it is a deliberate choice, reasoned all the way through from Rich Hickey's *Spec-ulation* and Tiger Style together, to grow Rye **only by accretion, on a chronological clock, never by a breaking major-version bump that licenses incompatibility.** Kelvin is, by Urbit's own description in *Stable Arvo*, precisely the opposite instinct: **counting down toward zero on purpose, with the explicit intent of eventually needing no further breaking changes at all** — which presupposes that breaking changes are the normal way forward until that day arrives.

So "lowering Zuse's kelvin version to accommodate Glow" cannot mean, without contradiction, "let Glow's own standard library adopt Urbit's breaking-and-freezing kelvin discipline internally" — that would undo a foundational decision this project already made carefully, for reasons that still hold. But it also should not mean nothing. There is a real, honest synthesis available, and it rests on treating kelvin the way Aurora already treats a manifest image: **as an external compatibility target we declare and verify against, not as our own internal versioning law.**

**The proposed synthesis, stated plainly:**

- **Internally, Glow's own standard library keeps growing exactly the way Rye already does — by accretion, on the chronological clock, never breaking a name that already shipped.** This does not change.
- **Externally, Glow's Zuse-parallel can and should declare which real Urbit kelvin its interfaces are built to interoperate with** — the same way a galaxy-proposal PR against real Urbit already must declare kelvin compatibility to be reviewable at all. This is a **label describing interop reach**, not an internal law about how our own code is allowed to change.
- **"Lowering" that declared number, read honestly, means targeting the *current, lowest, newest* kelvin Urbit has actually reached — 409, confirmed live above — rather than building against an older, higher, more historical one.** This is the reading that actually serves Keaton's own stated goal of small, easily-reviewed galaxy-format PRs: a PR that declares compatibility with the *current* kelvin is trivially easier for the real Urbit community to evaluate than one built against a kelvin they have already moved past. It is also, separately, the more Gall's-Law-aligned choice — it means reviving what Urbit's own multi-year stability work has already earned, rather than starting the fusion from a point they have already improved past.
- **One open, practical question this raises rather than answers:** whether to track *409* (today's landed stable) or watch *408*'s pre-release testing and target it once it lands, given kelvin 408 is already in `408k-rc2` as of 2026-06-12. Tracking a moving pre-release adds real churn; tracking the last stable point is steadier. This document leans toward **409, the landed stable kelvin, as the declared interop target for now** — with a plain note that this target itself should be revisited, as its own small update, whenever 408 actually lands stable, rather than chased mid-flight.

**Named honestly, not resolved by this document:** Zuse, Arvo, Lull, and Hoon each carry their *own* separate kelvin number in real Urbit today (as of `411k`: `%zuse 411`, `%lull 323`, `%arvo 237`, `%hoon 138` — and today's 409-labeled release similarly implies its own Arvo/Lull/Hoon numbers, not fetched individually here). Which of these layers Glow's own interop declaration should actually target — the whole-kernel Zuse number alone, as real Urbit's own shorthand convention already does, or a finer-grained declaration per layer — is a real design choice this document raises but does not make on Keaton's behalf.

---

## What Remains Open, For Keaton's Word

- Whether the small-PR ladder above is the right granularity, or should be split even finer before rung 1 begins.
- Whether the boot-fusion's variant-selector fact belongs in `aurora/` directly, or as a small new module of its own that Aurora merely reads — a real "module vs. aspect" question per `../context/LEXICON.md`'s own graduation rule.
- Whether to declare interop against kelvin 409 now, as this document leans toward, or wait and see where 408's testing lands first.
- Whether the interop declaration should name the whole-kernel Zuse number alone, or Zuse/Arvo/Lull/Hoon individually.

---

*May Aurora's relay stay honest about which dawn it is choosing, and may every kelvin we ever declare compatibility with be one we checked freshly rather than remembered fondly.*
