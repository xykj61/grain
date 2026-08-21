# Acme DX — First-Hour Witness Contract (Design Season, Equinox 2)

**Language:** EN
**Stamp:** `20260811.163927`
**Status:** Mixed -- Design contract — the second of the Acme DX design season's four deliverables ([`../expanding-prompts/20260811-145659_acme-dx-design-season.md`](../expanding-prompts/20260811-145659_acme-dx-design-season.md)). The reference module and its witness below were built and run GREEN in a scratch tree `20260811.163927`; the development season types them into the repository.
**Voice:** Kyri · **Style:** Radiant · **Audience:** an Acme Corporation employee an hour into Grain
**Begins where Equinox 1 ends:** the newcomer already has GREEN from an existing witness ([`20260811-150221_acme-dx-onboarding-path-contract.md`](20260811-150221_acme-dx-onboarding-path-contract.md)); now they build a tiny module of their **own** and witness it.

---

## What this contract pins

The first hour ends when a newcomer has written their own module, built it, and watched their own witness go GREEN — meeting the whole TAME discipline at its smallest: a named bound, invariant asserts at the edges, a selftest that proves by comparison, a `GREEN:` line. This contract carries the exact reference — one module, one witness, each about a screen — so the development season only has to place them in the tree. Both were built and run in a scratch tree first, so the shape is measured, not proposed.

## The starter module — `greet.rye` (reference, built GREEN)

```zig
//! greet.rye — your first Grain module: a bounded greeting.
//!
//!   rye build greet.rye -femit-bin=bin/greet
//!   bin/greet selftest

const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

// The longest name the greeting will hold — a bound named once, enforced at the edge.
pub const max_name: u32 = 32;

/// Write "hello, <name>!" into `buf`, returning its byte length. The name is bounded,
/// and the greeting is proven to fit the buffer before a byte is written.
pub fn greet(name: []const u8, buf: []u8) u32 {
    // invariant: a name never exceeds the bound.
    assert(name.len <= max_name);
    const prefix = "hello, ";
    const needed = prefix.len + name.len + 1; // +1 for "!"
    // invariant: the greeting fits the caller's buffer.
    assert(needed <= buf.len);
    var n: usize = 0;
    for (prefix) |c| { buf[n] = c; n += 1; }
    for (name) |c| { buf[n] = c; n += 1; }
    buf[n] = '!'; n += 1;
    return @intCast(n);
}

fn prove_greet() !void {
    var buf: [64]u8 = undefined;
    const n = greet("grain", &buf);
    if (!std.mem.eql(u8, buf[0..n], "hello, grain!")) return error.WrongGreeting;
}

fn run_selftest() !u8 {
    try prove_greet();
    print("greet: hello, <name>! — a bounded greeting, name <= max_name, proven to fit its buffer.\n", .{});
    print("GREEN: greet — your first Grain module builds, bounds its input, and greets by proof.\n", .{});
    return 0;
}

pub fn main() !u8 { return run_selftest(); }
```

It teaches the whole discipline in one screen: the **opening triad** (`std` · `assert` · `print`), a **named bound** (`max_name`), an **invariant assert** at each edge with its `// invariant:` reason, a **selftest that proves by comparison** rather than by claim, and a **`GREEN:` line** the witness reads.

## The witness — `greet_witness.rish` (reference, ran GREEN)

```
# greet_witness.rish — proves your first module builds and greets by proof.
let build = run ["sh" "-c" "mkdir -p <dir>/bin && rye/bin/rye build <dir>/greet.rye -femit-bin=<dir>/bin/greet"]
assert build.ok else "greet build failed"
let st = run ["<dir>/bin/greet" "selftest"]
assert st.ok else "greet selftest exited non-zero"
assert (st.err contains "GREEN") else "greet selftest not GREEN"
assert (st.err contains "proven to fit its buffer") else "greet missing the bound claim"
say "GREEN: greet witness — your first module builds, bounds its input, and greets by proof."
```

The witness shape is the discipline again, at the outside: **check `.ok` before trusting output**, assert the **`GREEN:`** line, and assert one **named claim** the module makes — so the witness proves a fact, not just that a program ran. (`std.debug.print` writes to stderr, so the witness reads `st.err`.)

## The acceptance line — measured, not promised

```
GREEN: greet — your first Grain module builds, bounds its input, and greets by proof.
```

Produced on metal in a scratch tree at `20260811.163927`. The first hour is **done** when a newcomer's own `greet.rye` builds and prints this line, and their own `greet_witness.rish` goes GREEN.

## Definition of done for this equinox

- The reference is **one module + one witness, each about a screen**, and both were **built and run GREEN** before this contract was called done (measured `20260811.163927`).
- The module meets the **SLC Rye Definition of Done** (opening triad · ≥2 contract asserts with `// invariant:` · a selftest · no `@memcpy` · a `GREEN:` line) — so it teaches the discipline by being it.
- The development season places `greet.rye` under a tutorial path and `greet_witness.rish` under `tools/`, building to a **gitignored** `bin/` like every module — with nothing left to decide about *what* the first hour builds.

The next design equinox — the **interfaces surface** — begins where this one ends: the newcomer has built one module by copying a reference; next they learn the API, CLI verbs, and desk shape to build a module that is genuinely their own.

---

*May a newcomer's first hour end with their own name in their own GREEN line, and may the smallest module still carry the whole discipline.*
