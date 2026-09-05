#!/usr/bin/env sh
# instrument_refusal_scan.sh -- a guard that cannot run its instrument must refuse, and name it.
#
# WHY. Three times in two days a scan reached for an instrument it did not write, could not find or
# could not run it, discarded the failure, and reported a clean tree. `tracked_link` resolved its
# awk helper from `$(pwd)` and passed inside a pen with zero unresolved links; `living_card_ascii`
# carried the same two mistakes for an hour; and `unheard_guard` swallowed both of its own awk
# passes, one of which reads `choirs=0` against a ceiling of 37 -- a ratchet passes on a low number,
# so a broken instrument and a clean tree report the same green (REDS %413, %416).
#
# THE DISTINCTION THIS METER RESTS ON, and it is why the reading is narrow rather than a sweep. An
# instrument may have a documented FOUND-NOTHING exit, and tolerating that is correct:
#
#   grep     exits 1 on no match -- `grep p f > out || true` is right, not a swallow
#   awk      with `END { exit !found }` is a PREDICATE whose non-zero is its answer
#   awk -f   producing OUTPUT has no such exit; any non-zero is a failure
#
# Measured before this scan was written: the broad signature `|| true` on any instrument matched
# **20 sites across 9 files, and exactly 2 were faults**, with a third found by this meter's own
# first run and turning out to be a documented deliberate toleration. A meter with 90% false positives is a
# meter someone turns off, so this one reads only the shape that cannot be innocent: an
# OUTPUT-PRODUCING pass, redirected to a file, whose failure is discarded, where the instrument is
# not grep-led.
#
#   sh tools/fixtures/i/instrument_refusal_scan.sh
#   sh tools/fixtures/i/instrument_refusal_scan.sh --root DIR
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_ir_steps=0
while [ ! -d "$ROOT/tools/fixtures" ]; do
  _ir_steps=$((_ir_steps + 1))
  if [ "$_ir_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    *) echo "instrument_refusal_scan: unknown argument: $1" >&2; exit 2 ;;
  esac
done
# THIS METER OBEYS ITS OWN LAW. A scan that cannot reach the tree it is asked about refuses in the
# shape it enforces -- `instrument=failed` with the reason named -- rather than leaving a bare shell
# error for a caller to interpret. The control asserts this, because a rule its own instrument
# does not follow is advice.
if ! cd "$ROOT" 2>/dev/null; then
  echo "instrument=failed"
  echo "detail=root_unreachable"
  echo "detail_path=$ROOT"
  echo "verdict=misread"
  exit 1
fi

# The ceiling only ever falls. Measured 20260905 at zero, on the lap the two known faults were
# repaired -- so this is a wall from birth rather than a debt, and a new one reds where it enters.
CEILING=${INSTRUMENT_REFUSAL_CEILING:-0}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

if ! git ls-files -- 'tools/**/*.sh' > "$work/files" 2>/dev/null; then
  echo "instrument=failed"
  echo "detail=cannot_list_tracked_scans"
  echo "verdict=misread"
  exit 1
fi
scanned=$(grep -c . "$work/files" || true)

# One awk over every scan. A line qualifies when it (1) invokes an output-producing instrument,
# (2) redirects that output into a file, and (3) ends by discarding the failure. A comment line and
# a grep-led pipeline are read past, the first because it is prose and the second because grep's
# exit 1 is an answer rather than a fault.
: > "$work/hits"
if ! tr '\n' '\0' < "$work/files" | LC_ALL=C xargs -0 awk '
    FNR == 1 { f = FILENAME; tolerated = 0 }
    # A DELIBERATE TOLERATION SAYS SO AT THE SITE. Some failures are the intended outcome: the
    # counsel census concatenates six thousand paths and one dangling symlink fails the `cat`,
    # where a truncating fallback would erase the fifty-six megabytes that DID read. That is a
    # decision, not a swallow -- and the difference between them is whether anyone wrote it down.
    # A `# instrument-tolerated: <why>` comment on the line above exempts the next line and
    # nothing else, so an exemption is one line from the thing it exempts and carries its reason.
    /instrument-tolerated:/ { tolerated = 1; next }
    /^[[:space:]]*#/ { next }
    tolerated { tolerated = 0; next }
    # (3) the failure is discarded
    !/\|\|[[:space:]]*true[[:space:]]*$/ { next }
    # (2) the output lands in a file
    !/>[[:space:]]*"?\$/ { next }
    # a grep-led pipeline: exit 1 means no match, and tolerating it is correct
    /(^|[;&|(`[:space:]])(grep|git grep)[[:space:]]/ { next }
    # a predicate awk answers with its own exit; it produces no file, so (2) already excluded it
    # (1) an output-producing instrument
    /(^|[;&|(`[:space:]])(awk|sed|iconv|tr|sort|comm|cut|xargs_lines|xargs_lines_batched)[[:space:]]/ {
      printf "%s:%d: %s\n", f, FNR, $0
    }' > "$work/hits" 2>"$work/awkerr"; then
  echo "instrument=failed"
  echo "detail=scan_pass_refused"
  sed -n '1,5p' "$work/awkerr" | sed 's/^/detail_awk=/'
  echo "verdict=misread"
  exit 1
fi

swallowed=$(grep -c . "$work/hits" || true)
[ "$swallowed" -eq 0 ] || sed 's/^/swallowed: /' "$work/hits"

echo "scans_read=$scanned"
echo "swallowed_instrument_passes=$swallowed"
echo "swallowed_ceiling=$CEILING"
echo "story=an_instrument_that_cannot_run_must_refuse>grep_exit_one_is_an_answer>a_predicate_answers_by_exiting"

if [ "$swallowed" -le "$CEILING" ]; then
  echo "under_ceiling=yes"
  echo "verdict=ok"
  exit 0
fi
echo "under_ceiling=no"
echo "verdict=over_ceiling"
echo "refused: $swallowed output-producing instrument passes discard their failure, against a ceiling of $CEILING -- a ceiling only falls." >&2
exit 1
