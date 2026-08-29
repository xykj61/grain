#!/bin/sh
# Two-sided host control for Rishi's bounded child and cleanup surfaces.
set -eu

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
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
RISHI_BIN=${RISHI_TEST_BIN:-$ROOT/rishi/bin/rishi}
BENCH=$(mktemp -d "${TMPDIR:-/tmp}/grain-rishi-process.XXXXXX")
cleanup() {
  rm -rf "$BENCH"
}
trap cleanup EXIT HUP INT TERM

run_at_bench() {
  (cd "$BENCH" && exec env RISHI_TEST_BIN="$RISHI_BIN" RISHI_SPLIT_SCRIPT="$ROOT/rishi/tests/fixtures/process_split.rish" RISHI_RELAY_SCRIPT="$ROOT/rishi/tests/fixtures/process_relay_chunks.sh" "$RISHI_BIN" run "$@")
}

marker="grain-rishi-overflow-$$"
run_at_bench "$ROOT/rishi/tests/run_bounded.rish" "$marker" >"$BENCH/positive.stdout" 2>"$BENCH/positive.stderr"
grep -F 'run-bounded held.' "$BENCH/positive.stdout" >/dev/null
if grep -F 'bounded stdout' "$BENCH/positive.stdout" >/dev/null || grep -F 'bounded stderr' "$BENCH/positive.stderr" >/dev/null; then
  echo "RED: default run-bounded unexpectedly relayed a child stream" >&2
  exit 1
fi
test ! -e "$BENCH/should-not-exist"
test "$(stat -f '%Lp' "$BENCH/cat.out")" = 600
test "$(stat -f '%Lp' "$BENCH/cat.err")" = 600

run_at_bench "$ROOT/rishi/tests/run_bounded_relay.rish" >"$BENCH/relay.stdout" 2>"$BENCH/relay.stderr"
cmp "$BENCH/relay.stdout" "$BENCH/relay.out" >/dev/null
cmp "$BENCH/relay.stderr" "$BENCH/relay.err" >/dev/null
test "$(stat -f '%Lp' "$BENCH/relay.out")" = 600
test "$(stat -f '%Lp' "$BENCH/relay.err")" = 600

run_at_bench "$ROOT/rishi/tests/run_bounded_relay_exact.rish" >"$BENCH/relay-exact.stdout" 2>"$BENCH/relay-exact.stderr"
cmp "$BENCH/relay-exact.stdout" "$BENCH/relay-exact.out" >/dev/null
test ! -s "$BENCH/relay-exact.stderr"
test "$(wc -c < "$BENCH/relay-exact.stdout" | tr -d ' ')" -eq 8

relay_marker="grain-rishi-relay-over-$$"
run_at_bench "$ROOT/rishi/tests/run_bounded_relay_over.rish" "$relay_marker" >"$BENCH/relay-over.stdout" 2>"$BENCH/relay-over.stderr"
cmp "$BENCH/relay-over.stdout" "$BENCH/relay-over.out" >/dev/null
test ! -s "$BENCH/relay-over.stderr"
test "$(wc -c < "$BENCH/relay-over.stdout" | tr -d ' ')" -eq 8193

if run_at_bench "$ROOT/rishi/tests/run_bounded_relay_bad_type.rish" >"$BENCH/relay-type.stdout" 2>"$BENCH/relay-type.stderr"; then
  echo "RED: non-boolean relay authority was accepted" >&2
  exit 1
fi
grep -F 'RunBoundedNeedsBool' "$BENCH/relay-type.stderr" >/dev/null
test ! -e "$BENCH/relay-type.out"
test ! -e "$BENCH/relay-type.err"

if run_at_bench "$ROOT/rishi/tests/run_bounded_input_over.rish" >"$BENCH/input.stdout" 2>"$BENCH/input.stderr"; then
  echo "RED: just-over stdin was accepted" >&2
  exit 1
fi
grep -F 'ProcessInputTooLong' "$BENCH/input.stderr" >/dev/null
test ! -e "$BENCH/input-over.out"
test ! -e "$BENCH/input-over.err"

if run_at_bench "$ROOT/rishi/tests/run_bounded_path_over.rish" >"$BENCH/path.stdout" 2>"$BENCH/path.stderr"; then
  echo "RED: upward output path was accepted" >&2
  exit 1
fi
grep -F 'ProcessPathUnsafe' "$BENCH/path.stderr" >/dev/null
test ! -e "$(dirname "$BENCH")/escape.out"

printf 'kept\n' >"$BENCH/symlink-target"
ln -s symlink-target "$BENCH/linked.out"
if run_at_bench "$ROOT/rishi/tests/run_bounded_path_symlink.rish" >"$BENCH/link.stdout" 2>"$BENCH/link.stderr"; then
  echo "RED: symlink output path was accepted" >&2
  exit 1
fi
grep -F 'ProcessPathSymlink' "$BENCH/link.stderr" >/dev/null
test "$(cat "$BENCH/symlink-target")" = kept
rm "$BENCH/linked.out"

mkdir "$BENCH/run.lock"
if run_at_bench "$ROOT/rishi/tests/cleanup_normal.rish" >"$BENCH/held.stdout" 2>"$BENCH/held.stderr"; then
  echo "RED: an existing lock was accepted" >&2
  exit 1
fi
grep -F 'LockAlreadyHeld' "$BENCH/held.stderr" >/dev/null
test -d "$BENCH/run.lock"
rmdir "$BENCH/run.lock"

ln -s symlink-target "$BENCH/run.lock"
if run_at_bench "$ROOT/rishi/tests/cleanup_symlink.rish" >"$BENCH/lock-link.stdout" 2>"$BENCH/lock-link.stderr"; then
  echo "RED: symlink lock was accepted" >&2
  exit 1
fi
grep -F 'ProcessPathSymlink' "$BENCH/lock-link.stderr" >/dev/null
test -L "$BENCH/run.lock"
rm "$BENCH/run.lock"

run_at_bench "$ROOT/rishi/tests/cleanup_normal.rish" >/dev/null
test ! -e "$BENCH/run.lock"
if run_at_bench "$ROOT/rishi/tests/cleanup_failure.rish" >"$BENCH/failure.stdout" 2>"$BENCH/failure.stderr"; then
  echo "RED: planted body failure was accepted" >&2
  exit 1
fi
test ! -e "$BENCH/run.lock"

set +e
run_at_bench "$ROOT/rishi/tests/cleanup_exit.rish" >"$BENCH/exit.stdout" 2>"$BENCH/exit.stderr"
exit_code=$?
set -e
test "$exit_code" -eq 111
test ! -e "$BENCH/run.lock"

signal_case() {
  signal_name=$1
  (cd "$BENCH" && exec env RISHI_TEST_BIN="$RISHI_BIN" RISHI_SPLIT_SCRIPT="$ROOT/rishi/tests/fixtures/process_split.rish" "$RISHI_BIN" run "$ROOT/rishi/tests/cleanup_signal.rish") >"$BENCH/signal-$signal_name.stdout" 2>"$BENCH/signal-$signal_name.stderr" &
  rishi_pid=$!
  turns=0
  while test ! -d "$BENCH/run.lock" && test "$turns" -lt 100; do
    sleep 0.02
    turns=$((turns + 1))
  done
  test -d "$BENCH/run.lock"
  kill -"$signal_name" "$rishi_pid"
  set +e
  wait "$rishi_pid"
  signal_code=$?
  set -e
  test "$signal_code" -eq 130
  test ! -e "$BENCH/run.lock"
}

for signal_name in HUP INT TERM; do
  signal_case "$signal_name"
done

echo "GREEN: bounded stdin/output, opt-in exact live relay, argv truth, overflow reap, safe paths, and exit/signal lock cleanup held."
