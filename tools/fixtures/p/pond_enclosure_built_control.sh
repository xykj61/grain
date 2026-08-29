#!/bin/sh
# tools/fixtures/p/pond_enclosure_built_control.sh -- proves the built-plan seam on planted trees.
#
# WHY A CONTROL. The scan it drives reports `undeclared_builds=0` on the living tree, and a zero is
# the one reading that cannot tell a working guard from a guard reading nothing (REDS %285 is the
# whole argument). So every reading below is shown from BOTH sides: the shape that must refuse is
# planted and watched to refuse, and the shape that must pass free is planted beside it and watched
# to pass. A refusal proven only in the passing direction cannot be told from a bypass.
#
# Each pen is a throwaway directory holding a record and a plan, handed to the scan with --root and
# --plan. Every case runs --no-live, so the gate is proven WITHOUT a jail installed -- which is the
# state of every clone this guard has to work on.
#
# USAGE
#   sh tools/fixtures/p/pond_enclosure_built_control.sh
#
# Driven by tools/p/pond_enclosure_built_witness.rish. Run from the repository root.
set -u

SCAN=$(CDPATH= cd "$(dirname "$0")" && pwd)/pond_enclosure_built_scan.sh
[ -f "$SCAN" ] || { echo "control_verdict=scan_absent" >&2; exit 1; }

pen_root=$(mktemp -d)
trap 'rm -rf "$pen_root"' EXIT INT TERM

fails=0
note() { echo "$1"; }
want() { # want <name> <expected ok|refuse> <actual exit>
  if [ "$2" = "ok" ] && [ "$3" -eq 0 ]; then note "$1=yes"; return; fi
  if [ "$2" = "refuse" ] && [ "$3" -ne 0 ]; then note "$1=yes"; return; fi
  note "$1=no"; fails=$((fails + 1))
}

new_pen() { # new_pen <name> -- a pen holding an empty record and an empty plan
  p=$pen_root/$1
  mkdir -p "$p/pond"
  printf 'format pond-enclosure-policy-v1\nname pen\n' > "$p/pond/enclosure_policy.kyri"
  printf 'format pond-enclosure-default-plan-v1\nmeasured 20260101.000000\nhost pen\njail pen\nflags none\n' > "$p/plan.kyri"
  echo "$p"
}
declare_line() { printf '%s\n' "$2" >> "$1/pond/enclosure_policy.kyri"; }
plan_line() { printf '%s\n' "$2" >> "$1/plan.kyri"; }
run_scan() { sh "$SCAN" --root "$1" --plan "$1/plan.kyri" --no-live >"$1/.out" 2>"$1/.err"; echo $?; }

# ---- Reading one: the gate bites in the escape direction, and only there.
pen=$(new_pen escape)
plan_line "$pen" 'ro-bind /usr /usr'
want undeclared_build_refused refuse "$(run_scan "$pen")"
grep -q 'detail: the plan builds `map /usr`' "$pen/.out" && note "undeclared_build_named=yes" || { note "undeclared_build_named=no"; fails=$((fails + 1)); }
declare_line "$pen" 'map /usr'
want declared_build_passes ok "$(run_scan "$pen")"

# A record declaring MORE than the plan builds is reported, never gated: the launcher's own rows
# live there by design, and a guard that reds on the truth is a guard someone turns off.
declare_line "$pen" 'map /run/current-system'
want declared_unbuilt_reported_not_gated ok "$(run_scan "$pen")"
grep -q 'declared_unbuilt=1' "$pen/.out" && note "declared_unbuilt_counted=yes" || { note "declared_unbuilt_counted=no"; fails=$((fails + 1)); }

# ---- Reading two: the translation table, each row shown by the declaration it must produce and
# by the one it must NOT. A wrong mark here would say the opposite thing about isolation.
check_translation() { # check_translation <name> <plan row> <right declaration> <wrong declaration>
  pen=$(new_pen "$1")
  plan_line "$pen" "$2"
  declare_line "$pen" "$4"
  want "$1_wrong_mark_refused" refuse "$(run_scan "$pen")"
  printf 'format pond-enclosure-policy-v1\nname pen\n' > "$pen/pond/enclosure_policy.kyri"
  declare_line "$pen" "$3"
  want "$1_right_mark_passes" ok "$(run_scan "$pen")"
}
check_translation same_path_is_map   'ro-bind /usr /usr'                  'map /usr'            'graft /usr'
check_translation grafted_is_graft   'ro-bind /tmp/bwrap-resolv /etc/resolv.conf' 'graft /etc/resolv.conf' 'map /tmp/bwrap-resolv'
check_translation rw_bind_is_rw_map  'bind /run/user/<uid> /run/user/<uid>' 'rw-map /run/user/<uid>:/run/user/<uid>' 'map /run/user/<uid>'
check_translation dev_bind_is_device 'dev-bind /dev/shm /dev/shm'         'device /dev/shm'     'rw-map /dev/shm:/dev/shm'
check_translation dev_is_fresh       'dev /dev'                           'fresh /dev'          'map /dev'
check_translation proc_is_fresh      'proc /proc'                         'fresh /proc'         'map /proc'

# ---- Reading three: a tmpfs is a mask when the plan binds a path above it, and scratch when it
# stands alone. The rule is read off the plan itself, so a mask the jail adds tomorrow reads as one.
pen=$(new_pen masking)
plan_line "$pen" 'ro-bind /sys /sys'
plan_line "$pen" 'tmpfs /sys/kernel/debug'
plan_line "$pen" 'tmpfs /tmp'
declare_line "$pen" 'map /sys'
declare_line "$pen" 'mask /sys/kernel/debug'
declare_line "$pen" 'ephemeral /tmp'
want mask_and_scratch_told_apart ok "$(run_scan "$pen")"

printf 'format pond-enclosure-policy-v1\nname pen\npersist /home/youruser/grain\n' > "$pen/pond/enclosure_policy.kyri"
declare_line "$pen" 'map /sys'
declare_line "$pen" 'ephemeral /sys/kernel/debug'
declare_line "$pen" 'mask /tmp'
want mask_and_scratch_swapped_refused refuse "$(run_scan "$pen")"

# The same tmpfs with the bind above it removed becomes scratch, which is what makes it a rule
# rather than a roster of four paths somebody typed.
pen=$(new_pen masking_unbound)
plan_line "$pen" 'tmpfs /sys/kernel/debug'
declare_line "$pen" 'ephemeral /sys/kernel/debug'
want unbound_tmpfs_is_scratch ok "$(run_scan "$pen")"

# ---- Reading four: normalization, so nothing a pier knows about its operator reaches the tree.
pen=$(new_pen normalize)
plan_line "$pen" 'bind /home/somebody/grain/loops/claude /home/somebody/.claude'
plan_line "$pen" 'bind /run/user/1000 /run/user/1000'
plan_line "$pen" 'ro-bind /nix/store/ahnwawk7prmdldj0wb4qcn1pwf0c9f3h-hosts /nix/store/ahnwawk7prmdldj0wb4qcn1pwf0c9f3h-hosts'
declare_line "$pen" 'rw-map /home/youruser/grain/loops/claude:/home/youruser/.claude'
declare_line "$pen" 'rw-map /run/user/<uid>:/run/user/<uid>'
declare_line "$pen" 'map /nix/store/<hash>-hosts'
want host_names_normalized ok "$(run_scan "$pen")"

pen=$(new_pen normalize_literal)
plan_line "$pen" 'bind /run/user/1000 /run/user/1000'
declare_line "$pen" 'rw-map /run/user/1000:/run/user/1000'
want literal_uid_refused refuse "$(run_scan "$pen")"

# ---- Reading five: the bound on the plan roster, from both sides.
pen=$(new_pen bound)
i=1
while [ "$i" -le 64 ]; do plan_line "$pen" "ro-bind /r$i /r$i"; declare_line "$pen" "map /r$i"; i=$((i + 1)); done
want plan_at_bound_passes ok "$(run_scan "$pen")"
plan_line "$pen" 'ro-bind /r65 /r65'
declare_line "$pen" 'map /r65'
want plan_over_bound_refused refuse "$(run_scan "$pen")"
grep -q 'verdict=unbounded' "$pen/.out" && note "over_bound_named=yes" || { note "over_bound_named=no"; fails=$((fails + 1)); }

# ---- Reading six: an absent half is named rather than read as zero.
pen=$(new_pen absent)
rm -f "$pen/pond/enclosure_policy.kyri"
want absent_record_refused refuse "$(run_scan "$pen")"
pen=$(new_pen absent_plan)
want absent_plan_refused refuse "$(sh "$SCAN" --root "$pen" --plan "$pen/nothing.kyri" --no-live >/dev/null 2>&1; echo $?)"

# A plan holding header fields and no mount rows answers unreadable rather than green-at-zero,
# which is the failure mode a zero-gated guard is most likely to reach.
pen=$(new_pen empty_plan)
want empty_plan_refused refuse "$(run_scan "$pen")"
grep -q 'verdict=unreadable' "$pen/.out" && note "empty_plan_named=yes" || { note "empty_plan_named=no"; fails=$((fails + 1)); }

echo "control_checks=29"
echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=behavior_missing" >&2
exit 1
