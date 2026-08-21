# Clean-Room Brief -- Microkit Protection Domains and Channels, as they Inform Caravan

**Stamp:** `20260819.094721` -- **Status:** Mixed -- Living (clean-room brief) -- **Voice:** Kyri
**Register:** Radiant -- **Commissioned by:** [`../external-research/20260819-094721_microkernel-target-study-weight-recenter.md`](../external-research/20260819-094721_microkernel-target-study-weight-recenter.md)
**Studies:** Microkit (formerly seL4 Core Platform) -- Trustworthy Systems' official, subtractive layer over seL4 for static architectures.
**License boundary:** Microkit ships under friendlier (BSD-style) terms than the seL4 kernel, yet this brief still keeps the **clean-room boundary**: **design concepts and docs only, no source in our tree.** Rule: [`gratitude-licenses`](../.claude/rules/gratitude-licenses.md).
**Reads only** the Microkit model, user manual, and design rationale.

---

## The concepts worth internalizing

Microkit is deliberately **subtractive**: it exposes a small, opinionated slice of seL4 aimed at systems whose component structure is fixed at build time. Its smallness is the point -- it rules out whole classes of complicated dynamic patterns so the resulting system stays simple enough to reason about and, potentially, to verify further.

- **Protection domains (PDs).** The unit of isolation and execution: a single-threaded, event-driven component with its own address space and its own capabilities. A PD is passive until an event arrives; it handles the event and returns. There is no sprawling thread soup -- one PD, one clear responsibility.
- **Channels.** A statically declared communication link between exactly two protection domains. Channels are the only way PDs talk, and they are known at build time, so the full communication graph of the system is visible in the description rather than discovered at runtime.
- **Memory regions.** Explicitly declared, explicitly mapped shared memory, granted to named PDs with named permissions. Sharing is deliberate and visible, never ambient.
- **The event-driven model.** A PD implements a small set of entry points -- notified (a channel signal arrived), protected-procedure-call (a synchronous request from another PD), and fault (a child PD faulted). The whole behavior of a component is these few handlers over a bounded set of events.
- **The system description.** A single declarative file names every PD, channel, memory region, and their wiring. The static architecture *is* this description; the build turns it into a bootable image. Nothing about the component graph is decided at runtime.

## What Caravan can re-express in Rye under TAME

- **The protection domain as Caravan's supervised-component shape.** A PD -- single responsibility, event-driven, passive until signalled -- is a clean template for a Caravan-supervised unit. Model it in Rye as a bounded handler over a named, closed set of events, each handler short and asserted, echoing the "one PD, one job" discipline.
- **Channels as a static, build-time supervision graph.** Caravan's supervision tree can borrow the lesson that the *whole graph is known and declared*, not discovered. Express the wiring as a bounded, asserted Rye record -- a fixed roster of links between named components -- so the supervision topology is inspectable at construction, not emergent at runtime. This pairs naturally with the parity witnesses: a static graph is a graph a witness can check whole.
- **Memory regions as explicit, named, permissioned shares.** When Caravan components must share state, model it as a declared region with a named holder set and named permissions -- explicit width, asserted bounds, no ambient sharing -- mirroring Microkit's deliberate-sharing rule.
- **The event vocabulary as a closed, named set.** Microkit's few entry points (notified, protected-call, fault) argue for a *small, closed* event vocabulary. Caravan's exit/fault vocabulary already leans this way; the Microkit lesson is to keep the whole event surface small enough to enumerate and assert over, rather than open-ended.
- **A declarative system description as the source of truth.** A Caravan configuration that names components and wiring declaratively -- parsed, bounded, asserted, then realized -- fits the tree's existing Brix/Bron habit of declaring systems as data. The static description is the artifact a witness reads to prove the graph.

## What stays out

- **No Microkit source, no libmicrokit, no its build tooling in our tree.** Concepts and the shape of the model only; Caravan stays our own Rye.
- **No adoption of Microkit's file format verbatim as our config.** The *idea* of a declarative static description enters; the concrete syntax stays ours (Brix/Bron shaped), not a copy.
- **No dynamic PD creation as a default.** Microkit's whole virtue is static-at-build-time; Equinox 1 keeps that virtue. Any later controlled dynamism is a deliberate, separately-witnessed ring, never the starting posture.
- **No implication that a Caravan mirror is "Microkit-compatible."** We sit *beside* the model honestly; we do not claim binary or interface compatibility we have not built and witnessed.

## Open questions this brief leaves to a later round

- How closely Caravan's declarative supervision description should resemble Microkit's system-description shape while staying Brix/Bron-native.
- Whether the single-threaded, passive-until-signalled PD model fits every Caravan ring, or only the leaf components, with richer supervisors above.
- How a static Microkit-style graph coexists with the deliberate later dynamism Genode's ideas would bring to a post-GREEN ring.
