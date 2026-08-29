#!/bin/sh
# Append Glow almanac seat 121 from e117 fork EXTEND + breach let-close -- ch8 9/16.
# Data-in-stub since 20260829; the one body is almanac_engine.sh beside this file.
exec sh "$(dirname "$0")/almanac_engine.sh" <<'DATA'
seat 121
print almanac seat 121 appended · chapter eight 9/16
bump ## Chapter Eight (8 of 16)|## Chapter Eight (9 of 16)
entry ### 121. Equinox e117 fork EXTEND + breach let-close: Keaton's word (fuse kg approving all breaches forks recommendations) seats THE FORK as EXTEND +128 with nested return_surface_p59 held not consumed; seats THE BREACH as let close — census_breach_count=0 banked approval closed unspent; roof reconciliation already e116; geode stays APPROVED GATED; shred RED; seat 128 stays reserved; surface census four kept.
entry **Ran:** `sh tools/fixtures/e/equinox_e117_fork_extend_breach_close_scan.sh` · **Stamp:** `{STAMP}` · **Witness:** `tools/equinox/witness/equinox_e117_fork_extend_breach_close_witness.rish` · counsel `counsel/date/20260731/20260731-170354_e117-fork-extend-breach-let-close.md` · scan `tools/fixtures/e/equinox_e117_fork_extend_breach_close_scan.sh`
entry Expected control_gate · instruments_tracked · fork_word=EXTEND · handback_status=not_consumed · breach_status=closed_unspent · geode APPROVED_GATED · seat_128 reserved · surface_count=4 · prove-red RED_approve_all_consumed_handback · roof e116 kept · shelf end ep045 · baton breach 0. Approve-all seats recommended yes/no leans; hard lines still refuse shred. Metal answered GREEN. Invent none.
DATA
