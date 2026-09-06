#!/bin/sh
# tools/fixtures/s/signal_trap_control.sh -- what a shell script does after a signal it trapped.
#
# WHY. POSIX runs a trapped signal's handler and then RESUMES the script at the point the signal
# arrived. So `trap 'cleanup' EXIT INT TERM` reads as "clean up and stop" and behaves as "clean up
# and carry on": the script continues, holding a scratch directory its own handler just removed.
# This tree wrote that shape 142 times and the stopping shape once at `15f99e1fe0`, and `shell_portable.sh`'s own
# header taught the first form beside `lock_acquire` until 20260906.
#
# WHAT THIS CONTROL PROVES, on metal, in a pen, in both directions:
#
#   documented_idiom_continues  -- the tree's documented shape without `set -e`: after a TERM the
#                                 script runs all the way to its end, its scratch gone.
#   count_understated           -- the same shape wearing a scan's clothes: the total it prints
#                                 after a TERM sits BELOW the true total. That is the reading a
#                                 ratchet welcomes as green.
#   set_e_dies_late             -- the same shape WITH `set -e`: the shell ends at the first write
#                                 after the handler, so the cost is a lost verdict rather than a
#                                 wrong number -- a milder fault, and a different one.
#   lock_taken_before_signal    -- the runner's exact shape holds its lock while it works.
#   lock_freed_on_signal        -- and its handler frees that lock.
#   lock_window_not_exploitable -- yet the process has already ended a second later, so a second
#                                 pass meets a free lock only once the first has finished. This
#                                 leg records a NEGATIVE result on purpose. The first draft of
#                                 this control claimed a checkout's mutual exclusion stands free
#                                 while a pass runs on, and the pen refused it: a trap runs once
#                                 the current command completes, and the runner's next command is
#                                 the write that ends it. The severity is a lost verdict, kept
#                                 here so a later reader inherits the measured version.
#   corrected_idiom_stops       -- signal traps that call `exit`: the script stops where the
#                                 signal landed, cleanup runs exactly once, and the code is 143.
#   pen_innocent                -- every pen script above, unsignalled, answers correctly.
#
# THE PEN-INNOCENT LEG EARNS ITS KEEP. A pen script that was simply broken would show the same
# understated count with a signal and without one, leaving every refusal above proving nothing.
#
# Instrument: `sh` and `kill`, both POSIX-granted. The pen is a fixed name under the host
# temporary directory, removed on exit; `mktemp` stays out, being absent from POSIX since 2008.
#
# Usage:  sh tools/fixtures/s/signal_trap_control.sh
#
# Read against: construction/REDS.md row %485
# Guards:       tools/fixtures/s/signal_trap_scan.sh
set -u

PEN="${TMPDIR:-/tmp}/signal_trap_control_pen"
# This control's own trap is the CORRECTED shape, which is the point: a control proving a bug
# must not carry the bug. The signal traps exit; the EXIT trap cleans up exactly once.
trap 'rm -rf "$PEN"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

rm -rf "$PEN"; mkdir -p "$PEN"

faults=0
proven=0

claim() {
  # claim NAME EXPECTED ACTUAL
  proven=$((proven + 1))
  if [ "$2" = "$3" ]; then
    echo "ok $1 = $3"
  else
    echo "FAULT $1: wanted '$2' got '$3'"
    faults=$((faults + 1))
  fi
}

# ---- the pen scripts ------------------------------------------------------------------------
# Each writes one row per tick into its own scratch, sleeping between ticks so a signal has
# somewhere to land. `rows` is what the script believes it counted; `ticks_done` is what it
# actually reached. A signal that removes the scratch drives the two apart.

# The tree's documented idiom, no `set -e`.
cat > "$PEN/documented.sh" <<'EOS'
#!/bin/sh
scratch="$1"; total="$2"; out="$3"
rm -rf "$scratch"; mkdir -p "$scratch"
trap 'rm -rf "$scratch"' EXIT INT TERM
i=0
while [ "$i" -lt "$total" ]; do
  echo "finding $i" >> "$scratch/rows" 2>/dev/null
  i=$((i + 1))
  sleep 0.1
done
rows=$(wc -l < "$scratch/rows" 2>/dev/null || echo 0)
printf 'ticks_done=%s rows=%s\n' "$i" "$(echo "$rows" | tr -d ' ')" > "$out"
EOS

# The same idiom WITH `set -e`.
cat > "$PEN/setexit.sh" <<'EOS'
#!/bin/sh
set -eu
scratch="$1"; total="$2"; out="$3"
rm -rf "$scratch"; mkdir -p "$scratch"
trap 'rm -rf "$scratch"' EXIT INT TERM
i=0
while [ "$i" -lt "$total" ]; do
  echo "finding $i" >> "$scratch/rows"
  i=$((i + 1))
  sleep 0.1
done
printf 'ticks_done=%s\n' "$i" > "$out"
EOS

# The runner's exact shape: scratch AND a lock directory, released in the same handler.
cat > "$PEN/locked.sh" <<'EOS'
#!/bin/sh
set -eu
scratch="$1"; total="$2"; out="$3"; lock="$4"
rm -rf "$scratch"; mkdir -p "$scratch"
mkdir "$lock"; printf '%s\n' "$$" > "$lock/pid"
trap 'rm -rf "$scratch"; rm -rf "$lock"' EXIT INT TERM
printf 'alive\n' > "$scratch/started"
i=0
while [ "$i" -lt "$total" ]; do
  sleep 0.4
  echo "finding $i" >> "$scratch/rows"
  i=$((i + 1))
done
printf 'ticks_done=%s\n' "$i" > "$out"
EOS

# The corrected shape: signal traps exit, the EXIT trap cleans up once.
cat > "$PEN/corrected.sh" <<'EOS'
#!/bin/sh
scratch="$1"; total="$2"; out="$3"
rm -rf "$scratch"; mkdir -p "$scratch"
trap 'rm -rf "$scratch"; echo cleaned >> '"$4"'' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
i=0
while [ "$i" -lt "$total" ]; do
  echo "finding $i" >> "$scratch/rows" 2>/dev/null
  i=$((i + 1))
  sleep 0.1
done
printf 'ticks_done=%s\n' "$i" > "$out"
EOS

# ---- leg: documented_idiom_continues ---------------------------------------------------------
# TERM arrives a third of the way in. If the handler stopped the script, `ticks_done` would sit
# near the tick the signal landed on. It does not: the script runs to the end.
sh "$PEN/documented.sh" "$PEN/s1" 30 "$PEN/o1" &
p1=$!
sleep 1
kill -TERM "$p1" 2>/dev/null
wait "$p1" 2>/dev/null
d1=$(sed -n 's/.*ticks_done=\([0-9]*\).*/\1/p' "$PEN/o1" 2>/dev/null)
: "${d1:=absent}"
claim documented_idiom_continues 30 "$d1"

# ---- leg: count_understated -------------------------------------------------------------------
# The same run's OWN reported total. Thirty findings were reached; the count it prints comes from
# a scratch file its handler deleted, so it reports a number a ratchet would welcome.
r1=$(sed -n 's/.*rows=\([0-9]*\).*/\1/p' "$PEN/o1" 2>/dev/null)
: "${r1:=absent}"
claim count_understated 0 "$r1"

# ---- leg: set_e_dies_late ---------------------------------------------------------------------
# With `set -e` the first write after the handler fails and the shell exits, so no output file
# is written at all. The fault is a lost verdict rather than a wrong count.
sh "$PEN/setexit.sh" "$PEN/s2" 30 "$PEN/o2" &
p2=$!
sleep 1
kill -TERM "$p2" 2>/dev/null
wait "$p2" 2>/dev/null
if [ -f "$PEN/o2" ]; then d2=present; else d2=absent; fi
claim set_e_dies_late absent "$d2"

# ---- leg: lock_freed_on_signal, and the window that is not there ----------------------------
# The runner's shape, with a long step so a signal has somewhere to land. Two readings, and the
# second is the one that bounds the severity: the lock IS freed by the handler, AND the process
# is already gone a second later, because the command after the handler writes to the scratch
# the handler removed and `set -e` ends the shell there. A second pass cannot use the gap.
sh "$PEN/locked.sh" "$PEN/s3" 30 "$PEN/o3" "$PEN/lock.d" &
p3=$!
sleep 1
if [ -d "$PEN/lock.d" ]; then taken=taken; else taken=absent; fi
claim lock_taken_before_signal taken "$taken"
kill -TERM "$p3" 2>/dev/null
sleep 1
if [ -d "$PEN/lock.d" ]; then held=held; else held=freed; fi
claim lock_freed_on_signal freed "$held"
if kill -0 "$p3" 2>/dev/null; then alive=alive; else alive=gone; fi
claim lock_window_not_exploitable gone "$alive"
wait "$p3" 2>/dev/null

# ---- leg: corrected_idiom_stops ------------------------------------------------------------------
# Signal traps that exit. The script stops where the signal landed, so `ticks_done` never
# reaches the total, and the cleanup ran exactly once.
sh "$PEN/corrected.sh" "$PEN/s4" 30 "$PEN/o4" "$PEN/cleanlog" &
p4=$!
sleep 1
kill -TERM "$p4" 2>/dev/null
wait "$p4" 2>/dev/null
code4=$?
if [ -f "$PEN/o4" ]; then d4=present; else d4=absent; fi
claim corrected_idiom_stops absent "$d4"
claim corrected_exit_code 143 "$code4"
cleaned=$(wc -l < "$PEN/cleanlog" 2>/dev/null | tr -d ' ')
: "${cleaned:=0}"
claim corrected_cleanup_ran_once 1 "$cleaned"

# ---- leg: pen_innocent ----------------------------------------------------------------------
# Every pen script above, unsignalled, answers correctly. Without this the refusals prove nothing.
sh "$PEN/documented.sh" "$PEN/c1" 5 "$PEN/co1"
c1=$(sed -n 's/.*rows=\([0-9]*\).*/\1/p' "$PEN/co1" 2>/dev/null)
: "${c1:=absent}"
claim pen_innocent_documented_counts 5 "$c1"

sh "$PEN/setexit.sh" "$PEN/c2" 5 "$PEN/co2"
c2=$(sed -n 's/.*ticks_done=\([0-9]*\).*/\1/p' "$PEN/co2" 2>/dev/null)
: "${c2:=absent}"
claim pen_innocent_set_e_finishes 5 "$c2"

sh "$PEN/corrected.sh" "$PEN/c4" 5 "$PEN/co4" "$PEN/cleanlog2"
c4=$(sed -n 's/.*ticks_done=\([0-9]*\).*/\1/p' "$PEN/co4" 2>/dev/null)
: "${c4:=absent}"
claim pen_innocent_corrected_finishes 5 "$c4"

# ---- the scan's own two directions -------------------------------------------------------------
# A guard that only ever reads a healthy tree cannot be told from one that reads nothing.
SCAN="$(CDPATH= cd -- "$(dirname "$0")" && pwd)/signal_trap_scan.sh"
if [ -f "$SCAN" ]; then
  mkdir -p "$PEN/tree/tools/fixtures/s" "$PEN/tree/rishi/bin"
  : > "$PEN/tree/rishi/bin/rishi"
  ( cd "$PEN/tree" && git init -q . && git config user.email a@b.c && git config user.name t )

  # clean: one trap, the corrected shape
  printf '#!/bin/sh\ntrap %s EXIT\ntrap %s TERM\n' "'rm -rf \$p'" "'exit 143'" > "$PEN/tree/tools/fixtures/s/a.sh"
  ( cd "$PEN/tree" && git add -A && git commit -qm one )
  out=$(cd "$PEN/tree" && sh "$SCAN" 2>&1)
  got=$(echo "$out" | sed -n 's/^nonexiting \([0-9]*\)$/\1/p')
  : "${got:=absent}"
  claim scan_clean_reads_zero 0 "$got"

  # planted: the documented idiom, and one releasing a lock
  printf '#!/bin/sh\ntrap %s EXIT INT TERM\n' "'rm -rf \$p'" > "$PEN/tree/tools/fixtures/s/b.sh"
  printf '#!/bin/sh\ntrap %s EXIT INT TERM\n' "'rm -rf \$p; lock_release \$l'" > "$PEN/tree/tools/fixtures/s/c.sh"
  ( cd "$PEN/tree" && git add -A && git commit -qm two )
  out=$(cd "$PEN/tree" && sh "$SCAN" 2>&1)
  got=$(echo "$out" | sed -n 's/^nonexiting \([0-9]*\)$/\1/p')
  : "${got:=absent}"
  claim scan_bites_planted 2 "$got"
  gotl=$(echo "$out" | sed -n 's/^lock_releasing \([0-9]*\)$/\1/p')
  : "${gotl:=absent}"
  claim scan_bites_lock_release 1 "$gotl"

  # removed: the reading returns, so the bite was the plant rather than the pen
  rm -f "$PEN/tree/tools/fixtures/s/b.sh" "$PEN/tree/tools/fixtures/s/c.sh"
  ( cd "$PEN/tree" && git add -A && git commit -qm three )
  out=$(cd "$PEN/tree" && sh "$SCAN" 2>&1)
  got=$(echo "$out" | sed -n 's/^nonexiting \([0-9]*\)$/\1/p')
  : "${got:=absent}"
  claim scan_returns_after_removal 0 "$got"
else
  echo "FAULT scan_absent: no scan at $SCAN"
  faults=$((faults + 1))
fi

echo "proven $proven"
echo "faults $faults"
[ "$faults" -eq 0 ] || exit 1
echo "signal_trap_control GREEN"
