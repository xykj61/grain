#!/bin/sh
# tools/fixtures/ales_sing_lock.sh -- one sing of the Lotus choir at a time.
#
# WHY. tools/al/ales_suite_witness.rish clears `lotus/bin` and then has 240 witnesses build into it.
# Two sings at once therefore delete each other's binaries mid-run, and the second one reports a
# per-rung RED naming a module that is perfectly sound. That happened on `20260825.132121`, on the
# lap the choir was written: a second timing run overlapped a single-witness measurement and refused
# at `ales_compress_witness` after 28 seconds. A false RED is worse than a slow guard, because
# Standfast stops the line for it and the line was never broken.
#
# The shape is `tools/fixtures/sow_project.sh`'s, and the reasoning there holds here word for word:
# a lock held in a DIRECTORY, since `mkdir` is atomic on every POSIX filesystem where a two-step
# test-then-create is not; a REFUSAL rather than a wait, since a queued sing would still hand its
# reader verdicts from a tree that changed under them; and a lock left by a killed run naming its
# dead pid, so the next sing clears it rather than wedging forever.
#
# It lives in its own file rather than inside the choir because the choir is Rishi and a Rishi
# `for-each` cannot hold a shell trap across its rungs -- and because REDS %215 is this tree's
# standing lesson that a body shared by copying drifts. One body, called twice.
#
# ALES_SING_LOCK_DIR (default lotus/.sing.lock) names the lock, so a witness can prove both paths
# without touching the real one.
#
# USAGE
#   sh tools/fixtures/ales_sing_lock.sh take   # 0 taken, 3 already held
#   sh tools/fixtures/ales_sing_lock.sh free   # always 0; freeing an unheld lock is a no-op
#
# Run from the repository root.
set -eu

LOCK="${ALES_SING_LOCK_DIR:-lotus/.sing.lock}"

case "${1:-}" in
  take)
    mkdir -p "$(dirname "$LOCK")"
    if ! mkdir "$LOCK" 2>/dev/null; then
      holder=$(cat "$LOCK/pid" 2>/dev/null || echo unknown)
      if [ "$holder" != unknown ] && ! kill -0 "$holder" 2>/dev/null; then
        echo "ales-sing-lock: clearing a lock left by dead pid $holder" >&2
        rm -rf "$LOCK"
        mkdir "$LOCK" 2>/dev/null || { echo "LOCK_REFUSED reason=cannot_take"; exit 3; }
      else
        echo "LOCK_REFUSED reason=held holder=${holder}"
        echo "ales-sing-lock: a sing is already running -- lotus/bin is cleared and rebuilt in place," >&2
        echo "ales-sing-lock: so a second sing would report a RED naming a module that is sound" >&2
        exit 3
      fi
    fi
    printf '%s\n' "$$" > "$LOCK/pid"
    echo "LOCK_TAKEN dir=${LOCK}"
    ;;
  free)
    rm -rf "$LOCK"
    echo "LOCK_FREED dir=${LOCK}"
    ;;
  *)
    echo "LOCK_REFUSED reason=unknown_word word=${1:-}"
    echo "refused: want take or free" >&2
    exit 2
    ;;
esac
