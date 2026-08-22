#!/bin/sh
# Mechanism-sentence ratchet -- a commit body says what changed before it says what it means.
#
# Keaton read six commits of one Caravan refactoring arc on 20260822 and still had to ask what
# the arc did. The code was sound and the witnesses were green; the bodies described the work
# entirely in image. The `note_path` commit contains no occurrence of `file`, `function`,
# `parameter`, `import`, or `call` -- the mechanism is genuinely absent from the prose.
#
# Measured over the forty commits standing at seating:
#
#   mechanism words found   0-1   10 commits
#                             2   12 commits      21 of 40 below the floor
#                             3    9 commits
#                             4    5 commits
#                            5+    4 commits
#
# Cause is the style stack more than any one hand: Radiant rewards the earned line, the commit
# rule asks for Radiant bodies, and titles are drawn as poetry, so a careful author aims where
# the rules point. The habit that answers it is one line long -- MECHANISM FIRST, MEANING AFTER
# -- and a habit with a meter is a check, while a habit without one is a hope.
#
# TWO TIERS, the shape the ASCII and negation guards already proved:
#   WALL      -- tools/hooks/commit-msg refuses a thin body at write time, going forward.
#   ADVISORY  -- this scan reports the trailing window against a ceiling that only ever falls,
#                so no round is asked to rewrite twenty-one dated commit messages, which
#                accrete-never-break forbids anyway.
#
# The vocabulary line below is shared with the hook, and the witness asserts the two agree --
# a wall and its meter that drift apart are worse than either alone.
#
#   sh tools/fixtures/mechanism_sentence_scan.sh
#   sh tools/fixtures/mechanism_sentence_scan.sh prove-red
#
# Read-only: no network, no key, no funds, and no prose is rewritten here.
set -eu

MODE=${1:-}
HERE="$(CDPATH= cd "$(dirname "$0")" && pwd)"
CONTROL=$HERE/mechanism_sentence_control/metaphor_only_control.txt
WINDOW=${WINDOW:-40}
CEILING=${CEILING:-21}

# MECHANISM-WORDS-BEGIN
MECH_WORDS='function fn parameter argument import call struct field signature symbol declaration module file script directory constant type'
# MECHANISM-WORDS-END

# Count distinct mechanism words and body words in one pass, so the two always agree.
# Matched as WHOLE WORDS with an optional plural, never as a substring: `file` must not be
# found inside `profile`, and `call` must not be found inside `called-for` prose.
measure() {
  awk -v words="$MECH_WORDS" '
    { w += NF; text = text " " tolower($0) }
    END {
      n = split(words, v, " ")
      for (i = 1; i <= n; i++)
        if (text ~ ("(^|[^a-z])" v[i] "(s|es)?([^a-z]|$)")) found++
      need = (w >= 60) ? 3 : (w >= 25) ? 1 : 0
      printf "%d %d %d\n", w, found + 0, need
    }' "$1"
}

if test "$MODE" = "prove-red"; then
  # A body written entirely in image MUST be caught. If this ever passes, the meter is asleep.
  test -f "$CONTROL" || { echo "control_verdict=missing"; exit 1; }
  set -- $(measure "$CONTROL")
  echo "control_words=$1 control_mechanism=$2 control_need=$3"
  if test "$2" -lt "$3"; then
    echo "RED_metaphor_only_caught=$2"
    exit 1
  fi
  echo "control_verdict=MISSED"
  exit 1
fi

test -d .git || { echo "scan_verdict=not_a_repository"; exit 1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

thin=0; counted=0
git log -"$WINDOW" --format='%H' > "$TMP/hashes"
while read -r h; do
  [ -n "$h" ] || continue
  git log -1 --format='%b' "$h" > "$TMP/body"
  set -- $(measure "$TMP/body")
  counted=$((counted + 1))
  if test "$2" -lt "$3"; then
    thin=$((thin + 1))
    echo "thin_body=$(printf '%.10s' "$h") words=$1 mechanism=$2 need=$3"
  fi
done < "$TMP/hashes"

echo "window=$counted"
echo "thin=$thin"
echo "ceiling=$CEILING"
echo "vocabulary=$(printf '%s' "$MECH_WORDS" | wc -w | tr -d ' ')"

if test "$thin" -gt "$CEILING"; then
  echo "RED_ceiling_exceeded=$thin"
  echo "verdict=red"
  exit 1
fi
echo "verdict=ok"
exit 0
