# Shelved account -- GRASS, hold1 repair, and the zero-assert ratchet's close

**Shelved:** `20260918.103223`, folded whole from `construction/ITINERARY.md` under
[`the-writer-sheds`](../../.claude/rules/the-writer-sheds.md). Live card: `construction/ITINERARY.md`.

---

**GRASS -- `linengrow/setu_desk_hold1_check.rye` NAMES THE SAME READ-BOUND INVARIANTS.** Same shape
as the hold0 repair one row above: `file_len` and `run_check` each read into a fixed buffer --
`[1024]u8`, `[1024]u8`, `[hold1.chrome_line_max]u8` (x2) -- and nothing stated that the read or
either formatted line actually stays inside the buffer it was drawn from. `file_len` now asserts its
path is non-empty and its read length never exceeds the 1024-byte buffer; `run_check` asserts the
station read stays inside `station_buf`, and the two formatted lines (`chrome`, `detail`) each stay
inside their own buffers. `tools/s/setu_desk_hold1_witness.rish` GREEN unchanged (device-free
fixture leg, no station cache); `width-check` clean; `tame_style_check`'s zero-assert ratchet falls
3 to 2, dropping this file off the remaining list. No claim opened: an ordinary repair to one
existing tracked file, named by no ledger row.

**What followed, closing the thread this account left open.** A later lap took the ratchet's
remaining two files -- `setu65_lab_tx_check.rye` and `setu_desk_hold_wayland_check.rye` -- to the
same shape, and `tame_style_check`'s zero-assert ratchet fell 2 to **0**; that account is itself
shelved at
[`20260918-101337_itinerary-grass-zero-assert-ratchet-account.md`](20260918-101337_itinerary-grass-zero-assert-ratchet-account.md).
This account was left standing live on the card past that point -- a writer-sheds gap rather than
open work -- and is shelved now rather than repaired in place, since nothing in its own text was
wrong.
