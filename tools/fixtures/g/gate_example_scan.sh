#!/bin/sh
# tools/fixtures/g/gate_example_scan.sh -- a gate desk's `example` line is a runnable claim, and
# until this meter nothing ran one.
#
#   sh tools/fixtures/g/gate_example_scan.sh              # the free readings: parse and arity
#   sh tools/fixtures/g/gate_example_scan.sh --list       # name every parsed case
#   sh tools/fixtures/g/gate_example_scan.sh --run        # lower, build and run every case
#
# WHAT STANDS AT THE DOOR. Every desk in src/gate/ opens with the six placard lines
# src/shape/PLACARD.md seats, and one of them is `example`. On a shape pedestal that line is a
# single literal -- `example    3` -- and four meters already hold such a number against the Rye
# it describes. On a GATE desk the same line is a table of input and answer:
#
#     ::  example    3 5 -> 1 - 3 2 -> 0 - 3 3 -> 1
#
# That is a program's behavior written down by the hand that wrote the program, on the program's
# own face, in a form a machine can read. Measured 20260911 over the 49 desks of the room: 40
# carry an example, 39 of those parse as machine tables, and they hold 116 cases between them.
# Not one had ever been run. The desks themselves are run -- glow_desk_reach reads 347 covered
# desks and gates the uncovered at zero -- so what was missing was never the run; it was the
# comparison between what the desk answers and what its own placard says it answers.
#
# WHY THIS IS THE EARTH READING. A stamp is read off a filename, a room token off a status line,
# and an answer off a placard: the concrete fact taken in whole at the door, before any argument
# about it (foundations/20260826-021735_earth-the-row-that-breathes-in.md). A table nobody runs is
# a fact nobody breathed in.
#
# THE TWO FREE READINGS, GATED AT ZERO, AND WHY THEY COST NO BUILD.
#   arity_unreadable  the worker declines to state a run contract for this stem, so the table's
#                     inputs can be compared against nothing. tools/g/glow_run_worker.sh answers
#                     `--arity` precisely so a caller need keep no second copy of that fact
#                     (REDS %532's third enumeration), and a desk it cannot answer for is a desk
#                     whose table is unrunnable whatever it says.
#   arity_unaccepted  a case whose input count stands outside the set the worker accepts. The
#                     placard and the worker are two statements of one fact -- how many samples
#                     this desk takes -- written in two rooms by two hands, and nothing compared
#                     them. Read PER CASE rather than per desk, because gate-lantern-face-core
#                     carries cases of two and of three inputs and the worker accepts both; a
#                     reading taken from the first case alone would have called that desk arity 2
#                     and passed its three-input cases unseen.
#
# WHY prose_tabled IS REPORTED AND NEVER GATED. gate-compose-sumto-u32 writes its example as a
# sentence -- `argv 4 -> 10 (inc of 3); welcome bakes 5 -> 15; past 65535 -> 0` -- which carries
# arrows and is plainly for a person. A placard may speak to a reader; PLACARD.md asks for one
# small literal and says nothing about a machine table. So an example that does not parse is named
# by desk and left alone, the way `members()` one room over answers `unresolved:<what>` rather than
# reading zero. A gate here would refuse honest prose, and a guard that reds on honest work is a
# guard somebody turns off.
#
# WHAT --run COSTS, SAID PLAINLY. Each case lowers the desk and builds it with Zig, and nothing
# caches the binary between cases: measured 20260911, 5.5 to 6.0 seconds each, so the 116 cases
# take roughly eleven minutes. That is why the run half is opt-in rather than the default, and why
# the witness proves the runner on a miniature desk room in a pen -- where a wrong answer is
# planted and bitten in seconds -- rather than spending eleven minutes of every lap to re-prove 116
# answers that moved for nobody. A hand or a cadence slice takes the live sweep with `--run`.
#
# NO SILENT CAP. `--run` runs every parsed case of every desk. It drops nothing, samples nothing,
# and prints `ran` beside `cases` so the two can be compared.

set -u

ROOT=$(pwd)
while [ ! -d "$ROOT/.git" ]; do
  if [ "$ROOT" = "/" ]; then
    echo "gate_example: no repository root above $(pwd)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT" || exit 2

GATE_DIR=${GATE_EXAMPLE_DIR:-src/gate}
WORKER=${GATE_EXAMPLE_WORKER:-tools/g/glow_run_worker.sh}

# Bound: the room held 49 desks on 20260911 and grows a few a round. 1024 is a power of two an
# order of magnitude above that -- high enough never to refuse honest growth, low enough that a
# generator writing desks in a loop is named rather than scanned forever.
MAX_DESKS=1024
# Bound: the longest table standing carries six cases. 64 per desk is a power of two well above
# it, so a malformed line that splits into hundreds of pieces is refused rather than walked.
MAX_CASES_PER_DESK=64

LIST=no
RUN=no
for arg in "$@"; do
  case "$arg" in
    --list) LIST=yes ;;
    --run) RUN=yes ;;
    *) echo "gate_example: unknown argument $arg" >&2; exit 2 ;;
  esac
done

if [ ! -d "$GATE_DIR" ]; then
  echo "gate_example: no gate room at $GATE_DIR" >&2
  exit 2
fi
if [ ! -f "$WORKER" ]; then
  echo "gate_example: no run worker at $WORKER" >&2
  exit 2
fi

WORK=$(mktemp -d 2>/dev/null || echo "/tmp/gate_example.$$")
mkdir -p "$WORK" || exit 2
trap 'rm -rf "$WORK"' EXIT INT TERM

# Sort under one collation everywhere, because a meter that sorts and a meter that compares must
# agree about the alphabet (REDS %532's own last lesson).
LC_ALL=C
export LC_ALL

find "$GATE_DIR" -name 'gate-*.glow' -type f | sort > "$WORK/desks"
desks=$(wc -l < "$WORK/desks" | tr -d ' ')

if [ "$desks" -gt "$MAX_DESKS" ]; then
  echo "gate_example: $desks desks past the bound of $MAX_DESKS" >&2
  exit 2
fi

# A case parses when every field left of the arrow and the one field right of it are decimal, and
# at least one input stands. Anything else is prose and says so.
numeric() {
  case "$1" in
    ''|*[!0-9]*) return 1 ;;
    *) return 0 ;;
  esac
}

placarded=0
tabled=0
machine_tabled=0
prose_tabled=0
cases=0
arity_unreadable=0
arity_unaccepted=0
verdict=ok

: > "$WORK/cases"
: > "$WORK/prose"
: > "$WORK/unaccepted"
: > "$WORK/unreadable"

while IFS= read -r desk; do
  stem=$(basename "$desk" .glow)
  ex=$(sed -n 's/^::  example  *//p' "$desk" | head -1)
  [ -n "$ex" ] || continue
  placarded=$((placarded + 1))
  case "$ex" in *'->'*) ;; *) continue ;; esac
  tabled=$((tabled + 1))

  # Split the table on ` - `, the separator the room writes between cases.
  printf '%s\n' "$ex" | sed 's/ - /\n/g' > "$WORK/chunks"
  chunk_count=$(wc -l < "$WORK/chunks" | tr -d ' ')
  if [ "$chunk_count" -gt "$MAX_CASES_PER_DESK" ]; then
    echo "gate_example: $stem splits into $chunk_count cases, past the bound of $MAX_CASES_PER_DESK" >&2
    exit 2
  fi

  parsed=yes
  : > "$WORK/desk_cases"
  while IFS= read -r chunk; do
    case "$chunk" in *'->'*) ;; *) parsed=no; break ;; esac
    inputs=${chunk%%->*}
    answer=${chunk#*->}
    answer=$(printf '%s' "$answer" | tr -d ' ')
    numeric "$answer" || { parsed=no; break; }
    n=0
    for field in $inputs; do
      numeric "$field" || { parsed=no; break; }
      n=$((n + 1))
    done
    [ "$parsed" = yes ] || break
    [ "$n" -gt 0 ] || { parsed=no; break; }
    printf '%s\t%s\t%s\t%s\n' "$stem" "$n" "$(printf '%s' "$inputs" | sed 's/  */ /g; s/^ //; s/ $//')" "$answer" >> "$WORK/desk_cases"
  done < "$WORK/chunks"

  if [ "$parsed" != yes ]; then
    prose_tabled=$((prose_tabled + 1))
    printf '%s\n' "$stem" >> "$WORK/prose"
    continue
  fi

  machine_tabled=$((machine_tabled + 1))
  cat "$WORK/desk_cases" >> "$WORK/cases"

  # The worker's own statement of the run contract, asked rather than copied.
  accepts=$(sh "$WORKER" --arity "$desk" 2>/dev/null | sed -n 's/^accepts=//p' | head -1)
  if [ -z "$accepts" ]; then
    arity_unreadable=$((arity_unreadable + 1))
    printf '%s\n' "$stem" >> "$WORK/unreadable"
    continue
  fi
  while IFS='	' read -r cstem cn cin cans; do
    hit=no
    for a in $accepts; do
      [ "$a" = "$cn" ] && hit=yes
    done
    if [ "$hit" = no ]; then
      arity_unaccepted=$((arity_unaccepted + 1))
      printf '%s\t%s\t%s -> %s\taccepts=%s\n' "$cstem" "$cn" "$cin" "$cans" "$accepts" >> "$WORK/unaccepted"
    fi
  done < "$WORK/desk_cases"
done < "$WORK/desks"

cases=$(wc -l < "$WORK/cases" | tr -d ' ')

if [ "$LIST" = yes ]; then
  while IFS='	' read -r cstem cn cin cans; do
    echo "case: $cstem ($cn) $cin -> $cans"
  done < "$WORK/cases"
  while IFS= read -r p; do
    echo "prose: $p"
  done < "$WORK/prose"
fi

while IFS= read -r u; do
  echo "unreadable: $u"
done < "$WORK/unreadable"
while IFS='	' read -r ustem un ucase uacc; do
  echo "unaccepted: $ustem case $ucase takes $un input(s), $uacc"
done < "$WORK/unaccepted"

ran=0
answers_wrong=0
run_failed=0
if [ "$RUN" = yes ]; then
  while IFS='	' read -r cstem cn cin cans; do
    desk="$GATE_DIR/$cstem.glow"
    # shellcheck disable=SC2086
    out=$(sh "$WORKER" "$desk" $cin 2>&1)
    rc=$?
    ran=$((ran + 1))
    if [ "$rc" -ne 0 ]; then
      run_failed=$((run_failed + 1))
      echo "run_failed: $cstem $cin -> $cans (exit $rc)"
      continue
    fi
    # The worker prints the binary's own lines and then `EXIT:<code>`. The answer is the last line
    # standing before that tail -- read exactly, never by substring, because `EXIT:0` contains the
    # very digits an answer of 0 would be mistaken for (REDS %310).
    got=$(printf '%s\n' "$out" | grep -v '^EXIT:' | grep -v '^$' | tail -1)
    if [ "$got" != "$cans" ]; then
      answers_wrong=$((answers_wrong + 1))
      echo "answer_wrong: $cstem $cin -> declared $cans, answered ${got:-<silence>}"
    else
      # One line per case as it lands. A sweep that prints only at its end is eleven minutes a
      # reader cannot tell from a hang, which is the same reading `standing_equipment_run.sh`
      # earned its per-guard line for -- and the transcript then IS the record of what was proven.
      echo "ran: $cstem $cin -> $cans"
    fi
  done < "$WORK/cases"
fi

if [ "$arity_unreadable" -gt 0 ]; then
  verdict="arity_unreadable"
elif [ "$arity_unaccepted" -gt 0 ]; then
  verdict="arity_unaccepted"
elif [ "$RUN" = yes ] && [ "$run_failed" -gt 0 ]; then
  verdict="run_failed"
elif [ "$RUN" = yes ] && [ "$answers_wrong" -gt 0 ]; then
  verdict="answers_wrong"
fi

echo "desks=$desks"
echo "placarded=$placarded"
echo "tabled=$tabled"
echo "machine_tabled=$machine_tabled"
echo "prose_tabled=$prose_tabled"
echo "cases=$cases"
echo "arity_unreadable=$arity_unreadable"
echo "arity_unaccepted=$arity_unaccepted"
echo "run=$RUN"
echo "ran=$ran"
echo "run_failed=$run_failed"
echo "answers_wrong=$answers_wrong"
echo "verdict=$verdict"

# A refusal exits 1 so a caller reading only the exit code meets the same answer the verdict line
# spells. Exit 2 stays reserved for a scan that could not read its subject at all -- an absent
# room, an absent worker, a bound crossed -- because "I refuse your tree" and "I cannot see your
# tree" are two different sentences and a reader repairing one must not reason about the other.
[ "$verdict" = ok ] || exit 1
exit 0
