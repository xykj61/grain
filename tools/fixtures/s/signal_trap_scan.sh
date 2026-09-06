#!/bin/sh
# tools/fixtures/s/signal_trap_scan.sh -- how many trapped signals in this tree do not stop the
# script that trapped them.
#
# WHY. `trap 'cleanup' EXIT INT TERM` reads like "clean up and stop." It is not: POSIX runs the
# handler and RESUMES the script where the signal landed. So the script carries on with the
# scratch directory its own handler just deleted -- and if the handler also released a lock, it
# carries on holding nothing. The correct shape gives the signals their own trap that calls
# `exit`, letting the EXIT trap clean up exactly once.
#
#   trap 'rm -rf "$pen"' EXIT      # cleanup, once, however the script ends
#   trap 'exit 130' INT            # 128 + SIGINT
#   trap 'exit 143' TERM           # 128 + SIGTERM
#
# WHAT IT COUNTS, and the boundary of each reading.
#
#   traps_total       -- `trap` in COMMAND POSITION on a tracked `.sh` or `.rish` line whose
#                        signal list names INT or TERM. Command position rather than anywhere on
#                        the line, so a trap quoted inside a string or a heredoc is not counted
#                        as one this tree runs.
#   exiting           -- of those, whose handler contains `exit` as a word. A handler naming a
#                        path that contains the letters "exit" would read as exiting; measured
#                        20260906 there is no such path, and the direction of that error is to
#                        UNDER-report the defect, which is the direction to be wrong in.
#   nonexiting        -- traps_total minus exiting. The population.
#   lock_releasing    -- of the nonexiting, whose handler frees a lock. This is the severe
#                        subset: the script continues, briefly, having released the mutual
#                        exclusion its own checkout depends on. GATED at zero.
#   files_without_set_e -- files carrying a nonexiting signal trap and no `set -e`. In these the
#                        script does not merely lose its verdict; it RUNS TO COMPLETION and
#                        prints a total computed from a directory that is gone.
#
# THE SELF-EXCLUSION, named rather than silent. `signal_trap_control.sh` writes pen scripts as
# heredocs, and those heredocs contain the broken idiom on purpose -- it is what the control
# proves. Counting them would make the defect un-repairable, since removing them would remove
# the proof. One path, excluded by name, and the count of exclusions is printed.
#
# WHERE IT READS. The git repository containing the current working directory, so a pen tree
# under test is scanned rather than the tree this file happens to live in.
#
# Instrument: `git grep`, `sed`, `grep` -- all present wherever git is.
#
# Usage:  sh tools/fixtures/s/signal_trap_scan.sh
#
# Read against: construction/REDS.md row %485
# Refusals proven by: tools/fixtures/s/signal_trap_control.sh
set -u

trap 'rm -rf "$WORK"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
WORK="${TMPDIR:-/tmp}/signal_trap_scan_work"
rm -rf "$WORK"; mkdir -p "$WORK"

git rev-parse --show-toplevel >/dev/null 2>&1 || {
  echo "refused: not inside a git repository" >&2; exit 2; }

EXCLUDE='tools/fixtures/s/signal_trap_control.sh'

echo "signal_trap_scan v1"

# Every command-position trap line whose signal list names INT or TERM, with its path.
git grep -n -E "^[[:space:]]*trap[[:space:]]" -- '*.sh' '*.rish' 2>/dev/null \
  | grep -E "(INT|TERM)" > "$WORK/all" || true

excluded=$(grep -c "^$EXCLUDE:" "$WORK/all" 2>/dev/null || true)
: "${excluded:=0}"
grep -v "^$EXCLUDE:" "$WORK/all" > "$WORK/hits" 2>/dev/null || : > "$WORK/hits"
echo "excluded_self $excluded"

total=$(wc -l < "$WORK/hits" | tr -d ' ')
echo "traps_total $total"

# Strip `path:line:` then the leading `trap ` then the trailing signal list, leaving the handler.
sed -E 's/^[^:]*:[0-9]+://' "$WORK/hits" \
  | sed -E 's/^[[:space:]]*trap[[:space:]]+//' \
  | sed -E 's/[[:space:]]+[A-Z][A-Z ]*$//' > "$WORK/handlers"

exiting=$(grep -cw exit "$WORK/handlers" 2>/dev/null || true)
: "${exiting:=0}"
echo "exiting $exiting"
echo "nonexiting $((total - exiting))"

# The severe subset: a handler that frees a lock and does not exit.
paste -d'|' "$WORK/hits" "$WORK/handlers" 2>/dev/null > "$WORK/paired" || : > "$WORK/paired"
lockrel=0
: > "$WORK/lock_sites"
while IFS='|' read -r site handler; do
  [ -n "${handler:-}" ] || continue
  echo "$handler" | grep -qw exit && continue
  if echo "$handler" | grep -qE 'lock_release|rm -rf[^;]*lock'; then
    lockrel=$((lockrel + 1))
    echo "$site" | sed -E 's/:([0-9]+):.*/:\1/' >> "$WORK/lock_sites"
  fi
done < "$WORK/paired"
echo "lock_releasing $lockrel"
if [ "$lockrel" -gt 0 ]; then
  while read -r s; do echo "lock_site $s"; done < "$WORK/lock_sites"
fi

# Files carrying a nonexiting signal trap, and how many of those have no `set -e`.
: > "$WORK/files"
while IFS='|' read -r site handler; do
  [ -n "${handler:-}" ] || continue
  echo "$handler" | grep -qw exit && continue
  echo "$site" | sed -E 's/:[0-9]+:.*//' >> "$WORK/files"
done < "$WORK/paired"
sort -u "$WORK/files" > "$WORK/files_u" 2>/dev/null || : > "$WORK/files_u"
nfiles=$(wc -l < "$WORK/files_u" | tr -d ' ')
echo "files_with_nonexiting_trap $nfiles"

nosete=0
while read -r f; do
  [ -n "${f:-}" ] || continue
  [ -f "$f" ] || continue
  grep -qE '^[[:space:]]*set -[a-z]*e' "$f" || nosete=$((nosete + 1))
done < "$WORK/files_u"
echo "files_without_set_e $nosete"

if [ "$lockrel" -eq 0 ]; then
  echo "verdict ok"
else
  echo "verdict lock_released_without_exit"
  exit 1
fi
