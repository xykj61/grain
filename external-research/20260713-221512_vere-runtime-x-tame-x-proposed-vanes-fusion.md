# Vere's Runtime, Read Against TAME and the Proposed Vane Names

**Language:** EN
**Version:** `20260713.221512`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Research — reads `vere/old`'s actual source, proposes no code merge yet

---

## What This Answers, for an Acme Corporation Employee Reading This

Kaeden asked for a study of `urbit/vere`'s own codebase (now resting at `vere/old` in this fork) against TAME's discipline and the proposed vane-parallel names from this session's naming-mapping proposal — a real look at Vere's C source, not a description from memory. This document reads the actual files, sizes them, and names where Vere's runtime already lines up with a Rye OS module, where it does not, and where TAME's own rules would need to bend or hold firm against Vere's own established patterns.

---

## Vere's Actual Shape, Read Directly

```
vere/old/pkg/
├── noun/           the Nock VM itself
│   ├── nock.c          (3,372 lines) — the interpreter: opcodes 0-11, tree addressing
│   ├── allocate.c      (2,126 lines) — the noun allocator: "roads" (nested memory arenas)
│   ├── jets.c          (2,499 lines) — accelerated native shortcuts for common Nock formulas
│   ├── hashtable.c     (1,420 lines) — hash-consing: structural sharing of identical nouns
│   └── serial.c + ur/serial.c — jam/cue: noun-to-bytes and back
├── vere/           the runtime shell around the VM
│   ├── io/             one file per vane's *runtime* half: ames.c, behn.c, term.c, http.c, lick.c...
│   ├── db/lmdb.c   (639 lines) — the persistent event log (LMDB-backed)
│   └── ivory/           the precompiled Hoon kernel boot image
├── c3/             base types and platform shims (Vere's own small "std" replacement)
├── ur/             jam/cue serialization, independently packaged
└── ent/, past/     entropy and legacy/history support
```

**The load-bearing finding:** Arvo's ten vanes are a *Hoon-side* kernel concept — `sys/vane/ames.hoon` and its nine siblings are Hoon source, interpreted by Nock. Vere's `pkg/vere/io/ames.c` is not that vane; it is the **runtime's own I/O half** that feeds raw events (a packet arriving, a timer firing, a keystroke) into the Hoon-side vane through Nock, and carries the vane's *effects* (send this packet, print this line) back out into the real operating system. Every vane has both halves — the Hoon-side logic vane in `urbit/urbit` (now `old/` in this fork) and the C-side runtime driver in `vere/old/pkg/vere/io/`. Any real fusion needs to name which half of which vane it is actually proposing to fuse.

---

## Module-by-Module: Where Rye OS Already Lines Up, and Where It Doesn't

| Vere component | Lines | Closest Rye OS module | Read against TAME |
|---|---|---|---|
| **`noun/nock.c`** — the Nock interpreter | 3,372 | No current module — this is exactly the gap the Nock-interpreter scoping doc named | Vere's own `nock.c` is hand-tuned C with deep tree-recursion for opcode 2's self-reference (`*[a 2 b c]` calls `*` again) — the same unbounded-recursion tension named in the Nock/Hoon fusion scoping doc, now confirmed present in Vere's *own* reference implementation, not only in Hoon source. A TAME-faithful interpreter would need an explicit, named recursion-depth bound with an asserted ceiling, where Vere's C simply trusts the C stack |
| **`noun/allocate.c`** — the "road" allocator | 2,126 | **Tally**, closely | Vere's "roads" are nested, freeable memory arenas — almost exactly Tally's own "named gardens" concept (bounded regions, freed as a season closes). This is the single cleanest fusion candidate in this whole document: Tally already has the right *shape*; it would need to grow Vere's specific noun-allocation pattern (cons-cell-style paired allocation, hash-consed dedup) as a new named garden kind, not a wholesale replacement |
| **`noun/hashtable.c`** — hash-consing | 1,420 | No current module | Nock's hash-consing (structural sharing so two identical nouns are one allocation) has no Rye OS analog today — Bron's one-value model does not currently dedupe by structure. This is a real, un-covered gap this study surfaces plainly rather than glossing over |
| **`noun/jets.c`** — accelerated native shortcuts | 2,499 | Conceptually close to nothing in Rye OS, and worth naming as a design pattern on its own | A jet is a proof obligation as much as a performance trick: the native code must be provably equivalent to the (slower) pure-Nock formula it replaces. TAME's own "pair your assertions" rule (assert equivalence on both paths) is a *natural* fit here, arguably a better-specified version of jet-correctness than Vere's own informal convention |
| **`vere/db/lmdb.c`** — the persistent event log | 639 | **Mantra**, closely, per the naming-mapping proposal's own Clay parallel | Mantra's weave already plays this role conceptually; LMDB's specific durability guarantees (memory-mapped, copy-on-write B-trees) are a real, separate research question from Mantra's own current storage backend, worth its own future study rather than folding in here |
| **`vere/io/ames.c`** — networking runtime | (part of `io/`) | **Comlink**, closely, per the naming-mapping proposal's own Ames parallel | Comlink's sealed datagram model and Ames's own encrypted-packet model are close enough that this is the second-cleanest fusion candidate after Tally/allocate.c |
| **`vere/io/term.c`, `http.c`, `lick.c`** | (part of `io/`) | No current 1:1 Rye OS module — Dill (terminal), Eyre (HTTP), Lick (low-level IPC) have no vane-level Rye OS parallel yet, only Rishi (Dojo-parallel) at the app layer | Naming this gap matters: fusing Vere wholesale would mean growing three new kernel-level modules that do not exist in Rye OS today, not merely renaming three that do |

---

## The TAME Question Vere's Own Source Answers Honestly

Reading `nock.c` directly settles something the earlier Nock/Hoon fusion scoping doc could only pose abstractly: **Vere's own reference Nock interpreter does not bound its recursion depth explicitly** — it trusts the host C stack, the same way Hoon's own idiom trusts Nock's interpreter to keep evaluating. This is not a flaw unique to Hoon; it is load-bearing in Vere's *runtime* too. A TAME-faithful Nock interpreter genuinely diverges from Vere's own reference implementation here, not only from Hoon's surface syntax — worth carrying into whichever of the three resolutions from the earlier scoping doc Kaeden eventually chooses.

---

## What a Real Fusion Would Actually Require, Named Plainly

1. **Tally grows a Vere-style "road" garden kind** — the closest, cheapest real fusion; already TAME-shaped
2. **A new module for hash-consing** — no current Rye OS analog; a genuine gap, not a rename
3. **The Nock interpreter (once built, per the earlier scoping doc) names an explicit, asserted recursion bound** — diverging from Vere's own C reference on purpose, for TAME's sake
4. **Comlink grows toward Ames's specific wire behaviors** — a real but bounded extension of work already in progress
5. **Dill, Eyre, and Lick have no Rye OS analog today** — fusing Vere "wholesale" means building three new kernel modules from scratch, not renaming three existing ones; this is the single biggest scope-correction this study offers against the original "full rename" framing

---

## What This Document Does Not Do

- It does not merge any code from `vere/old` into any Rye OS module — per this project's own `gratitude/`-style discipline ("held whole for clean-room study. Never copy code or text into our modules"), any real fusion would be a clean-room reimplementation informed by this reading, never a copy-paste.
- It does not resolve the Nock-recursion-bound question — it confirms the question is real by pointing at the exact line of reasoning in Vere's own reference source, and leaves the resolution to the earlier scoping doc's three named options.

---

*May the reading stay honest about what already fits and what would need to be grown from nothing, so the fusion — whenever it comes — knows its own true size before it begins.*
