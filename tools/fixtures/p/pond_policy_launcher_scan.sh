#!/usr/bin/env sh
# pond_policy_launcher_scan.sh -- the policy record and the launcher it claims to describe.
#
# WHAT THIS READS. pond/enclosure_policy.kyri is the ASKER: it declares what the agent-jail lap
# builds, and its own header says so -- "This record READS tools/ag/agent-jail.sh and
# tools/e/enclosure.conf.example and says what they build." tools/ag/agent-jail.sh is the
# ANSWERER: it assembles the flags and mounts that actually reach the enclosure. Two files, one
# contract, and until 20260828 nothing compared them.
#
# WHY IT EXISTS. A record nobody checks against its subject is a second spelling of the truth, and
# two spellings that must agree are one spelling plus a waiting bug. The record shipped
# `network off` from its first day for an enclosure whose network namespace is the host's own
# (REDS %329, measured on metal). Orbit two of the quest that retires ai-jail derives its grant
# set from this record, so a wrong line here becomes a wrong enclosure there.
#
# THE READINGS
#   unspelled_maps        the launcher mounts what the record does not declare   ZERO, ENFORCED
#   unsupported_closures  the record calls a facility closed with no flag        ZERO, ENFORCED
#   unbuilt_maps          the record declares what the launcher does not spell   reported
#   undeclared_flags      a launcher flag the record carries no line for         reported
#   unofferable_closures  a closure naming a facility the jail offers no flag    reported, never gated
#
# WHY THE GATES SIT WHERE THEY DO. `unspelled_maps` is the escape direction: a mount the policy
# never named is exactly the thing orbit two must prove cannot happen, so it is enforced. The
# reverse, `unbuilt_maps`, is reported instead -- the record honestly names ai-jail's own defaults
# (`/nix/store`, the persisted pier, the ephemeral /tmp), which the launcher never spells because
# it never has to, and failing on those would fail on the truth. `unofferable_closures` needs
# `ai-jail --help` and so needs a machine with the jail installed; a guard that reds on somebody
# else's machine is a guard someone turns off, which is the same reason pond_enclosure_state_scan
# reports its host-conf reading rather than gating it.
#
# THE CLOSURE VOCABULARY. In this launcher's own words, a facility is closed by a flag: `--no-gpu`
# closes the GPU, `--private-home` closes the home. So a record line claiming a facility is closed
# must point at a flag that closes it, and a line claiming one is open needs no flag at all --
# open is what an enclosure does when nobody says otherwise. That asymmetry is the whole check:
# `gpu no` is a promise, `gpu yes` is a description.
#
#   sh tools/fixtures/p/pond_policy_launcher_scan.sh [--root DIR]
#
# ACCRETE-ONLY. This reads the ai-jail launcher and Pond's own record. It rewrites neither, and it
# flips nothing: the ENCLOSURE selector stays ai-jail until the switchover round lands behind its
# audit.
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
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    *) echo "pond_policy_launcher_scan: unknown argument: $1" >&2; exit 2 ;;
  esac
done

JAIL="$ROOT/tools/ag/agent-jail.sh"
POLICY="$ROOT/pond/enclosure_policy.kyri"

# invariant: both halves of the seam must exist before a comparison means anything.
if [ ! -f "$JAIL" ]; then echo "scan=absent detail=no_launcher"; exit 1; fi
if [ ! -f "$POLICY" ]; then echo "scan=absent detail=no_policy"; exit 1; fi

# max_maps bounds the mount roster read off either side. Six stand in the launcher; the record held
# seven when this bound was drawn and holds fifteen since 20260828, when ai-jail's own twenty-one
# default mounts were measured and declared. Thirty-two leaves a body per seat on the six-body
# constellation with room to spare and still refuses a generated file, so the bound stands where it
# was -- the reading doubled and stayed under half of it.
max_maps=32
# max_flags bounds the flag list. Three stand; sixteen is the same shape of headroom.
max_flags=16

echo "pond_policy_launcher_scan v1"
echo "asker=pond/enclosure_policy.kyri"
echo "answerer=tools/ag/agent-jail.sh"

# The record names its own placeholder root, so nothing here spells a host path. `persist` is the
# pier bind and its parent is the placeholder home -- read from the record rather than restated,
# for the same reason the launcher's tables are read rather than restated.
placeholder_root=$(awk '$1=="persist"{print $2; exit}' "$POLICY")
if [ -z "${placeholder_root:-}" ]; then
  echo "detail: the record declares no persist line, so its placeholder root is unknown"
  echo "verdict=unreadable"
  exit 1
fi
placeholder_home=$(dirname "$placeholder_root")

# The answerer's flag default, read out of its own assignment rather than restated here.
flags=$(awk '
  /^AIJAIL_FLAGS="\$\{AIJAIL_FLAGS:-/ {
    line = $0
    sub(/^AIJAIL_FLAGS="\$\{AIJAIL_FLAGS:-/, "", line)
    sub(/\}"[ \t]*$/, "", line)
    n = split(line, f, / +/)
    for (i = 1; i <= n; i++) { sub(/^--/, "", f[i]); if (f[i] != "") print f[i] }
  }
' "$JAIL")

# The launcher's own room variables, the same two-line shape pond_enclosure_state_scan reads.
#   VAR="${VAR:-$LOOPS/room}"          -> <root>/loops/room
#   VAR="${VAR:-$OTHER_VAR/child}"     -> resolved in the second pass below
rooms=$(awk '
  match($0, /^[A-Z_]+="\$\{[A-Z_]+:-\$LOOPS\/[A-Za-z0-9_-]+\}"$/) {
    eq = index($0, "="); name = substr($0, 1, eq - 1)
    room = $0; sub(/^.*\$LOOPS\//, "", room); sub(/\}"$/, "", room)
    print name, room
  }
' "$JAIL")

children=$(awk '
  match($0, /^[A-Z_]+="\$\{[A-Z_]+:-\$[A-Z_]+\/[A-Za-z0-9_-]+\}"$/) {
    eq = index($0, "="); name = substr($0, 1, eq - 1)
    rest = $0; sub(/^.*:-\$/, "", rest); sub(/\}"$/, "", rest)
    slash = index(rest, "/")
    print name, substr(rest, 1, slash - 1), substr(rest, slash + 1)
  }
' "$JAIL")

# resolve_var <NAME> -- the placeholder path a launcher variable stands for, or empty.
resolve_var() {
  _want=$1
  _hit=$(printf '%s\n' "$rooms" | awk -v w="$_want" '$1==w{print $2; exit}')
  if [ -n "$_hit" ]; then printf '%s/loops/%s' "$placeholder_root" "$_hit"; return 0; fi
  _row=$(printf '%s\n' "$children" | awk -v w="$_want" '$1==w{print $2, $3; exit}')
  if [ -n "$_row" ]; then
    _parent=${_row%% *}; _child=${_row##* }
    [ "$_parent" = "LOOPS" ] && { printf '%s/loops/%s' "$placeholder_root" "$_child"; return 0; }
    _base=$(resolve_var "$_parent")
    [ -n "$_base" ] && { printf '%s/%s' "$_base" "$_child"; return 0; }
  fi
  return 0
}

# expand <text> -- a launcher argument with its variables put back as placeholder paths. HOST_HOME
# is the agent's home inside the enclosure, which the script sets from $HOME, so it stands for the
# record's placeholder home.
expand() {
  _t=$1
  _t=$(printf '%s' "$_t" | sed "s|\${HOST_HOME}|$placeholder_home|g; s|\$HOST_HOME|$placeholder_home|g")
  while :; do
    _v=$(printf '%s' "$_t" | sed -n 's|.*\${\([A-Z_][A-Z_]*\)}.*|\1|p' | head -1)
    [ -n "$_v" ] || break
    _r=$(resolve_var "$_v")
    [ -n "$_r" ] || { _r="UNRESOLVED_$_v"; }
    _t=$(printf '%s' "$_t" | sed "s|\${$_v}|$_r|g")
  done
  printf '%s' "$_t"
}

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# The launcher's mounts, expanded. `--rw-map "A:B"` and `--map P` are ai-jail's own two spellings
# (context/specs/enclosure-editors.md), and the record uses the same two words on purpose.
awk '
  match($0, /--rw-map[ \t]+"[^"]+"/) {
    s = substr($0, RSTART, RLENGTH); sub(/^--rw-map[ \t]+"/, "", s); sub(/"$/, "", s)
    print "rw-map", s
  }
  match($0, /--map[ \t]+\/[^ \t")]+/) {
    s = substr($0, RSTART, RLENGTH); sub(/^--map[ \t]+/, "", s)
    print "map", s
  }
' "$JAIL" > "$pen/raw_maps"

: > "$pen/built_maps"
while read -r kind value; do
  [ -n "${kind:-}" ] || continue
  printf '%s %s\n' "$kind" "$(expand "$value")" >> "$pen/built_maps"
done < "$pen/raw_maps"
sort -u "$pen/built_maps" > "$pen/built" && mv "$pen/built" "$pen/built_maps"

# The record's own map declarations.
awk '$1=="map" || $1=="rw-map" {print $1, $2}' "$POLICY" | sort -u > "$pen/declared_maps"

built_count=$(wc -l < "$pen/built_maps" | tr -d ' ')
declared_count=$(wc -l < "$pen/declared_maps" | tr -d ' ')
flag_count=$(printf '%s' "$flags" | grep -c . || true)

echo "built_maps=$built_count"
echo "declared_maps=$declared_count"
echo "launcher_flags=$flag_count"
# The bounds are printed rather than left in the source, so the control reads them off a run
# instead of spelling them. A control that spells a number goes stale the lap the truth moves,
# which is exactly what happened to three of its cases on 20260828.
echo "max_maps=$max_maps max_flags=$max_flags"

if [ "$built_count" -gt "$max_maps" ] || [ "$declared_count" -gt "$max_maps" ]; then
  echo "detail: a mount roster exceeds max_maps $max_maps"
  echo "verdict=unbounded"
  exit 1
fi
if [ "$flag_count" -gt "$max_flags" ]; then
  echo "detail: the flag roster exceeds max_flags $max_flags"
  echo "verdict=unbounded"
  exit 1
fi

unspelled_maps=0
while read -r kind value; do
  [ -n "${kind:-}" ] || continue
  if ! grep -qxF "$kind $value" "$pen/declared_maps"; then
    unspelled_maps=$((unspelled_maps + 1))
    echo "detail: the launcher mounts $kind $value, which the record does not declare"
  fi
done < "$pen/built_maps"

unbuilt_maps=0
while read -r kind value; do
  [ -n "${kind:-}" ] || continue
  if ! grep -qxF "$kind $value" "$pen/built_maps"; then
    unbuilt_maps=$((unbuilt_maps + 1))
    echo "detail: the record declares $kind $value, which the launcher does not spell -- an ai-jail default or a drift"
  fi
done < "$pen/declared_maps"

# The closure roster. Each row is: <record mark> <value meaning closed> <flag that closes it>.
# Three facilities carry a closure claim today. A facility whose closing flag the launcher passes
# is supported; one whose flag is absent is a promise nothing keeps.
closure_rows='network off no-network
gpu no no-gpu
private-home yes private-home'

unsupported_closures=0
supported_closures=0
open_claims=0
printf '%s\n' "$closure_rows" | while read -r mark closed_value flag; do
  [ -n "${mark:-}" ] || continue
  value=$(awk -v m="$mark" '$1==m{print $2; exit}' "$POLICY")
  [ -n "${value:-}" ] || continue
  if [ "$value" != "$closed_value" ]; then
    echo "open_claims" >> "$pen/tally"
    echo "detail: the record reads $mark $value, an open claim, which needs no flag to be true"
    continue
  fi
  if printf '%s\n' "$flags" | grep -qx "$flag"; then
    echo "supported_closures" >> "$pen/tally"
    echo "detail: $mark $value is kept by the launcher flag --$flag"
  else
    echo "unsupported_closures" >> "$pen/tally"
    echo "detail: the record claims $mark $value while the launcher passes no --$flag, so nothing closes it"
  fi
done
touch "$pen/tally"
count_of() { grep -c "^$1\$" "$pen/tally" 2>/dev/null || true; }
unsupported_closures=$(count_of unsupported_closures)
supported_closures=$(count_of supported_closures)
open_claims=$(count_of open_claims)

undeclared_flags=0
for f in $flags; do
  mark=$(printf '%s' "$f" | sed 's/^no-//')
  if ! awk -v m="$mark" '$1==m{found=1} END{exit !found}' "$POLICY"; then
    undeclared_flags=$((undeclared_flags + 1))
    echo "detail: the launcher passes --$f and the record carries no $mark line"
  fi
done

# The metal reading. Present only where ai-jail is installed, so it is reported and never gated.
unofferable_closures=0
jail_help=absent
AIJAIL=$(command -v ai-jail 2>/dev/null || true)
if [ -n "$AIJAIL" ]; then
  jail_help=present
  "$AIJAIL" --help >"$pen/help" 2>&1 || true
  printf '%s\n' "$closure_rows" | while read -r mark closed_value flag; do
    [ -n "${mark:-}" ] || continue
    value=$(awk -v m="$mark" '$1==m{print $2; exit}' "$POLICY")
    [ "$value" = "$closed_value" ] || continue
    grep -q -- "--$flag" "$pen/help" && continue
    echo "unofferable" >> "$pen/tally"
    echo "detail: the installed ai-jail offers no --$flag, so $mark $closed_value is unspellable here"
  done
  unofferable_closures=$(count_of unofferable)
fi

echo "unspelled_maps=$unspelled_maps"
echo "unsupported_closures=$unsupported_closures"
echo "unbuilt_maps=$unbuilt_maps"
echo "undeclared_flags=$undeclared_flags"
echo "supported_closures=$supported_closures"
echo "open_claims=$open_claims"
echo "jail_help=$jail_help"
echo "unofferable_closures=$unofferable_closures"

if [ "$unspelled_maps" -ne 0 ]; then
  echo "verdict=unspelled_mount"
  exit 1
fi
if [ "$unsupported_closures" -ne 0 ]; then
  echo "verdict=unsupported_closure"
  exit 1
fi
echo "verdict=green"
