# What Doesn't Nest Within a Vane — Glow's Three Non-Vane Strata, and Pond's Narrowing

**Language:** EN
**Version:** `20260715.165000` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Design → architecture, siloed. Register: design (Two Rooms — a proposal about layering, not a bound claim). Addressed to a generic Acme Corporation employee.
**Companion:** `../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md` (the vane-parallel mapping this doc refines with an explicit non-vane layering)

---

## What This Answers

The vane-parallel mapping proposal already returns an honest "no analog" for several modules — Pond, Tally — and names others (Bron, Aurora, Rishi) as language-, VM-, or shell-level rather than kernel-level. This doc gathers those scattered verdicts into one architecture: the three strata that deliberately sit **outside** the vane frame, why each belongs there, and how each maps onto a layer Urbit itself keeps outside its own ten vanes. It closes with how **Pond** narrows under the Glow vane model — the one module whose role genuinely changes as Pool, Quin, Puddle, and the rest take their places.

The starting fact, stated plainly: **not everything is a vane, and Urbit knows this too.** Arvo has ten vanes, yet Nock, Hoon, Vere, Zuse, the Dojo, and Ford are none of them — they are the strata a vane rests on. Glow's non-vane modules fall into the same shape.

## The Three Strata

### One — the substrate, below every vane

| Glow module | Urbit layer it parallels | Why it is not a vane |
|---|---|---|
| **Rye** | Hoon (the language) | Everything nests on it; it nests in nothing. The language is the ground, not a system concern. |
| **Bron** | Nock's noun (the value model) | The one-value model — string, int, bool, list, record, composite, never tangled — is the universal type vanes pass values *as*. The mapping calls it the single cleanest Urbit parallel in the tree. |
| **Aurora** | Vere (the runtime) | The runtime boots and hosts the vanes; a host of vanes is not itself one. |
| **Tally** | (no Urbit analog — memory is below the language) | Bounded memory and named gardens; Nock handles memory implicitly at the VM level, so no kernel vane owns it. |

### Two — enclosure and build infrastructure, beneath and around the vanes

| Glow module | Urbit layer it parallels | Why it is not a vane |
|---|---|---|
| **Pond** | (no Urbit analog — ships do not sandbox their own kernel) | Isolation policy: the customs engine that grants each mark place, hold, or refuse. It bounds a running whole rather than serving a system concern within one. |
| **Puddle** | (no Urbit analog) | Ephemeral, snapshot-able hosting of many isolated wholes; composes with Pond as the multi-tenant layer. |
| **Maze** | (no Urbit analog) | The nursery namespace that shelters a proposal while it earns its single clear responsibility and its canonical name. A meta-layer, not a running concern. |
| **Brix** | Ford (build, since folded into Clay) | Declarative build descriptors; Ford's own vane role no longer exists in modern Arvo, so there is no live vane to claim it. |

### Three — the shell, beside the vanes

| Glow module | Urbit layer it parallels | Why it is not a vane |
|---|---|---|
| **Rishi** | Dojo (the shell) | The typed shell/REPL; Dojo is an application one layer above the kernel, not a vane, so Rishi inherits that standing. |

## The Unclaimed Slot — a Zuse Parallel

Urbit keeps a shared standard-library layer, **Zuse**, of common structures and helpers every vane and agent may draw on. Glow has no single named equivalent yet; its closest thing is the scattered shared cores many modules import — `tally/copy`, `kumara`, `receipt_core`, `wire_format`. Should Glow ever want a named stdlib stratum, that is the open, unclaimed slot, and naming it would complete the substrate layer honestly.

## Pond's Narrowing Under the Glow Vane Model

Pond today carries two jobs at once (`../pond/README.md`): an **enclosure** aspect (the `customs.rye` policy engine) and an **applications** floor (`apps/`, where composed wholes run). The Glow vane family pulls these apart, because two new vanes now claim pieces Pond used to hold alone:

- **Pool**, named as Glow's whole application vane (the full Gall role, the content-market its flagship), claims the `apps/` floor. Applications compose *under Pool* now; they no longer need to live inside Pond.
- **Puddle** claims the ephemeral multi-whole role — many isolated wholes, each with its own identity and policy, torn down after. The Quin study states it directly: Pond is the enclosure inside one running whole; Puddle hosts many.

What remains is the thing only Pond does: **the isolation-policy substrate** — the customs decision of what a running whole may touch, and the boundary against the host that reimplements ai-jail in the TAME style. In the sandboxed-agent composition (Quin × Puddle × Neth, Maze-sheltered), Pond is what bounds each Puddle from the inside. It becomes a layer beneath the vanes, not a peer among them.

**Which vane, if forced into the Arvo frame?** None — Pond stays Rye-named, exactly as the mapping concluded, and the P-slot is already Pool's. Spiritually, its closest analog is **Jael's permissions half** (Jael is Urbit's security/PKI vane; Pond's place/hold/refuse is permission-granting), with **Lick** (the POSIX/host-boundary vane) as the secondary echo for Pond's host-fence face. Its identity half — the other side of Jael — belongs to Rhyz, not Pond.

## The Three-Layer Enclosure, Clarified by the Pool Build (`20260715.211500`)

Landing Pool P0 (host an agent, admitted by capability) and P1 (isolate agents, no cross-access without a named grant) — both green over Caravan's own capability table — made the enclosure layering concrete, and it settles what Pond *is a part of* now that Pool is real. Three named parts compose, none absorbing another:

- **Caravan** — holds the capability *table* (the facts of what each child may do) and the supervision. The mechanism.
- **Pool** — the userspace *host* (the vane) that reads that table to admit an agent (P0) and enforce the boundary between agents (P1). Where the agents run.
- **Pond** — the *policy substrate beneath Pool*, keeping the two jobs only it does: **customs on content crossing in** (place/hold/refuse on a mark or resin at receipt — distinct from Pool/Caravan's capability check on *agents*; Amber's cold-scrub already calls customs before a restore) and **the host-OS boundary** (the ai-jail/Seatbelt-style fence against the machine underneath).

So Pond is a part of the same enclosure-and-policy concern as Pool and Caravan — specifically its **content-customs and host-fence floor**. An agent is *hosted by Pool*, *isolated by Caravan's capabilities*, running *inside Pond's customs and host boundary*. Pool is the vane; Pond is the policy floor it stands on. Pool taking agent-hosting and Puddle taking the ephemeral-multi-whole role did not shrink Pond into nothing — it left Pond exactly the two jobs no other layer does.

## Puddle, and Why the Fleet Research Sharpens Rather Than Undermines It (`20260715.211500`)

Puddle (ephemeral, snapshot-able, isolated wholes on one machine, each with its own identity and policy, torn down after) and a **fleet** (many sovereign, persistent wholes across the network in a sponsorship/settlement relation — Rhyz membership × Neth graduated-trust × Pool monitor × Comlink, per `20260715-165500_glow-neth-and-the-urbit-fleet.md`) solve different problems and do not overlap: Puddle is *local, ephemeral, multi-tenant*; a fleet is *distributed, persistent, identity-anchored*. The fleet research does not make Puddle redundant — it draws the line sharply: do not reach for Puddle when you mean a fleet, nor a fleet when you mean an ephemeral local sandbox.

After Pool took agent-hosting, Puddle's one genuine remaining job is the **ephemeral sandbox in the deterministic-testing / agents-spawn-agents loop** (Quin × Puddle × Neth) — spin up a throwaway isolated whole, run a generated attempt, prove it on Neth's seeded replay, tear it down. Neither Pool (persistent agent host) nor the fleet (distributed sponsorship) covers that.

**The recommendation, honoring the finishing discipline:** Puddle stays a good idea for that narrow niche, and stays a **named horizon, not built** — nothing green today, nor the SLC flagship, nor the fleet needs it; it earns its build only when the vibe-coding sandbox loop it serves is actually built. And when that day comes it belongs on the **home forge** (the AMD/Minisforum box), not the phone — a phone does not run many ephemeral wholes; the two-body strategy already puts that heavy multi-tenant work on the forge.

## What This Doc Does Not Claim

- It does not rename anything; the strata are an architecture over the existing names, and every rename stays gated behind Keaton's word per the mapping proposal.
- It does not claim the Zuse slot should be filled now — only that it is the honest open slot if a named stdlib is ever wanted.
- It does not close the Pond question by force-fitting a vane; the recommendation is that Pond stays Rye-named as a substrate, and the Jael/Lick parallels are offered for reasoning, not for renaming.

## Related

- `../context/specs/20260713-214400_urbit-parallel-naming-mapping-proposal.md` — the mapping this doc gives an explicit layering.
- `../external-research/20260714-042545_quin-q-vane-inference-voices.md` — the Pond/Puddle isolation split and the compose-don't-name instinct.

---

The vanes are the system-concern layer; the language, the value model, the runtime, memory, enclosure, build, and the shell sit outside it by design — the same shape Urbit's own architecture keeps.
