# Cursor Build — SLC-1 Step 2: Version, in `rishi/src/main.rye`

*The implementation pass for one verb, gated step by step. The session gains two bounded structures and one meta-command that weaves it into Mantra's store. Grounded in the loop Step 1 already proved, built incrementally, typechecked at each turn, with the witness held for metal.*

**Stamp:** `20260629.004912`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Discipline:** TAME (see `context/TAME_STYLE.md`) · SLC
**For:** Cursor Composer 2.5, in the ai-jail sandbox
**Grounding:** scope — [`active-designing/20260629-004912_slc-1-step-2-version.md`](active-designing/20260629-004912_slc-1-step-2-version.md) · runbook Phase 2 — [`expanding-prompts/20260629-004912_cursor-pass-slc1-version-recall-and-tame.md`](expanding-prompts/20260629-004912_cursor-pass-slc1-version-recall-and-tame.md)

*Written together by Kaeden and Reya 2.*

---

## How We Build This

Propose, then apply — one substep at a time, in the order 2a → 2f. After each substep, typecheck `rishi/src/main.rye` against pristine std with the pinned toolchain the seed header documents, and show the result. Building the `rishi` binary and running the witness need Kaeden's metal; everything else is **[sandbox-verifiable]** by typecheck.

Build in TAME order. The new code is born clean: bounded structures with named ceilings, a `u32` count, two assertions a function on average, and the unqualified `assert` imported once. We add no width debt and no qualified asserts in anything we write here.

**Settled rulings carried in:** the Mantra binary resolves via `RISHI_MANTRA`, defaulting to `"mantra"` on `PATH`; the transcript records prompt, input, and caught errors only, with stdout capture left as a horizon; `.mantra/` is created lazily on first `:version`.

---

## One Import, Up Front

At the top of `rishi/src/main.rye`, beside the existing `const std = @import("std");`, add the unqualified assert the supplement asks for, so the new code calls it bare:

```zig
const assert = std.debug.assert;
```

Optional, gated ratchet — since we are already in this file: convert the eighteen existing `std.debug.assert(` calls to bare `assert(`, leaving the file clean for the coming `tame-check`. Propose it; Kaeden's call whether it rides this pass or waits for the next touch. It is mechanical and safe, yet it is not Step 2's heart.

---

## The Two Bounds

Near the other module constants, name the two ceilings the hammock spec drew — both first estimates the metal may revise:

```zig
const max_history: u32 = 50;             // recent input lines kept for :history and (Step 3) :recall
const max_transcript_bytes: u32 = 65536; // the session transcript's ceiling, in bytes
```

---

## Phase 2a — The Session Ring

A bounded ring of recent **input lines**, the cache for `:history` now and `:recall` in Step 3. It mirrors `Env`'s bounded shape, with a `u32` count.

```zig
/// A bounded ring of the most recent input lines. Bounded on purpose: the
/// limit is named, so a long session meets a clear edge rather than growing
/// without end. The oldest line is released when the ring is full.
const History = struct {
    items: [max_history][]const u8 = undefined,
    count: u32 = 0,

    fn record(self: *History, line: []const u8) void {
        assert(self.count <= max_history); // invariant: never past the ceiling
        if (self.count == max_history) {
            var i: u32 = 1;
            while (i < max_history) : (i += 1) self.items[i - 1] = self.items[i];
            self.items[max_history - 1] = line;
        } else {
            self.items[self.count] = line;
            self.count += 1;
        }
        assert(self.count <= max_history); // invariant: still in range
    }
};
```

**Correctness — duplicate the line before storing it.** In `runRepl`, the trimmed `line` is a slice into the reader's reused `stdin_buffer`; the next read overwrites it. So before recording, copy the line into the season arena and store the copy:

```zig
const kept = try garden.dupe(u8, line);
history.record(kept);
```

A stored slice into `stdin_buffer` would dangle. The dupe into the arena lives for the session, which is exactly its lifetime.

---

## Phase 2b — The Transcript

A bounded, in-memory text record of prompt, input, and caught errors, held until `:version`. It owns its bytes, so it needs no dupe.

```zig
/// The durable record the weave remembers: prompt, input, and caught errors,
/// in order, bounded by a named ceiling. Held in memory until :version writes
/// it whole to .mantra/session.log.
const Transcript = struct {
    bytes: [max_transcript_bytes]u8 = undefined,
    len: u32 = 0,

    /// Append text if it fits. Returns false at the edge — the caller then
    /// invites a :version to checkpoint, rather than wrapping in silence.
    fn append(self: *Transcript, text: []const u8) bool {
        assert(self.len <= max_transcript_bytes);
        assert(text.len <= std.math.maxInt(u32));
        const add: u32 = @intCast(text.len);
        if (add > max_transcript_bytes - self.len) return false; // bounded edge
        const start: usize = @intCast(self.len);
        const end: usize = @intCast(self.len + add);
        @memcpy(self.bytes[start..end], text);
        self.len += add;
        assert(self.len <= max_transcript_bytes);
        return true;
    }
};
```

(The `usize` here is the inherited-std seam at the slice index — assert-and-cast, exactly the Tally pattern, permitted under the refined width-check.)

A small helper keeps the record shape in one place: write `"rishi> "`, then the input line, then a newline; on a caught error, write `"  error: "`, the error name, and a newline. When `append` returns false, print a gentle line inviting `:version`, and continue.

---

## Phase 2c — `:history`

In `runRepl`'s meta-command branch, add `:history` — print the ring entries, numbered from 1 across the current window:

```zig
if (std.mem.eql(u8, line, ":history")) {
    var i: u32 = 0;
    while (i < history.count) : (i += 1) {
        std.debug.print("  {d}  {s}\n", .{ i + 1, history.items[i] });
    }
    continue;
}
```

`:recall` stays an unknown meta-command for now; it arrives in Step 3, reading this same ring.

---

## Phase 2d — The Lazy Store

`:version` touches the store only when first asked. Carry a session flag in `runRepl`:

```zig
var store_ready = false;
```

On the first `:version`, ensure `.mantra/` exists — stat it, and run `mantra init` only when it is absent — then set `store_ready = true`, so repeated versions stay quiet.

---

## Phase 2e — `:version`

The verb itself. A small helper resolves the binary and runs Mantra, reusing the `std.process.run` path `doRun` already proves:

```zig
fn mantraBin(allocator: std.mem.Allocator) []const u8 {
    // RISHI_MANTRA overrides; otherwise "mantra" on PATH (settled ruling).
    return std.process.getEnvVarOwned(allocator, "RISHI_MANTRA") catch "mantra";
}

fn runMantra(allocator: std.mem.Allocator, io: std.Io, args: []const []const u8) !std.process.Child.RunResult {
    const bin = mantraBin(allocator);
    const argv = try allocator.alloc([]const u8, args.len + 1);
    argv[0] = bin;
    for (args, 0..) |a, i| argv[i + 1] = a;
    return std.process.run(allocator, io, .{ .argv = argv });
}
```

*(Confirm the exact env and `RunResult` names against pristine std as you build; the shape is what matters.)*

On `:version`, in order:

1. Ensure the store lazily (Phase 2d).
2. Write the transcript whole to `.mantra/session.log` — `Dir.cwd().writeFile(io, .{ .sub_path = ".mantra/session.log", .data = transcript.bytes[0..transcript.len] })`.
3. Weave it — `runMantra(garden, io, &.{ "add", ".mantra/session.log" })`.
4. Report the result: on a zero exit, print Mantra's stdout (the advanced HEAD line); otherwise print its stderr and the code, plainly.

Composition holds throughout: Rishi calls the Mantra program and reads its result; Mantra's internals stay in Mantra.

---

## Phase 2f — The Witness

`tools/slc1_version_step2.rish` with `tools/fixtures/slc1_version_step2.input`, in the Step 1 mould — a `.rish` witness wrapping an `sh -c`. **[metal-gated to run]**

Fixture (input piped to `rishi repl`):

```
let greeting = "hello"
say "${greeting}"
:version
:quit
```

The shell prepares a clean temporary directory as cwd, puts `rishi/bin` and `mantra/bin` on `PATH` (or sets `RISHI_MANTRA` to the built binary), runs `rishi repl` against the fixture, then confirms `.mantra/HEAD` is non-empty and `.mantra/blobs/` holds at least one blob, and echoes a clear `GREEN: SLC-1 Step 2` line. The Rish witness asserts the shell exited zero and its output carries that line:

```
let result = run ["sh" "-c" "<setup, run, verify, echo GREEN>"]
assert result.ok else "rishi repl version pass exited non-zero"
assert result.out contains "GREEN: SLC-1 Step 2" else "version did not advance HEAD with a blob"
say "GREEN: SLC-1 Step 2 — the session versions into Mantra."
```

Register it in `tools/parity.rish` once it runs green on metal, beside `slc1_repl_step1.rish`.

---

## The Gates

- **Typecheck** `rishi/src/main.rye` against pristine std after each substep. **[sandbox-verifiable]**
- **`width-check.rish`** — green on `rishi/src/main.rye` for everything we add (new counts are `u32`; the one transcript seam is asserted-and-cast). The file's pre-existing `usize` is its own later pass, not this build's. **[sandbox-verifiable]**
- **`tame-check.rish`**, if present — the new code carries bare `assert` and no `Self = @This()`. **[sandbox-verifiable]**
- **`parity.rish`** and **`slc1_version_step2.rish`** — green on metal. **[metal-gated]**

State plainly at the end which gates ran by running and which await Kaeden's metal.

---

## Commit, Push, Session Log

Commit the build as one honest unit — the two structures, the meta-commands, the composition, the witness, and the fixture together. Write a session log at `session-logs/<filing-stamp>_slc1-step2-version-built.md`, coauthored, in Radiant voice: the thinking trace, the dangling-slice catch and how it was met, what typechecked in the sandbox, and what awaits metal. Push over HTTPS to the usual remotes from the host; Berry on the tip if it pleases you.

*(Kaeden: supply the filing stamp verbatim; `20260629.004912` is the pass mark, re-stamped for the moment this lands.)*

---

## Definition of Done

- [ ] `History` and `Transcript` exist, bounded and asserted; input lines are duped into the arena before storing
- [ ] `:history` prints the numbered ring
- [ ] `:version` ensures the store lazily, writes the transcript, runs `mantra add`, and reports HEAD
- [ ] The Mantra binary resolves via `RISHI_MANTRA` then `PATH`
- [ ] `rishi run` and `rishi version` behave exactly as before
- [ ] `rishi/src/main.rye` typechecks against pristine std; width-check green on the new code
- [ ] The witness is written; green on metal; registered in `parity.rish` once the suite is green

---

*May the second turn of the loop close as cleanly as the first. May the session find its home in the store, written whole and named by its content. And may the kept line carry forward, alive for exactly as long as the hand that typed it is still at the keys.*
