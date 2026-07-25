# Cursor Pass — SLC-1 Acceptance: The Four Verbs, Proven Together

*The closing ritual for the first ring. One scripted session runs type, run, version, and recall end to end; the full gate trio confirms the ground; and SLC-1 closes on the promise it actually made. The deferred code-hardening is named honestly as the next milestone, not folded into this close.*

**Stamp:** `20260629.024012`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Discipline:** TAME · [SLC](context/SIMPLE_LOVABLE_COMPLETE.md)
**For:** Cursor Composer 2.5, in the ai-jail sandbox
**Grounding:** scope — [`active-designing/20260628-071012_slc-1-rishi-mantra-shell.md`](active-designing/20260628-071012_slc-1-rishi-mantra-shell.md) (acceptance section) · the verbs landed in `rishi/src/main.rye`

*Written together by Kaeden and Reya 2.*

---

## The Scope Ruling (surface, do not assume)

The four-verb loop is functionally complete and green on metal. By the scope note's letter, one acceptance line — *width migration on touched files per `width-check`* — stays unchecked, because `width-check` is still the unrefined substring version that flags the sanctioned seam casts Tally itself uses, and that ruling-#1 refinement was never built (we drove Steps 2–3 straight through instead).

**Recommended:** close SLC-1 on its functional promise with the acceptance ritual below, and open a short **TAME-hardening milestone** next — width-check refinement (ruling #1, already approved), then `mantra/*` Phase 1b, the `rishi/*` width pass, the first `tame-check` lints, and the `.brix` dead-path mend. The loop is what SLC-1 promised; the hardening is real and separable, and it deserves its own clean pass rather than swelling this close.

**Kaeden rules:** close now on the functional promise (recommended), or fold the hardening into SLC-1's close first? This pass builds the ritual either way; the ruling decides whether SLC-1 is declared finished at its end.

*(Note: the `.brix` dead paths and the unrefined width-check do not touch this ritual — `:version` runs `mantra add` on a single named file, never the `.brix` file list, and acceptance gates on parity, the selftest, and the additive gate, not on width-check.)*

---

## How We Build This

Propose, then apply. The witness and fixture are **[sandbox-verifiable]** to write and typecheck-adjacent; running the ritual and the gate trio is **[metal-gated]**, needing the built `rishi` and `mantra`.

---

## The Acceptance Witness

One session, all four verbs. Mirror the Step 2 fixture-shell-script pattern exactly — `:version` touches the store, so an isolated temp cwd and `PATH` are needed, and a shell script keeps the nested quoting out of Rishi's hands.

**`tools/fixtures/slc1_accept.input`** — the four verbs in order:

```
let mark = "ACCEPT-OK"
say "${mark}"
:version
:recall 2
:quit
```

`let mark` is entry 1; `say "${mark}"` is entry 2 and prints `ACCEPT-OK` to stdout; `:version` weaves the session into a fresh `.mantra/`; `:recall 2` re-runs entry 2 and prints `ACCEPT-OK` a second time; `:quit` ends cleanly.

**`tools/fixtures/slc1_accept.sh`** — run isolated, verify all four verbs, echo one green line:

```sh
#!/bin/sh
# SLC-1 acceptance: type, run, version, recall — proven in one session.
set -e
root=$(pwd)
tmpdir=$(mktemp -d)
cd "$tmpdir"
export PATH="$root/rishi/bin:$root/mantra/bin:$PATH"
out=$("$root/rishi/bin/rishi" repl < "$root/tools/fixtures/slc1_accept.input")
# version — the store advanced with a blob:
test -s .mantra/HEAD
test -n "$(ls -A .mantra/blobs 2>/dev/null | head -n1)"
# type + run + recall — ACCEPT-OK printed twice (say, then the recall re-run):
count=$(printf '%s\n' "$out" | grep -c "ACCEPT-OK" || true)
test "$count" -ge 2
echo "GREEN: SLC-1 ACCEPT — type, run, version, recall"
```

**`tools/slc1_accept.rish`** — the witness the suite runs:

```
# slc1_accept.rish — SLC-1 acceptance: the four verbs proven together in one pass.
#
# Run from the repository root:
#   rishi/bin/rishi run tools/slc1_accept.rish

let result = run ["sh" "tools/fixtures/slc1_accept.sh"]

assert result.ok else "SLC-1 acceptance pass exited non-zero"
assert result.out contains "GREEN: SLC-1 ACCEPT" else "the four verbs did not all prove out in one session"
say "GREEN: SLC-1 ACCEPT — type, run, version, recall all breathe on one pass."
```

This proves the verbs **compose**, where the three per-step witnesses prove each in isolation. Keep all four — the step witnesses pinpoint which verb broke, the acceptance witness proves they hold together.

---

## Register and Confirm the Gate Trio

Register the acceptance witness in `tools/parity.rish` beside the three step witnesses — the suite then carries **120**.

Then confirm the full trio green on metal, naming each result:

```
rishi/bin/rishi run tools/parity.rish            # behavior — 120 witnesses, incl. the four SLC-1 verbs
rishi/bin/rishi run tools/parity-selftest.rish   # the pristine-std symlink guard + tamper detection
rishi/bin/rishi run tools/additive-gate.rish     # the structural gate on the last commit's rye/lib changes
```

All three green is the ground confirmed. **[metal-gated]**

---

## Mark SLC-1 Complete (if Kaeden rules to close)

Once the ritual and the trio are green, and if Kaeden rules to close on the functional promise:

- In `work-in-progress/ROADMAP.md`, mark **SLC 1 done** — the four verbs proven together; note the acceptance witness and the 120-count.
- In `work-in-progress/TASKS.md`, check **SLC-1 acceptance**, and open the **TAME-hardening milestone** as the next section: width-check refinement (ruling #1), `mantra/*` Phase 1b, `rishi/*` width pass, first `tame-check` lints, `.brix` mend.
- Note plainly in both that the width/TAME hardening is the next milestone, distinct from SLC-1's functional close — so the record stays honest about what "done" claimed.

---

## Commit, Push, Session Log

Commit as one honest unit — the acceptance witness, the two fixtures, the parity registration, and any roadmap/tasks updates together. Write a session log at `session-logs/<filing-stamp>_slc1-acceptance.md`, coauthored, in Radiant voice: the four verbs proven in one pass, the trio results, the scope ruling and why SLC-1 closes on its functional promise, and the hardening milestone named for next. Push over HTTPS to the usual remotes; Berry on the tip if it pleases you — or a fresh gratitude entry, if closing the first ring earns one.

*(Kaeden: supply the filing stamp verbatim; `20260629.024012` is this pass's mark, re-stamped for the moment it lands.)*

---

## Definition of Done

- [ ] `slc1_accept.input`, `slc1_accept.sh`, and `slc1_accept.rish` exist; the ritual exercises all four verbs in one session
- [ ] The witness proves the store advanced (HEAD + blob) and the recall re-ran (`ACCEPT-OK` twice)
- [ ] Registered in `parity.rish`; the suite carries 120
- [ ] Parity, parity-selftest, and additive-gate all green on metal
- [ ] If Kaeden rules to close: ROADMAP and TASKS mark SLC-1 done and name the TAME-hardening milestone next

---

*May the four verbs prove out together as cleanly as they proved out apart. May the first ring close on exactly the promise it made — no less, and no more. And may what we harden next be its own clean pass, the loop already whole and already loved.*
