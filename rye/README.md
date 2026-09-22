# Rye

**Language:** EN
**Version:** `20260620.033912` (Rye chronological stamp)
**Last updated:** 2026-09-22 (Radiant-Gauge pass -- the language door and its return paths)
**Style:** Radiant + Gauge (warmth carried by [`Radiant Style`](../context/RADIANT_STYLE.md), claims held by [`Gauge Style`](../context/GAUGE_STYLE.md))
**Status:** Checkable -- living language module
**Where this sits:** home is [`../README.md`](../README.md) - a first hour with Rye in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md) - the sibling shell
this language builds is [`../rishi/README.md`](../rishi/README.md)

## The fascia: a handrail through Grain

The visible edge of Rye reaches in two directions. Upward, it returns to the [`Grain root`](../README.md),
where the project names its larger promise. Downward, it leads into the files and commands that let
the language take a first breath on your machine. Across the room, it introduces the family that grows
from the same soil.

| Reach | Door | What it carries |
|---|---|---|
| Home | [`Grain README`](../README.md) | the whole tree, its invitation, and its present shape |
| Begin | [`The first hour`](../docs-geode/tutorials/the-first-hour.md) | a guided arrival from a fresh checkout to a green result |
| Build | [`SOURCE.md`](../SOURCE.md) | the signed, sandboxed route through the system |
| Learn | [`Rye learning process`](../rye-learning-process/README.md) | the record of how the language became itself |
| Sibling | [`Rishi`](../rishi/README.md) | the shell and witness language that grows beside Rye |
| Higher voice | [`Glow`](../glow/README.md) | the language people write before Rye carries it to metal |
| Bare metal | [`Aurora`](../aurora/README.md) | the first RISC-V seed that wakes below the application layer |
| Craft | [`TAME Guidance`](../context/TAME_GUIDANCE.md) · [`Kyri`](../context/KYRI.md) | the discipline and voice that keep the work clear |

The path has a gentle return: after a build, follow the command's receipt back through this page,
step up to [`Grain home`](../README.md), or continue outward through [`the docs geode`](../docs-geode/README.md).
Every door leaves a reader with a next door.

---

## What Rye is

Rye is Grain's systems language: a careful front-end grown from Zig 0.16.0, with a standard library
held under Rye's care and a chronological clock of its own. A `.rye` file currently travels through
the Zig toolchain, so every capability the toolchain carries, including SHA3-512, arrives by
construction. Rye adds its own library path, its own receipts, its own tests, and its own way of
counting time. Each piece brings the language closer to its own shape.

The [`rye` command](src/main.rye) speaks four verbs:

- `rye version` -- print Rye's chronological version and the backend it stands upon.
- `rye run <file.rye>` -- compile and run a single `.rye` source file, against Rye's own standard library.
- `rye build <file.rye>` -- compile a `.rye` source file to a binary. Flags after the file pass straight through to the toolchain, so Rye can aim at any target it supports.
- `rye build-lib <file.rye>` -- compile a `.rye` source file to a library (static archive or shared object). Same flag pass-through as `build`. First consumer: Glow's Android `libglowapp.so` path under TUBE0.5 (`rye build-lib -fsingle-threaded` -> NDK link).

Because the toolchain's front-end reads only the `.zig` extension, `run`, `build`, and `build-lib` bridge: they copy the `.rye` source to an adjacent `.zig` file, hand that to the compiler -- pointed at Rye's standard library -- and clear the bridge away so the tree stays tidy.

A build with a named output also writes a content receipt beside it. Rye reuses the output only
when the full local source closure still agrees: path, bytes, executable bit, flags, library
overlay, toolchain path and bytes, Rye binary, and embedded files all join the key. Every build still
reads that closure, and any input it cannot account for takes the safe path and compiles fresh.

The first place we aimed `rye build` was bare metal. It compiled a freestanding RISC-V program that wakes on an emulator -- at once Rye's RISC-V cohesion made concrete and Aurora's first living seed, a hart that comes up, speaks one asserted line, and rests. That seed and its story live in `../aurora/`.

---

## The Shape of the Folder

```
rye/
  README.md                 <- this introduction
  bootstrap.sh              <- cold-start build, before a `rye` binary exists
  lib/                      <- Rye's library directory (passed via --zig-lib-dir)
    std/                    <- our std: a copy of Zig 0.16.0's, under our care
    (others)                <- relative symlinks back to the pinned toolchain
  src/
    main.rye                <- the `rye` command, itself a Rye program (TAME Guidance)
  tests/
    sha3_512_test.rye       <- proves SHA3-512 parity with Zig 0.16.0
    version_test.rye        <- shows the backend version via builtin.zig_version
  bin/
    rye                     <- the built command (after building)
```

The lessons learned while building Rye live in the [`Rye learning process`](../rye-learning-process/),
with the elder reference at [`ALMANAC.md`](../rye-learning-process/archive/ALMANAC.md) -- gate trio,
Caravan seeds, Brushstroke, strengthening, and Zig 0.16.0 I/O.

Sibling modules built with `rye build` include [`Rishi`](../rishi/), [`Caravan`](../caravan/),
[`Tally`](../tally/), [`Brushstroke`](../brushstroke/), [`Mantra`](../mantra/), and
[`Aurora`](../aurora/). What *seed* means in this family is defined in
[`the seed note`](../active-designing/yonder/date/20260622/20260622-235012_what-we-mean-by-seed.md).

---

## Owning the Standard Library

A language becomes wholly its own when it owns its standard library. Rye does. The folder `lib/` is Rye's library directory. Its `std/` began as a **bit-for-bit copy of Zig 0.16.0's** standard library, now under our care to tend and grow. The rest of the directory links back to the pinned toolchain, unchanged. The `rye` command points the compiler at this library with `--zig-lib-dir`, so `@import("std")` in a `.rye` program means *Rye's* std.

The command **insists** on it. Before compiling, it confirms our library sits at the expected path and refuses to run against anything else. A successful `rye run` is therefore, by construction, a run against Rye's own standard library. The assurance lives in the path rather than in any marker written into the code. That choice lets `std` stay a faithful copy we diverge from deliberately, a clean diff at a time.

A note on names, while we are here. The programs we author carry the `.rye` extension -- `src/main.rye`, the tests, Aurora's seed. The standard library under `lib/std` keeps the `.zig` extension, because that is the name the compiler looks for when we point it at the library. The layout there belongs to the toolchain. So the line stays clean: `.rye` is what we write, and `.zig` is the library the toolchain reads.

---

## How Rye Counts Time

Rye's first deliberate divergence from Zig is the way it names its versions. Where Zig counts semantically (`0.16.0`), Rye counts **chronologically** -- `YYYYMMDD.HHMMSS`, where later is always larger -- so a version says *when*, and carries only the one semantic worth keeping. The first running, divergent version is `20260617.213112`.

Rye carries this all the way down. The backend keeps its own honest semantic version, reported live through `builtin.zig_version`; Rye also reads that same pinned snapshot on its own clock -- Zig 0.16.0 was committed at `20260413.181917` UTC, so that is the backend's name in Rye's time. `rye version` prints both, side by side. The fuller reasoning lives in `../context/specs/rye-versioning-style.md`.

---

## Building and Running

Rye stands on the prebuilt Zig 0.16.0 toolchain kept at `../vendor/zig-toolchain`, fetched from the official release and verified against its published checksum before we trusted a byte of it. That fetch is one command now, and it runs before anything in this tree is built -- plain `sh`, since Rishi is itself a Rye program and arrives only after this step:

```sh
sh tools/f/fetch-toolchain.sh
```

The archive extracts only when the download matches a checksum pinned in this repository rather than fetched beside the file. Four platforms are pinned; the refusal is proven on metal by `tools/f/fetch_toolchain_witness.rish`.

Because the `rye` command is itself a Rye program (`src/main.rye`), Rye builds itself. The first build is the cold start, before any `rye` binary exists -- `bootstrap.sh` bridges the source the way `rye build` does and hands it to the toolchain, pointed at Rye's own `std`:

```sh
./bootstrap.sh
```

From then on, Rye rebuilds itself with its own `build` verb, self-hosting the build and standing as the first resident of the `std` it ships. We write the new binary beside the old one and move it into place. A running program keeps its open file, so the move swaps the directory entry while the process finishes on the prior copy:

```sh
./bin/rye build src/main.rye -femit-bin=bin/rye.next && mv -f bin/rye.next bin/rye
```

The toolchain needs no naming here. `rye build` reads `RYE_ZIG` first, then the pinned toolchain
beside its own binary at `../vendor/zig-toolchain/zig`, then a `zig` on PATH -- the same order
`bootstrap.sh` takes. Export `RYE_ZIG` when you want a different one.

Run the SHA3-512 test; the command finds `lib/` beside its own binary, so `.rye` programs compile against Rye's `std` automatically:

```sh
./bin/rye run tests/sha3_512_test.rye
```

The test hashes the bytes `"Rye"` with SHA3-512 and asserts the digest against a value computed independently beforehand. When it prints the digest and confirms parity, SHA3-512 in Rye is working exactly as it does in Zig 0.16.0 -- the very same code, under a new name.

**Linking and extra sources.** Flags after the `.rye` path pass through to `zig build-exe`. A native client may need a companion `.c` file and system libraries:

```sh
rye/bin/rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
```

---

## Strengthening and the Gate Trio

Rye's `std` grows by **strengthening** -- assertions and `maybe` markers that state what the code already does, while behavior stays exactly as it was. Each pass is recorded in `../external-research/yonder/strengthening-compiler/` and proven by three **Rishi** gates (`../tools/*.rish`):

```sh
rishi/bin/rishi run tools/p/parity.rish          # witness regression suite (116 programs)
rishi/bin/rishi run tools/p/parity-selftest.rish # std must stay symlinked; tamper caught
rishi/bin/rishi run tools/ad/additive-gate.rish   # shape of std changes only (if any local patches)
```

`rye/lib/std` is a **symlink** to the pinned toolchain -- a pristine overlay rather than a fork. `parity.rish` runs each witness once against that `std` (the old differential baseline-vs-strengthened gate retired). `parity-selftest.rish` guards against accidental re-copying `std` into the tree. Details live in `../rye-learning-process/archive/ALMANAC.md` under *The Gate Trio in Rishi*.

---

## A Note on Memory

The `rye` command allocates from `init.garden` -- the process season allocator the runtime clears whole on exit -- so a short-lived command skips finer bookkeeping and leaves the tree clean. This is the region model our designs name Tally, lived in the smallest place.

---

## Rye's garden and the way out

Rye is the language at the bottom of a wider ecosystem we are designing in the open: **Tally**, the
garden allocator; **Caravan**, the supervisor-kernel; **Tablecloth**, the content-addressed store;
**Mantra**, version control; [`Aurora`](../aurora/), boot; and **Pond**, a gentle TAME-style
reimplementation of the `ai-jail` sandbox, a bounded enclosure where an agent can build in safety.
The explorations behind these names live in [`external-research`](../external-research/), and the
from-scratch setup that ties the tools together lives in [`SOURCE.md`](../SOURCE.md).

When your Rye reading is complete, the clean exit is [`Grain home`](../README.md). From there,
[`the docs geode`](../docs-geode/README.md) offers the wider shelf, [`Glow`](../glow/README.md)
offers the higher language, and [`Rishi`](../rishi/README.md) offers the neighboring shell. Rye is
a room in the tree, and a good room leaves its reader oriented toward the whole house.

---

*May the first command be sure, and the language grow surely from it. May every `.rye` file we run leave the tree as tidy as it found it, and may Rye become, in time, wholly its own -- safe, swift, and a joy to write.*
