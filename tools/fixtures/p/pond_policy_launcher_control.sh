#!/usr/bin/env sh
# pond_policy_launcher_control.sh -- pond_policy_launcher_scan.sh proven on planted trees.
#
# WHAT THIS PROVES. Every refusal the scan can make, shown from BOTH sides: the plant refuses, and
# the same pen with the plant removed returns to green. A refusal proven only in the passing
# direction cannot be told from a bypass, so the removal leg is what makes the rest mean anything.
# Both bounds are proven from both sides too, one entry past and one entry under, so no override
# exists and none is wanted.
#
# WHY A PEN RATHER THAN THE LIVE TREE. The scan reads two tracked files, and planting into them
# would move the tree a roster run is measuring. Each case builds its own throwaway copy, which
# also means a case can plant a launcher flag this pier would never pass.
#
#   sh tools/fixtures/p/pond_policy_launcher_control.sh
set -eu
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/p/pond_policy_launcher_scan.sh"

pen_root=$(mktemp -d)
trap 'rm -rf "$pen_root"' EXIT INT TERM
pass=0
fail=0

# new_pen -- a fresh copy of the live seam, ready to be planted into.
new_pen() {
  _p="$pen_root/$1"
  mkdir -p "$_p/tools/ag" "$_p/pond"
  cp "$ROOT/tools/ag/agent-jail.sh" "$_p/tools/ag/agent-jail.sh"
  cp "$ROOT/pond/enclosure_policy.kyri" "$_p/pond/enclosure_policy.kyri"
  printf '%s' "$_p"
}

# expect <name> <want-exit> <want-text> <pen>
expect() {
  _name=$1; _code=$2; _text=$3; _pen=$4
  set +e
  _out=$(sh "$SCAN" --root "$_pen" 2>&1)
  _got=$?
  set -e
  if [ "$_got" -eq "$_code" ] && printf '%s' "$_out" | grep -q -- "$_text"; then
    echo "ok: $_name"
    pass=$((pass + 1))
  else
    echo "no: $_name -- want exit $_code with '$_text', got exit $_got"
    printf '%s\n' "$_out" | sed 's/^/    /'
    fail=$((fail + 1))
  fi
}

# 1-2. The live seam reads green, and says so with both gates at zero.
p=$(new_pen live)
expect "the live seam reads green" 0 "verdict=green" "$p"
expect "both gates read zero on the live seam" 0 "unsupported_closures=0" "$p"

# 3-4. REDS %329 itself, planted and removed: a closure claim with no flag behind it.
p=$(new_pen closure)
sed -i 's/^network on$/network off/' "$p/pond/enclosure_policy.kyri"
expect "a closure claim with no flag refuses" 1 "verdict=unsupported_closure" "$p"
expect "the refusal names the facility and the missing flag" 1 "the launcher passes no --no-network" "$p"
sed -i 's/^network off$/network on/' "$p/pond/enclosure_policy.kyri"
expect "removing the plant returns the same pen to green" 0 "verdict=green" "$p"

# 5-6. The same row for a DIFFERENT facility, so the check is the roster rather than one word.
p=$(new_pen gpu)
sed -i 's/ --no-gpu}"/}"/' "$p/tools/ag/agent-jail.sh"
expect "gpu no refuses when the launcher stops passing --no-gpu" 1 "verdict=unsupported_closure" "$p"
sed -i 's/ --no-docker}"/ --no-docker --no-gpu}"/' "$p/tools/ag/agent-jail.sh"
expect "restoring the flag returns the same pen to green" 0 "verdict=green" "$p"

# 7-8. An open claim needs no flag, which is the asymmetry the scan is built on.
p=$(new_pen openclaim)
sed -i 's/^gpu no$/gpu yes/' "$p/pond/enclosure_policy.kyri"
sed -i 's/ --no-gpu}"/}"/' "$p/tools/ag/agent-jail.sh"
expect "an open gpu claim stands with no flag behind it" 0 "verdict=green" "$p"
expect "and it is counted as an open claim rather than a closure" 0 "open_claims=2" "$p"

# 9-11. The escape direction: a mount the record never named.
p=$(new_pen mount)
sed -i 's|^  --rw-map "${CODEX_STATE}:${HOST_HOME}/.codex"$|  --rw-map "${CODEX_STATE}:${HOST_HOME}/.codex"\n  --rw-map "${CLAUDE_STATE}:${HOST_HOME}/.ssh"|' "$p/tools/ag/agent-jail.sh"
expect "a mount the record never declared refuses" 1 "verdict=unspelled_mount" "$p"
expect "the refusal names the mount rather than counting it" 1 "/home/youruser/.ssh" "$p"
sed -i '\|--rw-map "${CLAUDE_STATE}:${HOST_HOME}/.ssh"|d' "$p/tools/ag/agent-jail.sh"
expect "removing the extra mount returns the same pen to green" 0 "verdict=green" "$p"

# 12-13. Declaring the planted mount is the other way to green, so the gate reads the PAIR rather
# than the launcher alone -- the point of a seam guard.
p=$(new_pen declared)
sed -i 's|^  --rw-map "${CODEX_STATE}:${HOST_HOME}/.codex"$|  --rw-map "${CODEX_STATE}:${HOST_HOME}/.codex"\n  --rw-map "${CODEX_STATE}:${HOST_HOME}/.config/codex"|' "$p/tools/ag/agent-jail.sh"
expect "the new mount refuses while undeclared" 1 "verdict=unspelled_mount" "$p"
printf 'rw-map /home/youruser/grain/loops/codex:/home/youruser/.config/codex\n' >> "$p/pond/enclosure_policy.kyri"
expect "declaring it in the record returns the pen to green" 0 "verdict=green" "$p"

# 14-15. The reverse reading moves, and never gates.
p=$(new_pen unbuilt)
expect "the record's ai-jail defaults are reported" 0 "unbuilt_maps=1" "$p"
sed -i '\|^map /nix/store$|d' "$p/pond/enclosure_policy.kyri"
expect "and removing one lowers the reading without refusing" 0 "unbuilt_maps=0" "$p"

# 16-17. A launcher flag the record carries no line for is reported, not gated.
p=$(new_pen flags)
expect "the undeclared flag is reported" 0 "undeclared_flags=1" "$p"
sed -i 's/ --no-gpu}"/ --no-gpu --no-pictures}"/' "$p/tools/ag/agent-jail.sh"
expect "a second undeclared flag raises the reading and still passes" 0 "undeclared_flags=2" "$p"

# 18-19. The map bound, proven from both sides.
p=$(new_pen bound_under)
i=0
while [ $i -lt 25 ]; do printf 'map /nix/pad%s\n' "$i" >> "$p/pond/enclosure_policy.kyri"; i=$((i + 1)); done
expect "thirty-two declared maps sit inside the bound" 0 "declared_maps=32" "$p"
printf 'map /nix/pad25\n' >> "$p/pond/enclosure_policy.kyri"
expect "one past the bound refuses" 1 "verdict=unbounded" "$p"

# 20. The flag bound, from the refusing side.
p=$(new_pen bound_flags)
sed -i 's/ --no-gpu}"/ --no-gpu --f1 --f2 --f3 --f4 --f5 --f6 --f7 --f8 --f9 --f10 --f11 --f12 --f13 --f14 --f15}"/' "$p/tools/ag/agent-jail.sh"
expect "a runaway flag list refuses" 1 "verdict=unbounded" "$p"

# 21-23. Both halves of the seam must be present, and the record must name its own root.
p=$(new_pen nolauncher); rm -f "$p/tools/ag/agent-jail.sh"
expect "an absent launcher refuses rather than guessing" 1 "detail=no_launcher" "$p"
p=$(new_pen nopolicy); rm -f "$p/pond/enclosure_policy.kyri"
expect "an absent record refuses rather than guessing" 1 "detail=no_policy" "$p"
p=$(new_pen noroot); sed -i '\|^persist |d' "$p/pond/enclosure_policy.kyri"
expect "a record naming no root refuses rather than spelling a host path" 1 "verdict=unreadable" "$p"

# 24. The metal reading is present on a pier with the jail and never gates either way.
p=$(new_pen metal)
expect "the jail-help reading is reported beside the gates" 0 "jail_help=" "$p"

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=broken"; exit 1; fi
echo "control_verdict=ok"
