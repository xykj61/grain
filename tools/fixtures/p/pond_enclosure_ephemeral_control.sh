#!/bin/sh
# tools/fixtures/p/pond_enclosure_ephemeral_control.sh -- proves the forgetting seam on planted trees.
#
# WHY A CONTROL. The scan it drives reports `unforgotten_claims=0` on the living tree, and a zero is
# the one reading that cannot tell a working guard from a guard reading nothing (REDS %285 is the
# whole argument). So every reading below is shown from BOTH sides: the shape that must refuse is
# planted and watched to refuse, and the shape that must pass free is planted beside it and watched
# to pass. A refusal proven only in the passing direction cannot be told from a bypass.
#
# Each pen is a throwaway directory holding a record, a plan, and a copy of the sibling scan the
# reading is lifted from, handed to the scan with --root and --plan. No case passes --probe, so the
# gate is proven WITHOUT a jail installed -- which is the state of every clone this guard works on.
#
# WHAT THIS CONTROL DOES NOT REACH. The probe itself, which starts a real enclosure: a pen cannot
# convincingly fake a kernel, and faking one would prove the fake. tools/p/pond_enclosure_ephemeral_witness.rish
# runs the probe on metal where ai-jail stands, and says so plainly when it cannot.
#
# USAGE
#   sh tools/fixtures/p/pond_enclosure_ephemeral_control.sh
#
# Driven by tools/p/pond_enclosure_ephemeral_witness.rish. Run from the repository root.
set -u

HERE=$(CDPATH= cd "$(dirname "$0")" && pwd)
SCAN=$HERE/pond_enclosure_ephemeral_scan.sh
SIBLING=$HERE/pond_enclosure_built_scan.sh
[ -f "$SCAN" ] || { echo "control_verdict=scan_absent" >&2; exit 1; }
[ -f "$SIBLING" ] || { echo "control_verdict=sibling_absent" >&2; exit 1; }

pen_root=$(mktemp -d)
trap 'rm -rf "$pen_root"' EXIT INT TERM

fails=0
note() { echo "$1"; }
want() { # want <name> <expected ok|refuse> <actual exit>
  if [ "$2" = "ok" ] && [ "$3" -eq 0 ]; then note "$1=yes"; return; fi
  if [ "$2" = "refuse" ] && [ "$3" -ne 0 ]; then note "$1=yes"; return; fi
  note "$1=no"; fails=$((fails + 1))
}
saw() { # saw <name> <pen> <string that must appear in the scan output>
  if grep -qF "$3" "$2/.out"; then note "$1=yes"; else note "$1=no"; fails=$((fails + 1)); fi
}

new_pen() { # new_pen <name> -- a record, an empty plan, and the sibling this scan lifts from
  p=$pen_root/$1
  mkdir -p "$p/pond" "$p/tools/fixtures/p"
  cp "$SIBLING" "$p/tools/fixtures/p/pond_enclosure_built_scan.sh"
  printf 'format pond-enclosure-policy-v1\nname pen\n' > "$p/pond/enclosure_policy.kyri"
  printf 'format pond-enclosure-default-plan-v1\nmeasured 20260101.000000\nhost pen\njail pen\nflags none\n' > "$p/plan.kyri"
  echo "$p"
}
declare_line() { printf '%s\n' "$2" >> "$1/pond/enclosure_policy.kyri"; }
plan_line() { printf '%s\n' "$2" >> "$1/plan.kyri"; }
run_scan() { sh "$SCAN" --root "$1" --plan "$1/plan.kyri" >"$1/.out" 2>"$1/.err"; echo $?; }

# ---- Reading one, the gate: a path the record says dissolves, which the plan keeps.
pen=$(new_pen unforgotten)
plan_line "$pen" 'ro-bind /tmp /tmp'
declare_line "$pen" 'ephemeral /tmp'
want unforgotten_claim_refused refuse "$(run_scan "$pen")"
saw unforgotten_claim_named "$pen" 'detail: the record declares `ephemeral /tmp` and the plan builds no dissolving mount there'
saw unforgotten_verdict_named "$pen" 'verdict=unforgotten'

printf 'format pond-enclosure-default-plan-v1\nmeasured 20260101.000000\nhost pen\njail pen\nflags none\ntmpfs /tmp\n' > "$pen/plan.kyri"
want forgotten_claim_passes ok "$(run_scan "$pen")"
saw forgotten_claim_counted "$pen" 'unforgotten_claims=0'

# ---- Reading two: the lifetime table, each row shown by the answer it must give and the one it
# must not. A wrong lifetime here would say the opposite thing about what the enclosure keeps.
lifetime_case() { # lifetime_case <name> <plan row> <expected counter line>
  pen=$(new_pen "$1")
  plan_line "$pen" "$2"
  want "$1_reads" ok "$(run_scan "$pen")"
  saw "$1_classified" "$pen" "$3"
}
lifetime_case tmpfs_dissolves    'tmpfs /tmp'                   'dissolves=1'
lifetime_case dev_dissolves      'dev /dev'                     'dissolves=1'
lifetime_case proc_dissolves     'proc /proc'                   'dissolves=1'
lifetime_case ro_bind_keeps_none 'ro-bind /usr /usr'            'survives_outside_pier=0'
lifetime_case bind_survives      'bind /a /b'                   'survives_outside_pier=1'
lifetime_case dev_bind_survives  'dev-bind /dev/shm /dev/shm'   'survives_outside_pier=1'
saw ro_bind_counted_readonly "$pen_root/ro_bind_keeps_none" 'readonly_rows=1'
saw tmpfs_keeps_nothing "$pen_root/tmpfs_dissolves" 'survives_outside_pier=0'

# ---- Reading three: the pier split. The same surviving bind is lawful under a declared persist
# root and a hole outside it, so the record's own `persist` line is what decides.
pen=$(new_pen pier_split)
plan_line "$pen" 'bind /home/youruser/grain/loops/claude /home/youruser/.claude'
declare_line "$pen" 'persist /home/youruser/grain'
want pier_survivor_passes ok "$(run_scan "$pen")"
saw pier_survivor_in_pier "$pen" 'survives_in_pier=1 survives_outside_pier=0'

printf 'format pond-enclosure-policy-v1\nname pen\npersist /home/otherplace\n' > "$pen/pond/enclosure_policy.kyri"
want outside_survivor_still_passes ok "$(run_scan "$pen")"
saw outside_survivor_counted "$pen" 'survives_in_pier=0 survives_outside_pier=1'
saw outside_survivor_named "$pen" 'is writable and outlives the enclosure at'

# ---- Reading four: the ceiling, proven from both sides, so no override exists and none is wanted.
pen=$(new_pen ceiling)
plan_line "$pen" 'dev-bind /dev/shm /dev/shm'
plan_line "$pen" 'bind /tmp/.X11-unix /tmp/.X11-unix'
plan_line "$pen" 'bind /run/user/<uid> /run/user/<uid>'
want ceiling_at_bound_passes ok "$(run_scan "$pen")"
saw ceiling_at_bound_counted "$pen" 'survives_outside_pier=3 ceiling=3'
plan_line "$pen" 'bind /var/lib/somewhere /var/lib/somewhere'
want ceiling_one_past_refuses refuse "$(run_scan "$pen")"
saw ceiling_verdict_named "$pen" 'verdict=over_ceiling'

# ---- Reading five: a hole inside a forgetting subtree is reported and never gated, since the
# record naming it separately is the honest state rather than a fault.
pen=$(new_pen pierced)
plan_line "$pen" 'tmpfs /tmp'
plan_line "$pen" 'bind /tmp/.X11-unix /tmp/.X11-unix'
declare_line "$pen" 'ephemeral /tmp'
want pierced_reported_not_gated ok "$(run_scan "$pen")"
saw pierced_counted "$pen" 'pierced_forgetting=1'
saw pierced_named "$pen" 'outlives the close inside `ephemeral /tmp`'

printf 'format pond-enclosure-policy-v1\nname pen\n' > "$pen/pond/enclosure_policy.kyri"
want unclaimed_subtree_passes ok "$(run_scan "$pen")"
saw pierced_needs_a_claim "$pen" 'pierced_forgetting=0'

# ---- Reading six: the lift refuses rather than guesses. A sibling that no longer publishes the
# tokenizer leaves this scan with no way to read a plan row, and a guess there would be a reading
# nobody could trace.
pen=$(new_pen lift)
plan_line "$pen" 'tmpfs /tmp'
want lift_present_passes ok "$(run_scan "$pen")"
printf '#!/bin/sh\necho no plan reader here\n' > "$pen/tools/fixtures/p/pond_enclosure_built_scan.sh"
want lift_absent_refuses refuse "$(run_scan "$pen")"
saw lift_absent_named "$pen" 'no longer publishes plan_rows() and normalize()'
rm -f "$pen/tools/fixtures/p/pond_enclosure_built_scan.sh"
want sibling_absent_refuses refuse "$(run_scan "$pen")"

# ---- Reading seven: the bounds, from both sides. A plan that grew past the roster is refused
# before it is read rather than counted quietly.
pen=$(new_pen bounds)
i=0
while [ "$i" -lt 64 ]; do plan_line "$pen" "tmpfs /pen/$i"; i=$((i + 1)); done
want plan_at_max_rows_passes ok "$(run_scan "$pen")"
saw plan_at_max_rows_counted "$pen" 'plan_rows=64 max_rows=64'
plan_line "$pen" 'tmpfs /pen/64'
want plan_past_max_rows_refuses refuse "$(run_scan "$pen")"
saw plan_past_max_rows_named "$pen" 'verdict=unbounded'

pen=$(new_pen empty_plan)
want empty_plan_refuses refuse "$(run_scan "$pen")"
saw empty_plan_named "$pen" 'the pinned plan carries no mount rows'

# ---- Reading eight: an absent half is named rather than guessed at.
pen=$(new_pen no_record)
plan_line "$pen" 'tmpfs /tmp'
rm -f "$pen/pond/enclosure_policy.kyri"
want absent_record_refuses refuse "$(run_scan "$pen")"
saw absent_record_named "$pen" 'detail=no_policy'

# ---- Reading nine: the probe stays opt-in. An ordinary run starts no enclosure and says so in its
# own counters, which is what lets this guard ride the roster every lap.
pen=$(new_pen no_probe)
plan_line "$pen" 'tmpfs /tmp'
want ordinary_run_passes ok "$(run_scan "$pen")"
saw probe_absent_by_default "$pen" 'probe_read=no probe_planted=0 probe_refused=0'

echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=failed"; exit 1
