# The compiler that could not find its own toolchain

**Stamp:** `20260911.110257`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Status:** Landed -- **checkable room**: every behavior below is proven by
[`../tools/fixtures/r/rye_toolchain_resolve_control.sh`](../tools/fixtures/r/rye_toolchain_resolve_control.sh)
and gated by [`../tools/r/rye_toolchain_resolve_witness.rish`](../tools/r/rye_toolchain_resolve_witness.rish)
**Voice:** Kyri
**Kin:** [`../foundations/20260826-021732_air-the-row-that-feels.md`](../foundations/20260826-021732_air-the-row-that-feels.md) -- [`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md) -- [`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md)

The second command a newcomer runs in this tree is `sh tools/f/fetch-toolchain.sh`. It downloads
Zig 0.16.0, checks the bytes against a checksum this repository holds, and extracts the toolchain
to `vendor/zig-toolchain/zig`. The third thing they do is build something, and until this lap the
compiler answered:

```
rye build: could not start toolchain 'zig' (FileNotFound). Set RYE_ZIG to the zig binary, or put zig on your PATH.
```

Two doors, both of them other than the one the tree had just walked them through.

## What the mechanism was

`rye/src/main.rye:289` read the toolchain in one line: `init.environ_map.get("RYE_ZIG") orelse
"zig"`. An explicit setting, else a bare command name for the host's PATH to resolve. On a host
carrying `zig` on PATH that works, and on a host without one -- this pier, and any NixOS host that
has not installed Zig globally -- the tree's own compiler refuses to build the tree.

`resolve_zig` now takes three readings. An explicit `RYE_ZIG` wins, unchanged. Failing that, the
pinned toolchain, found beside the binary at `<exe_dir>/../../vendor/zig-toolchain/zig` through
`resolve_self_exe` -- the same function `resolve_rye_lib` already uses to find Rye's own standard
library, ten lines further down the same file. Last, a bare `zig` for PATH.

The candidate is asked `access(.{ .execute = true })` before it is taken, because the only question
a toolchain path answers is whether it can be run. Every refusal inside the reading falls through
to the next one rather than stopping, since each means only that *this* reading cannot answer.

## The disagreement stood inside one directory

`rye/bootstrap.sh:15` has read `zig="${RYE_ZIG:-../vendor/zig-toolchain/zig}"` since it was
written. The cold start that builds the first `rye` binary knew exactly where the toolchain lived;
the compiler it bootstrapped did not, and consulted a PATH the cold start never looks at.

That is the **air** reading in the row's own terms: close a hand on a boundary and pull. One
question -- *which toolchain compiles this tree?* -- was answered in two places, and the hand went
straight through. The control reads both files and holds them to one destination, so the next hand
to move either one hears about it.

The third answer is the tree's habit. **2,387 living tracked files spell
`vendor/zig-toolchain/zig`, and 2,396 spell `RYE_ZIG`, 1,575 of them under `tools/`** -- almost
every witness in the tree opens by binding the path by hand and passing it through `env`. These
figures are **free** -- a guard holds them still nowhere in the tree, and they grow with every
witness written. Run them
rather than reading them here:

```
git grep -l 'vendor/zig-toolchain/zig' -- ':!session-logs' ':!*/date/*' ':!*/archive/*' ':!counsel' ':!vendor' | wc -l
```

A workaround written two thousand times reads as a convention. What it actually was is a rule the
tool declined to hold, paid for once per file, forever.

## The second finding, which nobody was looking for

A build receipt keys a `.ryekey` beside the output so a byte-identical rebuild skips the toolchain
entirely. `rye/src/main.rye` hashes the toolchain's path and size into that key, and turns receipts
off whenever the size cannot be read: `zig_stat != null` is one of the five conditions of
`wants_receipt`.

A bare `zig` is a command name rather than a path, so `statFile` on it refuses, so **every build
through a PATH-resolved toolchain wrote no receipt at all.** Measured in the pen, both ways: the
elder binary with `zig` on PATH builds a 10,447,522-byte output and leaves no `.ryekey`; the same
source through the vendored reading leaves a 129-byte one. Build caching stood off for exactly the
hosts least likely to suspect it, and the resolution that fixes the build turns it back on.

## Why the pin comes before PATH

The order is the one the tree already keeps. `bootstrap.sh` prefers the pin and reads no PATH at
all; the witnesses pin it by hand at the count above; `fetch-toolchain.sh` pins the version against
a checksum. A host `zig` of another version compiles this tree differently, and the reading that
reaches it is now the last rather than the second.

**This changes nothing that works today on this pier**, which is worth saying plainly rather than
assuming: no `zig` stands on PATH here, so the whole change is a refusal becoming a build. On a
host that does carry one, a bare `rye build` now takes the pinned toolchain instead. The falsifier
is cheap and the escape is one word: `RYE_ZIG` still wins over everything.

## What is proven, and what is not

Twelve legs on real builds in a throwaway pen, each reading shown from both sides -- the reading
answers where it owns the question, and the next one answers everywhere else. Three mutations of the resolver are
rebuilt through the pinned toolchain and shown to bite: the vendored reading removed drops leg 1,
`RYE_ZIG` moved out of first place drops leg 3, the executable check dropped drops leg 6.

A binary older than its source is named as a **machine fact** and skipped at exit 0, the way
`ryekey_control.sh` names the same thing: `rye/bin/rye` is gitignored, so a fresh clone holds none
and a working pier holds whichever one it last built.

What this does not settle is which toolchain a given host *should* use. It settles that the tree's
own answer is the one the compiler takes by default.

## What it leaves for a later lap

The 2,396 files binding `RYE_ZIG` by hand still work and still bind it. Binding it is optional from
here,
which makes a sweep possible and leaves it a choice -- and an optional sweep of two thousand files
belongs to a lap that wants it rather than to this one. The first-hour tutorial's warning about
`$PWD`-relative paths is now advice about a variable a reader can skip setting.
