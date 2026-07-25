# Expanded Prompt — The Glow Application Framework and Publishing Mechanism, Held Against GrapheneOS

**Language:** EN
**Version:** `20260716.142818` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Runnable long-term plan — design/research register (Two Rooms). The GrapheneOS facts below are **checkable**, dated July 2026 and cited so they can be re-verified as the project moves; the Glow mapping, framework, and ladder are **design proposals**, none bound, gated on Keaton's word before anything is seated or built. Addressed to a generic Acme Corporation employee.
**Waymark:** **TUBE** — this ladder's own name-tag, drawn deterministically (SHA3-512 over `old/doc/spec/flw.txt`, per [`../context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md`](../context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md)) from the input `glow-application-framework-and-publishing`, so it never collides with the Genode `G`-ladder or the GrapheneOS `HAWM`-ladder. The word carries no chosen meaning; its aptness (a tube carries things) is coincidence.

---

## The Seed (what was asked)

With HAWM0 and HAWM1 both GREEN — a real Android userland booting under KVM, and Glow's own verified fold running inside it — the next question is the long one: what should the recommendation be for where this thread goes, written as a thorough long-term plan? Specifically: connect the plan with the Glow **rune design for applications**; think about the **application framework and publishing mechanism of GrapheneOS** — whether it has an app-store process or package-install process different from Android; and name **which modules/vanes of the current Glow OS most closely match the kinds of services GrapheneOS offers**.

## The Lens Applied

- The compass, walked: foundations (sovereignty, the person owns the device, anti-extraction, a key not a login) → grain (state as a fold over a signed log) → Two Rooms (GrapheneOS facts checkable and dated; Glow design marked proposal) → active studies (the rune grammar brief, the Pool keystone, the vane-parallel mapping) → the HAWM ladder now half-green → this plan.
- Witness-before-truth — every GrapheneOS claim below is dated `20260716` and carries its source, so it can be re-checked as GrapheneOS's own build and distribution process changes.
- The gratitude/clean-room discipline (`../.cursor/rules/gratitude-licenses.mdc`) — GrapheneOS (MIT/Apache-family AOSP derivative) is **studied and thanked**, never copied; every Glow parallel enters through our own vocabulary.
- The rune sameness test (`../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`) — closed, regular, checked-at-expansion — applied directly to what an *installable Glow application* is.
- Civic Style — name the outcome, name what the mechanism actually measures, keep them aligned.

---

## Part 1 — GrapheneOS's Application Framework and Publishing Mechanism (checkable, `20260716`)

GrapheneOS keeps Android's own application *framework* (the APK format, the AOSP app sandbox, the Android 12+ package installer and unattended-update APIs) and changes the *trust model and distribution* around it. The distinctions that matter for Glow:

**1. Its own signed app repository, distinct from Google Play.** The **GrapheneOS App Store** (the "Apps" app, `github.com/GrapheneOS/AppStore`, Apache-2.0) is the client for the **GrapheneOS App Repository**. The repository serves three things: GrapheneOS's own standalone apps (Vanadium, Camera, PDF Viewer, Auditor, and the rest); **out-of-band updates to certain GrapheneOS system components**; and a *mirror* of the core Google Play apps + Android Auto, tested against GrapheneOS's sandboxed-Play compatibility layer. TLS key pinning guards the client-repository connection (release notes carry the pin's own expiry date).

**2. Verified boot extends to system-app updates.** The load-bearing sentence from the App Store's own release notes: *"GrapheneOS users must obtain GrapheneOS app updates through our App Store since verified boot metadata is required for out-of-band system app updates on GrapheneOS as part of extending verified boot to them."* The chain of trust that starts at the bootloader reaches all the way up to system-app updates — a system app cannot be updated out-of-band without matching verified-boot metadata.

**3. Sandboxed Google Play — the store as an unprivileged app, not a system backend.** Where stock Android wires Play Services deep into the OS with privileged access, GrapheneOS runs the official Play releases **in the ordinary app sandbox, with no special privileges at all** — the compatibility layer "teaches it how to work within the full app sandbox." Play is installed per user/work profile, only apps in the same profile can use it, and it needs explicit consent like any app. It can install/update/uninstall via the **standard Android 12+ package-installer flow** (the user authorizes it as an app source once, then consents per action), and it uses the standard Android 12+ unattended-update feature for apps where it was the last installer. GrapheneOS itself never uses Play as a backend, even when installed.

**4. The OS update mechanism is separate and A/B-slotted.** Distinct from app distribution: automatic background OS updates, checked ~every 6 hours, downloaded as **incremental/delta** images, installed to a **secondary (inactive) slot that only becomes active after a complete, verified install**, with **automatic rollback if the new version fails to boot** and **downgrade protection** enforced by verified boot. Signed update zips are verifiable by recovery too (the `adb sideload` path), enforcing the same guarantees.

**5. The sandbox/permission model underneath.** Every app is untrusted by default; permissions are minimal and opt-in; **per-app network permission**, **per-app sensor permissions**, **Storage Scopes** (an app sees only the files it created or was explicitly granted, and loses that access on uninstall unless re-granted), and **Contact Scopes** are the app-facing surface. Identity is optional — a Google account is needed only for Play features that require one; the OS itself demands none.

**The one-line summary:** GrapheneOS keeps Android's *installation and sandbox machinery* and replaces the *trust and distribution* around it — a signed repository tied to verified boot, a store that is just an unprivileged app, per-app capability gating, and an A/B verified-boot update rail with rollback. That shape — **signed content, capability-gated execution, verifiable updates, no privileged central authority** — is exactly the shape Glow OS's own spine already grows toward, which is what Part 2 maps.

---

## Part 2 — Which Glow Modules/Vanes Most Closely Match GrapheneOS's Services

The mapping, strongest matches first. Every Glow entry is an existing named module or vane in this tree, not invented here.

| GrapheneOS service | Closest Glow module/vane | Match | Why |
|---|---|---|---|
| **App sandbox + per-app permissions** (untrusted-by-default, capability-gated execution) | **Pool** (application host) over **Caravan**'s capability table | **Strongest** — already GREEN | Pool's P0/P1 witnesses already prove exactly this shape: admission is a capability check not a name check; two agents cannot touch each other's state without a named grant; the grant is the only bridge and does not leak. This *is* the GrapheneOS sandbox model, grown on a witnessed spine rather than retrofitted onto a trusted-by-default base |
| **App Repository** (signed, content-addressed distribution of apps + updates) | **Granary** (Sharing surface) + **Amber/Amphora** (resins) + **Comlink** (sealed carriage) | Strong | A repository is signed content named, mirrored, and verified. Granary is the sharing surface where signed weaves are named and mirrored; a resin is the content-addressed unit (SHA3-tiered) Amber seals and Amphora carries; Comlink is the sealed sea between docks |
| **App Store client** (install/update/uninstall under per-action consent) | **Pool** (admits an agent) + **Rishi** (the hand that runs the verb) | Strong | Installing is admitting an agent into a Pool host under a capability, with consent as the admission gate; Rishi is the faithful hand that invokes it |
| **Verified boot → system-app updates** | **Aurora** (the boot) + **Kumara/Rhyz** (signing identity) + **Mantra** (version history) | Strong | Aurora is the boot; the chain of trust is Kumara/Rhyz signatures; Mantra's append-only versioned history is where an update's provenance lives, verifiable by folding |
| **OS update rail** (A/B slot, delta, signed, rollback, downgrade protection) | **Mantra** (weave revisions) + **Amber** (sealed resins verified by folding) + **Aurora** | Strong | A verifiable, rollback-able, downgrade-protected update is a signed revision in an append-only log; Mantra already models exactly this, Amber seals each state cold, verification is a fold |
| **Storage Scopes / Contact Scopes** (per-app data access) | **Bookie** (borrow discipline) + Pool capabilities | Moderate | Bookie names who may change a value versus who may only witness it; a scope is a capability naming which resource an agent may touch |
| **Payments** (in-app purchase, paid-app license — Play-dependent on GrapheneOS) | **MALA** + **Neth** + **Sigma** + **Mandi** | Strong (and an improvement) | GrapheneOS must lean on Google Play for payment; Glow has its own rail — MALA prices, Neth settles with a verifiable receipt, Sigma keeps the amount private, Mandi is the market floor. This is a place Glow does *more* than GrapheneOS, not merely matches it |
| **Identity / account** (Google account optional) | **Rhyz** (revives Kumara) | Strong | "A key, not a login" — Rhyz's rhizome identity over Kumara's Ed25519 root is the account model GrapheneOS approximates by making Google's optional; Glow's is native |
| **Per-app network permission** | **Comlink** (sealed datagram) + Pool capability | Moderate | Network access as a named capability an agent must be granted, carried over Comlink's sealed wire rather than an ambient socket |
| **The enclosure the app runs in** | **Pond** (isolation policy) + **Puddle** (ephemeral sandboxed containers) | Moderate | Under the new Glow vane model Pond narrowed to pure isolation policy; Puddle is the ephemeral-container role — together the "profile" boundary GrapheneOS draws with users/work profiles |

**The honest gap, named plainly:** GrapheneOS's deepest security guarantees are **hardware-rooted** — Titan M2 / hardware memory tagging (MTE), verified boot anchored in a locked bootloader, exploit mitigations in a hardened kernel and libc. Glow's capability model is a strong *software* parallel to the sandbox — the hardware root of trust is exactly what HAWM2 (a real GrapheneOS build) and HAWM3 (a physical Pixel) exist to reach, and what no emulated rung or software capability table can substitute for. Glow-on-GrapheneOS composes the two: Glow's capability-secured userland *on top of* GrapheneOS's hardware-rooted base, each doing what only it can.

---

## Part 3 — The Glow Application Framework, Connected to the Rune Design

An installable Glow application is a **Pool agent**, and the rune grammar (`../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`) already gives it its shape. The connection is not decorative — the three properties that make a rune *sameness* (closed, regular, checked-at-expansion) are the same three properties that make a capability-secured app framework trustworthy.

- **An app's manifest is a bounded mold (`+$`).** What an app is — its name, its version, the capabilities it requests, its resource ceilings — is a `+$` mold with cold-atom-tagged fields, per the mold-nesting surface (`../external-research/20260715-170000_glow-mold-nesting-bounded.md`). A manifest that declares a capability it never uses, or omits one it needs, is a type error at admission, not a runtime surprise.
- **Requested capabilities are declared, exhaustively, and checked at admission.** GrapheneOS's per-app permission model is total — an app gets exactly what it was granted, nothing ambient. This is the `?-` **exhaustive switch** applied to a capability set: Pool's admission checks every requested capability against the grant, and a capability with no matching grant is refused (`NotAdmitted`, already witnessed in P0), never silently defaulted. The exhaustive-switch discipline (`?-` over `?+`) is exactly "no silent default grant."
- **Resource bounds are the bounded trap (`|-`).** An app's own loops carry their bound at the site, checked every iteration, failing `BoundExceeded` rather than hanging — the same discipline that makes a phone app a good citizen (no runaway background loop draining the battery) is TAME's root rule given a syntax. GrapheneOS enforces resource limits from outside the app; Glow's rune grammar builds the bound *into* the app's own compiled code, checked at expansion.
- **Install is a capability admission checked at expansion, never merely trusted.** The rune brief's deepest property — "a macro whose every expansion is checked, visibly, the same way every time, is sameness" — is exactly the install-time guarantee: admitting an app is checking its declared capabilities against a grant, the same way, every time, with the check compiled in rather than hoped for. "Checked at expansion, never merely trusted" and "untrusted by default, capability-gated" are the same sentence in two vocabularies.

**The framework in one breath:** a Glow app is a Pool agent whose manifest is a bounded mold, whose capabilities are declared and exhaustively checked at admission, whose loops are bounded at their own site, and whose every trust decision is checked at expansion rather than assumed — the rune sameness test and the capability sandbox are the same discipline seen from two sides.

---

## Part 4 — The Publishing Mechanism (no central store; the store is a fold)

GrapheneOS's repository still has a central authority (the GrapheneOS project signs it). Glow's publishing mechanism removes even that, because the pieces already exist to make a *store* a **fold over signed offers** rather than a server:

1. **Publish** = a maker signs a weave (the app + its manifest) with their Rhyz/Kumara key and names it in **Granary**'s global namespace — a signed fact, not an upload to anyone's server.
2. **Distribute** = the app's bytes are **content-addressed resins** (Amber seals, Amphora carries), fetched over **Comlink**'s sealed wire from any peer that holds them — mirrored, not hosted; verified by digest, so provenance does not depend on where it came from.
3. **Discover** = the "store" is **Pool**'s own content-creation data market (`../external-research/20260714-035600_pool-p-vane-content-data-market.md`) — a fold over the signed offers in the namespace, each offer wearing its own terms. A listing is a signed fact; a catalog is a fold; there is no privileged index.
4. **Acquire** = price in **MALA**, settle through **Neth** with a verifiable receipt, keep the amount private with **Sigma** if wanted, over **Mandi**'s floor — the payment rail GrapheneOS has to borrow from Google, Glow owns.
5. **Install** = **Pool** admits the agent under the capabilities its manifest declares, checked at admission (Part 3).
6. **Update** = a new signed revision in **Mantra**'s append-only history, verifiable by folding, rollback-able by construction — the A/B-slot rollback guarantee expressed as "the old revision never left the log."

Every step is a signed fact re-folded, never a node patched; every trust decision is a signature check, never a trusted authority. This is GrapheneOS's "signed content, verifiable updates, no privileged backend" carried to its conclusion: **the store is not a place, it is a fold anyone can compute.**

---

## Part 5 — The TUBE Ladder (long-term, smallest-first, gated on the Glow agent runtime)

Each rung provable before the next; every rung gated on Pool's own agent runtime existing, which is itself gated on the Glow compiler running a program. Named honestly as horizon design until Pool can host a real agent.

| Rung | Name | What it is | Gate |
|---|---|---|---|
| **TUBE0** | **App manifest mold** | **Landed and GREEN `20260716.145256`** — [`../linengrow/tube_manifest.rye`](../linengrow/tube_manifest.rye) + [`../linengrow/tube_manifest_witness.rye`](../linengrow/tube_manifest_witness.rye), wired into `tools/parity_ch01.rish` via [`../tools/tube0_manifest_witness.rish`](../tools/tube0_manifest_witness.rish). Eight claims: a well-formed manifest (name, version, ≥1 declared capability reusing `caravan/capabilities.rye`'s own `right_*` bits, a real iteration bound) builds cleanly; `declares()` checks the exact right, not mere resource presence; and five malformed shapes are refused at the manifest's own boundary — empty name, zero declared capabilities, a zero-rights-mask capability, and a zero iteration bound (TAME root rule 2's own discipline, checked here rather than left to a confusing runtime failure) | Glow mold surface; no agent runtime needed — a pure value witness, buildable today, the smallest real first step |
| **TUBE1** | **Admission = capability check** | Pool admits one agent iff its manifest's declared capabilities match a grant; refuses `NotAdmitted` otherwise. This is P0's own claim, re-aimed at a manifest | Pool P0 (GREEN) · TUBE0 |
| **TUBE2** | **Publish as a signed weave** | A maker signs an app+manifest into Granary's namespace; a consumer resolves it by name and verifies the signature before anything installs | Granary (landed) · Rhyz/Kumara (landed) · TUBE1 |
| **TUBE3** | **Distribute as content-addressed resins** | The app's bytes cross Comlink as Amber resins, fetched by digest from a peer, verified before admission | Amber/Amphora (landed) · Comlink (landed) · TUBE2 |
| **TUBE4** | **Acquire through the market rail** | Price in MALA, settle through Neth with a receipt, over Mandi's floor; Sigma for amount privacy | Pool Lap 1 (the content-data market) · MALA/Neth/Mandi (landed) · TUBE3 |
| **TUBE5** | **Update as a signed revision** | A new app revision lands in Mantra's append-only history; the old revision stays; rollback is selecting the prior revision | Mantra (landed) · TUBE4 |
| **TUBE0.5** | **First installable Glow APK on GrapheneOS** *(named `20260717.014522`, host-side GREEN `20260717.021857`)* | **Host-side packaging GREEN** — closed-table permission emission (`tube_manifest_android_permission.rye`), NativeActivity envelope (`tube_android_manifest.rye`, Android's own `NativeActivity`, no custom Kotlin/Java), fixed `libglowapp.so` exporting `ANativeActivity_onCreate`, signed demo APK via `tools/tube05_apk_pack_witness.rish`. On-device `adb install` and a real Glow fold inside the entry remain the next slice. Answers Keaton's own question about a Glow-to-Kotlin transpiler — named "no" in [`../active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md`](../active-designing/20260717-014522_native-activity-shim-and-slc-packaging.md) | TUBE0 (GREEN) · HAWM3 (closed `20260717.013700`) — host-side closed; on-device install open |
| **TUBE6** | **On real GrapheneOS (HAWM2)** | The whole TUBE stack running as a Glow userland on a real GrapheneOS build — Glow's capability sandbox atop GrapheneOS's hardware-rooted one | HAWM2 (horizon, needs Linux/KVM + full AOSP build) · TUBE5 |
| **TUBE7** | **On a physical Pixel (HAWM3)** | The publishing mechanism live on real Titan-class silicon — the two roots of trust (hardware + capability) composed on the actual target device | HAWM3 (**closed** `20260717.013700` — GrapheneOS installed and verified-boot hash confirmed on Keaton's own Pixel 10a) · TUBE6 |

**The honest register:** TUBE0 is buildable today as a pure value witness (no agent runtime, no device). TUBE1–TUBE5 are gated on Pool's agent runtime — real design, real composition of already-landed modules, yet not startable until Glow runs an agent. TUBE0.5 sits beneath TUBE6/TUBE7 rather than inside the TUBE1–5 capability pipeline: it answers a device-hosting question (how any Glow binary becomes a recognized, installable Android app at all), not a capability or market question, and both of its own gates are now closed. TUBE6–TUBE7 join this lane to the HAWM ladder's own hardware rungs; HAWM3 itself closed `20260717.013700`, a real device with a verified chain of trust. Nothing here claims to be GrapheneOS's security; it claims to be Glow's own capability-secured application framework, which *composes with* GrapheneOS's hardware root rather than replacing it.

---

## The Recommendation (what was actually asked)

**Recommendation: build TUBE0 next — the app manifest mold — as the single reachable, buildable, device-free first step of the application framework.** It needs no emulator, no agent runtime, no physical Pixel; it is a pure value witness in the exact shape this tree already builds well, and it turns the whole TUBE ladder from horizon into a lane with a green first rung. It also directly exercises the rune design's own mold surface, connecting the language-design thread to the application-framework thread concretely rather than only in prose.

The Sala broadcaster app-layer client (the other open door from HAWM1's close) is a real and worthy lap too, yet it is a *specific app*; TUBE0 is the *framework every app rides*, including that one — so the framework earns priority. HAWM2 (real GrapheneOS build) and the physical-Pixel purchase remain genuinely gated on a Linux/KVM full-AOSP build and on hardware not yet in hand, and stay horizon by honest necessity, not by choice.

## What This Prompt Does Not Do

- It writes no vane or app-framework code — Glow must run an agent first for TUBE1+, though TUBE0 is buildable as a pure value witness whenever Keaton says go.
- It does not seat the TUBE waymark or this ladder into `context/LEXICON.md` or the roadmap as committed direction — that is Keaton's word (the waymark is *derived* and recorded here, not yet seated as canon).
- It does not confirm any GrapheneOS fact as permanent — each is dated `20260716` and must be re-checked as GrapheneOS's own process evolves.
- It does not claim Glow's capability model substitutes for GrapheneOS's hardware root of trust — Part 2 names that gap plainly, and the ladder composes the two rather than conflating them.

## Related

- `../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md` — the rune grammar this framework's manifest/capability/bound design rests on.
- `../external-research/20260714-035600_pool-p-vane-content-data-market.md` — Pool as the application host and the market that becomes the store.
- `../external-research/20260715-170000_glow-mold-nesting-bounded.md` — the bounded-mold surface a manifest is expressed in.
- `../context/specs/two-dev-environments-and-mobile-emulation.md` — the HAWM ladder (HAWM0/HAWM1 GREEN) this joins at TUBE6/TUBE7.
- `../context/specs/20260716-115927_waymark-ladder-naming-and-g0-collision-fix.md` — the waymark scheme TUBE's own name comes from.
- `../context/LEXICON.md` — Granary, Amber, Amphora, Comlink, Mantra, Pool, Rhyz, MALA, Neth, Sigma, Mandi, Bookie, Pond, Puddle — every Glow module the mapping names.

---

*May the store be a fold anyone can compute, the app a bounded agent admitted only by a checked grant, and the two roots of trust — the hardware's and the capability's — hold the same house together, each doing what only it can.*
