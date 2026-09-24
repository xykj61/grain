# GRASS -- `linengrow/setu_desk_hold0_check.rye` account (shelved)

Shelved whole from `construction/ITINERARY.md` at `20260918.093822`, per
[`the-writer-sheds`](../../../../.claude/rules/the-writer-sheds.md).

---

**GRASS -- `linengrow/setu_desk_hold0_check.rye` NAMES TWO READ-BOUND INVARIANTS.** `file_len` and
`run_check` each read into a fixed buffer -- `[1024]u8`, `[1024]u8`, `[status_line_max]u8` -- and
nothing asserted the read or formatted result actually stayed inside the buffer it was drawn from,
which `std.fmt.bufPrint`, `readFile`, and the caller's own logic already guarantee, so the guarantee
was a fact nowhere stated. Three invariant asserts now say so: `file_len` asserts its path is
non-empty and its read length never exceeds the 1024-byte buffer; `run_check` asserts the station
read stays inside its own buffer and the formatted status line stays inside `line_buf`.
`tools/s/setu_desk_hold0_witness.rish` GREEN unchanged (device-free fixture leg); `width-check`
clean; `tame_style_check` zero-assert ratchet falls 4 to 3 -- the file drops off the remaining list.
No claim opened: an ordinary repair to one existing tracked file, named by no ledger row. **YOURS:**
the zero-assert ratchet now names 3 files, all under `linengrow/` -- `setu65_lab_tx_check.rye`,
`setu_desk_hold1_check.rye`, `setu_desk_hold_wayland_check.rye`; the next agent-doable pick is any
of them, claim-board checked first.
