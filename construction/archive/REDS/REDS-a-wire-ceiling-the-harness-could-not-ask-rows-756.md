# REDS -- a wire ceiling the harness could not ask

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one folded row, immutable once written
**Room:** checkable -- the repair is proven by four witnesses on metal
**Folded:** `20261001.132612` from [`../REDS.md`](../../REDS.md)

One row, folded the moment its repair landed. It teaches that a derived ceiling and the check that
enforces it must arrive together: shrinking a constant the encoder never checks would have made the
declared hit count promise what the bytes could not keep.


**REDS %756 (`20260916.004153`) -- a wire ceiling was corrected, and the harness measuring it had been publishing an answer shape the wire could never carry.** *What went wrong:* `comlink/query_wire_retention_cost.rye` declares `measured_hit_count` as the literal 4 and slices `kept_store[0..measured_hit_count]` out of an array sized `qw.max_wire_hits`. `0d6e6829a` made that ceiling derived -- `(max_wire_payload - response_head_bytes) / max_hit_bytes` -- where it had been the literal 8, and it reads **2**, so the harness refuses to compile and `query_wire_retention` reads red on every ship. *What caught it:* the hot endurance run, `query_wire_retention red`, whose own line named the slice bound rather than the seam. *What it taught:* **the derived 2 is the correct number, and the elder 8 was never consistent with the 340-byte payload beside it.** Nothing tied the pair until that commit added `assert(response_head_bytes + max_wire_hits * max_hit_bytes <= max_wire_payload)`; an eight-hit answer at today's field sizes needs 954 bytes. So every retention figure this harness has published names a four-hit answer the wire could not hold, and the compile error is the first instrument that ever asked. *And no clamp repairs it*, which is the sharper half: the comparison measures the unused tail a variable-length answer leaves behind, so the count must sit strictly below the ceiling -- at 2 it reads `kept=128 fixed=120` and the control's own leg refuses in words, *the variable form must hold fewer bytes below the ceiling*. Below that, at 1, `r % measured_hit_count` folds to a constant index and the compiler hoists all three measurement loops: each read retired **6** instructions against the 20,000 its control requires. Both together need `max_wire_hits >= 3`. *What holds this still:* a `@compileError` in the harness naming the floor, the cause, and the three doors -- grow `max_wire_payload`, shrink `max_peer`/`max_bolt`/`max_path`, or retire the measurement. The guard still reds, and it reds legibly now rather than on a slice bound. **BOOKED** -- repaired `20261001` through the shrink door on Keaton's word: the wire's `max_path` is 57, one hit is 112 bytes, three fit the 340-byte payload, and `query_wire_retention` reads GREEN on metal.
