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
# THE SECOND DISCARD SPELLING, added 20260906 after the same lantern lit one room over. `|| true`
# discards a failure and leaves EMPTINESS behind; `|| echo -` discards a failure and puts a
# FALLBACK VALUE in its place, which is strictly worse, because emptiness at least looks like
# nothing while a value reads as an answer. `radiant_negation_scan.sh` carried exactly that: an
# output-producing awk looked up a rule's baseline row, and on any failure substituted `-`, the one
# token meaning *no baseline row, admit this file at its measured value*. Pointed at a mode-000
# baseline the guard printed `enforce_admitted=51` of `enforce_files=51`, `enforce_risen=0` and
# `verdict=ok` -- green while comparing nothing, with awk's reason already thrown away. Its own
# tell was printed and read by nobody. Measured across every tracked tool scan: ONE site.
#
# TWO EXCLUSIONS KEEP THE SECOND READING HONEST, and both were found by measuring rather than
# guessed. Six of the first seven hits were the `test && echo yes || echo no` TERNARY, where the
# `||` is a conditional's else-branch and discards nothing; and the seventh was that same ternary
# written across three lines, which a line-at-a-time reader sees only the tail of. So this pass
# JOINS BACKSLASH CONTINUATIONS before matching -- a multi-line command is one command, and reading
# its tail alone is the same narrowing fault `20260906.161500` and `20260906.173013` booked in two instruments.
#
# THE TWO READINGS ARE COUNTED APART rather than summed. Each rests on its own reasoning and can be
# freed on its own condition, and a composed number would let one shape's ceiling quietly cover the
# other's -- the same reason the QA card prints its two overages separately.
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
# The fallback reading is a wall from birth too: measured 20260906 at ONE across 2,969 tracked
# scans, and that one repaired on the lap this reading landed. Its own ceiling, so either shape can
# fall without the other's number moving.
FALLBACK_CEILING=${INSTRUMENT_FALLBACK_CEILING:-0}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

if ! git ls-files -- 'tools/**/*.sh' > "$work/files" 2>/dev/null; then
  echo "instrument=failed"
  echo "detail=cannot_list_tracked_scans"
  echo "verdict=misread"
  exit 1
fi
scanned=$(grep -c . "$work/files" || true)

# One awk over every scan, with backslash continuations JOINED first, so a command written across
# three lines is judged as the one command it is. A line qualifies for the elder reading when it
# (1) invokes an output-producing instrument, (2) redirects that output into a file, and (3) ends by
# discarding the failure; and for the fallback reading when (3) becomes *substitutes a value*. A
# comment is prose, a grep-led pipeline is an answer rather than a fault, and a `&& echo ... ||
# echo ...` ternary discards nothing at all -- its `||` is an else-branch.
: > "$work/hits"
: > "$work/fallback"
if ! tr '\n' '\0' < "$work/files" | LC_ALL=C xargs -0 awk -v hits="$work/hits" -v fb="$work/fallback" '
    function classify(   ) {
      # A DELIBERATE TOLERATION SAYS SO AT THE SITE. Some failures are the intended outcome: the
      # counsel census concatenates six thousand paths and one dangling symlink fails the `cat`,
      # where a truncating fallback would erase the fifty-six megabytes that DID read. That is a
      # decision, not a swallow -- and the difference between them is whether anyone wrote it down.
      # A `# instrument-tolerated: <why>` comment on the line above exempts the next line and
      # nothing else, so an exemption is one line from the thing it exempts and carries its reason.
      if (line ~ /instrument-tolerated:/) { tolerated = 1; return }
      if (line ~ /^[[:space:]]*#/) return
      if (tolerated) { tolerated = 0; return }
      # a grep-led pipeline: exit 1 means no match, and tolerating it -- with `|| true` or with a
      # placeholder value -- is correct in both spellings
      if (line ~ /(^|[;&|(`[:space:]])(grep|git grep)[[:space:]]/) return
      # (1) an output-producing instrument. A predicate awk answers by exiting and writes no file,
      # so condition (2) already excludes it from the elder reading.
      if (line !~ /(^|[;&|(`[:space:]])(awk|sed|iconv|tr|sort|comm|cut|xargs_lines|xargs_lines_batched)[[:space:]]/) return
      # (3a) the failure is discarded and (2) the output lands in a file
      if (line ~ /\|\|[[:space:]]*true[[:space:]]*$/ && line ~ />[[:space:]]*"?\$/) {
        printf "%s:%d: %s\n", f, start, line >> hits
        return
      }
      # (3b) the failure substitutes a VALUE. No redirect is required: a command substitution takes
      # the answer just as surely as a file does, and the fallback is what makes it unreadable.
      if (line ~ /\|\|[[:space:]]*(echo|printf)[[:space:]]/ && line !~ /&&[[:space:]]*(echo|printf)[[:space:]]/)
        printf "%s:%d: %s\n", f, start, line >> fb
    }
    FNR == 1 { f = FILENAME; tolerated = 0; line = ""; start = 0 }
    { if (line == "") start = FNR; line = line $0 }
    /\\[[:space:]]*$/ { sub(/\\[[:space:]]*$/, " ", line); next }
    { classify(); line = "" }
  ' 2>"$work/awkerr"; then
  echo "instrument=failed"
  echo "detail=scan_pass_refused"
  sed -n '1,5p' "$work/awkerr" | sed 's/^/detail_awk=/'
  echo "verdict=misread"
  exit 1
fi

swallowed=$(grep -c . "$work/hits" || true)
fallback=$(grep -c . "$work/fallback" || true)
[ "$swallowed" -eq 0 ] || sed 's/^/swallowed: /' "$work/hits"
[ "$fallback" -eq 0 ] || sed 's/^/fallback: /' "$work/fallback"

echo "scans_read=$scanned"
echo "swallowed_instrument_passes=$swallowed"
echo "swallowed_ceiling=$CEILING"
echo "fallback_instrument_passes=$fallback"
echo "fallback_ceiling=$FALLBACK_CEILING"
echo "story=an_instrument_that_cannot_run_must_refuse>grep_exit_one_is_an_answer>a_predicate_answers_by_exiting>a_fallback_value_reads_as_an_answer"

# BOTH GATES ARE READ BEFORE EITHER REFUSES, so one shape over its ceiling never hides the other's
# reading from whoever is looking at the output.
over=no
[ "$swallowed" -le "$CEILING" ] || over=yes
[ "$fallback" -le "$FALLBACK_CEILING" ] || over=yes
if [ "$over" = no ]; then
  echo "under_ceiling=yes"
  echo "verdict=ok"
  exit 0
fi
echo "under_ceiling=no"
echo "verdict=over_ceiling"
[ "$swallowed" -le "$CEILING" ] || echo "refused: $swallowed output-producing instrument passes discard their failure, against a ceiling of $CEILING -- a ceiling only falls." >&2
[ "$fallback" -le "$FALLBACK_CEILING" ] || echo "refused: $fallback instrument passes substitute a fallback VALUE for a failure, against a ceiling of $FALLBACK_CEILING -- a value reads as an answer where emptiness reads as nothing." >&2
exit 1
