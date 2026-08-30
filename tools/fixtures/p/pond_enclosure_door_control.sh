#!/bin/sh
# tools/fixtures/p/pond_enclosure_door_control.sh -- proves the door seam on planted trees.
#
# WHY A CONTROL. The scan it drives reports `entry_unreachable=0` and `door_disagreements=0` on the
# living tree, and a zero is the one reading that cannot tell a working guard from a guard reading
# nothing (REDS %285 is the whole argument). So every reading below is shown from BOTH sides: the
# shape that must refuse is planted and watched to refuse, and the shape that must pass free is
# planted beside it and watched to pass. A refusal proven only in the passing direction cannot be
# told from a bypass.
#
# Each pen is a throwaway directory holding a record and a launcher, handed to the scan with --root,
# --policy, and --launcher. No case passes --probe, so every gate here is proven WITHOUT a jail
# installed -- which is the state of every clone this guard works on.
#
# WHAT THIS CONTROL DOES NOT REACH. The probe itself, which starts a real enclosure: a pen cannot
# convincingly fake a kernel, and faking one would prove the fake. tools/p/pond_enclosure_door_witness.rish
# runs the probe on metal where ai-jail stands, and says so plainly when it cannot. That division
# reaches the `user` mark too: the cases below prove the record's declaration is READ, from both
# spellings and from its absence, and the witness proves it is SETTLED -- agreeing on the living
# record and refusing on a planted uid the enclosure cannot be running as.
#
# USAGE
#   sh tools/fixtures/p/pond_enclosure_door_control.sh
#
# Driven by tools/p/pond_enclosure_door_witness.rish. Run from the repository root.
set -u

HERE=$(CDPATH= cd "$(dirname "$0")" && pwd)
SCAN=$HERE/pond_enclosure_door_scan.sh
[ -f "$SCAN" ] || { echo "control_verdict=scan_absent" >&2; exit 1; }

# THE DIALECT HELPER, sourced from its letter room beside this one. The single plant below edits a
# pen launcher in place, and the GNU and BSD spellings of that flag have no overlap at all, so the
# tree writes neither: `sed_inplace` writes a temporary and copies it back through the original
# inode. Why it matters here: this control is one of the two Pond guards that red on the macOS
# bench, and a control that cannot run there proves nothing there.
. "$HERE/../s/shell_portable.sh"

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

# A pen carries the two halves the scan compares and nothing else. The record's declared subtrees are
# the ones the living record carries, so a pen reads the way the tree reads.
new_pen() { # new_pen <name>
  p=$pen_root/$1
  mkdir -p "$p/pond" "$p/tools/ag"
  cat > "$p/pond/enclosure_policy.kyri" <<'EOF'
# a planted record
format pond-enclosure-policy-v1
name pen
private-home yes
network on
gpu no
map /run/current-system
map /nix
map /bin
map /sys
mask /sys/kernel/debug
persist /home/youruser/grain
ephemeral /run
ephemeral /tmp
rw-map /home/youruser/grain/loops/claude:/home/youruser/.claude
EOF
  launcher "$p" '/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:${HOST_HOME}/.nix-profile/bin:/bin'
  echo "$p"
}

# launcher <pen> <jail-path-value> -- the three lines the scan lifts, in the launcher's own spelling.
launcher() {
  cat > "$1/tools/ag/agent-jail.sh" <<EOF
#!/usr/bin/env bash
REPO="\${REPO:-\$REPO_ROOT}"
GH_STATE="\${GH_STATE:-\$REPO/.gh}"
AIJAIL_FLAGS="\${AIJAIL_FLAGS:---private-home --no-docker --no-gpu}"
JAIL_PATH="$2"
exec "\$AIJAIL_ABS" --no-save-config \$AIJAIL_FLAGS "\${DRY_ARGS[@]}" "\${MAP_ARGS[@]}" -- \\
  env "GH_CONFIG_DIR=\$GH_STATE" "PATH=\$JAIL_PATH" "\$AGENT_BIN" "\${AGENT_FORWARD[@]}" "\$@"
EOF
}

# Every pen names its entry explicitly, so no case depends on whether this bench has claude
# installed -- the control has to answer the same on a clone that has never seen an agent CLI.
run_scan() { # run_scan <pen> [extra args...]
  p=$1; shift
  sh "$SCAN" --root "$p" --policy "$p/pond/enclosure_policy.kyri" \
     --launcher "$p/tools/ag/agent-jail.sh" --entry /nix/store/pen-hash/bin/claude "$@" > "$p/.out" 2>&1
  echo $?
}

# ---- Reading one, the gate: the entry. An enclosure that cannot start the one program it exists to
# run is the shape that is always wrong, so it is shown refusing and passing at the same pen.
pen=$(new_pen entry_declared)
want entry_declared_passes ok "$(run_scan "$pen")"
saw entry_declared_named "$pen" 'entry_state=declared entry_unreachable=0'
saw entry_declared_verdict "$pen" 'verdict=ok'

pen=$(new_pen entry_undeclared)
sh "$SCAN" --root "$pen" --policy "$pen/pond/enclosure_policy.kyri" \
   --launcher "$pen/tools/ag/agent-jail.sh" --entry /opt/vendor/bin/claude > "$pen/.out" 2>&1
want entry_undeclared_refuses refuse "$?"
saw entry_undeclared_named "$pen" 'verdict=entry_unreachable'
saw entry_undeclared_detail "$pen" 'sits under no declared subtree'

# An entry under a masked subtree is undeclared however wide the map above it, because a masked path
# is hidden whatever declared it.
pen=$(new_pen entry_masked)
sh "$SCAN" --root "$pen" --policy "$pen/pond/enclosure_policy.kyri" \
   --launcher "$pen/tools/ag/agent-jail.sh" --entry /sys/kernel/debug/bin/claude > "$pen/.out" 2>&1
want entry_masked_refuses refuse "$?"
saw entry_masked_named "$pen" 'verdict=entry_unreachable'

# ---- Reading two, the ratchet: undeclared search-path elements, proven from both sides of the
# ceiling by planting one at the bound and one past it. No override exists and none is wanted.
pen=$(new_pen ceiling_at_bound)
want ceiling_at_bound_passes ok "$(run_scan "$pen")"
saw ceiling_at_bound_named "$pen" 'path_undeclared=1 ceiling=1'

pen=$(new_pen ceiling_one_past)
launcher "$pen" '/run/current-system/sw/bin:${HOST_HOME}/.nix-profile/bin:/var/lib/nowhere/bin:/bin'
want ceiling_one_past_refuses refuse "$(run_scan "$pen")"
saw ceiling_one_past_named "$pen" 'verdict=over_ceiling'
saw ceiling_one_past_counts "$pen" 'path_undeclared=2'

pen=$(new_pen all_declared)
launcher "$pen" '/run/current-system/sw/bin:/nix/store/x/bin:/bin'
want all_declared_passes ok "$(run_scan "$pen")"
saw all_declared_named "$pen" 'path_undeclared=0'

# ---- Reading three: which record lines declare reach, and which do not. Four shapes, each shown to
# answer the way the record's own grammar says it should.
pen=$(new_pen reach_rwmap)
launcher "$pen" '/home/youruser/.claude/bin'
want reach_rwmap_passes ok "$(run_scan "$pen")"
saw reach_rwmap_declared "$pen" 'path_undeclared=0'

pen=$(new_pen reach_ephemeral)
launcher "$pen" '/run/user/1000/bin'
want reach_ephemeral_refuses ok "$(run_scan "$pen")"
saw reach_ephemeral_undeclared "$pen" 'path_undeclared=1'
saw reach_ephemeral_named "$pen" 'under no declared subtree'

pen=$(new_pen reach_masked)
launcher "$pen" '/sys/kernel/debug/tracing'
want reach_masked_passes ok "$(run_scan "$pen")"
saw reach_masked_undeclared "$pen" 'path_undeclared=1'

pen=$(new_pen reach_persist)
launcher "$pen" '/home/youruser/grain/tools/bin'
want reach_persist_passes ok "$(run_scan "$pen")"
saw reach_persist_declared "$pen" 'path_undeclared=0'

# ---- Reading four: the environment crossing the threshold.
pen=$(new_pen env_declared)
want env_declared_passes ok "$(run_scan "$pen")"
saw env_declared_named "$pen" 'env_assignments=2 env_undeclared=0'

pen=$(new_pen env_undeclared)
sed_inplace 's#^GH_STATE=.*#GH_STATE="${GH_STATE:-/var/cache/gh}"#' "$pen/tools/ag/agent-jail.sh"
want env_undeclared_reported ok "$(run_scan "$pen")"
saw env_undeclared_counted "$pen" 'env_undeclared=1'
saw env_undeclared_detail "$pen" 'so what the agent writes there dissolves'

# ---- Reading five: the duties the record's grammar cannot express. Three today, and a record that
# grows keys for them reads zero -- which is how orbit four will know it is finished.
pen=$(new_pen duties_absent)
want duties_absent_passes ok "$(run_scan "$pen")"
saw duties_absent_counted "$pen" 'duties_undeclared=3'
saw duties_absent_named "$pen" 'the record names no `entry`'
# A record naming no user makes no claim, so the derived reading says `unstated` rather than
# guessing at one -- which is what keeps the probe comparison below silent on a record that has not
# seated the mark.
saw duties_absent_user_unstated "$pen" 'user_declared=unstated'

# The `env` lines here took the seated `KEY=value` spelling on `20260830`. This pen was written
# before the mark existed and guessed at `env KEY value`, which cost nothing while the duty count
# only asked whether a line began with `env `. It costs everything now: the settling reading below
# compares the declaration against the exec line, so a pen must declare what its own launcher
# spells or refuse -- which is the guard working.
pen=$(new_pen duties_declared)
cat >> "$pen/pond/enclosure_policy.kyri" <<'EOF'
entry /nix/store/pen-hash/bin/claude
env GH_CONFIG_DIR=/home/youruser/grain/.gh
env PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/home/youruser/.nix-profile/bin:/bin
user 1000
EOF
want duties_declared_passes ok "$(run_scan "$pen")"
saw duties_declared_counted "$pen" 'duties_undeclared=0'
saw duties_declared_user_read "$pen" 'user_declared=1000'
saw duties_declared_user_named "$pen" 'a fixed uid the probe leg settles against the kernel'

# ---- The `user` mark on its own, seated 20260829. The record can now state who the enclosure runs
# as, so the derived leg lifts that value and the probe leg settles it against a kernel. Both
# spellings are read here; the settling itself needs a running enclosure and is proven on metal by
# tools/p/pond_enclosure_door_witness.rish, which plants a uid the enclosure cannot be running as
# and watches the scan refuse.
pen=$(new_pen user_invoking)
printf 'user invoking\n' >> "$pen/pond/enclosure_policy.kyri"
want user_invoking_passes ok "$(run_scan "$pen")"
saw user_invoking_read "$pen" 'user_declared=invoking'
saw user_invoking_named "$pen" 'runs the agent as whoever opened the door'
saw user_invoking_counted "$pen" 'duties_undeclared=2'


# ---- The `env` mark on its own, seated 20260830. The record can now state the environment that
# crosses the threshold, so the derived leg lifts those lines and settles them against the exec line
# that makes them. This settling needs no kernel -- the launcher IS the ground truth -- so unlike the
# `user` mark both directions are proven right here, on planted trees, on any bench.
#
# The pen's own two assignments, in the record's namespace: GH_STATE reads $REPO/.gh, and $REPO is
# the pen root, which `to_record` speaks as the record's persist line; the search path is the four
# elements new_pen's launcher spells, with ${HOST_HOME} spoken as the record's home.
env_pair() { # env_pair <pen> -- append the two declarations the pen's own launcher spells
  cat >> "$1/pond/enclosure_policy.kyri" <<'EOP'
env GH_CONFIG_DIR=/home/youruser/grain/.gh
env PATH=/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/home/youruser/.nix-profile/bin:/bin
EOP
}

pen=$(new_pen env_agrees)
env_pair "$pen"
want env_agrees_passes ok "$(run_scan "$pen")"
saw env_agrees_counted "$pen" 'env_declared=2 env_state=declared env_disagreements=0'
saw env_agrees_named "$pen" 'which is what the exec line spells'
saw env_agrees_duties "$pen" 'duties_undeclared=2'

# A key the exec line spells and the record leaves out is the gap this mark closes, still standing.
pen=$(new_pen env_key_missing)
printf 'env GH_CONFIG_DIR=/home/youruser/grain/.gh\n' >> "$pen/pond/enclosure_policy.kyri"
want env_key_missing_refuses refuse "$(run_scan "$pen")"
saw env_key_missing_named "$pen" 'verdict=env_disagrees'
saw env_key_missing_detail "$pen" 'the record declares no `PATH` at all'

# A key both sides name at different values is the drift neither side can see alone, and it is
# counted ONCE rather than once from each direction.
pen=$(new_pen env_value_drift)
env_pair "$pen"
sed_inplace 's#^env GH_CONFIG_DIR=.*#env GH_CONFIG_DIR=/home/youruser/grain/.elsewhere#' "$pen/pond/enclosure_policy.kyri"
want env_value_drift_refuses refuse "$(run_scan "$pen")"
saw env_value_drift_named "$pen" 'verdict=env_disagrees'
saw env_value_drift_counted "$pen" 'env_disagreements=1'
saw env_value_drift_detail "$pen" 'and the record declares `GH_CONFIG_DIR=/home/youruser/grain/.elsewhere`'

# A declared assignment the launcher never makes is a claim nothing keeps -- REDS %329 one mark over.
pen=$(new_pen env_extra)
env_pair "$pen"
printf 'env EDITOR=/home/youruser/grain/tools/bin/ed\n' >> "$pen/pond/enclosure_policy.kyri"
want env_extra_refuses refuse "$(run_scan "$pen")"
saw env_extra_named "$pen" 'verdict=env_disagrees'
saw env_extra_detail "$pen" 'the exec line spells no `EDITOR` at all'

# And the passing side of the same gate at the same pen: a record that says nothing about env makes
# no claim, so it walks free and the duty count is the reading that speaks for it.
pen=$(new_pen env_unstated)
want env_unstated_passes ok "$(run_scan "$pen")"
saw env_unstated_counted "$pen" 'env_declared=0 env_state=unstated env_disagreements=0'

# ---- Reading six: the lift. The search path and the exec line are read out of the launcher at run
# time, so losing either makes this refuse rather than guess at a default it once saw.
pen=$(new_pen lift_no_jail_path)
grep -v '^JAIL_PATH=' "$pen/tools/ag/agent-jail.sh" > "$pen/x" && mv "$pen/x" "$pen/tools/ag/agent-jail.sh"
want lift_no_jail_path_refuses refuse "$(run_scan "$pen")"
saw lift_no_jail_path_named "$pen" 'no longer publishes JAIL_PATH='

pen=$(new_pen lift_no_exec)
grep -v 'exec "\$AIJAIL_ABS"' "$pen/tools/ag/agent-jail.sh" > "$pen/x" && mv "$pen/x" "$pen/tools/ag/agent-jail.sh"
want lift_no_exec_refuses refuse "$(run_scan "$pen")"
saw lift_no_exec_named "$pen" 'verdict=unreadable'

# ---- Reading seven: the bounds. A generated search path refuses rather than being walked.
pen=$(new_pen path_unbounded)
long=/bin
i=0
while [ "$i" -lt 17 ]; do long="$long:/bin/$i"; i=$((i + 1)); done
launcher "$pen" "$long"
want path_unbounded_refuses refuse "$(run_scan "$pen")"
saw path_unbounded_named "$pen" 'verdict=unbounded'

pen=$(new_pen path_empty)
launcher "$pen" ''
want path_empty_refuses refuse "$(run_scan "$pen")"
saw path_empty_named "$pen" 'carries no elements'

# ---- Reading eight: an absent half is named rather than guessed at.
pen=$(new_pen no_record)
rm -f "$pen/pond/enclosure_policy.kyri"
want absent_record_refuses refuse "$(run_scan "$pen")"
saw absent_record_named "$pen" 'detail=no_policy'

pen=$(new_pen no_launcher)
rm -f "$pen/tools/ag/agent-jail.sh"
want absent_launcher_refuses refuse "$(run_scan "$pen")"
saw absent_launcher_named "$pen" 'detail=no_launcher'

# A record naming no home cannot place a launcher path spelled under ${HOST_HOME}, so it says so
# rather than silently reading that element against nothing.
pen=$(new_pen no_home)
grep -v '^rw-map \|^persist ' "$pen/pond/enclosure_policy.kyri" > "$pen/x" && mv "$pen/x" "$pen/pond/enclosure_policy.kyri"
want no_home_refuses refuse "$(run_scan "$pen")"
saw no_home_named "$pen" 'the record names no home'

# ---- Reading nine: the probe stays opt-in. An ordinary run starts no enclosure and says so in its
# own counters, which is what lets this guard ride the roster every lap.
pen=$(new_pen no_probe)
want ordinary_run_passes ok "$(run_scan "$pen")"
saw probe_absent_by_default "$pen" 'probe_read=no probe_asked=0'

echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=failed"; exit 1
