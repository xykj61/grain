#!/bin/sh
# tools/fixtures/prose_register_scan.sh -- prose that measures, measured.
#
# WHY. On 20260823 a freshly written front door was labelled Radiant and read as its opposite.
# Counted: 46% of README sentences and 54% of a founding statement's carried a negative, against
# 29% in RADIANT_STYLE.md itself -- a founding statement twice as negative as the guide it claimed
# to follow. The reading grade sat inside target the whole time, which is why nobody caught it.
#
# The meter that existed, tools/fixtures/radiant_negation_scan.sh, counts NEGATION WORDS across
# `.claude/rules/*.md` alone. Two gaps, both honest: the front door was never on its roster, and
# negative FRAMING -- fails, broken, lost, refused, stale, problem -- was never counted at all.
# This scan reads the second thing, on the tier where it does the most damage. The two meters are
# siblings rather than rivals: one guards the rules, one guards the door.
#
# WHAT IS GATED, hard. Every document on the DOOR roster keeps its negative-sentence share at or
# under 20%. The roster is named below rather than discovered, so a new file cannot join the
# enforced tier by accident and red on work it never agreed to cover.
#
# WHAT IS REPORTED, as a ratchet under a ceiling that only ever falls. The teaching tier --
# docs-geode/, manual/, edu/, and the root guides a newcomer opens -- counted as documents sitting
# above the Field target of 30%. Repair is a rewrite per document rather than a substitution, so
# these fall on touch. Measured at seating, the beginner tutorial itself read 59%.
#
# WHAT PASSES FREE, by named rule. Dated testimony keeps every word it wrote, so a file whose own
# basename carries a one-clock stamp is read past -- except where the DOOR roster names one
# outright, which is a deliberate choice to hold a founding statement to the front-door standard.
# Ledger rows, witness headers, and commit bodies are the Meter setting of context/GAUGE_STYLE.md
# and carry no ceiling; refusal-first is correct there, because refusal is the subject.
#
# WHAT IS NOT PROVEN. That the prose is GOOD. This counts negation density, which is one honest
# proxy among several, and the second number to read is always the prose itself. A page can pass
# this meter and still fail a reader.
#
# USAGE
#   sh tools/fixtures/prose_register_scan.sh
#
# Driven by tools/prose_register_witness.rish. Run from the repository root.

set -u

DOOR="README.md foundations/README.md foundations/20260823-034321_the-return-that-feeds-everyone.md docs-geode/tutorials/the-first-hour.md docs-geode/demos/README.md"
DOOR_MAX=20
FIELD_MAX=30
# The ratchet's ceiling only ever falls. Measured 20260823 across the teaching tier.
ceiling=14   # 16 at seating; two swept 20260823.061415 -- it only falls

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# One awk, so the reading of a Door file and a teaching file is the same reading by construction.
measure() {
  awk '
    BEGIN {
      neg = "\\<(not|no|never|none|nothing|nobody|cannot|without|fails?|failed|failure|broken|breaks?|broke|wrong|lost|lose|loses|losing|stale|rot|rots|rented|dead|blind|refuses?|refused|refusal|error|bug|stopped|worse|worst|difficult|disappoint|pessimis|problem|risk|danger|threat|lying|lies|merely|nor|neither|hollow|empty|missing|absent|useless|wasted|corrupt)\\>"
      infence = 0
    }
    /^```/ { infence = 1 - infence; next }
    infence { next }
    /^[ \t]*\|/ { next }                 # tables
    /^[ \t]*[-*>#]/ { next }             # bullets, headings, quotes
    /^[ \t]*$/ { next }
    {
      line = tolower($0)
      gsub(/\[[^]]*\]\([^)]*\)/, " link ", line)
      gsub(/`[^`]*`/, " code ", line)
      gsub(/[*_]/, "", line)
      buf = buf " " line
    }
    END {
      n = split(buf, s, /[.!?]+[ ]/)
      sent = 0; negsent = 0
      for (i = 1; i <= n; i++) {
        w = split(s[i], t, /[ ]+/)
        if (w < 4) continue
        sent++
        if (s[i] ~ neg) negsent++
      }
      if (sent == 0) { print "0 0 0"; exit }
      printf "%d %d %d\n", sent, negsent, int(negsent * 100 / sent)
    }
  ' "$1"
}

door_over=0
: > "$work/door.txt"
for f in $DOOR; do
  if [ -f "$f" ]; then
    set -- $(measure "$f")
    pct=$3
    printf 'door: %s %s%% (%s of %s sentences)\n' "$f" "$pct" "$2" "$1" >> "$work/door.txt"
    [ "$pct" -le "$DOOR_MAX" ] || { door_over=$((door_over + 1)); printf 'over: %s reads %s%% against a %s%% door ceiling\n' "$f" "$pct" "$DOOR_MAX" >> "$work/door.txt"; }
  else
    door_over=$((door_over + 1))
    printf 'over: %s is named on the door roster and absent\n' "$f" >> "$work/door.txt"
  fi
done

# The teaching tier: what a newcomer opens after the front door.
git ls-files 'docs-geode/*.md' 'manual/*.md' 'edu/*.md' CONTRIBUTING.md SOURCE.md ORGANIZING.md MAP.md 2>/dev/null \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}_' > "$work/teaching.txt"

teaching_over=0
: > "$work/teaching_over.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  set -- $(measure "$f")
  [ "$1" -ge 8 ] || continue     # too short to read a share from honestly
  if [ "$3" -gt "$FIELD_MAX" ]; then
    teaching_over=$((teaching_over + 1))
    printf 'teaching: %s %s%%\n' "$f" "$3" >> "$work/teaching_over.txt"
  fi
done < "$work/teaching.txt"

cat "$work/door.txt"
echo "door_documents=$(echo $DOOR | wc -w | tr -d ' ')"
echo "door_over_ceiling=$door_over"
echo "door_ceiling_percent=$DOOR_MAX"
echo "teaching_documents=$(wc -l < "$work/teaching.txt" | tr -d ' ')"
echo "teaching_over_field_target=$teaching_over"
echo "teaching_ceiling=$ceiling"
[ "$teaching_over" -eq 0 ] || sort -t% -k1 "$work/teaching_over.txt" | head -8

if [ "$door_over" -eq 0 ] && [ "$teaching_over" -le "$ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=register_drift"
echo "refused: a door document reads more negatively than the style it claims -- read the lines above" >&2
exit 1
