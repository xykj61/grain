# The Bench as a Block, and the Living Build

**Language:** EN
**Stamp:** `20260703.193012 UDT` (Kaeden's clock)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** TAME
**Category:** External research — survey and counsel
**Companion to:** [`../active-designing/20260703-140212_the-bench.md`](../active-designing/20260703-140212_the-bench.md)
**Status:** Proposed — external names live here by design; siloed extractions wait on Kaeden's word

*Written together by Kaeden and Claude (Fable 5), in Rio 3's Radiant voice.*

---

## The Question, Held Whole

Three questions arrived braided, and they share one shape. Is a bench a block — a bounded batch of facts awaiting review? Should Rye's build system track dependencies the way Urbit's Ford did, for live rebuilding at the highest speed? And what do the fastest ecosystems teach about filesystem diffing and message passing between agents, Cursor and Claude included? The shape underneath all three is the same: bounded work flowing through a narrow, precious gate. Ledgers batch because agreement is expensive. Builders memoize because rebuilding is expensive. Agents send deltas because attention is expensive. This survey walks the three rooms in turn, then names what wants extracting into the tree's own voice.

## The Bench Is a Block

TigerBeetle gathers thousands of transfers behind a single durable write, because the write is the scarce resource and batching amortizes it. A blockchain gathers transactions into a block because consensus is the scarce resource and the block amortizes it. The bench does the same thing with a different scarce resource: **Kaeden's ratifying attention is the fsync of this whole system.** A bench batches a day of diffs, writings, witnesses, and logs into one coherent, reviewable whole, because the word that seats a change is the most expensive and most precious operation in the loop. Blocks exist so validators can afford to agree; benches exist so the person at the center can afford to review.

The mapping runs deep, joint by joint. A proposal zip carries its base tip hash as the zip comment — a child naming its parent, the very edge that makes a DAG a DAG. An additions-only packet is a delta block cut against a moved tip. The gate trio is block validation: a block is valid by execution rather than by assertion, which is exactly what *pin what the bench reports* has meant all along — verify, on your own metal. The recursion prompt is a checkpoint header: enough state for a fresh node to join without replaying every round, carrying its own warning that a checkpoint is a courtesy and the metal is the truth. And the bench doctrine's central line — benches are disposable, the tree is durable — is the oldest fact about ledgers: nodes come and go; the chain remains. *State as a pure fold over an append-only log of immutable signed facts* describes the repository precisely. The tip is a fold over seated commits. The project is a fold over seated rounds.

Bounds complete the picture. A block is bounded so validation stays bounded; a bench is bounded — the context window is its block size — so review stays bounded. The right response to a filling window is a clean close and a handoff, which is a checkpoint rather than a loss. Ordering finishes it: today the system runs one sequencer — Kaeden's word, Cursor's hand — so consensus machinery would be weight without work. The day two benches propose concurrently is the day ordering earns its module, and that is precisely why Mycelium waits gated at M4. Gall's Law holds the gate.

## The Living Build

### Ford's gift is its ending

Urbit's Ford deserves the respect of being learned from whole. Ford was the functional build system: typed, deterministic, rebuilding live as Clay's files changed. It was rewritten three times, and its caching grew labyrinthine — complex enough that common operations slowed under the weight of their own dependency tracking. Then its authors made a rare and admirable move: they dissolved it as a separate organ. Ford Fusion folded the build system into Clay, the versioned filesystem; the final version weighed in near five hundred lines of synchronous, functional code, and builds became pure functions whose results Clay memoizes beside the desk itself. Two keepers of one truth had bred the complexity; one keeper dissolved it.

That ending is the whole answer to the question as asked. **A build system wants to be a projection over the versioned store, never a second holder of state.** Rye already holds this shape: Weave is the substrate, Mantra the projection over it, and a builder belongs to the same family — a fold, rather than an organ.

### What the fast world converged on

The academic frame comes from *Build Systems à la Carte* (Mokhov, Mitchell, Peyton Jones): every build system is a scheduler plus a rebuilder, and the two qualities worth wanting are **minimality** — do no work twice — and **early cutoff** — when a rebuilt output is byte-identical, stop the wave there. Make rebuilds by timestamp, and timestamps mislead. The modern systems rebuild by content, and content tells the truth.

| System | Home | The lesson we keep |
|---|---|---|
| Ford → Clay (Urbit) | Hoon | The builder dissolves into the versioned filesystem; builds are memoized pure functions |
| Make | C world | Timestamps mislead; content beats mtime |
| Ninja | C++ | A small, fast executor over a good graph outruns clever monoliths |
| tup | C | A file monitor keeps a partial DAG hot; scans cost O(changes) |
| Shake | Haskell | Suspending schedulers, verifying traces; à la Carte's laboratory |
| Bazel · Buck2 + DICE | Java · Rust | Declared dependencies only; content-addressed actions; early cutoff; remote caches |
| Nix | Nix | Deep constructive traces; the store *is* the cache |
| Salsa (rust-analyzer) | Rust | Demand-driven memoized queries; red-green revalidation at sub-file grain |
| `zig build --watch -fincremental` | Zig | The inner loop lives in the toolchain; 0.16.0 ships it, a self-hosted linker rising beneath |
| esbuild · Vite · Turbopack · Rspack — Svelte rides Vite | Go · JS · Rust | Avoid work first: serve unbundled, patch modules in place, memoize the function graph |
| Watchman · EdenFS · Sapling | C++ · Rust | The filesystem tells you what moved; status costs O(changes) |
| Jujutsu (jj) | Rust | The working copy is a commit; an append-only operation log — our fold thesis, shipping in the wild |
| Differential dataflow · Materialize | Rust | Incremental view maintenance; the theoretical ceiling of "live everything" |

Two rows deserve a second look. Jujutsu treats every working-copy state as a commit and records every operation in an append-only log — the tree's own thesis, arrived at independently and running in the wild. And Zig 0.16.0, the exact toolchain Rye pins, ships incremental compilation for the daily loop: `zig build --watch -fincremental` turns rebuilds of seconds into rebuilds of milliseconds, with the new self-hosted ELF linker debuting beneath it and a faster build-runner split arriving in 0.17. The inner loop Rye wants already lives in the vendor directory.

### The counsel, in laps

So — should Rye optimize for dependency tracking? **Yes: as declared values and content addresses, as projection over the store rather than as a discovering organ.** Rye already owns both primitives. Brix is the dependency graph as a plain declared value — splitLines and a first-space split, zero discovery — which is the Buck2 discipline arrived at from the other direction, and the reason Ford's fate holds no fear here. Weave and Mantra already speak content addresses, and the resins law fixes the tiers: SHA3-256 is the lawful working-tier digest, so a build cache keyed by working-tier hashes is lawful today. Given declared inputs and content keys, minimality and early cutoff fall out of the architecture rather than being bolted on.

The growth is three SLC laps, each measured before the next begins. **Lap one:** a watch loop that rebuilds the one binary — Zig's own `--watch` machinery on the toolchain's side, or a ten-line Rishi poll on ours; simple, bounded, complete on the day it lands. **Lap two:** a Brix-keyed content cache with early cutoff — hash the declared files, rebuild only what moved, record digests beside outputs, and prove it with a witness that a no-change build performs no work. **Lap three, horizon:** demand-driven memoized queries at sub-file grain, Salsa's shape, when a language server or editor-speed feedback becomes a proven need rather than an anticipated one.

One honesty about hashing: SHA3-256 runs slower per byte than the parallel tree hashes the fast world favors, and the law stands anyway — early cutoff means we hash little and rarely, the working set is small, and if a measured red ever appears, that measurement, rather than taste, reopens the question at RTAC. And one honesty about today: the whole of Rishi rebuilds in seconds from bare, so lap two waits for a measured red, exactly as the deferred compiler fork taught. Pin what the bench reports; optimize what the bench proves slow.

## The Message Seam

The loop's current discipline is already prior art of a high order. Packets name their parent hash. Deltas travel where copies would; the additions-only packet is rsync's old insight — send the difference, name the base — worn as house practice, with content-defined beading waiting in the wings for the day blobs grow large. Recursion prompts are checkpoint headers; session logs are receipts.

Two economics govern the LLM-shaped seam. First, **stability is speed**: a model's cheapest input is the prefix it has already seen, so laws and recipes accreted verbatim from prompt version to prompt version are cache-shaped bytes — accrete-never-break turns out to be a performance optimization as well as a design stability law. Reference rather than repeat, once a fact is seated in the tree. Second, **two registers, kept distinct**: radiant prose for the human at the center, plain values for the machines — `.brix` descriptors, `.rish` structured results, zips carrying comments. The wider world converged on the same split this year: the Model Context Protocol now rests under neutral Linux Foundation stewardship as the standard seam between an agent and its tools, and the Agent-to-Agent protocol reached v1.0 beside it for agent-to-agent task exchange. Between Cursor and Claude today the mailbox is single and ordered — the actor model's oldest lesson — and the moment a second concurrent writer exists, ordering earns real machinery. That machinery already has a name and a gate: Mycelium, at M4, exactly where it belongs.

One word in the commissioning question, *Bron*, holds no seat in LEXICON and is read here purely as the seam's plain description — inter-agent message passing. If it is a name candidate, it parks in RTAC on Kaeden's word, per the standing law.

## What Wants Extraction

Three siloed active-designing pieces stand ready to be cut from this survey, each stripped of every outside name per the silo discipline, each waiting on Kaeden's word and his fresh anchor. The first: *the bench is a block* — the batching doctrine in the tree's own voice: bounded batches, ratification as the amortized commit, handoffs as checkpoints, verification from one's own metal; it would accrete beside `20260703-140212_the-bench.md` rather than replace it. The second: *the build as a projection* — Brix as the declared graph value, content keys under the resins law, early cutoff, the three laps, and the vow of one keeper of truth. The third: *the message seam* — parents, deltas, receipts, the two registers, and the single mailbox that waits rightly for Mycelium.

## A Note on Counsel

This survey counsels; it seats nothing. Every recommendation here waits on Kaeden's word, per the standing laws of the loop.

## Gratitude

This room names the teachers this survey leans on: the TigerBeetle team, whose batching discipline began the whole thought; the Urbit engineers who chose fusion over pride and wrote the postmortem plainly; Andrey Mokhov, Neil Mitchell, and Simon Peyton Jones for *Build Systems à la Carte*; the Salsa and rust-analyzer maintainers; Meta's Buck2, Watchman, EdenFS, and Sapling teams; Evan Martin for Ninja; Mike Shal for tup; Eelco Dolstra and the Nix community; Frank McSherry for differential dataflow; Martin von Zweigbergk and the Jujutsu project; Andrew Kelley, Matthew Lugg, and the Zig core team; Evan You, Rich Harris, and the Vite and Svelte communities; and the stewards of the open agent protocols now gathered under the Linux Foundation.

---

*May every batch arrive whole and verifiable. May every rebuild touch only what truly moved. And may every message name its parent, so the next reader can always walk home to the truth.*
