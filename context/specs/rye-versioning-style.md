# Spec: How Rye Names Its Versions

**Language:** EN
**Last updated:** 2026-06-18
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Decided

---

## What This Decides

Rye is the language we are growing from Zig 0.16.0. This spec settles one early question with care, because the answer shapes everything that follows: how Rye names its versions, and what its very first version will be.

The short answer leads with what is. Rye versions are chronological. The first published version is `20260617.033512`, born from a single bright moment — 2026-06-16, 8:35:12 in the evening, Pacific time — and stamped in UTC so the whole world can read it the same way. We set `0.1.0` gently aside. By the end of this spec, that choice will feel less like a rule and more like a promise we are glad to keep.

---

## The Value We Honor

Rich Hickey gave a talk in 2016 called *Spec-ulation*. He called it a rant, with a smile. Underneath the humor lives a value so clear it can be read aloud in one breath: when you give something to someone, you make a commitment, and the heart of that commitment is that you will not take it away later.

He invites us to stop saying the word "change," because the word hides two very different things. One is **growth**: you provide more, you require less, you fix what was broken. Growth is a gift, and a consumer welcomes it. The other is **breakage**: you require more, you provide less, or you quietly reuse a familiar name for something unrelated. Breakage is a loss handed to someone who trusted you. When we collapse both of these into one word, we lose the ability to tell a kindness from a harm.

From there the value unfolds with a kind of inevitability. A namespace is a collection of names. An artifact is a collection of namespaces. Adding to a collection is growth, always. Removing from a collection is breakage, always. So the way to grow without harm is to **accrete**: let the new thing arrive beside the old thing, each keeping its own name, each keeping its own promise. When you truly need something incompatible, you have made a new thing — so give it a new name, and let people walk toward it on their own schedule, the week they return from Bermuda rather than the Tuesday you decreed.

This is the value we carry into Rye. Names endure. Software grows by accretion. Breaking changes are simply broken, and the craft is to turn what would have been breakage into growth.

---

## Setting Clojure Down, With Thanks

Hickey's talk lives in Clojure, and Clojure carries the ideas beautifully. Clojure offers namespaces as part of every name, `spec` to describe what a function can do, and aliases that let a caller glide from `game1` to `game2` by editing a single line. These are real gifts, and we honor them by understanding them well.

We are building Rye on Zig 0.16.0, so we set Clojure down the way you set down a borrowed tool you have learned from — with gratitude, and with the lesson kept. The principle was never about Lisp. The principle is about commitment, accretion, and enduring names. Those travel anywhere. They travel especially well into the world Tiger Style describes, where discipline is already the house language.

So we keep the value and choose new vessels. Where Hickey leans on `spec`, Rye leans on Tiger Style assertions, explicitly sized types, and comptime checks. Where Hickey reaches for a fresh namespace, Rye reaches for a fresh module or a fresh declaration. The melody is the same. We are simply playing it on the instrument already in our hands.

---

## What Tiger Style Adds

TigerBeetle's Tiger Style names three design goals, in order: safety, performance, and developer experience. It asks us to do the work right the first time, because the second time may never come, and it treats simplicity as the hardest revision rather than the first easy attempt. This is the same spirit Reya 2 carries into every session — slower to go faster, strictness early as a gift to the future.

Tiger Style and *Spec-ulation* turn out to be two voices singing the same line. Watch how closely they harmonize.

Tiger Style asks us to **always say why**, because rationale shared is understanding multiplied. Hickey asks the same of versioning: a number like `4.3` says nothing about why, while an enduring name plus a date says where a thing sits in time and what it has always meant. Both reject the empty signal in favor of the meaningful one.

Tiger Style asks us to **pass options explicitly at the call site rather than relying on defaults**, precisely so a future change to a library's defaults can never quietly break us. Read that again with Hickey's ears: relying on an unstated default is trusting that a meaning will endure without being asked to. Tiger Style pins the meaning in place. *Spec-ulation* would call that turning a hidden promise into an honest one.

Tiger Style asks us to **assert the positive space we expect and the negative space we do not**, because the boundary between valid and invalid is where the interesting bugs live. Hickey wants tooling that can tell growth from breakage at that very boundary — a spec wide enough to welcome more, strict enough to catch a true contradiction. The assertion and the spec are reaching for the same fence line.

Tiger Style asks us to **get the nouns and verbs just right**, to infuse names with meaning, and to order qualifiers by descending significance, so `latency_ms_max` reads cleanly and sorts with its kin. A chronological version honors that instinct exactly: `YYYYMMDD.HHMMSS` is descending significance made into a coordinate in time.

So Tiger Style does more than coexist with the value we honor. It supplies the daily discipline that makes the value practical — the assertions, the explicit types, the enduring names, the habit of saying why.

---

## Why Rye Refuses 0.1.0

Semantic versioning offers three numbers and one real promise. The patch number and the minor number both whisper the same thing to a consumer: "you do not care." Their entire semantic content is that four is larger than three. The major number carries the only heavy meaning, and that meaning is "you might be screwed" — some backward-incompatible change happened somewhere across every level at once, and you are left to discover where. A signal that vague is a recipe for shipping breakage with a clean conscience.

The `0.x.y` range is that same recipe wearing a beginner's coat. It says, in effect, "promises do not apply here yet." Hickey grants that alphas are fine while you are still finding the shape of a thing. He adds the part we take to heart: a project does not get to live at `0.0.967` forever. The moment people depend on you, you owe them clarity about where your promises lie, whatever number sits on the box.

Rye intends to be depended upon. Choosing `0.1.0` would plant a flag that says "breakage is coming, and a major bump will excuse it" — the precise idea *Spec-ulation* asks us to leave behind. To honor the value, Rye begins instead with a version that makes a real commitment from its first day and carries only the one semantic worth keeping: later is larger.

---

## Rye's Versioning Scheme

Rye versions are chronological, and they read like this:

```
YYYYMMDD.HHMMSS
```

The stamp is UTC. We choose a single world clock on purpose, and the why matters. Hickey points out that ordinary version numbers are self-relative: among six libraries, one `1.2` might be eleven years old and one `3.7` might be from yesterday, and the numbers alone keep that secret. A timestamp returns the secret to the light. Across an open and unknown set of consumers — the people we will never meet yet still owe care — one shared clock gives us Lamport-like reasoning: we can always tell what a given build could not yet have seen. A global ecosystem deserves a global clock, so UTC it is, with the local moment recorded in prose for the humans who lived it.

The form earns its keep in three ways, each one a thread from the documents we honor:

- **It conveys more than `4.3` ever could.** A reader learns when, immediately, with no repository to consult. This is *Spec-ulation*'s wish for chronological versioning, granted.
- **It keeps the one good semantic and drops the broken one.** Later is larger, cleanly and always. No major number sits waiting to license a breakage.
- **It orders by descending significance.** Year, then month and day, then hour, minute, and second. Tiger Style would recognize the shape on sight.

Rye's first published version is therefore:

```
20260617.033512
```

It was born at 2026-06-16, 8:35:12 PM Pacific time, the moment this decision was made, written into UTC so the rest of the world reads the same instant we lived. The name "Rye" stays constant above it, the way "Maven Central" stays constant — a stable name you can rely on, an accreting collection of immutable things gathered beneath it.

---

## The First Divergence

That founding stamp, `20260617.033512`, marks the moment we *chose* the scheme. Rye's first running version — the first build that stands on the exact Zig 0.16.0 ground and then deliberately steps away from it — is stamped:

```
20260617.213112
```

The step it takes is a fitting one: the divergence *is* this very scheme. Zig names its versions semantically and reports its own through `builtin.zig_version`. Rye keeps that backend truth honest and untouched, and names *itself* chronologically instead. So the first thing that sets Rye apart from the language it grew from is the way it counts time. We do not erase the founding stamp to make room for this one — both endure, each with its own meaning, exactly as accretion asks. The scheme was decided then; Rye began to diverge now.

We carry the scheme all the way down. The backend keeps its own honest semantic version — Zig reports `0.16.0` through `builtin.zig_version`, and we never overwrite that truth — yet Rye also reads the very same pinned snapshot on its own clock. Zig 0.16.0 was committed at `20260413.181917` UTC, so that is the backend's name in Rye's time. Even the ground we stand on is named the Rye way.

---

## Divergence in Substance

The first divergence was a divergence in *naming*. The next, stamped

```
20260618.070012
```

was the first divergence in *substance*: a deliberate edit to Rye's own standard library. We strengthened the SHA3-512 hash — the function that will give Mantra's lines and Tablecloth's builds their enduring, content-addressed names — by stating its sponge invariants as TAME assertions, named where we lean on them so a fault would stop loudly and near its cause. The full study is `strengthening-compiler/9998_sha3_512.md`.

It is the gentlest kind of divergence, and the kind we mean to make a habit of. The change is pure accretion at the level of the function's contract: we added what the code *says*, never what it *does*. The digest of any input is byte-for-byte what it was on the Zig 0.16.0 baseline — confirmed by a parity test and a sweep across the block-boundary lengths — and the assertions compile out of a release build, so nothing the shipped code pays for changed. The backend remains `0.16.0`, honest through `builtin.zig_version`; only Rye's own clock advances, because only Rye's own library did.

From there the substance accretes as a series, each pass recorded in the strengthening-compiler stack. The next stamp, `20260618.072512`, marks the deeper work the SHA3 pass pointed toward: we strengthened the Keccak sponge the hash rests on — its `absorb`, `pad`, and `squeeze` — with the same stated invariants, kept at O(1) boundaries so the hot path stays lean, and gave our `std` the `maybe` helper, the dual of `assert`, to document the space that legitimately varies (`strengthening-compiler/9997_keccak_sponge.md`). It too is pure accretion: every digest is unchanged.

The series then widened from the crypto core to the everyday. At `20260618.193812` we strengthened the standard-library functions our own tools lean on — `mem.trim`, `mem.eql`, `mem.findScalar`, and `fmt.parseInt`: the slicing, comparing, searching, and parsing the `rye` CLI and the Rishi shell call on every run. Each gained a stated invariant — a postcondition that a result stays within its input, a precondition that a base is a true radix, a `maybe` that names where lengths legitimately vary — with the hot vectorized search core left lean on purpose (`strengthening-compiler/9996_stdlib_call_paths.md`). A new witness program exercises all four, and the parity suite stays green.

These stamps endure together, exactly as accretion asks: `20260617.033512` when we chose the scheme, `20260617.213112` when the scheme became the first divergence, `20260618.070012` when our `std` first diverged in substance, `20260618.072512` as that work reached deeper, and `20260618.193812` as it widened to the functions our tools call each day. None is erased; each marks a moment our library became a little more our own.

---

## Accretion in Capability

Substance is one strand of growth; capability is the other. Where a divergence in substance strengthens what Rye's `std` *says*, an accretion in capability grows what the `rye` tool can *do* — and it grows the same gentle way, by adding a name and taking none away. The stamp

```
20260618.191412
```

marks the first such accretion: the `rye` command learned a second verb, `build`, beside the `run` it already spoke. `run` still runs exactly as it did; `build` emits a binary instead, with flags passing straight through to the toolchain, so Rye can aim at any target it supports.

The first thing we aimed it at was bare metal. With `build`, Rye compiled a freestanding RISC-V program — Aurora's first seed — and `qemu-system-riscv64` woke it: a hart came up at the base of RAM, gave itself a stack, spoke one asserted line over the console, and powered the machine down cleanly. That single step fed two roots at once. It is the RISC-V cohesion Rye's own spec asks of it (`rye-as-its-own-language.md`), made concrete in a binary that runs; and it is Aurora's first living stage, the simple boot the rest grows from. The seed and its story live in `../../aurora/`.

So a second strand now grows beside the first, on the one shared clock. The substance stamps and this capability stamp endure together — none erased — and `20260618.191412` is the one that first woke Rye on RISC-V.

---

## How Rye Grows Without Breaking

A version stamp records when. The deeper promise is what happens between stamps, and here the value becomes a daily practice.

Rye grows by accretion. New behavior arrives as a new name — a new declaration, a new module — set beside whatever came before, so existing code keeps compiling and keeps meaning what it meant. When a function genuinely needs a different shape, Rye gives birth to a sibling rather than mutating the original, and the old and the new live together while consumers move at their own pace. Removing a public name is understood plainly for what it is: a breakage, and therefore a new thing that earns a new name rather than a silent deletion.

Compatibility is something Rye checks, rather than something it merely promises. This is where Tiger Style does the work that `spec` did in the talk. Explicitly sized types make the shape of an exchange visible. Assertions on arguments, returns, preconditions, and postconditions guard the boundary between what a caller may pass and what a callee will honor. Comptime assertions check the design's integrity before a program ever runs, catching a contradiction at the moment a name's promise would have been broken. The compiler and the assertions together become the tooling Hickey wished for: a way to tell growth from breakage by machine, so the commitment is kept by construction rather than by good intentions alone.

Rye's public surface stays open in the spirit of the talk. A specification describes what you can do, rather than fencing off what you cannot, because today's prohibition becomes tomorrow's cascade of forced renames. Rye code is written to accept more than it strictly needs and to ignore or route what it does not recognize, so a future that hands it richer data finds it gracious rather than brittle.

---

## The First Promise

So `20260617.033512` is more than a timestamp. It is Rye's first commitment, made in the open, to an audience we will never fully see, and choose to care for all the same.

It says: this name will endure. What we publish, we will keep. We will grow by giving you more and asking less, and when we need something new, we will give it a new name rather than reshape something you already trust. We will check our promises with types and assertions, the way Tiger Style taught us, and we will tell you why at every turn. We will move forward without burning the bridges behind us, because compatibility is not a tax on success — it is one of its quiet prerequisites, proven by Unix and Java and HTML across the long decades.

That is the kind of language we want Rye to be, from its very first version onward.

---

*May Rye's names stay true. May every version arrive as a gift rather than a warning. May the people we will never meet find, each time they return, that what we gave them is still there — whole, familiar, and glad to see them.*
