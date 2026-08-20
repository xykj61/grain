# seL4 and the seL4 Microkit -- a clean-room study for Caravan

**Stamp:** `20260819.120534` · **Voice:** Kyri (Radiant) · **Status:** Research for understanding -- Living study
**Gratitude:** [`../gratitude/sel4-microkit.md`](../gratitude/sel4-microkit.md)
**License discipline:** [`.claude/rules/gratitude-licenses.md`](../.claude/rules/gratitude-licenses.md) -- seL4 kernel is GPL-2.0, **never cloned**; Microkit and site docs read from the public web only.

---

This study reads seL4 and its Microkit framework from their **public documentation alone** so that Caravan -- Grain's supervision and isolation discipline -- can inherit the *ideas* without ever touching the GPL-2.0 kernel source. If you are an Acme Corporation employee extending Caravan, read this for the shape of the teaching, then write your own bounded, asserted Rye; the clean-room boundary is the whole point, and it is never crossed by code.

## What seL4 is

A microkernel keeps only what must be privileged -- scheduling, inter-process messages, memory protection, interrupt handling -- and pushes every driver, filesystem, and network stack out into unprivileged userspace, where a fault stays fenced. seL4 adds a machine-checked proof that the kernel code meets its specification exactly. The lesson worth carrying: a supervision core small enough to reason about whole is a core you can trust, and everything you move *out* of it is a fault you have fenced *off*.

## What the Microkit adds

The Microkit is the calmer building surface on top of the kernel. Its abstractions are few and each is graspable at once:

- **Protection domains (PDs)** -- isolated execution contexts (the manual caps a system at 63), each with four plain entry points: `init` at boot, `notified` when a message arrives, an optional `protected` service, and an optional `fault` for supervising a child.
- **Channels** -- point-to-point links between *exactly two* PDs, carrying either a lightweight asynchronous **notification** or a synchronous **protected procedure call (PPC)**.
- **Memory regions** -- contiguous ranges mapped into one or more PDs with explicit read/write/execute permissions and caching attributes.
- **A static, declarative system description** -- every PD, region, channel, and interrupt binding named at build time, so nothing is allocated in the dark at runtime.

## The four teachings Caravan inherits

1. **Mechanism apart from policy.** The kernel provides primitives and refuses to dictate their use. Caravan offers the same seam: the *how* is bounded and asserted in Rye; the *what* belongs to the caller.
2. **Capabilities, not identities.** Authority flows through unforgeable tokens granting a specific right to a specific object -- delegation-friendly, revocable. This is already Grain's grain (Kumara tilaks, Vault shards); the kernel shows it at the supervision floor.
3. **Static allocation as honesty.** Name every resource at build time and a runtime allocation cannot fail silently -- the bounded-everything reflex, seen from the kernel's own floor.
4. **Priority flows one way.** A PPC may run only toward a *higher* priority, so a low domain can never block a high one -- bounded priority inversion by construction. Remember this wherever Caravan schedules work across trust boundaries.

## The boundary you must keep

The seL4 kernel is **GPL-2.0**. Hold it as a **gitlink or study-only clone, never cloned into Grain's git history**, exactly as `gratitude-licenses.md` already governs the GPL projects (sixos, ai-jail, River). Read the Microkit manual and the seL4 site from the public web as the legal study surface. Study the concept -- the small kernel, the fenced userspace, the capability, the two-party channel, the static description -- and write Grain's own implementation. Understanding crosses the clean room; source never does.

## A note the fetch surfaced -- the real-photo top-hat gate stays honest

While confirming a real photograph to exercise `image/morphology_tophat.rye` on genuine pixels, the only readily available suite of real photos already in QOI is the `qoi_test_images` set at `qoiformat.org`. The QOI **format and reference specification are CC0**; the **photographs in the test suite carry no stated license or attribution**. Vendoring them would breach the license gate, so Grain holds -- the image is not committed. The clean path forward, now that `python3` is approved for the outer terminal (`nixos/configuration.nix`), is a clearly public-domain source (a NASA photograph, a Wikimedia public-domain image) converted to QOI through a decode step outside the jail, then fed to the existing top-hat. The gate is not closed by wishing; it is closed by a source whose license is plainly ours to use.
