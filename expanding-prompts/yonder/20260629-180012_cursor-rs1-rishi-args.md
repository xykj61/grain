# Cursor Pass — RS-1: A Script Can Read Its Own Arguments

*The shell learns to hand a script the words that followed it. Rishi already holds lists and strings and a binding that shadows; RS-1 simply pre-binds one value — `args` — into the script's world before its first line runs, and gives a script the two small ways to read it. No new value is born; the model gains a single injected binding and a length-and-index it can already almost express.*

**Stamp:** `20260629.180012`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Guidance:** TAME (`context/TAME_GUIDANCE.md`) — bounds, the seam, friendly handling of untrusted input
**For:** Cursor Composer 2.5 in the jail (typecheck), Claude Code on the host (metal)
**Tip:** pull `2447d99` first.

*Written together by Kaeden and Reya 2.*

---

## What RS-1 Is, and Is Not

**Is:** a script run by `rishi run <path> [more words…]` can read those trailing words as a value named `args`, ask how many there are, and reach each one.

**Is not:** the flag parser (RS-2), and not the launcher's native `--appimage` (RS-3). Both are pure Rishi scripts built on what RS-1 lays down; they need no further interpreter change. Keep this pass to the one complete step.

---

## The Design — One Injected Binding, Reusing the Model

The value model already carries `string` and `list`, and `Env.bind` already adds a binding that `lookup` finds most-recent-first. RS-1 uses exactly these.

**Bind `args` before the script runs.** In `runFile`, after the path is read from `args[2]`, gather `args[3..]` into a Rishi `.list` whose items are `.string`, and `Env.bind("args", …)` it into the script's environment before evaluating the first line. It then behaves as any other binding — a script may even shadow it with its own `let args`, by the shadowing rule already in `lookup`. **No new `Value` kind; no new binding mechanism.**

**What `args` holds.** The user's arguments only — `args[3..]`, in order — so `args[0]` is the first word after the script path. The script's own name stays out of `args`; a script reads its own arguments, not the shell's. (A separate `script` or `arg0` binding can come later if a need appears; not in RS-1.)

**How a script reads them — the two small additions.** First confirm whether any list access already exists and reuse it; add only what is missing. The minimal, consistent pair:

- **Length** — `args.len` returning an `int`, mirroring the record field access scripts already use (`result.ok`). A length pseudo-field on a list.
- **Index** — `args[n]`, with `n` an integer expression, returning the `.string` at that position.

Both are general over lists, with `args` as the first consumer rather than a special case. *(Kaeden blesses the final syntax; this is the proposal.)*

**Out-of-range stays gentle.** `args[n]` past the end returns a **friendly error**, never an assertion — command-line input is untrusted, the same reasoning that governs an out-of-range `:recall`. Assertions guard our invariants; a user's mistake earns a kind message and a clean nonzero exit.

---

## Bounds and the Seam

**Bound the count.** Name `max_args` (a `u32`, e.g. 64) with a comment saying why. Assert `args[3..].len <= max_args` at the boundary; if a caller exceeds it, fail with a friendly message rather than a crash. Per-argument length is already bounded by the operating system's argv limit; the Env slot `args` consumes is covered by the existing `TooManyBindings` bound.

**Cross the shell boundary cleanly.** The process argv arrives as `[]const [:0]const u8`, `usize`-indexed at the std edge. Apply the seam policy now written in `TAME_GUIDANCE`: assert the count fits, `@intCast` it to `u32`, and **dup each argument's bytes into the garden** as you build its `.string`, so every string in the value model shares one ownership story and nothing borrows a lifetime it cannot keep. The Transcript a few lines away already shows the assert-then-`@intCast` shape to follow.

---

## The Model Stays One

State plainly in the code comments and the session log: RS-1 adds **no new value kind**. `args` is a `.list` of `.string`. The one new thing at runtime is a single binding the interpreter injects before a script runs; the one new thing in the grammar is length-and-index over the `.list` that already exists. The value model remains the same five shapes.

---

## Witness

Add `tools/rs1_args.rish` (and register it in `parity.rish`) exercising:

- **No arguments** — `args.len == 0`, and the script runs without error.
- **Several arguments** — `args.len` is right, and `args[0]`, `args[1]`, … read back the exact words.
- **Out of range** — `args[len]` yields the friendly error, observably, rather than crashing.
- **Over the bound** — more than `max_args` fails friendly. (Drive this from a small host harness if a `.rish` cannot pass that many itself.)

And confirm **the SLC-1 repl still passes** unchanged — RS-1 touches `runFile`, not the interactive loop.

---

## Verify on Metal (host)

```
rye build                                  → rishi rebuilds clean
rishi/bin/rishi run tools/rs1_args.rish a b c   → args.len 3; a, b, c read back
rishi/bin/rishi run tools/parity.rish      → GREEN (count risen)
rishi/bin/rishi run tools/slc1_accept.rish → SLC-1 still green
```

If the repl path or an SLC-1 witness shifts, stop — RS-1 reached past `runFile`.

---

## Scope Guardrails

- No flag parsing, no `--flag value` helper — that is RS-2.
- No loops, no general list library beyond length and index — those wait for a proven need.
- `args` carries the trailing words only; the script name is out of scope.

---

## What Comes Next (not this pass)

- **RS-2** — a flag-parse helper written in Rishi, reading fixed positions of `args` and comparing. Mechanical on these primitives **unless** it needs a string operation Rishi lacks (a prefix test, a split); that is a new semantic question — check in before adding it.
- **RS-3** — `launch-cursor.rish` takes `--appimage PATH` natively through the helper, and the flag layer in `cursor-jail.sh` graduates out.

---

## Record and Push

Commit as one honest unit — the `runFile` change, the list length/index, the witness, and the session log. Log at `session-logs/<stamp>_rs1-script-args.md`: the injected-binding design, the friendly out-of-range choice, the `max_args` bound, the seam, and the note that the value model stays five shapes. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## Before You Move On — Recommend the Next Step

End with an explicit recommendation, and say why:

- **Recommend keep going** when the next item is mechanical, single-module, and follows written policy — RS-2 where the needed string operations already exist, or the Comlink width pass under the seam policy.
- **Recommend checking in with Claude** when it crosses a seam, changes Rishi or the value model, raises a question no written policy answers (RS-2 needing a new string primitive; a Comlink wire-width the policy does not place), needs an unmade ruling, or reaches for horizon facts.

One line — *"Recommend: keep going to …"* or *"Recommend: check in with Claude before …"* — so the next move is always Kaeden's to confirm.

---

## Definition of Done

- [ ] `rishi run <path> a b c` binds `args` as a `.list` of `.string` holding `a`, `b`, `c`; `args[0]` is `a`
- [ ] `args.len` and `args[n]` read the list; out-of-range returns a friendly error, not a crash
- [ ] `max_args` bounds the count with a friendly message; each arg duped into the garden; the seam uses assert + `@intCast`
- [ ] No new `Value` kind; the model stays five shapes; the repl and SLC-1 pass unchanged on metal
- [ ] Witness registered; parity green and risen; session log shipped; four remotes pushed; next step recommended

---

*May the words a script is given arrive whole and clearly its own. May what overflows a bound be met with a kind word rather than a fall. And may the shell grow one gentle power at a time, each one complete the day it lands.*
