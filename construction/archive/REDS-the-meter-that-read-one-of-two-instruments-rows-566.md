# REDS shelf -- the meter that read one of two instruments, row %566

**Language:** EN
**Stamp:** `20260907.122532`
**Status:** Shelf -- immutable once written
**Rows:** `%566` -- folded from [`../REDS.md`](../REDS.md) on `20260907.122532`
**Voice:** Kyri

`tools/fixtures/g/glow_desk_reach_scan.sh` asks one question -- *does anything in this tree run this
desk?* -- and for one lap it answered from one of the two instruments that run desks. The derived
runner landed and was rostered at `20260907.110022`; the reach reading was not widened in the same
round, so it went on printing `uncovered_bare=83` under the sentence *bare-runnable desks are run by
nothing* while a guard on the standing roster ran all eighty-three of them.

The braid this meter exists to untangle was three hand-written statements of one run-contract, none
derived from any other. Adding a fourth statement -- a *derived* one this time, which is the good
kind -- without teaching the meter to read it re-tied the same knot one turn out, with the meter
itself now the enumeration that had drifted.

**A reading widens when the thing it reads about gains a second source, and the lap that adds the
source is the lap that owes the widening.** The repair asks the runner for its own selection with
`--list` rather than deriving it a second time here, because a second derivation would have been a
fifth statement of the contract rather than a reading of the fourth.

What changed with the number is the reading's character. `uncovered_bare` fell from a ratchet of 83
to a gate at zero, and it no longer counts a backlog: it counts a desk *nothing* runs, which makes
it the gate on two derivations agreeing. This scan excludes by the markers' intersection and the
runner by their union, so a half-declared desk reds here and at `norun_disagree` together -- the
truth said twice rather than once.

**REDS %566 (`20260907.122532`) -- a meter reported eighty-three desks run by nothing while a rostered guard ran all eighty-three.** *What went wrong:* `tools/fixtures/g/glow_desk_reach_scan.sh` asks *does anything run this desk* and derived its answer, `covered`, from one grep over `tools/g/glow_run_desk_witness.rish` -- the elder hand-written witness. `tools/fixtures/g/glow_desk_run_scan.sh` landed and was rostered `20260907.110022`; it derives the bare-runnable set from the room on every pass and runs **301** desks. For one lap the reach scan went on printing `covered=218` and `uncovered_bare=83`, under the sentence *bare-runnable desks are run by nothing*, while those same 83 were run by a guard on the standing roster. Two instruments, one population, two answers. *What caught it:* the previous lap's own `recommend` line named it as the seam it was leaving -- the runner shipped and the reach reading was not widened in the same round. *What it taught:* **a reading widens when the thing it reads about gains a second source, and the lap that adds the source is the lap that owes the widening.** The braid this meter was built to untangle was three hand-written statements of one contract; adding a fourth *derived* statement without teaching the meter to read it re-tied the same knot one turn further out, with the meter itself now the enumeration that had drifted. *Repaired (`20260907.122532`):* `covered` is the union of `covered_witness` and `covered_runner`, the runner asked for its own selection with `--list` rather than re-derived -- a second derivation here would have been a fifth statement of the contract. The parts stay printed so the elder witness's drift is still visible beside the union. `uncovered_bare` **fell from a ratchet of 83 to a gate at zero**, and its character changed with its number: it counts a desk *nothing* runs, which is the gate on two derivations agreeing. This scan excludes by the markers' INTERSECTION and the runner by their UNION, so a half-declared desk reds here and at `norun_disagree` together. A runner that cannot answer `--list` refuses the whole reading, since an empty selection and a broken instrument look identical in the arithmetic and mean opposite things. `glow_desk_reach_control.sh` proves **81 behaviors** (was 60), the union shown from every side -- each instrument alone, both together with no double count, a runner smuggling a phantom or a declared-unrunnable desk refused, and the real runner against the real derivation. The bare gate's refusal is proven on the live tree by muting the runner, which reproduces exactly the reading of one lap ago. **BOOKED.**
