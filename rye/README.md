# Rye

**Language:** EN
**Version:** `20260620.033912` (Rye chronological stamp)
**Last updated:** 2026-07-10 (Radiant Style pass round 2)
**Style:** Radiant prose (see `../context/RADIANT_STYLE.md`); code in TAME Guidance (`../external-research/TAME_GUIDANCE.md`)
**Status:** Checkable — living language module

---

## What Rye Is

Rye is the systems language we are growing from Zig 0.16.0. This first version is honest about what it is: a careful front-end that runs `.rye` source through the Zig 0.16.0 toolchain, on a standard library that is now Rye's own. A `.rye` file is Zig source at heart for now, so every capability the toolchain offers — including SHA3-512 in the standard crypto library — is Rye's too, by construction. Yet Rye has begun to diverge: it carries its own copy of the standard library, and it counts its versions in its own way. Over time, it grows further into its own shape.

The `rye` command speaks three verbs:

- `rye version` — print Rye's chronological version and the backend it stands upon.
- `rye run <file.rye>` — compile and run a single `.rye` source file, against Rye's own standard library.
- `rye build <file.rye>` — compile a `.rye` source file to a binary. Flags after the file pass straight through to the toolchain, so Rye can aim at any target it supports.

Because the toolchain's front-end reads only the `.zig` extension, both `run` and `build` bridge: they copy the `.rye` source to an adjacent `.zig` file, hand that to the compiler — pointed at Rye's standard library — and clear the bridge away so the tree stays tidy.

The first place we aimed `rye build` was bare metal. It compiled a freestanding RISC-V program that wakes on an emulator — at once Rye's RISC-V cohesion made concrete and Aurora's first living seed, a hart that comes up, speaks one asserted line, and rests. That seed and its story live in `../aurora/`.

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

The lessons learned while building Rye live in their own home, `../rye-learning-process/`, with the growing reference in `ALMANAC.md` — gate trio, Caravan seeds, Brushstroke, strengthening, and Zig 0.16.0 I/O.

Sibling modules built with `rye build` include **Rishi** (`../rishi/`), **Caravan** (`../caravan/`), **Tally** (`../tally/`), **Brushstroke** (`../brushstroke/`), **Mantra** (`../mantra/`), and **Aurora** (`../aurora/`). What *seed* means in this family is defined in `../active-designing/yonder/20260622-235012_what-we-mean-by-seed.md`.

---

## Owning the Standard Library

A language is not wholly its own until it owns its standard library. Rye does. The folder `lib/` is Rye's library directory: its `std/` began as a **bit-for-bit copy of Zig 0.16.0's** standard library, now under our care to tend and grow; the rest of the directory links back to the pinned toolchain, unchanged. The `rye` command points the compiler at this library with `--zig-lib-dir`, so `@import("std")` in a `.rye` program means *Rye's* std.

The command **insists** on it. Before compiling, it confirms our library sits at the expected path and refuses to run against anything else, so a successful `rye run` is, by construction, a run against Rye's own standard library. The assurance lives in the path, not in any marker written into the code — which lets `std` stay a faithful copy that we diverge from deliberately, a clean diff at a time.

A note on names, while we are here. The programs we author carry the `.rye` extension — `src/main.rye`, the tests, Aurora's seed. The standard library under `lib/std` keeps the `.zig` extension, because that is the name the compiler looks for when we point it at the library; it is the toolchain's layout, not our prose. So the line stays clean: `.rye` is what we write, `.zig` is the library the toolchain reads.

---

## How Rye Counts Time

Rye's first deliberate divergence from Zig is the way it names its versions. Where Zig counts semantically (`0.16.0`), Rye counts **chronologically** — `YYYYMMDD.HHMMSS`, where later is always larger — so a version says *when*, and carries only the one semantic worth keeping. The first running, divergent version is `20260617.213112`.

Rye carries this all the way down. The backend keeps its own honest semantic version, reported live through `builtin.zig_version`; Rye also reads that same pinned snapshot on its own clock — Zig 0.16.0 was committed at `20260413.181917` UTC, so that is the backend's name in Rye's time. `rye version` prints both, side by side. The fuller reasoning lives in `../context/specs/rye-versioning-style.md`.

---

## Building and Running

Rye stands on the prebuilt Zig 0.16.0 toolchain kept at `../vendor/zig-toolchain`, fetched from the official release and verified against its published checksum before we trusted a byte of it.

Because the `rye` command is itself a Rye program (`src/main.rye`), Rye builds itself. The first build is the cold start, before any `rye` binary exists — `bootstrap.sh` bridges the source the way `rye build` does and hands it to the toolchain, pointed at Rye's own `std`:

```sh
./bootstrap.sh
```

From then on, Rye rebuilds itself with its own `build` verb, self-hosting the build and dogfooding the `std` it ships. We write the new binary beside the old one and move it into place — a running program keeps its open file, so the move swaps the directory entry while the process finishes on the prior copy:

```sh
export RYE_ZIG="$PWD/../vendor/zig-toolchain/zig"
./bin/rye build src/main.rye -femit-bin=bin/rye.next && mv -f bin/rye.next bin/rye
```

Run the SHA3-512 test; the command finds `lib/` beside its own binary, so `.rye` programs compile against Rye's `std` automatically:

```sh
./bin/rye run tests/sha3_512_test.rye
```

The test hashes the bytes `"Rye"` with SHA3-512 and asserts the digest against a value computed independently beforehand. When it prints the digest and confirms parity, SHA3-512 in Rye is working exactly as it does in Zig 0.16.0 — the very same code, under a new name.

**Linking and extra sources.** Flags after the `.rye` path pass through to `zig build-exe`. A native client may need a companion `.c` file and system libraries:

```sh
rye/bin/rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
```

---

## Strengthening and the Gate Trio

Rye's `std` grows by **strengthening** — assertions and `maybe` markers that state what the code already does, never changing behavior. Each pass is recorded in `../strengthening-compiler/` and proven by three **Rishi** gates (`../tools/*.rish`):

```sh
rishi/bin/rishi run tools/parity.rish          # witness regression suite (116 programs)
rishi/bin/rishi run tools/parity-selftest.rish # std must stay symlinked; tamper caught
rishi/bin/rishi run tools/additive-gate.rish   # shape of std changes only (if any local patches)
```

`rye/lib/std` is a **symlink** to the pinned toolchain — pristine overlay, not a fork. `parity.rish` runs each witness once against that `std` (the old differential baseline-vs-strengthened gate retired). `parity-selftest.rish` guards against accidental re-copying `std` into the tree. Details live in `../rye-learning-process/ALMANAC.md` under *The Gate Trio in Rishi*.

---

## A Note on Memory

The `rye` command allocates from `init.garden` — the process season allocator the runtime clears whole on exit — so a short-lived command needs no finer bookkeeping and leaves nothing behind. This is the region model our designs name Tally, lived in the smallest place.

---

## Rye's Garden

Rye is the language at the bottom of a wider ecosystem we are designing in the open: **Tally**, the garden allocator; **Caravan**, the supervisor-kernel; **Tablecloth**, the content-addressed store; **Mantra**, version control; **Aurora**, boot; and **Pond** — a gentle, TAME-style reimplementation of the `ai-jail` sandbox we work inside, a bounded enclosure where an agent can build in safety. The explorations behind these names live in `../external-research/`, and the from-scratch setup that ties the tools together lives in `../SOURCE.md`.

---

*May the first command be sure, and the language grow surely from it. May every `.rye` file we run leave the tree as tidy as it found it, and may Rye become, in time, wholly its own — safe, swift, and a joy to write.*
