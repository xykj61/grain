# Dependency-tracked proving -- the world's answers, read against this harness

**Stamp:** `20260825.173153`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- research for understanding; the design that reads this is [`../active-designing/20260825-173153_reprove-only-what-moved.md`](../active-designing/20260825-173153_reprove-only-what-moved.md)
**Kin:** [`20260703-193012_the-bench-as-a-block-and-the-living-build.md`](20260703-193012_the-bench-as-a-block-and-the-living-build.md) -- the Mantra witness-receipts hammock (`counsel/date/20260726/20260726-050047`) -- [`20260825-000640_proving-a-host-you-do-not-have.md`](20260825-000640_proving-a-host-you-do-not-have.md)

## The question, and what this tree already holds

The question: when a `.rye` file changes, which of the tree's witnesses actually need to run
again, and which greens still stand? And its sharper twin: when NOTHING changed between a lap's
hot close and the next lap's cold open, why is the whole roster proven twice?

The tree has answered part of this before, and the "fusion" in the grep is Urbit's **Ford
Fusion**. Ford was Urbit's typed, deterministic build system. It was rewritten three times. Its
dependency-tracking cache grew until common operations slowed under its own weight. Ford Fusion
dissolved it into Clay: about 500 lines of pure, synchronous code, builds memoized beside the
versioned filesystem. The living-build study
([`20260703-193012`](20260703-193012_the-bench-as-a-block-and-the-living-build.md)) drew the
lesson plainly: *a build system wants to be a projection over the versioned store, never a second
holder of state.* The same study adopted the Build Systems a la Carte frame and named the two
qualities worth wanting: **minimality** (each piece of work happens once) and **early cutoff** (a byte-identical
rebuilt output stops the wave).

One more thing already stands. The **Mantra witness-receipts hammock**
(`counsel/date/20260726/20260726-050047`) designed a per-witness verdict cache in this tree's own
vocabulary: a receipt keyed on `SHA3(script_bytes || sorted_input_hashes || toolchain_pins ||
ABSENT_set)`, a gitignored shelf, and two modes -- **FAST** consults receipts, **COLD** ignores
them. Its law: FAST never satisfies a COLD gate. It waits, gated on an instrumented cost table
and Keaton's word. Everything below serves it. The world's systems are read here to inform it.

## What the harness actually does today, measured

Three readings from this round's tree walk, each checkable:

- **Every witness rebuilds.** 1,314 of the `.rish` witnesses under `tools/` call `rye/bin/rye
  build` unconditionally; 37 call `rye run`. Emitted binaries persist in gitignored `bin/` dirs,
  and freshness goes unread before each rebuild. One measured witness spent roughly 80-90% of
  its wall time compiling, not executing.
- **The digest exists and is thrown away.** `standing_equipment_run.sh` computes `tree_digest =
  sha256(git rev-parse HEAD + git status --porcelain)` at open and at close. It prints both to stdout, and the readings end with the run. The `tree_moved` refusal compares them within one run only.
- **The lap tail moves the tree after the hot roster.** The hot roster runs after `git add`. The
  commit comes later, and `tools/hooks/pre-commit` regenerates README metrics when a witness
  landed. So the tree at the next cold open differs from the tree the hot roster measured -- by
  the commit itself and often by hook-regenerated pages. A naive skip keyed on the hot-close
  digest would rarely fire under today's choreography.

## The world's answers, one lesson each

**rustc (red-green + verify-ich).** The Rust compiler memoizes queries in a dependency DAG and
revalidates with red-green marking: a node whose inputs re-fingerprint equal is green and never
recomputed. The load-bearing lesson is the failure: incremental compilation shipped **silently
unsound for 28 releases** (1.24 to 1.52), and the class was found only when
recompute-and-compare (`verify-ich`) was forced on. A dependency cache without a standing verify
mode is a cache whose wrongness has no detector. (rustc dev guide, incremental compilation
chapters; Rust 1.52.1 post-mortem; accessed 20260825.)

**Salsa / Adapton (early cutoff).** Memoized queries record their read edges; when an input
changes but a derived result comes back identical, propagation stops there. Early cutoff is what
makes fine-grained tracking pay: most edits change almost no derived results. (salsa-rs docs,
Adapton papers; accessed 20260825.)

**Build Systems a la Carte (the taxonomy).** Every build system is a scheduler plus a rebuilder.
Rebuilders differ by trace kind: a **verifying trace** stores hashes of inputs and output; a
**constructive trace** stores the output itself. A witness verdict is one GREEN line, so a
constructive trace of it costs nearly nothing -- the paper's cloud-build quadrant at
verifying-trace prices. **Deep constructive traces** key only on terminal inputs and require
determinism, or two builds weld inconsistent parts (the paper's Frankenbuild). (Mokhov, Mitchell,
Peyton Jones, ICFP 2018; accessed 20260825.)

**Bazel / Buck2 (hermeticity is structural).** An action's cache key covers command, declared
inputs, and environment -- and the sandbox denies reads outside the declared set, so a declaration stays true by construction. Declared-only dependencies stay honest because the sandbox turns an undeclared read into a loud stop rather than a leak. Grain already runs witnesses inside enclosures; the
mechanism is nearby. (bazel.build Skyframe and test encyclopedia; Buck2 DICE docs; accessed
20260825.)

**Zig (the backend's own levers).** `-fincremental` shipped experimental in 0.14 and matures
through 0.15/0.16, with in-place binary patching and millisecond rebuilds -- yet its state lives
inside a long-running `--watch` process, and `zig build-exe` performs a fresh whole-compilation
each invocation, reusing only shared artifacts from the content-addressed cache. That matches the
measured warm delta here (3.15s to 1.4s, partial). The vendored 0.16.0 toolchain already carries
these flags. (ziglang release notes 0.14/0.15; accessed 20260825.)

**Unison (cached test results, the exact analogy).** Every definition is content-addressed by the
SHA3-512 of its syntax tree with dependency names replaced by hashes. A `test>` watch expression
is a pure function; its result is cached against the test's hash and **never re-run while the
hash stands**. Impure tests are quarantined into `io.test`, which the cache leaves to run live. Purity is
what makes a cached PASS trustworthy, and the impure set is named up front rather than discovered.
(unison-lang.org, The Big Idea and testing docs; accessed 20260825.)

**Proof assistants and monorepo tools (the corroboration).** Lean's Lake hashes source, imports,
and the toolchain version into one trace; `lean4checker` replays every cached olean through the kernel, trust checked rather than assumed. Isabelle keys session builds on per-file SHA1s.
Turborepo and Gradle both document the same two failure modes: an input left off the declaration yields a false hit, and a flaky test cached green poisons everything after it. (lean-lang.org Lake
reference; Isabelle NEWS; turborepo and Gradle caching docs; accessed 20260825.)

## The four findings that survive contact with this tree

1. **A verdict cache is a constructive trace, and it is nearly free to store.** One GREEN line
   per key. The receipts hammock already chose this shape. What the world adds: store it beside a
   **verify mode** from day one, because rustc's 28 unsound releases were found by
   recompute-and-compare, never by inspection.
2. **Declared inputs and observed reads are rivals, and the synthesis is declare-then-verify.**
   The living-build counsel says dependencies enter as declared values, never as a discovering
   organ. The rustc record says hand-declared sets drift from real reads. Both hold: declare the
   manifest, then let a cadence-tier check trace actual file opens against it, the way the exec-bit
   witness already proves its refusals from both sides.
3. **Git's index is a free content-address store.** Every tracked file already carries a blob SHA
   in `git ls-files -s`. Per-witness input digests can be assembled from index hashes at near-zero
   cost. The tracked set's hashing budget is already paid.
4. **The cheapest large win skips no proof at all.** Compile time dominates witness time, and
   compilation of byte-identical sources is pure waste the receipts law never governed -- a build
   skip is not a proof skip. Every assertion still runs. This is where the design starts.

## What this note does not settle

Whether the cold-open roster may ever consult a cache is a **policy** question, and the seated
receipts design currently answers no -- FAST never satisfies a COLD gate. Amending that is
Keaton's ruling to make, not this note's. The expected hit rate of a whole-roster skip is also
unmeasured, and the lap tail's current choreography suggests it would be low until the tail is
reordered. Both facts belong to the design beside this note.

## Sources

- Mokhov, Mitchell, Peyton Jones, "Build Systems a la Carte," ICFP 2018 -- read in full this round; a session log of that read stands at `../session-logs/20260825-172213_build-systems-a-la-carte-traces-read.kyri`
- rustc dev guide, incremental compilation + queries chapters; Rust 1.52.1 incident write-up (accessed 20260825)
- salsa-rs/salsa book and Adapton publications (accessed 20260825)
- bazel.build -- Skyframe docs, test encyclopedia, user manual on `--cache_test_results`; Buck2 DICE documentation (accessed 20260825)
- ziglang.org release notes 0.14.0/0.15.x, `-fincremental` tracking issues (accessed 20260825)
- unison-lang.org -- The Big Idea, testing docs, tour (accessed 20260825)
- lean-lang.org Lake reference; leanprover/lean4checker; Isabelle2025 NEWS; docs.gradle.org common caching problems; turborepo.dev caching (accessed 20260825)
- In-tree: `external-research/20260703-193012_the-bench-as-a-block-and-the-living-build.md`, the Mantra witness-receipts hammock (`counsel/date/20260726/20260726-050047`), `tools/fixtures/standing_equipment_run.sh`, `rye/bin/rye` (read this round)
