format session-log-v1
stamp 20260715.214500
editor Cursor
model Cursor Sonnet 5 1M Medium
voice Quin
host cloud agent (Cursor Cloud) — Linux sandbox
title riscv64 parity witness green — Glow's fold runs on RISC-V
prompt yes -- build the riscv64 parity witness the way M0 did aarch64
think Mirror tools/glow_mobile_target_witness.rish for riscv64: same Sala B0 source, target riscv64-linux-musl, run under qemu-riscv64-static, assert byte-identical session root.
think Checked prerequisites first: vendor/zig-toolchain, rye, rishi, and qemu-riscv64-static all present in the sandbox.
obs Witness ran green on the first run -- cross-build produced a RISC-V binary and the emulated run reproduced the same GREEN and the byte-identical session root claim, matching native and aarch64. This turns the RISC-V-substrate decision from argued to witnessed.
obs Kept the witness standalone rather than adding it to parity_ch01.rish, matching M0's placement -- emulation witnesses that need qemu stay out of the core suite.
file tools/glow_riscv_target_witness.rish new witness: cross-build Sala B0 for riscv64, run under qemu, assert byte-identical root
file active-reviving/20260715-213500_glow-revives-hoon-runes-targets-riscv.md register + primary-backend line updated to green with the witness path
file context/specs/20260715-193000_two-dev-environments-and-mobile-emulation.md added the M0-riscv rung to the ladder and the related links
file external-research/20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md primary-backend bullet updated from argued to green
file session-logs/README.md prepended this log row
recommend keep-going the primary RISC-V path is now green; the next honest lap is M1 (postmarketOS full-system boot) which gates on the NixOS Framework host existing -- a check-in point, not a mechanical next step here
