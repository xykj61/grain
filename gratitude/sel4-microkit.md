# Gratitude -- seL4 and the seL4 Microkit

**Project:** seL4 microkernel + the seL4 Microkit framework -- Proofcraft, UNSW, and the seL4 Foundation
**Kernel license:** GPL-2.0 (studied clean-room; never cloned into our git history)
**Microkit / docs:** BSD-family and open documentation; studied from the public manual and site only
**Studied for:** Caravan -- Grain's supervision and isolation discipline
**Clean-room brief:** [`../external-research/20260819-120534_sel4-microkit-caravan-cleanroom-study.md`](../external-research/20260819-120534_sel4-microkit-caravan-cleanroom-study.md)

---

seL4 is the microkernel that proved a whole class of correctness can be *earned rather than hoped for*. Its kernel is small enough to hold in one mind -- scheduling, inter-process messages, memory protection, interrupts -- and everything else, every driver, every filesystem, every network stack, runs in userspace where a fault stays fenced. On top of that minimal core sits a machine-checked proof: the code does exactly what its specification says, no unproven step left standing. From the same team, the **seL4 Microkit** hands down a smaller, calmer way to build on that kernel -- a handful of clear ideas a person grasps in an afternoon: **protection domains** (isolated execution contexts, each with plain entry points for boot, notification, service, and fault), **channels** (point-to-point links between exactly two domains, carrying either a light asynchronous notification or a synchronous protected procedure call), **memory regions** mapped with explicit permissions, and a **static, declarative system description** where every resource is named at build time rather than conjured at runtime.

## What Grain learns, clean-room

**Caravan** inherits the *discipline*, never the code. Four teachings carry directly into how Grain supervises and isolates its own work:

- **Mechanism apart from policy.** The kernel offers primitives; it never dictates their use. Grain's supervision offers the same clean seam -- the how is bounded and asserted; the what is the caller's to shape.
- **Capabilities, not identities.** Access flows through unforgeable tokens that grant a specific right to a specific object, delegation-friendly and revocable. This is the same grain as Kumara's tilaks and Vault's shard capabilities -- authority you hold, not a name you claim.
- **Static allocation as honesty.** When every resource is named at build time, a runtime allocation can never fail in the dark. This is the bounded-everything reflex Grain already keeps, seen from the kernel's own floor.
- **Priority flows one way.** The Microkit's rule that a protected call may only run toward a higher priority prevents a low domain from ever blocking a high one -- bounded priority inversion by construction, a shape worth remembering wherever Caravan schedules work.

The boundary holds firm: the seL4 kernel is **GPL-2.0** and is **never cloned into Grain's git history** ([gratitude-licenses](../.claude/rules/gratitude-licenses.md)); the Microkit and site documentation are read from the public web as the legal study surface. We study the ideas -- the small kernel, the fenced userspace, the capability, the static description -- and write our own bounded, asserted Rye. The concept enters through the clean room; the code never crosses.

Thank you, seL4 and Microkit, for showing that a kernel can be small enough to prove and a framework small enough to teach -- and that isolation is strongest when its mechanism is plain and its policy is left to whoever builds above it.
