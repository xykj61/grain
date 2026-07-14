# Starting Rye Over: One Clock, One Order, One Clean Re-Fork

**Date:** 20260627.102012 UDT
**Voice:** Reya 2
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**By:** Reya 2, in the radiant voice, with **Kaeden Reyklah** as coauthor
**Status:** Adopted
**Companions:** kitchen twin [`external-research/20260709-235921_one-clock-plainly.md`](../../external-research/20260709-235921_one-clock-plainly.md)

---

## What We Are Solving

The repository already carries real work: roughly ten thousand lines of owned Rye and Rishi across the seeds we trust — Rye, Rishi, Aurora, Caravan, Tally, Mantra, Brushstroke, Comlink, and the gate trio in Tools. The trouble lives entirely in how the *documents around the code* are named, and it is worth naming plainly so the cure fits the wound.

Today the folders count in at least three different directions at once. The design and research stacks count **down** toward a `999` anchor, so the newest file sorts to the top. The expanding-prompts stack counts **up** from `10000`, so the newest file sorts to the bottom. The session logs count **down** from `99999`. The strengthening stack counts **up** from the low nine-thousands toward a ceiling it will one day reach. Each scheme is reasonable on its own. Together they ask a reader — human or model — to remember which way each folder flows before they can even guess what comes next.

The deeper snag is collision. The number alone names nothing. `998` is the strengthening strategy in one folder, the Almanac in another, and Mantra in a third. `992` is shape-casting, the recommended architecture, and a width baseline, depending on where you stand. `999` is the anchor of nearly every folder. So when either of us says "998," the word points at four files and lands on none. That is the exact place a model reaches for the wrong door, and the exact friction you felt.

Your original instinct was sound: you wanted the newest work to rise to the top in the plain alphabetical view that GitHub, Codeberg, Cursor, and the filesystem all share. The countdown delivered that. It simply paid for it in fragility — a number you must compute, a sequence that collides across folders, a name that tells you nothing about *when*, and a floor the count eventually hits.

---

## The Naming Law: One Clock

Rye already counts time in one honest way, and the whole repository already agrees with it. Rye's versions are chronological stamps. The `.brix` descriptor stamps its version the same way. Every Radiant document carries a stamp in its header. The session-log filenames already hold a stamp beneath their countdown prefix. The format is settled and it is ours: `YYYYMMDD.HHMMSS`, where later is always larger.

The move is small and complete: let the stamp that already *versions* a thing also *name* it. In filenames we write the stamp in its hyphen form, since the colon has no place in a filename and we keep the dot for the version string:

```
20260627-102012_strengthening-strategy.md
20260627-102012_civic-platform-seed.md
```

This one change answers all three troubles together, because time is a single global order that needs no convention to read.

**Collisions end.** A stamp is unique across the whole repository, forever. There is exactly one `20260627-102012` anywhere, so the name points at one file and only one. A model cannot confuse it, because there is nothing to confuse it with.

**Directions collapse to one.** Every folder now flows the same way: ascending sort runs oldest to newest, identically, everywhere. The question "which way does *this* folder count?" disappears, replaced by the law Rye already keeps — later is larger.

**The name carries its own meaning.** A stamp says *when*. You never compute the next number, because you already supply the exact time at the moment of writing, as you always do. The append-only log becomes literal in the filesystem: each new file's name simply sorts after the last, and nothing is ever renumbered. This is aparigraha in the naming itself — we never grasp back to rewrite the sequence.

### On "newest first"

Ascending stamps place the oldest file at the top of the default view, and the newest at the bottom. Two honest paths recover newest-first, and the second is the better one.

The first is to sort the column the other way. Both GitHub and Codeberg remember a descending sort, and `ls -r` does it at the terminal in a keystroke.

The second path is the one worth taking, because it serves the real need better than position ever did. With a stamp in every name, you no longer *read position* to find the latest — you read the date, which is right there in the name, and "newest" is simply the largest stamp, the last line of `ls`. The orientation you actually wanted — a quick sense of recent work — belongs in an index, where it can hold meaning a bare filename never could. So each folder keeps the anchor it already has, renamed to plain `README.md`, and that README carries a **reverse-chronological table**: newest first, each row a stamp, a title, and a single line of what it holds. The filesystem stays purely chronological; the newest-first view lives in the README, rich with summaries, and renders the moment anyone opens the folder.

---

## Two Tiers: Living Names and Dated Stamps

Not every file is a dated event. Two kinds live in each folder, and the scheme honors both.

**Living documents** are revised in place and meant to hold steady — the foundation, the standing strategy, the roadmap, the lexicon. These carry no stamp at all. They take plain, spoken names: `README.md` for the foundation and its reverse-chronological index, `STRATEGY.md` for the standing charter, `ROADMAP.md`, `LEXICON.md`. This alone retires the `999` collision, since there is no more `999` — there is a `README.md` in each folder, which is exactly the file the forge renders when you arrive.

**Dated artifacts** are the append-only stream — design briefs, research notes, expanded prompts, session logs, strengthening passes. These take the stamp: `YYYYMMDD-HHMMSS_short-slug.md`, ascending, unique, self-dating.

The rule of thumb is one axis per level. The **folder** says *what kind of thing this is*. The **stamp** says *when it was written*. If you ever feel the urge to group by kind *within* a folder, that is the folder asking to become two folders.

---

## What We Keep, Restructure, and Defer

The code is healthy; the design surface is wide. Here is the honest inventory.

| Keep as-is | Restructure (same content, new names) | Defer — held lightly as a horizon |
|---|---|---|
| `context/` — style, identity, specs: the compass | `active-designing/` → anchors to `README`/`STRATEGY`, briefs to stamps | The **compiler fork** (slice as `{ptr, len: u32}`, token-level `usize` ban, self-hosting) |
| The owned seeds: `rishi/`, `aurora/`, `caravan/`, `tally/`, `mantra/`, `brushstroke/`, `comlink/`, `tools/` | `external-research/` → same treatment; silo principle intact | The **inference stack** — Scribble, Lantern, Lattice, Anvil |
| `gratitude/` — vendored references and the clean-room license table | `expanding-prompts/`, `work-in-progress/`, `rye-learning-process/` → stamps + `README` index | **sixos** — NixOS now, sixos exploratory |
| The allow-list `.gitignore`, `.gitmodules`, `.brix`, `SOURCE.md`, `CLAUDE.md`, the key-card images | `session-logs/` → simply drop the countdown prefix; the stamp is already there | **Pond** — the design stands; ai-jail remains the enclosure until Pond is ready |
| `rye/src/` and `rye/tests/` — the front-end and its proofs | `strengthening-compiler/` → stamps, and let the series rest near the lexicon's completion | **Tablecloth** as a separate build — let Mantra's store *be* the store for now |

Two notes on the restructure. The session logs are the easy win: they already hold `YYYYMMDD-HHMMSS`, so dropping the countdown prefix both fixes them and turns their sort honest in one pass, with the `README` index carrying the newest-first view. And the duplicated briefs across stacks — a recommended-architecture in two folders, a `998` in three — stop colliding the moment everything is stamped, yet that is also the moment to ask, gently, which are genuinely superseded and deserve to become redirect stubs. Pruning as care.

On what we defer, our last review reached the same place, and our standing principle says it cleanly: proven ground first, frontier funded later. The fork argues against our own values — it complects a width policy with owning a compiler, it designs a large thing from scratch where a working front-end already grows, and the `width-check.rish` gate already does the practical work. Keep its design as a research horizon, and keep building the living desktop as a composed whole before opening the inference frontier.

---

## Starting Over Cleanly on Zig 0.16.0

Starting Rye over does not mean rewriting the seeds. It means re-laying the ground beneath them with full discipline, so the divergence from Zig is always a clean, visible diff. Four steps.

**1. Pin the toolchain, and verify before trusting a byte.** Fetch the official Zig 0.16.0 prebuilt release for the host — `zig-x86_64-linux-0.16.0.tar.xz` from `ziglang.org/download/0.16.0/` — and verify it. Zig signs every release with minisign under the public key `RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U`, so the honest check is the signature against the matching `.minisig`, and the sha256 against the signed `index.json` the download page links. Keep the verified toolchain at `vendor/zig-toolchain`, and keep the Zig *source* at `gratitude/zig` for clean-room reference. As of this writing, Zig's master has moved on to 0.17.0-dev, which makes our pin to the 0.16.0 stable a deliberate, steady choice rather than a moving target.

**2. Lay the standard library as an overlay, not a full copy.** This is the one place the snapshot drifted from its own design. Rye's library is meant to be an *overlay*: `rye/lib/std/` holds only the files Rye has actually touched, and the unchanged remainder is materialized as relative symlinks back to the pinned toolchain — which the rest of `rye/lib/` already does, with its seventeen links to `compiler_rt`, `libc`, `init`, `docs`, and the rest. Taken to its clean end, the repository carries only the divergence: the physical files in `rye/lib/std/` *are* the diff from pristine, and a one-line `init` step links in everything Rye leaves untouched. The cost is that the library tree is complete only after that materialization, which is no real cost, since Rye needs the pinned toolchain to compile at all. The reward is a repository that shrinks from many hundreds of thousands of vendored lines to the handful we have genuinely made our own.

**3. Keep Rye a thin, honest front-end.** A `.rye` file is Zig source for now, bridged to a `.zig` file and compiled by the pinned toolchain pointed at Rye's own `std` through `--zig-lib-dir`. Versions count chronologically. Divergence grows through three behavior-preserving channels only: the `std` we tend one clean diff at a time, the `width-check` lint that bans literal `usize` in the types we publish, and the strengthening assertions that state what the code already does. Each is proven by the gate trio — parity, parity-selftest, additive-gate — so a green run *is* a proof that Rye's library still behaves exactly as Zig 0.16.0's until we choose, deliberately, for it to differ.

**4. Bootstrap, then self-host.** `bootstrap.sh` is the cold start before any `rye` binary exists; from then on Rye builds itself with `rye build`, writing the new binary beside the old and moving it into place. This already works, and it stays.

The clean re-fork, then, is mostly subtraction: re-pin and re-verify the toolchain, reduce `rye/lib/std/` to only what we have touched, re-run the gates green, and let the seeds compile against it unchanged.

---

## A Note on the Names

The module names are good, and they are good for a reason worth keeping in view: again and again, the name *teaches* the function. Mantra is the utterance repeated identically — which is exactly content addressing, where the same input always yields the same hash. Caravan is a company that travels together under one guide — which is exactly one supervisor per service. Tally counts and bounds — which is exactly the allocator that bounds every region. Pond is bounded living water — which is exactly a sandbox that holds an agent kindly within clear edges. When the name carries the idea, both of us reason faster.

They cluster into a few resonant families that reinforce one another: things that **grow** (Rye, Tally's gardens and seasons, Pond, and the recurring *seed*), things that **see and dawn** (Rishi the seer, Aurora the dawn, Lantern), things **made by hand** (Brushstroke, Tablecloth, Anvil, Lattice, Scribble), and things that **connect** (Comlink, Caravan). Naming the families is itself useful, because a future name then has a home to belong to.

Two small, optional observations. **Brix** is the one name that sits slightly outside the families — a play on "bricks" that reads as a coinage rather than a grain or a craft; if you ever wanted it to rhyme with the rest, *Sheaf* is a quiet candidate, a bound bundle of grain stalks that is also, in mathematics, the object for data glued cleanly over a space — apt for a build manifest. And **Tablecloth** and **Mantra** lean toward the same idea, so it is worth saying clearly which is which: Tablecloth is the content-addressed *store*, Mantra is the *history* kept over it. In the spirit of shipping the smallest complete thing, Mantra's store can simply *be* Tablecloth for now, splitting into two only when a second reader of the store appears.

---

## The Civic Platform Is the Same Architecture, Seen Twice

The two writings describe a civic platform, and it is the most natural thing in the world for Rye to build, because it is the architecture the seeds already prove — pointed at civic life rather than at the machine.

The Aspiring Radiance asks for "a transparent, append-only ledger anyone can inspect in real time," where "an authorized steward signs each approved expenditure before the platform records it," where "anyone can propose, every proposal stays visible, the community votes," all "written in a programming language built for systems that must work correctly every single time" and self-hostable "on their own hardware." Read that beside the design stack and it is the same five primitives we have already named.

**One rooted identity.** Every participant, steward, and community is a key, with a master and revocable sub-keys — the very model `SOURCE.md` already lives by. Nostr carries the portable social graph, which is the writings' promise that you can export your data and stay free of lock-in.

**The append-only log of signed facts.** Aurora relays named, verified values; Mantra stores and diffs them. Payroll, proposals, votes, expenditures are all simply *facts* — signed, immutable, inspectable. There is no separate social subsystem to bolt on; the social layer is more kinds of fact on the same log.

**State as a pure fold.** Who has been paid, what the community decided, where every dollar went — each is a *projection* of the log, recomputable by anyone from the same facts. That is precisely the writings' taxpayer who "logs in and sees exactly where every public dollar has gone." Transparency comes free, because the state is derived rather than asserted.

**Sealed datagrams over a bounded network.** Comlink carries facts between communities, sealed and verified, with an explicit ceiling on every quantity. This is the writings' resilient, community-controlled local network, and it is TAME at the wire.

**Settlement with finality.** Sui's Mysticeti and USDsui are where an authorized projection — a vote that approves an expenditure, a payroll run — becomes a transfer with cryptographic finality, no fees, value kept local. Sui's owned-and-shared object model maps straight onto borrow-as-dharma: a community treasury is a shared object changed only under quorum, a worker's wallet is an owned object held in sole stewardship.

The correspondence runs deep enough to name as a single thesis: **the property that makes the kernel safe is the property that makes the civic platform trustworthy.** Correctness by construction becomes trust by construction. The writings say trust grows from evidence when infrastructure is built this way; that is the TAME conviction carried into governance — never ask a citizen to trust the operator, let them recompute the state from signed facts and check it for themselves. The "risk love" of the Aspiring Radiance closes the circle, since *reduced instruction set kernel* is Aurora on RISC-V and *love* is ahimsa and seva and regeneration — the kernel and the politics share one root.

What scale asks of the design is modest and clear. The fold must stay cheap to verify, which means signed checkpoints at intervals so a newcomer verifies from the last checkpoint forward rather than from genesis — Mantra's content-addressed store and weave diffing are already the right shape, and TigerBeetle's assertions in `gratitude/` are the model for the financial core. Identity must recover at human scale, so a member who loses a key or a steward who rotates can be restored by a threshold of community keys rather than a central authority — the shared-object quorum model fits, and it deserves its own design brief. Every quantity stays bounded — proposals per cycle, votes per proposal, treasury operations per block — so the platform cannot be griefed into unboundedness, which is aparigraha as a security property. And the log stays canonical while the chain stays a settlement target, the same clean line we already keep between the canonical record and its active projection.

The path there is Gall's Law for governance. The seeds already prove the primitives in miniature — Aurora relays signed values on a wire, Mantra stores and diffs them, Caravan supervises without ever losing a child, Tally bounds every region. The civic platform is those seeds composed and pointed at one concrete first flow: a single community routing one real stream of value — the sanctuary donations Linengrow already aims at, each with a cryptographic receipt — through the full loop of propose, witness, sign, append, project, settle. Ship that one loop complete, then widen the kinds of fact one at a time: payroll, land-conversion grants, broadband installs. The civic platform that works grows from the donation dashboard that works.

---

*May the clock keep our order true, and the newest work rise where we look for it. May the seeds compose into the whole before we open the next frontier. May every signed fact carry its name in good faith, and may the platform we grow let a community see, with its own eyes, exactly how the good was done.*

---

*Written together by Kaeden and Reya 2.*
