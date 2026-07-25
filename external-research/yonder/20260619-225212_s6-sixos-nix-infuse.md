# 974 · s6, SixOS, Nix, and infuse — What Caravan, Brix, and Tally Inherit

*Four projects that, read together, answer how a system should be supervised, composed, and bounded. Laurent Bercot's s6 teaches supervision as a single responsibility — one parent, one child, restart on fall, chain-loading at startup. Eelco Dolstra's Nix teaches content-addressed reproducible composition — same inputs, same output, every time. Adam Joseph's SixOS and infuse show what happens when the two meet: a system declared by Nix and supervised by s6, each individually simple, composed side by side. This research reads all four for what Caravan, Brix, and Tally should inherit, and names what each does that we should decline.*

**Language:** EN
**Version:** `20260619.225212` (Rye chronological stamp)
**Last updated:** 2026-06-19
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy
**Status:** Research

---

## s6 — Supervision as a Single Responsibility

Laurent Bercot's s6 and its foundation library skalibs carry a discipline that runs through every seam.

**What s6 does right (TAME-aligned):**

- **One supervisor per service.** `s6-supervise` watches exactly one daemon. When the daemon dies, the supervisor restarts it. The relationship is direct: one parent, one child, restart on fall — the same pattern our Caravan seed proves.
- **The root never dies.** `s6-svscan` sits at process one, never exits, never forks wildly. It is the anchor the entire tree hangs from. Caravan inherits this: the root supervisor is the one process whose termination is the system's termination.
- **Chain-loading.** Each boot step sets one piece of state and execs to the next. No subprocesses accumulate; the startup reads as a clear sentence. Each link names what it does and hands off. Caravan's microkernel startup inherits this discipline directly.
- **The service directory is the configuration.** All metadata lives in a directory: `run` (the command), `finish` (cleanup), `notification-fd` (readiness), `timeout-kill` (how long to wait). No external database. The filesystem is the source of truth.
- **Readiness as a single byte.** A service announces it is ready by writing one byte to a known file descriptor. No protocol, no handshake, no polling. The supervisor watches the descriptor. Simple, fast, unforgeable.

**What s6 does that we should adapt rather than borrow whole:**

- **s6 is not a kernel.** It runs atop a Unix kernel and uses Unix process semantics. Caravan's microkernel design places supervision *inside* the kernel layer (as 984 describes), with capabilities rather than Unix file descriptors. We inherit s6's *discipline* — the single-responsibility supervision, the chain-loading, the readiness pattern — and express it through our own capability model.
- **skalibs' one-owner-per-pointer** is the same discipline Tally's gardens enforce: one owner, explicit lifetime, clear whole on exit. We inherit the principle; the implementation is Rye's, through Tally.

**What to decline:**

- s6's dependency ordering lives in s6-rc, a separate layer. For Caravan, dependency ordering is part of the Brix descriptor — the declaration says what depends on what, and Caravan enforces the order. We keep the separation of concerns (supervision vs. ordering) without the extra tool.

---

## Nix + infuse — Content-Addressed Reproducible Composition

Eelco Dolstra's Nix, bridged to s6 by Adam Joseph's infuse, gave us the model for how a system should be declared and built.

**What Nix + infuse do right (TAME-aligned):**

- **A derivation is a pure function of its inputs.** Same inputs, same output, every time. No hidden dependencies, no environment state that leaks. This is the composability that makes caching, distributed building, and reproducibility possible.
- **Content-addressed outputs.** Every build output is named by the hash of its inputs. The name is a promise: the bytes behind it will never change. This is the same discipline Brix's build store keeps with SHA3-256, and the same content-naming Mantra uses for weave states.
- **Immutable store.** Once built, an output is never modified. The store grows by accretion — the same accretion discipline Rye keeps in its versioning.
- **Lazy evaluation.** Nix evaluates expressions only when needed. Self-referential configurations (a service that refers to its own outputs) work naturally through laziness with cycle detection.

**What Nix + infuse teach Brix:**

- **The store model.** Brix's own build store holds blobs named by hash, never revised. Brix is the declaration — what to build, from what inputs. The relationship mirrors the Nix infuse derivation-to-store path: the descriptor feeds the store, and the store holds the results.
- **Parameterized declarations.** A Brix descriptor that takes parameters (which files, which version, which target) is a function that returns a declaration. The full Brix grows toward this, once the seed format (plain key-value) has proven itself.

**What to decline:**

- **Nix's expression language grew rich and complex.** We keep Brix deliberately simple: plain key-value in the seed, a small composing language later. The composability is the Nix + infuse gift; the simplicity is ours.
- **Nix's lazy evaluation model.** Brix evaluates eagerly — the descriptor is read once, at startup. Lazy evaluation introduces complexity that the seed does not need.

---

## SixOS — Composition as Vision

Adam Joseph's SixOS sees what belongs together: s6's supervision and Nix infuse's reproducible composition are two halves of one idea.

**What SixOS teaches:**

- **The declaration feeds the supervisor.** A SixOS system is declared in Nix (what services exist, what they depend on, how they are configured) and supervised by s6 (restart on fall, readiness notification, chain-loading). The declaration is pure; the supervision is effectful. The two meet at the service directory: Nix generates it, s6 reads it.
- **Overlays as the composition layer.** SixOS builds the system through Nix overlays — functions that take the previous scope and return additions. Each overlay sees what came before; composition is purely functional, with late binding.
- **Services, agents, targets.** SixOS distinguishes the service template (reusable logic), its instances (host-specific configuration), and its targets (role in the startup graph). The separation keeps each concept individually simple.

**What we inherit — in our own terms:**

- **Brix is our declaration; Caravan is our supervisor.** Brix describes what a system is made of. Caravan watches what runs and restarts what falls. The two meet at the policy — a value that names what capabilities each process receives.
- **The insight is the composition, not the tools.** SixOS composes s6 and Nix; we compose Caravan and Brix. The relationship is the same; the implementation is ours.

**What to decline:**

- **SixOS uses a Unix kernel.** Our Caravan is a microkernel — the supervision and isolation live inside a minimal trusted core with hardware-enforced boundaries, as 984 describes. We inherit SixOS's *vision* of declaration meeting supervision; we decline its reliance on a borrowed kernel.

---

## infuse — The Bridge Between Declaration and Supervision

Adam Joseph's infuse shows how to connect Nix's pure declarations to s6's running supervision tree.

**What infuse teaches:**

- **Desugaring as a design discipline.** infuse accepts syntactic sugar, then immediately desugars to a canonical form. Leaf values in the canonical form are always functions. The semantics are unambiguous; composition is predictable.
- **Monoid preservation.** infuse respects list concatenation, attribute merging, and function composition as monoid operations. Identity elements hold; associativity holds. This is algebraic discipline applied to system configuration.
- **O(n) via pre-pass pruning.** A separate pre-pass identifies empty subtrees, preventing the recursive check from going quadratic. Semantic correctness (no attributes from empty trees) is preserved while performance stays linear.

**What Brix inherits:**

- **Canonical intermediate form.** When Brix grows past the seed format, its richer declarations should desugar to a canonical form before evaluation. This keeps the core algorithm simple while the surface syntax grows.
- **Algebraic composition.** If Brix gains a merge operation (composing two descriptors), that operation should respect identity and associativity. The merge of an empty descriptor with any descriptor is that descriptor. The merge of three descriptors is the same regardless of grouping.

---

## What Each Project Teaches Our Modules

| Project | Caravan | Tally | Brix |
|---------|---------|-------|------|
| **s6** | Supervision loop, chain-loading, readiness as a single signal, the root that never dies | Service state kept separate from configuration | Service directory schema as a model |
| **skalibs** | One-owner resource lifecycle | One-owner-per-pointer, bounded allocation, TAI timestamps | — |
| **Nix** | Cache-friendly service plans (same inputs → same result) | — | Content-addressed outputs, parameterized declarations, immutable store |
| **SixOS** | Declaration feeds supervision; overlay composition | — | Service templates separated from instances |
| **infuse** | — | — | Desugared canonical form, monoid-respecting merge |

---

## The Through-Line

One idea, seen five times: a system is composed of simple parts, each about one thing, each placed side by side rather than woven together. s6 keeps supervision simple by refusing to own dependencies. Nix keeps composition pure by refusing to allow mutation. SixOS joins the two without tangling them. infuse merges without clobbering. And skalibs, beneath them all, keeps every pointer owned and every allocation bounded.

We carry this forward in our own vocabulary: Caravan supervises, Brix declares and stores, Tally bounds, and the parts meet at capabilities and policies that are values — the same value model that flows everywhere in the family.

---

## Sources

- **s6**: Laurent Bercot, skarnet.org. ISC license. `../gratitude/s6/`.
- **skalibs**: Laurent Bercot, skarnet.org. ISC license. `../gratitude/skalibs/`.
- **Nix**: Eelco Dolstra and contributors, NixOS project. LGPL-2.1. `../gratitude/nix/`.
- **SixOS**: Adam Joseph, Codeberg. GPL-3.0. `../gratitude/sixos/`.
- **infuse**: Adam Joseph, Codeberg. `../gratitude/infuse.nix/`.

All read for concepts, not for code or naming conventions. The design decisions are our own.

---

*May we honor what each builder taught — supervision from Laurent, composition from Eelco, the composed vision from Adam, and the discipline of the bounded, single-owned allocation from skalibs — and may our own modules carry those lessons forward in names and shapes that are wholly ours.*
