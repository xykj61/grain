# The First Native arm64 Parity Witness Run on This Mac

**Language:** EN
**Version:** `20260714.005658` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Witness report — real, run, and green through the core; one host-specific gap fully diagnosed

---

## What This Answers

The earlier RISC-V/ARM64 shared-IR research ([`20260713-215200_riscv-arm64-shared-ir-research.md`](20260713-215200_riscv-arm64-shared-ir-research.md)) predicted that Zig's own backend already serves as the shared IR, and named "prove `parity.rish` green natively on this Mac's arm64" as the real, remaining, un-done work. This is that witness run — the first one, actually performed on this host.

## Setting Up the Pinned Toolchain

`vendor/zig-toolchain` did not exist on this Mac; it is gitignored by design (large, fetched, not authored). Following `rye/README.md`'s own stated practice — "fetched from the official release and verified against its published checksum before we trusted a byte of it" — the exact pinned build was fetched and verified:

```
Source:   https://ziglang.org/download/0.16.0/zig-aarch64-macos-0.16.0.tar.xz
Expected: b23d70deaa879b5c2d486ed3316f7eaa53e84acf6fc9cc747de152450d401489 (from ziglang.org's own index.json)
Got:      b23d70deaa879b5c2d486ed3316f7eaa53e84acf6fc9cc747de152450d401489
Size:     52,238,004 bytes — matched exactly
```

Extracted to `vendor/zig-toolchain/`. `rye/bootstrap.sh` then bootstrapped `rye` for the first time on this Mac:

```
rye 20260618.193812  (chronological: YYYYMMDD.HHMMSS, later is larger)
backend: zig 0.16.0  (Rye clock: 20260413.181917; live value via builtin.zig_version)
```

## A Real Finding, Caught Before It Became Silent Debt

Building `rishi` first failed with dozens of `invalid builtin function: '@Pointer'`/`@Enum`/`@Int`/etc. errors — Rye's own `std` copy expects newer Zig reflection builtins that a *different* compiler doesn't recognize. Tracing it: `rye`'s own build command resolves its backend as `RYE_ZIG` if set, **else `zig` on PATH** — and this Mac has Homebrew's Zig `0.15.2` on PATH, silently mismatched with the pinned `0.16.0` std. Setting `RYE_ZIG` and `RYE_LIB` explicitly resolved it immediately, with a clean build. Worth naming plainly: **any future build on this host must set `RYE_ZIG`/`RYE_LIB`, or it will silently reach for the wrong toolchain** — this is a real footgun for a Mac with any other Zig on PATH, not unique to this session.

## The Witness Run, in Full

```bash
export RYE_ZIG=~/urbit/vendor/zig-toolchain/zig
export RYE_LIB=~/urbit/rye/lib
rishi/bin/rishi run tools/parity.rish
```

**GREEN, natively, on this Mac's arm64, for the first time:**

- The full pristine-`std` witness set — dir/fs/mem/crypto/SHA3/Ed25519/X25519/AEAD/sealed-message primitives, Mantra weave, Tally gardens, path/allocator/string utilities, semantic versioning — every one of roughly 100 witnesses named in the chapter-1 run.
- SLC-1 Steps 1–3 (`repl`, `version`, `recall`) and SLC-1 acceptance — the whole Rishi+Mantra shell, working end to end.

**One failure, fully diagnosed, not a regression:** `tools/slc2a_ring1_arbitrary.rish` — the SLC-2a Lap 1 viewer witness — fails because it builds `brushstroke/wayland_seed.rye` **hard-linked against `-lwayland-client`**, Wayland being a Linux-only display protocol with no macOS analog. This is exactly the divergence `gratitude/wayland.md` already names: "the **hosted** Brushstroke build links on the development machine — never a dependency of Rye OS proper on bare metal." On macOS, this one hosted display seed cannot build, by the nature of the two host platforms, not by any fault in the witness or the code it tests.

## What This Confirms

- The earlier research's prediction holds exactly: **no new shared IR was needed.** The pristine-std corpus, Mantra, Tally, and the whole SLC-1 Rishi+Mantra shell compile and run correctly, unmodified, on `aarch64-macos` via the same `.rye`/`.zig` source this project already runs on Linux/x86_64.
- The one gap is a **known, host-appropriate display-layer seam**, not a language or width-discipline problem — TAME's own width migration (`u32`/`u64` discipline) is exactly what made the rest of the corpus port cleanly with zero source changes.

## What Remains — Named Plainly

- **A macOS-native Brushstroke display seed** (Cocoa/Metal or similar, in place of Wayland) is real, separate future work — not attempted here, and not a quick patch, since Wayland has no macOS equivalent to substitute in.
- **Document the `RYE_ZIG`/`RYE_LIB` requirement** somewhere a future contributor on any non-Linux, non-pinned-PATH host will actually see it before hitting the same silent-fallback footgun.
- Chapters beyond SLC-2a (2b onward) were not reached this run, since chapter 1 halts on its first failing assertion; a future run past a Wayland-skip point would need either a macOS display seed or a chapter-1 modification to skip the Wayland-specific witness on this host — neither attempted here.

---

*May the pinned toolchain always be the one actually running, and may every host-specific gap be named as plainly as this one was.*
