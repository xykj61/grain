# REDS -- the gate that guarded nothing (row %249)

**Language:** EN
**Status:** Shelf -- immutable once written
**Voice:** Kyri
**Folded:** `20260826.070513` from [`../REDS.md`](../REDS.md), **CLOSED**.

One row, and it is the whole shell-dialect story in a single reading. A guard held a population at
zero and enforced it, on a host where the pipeline underneath had been yielding nothing all along --
so the zero it enforced was its own silence rather than the tree's health. The repair is
[`../../tools/fixtures/shell_portable.sh`](../../tools/fixtures/shell_portable.sh), and the proof is
that the same witness fails at its line 53 with the elder spelling and reads GREEN with the new one.
Row %250 stays flat on the pin, narrowed to the `date -d` family this repair did not reach.

---

**REDS %249 (`20260826.014404`) -- the exec-bit control cannot see its own planted caller on this host.** *What went wrong:* `tools/fixtures/exec_bit_control.sh` plants a repository whose tracked file invokes `./x` in command position and expects `invoked_seen=yes` from the scan; on this macOS bench it reads `invoked_seen=no`, so `tools/e/exec_bit_witness.rish` refuses at line 53. Proven pre-existing: the same reading at committed HEAD in a clean worktree, before the panchanga molt touched a byte. *What caught it:* the molt round's spot-witness pass, which ran the witness on a host that had never run it. *What it taught:* a control proven on one host's shell dialect is proven on one host -- the BSD-versus-GNU family %226 and %211 already name, now in the control that guards the guard. The repair -- a dialect-safe reading in `tools/fixtures/exec_bit_scan.sh` or its control -- is its own lap on this bench. *Repaired* `20260826.062128` **on this pier, proven from both sides on metal.** The root was `tools/fixtures/exec_bit_scan.sh` line 74, `xargs -a "$work/living.txt" -d '\n' -n 400`, which BSD xargs refuses outright: the pipeline yields nothing, `invoked.txt` stays empty, and `directly_invoked` reads **0** where GNU reads **18** -- with `verdict=ok` printed both times, so the reading the guard *enforces* at zero, `directly_invoked_not_exec`, had nothing to enforce over. That site and eleven others moved to two functions in [`../tools/fixtures/shell_portable.sh`](../tools/fixtures/shell_portable.sh). Proven by running `tools/e/exec_bit_witness.rish` under an `xargs` that refuses `-a` and `-d` exactly as BSD's does: with the elder spelling it fails at **line 53** on `invoked_seen=yes` -- the very assertion this row reports from the macOS bench -- and with the repair it reads GREEN. **CLOSED.** *Renumbered:* booked as `%233` on the macOS bench and shifted here, because this pier had already spent `%233` at an earlier stamp -- REDS %230's own rule, the earlier row keeps the number (%252).

