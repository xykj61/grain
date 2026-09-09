# REDS shelf -- a success report has no ceiling, and its refusal does

**Language:** EN
**Status:** Shelf -- immutable once written
**Voice:** Kyri
**Rows:** `%648`
**Folded:** `20260908.010000`

One row, and it is about which half of a guard the language protects.

Rishi composes an interpolated string literal through a bounded 4,096-byte `StrBuf` and refuses
past it; a bare `say <value>` writes the value straight out under no ceiling. An
`assert ... else` message that overflows falls back to its raw literal rather than ending the run.
So the **refusal** path degrades gracefully and the **reporting** path dies -- and the reporting
path is the one that fires when everything is right, on a reading that grows as the tree it reads
grows. `reds_spine_derive_witness.rish` passed both its gates on a clean tree and then died
printing that it had passed, and eight ships paid that red every lap.

The cure is two lines. What earns a shelf is the second move: the class was **counted** rather than
left to the next growth, and counted narrowly -- 38 sites across 26 files that compose a
*verdict-bearing* capture, narrowed from 504 sites that compose any capture at all, because the
other 466 hold a probe's one line and would be pushed toward worse prose for nothing. A ratchet,
never a gate: every site is correct today and fails only when its own reading grows.

The row also records a repair that became a peer's. Two ships found one fault the same evening;
theirs landed first and landed better, printing the reading *before* the assert so a genuine
disagreement is explained too. This shelf keeps the census and the guard, and says plainly which
half withdrew.

---


**REDS %648 (`20260907.233349`) -- a guard passed both its gates and then died printing that it had passed, so eight ships paid a red every lap for a green reading.** *What went wrong:* Rishi composes an interpolated string literal through `StrBuf`, a bounded 4,096-byte buffer in `rishi/src/main.rye`, and refuses `StringTooLong` past it; a bare `say <value>` writes the value straight out under no ceiling at all. `tools/r/reds_spine_derive_witness.rish` read this tree, passed **both** of its assertions -- `verdict=ok`, `rebindings=0`, `published_doubles=2` -- and then ended the run at `say "reds-spine-derive: the reading on this tree --\n${scan.out}"`. The reading had grown to **4,250 bytes** as the ledger grew, so the seven-word label wrapped around it is what put the composition over. The failure named the guard's own reporting line, so the roster read `reds_spine_derive red` while the reading underneath it said the tree was clean -- and the fleet's collision instrument, the one thing standing between eight writers and a double-bound row number, reported nothing at all. *What caught it:* this lap's cold roster open, `guards_red=6`, and then running the scan alone rather than trusting the guard's verdict: `verdict=ok` on a guard that had just reddened. *What it taught:* **Rishi already protects the refusal path and not the reporting one, and that asymmetry is deliberate.** An `assert ... else` message that overflows falls back to its raw literal -- `interpolate(...) catch return text` -- so a refusal degrades to unexpanded text rather than ending the run. A `say` has no fallback. The protected path is the one that fires when something is wrong; the unprotected path is the one that fires when everything is right, and **a success report is exactly what grows without bound as the tree it reads grows**. *Repaired, and the repair is a peer's:* the cure -- label on its own `say`, reading on a bare one -- was written here and parked, and a peer reached the same fault and landed it first as `%597`, in a **stronger** form: they print the reading **before** the assert rather than after it, so a real disagreement is explained too, where this draft would still have refused in silence on the path that matters most. That half withdrew whole; what stands from this lap is the census and the guard. **The class is now measured rather than left to the next growth:** `tools/r/rish_report_bound_witness.rish` over `tools/fixtures/r/rish_report_bound_scan.sh` counts a tracked `.rish` composing a **verdict-bearing** capture into a `say`, ratchet **38 sites across 26 files**, ceiling only falls. Narrowed from **504 sites across 467 files** that interpolate some captured output by requiring the file to read the same capture with `contains`: almost all the rest hold a probe's one line, and counting them would push 466 files toward worse prose to reach the 26 that carry the hazard. Never a gate -- every site is correct today and fails only when its own reading grows, so a gate would refuse ordinary work. **The three claims about the interpreter are run rather than read:** `tools/fixtures/r/rish_report_bound_control.sh` proves on metal that an interpolated `say` past the buffer refuses and stops the run, that a bare `say` carries the same bytes to the end, and that an oversized assert message falls back instead of dying -- **15 behaviors, every plant lifted**. *Declined, and named so the door is not merely forgotten:* giving `say` the assert's own fallback in `main.rye` is one line, and it would print a literal `${scan.out}` where a reading belongs. A loud failure beats a quietly wrong report; what was wrong is only that the failure landed on the guard rather than on the hand. **CLOSED**

*Renumbered `%600` -> `%648` on `20260908.191521`, and the shelf renamed with it. The row was booked from a local read while this lap sat parked in a round-open stash; by the time it landed the anointed spine had spent `%600` on another stamp, so `reds_spine_derive` read it as a squatter and named the repair -- derive above the anointed spine's own head, twice in one round as peers published between. The key is the stamp `20260907.233349`, which has not moved; the number is a view, and this is the view being reallocated exactly as [`the derived spine`](../../.claude/rules/derived-spine.md) prescribes for an unshared row.*
