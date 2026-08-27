#!/bin/sh
# SIGTERM probe for caravan_subscribe_poll_signal_witness.rish -- send the supervisor a real signal
# and report how it stopped, so the witness beside it can read the answer.
#
# WHY THIS IS A FILE AND NOT A STRING. This probe used to live as one 300-character shell
# string inside the witness, opening `rm -f A B && "$service" ... >"$out" 2>&1 & pid=$!`.
# In shell grammar `&` binds LOOSER than `&&`, so that backgrounds the whole AND-list as a
# single subshell and `$!` names the subshell rather than the service. `kill -TERM "$pid"`
# then killed the wrapper; the service was orphaned to init and went on running; the wrapper
# was gone instantly, so the wait loop fell through on its first check and `cat "$out"` read
# an output file two lines deep. The witness asserted on output the service had not finished
# writing, and reported RED about a supervisor that stops correctly every time (REDS %297).
#
# The sibling probe, caravan_subscribe_poll_source_crash.sh, had the shape right the whole
# time: one command per line, backgrounded alone. This file is that shape, and the reason a
# 300-character one-liner is worth splitting is that the fault was invisible inside it.
set -eu

service="$1"
delivery="$2"
sentinel="$3"
out="$4"

rm -f "$sentinel" "$out"

# Backgrounded ALONE on its own line, so $! names the service and nothing else.
"$service" "$delivery" "$sentinel" >"$out" 2>&1 &
super=$!

# invariant: the supervisor reads its stop flag at a cycle boundary, so the signal must land
# after at least one cycle has begun; 0.8s clears the source-ready pause with room to spare.
sleep 0.8
kill -TERM "$super"

# invariant: 24 quarter-seconds is the whole stop budget. A cycle here runs well under a
# second, so a stop that has not landed in six seconds is a stop that is not coming.
i=0
while kill -0 "$super" 2>/dev/null; do
  i=$((i + 1))
  if test "$i" -gt 24; then
    # A probe that gives up still owns what it started. Left alive, this supervisor keeps its
    # store and its sockets, and the NEXT run inherits them -- which is how a stale process
    # came to answer RevisionImmutable to a run that had done nothing wrong.
    # Children first, then the supervisor. A KILL on the parent never reaches what it
    # spawned, so reaping only the supervisor leaves its source-loop and fetcher-poll
    # orphaned to init -- the exact leak this block exists to prevent. pgrep -P asks by
    # PARENT, never by command text, because a -f pattern here would match this shell.
    for kid in $(pgrep -P "$super" 2>/dev/null || true); do
      kill -KILL "$kid" 2>/dev/null || true
    done
    kill -KILL "$super" 2>/dev/null || true
    wait "$super" 2>/dev/null || true
    exit 2
  fi
  sleep 0.25
done

super_exit=0
wait "$super" || super_exit=$?
echo "exit:${super_exit}"
cat "$out"
