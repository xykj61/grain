#!/bin/sh
# mantra_delivery_port_control.sh -- the concurrency leg REDS %700 asked for.
#
# THE FAULT THIS CATCHES IS INVISIBLE TO ONE RUN. `mantra/recall_tablecloth_query_delivery.rye`
# spoke over two port numbers written into the file, and a port is a name on the MACHINE rather
# than in a tree. Eight checkouts stand on this pier and every one of their roster passes runs the
# delivery selftest, so two ships reaching the same two ports read each other's datagrams. Run
# alone the selftest passed; run beside itself it refused about half the time, which is exactly the
# shape a hand cannot reproduce and a ledger row could only infer (REDS %700).
#
# So this control runs the selftest BESIDE ITSELF and counts refusals, and then proves it can make
# a sound: a pen copy with the ephemeral bind mutated back to a fixed port must refuse, or a clean
# reading here says nothing at all.
#
# Measured on metal `20260911` at load 14, eight at once: the elder binary 39 of 80 red, the
# repaired binary 0 of 80. Serially both read 0 of 120, which is why the roster never saw it.
set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT" || exit 1

SOURCE=mantra/recall_tablecloth_query_delivery.rye
ZIG=vendor/zig-toolchain/zig
RYE=rye/bin/rye

# Bounds, each named. CONCURRENT matches the pier's eight ships, because the fault scales with how
# many speakers share one port and a reading below the real number understates it. ROUNDS is the
# smallest count that carried the elder to a refusal on every trial run of this control.
CONCURRENT=8
ROUNDS=2
MUTANT_ROUNDS=1
FIXED_PORT=38490

PEN=$(mktemp -d "${TMPDIR:-/tmp}/mantra-port-XXXXXX") || exit 1
trap 'rm -rf "$PEN"' EXIT INT TERM

fail() {
  printf 'detail: %s\n' "$1"
  printf 'verdict=broken\n'
  exit 1
}

# The pen holds the module and every sibling it imports by bare name, because Zig refuses an
# import that escapes the root file's directory -- so a pen copy must carry its whole room.
mkdir -p "$PEN/src" || fail "pen not made"
cp mantra/*.rye "$PEN/src/" 2>/dev/null || fail "module room not copied"

build() {
  # $1 pen-relative source basename, $2 output path
  ( cd "$PEN/src" && RYE_ZIG="$ROOT/$ZIG" "$ROOT/$RYE" build "$1" -lc -femit-bin="$2" ) \
    >"$PEN/build-$1.log" 2>&1
}

build recall_tablecloth_query_delivery.rye "$PEN/clean" \
  || fail "the unmutated module did not build -- see $PEN/build log"

# THE MUTATION: the client's ephemeral bind becomes the fixed port the elder spelled. The line is
# found by its own neighbor rather than by a count, since `open_bound(0)` is written twice and a
# number here would drift the first time the file is edited above it.
mutant=$PEN/src/mutant.rye
awk -v port="$FIXED_PORT" '
  { line[NR] = $0 }
  END {
    hit = 0
    for (i = 1; i <= NR; i++) {
      if (line[i] ~ /open_bound\(0\)/ && (line[i + 1] ~ /bound_port\(fd\)/ || line[i + 2] ~ /bound_port\(fd\)/)) {
        sub(/open_bound\(0\)/, "open_bound(" port ")", line[i])
        hit++
      }
      print line[i]
    }
    if (hit != 1) exit 3
  }
' "$PEN/src/recall_tablecloth_query_delivery.rye" > "$mutant" || \
  fail "the client bind was not found exactly once -- the mutation has lost its target"

build mutant.rye "$PEN/mutant" || fail "the mutated module did not build"

# One reading, run $CONCURRENT at a time.
storm() {
  bin=$1
  rounds=$2
  red=0
  r=1
  while [ "$r" -le "$rounds" ]; do
    tally=$PEN/tally
    : > "$tally"
    p=1
    while [ "$p" -le "$CONCURRENT" ]; do
      ( "$bin" selftest >/dev/null 2>&1 || printf 'x\n' >> "$tally" ) &
      p=$((p + 1))
    done
    wait
    red=$((red + $(wc -l < "$tally" | tr -d ' ')))
    r=$((r + 1))
  done
  echo "$red"
}

clean_red=$(storm "$PEN/clean" "$ROUNDS")
mutant_red=$(storm "$PEN/mutant" "$MUTANT_ROUNDS")

printf 'concurrent=%s rounds=%s clean_runs=%s clean_red=%s\n' \
  "$CONCURRENT" "$ROUNDS" "$((CONCURRENT * ROUNDS))" "$clean_red"
printf 'mutant_rounds=%s mutant_runs=%s mutant_red=%s fixed_port=%s\n' \
  "$MUTANT_ROUNDS" "$((CONCURRENT * MUTANT_ROUNDS))" "$mutant_red" "$FIXED_PORT"

if [ "$clean_red" -ne 0 ]; then
  printf 'detail: the module refused %s of %s runs beside itself -- a port is shared again\n' \
    "$clean_red" "$((CONCURRENT * ROUNDS))"
  printf 'verdict=red\n'
  exit 1
fi

if [ "$mutant_red" -eq 0 ]; then
  printf 'detail: the fixed-port mutant passed %s runs, so a clean reading above proves nothing\n' \
    "$((CONCURRENT * MUTANT_ROUNDS))"
  printf 'verdict=blind\n'
  exit 1
fi

printf 'verdict=ok\n'
