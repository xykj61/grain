# 991 · Useful Utilities — What We Lean On, and What We'll Re-Grow

*An inventory of the small tools worth vendoring into `gratitude/` so our work runs reliably today, ordered by how readily each becomes a TAME Rye module tomorrow. What we lean on, we eventually re-grow in our own hand.*

**Language:** EN
**Version:** `20260617.201612` (Rye chronological stamp)
**Last updated:** 2026-06-17
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME priority — safety, performance, then the joy of the craft
**Status:** Living roadmap

---

## Why This List

We work inside `ai-jail`, a deliberately small room. That smallness is a gift: it shows us exactly which tools we truly depend on, because the moment one is missing we feel it. This document gathers those tools into a single, growing list, so that when the terminal is ready we know precisely what to clone, build, and keep.

Two horizons sit inside every entry. The **near horizon** is reliability now: vendor the tool into `gratitude/`, build it from source or keep a trusted binary, and let our work proceed without friction. The **far horizon** is ownership: anything we come to lean on is a candidate to re-grow as a TAME Rye module, written in our own hand and our own vocabulary. The list is therefore both a shopping list and a roadmap. The order reflects how cleanly each tool makes that journey from borrowed to grown.

A small lesson from today seeds the first entry: a broad filesystem traversal wedged our shell. The cure is a single, reliable, static toolkit we control, so that diagnostics never again depend on a fragile host shell.

---

## The Clean-Room Principle for Re-Growing

When we re-grow a tool in Rye, we grow it from the **specification and the observed behavior**, not from another project's source. This keeps Rye's standard library clean in provenance and free in license. So we favor references that are already permissive — the suckless tools (MIT/ISC), the skarnet suite (ISC), toybox (0BSD), monocypher (CC0) — because reading them carries no encumbrance. Tools under stronger copyleft we are glad to *use* as vendored binaries; when we re-grow their function, we write to the POSIX standard and to behavior we can test, so what lands in Rye is wholly ours. Gratitude for the lesson, independence in the result.

---

## Tier 0 — A Reliable Floor for the Jail (do first)

The very first need is a toolkit that always works, in one static binary we trust.

- **toybox** — *0BSD, single static binary.* One executable that answers as `ls`, `cat`, `find`, `grep`, `sed`, `wc`, `du`, and a hundred more. The permissive license makes it the friendliest reference of the bunch. **Near:** instant, dependable basics inside the jail. **Far:** a living catalog of the commands a Rye base suite should eventually offer.
- **busybox** — *GPLv2, single static binary.* The embedded world's workhorse, even more complete than toybox. **Near:** a fallback floor if toybox lacks an applet we need. **Far:** used, not derived — its applet list informs our spec, its code stays at arm's length.
- **a POSIX shell** (`dash`, or toybox/busybox `ash`) — *permissive / GPLv2.* A small, predictable shell so our scripts never depend on an interactive shell's surprises. **Far:** see execline below, which is the TAME answer to scripting.
- **ai-jail → Pond** — *GPLv3 (ours: TAME Rye).* The sandbox that makes this whole environment safe to begin with. It layers Linux's own isolation — `bwrap` namespaces, Landlock filesystem rules, seccomp syscall filtering, and resource limits — to grant an agent only the paths we allow. **Near:** vendored into `gratitude/`, it is the very room we already work in. **Far:** **Pond**, our gentle reimplementation — a bounded, living enclosure rather than a cell — re-grown in Rye over those same Linux primitives, with TAME's explicit allow-lists and bounded resources. The name honors gentle aquatic life: water held kindly within clear edges, where work flourishes in safety.

---

## Tier 1 — Minimal Coreutils, the Seeds of a Rye Base (highest re-grow value)

These are the cleanest first candidates for Rye, because they are small, readable, and do one thing each.

- **sbase** — *suckless, MIT/ISC.* Portable POSIX coreutils in spare, legible C. This is the model for a future `rye-base`: each command short enough to hold in the eye, each one honest about its bounds. **Far:** our single best starting point for coreutils in Rye.
- **ubase** — *suckless, MIT/ISC.* The Linux-specific companions — mount, ps, and kin — that sbase leaves out by design. **Far:** the system-facing half of a Rye base suite, and a natural neighbor to Caravan.

---

## Tier 2 — Supervision and Services, the Lineage of Caravan

Caravan is, in essence, this family re-grown. Vendoring it brings the study close and gives us a working supervisor today.

- **skalibs** — *skarnet, ISC.* The foundation library: owned strings (`stralloc`), an event loop on absolute deadlines (`iopause`), TAI64N time. musl-first by design. **Far:** its ideas already flow into Tally and Caravan.
- **s6** — *skarnet, ISC.* A supervision tree that is small, correct, and chain-loaded. **Far:** the direct ancestor of Caravan's process model.
- **s6-rc** — *skarnet, ISC.* A dependency-ordered service manager atop s6. **Far:** Caravan's notion of bringing a system up in order.
- **execline** — *skarnet, ISC.* A non-interactive scripting language with no parsing surprises — every word is a program that chain-loads the next. **Far:** the TAME spirit of scripting, and a model for how Rye might describe service startup without a shell's ambiguity.
- **s6-portable-utils** and **s6-linux-utils** — *skarnet, ISC.* Tiny, single-purpose utilities (`s6-cat`, `s6-test`, and so on) built the skarnet way. **Far:** companions to a Rye base, written to the same minimal taste.

---

## Tier 3 — Build and Reproducibility

- **samurai** — *MIT.* A ninja-compatible build tool in a few thousand lines of C. **Near:** fast, small builds without a heavy dependency. **Far:** a clear reference for how Tablecloth might drive builds.
- **redo** (e.g. `redo-c`) — *permissive.* Djb's build design: each target a small script, dependencies discovered as they are used. **Far:** a second model for Tablecloth's build reasoning, complementary to samurai's graph.
- **zig** — *already vendored.* Our compiler and, for now, the ground beneath Rye's standard library.

---

## Tier 4 — Crypto and Integrity, for Mantra, Tally, and Tablecloth

- **monocypher** — *CC0 / 2-clause BSD, single file.* Audited primitives — Blake2b, ChaCha20, Poly1305, X25519, Ed25519, Argon2 — in one readable file. **Near:** everything content-addressing and signing needs. **Far:** the ideal size and license to re-grow as Rye's own `std.crypto` companions — a right-sized reference for the signing and hashing primitives Mantra and Tally lean on. For the SHA3 family Mantra recommends, our `std` already carries Zig's implementation, so monocypher complements rather than supplies it.

---

## Tier 5 — Search and Navigation, the Joy of the Craft

The third TAME value lives here: tools a person delights in.

- **ripgrep** (`rg`) — *MIT / Unlicense, Rust.* The north star for fast, ergonomic search. **Near:** a real speed-up while we work. **Far:** a target to *match in feel* once a Rye search tool matures — we study its experience, then earn it ourselves.
- **fd** — *Rust.* A friendly `find`. **fzf** — *Go.* Fuzzy selection. **Near:** daily ease. **Far:** experience references, not code ancestors.

---

## Tier 6 — Version Control, the Lineage of Mantra

- **got** (Game of Trees) — *ISC.* A smaller, clearer take on a Git-compatible workflow from the OpenBSD world. **Far:** a readable reference for the plumbing Mantra must also provide.
- **manyana** — *already vendored.* Bram Cohen's CRDT version control, the seed of Mantra's always-succeeding merge. **pijul** — *Rust.* The patch-theory line of thinking, a reference worth keeping near. **Far:** together, the heart of how Mantra merges without ever refusing.

---

## Tier 7 — Data and Configuration, the Lineage of Tablecloth

- **jq** — *MIT.* Querying and shaping structured data. **Near:** handling JSON in the jail. **Far:** informs how Tablecloth reads and transforms configuration values.
- **sixos** and **infuse.nix** — *already vendored.* The s6-and-Nix composition lineage, with `infuse`'s lawful combinator, that feeds Tablecloth directly. The Nix language itself stays a studied reference.

---

## Tier 8 — Compression

- **heatshrink** — *ISC, tiny.* LZSS compression small enough for the smallest targets. **Far:** a right-sized seed for a Rye compression module.
- **zstd** / **zlib** — *permissive.* Behavior and format references when we need strength over smallness.

---

## A Foundational Note: musl

- **musl libc** — *MIT.* The small, correct C library our whole taste is shaped by — static-friendly, RISC-V-ready, readable. We treat it as the reference for what a lean system interface looks like, the same way we treat RISC-V as fixed ground for hardware.

---

## What Each Becomes in Rye

The list resolves into a few clear destinations. The coreutils families (sbase, ubase, toybox's catalog) become **a Rye base suite** atop our own `std`. The skarnet suite becomes **Caravan**. The crypto file becomes companions to **Rye's `std.crypto`**, serving **Mantra** and **Tally**. The build tools and Nix lineage inform **Tablecloth**. The version-control line feeds **Mantra**. The sandbox becomes **Pond**, the gentle enclosure our agents work within. Seen this way, the utilities are not a detour from the modules — they are the modules, met early, in a form we can run today.

---

## Starting Order, When the Terminal Returns

1. **toybox**, built static — so the jail always has a dependable floor and today's wedge cannot recur.
2. **sbase** (and **ubase**) — the cleanest seeds for a Rye base suite, read with re-growing in mind.
3. **skalibs → s6 → s6-rc → execline** — the Caravan lineage, vendored together so the study and the working supervisor arrive at once.
4. **monocypher** — small, permissive crypto for the integrity work ahead.

Each clone lands in `gratitude/`, each is catalogued in `gratitude/README.md` with its source and license, and each carries the same quiet promise: we honor it by use now, and one day by re-growing its gift in Rye.

---

*May the tools we borrow serve us well, and may the day come when each is met again — smaller, clearer, and wholly our own.*
