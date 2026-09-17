#!/bin/sh
# tools/fixtures/b/build_lock_ignore_control.sh -- prove the lock-ignore reading from both sides,
# and prove the CONSEQUENCE on metal rather than arguing it.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass.
#
# The sharpest legs here are not about the scan at all. They run a real `git stash push -u` against
# a real held lock in a real git repository and ask whether the lock survived and whether a second
# acquirer got in -- which is the whole claim, done rather than reasoned.
#
#   sh tools/fixtures/b/build_lock_ignore_control.sh

set -u
root=$(pwd -P)
scan="$root/tools/fixtures/b/build_lock_ignore_scan.sh"
portable="$root/tools/fixtures/s/shell_portable.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }
[ -f "$portable" ] || { echo "control_verdict=no_portable"; exit 1; }

pen=$(mktemp -d "${TMPDIR:-/tmp}/build_lock_ignore_control.XXXXXX") || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

faults=0
legs=0
claim() { # name want got
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then echo "$1=yes"; else echo "$1=no ($3, wanted $2)"; faults=$((faults + 1)); fi
}

# --------------------------------------------------------------------------------------------
# A tree carrying a lock-taking runner, a room a build writes, and a .gitignore shaped like this
# tree's own -- root denied, project paths allowed back -- since that deny is what made the first
# draft of the scan read every lock as ignored.
newtree() { # name ignore-line
  d="$pen/$1"
  rm -rf "$d"; mkdir -p "$d/tools/fixtures/r" "$d/room/src"
  ( cd "$d" && git init -q . && git config user.email c@example.invalid && git config user.name c )
  { echo '/*'; echo '!/tools/'; echo '!/room/'; echo '!/.gitignore'; [ -n "${2:-}" ] && echo "$2"; } > "$d/.gitignore"
  printf 'const x = 1;\n' > "$d/room/a.rye"
  printf 'const x = 1;\n' > "$d/room/src/b.rye"
  printf '#!/bin/sh\nlock="$d/.rye-build.lock"\nlock_acquire "$lock" "$wait_max" || exit 3\n' \
    > "$d/tools/fixtures/r/rye_build.sh"
  ( cd "$d" && git add -A >/dev/null 2>&1 && git commit -qm seed >/dev/null 2>&1 )
}
readout() { # tree key
  ( cd "$pen/$1" && BUILD_LOCK_IGNORE_ROOT=. sh "$scan" 2>/dev/null ) | sed -n "s/^$2=//p" | head -1
}

# --- 1-4. the tree before the repair: the lock is read unignored, and the scan refuses -----------
newtree bare ""
claim bare_unignored 1 "$(readout bare locks_unignored)"
claim bare_in_tree 1 "$(readout bare locks_in_tree)"
claim bare_verdict swept_by_a_round_open "$(readout bare verdict)"
( cd "$pen/bare" && BUILD_LOCK_IGNORE_ROOT=. sh "$scan" >/dev/null 2>&1 ) && claim bare_exits_nonzero yes no || claim bare_exits_nonzero yes yes

# --- 5-7. the tree after the repair: named at every depth, and the scan walks free ---------------
newtree named ".rye-build.lock/"
claim named_unignored 0 "$(readout named locks_unignored)"
claim named_ignored 1 "$(readout named locks_ignored)"
claim named_verdict named "$(readout named verdict)"

# --- 8-9. A RULE ANCHORED TO ONE ROOM IS THE FAULT THE THREE-DEPTH PROBE EXISTS TO CATCH ---------
# `/room/.rye-build.lock/` satisfies a depth-one probe and leaves `room/src` swept, which is the
# whole reason the lock counts as ignored only when git ignores it in every room it can take.
newtree anchored "/room/.rye-build.lock/"
claim anchored_still_unignored 1 "$(readout anchored locks_unignored)"
claim anchored_verdict swept_by_a_round_open "$(readout anchored verdict)"

# --------------------------------------------------------------------------------------------
# THE CONSEQUENCE, RUN RATHER THAN ARGUED. A live lock, a real `git stash push -u`, and the
# question the whole row turns on: did the lock survive, and did a second acquirer get in?
stash_leg() { # tree-name ignore-line want-survives want-second-acquires
  newtree "$1" "$2"
  t="$pen/$1"
  # A held lock, exactly as lock_acquire holds one: the directory IS the lock, pid inside it.
  mkdir -p "$t/room/src/.rye-build.lock"
  printf '%s\n' "$$" > "$t/room/src/.rye-build.lock/pid"
  ( cd "$t" && git stash push -u -q -m roundopen >/dev/null 2>&1 )
  if [ -d "$t/room/src/.rye-build.lock" ]; then survives=yes; else survives=no; fi
  claim "$1_lock_survives_stash" "$3" "$survives"
  # A second acquirer, using this tree's own lock_acquire rather than a retelling of it.
  if ( . "$portable"; lock_acquire "$t/room/src/.rye-build.lock" 0 ) >/dev/null 2>&1; then
    second=acquired
  else
    second=refused
  fi
  claim "$1_second_acquirer" "$4" "$second"
}

# --- 10-11. unignored: the round-open releases a live build's lock and the room is entered -------
stash_leg sweep "" no acquired
# --- 12-13. named: the lock stands through the stash and the second builder is held out ----------
stash_leg hold ".rye-build.lock/" yes refused

# --- 14-15. the pid inside a surviving lock is the ORIGINAL holder's, never a replacement --------
newtree pidcheck ".rye-build.lock/"
mkdir -p "$pen/pidcheck/room/src/.rye-build.lock"
printf '424242\n' > "$pen/pidcheck/room/src/.rye-build.lock/pid"
( cd "$pen/pidcheck" && git stash push -u -q -m roundopen >/dev/null 2>&1 )
claim pid_file_survives yes "$([ -s "$pen/pidcheck/room/src/.rye-build.lock/pid" ] && echo yes || echo no)"
claim pid_unchanged 424242 "$(cat "$pen/pidcheck/room/src/.rye-build.lock/pid" 2>/dev/null)"

# --- 16-18. a lock outside the tree is counted outside and gates nothing -------------------------
newtree outside ".rye-build.lock/"
printf '#!/bin/sh\nport_lock="${TMPDIR:-/tmp}/pen-port.lock"\nlock_acquire "$port_lock" 5 || exit 3\n' \
  > "$pen/outside/tools/fixtures/r/port.sh"
( cd "$pen/outside" && git add -A >/dev/null 2>&1 && git commit -qm port >/dev/null 2>&1 )
claim outside_counted 1 "$(readout outside locks_outside)"
claim outside_not_gated 0 "$(readout outside locks_unignored)"
claim outside_verdict named "$(readout outside verdict)"

# --- 19-21. an unresolvable lock path is counted, never assumed free -----------------------------
newtree opaque ".rye-build.lock/"
printf '#!/bin/sh\nlock_acquire "$mystery" 5 || exit 3\n' > "$pen/opaque/tools/fixtures/r/opaque.sh"
( cd "$pen/opaque" && git add -A >/dev/null 2>&1 && git commit -qm opaque >/dev/null 2>&1 )
claim opaque_counted 1 "$(readout opaque locks_unresolved)"
claim opaque_not_ignored 0 "$(readout opaque locks_unignored)"
claim opaque_refuses swept_by_a_round_open "$(readout opaque verdict)"

# --- 22-23. a control and the portable helper itself are read past by name -----------------------
newtree roster ".rye-build.lock/"
printf '#!/bin/sh\nlock_acquire "$lk" 2\n' > "$pen/roster/tools/fixtures/r/thing_control.sh"
( cd "$pen/roster" && git add -A >/dev/null 2>&1 && git commit -qm roster >/dev/null 2>&1 )
claim control_read_past 1 "$(readout roster locks_in_tree)"
claim roster_verdict named "$(readout roster verdict)"

# --------------------------------------------------------------------------------------------
# MUTATIONS. Each is preceded by a check that its marker stands, since a mutation removing nothing
# reads as a passing leg.
mutate() { # name sed-expr marker want-after
  m="$pen/mutant_$1.sh"
  claim "mutation_${1}_marker" 1 "$(grep -c "$3" "$scan" | head -1)"
  sed "$2" "$scan" > "$m"
  got=$( ( cd "$pen/bare" && BUILD_LOCK_IGNORE_ROOT=. sh "$m" 2>/dev/null ) | sed -n 's/^locks_unignored=//p' | head -1 )
  claim "mutation_${1}_bites" "$4" "$got"
}
# The three-depth probe reduced to one room stops seeing an anchored rule -- and on `bare`, where
# nothing is ignored at all, it still reads 1, so this mutation is checked on `anchored` instead.
# One probe room rather than three: the derivation is cut to its first depth, which is exactly what
# a hand would write if the three-depth reasoning were dropped. On `anchored`, where the rule names
# only the shallow room, the truth is 1 and the one-room reading answers 0.
claim mutation_depth_marker 1 "$(grep -c '^  probe_rooms="\$probe_rooms \$_pick"' "$scan" | head -1)"
awk '/^for _depth in 1 2 3; do$/ { print "for _depth in 1; do"; next } { print }' "$scan" > "$pen/mutant_depth.sh"
got=$( ( cd "$pen/anchored" && BUILD_LOCK_IGNORE_ROOT=. sh "$pen/mutant_depth.sh" 2>/dev/null ) | sed -n 's/^locks_unignored=//p' | head -1 )
claim mutation_depth_bites 0 "$got"

# Deriving probe rooms from real tracked sources is what keeps the root `/*` deny from swallowing
# the reading. Traded for a fictional root, `named` -- a correctly repaired tree -- still reads 0,
# so the mutation is read on `bare`, where the truth is 1 and the fiction answers 0.
claim mutation_fictional_marker 1 "$(grep -c '^_rye_dirs=' "$scan" | head -1)"
awk '/^_rye_dirs=/ { print "_rye_dirs=\x27a a/b a/b/c\x27"; next } { print }' "$scan" > "$pen/mutant_fict.sh"
got=$( ( cd "$pen/bare" && BUILD_LOCK_IGNORE_ROOT=. sh "$pen/mutant_fict.sh" 2>/dev/null ) | sed -n 's/^locks_unignored=//p' | head -1 )
claim mutation_fictional_bites 0 "$got"

# An unresolved lock counted as free is the silent failure this instrument most owes a reader.
mutate unresolved 's/^  echo "verdict=swept_by_a_round_open"/  : /' 'verdict=swept_by_a_round_open' 1

echo "control_legs=$legs"
echo "control_failed=$faults"
[ "$faults" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=failed"
[ "$faults" -eq 0 ]
