#!/bin/sh
# tools/fixtures/p/prose_register_scan.sh -- prose that measures, measured.
#
# WHY. On 20260823 a freshly written front door was labelled Radiant and read as its opposite.
# Counted: 46% of README sentences and 54% of a founding statement's carried a negative, against
# 29% in RADIANT_STYLE.md itself -- a founding statement twice as negative as the guide it claimed
# to follow. The reading grade sat inside target the whole time, which is why nobody caught it.
#
# The meter that existed, tools/fixtures/r/radiant_negation_scan.sh, counts NEGATION WORDS across
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
#   sh tools/fixtures/p/prose_register_scan.sh
#
# Driven by tools/p/prose_register_witness.rish. Run from the repository root.

set -u

DOOR="README.md docs/README.md foundations/README.md foundations/20260823-034321_the-return-that-feeds-everyone.md docs-geode/tutorials/the-first-hour.md docs-geode/demos/README.md caravan/README.md mycelium/README.md image/README.md lotus/README.md crypto/README.md constel/README.md"
DOOR_MAX=20
FIELD_MAX=30
# A share needs a denominator big enough to mean something. Below this many sentences the reading is
# arithmetic on a rounding error: one negative sentence out of one reads 100%, and one out of two
# reads 50%, neither of which says anything about how a page is written. The teaching tier has
# applied this floor since it was written; naming it here rather than spelling it inside the loop is
# what lets tools/fixtures/q/qa_report_card.sh CITE the number instead of copying it, the same way it
# already cites measure(). One floor, two readings, and no way for them to drift apart.
REGISTER_MIN_SENTENCES=8
# THE CEILING ONLY EVER FALLS FOR A GIVEN READING, and on 20260906 the reading changed: measure()
# began reading the body paragraphs the `*` branch had been dropping (REDS %451), which is roughly
# twice the page on a Gauge document. A number the new reading produces and a number the old one
# produced are different measurements, so holding the first to the second's ceiling would refuse
# the tree for a repair that made the meter honest -- and a guard that reds on a correctness fix is
# a guard somebody turns off.
#
# So the ceiling is RE-SEATED at what the honest reading finds, with every number kept: 16 when the
# meter was seated 20260823, swept to 0 that day under the elder reading, and 5 under the reading
# from 20260906. The five are NAMED rather than counted, the way the DOOR roster already is, so the
# ceiling carries a population rather than an abstraction -- a lane sweeping one takes its name off
# and the number falls by one.
#
#   document                                   elder        now
#   docs-geode/wiki/README.md                  57% of 7     50% of 10   (under the 8-sentence floor, so unread)
#   manual/guides/macos-ai-jail-setup.md       22% of 49    37% of 70
#   edu/funds/gren-creating-one-of-twelve.md   22% of 18    35% of 28
#   manual/guides/self-hosted-vpn-setup.md     26% of 15    33% of 18
#   manual/guides/walking-the-rounds.md        30% of 53    31% of 66
#
# None of the five got worse. Each page has read over the Field target the whole time; the elder
# meter was reading a part of it, and the sentence counts beside each are how much of a part.
ceiling=5

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# One awk, so the reading of a Door file and a teaching file is the same reading by construction.
#
# WHAT IS READ PAST, each named separately rather than folded into one character class. The elder
# form was `/^[ \t]*[-*>#]/` under the comment "bullets, headings, quotes", and the `*` in it was
# reading the wrong half of this tree's prose (REDS %451). A CommonMark bullet is `-`, `*`, or `+`
# FOLLOWED BY WHITESPACE; `**What went wrong:**` is a bold span, and Gauge writes its paragraphs
# that way constantly. Not one asterisk bullet exists anywhere in docs-geode/, so that branch kept
# nothing it was aimed at and dropped body paragraphs instead: of docs-geode's 537 readable lines,
# 239 fell to it and none was a bullet, 85 of them body paragraphs on the twelve gated doors.
#
# FRONT MATTER IS DROPPED ON PURPOSE, where it used to fall to the same accident. Position and
# shape are required together, because neither alone is enough: `**Stamp:** ...` and
# `**What went wrong:** ...` are the same shape, and a body paragraph can open a page -- a rule
# keyed on shape alone ate real prose on 77 of 703 living documents when it was tried. So the block
# must be the FIRST one after the title, AND its opening line must carry a short bold key holding
# no `*` and no inner `:`. A wrapped value rides with it to the blank line that ends the block,
# which is what finally drops the shared `**Where this sits:**` navigation line -- twelve words
# carrying one negation, counted as prose on 111 front doors.
#
# WHY THE BLOCK EARNS ITS PLACE, measured 20260906. Without it `docs/README.md` reads 50% on two
# sentences of pure front matter and refuses the door gate on a page whose body is a link list,
# and `constel/README.md` reads 22% against a 20% ceiling on metadata alone rather than on prose.
# With it they read 0% and 18%. Of 892 living documents 676 carry such a block, and the six
# largest a prose-shaped audit flagged are all metadata with long values.
measure() {
  awk '
    BEGIN {
      # POSIX boundary classes, since \< is gawk-only and BSD awk matched nothing
      # (the control leg caught the zero-read on the first macOS run, 20260825)
      neg = "(^|[^a-z0-9_])(not|no|never|none|nothing|nobody|cannot|without|fails?|failed|failure|broken|breaks?|broke|wrong|lost|lose|loses|losing|stale|rot|rots|rented|dead|blind|refuses?|refused|refusal|error|bug|stopped|worse|worst|difficult|disappoint|pessimis|problem|risk|danger|threat|lying|lies|merely|nor|neither|hollow|empty|missing|absent|useless|wasted|corrupt)($|[^a-z0-9_])"
      infence = 0
      head = 1        # the title, then the metadata block, then the body begins
      inmeta = 0
    }
    # A front-matter key: `**Stamp:**`, `**Where this sits:**`. No interval quantifier anywhere in
    # this file -- BSD awk read nothing from \< once already, and an interval is the same risk --
    # so the length bound is taken from RLENGTH rather than spelled in the pattern. Forty holds the
    # longest key this tree writes and refuses a sentence that happens to carry a colon.
    function frontmatter_key(l) {
      if (l !~ /^[ \t]*\*\*[^*:]*:\*\*/) return 0
      match(l, /^[ \t]*\*\*[^*:]*:\*\*/)
      return (RLENGTH <= 40)
    }
    /^```/ { infence = 1 - infence; head = 0; next }
    infence { next }
    head {
      if ($0 ~ /^[ \t]*$/) { if (inmeta) { inmeta = 0; head = 0 } ; next }
      if (!inmeta && $0 ~ /^[ \t]*#/) next                       # the title
      if (!inmeta && frontmatter_key($0)) { inmeta = 1; next }   # the block opens
      if (inmeta) next                                           # a wrapped value rides with it
      head = 0                                                   # the body begins
    }
    /^[ \t]*\|/ { next }                       # tables
    /^[ \t]*[-*_][-*_ \t]*$/ { next }          # a rule line, or a marker with nothing after it
    /^[ \t]*[-*+][ \t]/ { next }               # a bullet: the marker THEN whitespace
    /^[ \t]*[>#]/ { next }                     # quotes, headings
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
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' > "$work/teaching.txt"

teaching_over=0
: > "$work/teaching_over.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  set -- $(measure "$f")
  [ "$1" -ge "$REGISTER_MIN_SENTENCES" ] || continue   # too short to read a share from honestly
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
