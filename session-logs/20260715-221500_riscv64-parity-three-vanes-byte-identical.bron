format session-log-v1
stamp 20260715.221500
editor Cursor
model Cursor Sonnet 5 1M Max
voice Quin
host cloud agent (Cursor Cloud) — Linux sandbox
title riscv64 parity broadened to three vanes, full-stdout byte-identical
prompt kg (model switched to Sonnet 5 1M Max) -- extend the riscv64 proof beyond Sala B0 to the Neth and Pool folds
think Chose the most foundational witness from each vane family to mirror Sala's B0 choice: neth_root_witness.rye (Neth's own minimal first witness, the load-bearing claim its whole design rests on) and pool_host_seam_witness.rye (Pool P0, the keystone's first real lap).
think Checked import graphs for all three candidates -- all resolve sibling .rye files from the same linengrow/ directory, the same pattern the already-working Sala cross-build uses, so no new build-system wiring was needed.
think Built and ran each natively first (green) before attempting the riscv64 cross-build, confirming a trustworthy baseline to compare against.
think Cross-built and ran all three under qemu-riscv64-static -- all green, and diffing native vs emulated stdout directly in the shell showed byte-for-byte IDENTICAL output for all three, with no volatile content (timestamps, addresses) to explain away. This is a stronger, more general claim than comparing one hash line.
think Checked Rishi's own feature list (main.rye's own doc comment) for == string equality, confirming the witness could compare native.out == emu.out directly rather than hardcoding a hash literal -- self-verifying against source drift, never a citation that could fall stale per docs-implementation-sync.
think Hit one real bug: run ["sh" "-c" "${bin}"] without a trailing 2>&1 returned an empty .out in Rishi, even though the process printed to stdout and exited 0. Found the fix by reading a working sibling witness (pool_host_seam_witness.rish) which always appends 2>&1 to its native run -- confirmed this is Rishi's own established convention, not a new discovery, and applied it to all three native-run captures.
obs Grew tools/glow_riscv_target_witness.rish additively rather than writing three separate per-vane files -- there is no existing per-module-per-arch convention (M0 aarch64 also only ever covered Sala), so one file naming the RISC-V-substrate rung stays the single named artifact, gaining proofs as it grows.
obs Ran the full parity_ch01.rish suite afterward and hit an unrelated pre-existing failure (SLC-2a Lap 1, linking -lwayland-client) -- traced it to a missing wayland dev-package in this specific cloud sandbox (runtime .so present, dev symlink/headers absent), confirmed unrelated to this change, and left it alone rather than scope-creeping into an unrelated fix.
obs The M0-riscv rung in the mobile-emulation spec, the active-reviving decision brief, and the external-research lens all updated from "green (Sala only)" to "green across three keystone vanes, full-stdout byte-identical" -- docs-implementation-sync satisfied by reading and running before each claim was written.
file tools/glow_riscv_target_witness.rish grown from a single Sala-only witness into three blocks (Sala B0, Neth, Pool P0), each comparing full native-vs-riscv64 stdout for exact equality
file active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md sharpened the primary-backend and validated-decisions sections to name all three vanes and the full-stdout comparison method
file context/specs/20260715-193000_two-dev-environments-and-mobile-emulation.md M0-riscv rung updated to name the three-vane coverage and re-stamped
file external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md primary-backend bullet updated to name all three vanes
file work-in-progress/TASKS.md added a checked line for the seated decision + green three-vane witness; Last-updated line re-stamped
file session-logs/README.md prepended this log row
recommend check-in the next honest rung is M1 (postmarketOS full-system boot), which gates on the NixOS Framework host existing -- a real-world dependency, not something provable in this sandbox. Inside-sandbox keep-going options remaining: extend riscv64 parity to Rhyz/Kumara or Comlink, or begin the Nock-second-backend interop seam now that the primary path is proven across three vane families.
