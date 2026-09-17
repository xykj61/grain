#!/bin/sh
# tools/fixtures/c/control_in_population_scan.sh -- a guard whose population holds its own
# control has a failure mode no care inside the guard prevents.
#
#   sh tools/fixtures/c/control_in_population_scan.sh [--list] [--explain <scan path>]
#
# WHY. A control proves a refusal by CONTAINING the thing refused. A scan proves a tree clean by
# reading a population. When the population includes the control, those two correctnesses pull
# against each other: the control cannot carry its plant without the live meter counting it. This
# is a fault in neither file. It is a fault in the PAIR, and it appears only when both are right.
#
# MEASURED ON METAL `20260916`, on `tools/fixtures/a/awk_lcg_exact_scan.sh`, whose population is
# every tracked `.sh` and `.rish` source and whose control is one of them. Staging that control
# took the live reading from `overflowing=0 exact=7 unread=17` to `5 / 8 / 18` and reddened a gate
# held at zero, on five generators existing only to be refused inside a pen. The repair moved the
# plant rather than the meter -- the numerals became shell variables and the plant heredocs
# unquoted -- so the pen still receives literal arithmetic while the tracked bytes carry no
# refusable shape.
#
# WHAT IS COUNTED. For every tracked `*_scan.sh`, this reads the scan's OWN `git ls-files`
# invocation out of its source, RUNS that invocation, and asks whether any tracked file sharing
# the scan's basename stem stands inside the population that comes back.
#
#   self_reading -- the scan's enumerated population holds at least one tracked file of its own
#     family. REPORTED, never gated: reading your own family is often correct, and `awk_lcg_exact`
#     deliberately does so today with its plant moved out of the tracked bytes. A gate here would
#     refuse the repaired shape along with the unrepaired one.
#
#   self_reading_control -- of those, the family file is a `_control.sh`. This is the subset where
#     the pull is structural, since a control's whole job is to hold what the scan refuses.
#
# THE DENOMINATOR IS SPLIT FOUR WAYS, because one word for all of them hid the widest case.
# A first draft of this scan reported a single `enumeration_unread=269` and, inside it, silently
# dropped every bare `git ls-files` -- which is the WHOLE tracked tree, the broadest population a
# scan can read and the likeliest to hold a control. The classes are kept apart now:
#
#   enumerating -- an invocation was extracted, admitted, and returned files. Measured.
#   membership_test -- the only invocation is `git ls-files --error-unmatch <path>`, which asks
#     whether ONE path is tracked. That is a predicate rather than a population, so these are
#     structurally outside this reading rather than unmeasured.
#   enumeration_refused -- an invocation stands and could not be run safely, almost always because
#     its glob is a shell variable. GENUINELY UNMEASURED, and named so a zero above is read as a
#     zero of the measured denominator alone.
#   no_git_population -- the scan names no `git ls-files` at all. Most read one module directory
#     with `find`, or run a built program. A `find` rooted at `tools/` CAN reach a control, so
#     this class is not proven clear either; it is unread by a different instrument, and the count
#     is printed rather than assumed empty.
#
# TWO BOUNDS, both stated because neither is fixable from here.
#
#   Upper, on enumeration: a scan may enumerate broadly and then filter with a `case` pattern, so
#     membership in the enumeration is not proof the scan READS the file. The exact question is
#     whether the scan's numbers CHANGE when the control leaves the index, which wants a worktree
#     per candidate and is named in the paper rather than run here.
#
#   Lower, on family: the pairing is by basename stem, which is a NAMING CONVENTION. The water
#     row's own cardinal seat teaches that a measurement finding evidence by name reports the
#     convention it was handed -- `dated_path_repoint_scan.sh` pairs with a control named for the
#     FAMILY rather than for the tool, and a stem search cannot see such a pair. The true count is
#     at or above this one.
#
# SAFETY. The extracted text is evaluated, so it is admitted only when it matches a bounded shape:
# `git ls-files` followed by flags, `--`, and quoted or bare globs. Any command substitution,
# variable, semicolon, ampersand, redirect, or backtick refuses that invocation.
set -e

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"

MAX_SCANS=2048          # bound: far above the 374 tracked scans read 20260916
MAX_ENUM_PER_SCAN=8     # bound: no scan in the tree spells more than three

MODE=report
TARGET=
case "$1" in
  --list) MODE=list ;;
  --explain) MODE=explain; TARGET=$2 ;;
  "") ;;
  *) echo "usage: $0 [--list] [--explain <scan path>]" >&2; exit 2 ;;
esac

TRACKED=$(mktemp); POP=$(mktemp); RAW=$(mktemp); HITS=$(mktemp)
cleanup() { rm -f "$TRACKED" "$POP" "$RAW" "$HITS"; }
trap cleanup EXIT INT HUP TERM

git ls-files > "$TRACKED"

# admit_enumeration: true when the extracted text is the bounded shape described above.
admit_enumeration() {
  case "$1" in
    *'`'*|*'$'*|*';'*|*'&'*|*'>'*|*'<'*|*'|'*) return 1 ;;
    *--error-unmatch*) return 1 ;;
    'git ls-files'*) return 0 ;;
    *) return 1 ;;
  esac
}

scans_tracked=0
enumerating=0
membership_test=0
enumeration_refused=0
no_git_population=0
self_reading=0
self_reading_control=0

for scan in $(grep -E '_scan\.sh$' "$TRACKED" | head -n "$MAX_SCANS"); do
  [ -f "$scan" ] || continue
  scans_tracked=$((scans_tracked + 1))
  base=${scan##*/}
  stem=${base%_scan.sh}

  # The scan's own invocations, read with comment lines removed first, so a header naming the
  # command in prose is never mistaken for a call. A BARE `git ls-files` is kept: it is the whole
  # tracked tree and the broadest population in the reading.
  src=$(sed 's/#.*$//' "$scan")
  raw=$(printf '%s\n' "$src" \
      | grep -oE "git ls-files[^|;)\`\$<>]*" \
      | sed -e 's/2>\/dev\/null//g' -e 's/[[:space:]]*$//' \
      | head -n "$MAX_ENUM_PER_SCAN")

  if [ -z "$raw" ]; then
    no_git_population=$((no_git_population + 1))
    continue
  fi

  admitted=no
  sawtest=no
  : > "$RAW"
  printf '%s\n' "$raw" | while IFS= read -r line; do
    [ -n "$line" ] || continue
    admit_enumeration "$line" || continue
    eval "$line" 2>/dev/null || true
  done > "$RAW" || true
  printf '%s\n' "$raw" | grep -q -- '--error-unmatch' && sawtest=yes
  for line in $(printf '%s\n' "$raw" | tr ' ' '\001' | tr '\n' ' '); do
    l=$(printf '%s' "$line" | tr '\001' ' ')
    admit_enumeration "$l" && admitted=yes
  done

  if [ ! -s "$RAW" ]; then
    if [ "$admitted" = no ] && [ "$sawtest" = yes ]; then
      membership_test=$((membership_test + 1))
    else
      enumeration_refused=$((enumeration_refused + 1))
    fi
    continue
  fi
  enumerating=$((enumerating + 1))

  # `git ls-files -s` prints mode, hash, stage, path -- take the path when four fields stand.
  awk '{ if (NF >= 4) print $NF; else print $0 }' "$RAW" | sort -u > "$POP"

  # The family: tracked files whose basename begins with this scan's stem, the scan itself apart.
  family=$(awk -v s="$stem" -v self="$scan" '
    { n = $0; sub(/^.*\//, "", n)
      if (index(n, s) == 1 && $0 != self) print $0 }' "$TRACKED")
  [ -n "$family" ] || continue

  found=
  for f in $family; do
    if grep -qxF "$f" "$POP"; then found="$found $f"; fi
  done
  [ -n "$found" ] || continue

  self_reading=$((self_reading + 1))
  ctl=no
  for f in $found; do
    case "$f" in *_control.sh) ctl=yes ;; esac
  done
  [ "$ctl" = yes ] && self_reading_control=$((self_reading_control + 1))

  echo "$scan control=$ctl held=$(echo $found | tr ' ' ',')" >> "$HITS"
done

if [ "$MODE" = list ]; then
  sort "$HITS" 2>/dev/null || true
fi
if [ "$MODE" = explain ]; then
  grep -F -- "$TARGET" "$HITS" 2>/dev/null \
    || echo "explain: $TARGET stands clear of its own family, or is outside the measured class"
fi

echo "scans_tracked=$scans_tracked"
echo "enumerating=$enumerating"
echo "membership_test=$membership_test"
echo "enumeration_refused=$enumeration_refused"
echo "no_git_population=$no_git_population"
echo "self_reading=$self_reading"
echo "self_reading_control=$self_reading_control"
echo "family_pairing=basename_stem"
echo "verdict=reported"
