# The Graph Is Not a Vane

**Language:** EN
**Stamp:** `20260726.044729`
**Voice:** Quin
**Status:** Counsel — propose-never-seat; Mixed — checkable where it cites the tree at nib `9ec80323c0`, the Ford Fusion essay read whole this sitting, and the searched state of the art · vision where it shapes the speed seasons
**Ground:** T3–T4 landed (382→135 · 29→10 · arithmetic published) · forge descriptions seated by hand and matched on both forges · monocypher gitlink restored · full parity F re-running on metal · the `042641` ask in hand
**Answers:** [`counsel/20260726-042641_parity-speed-safety-joy-ford-ask.md`](20260726-042641_parity-speed-safety-joy-ford-ask.md) · Keaton's Pear/Pool proposal · the world survey he asked for
**External study, read whole this sitting:** Ford Fusion (urbit.org/blog/ford-fusion, ~rovnys-ricfer, 2020)
**Files this create carries:** this memo
**Counsel model this sitting:** Claude Fable 5 1M Max

*Written together by Keaton and Quin.*

---

## What Ford Fusion Actually Teaches, Read to Its End

The essay's fame is the three properties — atomic, self-contained, ordered — and they are as good as remembered. Yet the ending is the part this decision needs, because the ending is a demotion story. Ford began as a vane. Its vane-hood forced Clay into an asynchronous dance with it — the essay names this *false modularity* — and every deferral multiplied the failure states. The fix that made everything else possible was moving Ford **into** Clay, where builds became synchronous function calls: six thousand lines became five hundred, kernelspace shrank twenty percent, and the caching collapsed to one honest rule — building a file is a pure function, memoize it, and on each commit throw away whatever the new revision did not use. The author's own closing question, *what is Ford in a hundred years,* is answered by the shape he landed on: smaller, purer, inside the filesystem organ, and no longer a peer of the kernel's modules.

So the strongest single sentence this essay offers Grain is an uncomfortable one for tonight's proposal: **the build system earned its excellence by ceasing to be a vane.**

## The World Survey You Asked For

I searched, and the modern systems agree with each other to a striking degree. The theory paper the field now stands on — *Build Systems à la Carte* — names the properties by which every system can be judged: **minimality** (never rebuild what did not change), **early cutoff** (if a rebuilt thing comes out byte-equal, its dependents do not rebuild), and **self-tracking** (the build description itself is an input, so editing the recipe invalidates the product). Meta's **Buck2** is that paper made industrial: one incremental dependency graph on an engine called DICE, every computation parallel with duplicates deduplicated, early cutoff applied by a plain equality check, plus two pragmatic gifts worth stealing — *dep files* (an action can declare after the fact which inputs it truly read) and *incremental actions* (an action may short-circuit part of its own work on a re-run). **Nix** contributes the hermetic key: a build addressed by the hash of everything it may see can be cached forever and shared safely. **Ninja** contributes the humility target: a no-op build should cost milliseconds, because the fastest build is the one you skip. And **Zig itself** — our own toolchain — carries two answers natively: a content-keyed cache at its core, and, mature in 2026 on exactly our x86_64-linux self-hosted backend, `zig build --watch -fincremental` with in-place binary patching for the inner loop, while the slow tail that remains is LLVM's emit step on release paths. On old Bun: its Zig-era lesson is real — one long-lived process, arenas, almost no spawning, because the process spawn is the tax — though I could not verify the Rust-rewrite claim from here and will not assert it either way.

Distilled to one line the whole field says: **a build is a pure function; key it by content; skip what the key proves unchanged; cut off early on equality; run the rest in parallel; and keep one cold path that trusts nothing.** Ford Fusion is the same sentence spoken in Hoon. Our parity suite currently does the opposite of most of it — hundreds of serial fresh processes, many cold compiles, no skip of the unchanged — which is exactly why it is honest and exactly why it is slow.

## The Pear Ruling — No to the Vane, Yes to Everything Underneath It

You offered your willingness to reorganize the whole tree for this, and that willingness is worth honoring with a straight answer and the blind-spot list you asked for.

**The ruling is no on the vane, and the reason is Ford Fusion itself.** Elevating the build system to vane status re-opens precisely the seam the essay spent years closing: a build vane must converse with the filesystem-and-versioning organ, and that conversation is where the asynchronicity leaks back in. Grain's Clay is **Mantra** — content-addressed versions over Weave — so the Ford-shape belongs where Ford ended up: **a pure core within Mantra**, called synchronously, memoized by content, with **Ojjo** consuming its timings as the yardstick vane it was already chartered to be. The essay's own future-work line even blesses the far horizon we want anyway: Ford moving *inside the desk*, which for us is builds becoming Glow-native when the desk season arrives. The instinct that the build system is kernel-grade is right; the lesson is that kernel-grade here means *pure, inside, and synchronous*, rather than *peer, outside, and named*.

**The blind spots, named as you asked.** First, **Maze is taken** — it is already seated as the nursery namespace, so Pool cannot become Maze without unseating a living name. Second, **Ojjo's charter collides**: a Pear-holds-parity vane and a benchmarking-and-parity vane are two owners of one duty, which is the Clay-and-Ford dance again with our own names on it. Third, **Pool is a proven seat** — TUBE admits, manifests, HAWM chain, witnesses green on a physical Pixel — and renaming a proven seat spends an enormous reference sweep to buy a letter, with zero minutes of wall-clock returned. Fourth, **the word parity already means three things here** — the suite, the variant twin-pairs, and now a proposed vane — and a vane name should never make a seated word more ambiguous. Fifth, one hazard I checked and can clear: the waymark corpus is a pinned fixture word-list (`tools/fixtures/flw-four-letter.txt`), not tree prose, so renames would not disturb its Tier-1 digest — though `pear` and `maze` being four-letter words means any future ladder could draw them as waymarks, and this tree has already buried Tusk and Toon for collisions of exactly that kind. If, with all of that in view, you still want a P-vane rebrand one day, it parks as a named naming round with these five checks as its entry gates — reported once, never urged.

## The Speed Plan — Four Rungs, Measured First

Under safety, performance, and joy, the blend you asked about is (a)+(c)+(d) in a strict order, with (b) gated behind the first number.

**S0 — Measure before touching anything.** The driver gains per-witness elapsed stamps and a closing cost table — the top twenty witnesses by wall time, written to a work-in-progress report. This is Ojjo's first real yardstick, it costs one evening, and no optimization below lands before its table prints. We once guessed thirty minutes and the metal said one hundred six; we do not guess again.

**S1 — The free wins.** Two, both suspected large. *The cache audit:* Zig's own content-keyed cache is designed to make repeat compiles nearly free, so the first question is whether the enclosure is letting it live — if `ZIG_LOCAL_CACHE_DIR`/`ZIG_GLOBAL_CACHE_DIR` land somewhere the jail resets, then the 116-file rye map and every `build-exe` after it are cold every single run, and *that* is the afternoon. Seat both at a persistent `tools/.cache/zig/` shelf, then time one rye-map before and after and pin what it prints. *The parallel lane:* Rishi already speaks `spawn`/`wait-for` in the wire labs, and the Framework has sixteen cores; independent witnesses run in bounded worker packs with duplicates deduplicated, while the QEMU and wire-lab families stay serial by law — they own ports and devices, and parallel witnesses must never share mutable state.

**S2 — Packs by intent.** Beside the Env-driven chapters, named packs a hand can run alone — `std` · `modules` · `glow` · `product` · `metal` — with full parity remaining the union. The lap that touched one module runs one pack; the joy target is a touched-pack loop under a minute or two, while the full oracle keeps its afternoon honesty.

**S3 — Witness receipts: the Ford-shape at the tools layer, no vane required.** Each witness gains a content key — SHA3 over the witness script's own bytes (self-tracking), the sorted content hashes of its declared inputs, the toolchain pins, and the ABSENT set — and a GREEN run writes a receipt `{key, stamp, nib}` to `tools/.cache/witness-receipts/`. A **FAST** run consults receipts and skips holders, printing a word that can never be mistaken for fresh metal: `GREEN (receipt 1a2b3c4d · 20260726.HHMMSS)`, counted separately in the summary. A **COLD** run ignores the shelf entirely, and **COLD remains the only word that unblocks H, precedes a release-shaped send, or claims the suite whole** — receipts serve the hand's loop and never the release truth. Input sets start coarse — the module directory, the script, the pins — and refine only on evidence, the dep-file way. Early cutoff arrives for free: an input that rebuilt byte-identical produces the same key. This is à la Carte's verifying trace, Nix's hermetic key, Buck2's equality cutoff, and Ford Fusion's memoized pure build, all wearing one small Rishi coat.

**Lane (b), archiving stale witnesses, waits for S0's table.** The criteria you named are right — replaced, retired surface, duplicate GREEN — and applying them before the cost table exists would be cutting in the dark. After S0, each candidate cut is its own small lap with its evidence in the commit body.

**What a fast suite may never do,** written once so speed cannot loosen it: never fabricate or receipt-launder a bare GREEN; never hide an ABSENT; never let a witness read another's mutable state in a parallel pack; never let FAST words satisfy a COLD gate; and never optimize a witness that S0 has not first weighed.

## Awaiting Keaton

The S-ladder word (this relay seats S0–S2 and the S3 *design*; S3 implementation waits for S0's numbers). The parked P-vane naming round, if ever, behind its five checks. Breach two, next season. The license badge, xykj61, Pond seven, the Acme line, the lap-kinds table, the Brix ladder name after H — H itself now waiting only on the in-flight COLD run coming home GREEN. Data dignity, succession, Mand ring-3.

---

## Gratitude close

With warmth and respect we thank **~rovnys-ricfer** and the **Urbit** community for Ford Fusion — the essay that taught us a build system becomes excellent by becoming smaller, purer, and synchronous inside the organ that owns the files; **Andrey Mokhov, Neil Mitchell, and Simon Peyton Jones** for *Build Systems à la Carte* and its vocabulary of minimality, early cutoff, and self-tracking; the **Buck2** team at Meta for DICE's parallel, deduplicated, equality-cut graph and the dep-file idea; the **Nix** lineage for the hermetic content key; the **Ninja** authors for the millisecond null build as a moral standard; the **Zig** team, whose content-keyed cache and 2026 incremental compiler are the engine under our every witness; and the **Bun** project's Zig era for the reminder that the process spawn is the tax. The mapping into Grain — receipts, packs, and the Mantra home — is ours to keep honest.

---

*May the cold run stay the only truth we release on. May every skipped witness say its receipt out loud. And may the build live where Ford finally lived — small, pure, and inside — so the kernel never learns to wait.*
