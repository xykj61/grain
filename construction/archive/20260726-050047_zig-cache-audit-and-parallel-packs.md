# Zig Cache Audit · Parallel Packs Design (S1)

**Language:** EN  
**Stamp:** `20260726.050047`  
**Voice:** Quin  
**Status:** Checkable — sidecar measurement on Framework metal; design note only for packs  
**Ground:** counsel [`../counsel/20260726-044729_the-graph-is-not-a-vane.md`](../../counsel/20260726-044729_the-graph-is-not-a-vane.md) · in-flight COLD F left undisturbed · nib before this send was `9ec80323c0`  
**Bound:** S0 cost table from the *next* full instrumented run still gates archive cuts and S2 workers  

---

## S1a — Zig cache audit

### Where the caches resolve today (before seating)

| Variable | Value on this Framework sitting |
|---|---|
| `ZIG_LOCAL_CACHE_DIR` | **unset** |
| `ZIG_GLOBAL_CACHE_DIR` | **unset** |
| Zig `global_cache_dir` (from `vendor/zig-toolchain/zig env`) | `/home/xy/.cache/zig` (~1.1G warm at audit time) |
| Zig version | 0.16.0 |

### Do they survive between runs?

| Context | Survives? |
|---|---|
| **Framework metal / host shell** | **Yes.** `~/.cache/zig` is ordinary host home cache; the in-flight COLD F is using it and was not wiped for this audit. |
| **ai-jail with `--private-home`** (Cursor jail default in `tools/cursor-jail.sh`) | **No — the jail home resets.** A cache that lives under `$HOME/.cache/zig` inside a private-home enclosure does not travel with the pier; the next jail session starts cold. That is the afternoon-risk path. |

**Plain sentence:** On bare metal the Zig cache was **not** being reset every parity run. Inside a private-home jail it **would** be, and that single fact can own most of a 106-minute wall when the 116-file rye map and every `build-exe` after it recompile cold.

### Seated shelf (persistent, gitignored)

Both variables now default to the pier-local shelf when unset (via `tools/parity_zig_cache_seat.sh` and `tools/parity_time_one.sh`):

| Variable | Seated path |
|---|---|
| `ZIG_LOCAL_CACHE_DIR` | `tools/.cache/zig/local` |
| `ZIG_GLOBAL_CACHE_DIR` | `tools/.cache/zig/global` |

`tools/.cache/` is already gitignored. The in-flight COLD F was **not** pointed at this shelf (it keeps its living `~/.cache/zig`); the next full run and all timed witnesses inherit the seated paths.

### Cold / warm pin — one rye-map file

File: `rye/tests/sha3_256_test.rye`  
Env: seated `tools/.cache/zig/{local,global}` only (host `~/.cache/zig` left alone for F).

| Pass | Wall (time) | Wrapper `elapsed_ms` |
|---|---:|---:|
| **Cold** (empty seated dirs) | **40.53 s** | **40404** |
| **Warm** (same seated dirs) | **0.29 s** | **212** |

Warm is roughly **190×** faster on this one file. Extrapolating without claiming precision: a fully cold 116-file rye map at ~40 s each would be hours; a warm map at ~0.2 s each is tens of seconds. Larger module `build-exe` steps (lantern, lattice, …) amplify the same cliff.

---

## S1b — Parallel packs design note (workers wait for S2)

Named packs (counsel): `std` · `modules` · `glow` · `product` · `metal`. Full parity remains their union. **No worker code lands until S0's cost table prints.**

### Parallel-safe (independent — candidates for bounded `spawn`/`wait-for`)

| Family | Why safe |
|---|---|
| **std** — pristine `rye/tests/*` map | Pure compile+assert; no ports; cache-keyed |
| **modules** — Lattice / Scribble / Anvil corpus views / TAME lints / width-check / opening-lines / living-docs | File-local witnesses; no device ownership |
| **glow** — jam/cue vectors, glow REPL, digraph twin, glow text floors | Script-local; no QEMU |
| Most **product** seeds (Granary/Mandi listing math, Tally gardens, Kumara seed without wire) | In-process or temp dirs |

Duplicates across packs must be **deduplicated** at the driver (one physical witness, many pack memberships).

### Serial by law (port / device / shared mutable)

| Family | Why serial |
|---|---|
| **Caravan** subscribe-poll · SIGTERM · host-mirror · restart-on-ok · footgun | Owns supervision lifecycle and signals |
| **Comlink / Mantra wire** labs (hosted+device sync, catch-up, poll intervals) | Shared wire endpoints / ports |
| **OA-L5** completion / consent wire | Wire surface |
| **metal / proven-seat** — `receipt_verify_wasm`, signed-Kumara, any `lane_kvm` / HAWM / QEMU guest | Host tools, devices, or exclusive guest slots |
| Anything that writes a **shared** temp path another witness reads | Mutable cross-talk |

Rule kept from counsel: parallel witnesses must never share mutable state; QEMU and wire-lab families stay serial.

### Joy target (design only)

Touched-pack loop under a minute or two once S2 workers land and S1a's shelf stays warm; COLD full union keeps afternoon honesty and alone unblocks H.

---

## What this round did not do

- Did not disturb in-flight COLD F  
- Did not cut or archive any witness (lane b gated on S0 table)  
- Did not land S2 pack driver flags/workers  
- Did not implement S3 receipts (hammock only — see active-designing)

---

*May the cold path stay the release truth. May the warm shelf live with the pier. And may every parallel pack refuse the ports it does not own.*
