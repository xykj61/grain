# Cursor Build — SLC-1 Step 3: Recall, in `rishi/src/main.rye`

*The fourth verb, built on the ring Step 2 already fills. A prior line comes back and runs again, exactly as if typed. One small refactor lets the normal path and the recall path share a single honest road, and the loop closes its circle: type, run, version, recall.*

**Stamp:** `20260629.024012`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Discipline:** TAME (see `context/TAME_STYLE.md`) · SLC
**For:** Cursor Composer 2.5, in the ai-jail sandbox
**Grounding:** scope — [`active-designing/20260629-004912_slc-1-step-2-version.md`](active-designing/20260629-004912_slc-1-step-2-version.md) (Step 3 named in the parent SLC-1 note) · the ring landed in `rishi/src/main.rye` at `History` (line ~126) and the meta block in `runRepl` (line ~298)

*Written together by Kaeden and Reya 2.*

---

## How We Build This

Propose, then apply — 3a → 3c, in order. Typecheck `rishi/src/main.rye` against pristine std after each substep; building `rishi` and running the witness are Kaeden's metal. New code stays TAME: bare `assert` (already imported at line 37), `u32` counts, named edges, and — the one rule recall leans on hardest — **user input is untrusted, so a bad recall index is met with a friendly named message, never an assertion that could crash the loop.**

**What recall is, drawn from the ring as it landed.** `History` holds the recent **input lines**, duped into the season arena, numbered from 1 across the current window by `:history`. Recall re-runs one of those lines. The ring holds only normal statements — the `:` meta lines never enter it — so a recalled entry is always safe to evaluate, with no meta-recursion to guard.

**In-session is the bar.** Recall reads the ring, not the store. Reading a versioned transcript back from `.mantra/blobs/` stays a horizon unless a demo asks for it.

---

## Phase 3a — `:recall <n>`

### First, one clean refactor — a shared road for a typed line

Right now the normal-input path in `runRepl` does its work inline: record the prompt line, dupe into the arena, record to history, evaluate, handle the error. Recall needs that very same work. So lift it into one helper, and let both callers use it — the "push the `if`s up, the leaf down" habit, and the guarantee that a recalled line behaves *exactly* as a typed one.

```zig
/// Run one ordinary input line as if freshly typed: record it to the
/// transcript and the history ring, evaluate it, and report any error.
/// The shared road for both the prompt and :recall.
fn runInputLine(
    garden: std.mem.Allocator,
    io: std.Io,
    env: *Env,
    history: *History,
    transcript: *Transcript,
    line: []const u8,
) !void {
    transcriptAppendPromptLine(transcript, line);
    const kept = try garden.dupe(u8, line); // the line may point into reused memory; keep our own
    history.record(kept);
    evalStatement(garden, io, env, line) catch |err| {
        if (err == error.AssertionFailed) {
            // doAssert already named the broken fact.
        } else {
            const err_name = @errorName(err);
            std.debug.print("rishi: {s}\n  {s}\n", .{ err_name, line });
            transcriptAppendError(transcript, err_name);
        }
    };
}
```

Then the normal path at the bottom of the loop becomes one call:

```zig
try runInputLine(garden, io, &env, &history, &transcript, line);
```

### Then the verb itself

In the `:` meta block of `runRepl`, after `:version` and before the unknown-meta fallback, add `:recall <n>`. The meta line is already recorded to the transcript at the top of the block, so this branch resolves the index and re-runs:

```zig
if (std.mem.startsWith(u8, line, ":recall ")) {
    const arg = std.mem.trim(u8, line[":recall ".len..], " \t");
    if (history.count == 0) {
        std.debug.print("rishi: no history yet to recall\n", .{});
        continue;
    }
    const n = std.fmt.parseInt(u32, arg, 10) catch {
        std.debug.print("rishi: usage — :recall <n>, where 1 <= n <= {d}\n", .{history.count});
        continue;
    };
    if (n < 1 or n > history.count) {
        std.debug.print("rishi: :recall out of range — choose 1 to {d}\n", .{history.count});
        continue;
    }
    // Capture before re-running: re-recording may shift the ring.
    const target = history.items[n - 1];
    try runInputLine(garden, io, &env, &history, &transcript, target);
    continue;
}
```

Notes on the honest edges: an empty ring, a non-numeric argument, and an out-of-range index each meet a clear message and continue. The recalled line re-enters history and the transcript as a freshly run line — faithful to "as if typed." Capturing `target` into a local before the call keeps it valid even though `record` may shift the ring when full.

---

## Phase 3b — `!<n>` Alias (optional, gated)

The meta table is stable now — `:quit`, `:q`, `:history`, `:version`, `:recall`. If it stays clean, add the shorthand `!<n>` for `:recall <n>`. It lives in its own small branch, since these lines open with `!` rather than `:`. Place it just before the `:` block:

```zig
if (line[0] == '!') {
    const arg = std.mem.trim(u8, line[1..], " \t");
    // resolve and re-run exactly as :recall <n> does — share the resolution
    // by calling a small recallByIndexText(arg, ...) helper, or fold this
    // into the :recall branch's logic.
    ...
    continue;
}
```

*Recommended only if it stays small.* If sharing the resolution would tangle the two branches, leave `!<n>` for a later pass and keep `:recall <n>` as the complete verb. Skip it cleanly rather than force it.

---

## Phase 3c — The Witness

`tools/slc1_recall_step3.rish` with `tools/fixtures/slc1_recall_step3.input`. Recall needs no store and no `PATH`, so follow the **Step 1 inline pattern** — no nested double-quotes, no fixture shell script required:

```
let result = run ["sh" "-c" "rishi/bin/rishi repl < tools/fixtures/slc1_recall_step3.input"]
```

Fixture (piped to `rishi repl`):

```
let mark = "RE-RAN"
say "${mark}"
:recall 2
:quit
```

`let mark` is entry 1; `say "${mark}"` is entry 2 and prints `RE-RAN`; `:recall 2` re-runs entry 2 and prints `RE-RAN` a second time. The witness proves the **re-run**, not merely a single print, by counting occurrences — two appearances split into three parts (see `rishi/tests/split.rish` for the surface):

```
assert result.ok else "rishi repl recall pass exited non-zero"
let parts = split result.out by "RE-RAN"
assert (length parts) == 3 else ":recall did not re-run the prior line"
say "GREEN: SLC-1 Step 3 — :recall brings a prior line back and runs it again."
```

Register it in `tools/parity.rish` beside the Step 1 and Step 2 witnesses once it runs green on metal — the suite then carries 119.

*(Should any quoting trouble surface, fall back to the Step 2 fixture-shell-script pattern; the inline form is the simpler default here because recall touches no store.)*

---

## The Documentation — Toward SLC-1 Acceptance

Step 3 adds the last meta-command, so name the full set where a person will find it. In `rishi/README` (or `rye-learning-process/ALMANAC.md`, whichever holds the shell's reference), document the meta-commands plainly: `:quit` / `:q` to end, `:history` to list recent lines, `:version` to weave the session into Mantra, `:recall <n>` to run a prior line again (and `!<n>` if it landed).

With this, the **SLC-1 acceptance** checklist comes into reach: type → run → version → recall closing on metal, the gate trio green, the pristine-`std` guard green, `rishi run` and `rishi version` unchanged, and the meta-commands documented. When that holds, SLC-1 is whole — the first lovable ring, finished.

---

## The Gates

- **Typecheck** `rishi/src/main.rye` against pristine std after 3a, 3b, 3c. **[sandbox-verifiable]**
- **`width-check.rish`** — green on the new code (counts are `u32`; no new `usize`). **[sandbox-verifiable]**
- **`tame-check.rish`**, if present — bare `assert`, no `Self = @This()`. **[sandbox-verifiable]**
- **`parity.rish`** with the new `slc1_recall_step3.rish` — green on metal. **[metal-gated]**

State plainly at the end which gates ran by running and which await metal.

---

## Commit, Push, Session Log

Commit as one honest unit — the `runInputLine` refactor, `:recall`, the optional `!<n>`, the witness, the fixture, and the doc update together. Write a session log at `session-logs/<filing-stamp>_slc1-step3-recall-built.md`, coauthored, in Radiant voice: the refactor and why it serves both paths, the untrusted-index handling, what typechecked in the sandbox, and what awaits metal. Push over HTTPS to the usual remotes from the host; Berry on the tip if it pleases you.

*(Kaeden: supply the filing stamp verbatim; `20260629.024012` is this pass's mark, re-stamped for the moment it lands.)*

---

## Definition of Done

- [ ] `runInputLine` holds the shared road; the normal path calls it
- [ ] `:recall <n>` re-runs a prior line as if typed; empty, non-numeric, and out-of-range inputs meet friendly messages
- [ ] `!<n>` either rides cleanly or is cleanly deferred
- [ ] The witness proves the re-run (two occurrences) and is registered once metal-green
- [ ] Meta-commands documented in `rishi/README` or the ALMANAC
- [ ] `rishi/src/main.rye` typechecks against pristine std; `rishi run` / `rishi version` unchanged
- [ ] The four verbs close on metal — SLC-1 acceptance in reach

---

*May the fourth verb close the circle the first three opened. May a line once typed come back whole to the hand that asks for it. And may the first ring, finished, run on the very metal it was made for — simple, lovable, and complete.*
