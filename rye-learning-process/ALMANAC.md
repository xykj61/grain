# The Rye Almanac

*A growing reference of how Rye and its Zig 0.16.0 toolchain actually work — each entry earned by running code, recorded so the next builder need not rediscover it.*

**Language:** EN
**Version:** `20260620.033912` (Rye chronological stamp)
**Last updated:** 2026-06-20
**Style:** Radiant (see `../context/RADIANT_STYLE.md`); code in TAME Guidance (`../external-research/TAME_GUIDANCE.md`)
**Status:** Living

---

## What the Almanac Holds

This is the field reference for building Rye. Every entry below was confirmed by code that compiled and ran, on the prebuilt Zig 0.16.0 toolchain we keep at `vendor/zig-toolchain`. When the toolchain's standard library surprised us — and the move to its new I/O model surprised us often — we wrote the truth down here, plainly, so the surprise becomes settled knowledge.

Read it as an almanac: practical, accumulated, seasonal. It grows as Rye grows.

---

## Rye v1 Stands on the Zig Toolchain

Rye's first version is honest about what it is: a thin front-end over the Zig 0.16.0 toolchain. A `.rye` file is Zig source for now, since the language has yet to diverge, so every capability the toolchain offers is Rye's by construction.

The one wrinkle we met immediately: the toolchain's front-end reads only the `.zig` extension. `zig run file.rye` answers `error: unrecognized file extension`. So the `rye` command bridges — it copies the `.rye` source to an adjacent `.zig` file, hands that to the compiler, and clears the bridge away afterward so the tree stays tidy. Since `050912`, `rye build` and `rye run` also bridge every local `@import("*.rye")` dependency recursively, rewriting those imports to `.zig` for the toolchain while the repository keeps `.rye` sources only.

**What we write vs what we strengthen:** programs and witness tests are `.rye`; assertions accrete in `rye/lib/std/**/*.zig` because that is the layout `--zig-lib-dir` serves. See `work-in-progress/archive/20260623-033012_open-threads.md` (*Ongoing — Rye vocabulary*) for the historical accretion; living plan is `TASKS.md` and `ROADMAP.md`.

Since then, Rye has taken its first steps away from the toolchain: it owns its standard library, and it counts its versions in its own way. The three entries that follow record how.

---

## Owning the Standard Library with `--zig-lib-dir`

A language earns its own standard library by hosting it. The compiler decides what `@import("std")` means by reading its **library directory**, and the flag `--zig-lib-dir <path>` lets us choose that directory. So Rye keeps its own at `rye/lib/`: the `std/` there is a copy of the toolchain's std we are free to tend, while the rest of the directory — `compiler_rt`, `libc`, the C headers, and the kindred runtime pieces — are relative symlinks back to the pinned toolchain, since we have no wish to change those yet. The `std` copy is about 18 MB; the symlinked remainder would have been some 230 MB, so linking rather than copying keeps the repository lean while still presenting the compiler a complete library tree.

The `rye` command passes `--zig-lib-dir rye/lib` on every run, and **insists** on it: before compiling, it confirms `rye/lib/std/std.zig` is present and refuses, loudly, to fall back to the backend's std. A wrong or missing path stops the run rather than quietly compiling against someone else's library. That insistence is the whole assurance — the proof that our std is in force lives in the path the compiler is handed — which is why `std` itself can stay a faithful, unmarked copy of Zig 0.16.0 that we diverge from one deliberate change at a time.

---

## The Version Lives in the Compiler, Not std

We learned this the honest way: there is no `std.version` in Zig. A language's version is a property of its *compiler*, surfaced through the compiler-generated `@import("builtin")` module as `builtin.zig_version` — a `std.SemanticVersion` with `major`, `minor`, and `patch`. Reaching for a hand-written `std.version` would both diverge our std needlessly and misplace the value, so we use the real mechanism instead, and a `.rye` program reads `builtin.zig_version` to learn the backend it stands upon.

Rye's own version lives where a distribution's version belongs — in the `rye` command — and it is **chronological**, our first deliberate divergence from Zig's semantic scheme. We also give the pinned backend a Rye-clock reading drawn from its real commit time (`20260413.181917` UTC for Zig 0.16.0), so `rye version` can show both truths at once without ever overwriting the backend's own.

---

## Finding the Library Beside the Binary

For `rye run` to point the compiler at `rye/lib`, the command must locate that directory at runtime. Zig 0.16.0 offers no `std.fs.selfExePath` — the I/O refactor moved such things — so we read the running binary's path from `/proc/self/exe` with `std.Io.Dir.readLinkAbsolute(io, "/proc/self/exe", &buf)`, take its directory with `std.fs.path.dirname`, and apply a hard-coded *relative* template, `../lib`. Because the template resolves against the binary's real location, it holds no matter where the repository is cloned; an explicit `RYE_LIB` environment variable overrides it on a host without `/proc`. A small `comptime` assertion keeps the template honest — non-empty, and relative, never an absolute path baked in.

---

## The Entry Point: the Init Handshake

Zig 0.16.0 changed how a program begins, and the change is a gift to clarity. A `main` function may now accept one argument, `std.process.Init`, and the runtime hands it everything a program needs, explicitly, rather than through hidden globals:

- `init.minimal.args` — the command-line arguments.
- `init.minimal.environ` — the environment.
- `init.garden` — the process season allocator (`*std.heap.ArenaAllocator`), cleared automatically on exit.
- `init.gpa` — a general-purpose allocator for finer-grained, freed-as-you-go work.
- `init.io` — the I/O implementation, threaded explicitly through every operation that touches the outside world.
- `init.environ_map` — the environment parsed into a lookup map.
- `init.preopens` — files handed down by the parent process.

`main` may return `void`, `!void`, `noreturn`, `u8`, or `!u8`. Returning `!u8` is the clean way to give an exit code: the value flows straight out as the process's status, with no separate exit call needed.

---

## Arguments and the Environment

The familiar `argsAlloc` is gone. Arguments now arrive through the `Init` handshake and become a slice with one call:

- `const args = try init.minimal.args.toSlice(allocator);` yields `[]const [:0]const u8`.

Environment lookups are equally direct, through the parsed map:

- `const value = init.environ_map.get("RYE_ZIG");` yields `?[]const u8`.

The `rye` command uses exactly these: the first to read its subcommand and file, the second to find its toolchain through the `RYE_ZIG` variable.

---

## The I/O Model: `io`, Threaded Explicitly

The largest change in 0.16.0 is that input and output flow through an explicit `io` value rather than ambient global state. This is deeply in the spirit we already keep: nothing reaches the outside world by surprise; the capability is passed, plainly, to whatever uses it.

In practice this means the old `std.fs` is now a deprecated doorway to `std.Io.Dir`, and the filesystem calls take `io`:

- `const dir = std.Io.Dir.cwd();` — open the current directory (no `io` needed for this one).
- `dir.readFileAlloc(io, sub_path, allocator, limit)` — read a whole file; `limit` may be `.unlimited`.
- `dir.writeFile(io, .{ .sub_path = path, .data = bytes })` — write a file.
- `dir.deleteFile(io, sub_path)` — remove one.

Path helpers such as `std.fs.path.basename` still work; they are pure string work and need no `io`. And `std.debug.print` still takes the familiar format strings — `{s}` for a string, `{d}` for a number — which kept our diagnostics simple. For an error value, `@errorName(err)` with `{s}` prints its name reliably.

---

## Spawning the Toolchain

The `rye` command runs a `.rye` file by handing the bridged `.zig` to the toolchain as a child process. The spawn likewise takes `io`:

- `var child = try std.process.spawn(io, .{ .argv = argv });` — `argv` is `[]const []const u8`, its first element the program to run.
- `const term = try child.wait(io);` — wait for completion, yielding a `Term`.

A `Term` reports how the child ended: `.exited` carries a `u8` status, and `.signal`, `.stopped`, and `.unknown` cover the rest. The `rye` command returns the child's `.exited` code as its own, so a failing `.rye` program surfaces its failure honestly.

A small kindness in the defaults: the child's standard input, output, and error all `inherit` from the parent unless asked otherwise, so a program's output streams straight to the terminal with no plumbing on our part. When `argv[0]` holds a path with a slash, it is run as that path; otherwise it is resolved through the parent's PATH. We pass an absolute toolchain path through `RYE_ZIG`, so the backend in use is never in doubt.

---

## Memory, the Tally Way

The first run of the `rye` command worked and printed the right answer — and the debug allocator then reported several leaks. The lesson was clean and on-theme. We had allocated from `init.gpa`, the leak-checking general allocator, and never freed, so it rightly complained.

The fix is the region model we already cherish, here named Tally in our designs: allocate a short-lived command's memory from `init.garden.allocator()`. The garden clears whole when the runtime exits, so there is nothing to track and nothing to leak. Switching the command's allocations to the garden turned a noisy run into a silent, clean one. The guidance settles simply: for whole-command, live-until-exit allocations, reach for `init.garden`; reserve the freed-as-you-go allocator for memory with a shorter, finer lifetime.

---

## SHA3-512 Parity

The first thing we asked Rye to prove was that SHA3-512 works exactly as it does in Zig 0.16.0. It does, by the only honest measure: a known-correct digest, matched.

The standard library offers `std.crypto.hash.sha3.Sha3_512`, with a `digest_length` of 64 bytes and a one-call form, `Sha3_512.hash(message, &digest, .{})`. We hashed the bytes `"Rye"`, rendered the digest as lowercase hex by hand, and asserted it against a digest computed independently beforehand. It matched to the last nibble:

```
SHA3-512("Rye") = c692f0476279e6b867ee66c6701c119106a38f46881da52d733ac2b0cd092e96
                  30249106dba551524678e70cea61686016926bdc984a191d055b329f2336763f
```

Because Rye v1 is the toolchain under a new name, this is not an approximation of Zig's cryptography — it is the very same code, confirmed.

---

## Building and Running

Two paths, both confirmed:

- **The toolchain.** We fetched the official prebuilt Zig 0.16.0 release, verified its SHA-256 against the published sum before trusting a byte, and keep it at `vendor/zig-toolchain`. Verifying the artifact before use is the safe habit, and it cost nothing.
- **The build.** The `rye` command is itself a Rye program (`rye/src/main.rye`), so Rye builds itself: `rye/bootstrap.sh` for the cold start, then `rye build` to self-host thereafter (see *Rye Builds Rye* below for the one wrinkle). With the toolchain on hand, `rye run rye/tests/sha3_512_test.rye` compiles and runs the test, printing the digest and confirming parity.

---

## A Freestanding Hart on RISC-V

The first time Rye left the operating system behind, it woke a bare-metal hart. `rye build` — the new sibling of `rye run` — hands the bridged source to `zig build-exe` rather than `zig run`, so Rye emits a binary; flags after the file pass straight through, which is how a freestanding target gets chosen. Aiming at `riscv64-freestanding-none` and running the result on `qemu-system-riscv64 -machine virt` taught a handful of lessons worth keeping.

- **The code model matters at the top of RAM.** QEMU's `virt` machine places RAM at `0x8000_0000`, and the default `medlow` code model cannot address a symbol there — its `lui`-based `R_RISCV_HI20` relocation overflows a signed 20-bit field by exactly one (`524288`, where `524287` is the maximum). The fix is the `medany` model, which Zig spells `-mcmodel=medium`: it addresses symbols PC-relative (`auipc`) and so reaches anywhere. This is the canonical RISC-V bare-metal stumble, and the linker error names it precisely once you know to read it.
- **A hart wakes with no stack.** At reset the stack pointer is undefined, so the entry point cannot be an ordinary function — its prologue would write through a garbage `sp`. We make `_start` `callconv(.naked)` so no prologue runs, set `sp` to real memory with a single `li`, and `j` to a normal function that may now use a stack freely.
- **Placement is the linker script's job.** With `-bios none`, the machine begins executing at `0x8000_0000`, so `_start` must live exactly there. We give it its own section, `.text.init`, and a tiny linker script (`ENTRY(_start)`; `. = 0x80000000`; `KEEP(*(.text.init))` placed first) that lays it at the base of RAM. `-fno-entry` tells the toolchain we provide the entry ourselves.
- **The machine has two useful edges.** The `virt` console UART sits at `0x1000_0000`: write a byte to its transmit register and it appears on the console. The SiFive test device sits at `0x10_0000`: write `0x5555` and the machine powers off, handing a clean exit (`0`) back to the host — which is how the seed ends without hanging the emulator.

The whole thing is one command, `aurora/run-seed.sh`, and it dogfoods Rye end to end: Rye's own toolchain builds the binary, against Rye's own `std`, and the emulator wakes it. The seed lives in `../aurora/`.

---

## Rye Builds Rye

We moved the `rye` and `rishi` commands from `.zig` source to `.rye`, so the programs we author are written in our own language. The standard library under `rye/lib/std` keeps the `.zig` name on purpose — that is the layout the compiler looks for when we point it there with `--zig-lib-dir`, the toolchain's library rather than our prose. The line stays clean: `.rye` is what we write, `.zig` is the library the toolchain reads.

With the source in Rye, Rye builds itself: `rye build src/main.rye`. There is one wrinkle worth keeping. A program's own file cannot be overwritten while it runs — the kernel guards the text of a live process, and a direct write returns `ETXTBSY` ("file busy"). So Rye writes the new binary beside the old and moves it into place:

```sh
rye build src/main.rye -femit-bin=bin/rye.next && mv -f bin/rye.next bin/rye
```

The move swaps the directory entry for a fresh inode; the still-running build keeps the old inode until it exits, and the next invocation is the new one. The cold start, `bootstrap.sh`, sidesteps this entirely by invoking the toolchain directly rather than running `rye` to build `rye`. Building anything *other* than the running binary — Rishi, Aurora's seed — meets no such wrinkle, and `rye build rishi/src/main.rye` is exactly how Rishi is built today: a Rye program, built by Rye.

---

## Strengthening the Functions We Call

The strengthening-compiler began at the crypto core — SHA3-512, then the Keccak sponge beneath it. This pass (`20260618.193812`) turned to the everyday: the standard-library functions the `rye` CLI and the Rishi shell call on every run. We traced our own call graph and found a small, load-bearing cluster — and a clean example of *functions that call other functions*, since our scalar searches reach `findScalarPos` through thin wrappers.

Four functions, each a different kind of TAME invariant:

- **`std.mem.trim`** — a *postcondition*: the two cursors close inward and never cross, so the result is a contiguous sub-slice of the input (`begin <= end <= slice.len`). Rishi trims on nearly every line.
- **`std.mem.findScalar`** (which `indexOfScalar` aliases) — a *postcondition at the cold wrapper*: a found index lands in range and truly points at the value (`i < slice.len`, `slice[i] == value`). Stated in the wrapper, not in `findScalarPos`'s hot vectorized loop, so the data plane stays lean — the control/data-plane economy from the TigerBeetle reading.
- **`std.mem.eql`** — a *`maybe`*, the dual of assert: equal and unequal lengths are both expected, so we name the variable space rather than constrain it.
- **`std.fmt.parseInt`** — a *precondition*: a base is `0` (detect the prefix) or a true radix in 2…36; anything else is the caller's mistake, named at the door.

The discipline held: each change adds what the code *says*, never what it *does*. A new witness program, `rye/tests/call_paths_test.rye`, exercises all four across found/not-found, equal/unequal, all-stripped trims, and several bases; the parity gate (`tools/parity.rish`) runs it against the baseline and the strengthened `std` and stays green. And because `rye run` builds in Debug, the assertions are *live* when we run Rishi — every `.rish` script now checks these invariants as it goes. The full study is `strengthening-compiler/9996_stdlib_call_paths.md`.

One deferral, named on purpose: `indexOfScalarPos` is a direct alias to the hot `findScalarPos`, so giving *it* a postcondition means touching the hot core. That waits for a pass that strengthens hot paths behind a `verify` flag — checks too costly for the data plane, compiled in only when asked for.

---

## Crypto on the Bare Hart

We wondered whether our standard-library cryptography would run *freestanding* — on a bare-metal RISC-V hart, with no operating system, no allocator, and no `std.debug.print` beneath it. It does. `aurora/src/named.rye` is a freestanding hart that names a message by its SHA3-512 content hash — the very function we strengthened first, assertions and all — and speaks the name over the `virt` UART before powering down. Built by `rye build` for `riscv64-freestanding-none` and run in QEMU, it produced the digest exactly as a hosted test does.

The reason it works is that the cryptography is *pure*: it computes over fixed-size arrays, allocates nothing, and performs no I/O. Our strengthening kept it that way — `assert` and `maybe` compile to `unreachable` and to nothing, neither of which needs an OS. So the hash, and by the same reasoning the key agreement, the seal, and the signature, all run on the bare hart as readily as in a hosted program.

This is the quiet unlock for the encrypted datagram. The cryptography our network leans on does not wait for an operating system; it runs the moment a hart wakes. Aurora's bare-metal reach and Mantra's content-addressing meet here, on the first stage that does real cryptographic work with nothing beneath it.

And the whole sealed message followed, exactly as the reasoning promised. `aurora/src/sealed.rye` composes key agreement (X25519), the seal (AEAD), the content-name (SHA3-512), and the attestation (Ed25519) on the bare hart, and opens the message — every primitive freestanding, every one pure. The proof is in the name: the content-name it computes is *byte-for-byte the same* as the hosted `sealed_message_test`. One value model, hosted or freestanding — the same sealed message either way. The one thing left between us and an encrypted datagram between two harts was the wire to carry it — and that wire now runs.

---

## Two Harts, One Wire

A sealed datagram is a value; carrying it *between* harts needs a wire. The smallest wire that works is two harts sharing RAM, so that came first. QEMU's `-machine virt` wakes as many harts as `-smp` asks for, and with `-bios none -kernel`, *every* hart enters at the same `_start`. A few lessons made the two-hart stages (`aurora/src/wire.rye`, `aurora/src/posted.rye`) run cleanly:

- **Each hart needs its own stack.** Since all harts share one `_start`, the entry reads `mhartid` and subtracts a per-hart step from the stack pointer (`sp = base - hartid * 64 KiB`), so no two harts trample one stack. The same `mhartid` then routes each hart to its role — sender or receiver — through one argument passed to `kmain`.
- **A flag and a fence make a mailbox.** The sender writes a buffer in shared RAM, then a `fence` (a full RISC-V memory fence), then raises a ready flag; the receiver spins on the flag, then a `fence`, then reads the buffer. The fence on each side keeps the order honest across harts: published before flagged, flagged before read. The flag and buffer are `volatile`, so the spin re-reads memory rather than a cached register.
- **One hart powers down, after the other has read.** The machine's test finisher powers off the *whole* machine, so the receiver writes it only once it has the value; the sender rests in a `wfi` loop rather than halting, lest it cut the wire mid-message.
- **Zig 0.16 clobbers are a struct.** Inline-asm clobbers moved from a string (`::: "memory"`) to a struct (`::: .{ .memory = true }`); the older spelling no longer compiles.

On that wire, `posted.rye` carries a whole sealed datagram: hart 0 seals and serializes it into the mailbox; hart 1 reads the raw bytes, *shape-casts* them (a datagram shorter than its header or longer than the wire is refused at the edge), and opens it — trusting only its own secret and the sender's public key off the wire, reconstructed with `Ed25519.PublicKey.fromBytes`, `Ed25519.Signature.fromBytes`, and `X25519.publicKeyFromEd25519`. The content-name matches the hosted test once more.

The next rung is a **hosted wire** between processes: `comlink/hosted_wire.rye` seals the same datagram shape and posts it over **localhost UDP** (port 38472). One process sends; one receives, shape-casts, and opens. Modes: `selftest` (crypto in one process), `send`, `recv`, `demo` (supervisor spawns recv then send). Build:

```sh
rye build comlink/hosted_wire.rye -lc -femit-bin=comlink/bin/hosted-wire
```

After that, the wire is a real device between two machines — virtio-net in QEMU ([`expanding-prompts/20260620-034212_virtio-device-wire.md`](../expanding-prompts/yonder/20260620-034212_virtio-device-wire.md)).

---

## The Gate Trio in Rishi

Safety rests on gates in **Rishi** — no `.sh` fallbacks:

| Gate | Script | What it proves |
|------|--------|----------------|
| **Witness suite** | `tools/parity.rish` | All **116** witness programs pass against pristine `std` (once per witness) |
| **Std overlay guard** | `tools/parity-selftest.rish` | `rye/lib/std` stays a symlink to vendor; tamper on a copied tree is caught |
| **Additive** | `tools/additive-gate.rish` | If `rye/lib/` changes, only assertions/comments/`maybe` (guards against re-fork) |

Run from the repository root:

```sh
rishi/bin/rishi run tools/parity.rish
rishi/bin/rishi run tools/parity-selftest.rish
rishi/bin/rishi run tools/additive-gate.rish   # after a rye/lib-touching commit
```

**Thin frontend (2026-06-28):** `rye/lib/std` symlinks to `vendor/zig-toolchain/lib/std`. The old differential parity gate — baseline `RYE_LIB` vs strengthened `rye/lib` — **retired**; both arms would read the same bytes. `parity.rish` is now a **behavior regression suite**. The selftest ensures no one replaces the symlink with a copied tree without witnesses still catching behavioral drift. The strengthening chronicle (`strengthening-compiler/`) remains honest record; invariants belong at **call sites** in authored `.rye` per [`work-in-progress/archive/20260628-044200_call-site-harvest.md`](../work-in-progress/archive/20260628-044200_call-site-harvest.md).

---

## `init.garden` — Season Memory

Rye renamed `std.process.Init.arena` to **`init.garden`**: the process season allocator, cleared whole on exit. Locals in our programs say `const garden = init.garden.allocator()` where the metaphor reads honestly; inherited Zig names such as `ArenaAllocator` stay until a deliberate std fork (`context/specs/inherited-names.md`). The garden is Tally's pattern lived in the runtime before Tally is a module.

---

## Caravan on Hosted Ground

Supervision grows by accretion on the host, where Rishi's gates reach every build. Each step is a `caravan/*.rye` seed (`active-designing/yonder/20260622-235012_what-we-mean-by-seed.md`):

| File | Claim |
|------|--------|
| `seed.rye` | One parent, one child, restart on fall |
| `bounded.rye` | Child in a Tally `Region`; budget enforced |
| `twin.rye` | Two children, separate stack gardens |
| `chain.rye` | Ordered startup (`wake` → `prove`); per-stage restart, chain does not rewind |

Build any seed: `rye build caravan/chain.rye -femit-bin=caravan/bin/chain`. The path toward Caravan v1 continues with a capability table, then freestanding kernel work (`984`).

---

## Brushstroke — Frame from Values

Brushstroke draws immediate-mode: a **Frame** value, a pure **redraw** pass, no retained widget tree.

- **Hosted seed** (`brushstroke/seed.rye`) — redraw to stdout; proves values → surface on the hosted path.
- **Wayland seed** (`brushstroke/wayland_seed.rye`) — same Frame; SHM buffer on an xdg toplevel. Build with an extra C protocol file and system libraries:

```sh
rye build brushstroke/wayland_seed.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lrt \
  -femit-bin=brushstroke/bin/brushstroke-wayland-seed
```

Flags after the `.rye` path pass through to `zig build-exe`, so link lines and additional translation units ride the same bridge as freestanding targets. Display seam wrappers live in the seed; the full brief is `active-designing/yonder/20260619-072600_brushstroke.md`.

---

## Rishi — Builtins Worth Knowing

Rishi (`rishi/src/main.rye`, built by `rye build`) is the shell that runs the gate trio. Beyond the first-version surface documented in `rishi/README.md`, these builtins matter for tooling:

- **`read-file` / `write-file` / `list-dir`** — file I/O behind OS wrappers (`rishi/tests/file_io.rish`).
- **`lines`** — split a string on newlines into a list.
- **`starts-with`** — prefix check as a boolean expression.
- **`length`** — byte length of a string or element count of a list.
- **`trim`** — remove surrounding ASCII whitespace from a string.
- **`slice`** — bounded substring with half-open indices.

Integer arithmetic, `map`/`where`, records, and `run` compose the parity gate. `write-file` has a practical size limit today — large std files are tampered in place with `sed -i` on a shadow tree instead.

---

## Open Threads

A few paths we have left lit for later, each a deliberate choice rather than an oversight:

- **Self-hosting the `rye` command.** The command is now written in Rye (`rye/src/main.rye`) and built by `rye build`, so the *build* is self-hosted. The deeper end state remains ahead: Rye compiling Rye, rather than bridging to the Zig toolchain beneath. We walk toward it as the language grows its own shape.
- **A `build.rye` story.** `rye build` now compiles a single `.rye` file to a binary, freestanding targets included, and accepts extra source files and link flags after the path (see *Brushstroke* above). Zig builds *whole projects* through a `build.zig` script; Rye will want its own `build.rye` for many-file programs, bridged the same way single files are today.
- **Device wire (virtio-net).** Sealed datagram over emulated `virtio-net` between two QEMU guests — Comlink's next rung after `comlink/hosted_wire.rye` (`10016`).
- **Strengthening series.** Passes 9988–9991 and crypto foundation 9995 are green; the next `std` surfaces our tools lean on each earn a strengthening note and a witness extension when they change behavior.
- **Pond.** The `ai-jail` sandbox we work inside is a Rust project; re-growing it as a gentle, TAME-style enclosure in Rye — Pond — is a thread we mean to follow once the language stands on more of its own.

---

*May each finding here stay true, and may the next builder trust it. May the gardens we allocate clear cleanly, the digests we compute match to the last nibble, and the language we grow stand surely on ground we have tested ourselves.*

