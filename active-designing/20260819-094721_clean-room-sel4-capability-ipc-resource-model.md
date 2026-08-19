# Clean-Room Brief -- seL4 Capability / IPC / Resource Model, as it Informs Caravan

**Stamp:** `20260819.094721` -- **Status:** Living (clean-room brief) -- **Voice:** Kyri
**Register:** Radiant -- **Commissioned by:** [`../external-research/20260819-094721_microkernel-target-study-weight-recenter.md`](../external-research/20260819-094721_microkernel-target-study-weight-recenter.md)
**Studies:** seL4 -- the formally verified microkernel from Trustworthy Systems.
**License boundary:** seL4 kernel is **GPLv2** (copyleft); parts of its userland/libraries are BSD-style. Studied for **design concepts only** -- IPC model, capability system, resource discipline. **No source enters our tree.** Verify per component before any fetch. Rule: [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md).
**Reads only** public docs, the whitepaper, and published papers -- no code incorporation.

---

## The concepts worth internalizing

seL4 is a small, capability-based microkernel whose functional correctness and security properties are machine-checked by proof. Its posture, not its lines, is what Caravan inherits.

- **Capabilities as unforgeable authority.** Every kernel object -- a thread, an address space, an endpoint, an untyped memory region -- is named and accessed only through a capability, a token of authority held in a capability space (CSpace). No ambient authority: a component can touch only what it holds a capability for. Authority is granted by explicit transfer, never assumed by position.
- **IPC through endpoints, synchronous and small.** Threads communicate by sending and receiving on endpoint objects. Message passing is deliberately minimal -- a few message registers plus the ability to transfer capabilities -- so the fast path stays fast and the kernel surface stays small. Notification objects carry lightweight signals beside the synchronous endpoints.
- **Resources are explicit: untyped memory and retype.** The kernel allocates no memory of its own after boot. Userland holds "untyped" memory capabilities and *retypes* them into concrete kernel objects, so every allocation is accounted to a holder and bounded by what that holder was granted. There is no hidden kernel heap to exhaust.
- **Policy freedom -- mechanism in the kernel, policy above it.** The kernel provides mechanism (capabilities, IPC, retype); the system's policy -- who supervises whom, what restarts on fault, how faults route -- lives in userland. This is the seam Caravan is built to fill.
- **MCS -- mixed-criticality scheduling.** The MCS extension makes CPU time itself a capability (scheduling contexts with budget and period), so time is bounded and accounted the way memory already is. Worth studying for how Caravan reasons about a supervised task's time budget, not only its memory.
- **Fault handling as messages to a handler.** A thread's fault (a bad access, an exception) is delivered as an IPC to a designated fault handler, turning fault recovery into ordinary, inspectable message handling rather than opaque kernel magic.

## What Caravan can re-express in Rye under TAME

- **Capability tables as bounded, asserted Rye records.** Caravan's capability rings already model held authority; the seL4 lesson is that authority is *only* what is explicitly held. Express a capability table with a named maximum entry count, an assert that no lookup exceeds bounds, and a named error on an absent or revoked capability -- authority proven present before use, never assumed.
- **Explicit resource accounting mirrors untyped/retype.** Tally's bounded allocation already names a budget at construction; the untyped-memory model reinforces that every allocation belongs to a named holder with a named ceiling. Caravan can carry a per-supervised-task resource budget as an explicit width count, asserted at grant and at spend.
- **Supervision and restart as fault-message policy.** Model a supervised child's fault as a value delivered to its supervisor -- a named exit/fault vocabulary term -- so restart policy is ordinary Rye control flow over a bounded set of fault kinds, each handled explicitly, echoing seL4's fault-as-IPC.
- **Time budgets alongside memory budgets (from MCS).** When Caravan's rings reach scheduling, carry a task's time budget and period as explicit-width fields with asserted bounds, rather than leaving CPU time as the one unbounded resource.
- **Minimal, synchronous message shape.** Keep Caravan's inter-component message vocabulary small and explicit -- a bounded record, not an open-ended blob -- honoring seL4's "small IPC, fast path" discipline.

## What stays out

- **No kernel source, no seL4 headers, no libsel4 lines in our tree.** GPLv2 concepts only; Caravan stays our own Rye.
- **No claim of formal verification for Caravan.** seL4 is proven; Caravan is asserted and witnessed. We inherit the discipline of proof-mindedness, not the proof itself -- and we never imply otherwise.
- **No adoption of seL4's C ABI as Caravan's API.** The capability *concept* enters; the concrete syscall shape does not become our published surface.
- **No dynamic-allocation ideas smuggled in.** The retype model is about explicit, bounded, accounted allocation; keep Caravan's Equinox-1 core static and bounded, deferring any controlled dynamism to a later, already-GREEN ring.

## Open questions this brief leaves to a later round

- Which seL4 configuration and platform table the RISC-V-under-QEMU bring-up targets (Equinox 4 horizon).
- How MCS scheduling-context budgets map onto Caravan's future scheduling ring -- study depth to grow when that ring opens.
- The per-component license read (kernel GPLv2 versus BSD-style libraries) before any tool is ever fetched, even for local study.
