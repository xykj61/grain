# REDS %688 -- the store's ceiling counts bytes and the weave's counts lines

*Folded from the living pin [`../REDS.md`](../REDS.md) on the lap after the one that booked it. The
pin stood at 40,948 of the 40,960 its own header declares -- **twelve bytes of headroom** -- so no
row could land beside it at all. A row closed on metal folds rather than holding a ledger shut,
which is the move `%681` made one shelf over.*

*The clause worth carrying forward. Two ceilings standing on two units are ONE ceiling only where
somebody wrote the conversion down. `store.rye` bounds a blob in bytes and refuses at the edge;
`weave.rye` bounds a weave in lines and refuses by name. Between them a reader appended every row of
a record off disk and read its ceiling afterwards, and the arithmetic nobody had taken -- nine bytes
a row -- says a blob standing UNDER the store's own ceiling carries fourteen times the lines a weave
may hold.*

*What made it a red rather than a rough edge: the file already knew the move. `read_commit_v2`, sixty
lines below the reader this repaired, refuses inside its own loop before appending. One file, two
readers, two answers -- so the repair was to make the file agree with itself rather than to invent a
rule.*

*Kin, and the reason this family keeps firing in one room: `%678` names the same shape one wire over
-- a count that bounds a variable-length thing bounds nothing. `20260910.043900` is the third, and
its unit is the byte a document ends with.*

---


**REDS %688 (`20260910.034822`) -- the store's ceiling counts BYTES and the weave's counts LINES, and nobody wrote the conversion down.** *What went wrong:* `mantra/src/store.rye` bounds a blob at `max_blob_bytes` (1 << 27) and refuses at the edge, before the allocation grows -- its own head note states that principle. `mantra/src/weave.rye` bounds a weave at `max_weave_lines` (1 << 20) and `Weave.from_v2` refuses `WeaveError.TooManyLines` by name. Between them, `read_v2_record` in `mantra/src/main.rye` appended every row of a record off disk and read the ceiling AFTERWARDS, with an `assert`. A v2 row costs nine bytes at its shortest, so a blob under the store's own ceiling carries **14,913,080** rows against the 1,048,576 a weave may hold. *What caught it:* an air lap walking the fence line, then a plant on metal -- a **15,666,516-byte** blob, an eighth of the store's ceiling, made `mantra status` panic at exit **134** after allocating all 1,048,600 rows. The named refusal never arrived, and without safety checks the assert is a no-op while the memory is spent either way. *What it taught:* **two ceilings on two units are one ceiling only where somebody wrote the conversion down** -- and the file already knew the move: `read_commit_v2`, sixty lines below, refuses `error.TooManyFiles` inside its own loop before appending. Two readers, one file, two answers. *Kin:* `%678`, one room over -- a second firing of *a count that bounds a variable-length thing bounds nothing*. *Repaired:* both weave readers refuse `weave.WeaveError.TooManyLines` inside the loop before the row is parsed, so a record off disk allocates at most `max_weave_lines` rows; the trailing asserts stay as postconditions holding by construction. The planted store now reads exit 1. *Proven:* `tools/m/mantra_record_ceiling_witness.rish` builds the same reader at ceilings of 16 and 8 and has the wide binary WRITE the stores the narrow one reads, so no store is forged. Thirteen readings, four phases, three breaks, one of them a fence biting a row early. **CLOSED.**
