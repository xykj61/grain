# GRASS -- `linengrow/setu_desk_hold1_check.rye` account (shelved)

**Status:** Landed, shelved whole per [`the-writer-sheds`](../../../../.claude/rules/the-writer-sheds.md).
**Shelved:** `20260918.095829`

`linengrow/setu_desk_hold1_check.rye` NAMES THE SAME READ-BOUND INVARIANTS as the hold0 repair one
row before it: `file_len` and `run_check` each read into a fixed buffer -- `[1024]u8`, `[1024]u8`,
`[hold1.chrome_line_max]u8` (x2) -- and nothing stated that the read or either formatted line
actually stays inside the buffer it was drawn from. `file_len` now asserts its path is non-empty and
its read length never exceeds the 1024-byte buffer; `run_check` asserts the station read stays
inside `station_buf`, and the two formatted lines (`chrome`, `detail`) each stay inside their own
buffers. `tools/s/setu_desk_hold1_witness.rish` GREEN unchanged (device-free fixture leg, no station
cache); `width-check` clean; `tame_style_check`'s zero-assert ratchet fell 3 to 2, dropping this
file off the remaining list. No claim opened: an ordinary repair to one existing tracked file, named
by no ledger row.

Next agent-doable pick named at close: either `linengrow/setu65_lab_tx_check.rye` or
`linengrow/setu_desk_hold_wayland_check.rye` -- both were taken up in the following lap.
