# Glow OS — Get Started

**Language:** EN
**Version:** `20260713.235900` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Status:** Scaffold — the getting-started path as it will read; steps marked real or proposed

---

**Navigation:**
[Hub](README.md) · [Overview](overview.md) · **Get Started** · [The Four Variants](variants/README.md)

---

## The Path (mirrors Urbit's own "get on the network," adapted)

Urbit's getting-started path is: get an identity, boot the OS, join the network. Glow OS keeps that shape and marks honestly what exists today.

1. **Choose a variant.** Pick one of Reya, Riyo, Trey, or Triz. For a first read, any is equivalent — they are one design seen four ways. *(Proposed; the variants are named, not yet built.)*
2. **Get an identity.** Glow OS's identity seam is Kumara (Ed25519), which already echoes Urbit's point-identity model. On the live Urbit network, an identity is an Azimuth point; a placeholder used in these docs is always a deliberately invalid name like `~acme-corp-test-ship` — never a real `@p`. *(Kumara runs today; Azimuth integration is open.)*
3. **Boot the variant.** A fake/local boot for testing needs no network and no real identity — the same idea as Urbit's fake ship. *(Proposed; boot path not yet built for the variants.)*
4. **Work inside the enclosure.** On macOS, run the editor inside the `sandbox-exec` enclosure — this is real today: `./tools/cursor-jail-macos.sh`, witnessed green ([`macos-ai-jail-setup.md`](../guides/macos-ai-jail-setup.md)). *(Real.)*

## What You Can Actually Run Today

- The macOS enclosure launcher and its witness — real, green on this host.
- The many module seeds (Rishi REPL, Mantra, Comlink, Scribble, and the rest) under the prior name, via their own `tools/*.rish` witnesses.

## What Is Scaffold

- The four named variants as bootable OS builds.
- Glow the language and its Nock interpreter.
- The Azimuth/Comlink network join.

These are named and scoped in the specs this hub links to; they are not yet things you can boot. This page will fill in, step by real step, as each lands a witness.

---

**Navigation:**
[Hub](README.md) · [Overview](overview.md) · **Get Started** · [The Four Variants](variants/README.md)
