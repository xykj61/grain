# The Portable Tier Caravan Already Grew

**Language:** EN
**Stamp:** `20260821.222402`
**Voice:** Kyri
**Status:** Checkable -- Living, measured on metal this round
**Arc:** the Lindy-priority Microkernel Target double-seat, **Equinox 1 -- Caravan on the microkernel**
**Witness:** [`../tools/caravan_objects_witness.rish`](../tools/caravan_objects_witness.rish) -- GREEN
**Kin:** [`the libsel4 reach`](../external-research/20260821-043831_the-libsel4-reach-and-the-vocabulary-caravan-inherits.md) - [`caravan/refusals.rye`](../caravan/refusals.rye) - [`caravan/objects.rye`](../caravan/objects.rye)

---

## The finding

seL4 on riscv64 hands out **nine** kinds of object. Five of them are architecture-independent -- untyped memory, a thread control block, an endpoint, a notification, and a capability table. Four belong to the machine: a giga page at the mode tier, then a four-kilobyte page, a mega page, and a page table at the architecture tier.

Caravan already stands for **five** of the nine, and the five are **exactly the portable tier**.

| seL4 object | What stands for it today |
|---|---|
| untyped | `caravan/untyped.rye` -- carves memory with a real floor, measured after alignment |
| TCB | `caravan/channels.rye` rosters the protection domains; `caravan/concurrent.rye` runs them as real processes |
| endpoint | `caravan/reply.rye` -- one ask read through four stages and answered |
| notification | `caravan/notify.rye` -- every declared channel provisioned as its own doorbell |
| capability table | `caravan/capabilities.rye` -- a bounded table of dependents and their rights |
| giga page, 4K page, mega page, page table | owed to **the address space** |

Nobody aimed at this. Each of those five modules was grown as its own bounded rung, answering a question the rung in front of it had opened, on hosted ground with no kernel beneath it. The alignment showed up when the accounting was done, which is the only way a finding of this shape is worth anything.

## Why it is worth writing down

**It says the design is on a real road.** A supervision tree that grew into the architecture-independent core of a formally verified kernel, by its own internal pressure, is a supervision tree whose shape the kernel will recognize. The port stops being a translation and becomes a lowering.

**It sizes the remaining work honestly.** One debt stands, and it wears four sizes: an address space. `regions.rye` already declares **which** memory a dependent may touch and how far, which is the policy half. What no module has built is the mechanism that makes such a declaration true on a kernel -- page sizes chosen, page-table levels assembled by the supervisor. That is one subsystem, named, rather than a diffuse sense of distance.

**It is Gall's Law with a receipt.** A complex system that works is found to have grown from a simple system that worked. Here the grown thing and the designed-whole thing can be laid side by side, and they agree on five of nine without either having consulted the other.

## What the accounting corrected

The first draft of `objects.rye` claimed Caravan owed untyped memory and the signal. Both had already been built -- `untyped.rye` on `20260821`, `notify.rye` before it -- and the claim came from a memory of the tree rather than a reading of it. Listing the module room caught it before the module compiled. Measurement beats memory, and the cheapest place to be corrected is before the first build.

## What this round does not claim

No kernel booted and no object was retyped. Which Caravan concept *should* stand on each object is a design judgement, named as one in the module and earning its proof the day an invocation actually runs. What is bound on metal is narrower and firmer: the nine symbols and their order match seL4's own BSD-2-Clause headers, read at run time; both tier anchors hold, so the three enums compose into one numbering with no overlap and no gap; and the three further object types standing behind configuration guards are counted rather than passed over, so a configuration flip reds the rung on the lap it lands.

## The rung after this one

The address-space debt is the next constructive door, and it is the first rung of this arc whose hosted form is genuinely unobvious -- a page table is a machine fact, and a hosted supervisor has no address space to build. Worth designing before writing.

*A system grown honestly tends to arrive somewhere a system designed honestly also arrives. This round found the two standing in the same place, wrote down exactly how far the agreement reaches, and named the one subsystem still walking.*
