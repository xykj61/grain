# Azimuth and the Sui Ground -- Arc II, Paper One

**Language:** EN
**Stamp:** `20260727.095919`
**Voice:** Quin
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Research for understanding -- Study -- measured this sitting from the elder's own documentation and Sui's; nothing here purchases, signs, or touches a key; every design word stays held for paper two
**Ground:** Twin Season Arc II opens (r24) - Kumara keeps the ship concept of identity - the study serves the seam papers to come

*Written together by Keaton and Quin.*

---

## Room One -- the Elder's Identity Ledger, Restated

The elder network seats identity in a general-purpose public-key infrastructure implemented as contracts on Ethereum, and its deepest lesson is a **split we already love**: one contract is the ledger and nothing else -- a bare data store of points, keys, and deeds -- while a second contract holds every rule of business logic, and the governing vote can change only the rules, never rewrite the ledger directly. Data accretes; law amends. That is our own accrete-never-break, discovered independently on another world.

The address space is a hierarchy of scarcity inside a 128-bit field: **28 galaxies, 216 stars, 232 planets**, with the vast remainder open as free, zero-reputation comet space, and moons hanging off any point without ever touching the ledger. Sponsorship is pure arithmetic -- a planet's default sponsor is its value modulo 216, a star's modulo 28 -- and a point may **escape** to a new sponsor when service disappoints, so the tree is a default, never a cage. Galaxies govern and route; stars discover peers and distribute updates; planets are people. The whole shape prices trust: an identity that cost something, sponsored by someone, is worth speaking to.

Powers divide by **proxy**, and this is the elder's second great lesson. The ownership key alone can transfer the point; beneath it stand limited siblings -- a **management** proxy that rotates networking keys and manages sponsorship, a **spawn** proxy (galaxies and stars) that issues children, a **voting** proxy (galaxies) for the senate, and a temporary **transfer** proxy that makes handoff a deliberate two-step. Sharpest of all: **networking keys rotate on their own counters -- life and rift -- without the ownership key ever moving**, so a compromised ship resets its continuity while its deed sits cold and safe. And when per-transaction gas made planets dear, the elder answered with a **naive rollup** -- points choosing a dominion where individual actions batch into aggregate proofs -- teaching that the ledger's costs shape the ledger's law.

*Room one sources, named with thanks: docs.urbit.org -- Azimuth (Urbit ID), Azimuth.eth reference, Core Academy 14 (Jael - Azimuth), Hoon School C (Azimuth); developers.urbit.org -- proxies glossary, L2 actions; urbit.org blog -- the value of address space, the first contract upgrade; azimuth.network.*

## Room Two -- the Sui Ground, Measured

Sui's world is made of **objects**: every asset is a struct with a 32-byte globally unique ID, an owner field, and a version that increments on every change. Ownership comes in kinds that matter enormously for an identity design -- **address-owned** objects ride a fast path that needs no global ordering; **shared** objects pay for consensus; **immutable** objects belong to everyone and change never; objects can be **wrapped** inside others; and -- the quiet gift -- an object can be **owned by another object**, its ID standing wherever an address would, forming a parent-child relation whose receive-rules are defined by the parent's own module. **Dynamic fields** let a parent carry named children of any shape, added and removed at runtime, with Table and Bag as the collection idioms. Transfer-to-object gives a **stable-ID account** pattern: the parent's address never changes however much it owns, holds, or moves. And **SuiNS** seats human names as registration objects whose holder manages the domain.

*Room two sources, named with thanks: docs.sui.io -- object model, dynamic fields, transfer-to-object; the Sui Foundation Move intro course, ownership lesson.*

## The Translation Table -- Where Paper Two Begins

Read the two rooms against each other and the Kumara questions name themselves, each held open on purpose:

| Elder organ | Sui-ground candidate | The held question |
|---|---|---|
| Point (deed) | An **address-owned object** per Kumara point -- identity ops ride the fast path, no global ordering for one owner's own affairs | Does anything about a point *need* shared consensus at all? |
| Ledger / logic split | Bare point-objects beside one small **shared registry** only where global reads demand it | How little can the shared surface be? |
| Galaxy - star - planet | The hierarchy as **spawn-capability objects** -- scarcity by capability, not by table | Keep 28 - 216 - 232 -- or reshape the scarcity for Grain? |
| Sponsorship (mod arithmetic + escape) | **Transfer-to-object parenting** or a dynamic-field link; escape = re-parent | Arithmetic default, chosen link, or both? |
| Proxies | **Capability objects** -- Move's native idiom: management, spawn, transfer as transferable caps | Which caps exist at birth; which are minted later? |
| Life and rift | Networking keys as a **versioned dynamic field**, rotating without the owner-object moving | The exact rotation record Comlink wants to read |
| Moons | Off-ledger under a point's local Kumara keys, exactly as the elder keeps them | -- settled by rhyme |
| The rollup lesson | Largely pre-answered: owned-object ops are already cheap; batch where shared | Measure, then believe |
| Names | A **kumara** SuiNS domain for human handles beside the point space | Held with the custody park, whole |

One more lane stays beside the table by Keaton's word: the **nostr-shaped alternative** -- identity as bare keys with no scarcity at all -- enters paper two as the honest counterweight, so the contract shape is chosen against a real rival rather than by default.

## What This Paper Does Not Do

No purchase, no wallet, no key, no `.sui` acquisition, no contract code, no vane nest. The elder repositories remain gratitude-pin candidates awaiting the `pins=` word. Paper two -- *The Identity Seam in Glow* -- takes this table and shapes the tilaks; paper three writes the Acme-generic onboarding with the jurisdiction template. Arc II closes when the three stand together.

---

*May the elder's lessons cross the water whole, the objects hold what the deeds held, the keys rotate while the names sit safe -- and every coin, key, and signature wait exactly where they already live: in Keaton's hands.*
