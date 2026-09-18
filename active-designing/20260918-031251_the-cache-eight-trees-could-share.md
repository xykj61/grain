# The Cache Eight Trees Could Share -- and the One Binary That Would Block It

**Language:** EN - **Style:** [Gauge](../.claude/rules/gauge-style.md) at Field - **Voice:** Kyri
**Stamp:** `20260918.031251` - **Status:** Landed measurement, proposal unbuilt
**Room:** mixed -- the sha256 readings below are checkable on metal; the store design is a proposal
**Lane:** incense -- law and design, on the overnight order's research item
**Answers:** [`recursion-prompts/incense-inner.md`](../recursion-prompts/incense-inner.md) *next* item 1
**Kin:** [`construction/archive/20260916-082153_itinerary-bakery-receipt-key-account.md`](../construction/archive/20260916-082153_itinerary-bakery-receipt-key-account.md) -
[`active-designing/date/20260917/20260917-054941_the-unit-that-survives-the-pier.md`](date/20260917/20260917-054941_the-unit-that-survives-the-pier.md) -
[`.claude/rules/read-scope.md`](../.claude/rules/read-scope.md)

---

## The question, plainly

`rye/src/main.rye` already caches a build inside one tree. A receipt keys itself on the compiler's
bytes, the standard library's bytes, the build flags, and the content of every source the build's
own closure touches, and it sits beside the emitted binary as `<path>.ryekey`. Eight ships share
one pier, each holding its own clone of the same repository, each compiling the same modules as
their own work touches them. When two trees would compute the same key for the same module, one
compile could serve both. This page measures how often that holds today and names the one thing
that stands in the way.

## What was measured, and how

All eight ships' trees sit as plain directories on this pier, one clone per name
(`/home/keeper/grain-<name>`). Reading a sibling tree costs nothing special here -- the same reach
the captain's view already grants for review (`tools/ag/agent-jail.sh`, *THE CAPTAIN'S VIEW*
section), taken directly rather than through a jail.

Every `.ryekey` sidecar was collected from all eight trees, 5,030 files, and grouped by the path
relative to each tree's own root:

```sh
find grain-<ship> -name '*.ryekey' | sed "s|^grain-<ship>/||" | sort
```

**1,374 of those relative paths exist in more than one ship's tree** -- the same module, built by
more than one ship, at least once. For each shared path, the receipt's own first line (the input
key, a SHA-256 hex digest) was compared across every ship holding that path.

## The finding

**All 1,374 shared paths disagree on their content key.** That reads at first like eight trees
sharing almost nothing. The deeper readings say the opposite about everything except one file.

**The vendored toolchain agrees, on every ship:**

```sh
sha256sum grain-<ship>/vendor/zig-toolchain/zig
```
reads `2317bbb9...724087c` on all eight. It is a pinned gitlink rather than something any ship
rebuilds, so this result was expected, and it confirms the one input the elder receipt-key account
already named as safe to share.

**The compiler's own source agrees, on every ship:**

```sh
sha256sum grain-<ship>/rye/src/main.rye
```
reads `41b573f1...6c1808a` on all eight -- the file that builds the `rye` binary whose own bytes
join every receipt key (the key's own header names the step: "then this binary's own bytes").
Eight independent clones agreeing on one tracked file is the ordinary case; it earns a line here
because of what it rules out next.

**The compiled `rye` binary parts ways, on every ship:**

```sh
sha256sum grain-<ship>/rye/bin/rye
```
reads eight distinct digests, one per ship, each answering for itself alone.

**One shared source builds eight different binaries, and that alone empties the shared cache
before a single project file is even read.** The toolchain agrees and the compiler's own source
agrees, so the receipt key's remaining difference traces to one input: the self-digest each ship
folds in from its own locally-built `rye`. Whatever module a lap compiles, that one digest already
guarantees a miss against any other ship's receipt.

## The mechanism, already measured by a peer lap

This finding rests on non-determinism a peer lap already measured while closing a different
question.
[`construction/archive/20260916-082153_itinerary-bakery-receipt-key-account.md`](../construction/archive/20260916-082153_itinerary-bakery-receipt-key-account.md)
records: *"at `-ODebug` this toolchain is not reproducible at all, two builds of one source parting
in 45,027 of 10,239,778 bytes... At `-OReleaseSmall` both spellings emit byte-identical binaries."*

`rye/bootstrap.sh` builds the `rye` binary at Zig's Debug default -- one line reading
`"$zig" build-exe "$bridge" -femit-bin=bin/rye --zig-lib-dir lib -lc`, carrying no `-O` flag at all.
Eight ships each ran their own bootstrap from identical source, through the identical pinned
toolchain, and Debug's own randomness -- unnamed serial numbers stamped on anonymous structs, per
the elder account -- sent each one to its own distinct bytes. The compiler asked for speed of
build rather than reproducibility here, a fair trade until this page's question arrived.

## What a shared store would need

**One reproducibly-built `rye` binary, distributed rather than eight bootstrapped.** The elder
account already proved `-OReleaseSmall` byte-identical across two spellings of one build. The same
flag, added to `rye/bootstrap.sh`, would let eight independent bootstraps of identical source
converge on one binary. The self-digest each ship folds into its receipt key would then become a
shared constant, and the 1,374 shared-path receipts would finally stand comparable. This is one
line in one script, and it closes the whole gate this page measures.

**A content-addressed store, keyed by the receipt's own input hash.** The receipt mechanism
already computes the right key; a shared store is a directory the key names, holding the emitted
bytes rather than a per-tree sidecar:

```
<store>/<key-hex>/binary
<store>/<key-hex>/ryekey     # the two-line stamp rye/src/main.rye already writes
```

A hit reads the directory the locally-computed key names; a miss builds locally and writes that
directory afterward. **Concurrent ships write safely by construction, rather than by a lock.** Two
ships computing the same key from the same inputs produce the same bytes, so writing to a temp
name and renaming atomically lands one complete directory however many ships race to write it --
a reader always finds the whole thing or finds it absent, and either answer stays honest. This
promise is lighter than `rye_build.sh`'s per-module lock, which exists because two *different*
builds can shadow one module's namespace; two identical builds racing toward one already-computed
key share the same answer and have nothing to contend over.

## Where this meets the jail law

**Every enclosure binds exactly one tree, by design** (`tools/ag/agent-jail.sh`, citing REDS `%291`:
*a shared checkout bit four times in a day*). A store eight jailed ships could reach looks, on its
face, exactly like the shape that law refuses.

**The captain's view already crossed this line, read-only, on Keaton's word, and its shape answers
half of this design already.** `FLEET_CAPTAIN_VIEW` mounts every peer tree into the captain's own
jail with `--map` (read-only) and denies the three credential paths inside each by name
(`.gnupg-rye`, `.ssh`, `loops/`). A shared cache directory, mounted `--map` into all eight jails the
same way, lets every ship read an entry a peer wrote. The one-writer-per-checkout law stays scoped
to checkouts -- a cache directory outside all eight trees belongs to none of their checkouts, so
reading it crosses no wall that law drew.

**The write side is the part the captain's view never needed, and content-addressing is what makes
it safe.** A cache a jail can only read stays forever empty, since nothing ever fills it. The
argument above carries the weight here: two ships writing the same key write the same bytes, so a
`--rw-map` of one shared, external directory stays safe for every jail to hold at once. A git
checkout can hold two writers who honestly disagree about what comes next; a content-addressed
entry has exactly one honest value for a given key, so a second writer can only ever confirm the
first, never contest it. The wall REDS `%427` raised, *a tree carries its own keys*, governs
signing and transport identity -- a compiled binary and a hash carry neither, so this store leaves
that wall standing exactly as it stands today.

**What stays outside the design.** The store's home sits beside the eight trees rather than inside
any one of them. Housing it inside a single ship's tree would make that ship's jail the accidental
keeper of a resource seven others lean on, precisely the shape `%291` stands against. A ninth
directory, owned by this pier's host, maps `--rw-map` into all eight jails at one fixed path
(`RYE_KEY_STORE`), read by `rye/src/main.rye` beside its own per-tree receipts rather than instead
of them -- a tree with the variable unset keeps exactly today's behavior, unchanged.

## What this page leaves open

**How many of the 1,374 shared paths would actually hit, once the self-digest gate falls.** This
page prices the gate (one bootstrap flag) and sketches the mechanism (a content-addressed
directory, atomic writes, a `--rw-map`). It stops short of measuring how often eight ships' project
sources -- apart from their compiler -- agree on a given module at a given moment, since that
reading wants the gate closed first.

**Whether `-OReleaseSmall` costs the bootstrap anything Debug spares it.** The bootstrap builds a
small, one-time bridge program; trading a slower one-time build for a fleet-wide sharing benefit
reads like a fair trade, and the one-time side still wants its own timing before anyone commits to
it.

## The falsifier, named before anyone builds this

**Claim.** Once every ship's `rye/bin/rye` comes from `-OReleaseSmall` built on identical source,
the same 1,374 shared module paths will show real agreement on their receipt keys, because the one
input that varied across all eight then holds constant.

**Horizon:** the lap that changes `rye/bootstrap.sh`'s build flag and re-bootstraps all eight
ships. **Assumptions:** `-OReleaseSmall` stays reproducible for this bridge program on this
toolchain, matching what the elder account already proved for a different binary; each ship's
project source agrees closely enough at that moment for the remaining match to show through.
**Falsifier:** the same eight-tree comparison, re-run after the flag change, still reading zero
agreement -- which would name a second, unmeasured input still varying per ship. **Confidence:**
high that the flag change closes the self-digest gap, since it rests on the same mechanism the
elder account already proved on metal; medium on how large the resulting hit rate runs, since that
half awaits its own reading.

Custody gate `%1` and every other named gate stand exactly where they stood. This page builds no
store, changes no bootstrap script, and touches no jail -- it measures, and it proposes.
