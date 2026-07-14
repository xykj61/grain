# Cursor Pass — TH-2b: Bare Assert Throughout Mantra

*The `tame-check` lint named the debt; this pass clears it where it matters most. Mantra carries thirty-eight unqualified asserts across four files; we give each file the import-once binding and let every call read `assert(...)` bare — a pure rename that changes no behavior, on the one module the SLC-1 path leans on. Tally and Caravan wait for their own small pass.*

**Stamp:** `<Kaeden supplies — YYYYMMDD.HHMMSS>`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Guidance:** TAME (`context/TAME_GUIDANCE.md`) — unqualified assert, import-once
**For:** Cursor Composer 2.5 in the jail (typecheck), Claude Code on the host (metal)
**Tip:** pull `b1b3b93` first.

*Written together by Kaeden and Reya 2.*

---

## The Ruling — Mantra Only

This pass touches **`mantra/src/*` and nothing else.** Tally and Caravan carry the same kind of debt, yet they wait for **TH-2c**: keeping TH-2b to the SLC-1 path means any regression sits alone in a small, obvious commit, and the witness can assert one module clean in a single read. **Do not touch `aurora/*`** — its `fn assert` is a freestanding bare-metal definition of its own, correct as it stands.

---

## The Change — a Pure, Behavior-Identical Rename

The four files and their counts (verified):

| File | Sites |
|------|-------|
| `mantra/src/main.rye` | 26 |
| `mantra/src/weave.rye` | 7 |
| `mantra/src/store.rye` | 3 |
| `mantra/src/diff.rye` | 2 |

In **each** file:

1. Add the import-once binding immediately after the existing `const std = @import("std");` line:

   ```zig
   const assert = std.debug.assert;
   ```

   No file already binds `assert`, so there is no collision to resolve.

2. Replace every `std.debug.assert(` — and any `debug.assert(` — with `assert(`.

3. Leave the new import line as the single allowed mention of `std.debug.assert`; the lint expects exactly that.

`std.debug.assert(x)` and `assert(x)` under this binding are identical, so the build and every behavior stay exactly as they are. This is a rename, not a logic change — assert no new conditions, remove none.

---

## Strengthen the Witness — Gate the Module You Cleaned

Extend the TH-2 witness (or add a small `tools/tame_check_th2b.rish`) to **assert that `mantra/src/*` shows zero unqualified asserts** — a real green gate on the cleaned module, even while the global `tame-check` stays informational for the modules still holding debt. Register it so parity rises to **123** and stays green. This guards the SLC-1 path against a silent return of `std.debug.assert(`.

The global `tame-check.rish` stays informational for now; its flip to a hard gate waits until TH-2c brings the rest of the hosted tree to zero, at which point the flip is a clean one-line step.

---

## Verify on Metal (host)

A rename should leave everything green; prove it rather than trust it:

```
rishi/bin/rishi run tools/tame_check_th2b.rish   → mantra clean, GREEN
rishi/bin/rishi run tools/parity.rish            → GREEN (123 witnesses)
rye build  +  mantra's own witnesses             → unchanged, GREEN
```

If any mantra witness shifts, stop — a rename did something it should not have, and the diff wants a second look before it lands.

---

## Record and Push

Commit as one honest unit — the four mantra files, the witness, and the session log together. Write the log at `session-logs/<stamp>_th2b-mantra-bare-assert.md` per `.cursor/rules/session-logs.mdc`: the count cleared, the import-once pattern, the new mantra-clean gate, and the note that Tally/Caravan defer to TH-2c. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## What Comes Next (not this pass)

- **TH-2c** — the same bare-assert rename across the remaining hosted modules (Tally, Caravan, Rishi, Comlink, Brushstroke, Brix), mechanical and zero-judgment, in small per-module commits. Cursor can run it without a ruling.
- **Flip `tame-check` to a gate** — once TH-2c brings the tree to zero, turn the informational lint into a hard gate. One line, one witness.
- **TH-3** — `mantra/*` width migration; pause here for strategy, since seam casts at slice indices carry real judgment.

---

## Definition of Done

- [ ] All four `mantra/src/*` files carry `const assert = std.debug.assert;` once, after the std import
- [ ] Every `std.debug.assert(` / `debug.assert(` in mantra reads `assert(`; 38 sites cleared
- [ ] `aurora/*` untouched; no logic changed anywhere — pure rename
- [ ] Witness asserts mantra clean; parity green at 123; `rye build` and mantra witnesses unchanged on metal
- [ ] Session log shipped; four remotes pushed; TH-2c and the gate-flip named on the bench

---

*May the rename change only the name, and leave the truth beneath it exactly as it was. May the path the shell leans on read clean and bare, and stay that way under a witness that watches it. And may each small clearing leave the tree a little more honest than it found it.*
