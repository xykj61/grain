#!/bin/sh
# tools/fixtures/b/brush_parse_control.sh -- prove brush-parse refuses a planted malformed .brush.
#
# WHAT THIS DOES. tools/gen/chapter/brush_parse_witness.rish asserts brush-parse's own selftest
# banners and the seed fixture's happy path; it never plants a bad .brush file from outside and
# watches the CLI refuse it. The redleg scan (REDS %827) counts that as no refusal of its own. This
# control supplies the missing plant: a `.brush` source missing its required `at-nib:` pin must make
# the built binary exit non-zero and name its own ParseError on stderr, and the tracked seed fixture
# must still exit zero beside it -- both directions, one pen.
#
# THE PEN IS ENTERED for its two throwaway fixtures only; the binary under test is the one the
# witness already built at brushstroke/bin/brush-parse, run against paths outside the repository so
# neither plant is ever staged.
#
# USAGE
#   sh tools/fixtures/b/brush_parse_control.sh
#
# Run from the repository root, after brushstroke/bin/brush-parse is built.
set -eu

ROOT=$(pwd)
BIN="$ROOT/brushstroke/bin/brush-parse"
SEED="$ROOT/brushstroke/seed-frame.brush"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/brush_parse_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT

behaviors=0
failed=0

check() { # check <name> <expected> <actual>
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then
    echo "  ok   $1"
  else
    echo "  FAIL $1 -- wanted [$2] got [$3]"
    failed=$((failed + 1))
  fi
}

if [ ! -x "$BIN" ]; then
  echo "brush_parse_control: $BIN is not built -- run the witness's build step first"
  exit 2
fi

echo "brush_parse_control: planted malformed .brush"

# -- 1. a .brush missing its required at-nib pin must refuse, by name --------------------------
printf '%s\n' \
  ':: planted: missing at-nib pin on purpose' \
  ':: present:    Frame' \
  ':: max-lines:  8' \
  ':: lines:' \
  '::   one line only' \
  > "$PEN/missing-at-nib.brush"
out="$PEN/missing-at-nib.out"
set +e
"$BIN" "$PEN/missing-at-nib.brush" >"$out" 2>&1
code=$?
set -e
check "missing at-nib refuses" "1" "$code"
case "$(cat "$out")" in
  *MissingAtNib*) echo "  ok   named error MissingAtNib on stderr" ;;
  *) echo "  FAIL named error MissingAtNib on stderr -- got [$(cat "$out")]"; failed=$((failed + 1)) ;;
esac
behaviors=$((behaviors + 1))

# -- 2. a .brush with max-lines past the seed ceiling must refuse, by name ---------------------
printf '%s\n' \
  ':: planted: max-lines past max_frame_lines on purpose' \
  ':: at-nib:     planted-nib' \
  ':: present:    Frame' \
  ':: max-lines:  9' \
  ':: lines:' \
  '::   one line only' \
  > "$PEN/max-lines-over.brush"
out2="$PEN/max-lines-over.out"
set +e
"$BIN" "$PEN/max-lines-over.brush" >"$out2" 2>&1
code=$?
set -e
check "max-lines over ceiling refuses" "1" "$code"
case "$(cat "$out2")" in
  *MaxLinesOutOfBound*) echo "  ok   named error MaxLinesOutOfBound on stderr" ;;
  *) echo "  FAIL named error MaxLinesOutOfBound on stderr -- got [$(cat "$out2")]"; failed=$((failed + 1)) ;;
esac
behaviors=$((behaviors + 1))

# -- 3. the tracked seed fixture still welcomes, beside both refusals --------------------------
set +e
"$BIN" "$SEED" >/dev/null 2>&1
code=$?
set -e
check "tracked seed fixture welcomes" "0" "$code"

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "verdict=control_failed"
  exit 1
fi
echo "verdict=ok"
