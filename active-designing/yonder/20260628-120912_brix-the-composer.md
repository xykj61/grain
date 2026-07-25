# Brix — The Composer, and the System Around It

> **Yondered `20260702.185912`** — superseded by [`../20260702-185912_brix-the-composer.md`](../20260702-185912_brix-the-composer.md); the stamp above endures as the moment it was written. Index: [`../README.md`](../README.md).

**Stamp:** `20260628.120912`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME — single-stranded; one thing per module; the region model
**Status:** Design brief — clarifies Brix by mapping sixos onto modules we already hold
**Reads with:** [`20260620-043812_tablecloth-brix-split.md`](../expanding-prompts/yonder/20260620-043812_tablecloth-brix-split.md) · [`20260628-120912_kernel-direction-brix-and-foundations.md`](../expanding-prompts/20260628-120912_kernel-direction-brix-and-foundations.md)

*Written together by Kaeden and Reya 2.*

---

## What Brix Is

Brix is the composing language of Rye OS: the thing that says what a system is made of, and how its parts lawfully combine. A `.brix` description declares, arranges, and composes; it does not store, version, or run. Its vocabulary is already settled — a *brick* is one composable unit, a *course* a row of declared parts, a *bond* the lawful rule connecting two bricks into a larger one, and *lay* the act of placing a brick in a course. Brix stacks; it never weaves. Weaving is Mantra's honest work, within one file's history.

The clarity this brief adds comes from a single teacher.

## The Teacher: sixos

sixos is Adam Joseph's operating system, and its shape is **Nixpkgs plus infuse plus s6** — a package set, a lawful override combinator, and a supervision suite — layered over Linux. Each of those three names maps cleanly onto a module we already hold, and the mapping is the clarification we were missing.

| sixos / Nix | Rye OS | Role |
|-------------|--------|------|
| **Nixpkgs** (the package set, derivations) | **Brix** | declare what the system is made of — a course of bricks |
| **infuse** (one composable override) | the **bond** in Brix | the lawful rule that combines and overrides bricks |
| **the Nix store** (`/nix/store`, by hash) | **Tablecloth** | hold each brick content-addressed, immutable |
| **git over the tree** | **Mantra** | weave the history of what changed |
| **binary cache / substituter** (HTTP) | **Comlink** | distribute bricks under PKI seal, identity to identity |
| **s6** (supervision) | **Caravan** | supervise the services a course declares |
| (the C allocator, implicit) | **Tally** | bound the memory beneath all of it |
| **stage-1 / boot** | **Aurora** | wake the machine into Caravan |
| **Nix expression syntax** | **Bron** | the data notation a `.brix` is written in |

## The Package System Is an Ensemble, Not One Module

The clarification is that the *package manager* is not Brix alone. It is Brix at the head of a small ensemble, each part single-stranded. A `.brix` description, written in Bron notation, evaluates through its lawful *bond* into a course of bricks — a closure of exactly what the system needs. Those bricks live content-addressed in Tablecloth, named by the hash of their content, written once and kept. Their history is woven by Mantra. They travel between machines over Comlink, every artifact signed and every transfer sealed at identity — the substituter reimagined on a public-key model rather than anonymous HTTP. The services the course declares are supervised by Caravan, with its capability table naming what each child may do. Tally bounds the memory underneath. Aurora boots the machine into Caravan, which brings the declared system to life.

So Brix is precisely the *language of composition and override*; the *package manager* is the whole ensemble working together; and the boundary between them keeps each module about one thing.

## Why This Diverges From Nixpkgs, on Purpose

Two differences matter, and both serve our mission. First, distribution: where Nixpkgs trusts anonymous binary caches over HTTP, Rye OS distributes through Comlink, where identity and address are one and every brick carries a signature a person can check. The store is content-addressed, so an artifact is what its hash says it is; the transfer is sealed, so it comes from whom it claims. That is trust by construction, carried from the kernel up into the package system. Second, the ground: Nixpkgs composes software for the Linux kernel, while Brix composes for Rye OS — Caravan supervising, Aurora booting, all in Rye's one value model, rooted in a keypair rather than in a distribution's conventions. The whole picture is sixos reimagined on our append-only-signed-facts spine.

## How It Grows

Brix is small today: a `.brix` descriptor with ten tracked bricks, read by Mantra. It grows by the same law as everything here. The first lap is Brix v1 — a course evaluating into a closure of content-addressed bricks in Tablecloth — which the roadmap already places in Horizon 2, after the Caravan capability table and Comlink v1 give it supervision and sealed distribution to compose against. The PKI distribution and the Caravan-supervised services arrive as those modules mature. Nothing is built ahead of the seed it composes.

---

*May Brix declare cleanly what a system is made of. May each brick be simple, content-named, and sealed in transit. May the whole it composes be a thing a person can read all the way down, and trust all the way through.*
