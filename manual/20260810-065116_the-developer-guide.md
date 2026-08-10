# The Developer Guide

**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Audience:** Acme Corporation employees · anyone contributing to this tree
**Status:** Living — describes what runs today; horizons named as horizons.

---

Welcome. This guide is for the person who wants to change the code — to fix a
witness, grow a module, or send a first contribution. It assumes you can read a
programming language and hold a shell prompt; it assumes nothing else. By the
end you will know the four languages this system speaks, the single discipline
every module keeps, how to build a module and prove it green, and how to send
that work the way the rest of the tree already does.

The whole system rests on one promise: **every claim is checked on metal.** A
module is done when a witness runs green against it, and a document tells the
truth only about behavior a reader can reproduce. That promise is the through-line
of everything below.

---

## 1. The four languages

This tree speaks four languages, and each one has exactly one job. Learn the
boundaries between them first; the syntax follows quickly once the roles are clear.

| Language | Extension | Role | Evaluated or read |
|----------|-----------|------|-------------------|
| **Rye** | `.rye` | Systems code — the modules themselves | Compiled to a native binary |
| **Rishi** | `.rish` | The shell — witnesses, tools, orchestration | Interpreted, line by line |
| **Brix** | `.brix` | Composition — declares systems and maps | Evaluated to data |
| **Kyri** | `.kyri` | Data notation — records, logs, configuration | Parsed, never evaluated |

A short way to remember it: **Rye builds, Rishi runs, Brix declares, Kyri records.**
Code lives in Rye and Rishi; facts live in Brix and Kyri. The line between the two
is the line between a program and the data it reads, and that line is never crossed
by accident.

### Rye — the systems language (`.rye`)

Rye is where the modules live: the identity vault, the sealed wire, the ledger,
the vector store. It is a disciplined dialect of Zig, compiled ahead of time to a
single native binary with no runtime and no garbage collector. Every allocation
is named and bounded; every surprising line earns a comment that says why.

A real Rye file opens with the same three lines, always in this order:

```rye
const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
```

This is the **opening triad**, and it is not optional. `std` is the standard
library seam. `assert` is imported once so every check reads as a bare `assert(...)`
rather than a qualified `std.debug.assert(...)`. `print` is imported once so
output and witness claim-lines read as bare `print(...)`. Every hosted Rye file in
the tree begins here.

### Rishi — the shell (`.rish`)

Rishi is the shell that drives everything: it runs witnesses, builds binaries,
and orchestrates the tools. Its defining feature is the **run-record**: every
external command returns a small record you inspect before trusting anything.

```rish
let ok = run ["vault/bin/vault" "selftest"]
assert ok.ok else "vault: selftest did not run"
assert ok.out contains "GREEN" else "vault: selftest was not green"
say "GREEN: vault selftest holds."
```

`run` returns a record with `ok` (did the command succeed), `out` (what it printed
to standard output), and `err` (what it printed to standard error). You check the
status **before** you trust the output — a command that failed prints nothing you
should believe. `assert … else …` is the pipeline gate: it stops the witness with a
named message the moment a claim fails. `say` prints a line for a human to read.
Conditionals are `if / then / else`; iteration is `for-each`.

### Brix — the composition language (`.brix`)

Brix declares systems and maps. It is read by a first-space split — a key, a
space, the rest of the line as the value — with blank lines and `#` comments
ignored. A Brix file states invariants at the top, in comments, so a reader knows
the shape before reading the rows:

```brix
# Invariant: exactly four blocks
# Invariant: each block names one direction, exactly once
kind map
name equinox_map
count 4

# A — the rising quarter
block A
direction east
element fire
```

Brix is data that happens to describe structure. It evaluates to the same plain
key-value shape Kyri uses, which is why the two feel like siblings: Brix is the
composed, block-structured form; Kyri is the flat record form.

### Kyri — the data notation (`.kyri`)

Kyri is where records live: session logs, configuration, inventory. A Kyri
document opens with a `format <name>` line that names its shape, then carries
`key value` fields, one per line, with `#` comments and blank lines ignored. No
quotes, no braces, no nesting — one field per line, plainly.

```kyri
format session-log-v1
stamp 20260810.065116
title developer guide first pass
think named the four languages and their boundaries
think grounded each example in a file that already runs
file manual/the-developer-guide.md the guide itself
recommend keep-going
```

A key may repeat — `think` and `file` above appear more than once, and every
occurrence is kept in order. The reader for Kyri (the `scribe` module) is
**zero-copy**: it parses a document into fields that are slices *into the source
text*, never copies of it, and every bound — the longest source, the most fields
— is named as a constant and asserted at the edge. That is the same discipline
Rye keeps everywhere, applied to reading a file.

---

## 2. The TAME discipline every module keeps

Every module in this tree keeps one discipline, and it has a name: **TAME**. The
full guidance lives in `../context/TAME_GUIDANCE.md`; this section is the working
summary a contributor needs at the keyboard. TAME governs `.rye`, `.rish`,
`.brix`, and `.kyri` alike, and its priority order is fixed:

> **Safety first — structural, not by convention. Performance second — measure
> before optimizing. Joy third — clarity, named things, the habit of saying why.**
> When these pull against each other, safety wins. When safety and performance
> are equal, joy earns the vote.

Here is what that order asks of your code.

### State invariants before you implement them

Write the `assert` calls first — at construction, at every mutation, and at every
postcondition — each preceded by a `// invariant:` comment that names what must be
true. This is the load-bearing habit of the whole tree. A module is not trusted
because it looks correct; it is trusted because it asserts its own correctness and
a witness confirms those assertions hold.

```rye
fn init(buf: []u8) Region {
    // invariant: buffer is non-empty
    assert(buf.len > 0);
    const r = Region{ .buf = buf, .pos = 0 };
    // postcondition: position starts inside the buffer
    assert(r.pos <= buf_len_u32(r.buf));
    return r;
}
```

Aim for at least two asserts on every function you write or touch —
preconditions, postconditions, and bounds. A green witness does **not** excuse a
module with no asserts of its own; the witness proves behavior from outside, and
the asserts prove it from inside.

### Bound everything, with a named maximum

Every allocation, every collection, every pipeline names a maximum — declared as a
constant at construction, enforced at the edge. No unbounded growth lives in this
tree.

```rye
// The child's memory budget — 256 bytes. Small on purpose: the proof
// is in the bound, not in the size.
const child_budget: u32 = 256;

// The longest source the reader accepts, and the most fields it holds.
const max_source_len: u32 = 65536;
const max_fields: u32 = 512;
```

The comment beside each bound is not decoration — it is the **say why** rule.
Every assertion, every named constant, every surprising design choice earns a
comment that names the reason, so the next reader inherits the intent, not just
the value.

### Explicit widths — `u32` for counts, `u64` for the wire

Integer width is a design decision, stated explicitly:

- **`u32`** for in-memory counts, indices, and lengths bounded by a named constant.
- **`u64`** for wire-persistent sizes, timestamps, and quantities that cross a
  target boundary.
- **`usize`** appears **only** at the inherited-standard-library seam — never in a
  struct field, a function parameter, a return type, or a local you publish as API.
  At that seam you assert the bound, keep the arithmetic in `u32`, and cast at the
  edge:

```rye
fn buf_len_u32(buf: []const u8) u32 {
    assert(buf.len <= std.math.maxInt(u32));
    return @intCast(buf.len);
}
```

Reaching into the standard library returns a `usize`; this helper asserts it fits
and hands back a `u32`, so the rest of the module reasons in one width. That cast
is correct code, not debt.

### `snake_case`, and no `@memcpy`

Functions, variables, and file names are `snake_case`. Copies between disjoint
slices go through the `copy_disjoint` helper rather than a raw builtin — the one
intentional low-level copy in the tree lives inside `copy_disjoint` itself and
nowhere else. When you touch a file that still uses an old form, migrate it in the
same edit; the style is a ratchet that tightens on contact, not a sweep you go
hunting for.

### Accrete, never break

The tree grows by adding, not by rewriting. Dated records — session logs,
research, testimony — are never edited to match a later truth; they stand as the
honest record of their moment, and a newer record accretes beside them. Living
documents and code may be revised freely; sealed and dated artifacts may not. When
in doubt, add a new file at a new timestamp rather than rewrite an old one.

---

## 3. Build a module, prove it green

A module earns its place by running green. The rhythm is: build the binary, write
a witness that exercises it, run the witness, and only then claim the module works.
This is **green-before-claim**, and it is the difference between "I think it works"
and "here is the proof."

### Build the binary

A Rye module compiles to a single native binary. Emit it into the module's own
`bin/` directory:

```
rye build vault/keeper.rye -femit-bin=vault/bin/keeper
```

The binary is self-contained: no runtime to install, no interpreter to match. A
well-formed module answers a `selftest` argument by running its own internal
checks and printing a green line, so the binary can prove itself before any
external witness even runs.

### Write the witness

A witness is a Rishi script in `../tools/` named `<module>_..._witness.rish`. It
runs the binary, inspects the run-record, and asserts every claim the module makes.
A witness is small, exact, and reads like a paragraph of proof:

```rish
# tools/vault_selftest_witness.rish — the keeper proves its own custody.
#
#   rishi/bin/rishi run tools/vault_selftest_witness.rish

say "vault: selftest — the keeper holds and returns the secret."

let out = run ["vault/bin/keeper" "selftest"]
assert out.ok else "vault: selftest did not run"
assert out.out contains "GREEN" else "vault: selftest was not green"

say "GREEN: vault selftest holds."
```

Every witness follows the same shape: a header comment with the one-line command
to run it, a `say` that states what is being proven, a sequence of `run` and
`assert … else …` gates, and a closing `GREEN:` line. When the last line prints,
the claim is proven — not asserted, proven, on this machine, right now.

### Run it

```
rishi/bin/rishi run tools/vault_selftest_witness.rish
```

Green means the module holds. Red means a named assertion failed, and the message
tells you which one. There is no third state — a witness either proves the claim or
names exactly where the claim broke.

---

## 4. Add a new module the right way

Here is the path a newcomer walks to add a module and have it fit the tree the
first time. Nothing here is ceremony; each step is the shortest route to a module
that is honest, bounded, and provable.

1. **Name it plainly.** Reach for the clearest, warmest, safest word — a plain
   word or a clear metaphor a newcomer grasps at once, at whatever length that word
   wants to be. Grep the tree first so the name collides with nothing already
   seated.

2. **Give it a home.** A module lives in its own directory: the `.rye` source, a
   `bin/` for the compiled binary, and a `README.md` that says in one paragraph
   what the module is and how to run its witness.

3. **Open with the triad.** Every hosted `.rye` file begins with
   `const std`, `const assert = std.debug.assert`, `const print = std.debug.print`.

4. **State the bounds and invariants first.** Before the logic, name the maximums
   as constants and write the `// invariant:` asserts at construction, mutation,
   and postcondition. Aim for at least two asserts per function.

5. **Keep the widths explicit.** `u32` for bounded counts, `u64` for the wire,
   `usize` only at the standard-library seam with the bound asserted and the cast
   at the edge.

6. **Answer `selftest`.** Have the binary run its own internal checks and print a
   green line, so it proves itself before any external witness.

7. **Write the witness.** A `..._witness.rish` in `../tools/` that builds or runs
   the binary, inspects the run-record, asserts every claim, and closes on a
   `GREEN:` line.

8. **Run it green.** `rishi/bin/rishi run tools/<your>_witness.rish`. Do not claim
   the module works until this line prints green.

9. **Document only what runs.** The README describes behavior the reader can
   reproduce. Where a capability is a plan rather than a fact, say so — name it a
   horizon, honestly.

Grow the module beside its neighbors, born with its own name, rather than renaming
something that already exists. The tree prefers a new thing, cleanly named, over a
churn of old ones.

---

## 5. Sending your work

When your work is ready, you **send** it — commit, push, and (when clean)
fast-forward to the main branch. The commit discipline is borrowed directly from a
large, careful open-source community, because it earns trust the same way the
witnesses do: every commit explains itself.

### The commit subject

- **Component-prefixed:** the short prefix names the area the commit touches —
  `vault:`, `scribe:`, `manual:`, `tools:`, and so on, matching the directory or
  module the change lives in.
- **Under 50 characters** total, prefix and description together, so it reads in a
  one-line log without wrapping.
- **Present tense, plain:** "add," "fix," "prove," "rename" — what the commit does,
  not what it will do or has done.

### The commit body

Write a short paragraph naming what changed and why it matters, in the same warm,
honest voice as the prose everywhere else — no filler, no hedging. Close with a
`Related` section that names the companion documents or states "no related work"
plainly, rather than omitting it. When a commit touches several files, name what
each significant one contributes.

```
manual: add the developer / contributing guide

Names the four languages and their boundaries -- Rye builds, Rishi
runs, Brix declares, Kyri records -- then the single TAME discipline
every module keeps: the opening triad, invariant asserts, named
bounds, explicit widths, snake_case, no raw copies. Closes with the
green-before-claim rhythm and the send discipline, so a newcomer can
add a module the right way the first time.

Related

Grounds every example in a file that already runs green in this tree.
```

### Signing and green-before-send

- **Commits are GPG-signed.** Signing stays on; never bypass it. A signed history
  proves who wrote each line the same way a witness proves what each line does.
- **Green before send, when there is code.** The witness runs green first, or the
  commit honestly names why it could not run. A document changed alongside code
  updates in the **same** commit, so a doc never describes behavior the code no
  longer has.
- **One record rides along.** A session log — a `.kyri` file capturing the
  reasoning behind the change — ships in the same send whenever possible.

---

## 6. Where to look next

- **`../context/TAME_GUIDANCE.md`** — the full discipline, every rule with its
  reasoning.
- **`../context/RADIANT_STYLE.md`** — the voice this tree writes in, prose and
  commits alike.
- **`reference/rishi-language.md`** — the Rishi language and command-line
  reference.
- **`tutorials/first-witness.md`** — run, read, and write your very first witness,
  by the hand.
- **`../tools/`** — the living corpus of witnesses. Every one of them is a worked
  example of green-before-claim; read a few near the module you mean to touch.

---

You now have the whole shape: four languages with clean boundaries, one discipline
that asks you to state your invariants and bound your growth, a build-and-witness
rhythm that proves work rather than assuming it, and a send discipline that leaves
a history which explains itself. Build something small, prove it green, and send
it. The tree grows one honest, witnessed module at a time — and there is room in
it for yours.
