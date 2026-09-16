#!/bin/sh
# rishi_make_pen_control.sh -- the runtime-owned pen, shown released down every path it can end on.
#
#   sh tools/fixtures/r/rishi_make_pen_control.sh
#
# WHY IT EXISTS (REDS %745). A `.rish` script carries no `trap`, so a failing `assert` ends the run
# where it stands and a pen made three lines above is left on a pier eight ships share. Nineteen
# rostered witnesses spell exactly that shape and put 32G into one `/tmp`. `make-pen` moves the
# release out of a line each script must remember and into the runtime that already owns the exit.
#
# THE BOUNDARY, WHICH IS THE WHOLE SAFETY ARGUMENT. A recursive removal is the one operation worth
# being frightened of, so the caller never supplies a path. It supplies a LABEL -- letters, digits,
# `_` and `-` -- and the runtime derives the root, the prefix, the clock seed and the attempt
# number. A label that cannot spell `/`, `.` or a null byte cannot leave one path component, and
# the release re-reads the runtime's own prefix off the basename before it removes anything.
#
# EVERY WALL IS SHOWN FROM BOTH SIDES BY INPUT rather than by a mutation switch. The subject here
# is a compiled runtime, so flipping a predicate costs a full rebuild -- which a rostered guard
# cannot afford to run. A 64-byte label is planted and accepted; 65 is planted and refused. Four
# pens are accepted; the fifth is refused at the registry's named ceiling. A pen is released empty
# and, separately, holding a nested tree, so a release proven only on an empty directory cannot be
# mistaken for one that sweeps.
#
# WHAT IT CANNOT REACH, named rather than implied. The prefix check inside the release is defense
# in depth and is unreachable from the script surface: the registry holds the path the runtime
# itself composed, and no `.rish` line can hand it another. The KIND check beside it IS reachable,
# so that one is proven from both sides -- a pen replaced by a file refuses out loud and turns the
# run's exit nonzero, while an untouched pen leaves the exit alone.
#
# READINGS: `leg <name>=ok|FAULT`, then `legs=N faults=N` and a `verdict=` line.
set -eu

root=$(cd "$(dirname "$0")/../../.." && pwd -P)
cd "$root"
rishi=${RISHI_BIN:-rishi/bin/rishi}
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
legs=0
faults=0
note() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then echo "leg $1=ok"
  else echo "leg $1=FAULT want=$2 got=$3"; faults=$((faults + 1)); fi
}
yn() { if [ "$1" = 0 ]; then echo yes; else echo no; fi; }
# Every pen path this run is told about, so the litter leg reads its own making rather than the
# shared root's whole population.
made_paths=""
keep() { [ -n "$1" ] && made_paths="$made_paths $1"; }

# ---- a clean run: the path is absolute, wears the prefix, carries the label, and is gone after
cat > "$pen/clean.rish" <<'RISH'
let p = make-pen "control_clean"
say "PEN:${p}"
RISH
out=$("$rishi" run "$pen/clean.rish" 2>&1 || true)
made=$(printf '%s\n' "$out" | sed -n 's/^PEN://p')
keep "$made"
note clean_absolute yes "$(case "$made" in /*) echo yes;; *) echo no;; esac)"
note clean_wears_prefix yes "$(case "$made" in */rishi-pen-*) echo yes;; *) echo no;; esac)"
note clean_carries_label yes "$(case "$made" in *control_clean*) echo yes;; *) echo no;; esac)"
note clean_released no "$([ -d "$made" ] && echo yes || echo no)"

# ---- a refusal with a NON-EMPTY pen standing: the tree goes too, and the exit stays the assert's
cat > "$pen/refuse.rish" <<'RISH'
let p = make-pen "control_refusal"
say "PEN:${p}"
let fill = run ["sh" "-c" "mkdir -p ${p}/a/b/c && head -c 4096 /dev/zero > ${p}/a/b/c/f"]
assert fill.ok else "control: the pen must fill"
assert 1 == 2 else "control: the deliberate refusal"
RISH
out=$("$rishi" run "$pen/refuse.rish" 2>&1 || true)
code=0; "$rishi" run "$pen/refuse.rish" >/dev/null 2>&1 || code=$?
made=$(printf '%s\n' "$out" | sed -n 's/^PEN://p')
keep "$made"
note refusal_said yes "$(printf '%s' "$out" | grep -q 'the deliberate refusal' && echo yes || echo no)"
note refusal_exit 1 "$code"
note refusal_released no "$([ -d "$made" ] && echo yes || echo no)"

# ---- `exit` with a pen standing: the runtime's own stop path releases too
cat > "$pen/exitpath.rish" <<'RISH'
let p = make-pen "control_exit"
say "PEN:${p}"
exit 3
RISH
out=$("$rishi" run "$pen/exitpath.rish" 2>&1 || true)
code=0; "$rishi" run "$pen/exitpath.rish" >/dev/null 2>&1 || code=$?
made=$(printf '%s\n' "$out" | sed -n 's/^PEN://p')
keep "$made"
note exit_code_kept 3 "$code"
note exit_released no "$([ -d "$made" ] && echo yes || echo no)"

# ---- TERM mid-run: the signal path releases, which is the one an unattended loop actually meets
cat > "$pen/sig.rish" <<'RISH'
let p = make-pen "control_signal"
say "PEN:${p}"
let fill = run ["sh" "-c" "mkdir -p ${p}/x && head -c 1024 /dev/zero > ${p}/x/f"]
assert fill.ok else "control: fill"
let slow = run ["sh" "-c" "sleep 30"]
RISH
"$rishi" run "$pen/sig.rish" > "$pen/sig.out" 2>&1 &
sig_pid=$!
tries=0
made=""
while [ "$tries" -lt 100 ]; do
  made=$(sed -n 's/^PEN://p' "$pen/sig.out" 2>/dev/null || true)
  [ -n "$made" ] && [ -d "$made" ] && break
  tries=$((tries + 1))
  sleep 0.1
done
keep "$made"
note signal_pen_stood yes "$([ -n "$made" ] && [ -d "$made" ] && echo yes || echo no)"
kill -TERM "$sig_pid" 2>/dev/null || true
wait "$sig_pid" 2>/dev/null || true
note signal_released no "$([ -d "$made" ] && echo yes || echo no)"

# ---- the label wall, from both sides
refuse_label() {
  printf 'let p = make-pen "%s"\nsay p\n' "$1" > "$pen/lab.rish"
  "$rishi" run "$pen/lab.rish" 2>&1 | grep -q 'PenLabelUnsafe' && echo yes || echo no
}
note label_dotdot_refused yes "$(refuse_label '../escape')"
note label_slash_refused yes "$(refuse_label 'a/b')"
note label_empty_refused yes "$(refuse_label '')"
note label_space_refused yes "$(refuse_label 'has space')"
note label_dot_refused yes "$(refuse_label 'a.b')"
long65=$(printf 'a%.0s' $(seq 1 65))
long64=$(printf 'a%.0s' $(seq 1 64))
note label_65_refused yes "$(refuse_label "$long65")"
printf 'let p = make-pen "%s"\nsay "PEN:${p}"\n' "$long64" > "$pen/lab64.rish"
out=$("$rishi" run "$pen/lab64.rish" 2>&1 || true)
note label_64_accepted yes "$(printf '%s' "$out" | grep -q '^PEN:/' && echo yes || echo no)"

# ---- TMPDIR is honored, and released there too
mkdir -p "$pen/root"
cat > "$pen/tmpdir.rish" <<'RISH'
let p = make-pen "control_root"
say "PEN:${p}"
RISH
out=$(TMPDIR="$pen/root" "$rishi" run "$pen/tmpdir.rish" 2>&1 || true)
made=$(printf '%s\n' "$out" | sed -n 's/^PEN://p')
note tmpdir_honored yes "$(case "$made" in "$pen/root"/*) echo yes;; *) echo no;; esac)"
note tmpdir_released no "$([ -d "$made" ] && echo yes || echo no)"
note tmpdir_root_survives yes "$([ -d "$pen/root" ] && echo yes || echo no)"

# ---- two pens in one run stand apart, and both go
cat > "$pen/two.rish" <<'RISH'
let a = make-pen "control_two_a"
let b = make-pen "control_two_b"
say "PEN:${a}"
say "PEN:${b}"
RISH
out=$("$rishi" run "$pen/two.rish" 2>&1 || true)
first=$(printf '%s\n' "$out" | sed -n 's/^PEN://p' | sed -n 1p)
second=$(printf '%s\n' "$out" | sed -n 's/^PEN://p' | sed -n 2p)
keep "$first"
keep "$second"
note two_pens_distinct yes "$([ "$first" != "$second" ] && echo yes || echo no)"
standing=no
[ -d "$first" ] && standing=yes
[ -d "$second" ] && standing=yes
note two_pens_released no "$standing"

# ---- the registry's named ceiling, from both sides: four stand, the fifth refuses
cat > "$pen/four.rish" <<'RISH'
let a = make-pen "control_cap_a"
let b = make-pen "control_cap_b"
let c = make-pen "control_cap_c"
let d = make-pen "control_cap_d"
say "PEN:${a}"
RISH
out=$("$rishi" run "$pen/four.rish" 2>&1 || true)
note cap_four_accepted yes "$(printf '%s' "$out" | grep -q '^PEN:/' && echo yes || echo no)"
cat > "$pen/five.rish" <<'RISH'
let a = make-pen "control_cap_a"
let b = make-pen "control_cap_b"
let c = make-pen "control_cap_c"
let d = make-pen "control_cap_d"
let e = make-pen "control_cap_e"
say "PEN:${e}"
RISH
out=$("$rishi" run "$pen/five.rish" 2>&1 || true)
note cap_fifth_refused yes "$(printf '%s' "$out" | grep -q 'TooManyCleanupPaths' && echo yes || echo no)"

# ---- the KIND check, from both sides: a pen replaced by a FILE refuses out loud
cat > "$pen/kind.rish" <<'RISH'
let p = make-pen "control_kind"
say "PEN:${p}"
let swap = run ["sh" "-c" "rmdir ${p} && : > ${p}"]
assert swap.ok else "control: the swap must land"
RISH
# ONE run gives both readings: the message on the captured stream and the exit code beside it. Two
# runs would leave two swapped files, and the second run's path was discarded by `>/dev/null` --
# which is how this block first left litter behind while asserting it had none.
code=0
out=$("$rishi" run "$pen/kind.rish" 2>&1) || code=$?
kind_path=$(printf '%s\n' "$out" | sed -n 's/^PEN://p')
keep "$kind_path"
note kind_change_refused yes "$(printf '%s' "$out" | grep -q 'path changed kind' && echo yes || echo no)"
note kind_change_exit 1 "$code"
# THE SWAPPED FILE IS REMOVED BY ITS EXACT PATH, never by a glob under the shared root. The release
# refused it, which is the leg above, so a plain file stands where the pen did -- and a
# `rm -f /tmp/rishi-pen-control_kind-*` would reach a PEER's file of the same shape on a pier eight
# ships share. That is `shared_pen`'s subject, and it caught this line at its ceiling.
[ -n "$kind_path" ] && [ -f "$kind_path" ] && rm -f "$kind_path"

# ---- a clean run leaves the exit alone, which is the other side of the leg above
cat > "$pen/quiet.rish" <<'RISH'
let p = make-pen "control_quiet"
RISH
code=0; "$rishi" run "$pen/quiet.rish" >/dev/null 2>&1 || code=$?
note clean_exit_untouched 0 "$code"

# ---- nothing THIS RUN made is left standing. The paths are the ones this run captured rather
# than a glob under the shared root: eight ships share this pier, so a name search would read a
# peer's live control as our litter and refuse a run that was clean. That is the same reading
# `shared_pen` gates on the writing side, asked on the reading side.
left=0
for made_path in $made_paths; do
  [ -e "$made_path" ] && left=$((left + 1))
done
note no_litter 0 "$left"

echo "legs=$legs"
echo "faults=$faults"
if [ "$faults" = 0 ]; then echo "verdict=ok"; else echo "verdict=faults"; fi
