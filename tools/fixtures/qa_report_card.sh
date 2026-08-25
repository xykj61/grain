#!/bin/sh
# tools/fixtures/qa_report_card.sh -- read one artifact and hand back its report card.
#
# WHY THIS FILE EXISTS. This tree measured its prose one way: the share of sentences carrying a
# negative, held at or under 20% for a Door document. That number is true and it is also backwards.
# A reader asked to hold "20% negative" is being told what the page failed to avoid, and a writer
# aiming at it is aiming at a ceiling rather than at a standard. Read the same measurement the other
# way up -- 100 minus that share -- and 20% becomes **80, a B**, which is a grade a person has known
# since school and can aim at without translating.
#
# So the report card is the same discipline pointed forward. Seated 20260824.161948 on Keaton's word.
#
# WHAT IT READS, and what it refuses to invent. Four readings, and the tool counts two and a half of
# them:
#
#   Register  counted   100 minus the share of sentences carrying a negative. The measure() function
#                       is lifted verbatim from tools/fixtures/prose_register_scan.sh, so the flip
#                       and the ceiling are one reading rather than two that can disagree (REDS %201).
#   Reach     counted   whether the intended reader can follow it: Flesch-Kincaid grade and
#                       cross-references per hundred words, against the setting's own budget --
#                       unless the page declares itself an index AND measures like one, where the
#                       density is reported rather than scored. Two conditions, never one.
#   Truth     half      counted: every relative link the page makes, resolved as written, root-
#                       relative, or by the fold rule. A placeholder shape -- `date/YYYYMMDD/name`
#                       -- is an illustration of a path rather than a citation of one, and a
#                       fabricated stamp naming no file still counts. Judged: whether a behavioral
#                       claim is still true, which only reading or running can say.
#   Service   judged    whether the artifact helps the work actually in front of us. The tool prints
#                       the inputs a reader needs and stops there, because a number nobody measured
#                       is worse than a blank.
#
# BOTH OF THOSE READINGS ARGUED IN FULL beside the code that carries them, further down this file.
# The short of it: a meter that instructs a repair which would make the artifact worse is the thing
# to fix, and this one did it twice -- telling an index to pad itself with prose, and telling a page
# that its blessed placeholder shape was a broken link. Neither page changed a word.
#
# THE COMPOSITE arrives once the judged readings are handed in with --service and --truth. Without
# them the card prints what it counted and says `composite=judged`, which is the honest output.
#
# THE SCALE, and why it has no minus grades. Keaton's word, 20260824: a plain school scale, so a
# writer reads a B and knows what to do.
#
#   97-100 A+ | 90-96 A | 85-89 B+ | 80-84 B | 75-79 C+ | 70-74 C | 65-69 D+ | 60-64 D | under 60 F
#
# WHAT IS NOT PROVEN. That an A page is a good page. This counts four honest proxies and names the
# two it cannot count, and the second thing to read is always the artifact itself.
#
# USAGE
#   sh tools/fixtures/qa_report_card.sh <path> [--setting door|field|meter] [--service N] [--truth N]
#   sh tools/fixtures/qa_report_card.sh --letter <0-100>
#
# Run from the repository root.

set -u

root=${QA_CARD_ROOT:-.}

# --- the scale ---------------------------------------------------------------------------------
letter_for() {
  n=$1
  if   [ "$n" -ge 97 ]; then echo "A+"
  elif [ "$n" -ge 90 ]; then echo "A"
  elif [ "$n" -ge 85 ]; then echo "B+"
  elif [ "$n" -ge 80 ]; then echo "B"
  elif [ "$n" -ge 75 ]; then echo "C+"
  elif [ "$n" -ge 70 ]; then echo "C"
  elif [ "$n" -ge 65 ]; then echo "D+"
  elif [ "$n" -ge 60 ]; then echo "D"
  else echo "F"
  fi
}

if [ "${1:-}" = "--letter" ]; then
  [ $# -ge 2 ] || { echo "qa: --letter wants a score" >&2; exit 1; }
  letter_for "$2"
  exit 0
fi

path=${1:-}
[ -n "$path" ] || { echo "qa: name an artifact to read" >&2; exit 1; }
[ -f "$root/$path" ] || { echo "qa: $path is absent -- refusing rather than reading zero" >&2; exit 1; }
shift

setting=field
service=-1
truth_given=-1
while [ $# -gt 0 ]; do
  case "$1" in
    --setting) setting=${2:-field}; shift 2 ;;
    --service) service=${2:--1}; shift 2 ;;
    --truth)   truth_given=${2:--1}; shift 2 ;;
    *) echo "qa: unknown option $1" >&2; exit 1 ;;
  esac
done

case "$setting" in
  door)  grade_ceiling=9;  xref_ceiling=1 ;;
  field) grade_ceiling=11; xref_ceiling=3 ;;
  meter) grade_ceiling=0;  xref_ceiling=0 ;;
  *) echo "qa: unknown setting $setting -- door, field, or meter" >&2; exit 1 ;;
esac

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# --- Register: the same reading prose_register_scan.sh gates, flipped -----------------------------
reg_scan="$root/tools/fixtures/prose_register_scan.sh"
[ -f "$reg_scan" ] || { echo "qa: the register reading is missing at $reg_scan" >&2; exit 1; }
sed -n '/^measure() {/,/^}/p' "$reg_scan" > "$work/measure.sh"
[ -s "$work/measure.sh" ] || { echo "qa: prose_register_scan.sh no longer publishes measure()" >&2; exit 1; }
. "$work/measure.sh"

set -- $(measure "$root/$path")
sentences=$1
negatives=$2
neg_pct=$3
register=$((100 - neg_pct))

# --- Reach: can the intended reader follow it ----------------------------------------------------
# Flesch-Kincaid over the same prose the register reading sees, plus link density. Syllables are
# counted by vowel groups with a silent trailing `e` removed and a floor of one, which is the
# ordinary heuristic and honest to about half a grade.
reach_raw=$(awk -v gc="$grade_ceiling" -v xc="$xref_ceiling" '
  BEGIN { infence = 0 }
  /^```/ { infence = 1 - infence; next }
  infence { next }
  /^[ \t]*\|/ { next }
  /^[ \t]*[-*>#]/ { next }
  /^[ \t]*$/ { next }
  {
    line = $0
    while (match(line, /\]\([^)]*\)/)) { links++; line = substr(line, RSTART + RLENGTH) }
    line = $0
    gsub(/\[[^]]*\]\([^)]*\)/, " link ", line)
    gsub(/`[^`]*`/, " code ", line)
    buf = buf " " tolower(line)
  }
  END {
    n = split(buf, s, /[.!?]+[ ]/)
    for (i = 1; i <= n; i++) {
      w = split(s[i], t, /[ ]+/)
      if (w < 4) continue
      sent++
      for (j = 1; j <= w; j++) {
        word = t[j]
        gsub(/[^a-z]/, "", word)
        if (word == "") continue
        words++
        sub(/e$/, "", word)
        c = split(word, v, /[aeiouy]+/)
        syl = c - 1
        if (syl < 1) syl = 1
        syllables += syl
      }
    }
    if (sent == 0 || words == 0) { print "0 0 0 0 0 0"; exit }
    grade = 0.39 * (words / sent) + 11.8 * (syllables / words) - 15.59
    if (grade < 0) grade = 0
    per100 = links * 100 / words
    go = grade - gc;   if (go < 0) go = 0
    xo = per100 - xc;  if (xo < 0) xo = 0
    reach = 100 - 10 * int(go + 0.5) - 10 * int(xo + 0.5)
    if (reach < 0) reach = 0
    # The same reading with the cross-reference term dropped, for a page whose links ARE its
    # content. Computed here so one arithmetic answers both readings rather than two that can drift.
    reach_prose = 100 - 10 * int(go + 0.5)
    if (reach_prose < 0) reach_prose = 0
    printf "%d %d %d %d %d %d\n", reach, reach_prose, int(grade + 0.5), int(per100 + 0.5), words, links
  }
' "$root/$path")
set -- $reach_raw
reach=$1
reach_prose=$2
grade=$3
xrefs=$4
words=$5
links=$6

# --- The page's own declaration: an index says so, and then measures like one ---------------------
# A cross-reference budget of one per hundred words is written for prose. On an index the links ARE
# the content, so the budget measures the page against a standard it was never built to meet:
# docs/README.md carries 10 words of prose and 5 links, which reads 50 per 100w against a budget of
# 1 and floors Reach at zero. That is a meter instructing a repair -- pad the page with prose --
# which would make the artifact worse, and a meter that does that is the thing to fix.
#
# So the card reads a page's own declaration, the way declared_ceiling reads a page's own limit.
# TWO conditions, never one, because a self-declared exemption is a door, and a door beside a wall
# makes the wall a habit again:
#
#   1. The page DECLARES itself an index, in its HEADER -- `**Depth:** routing` or `**Kind:** ...
#      index`. Header only, meaning the block above the first `---` rule, so a body that merely
#      discusses indexes declares nothing.
#   2. The page MEASURES as one -- under 100 words of prose. A rate expressed per hundred words is
#      extrapolation below one full unit of its own denominator, and that is the whole fault here.
#
# Measured 20260825 over every living page: four declare an index in their header, and three of them
# carry 13, 13, and 10 words. The fourth, docs-geode/edu/README.md, carries 193 and already reads A
# at 3 xrefs per 100w -- so the floor keeps a readable index graded and lifts only the pages whose
# denominator cannot carry the rate. That the pair discriminates on real data, before a line of this
# was written, is what makes it a reading rather than an opt-out.
index_floor=100
declares_index=no
awk 'NR <= 40 { if ($0 ~ /^---[ \t]*$/) exit; print }' "$root/$path" \
  | grep -qE '[*][*]Depth:[*][*][^|]*routing|[*][*]Kind:[*][*][^|]*index' && declares_index=yes

reach_mode=graded
if [ "$declares_index" = yes ] && [ "$words" -lt "$index_floor" ]; then
  reach_mode=index
  reach=$reach_prose
fi

# Meter carries no reach budget, because refusal-first prose is the subject rather than a fault.
[ "$setting" = "meter" ] && { register=100; reach=100; reach_mode=meter; }

# --- Truth, the counted half: every relative link resolves somewhere ------------------------------
dir=$(dirname "$path")
cited=0
unresolved=0
illustrations=0
: > "$work/unresolved.txt"
: > "$work/illustrations.txt"
grep -o '](\([^)]*\))' "$root/$path" 2>/dev/null | sed 's/^](//; s/)$//' | sed 's/#.*$//' > "$work/links.txt" || :
while IFS= read -r target; do
  [ -n "$target" ] || continue
  case "$target" in http*|mailto:*|'<'*) continue ;; esac
  # An example path in prose is a SHAPE -- `date/YYYYMMDD/name` -- with letter placeholders standing
  # where the digits would go. `.claude/rules/stamp-and-name.md` seats that spelling and asks for it
  # by name: build an illustration from placeholders and it stays honest; build one from a real-
  # looking stamp and a sprig naming no file, and it reads as a real citation to every reader and
  # every tool. So a placeholder run is an illustration rather than a citation.
  #
  # Only the two runs that law spells inside a path shape count, YYYYMMDD and HHMMSS. Measured
  # 20260825: zero of this tree's tracked paths carry either run literally, so the reading can never
  # swallow a real path, and exactly 8 links across all living Markdown match, in 4 files. A
  # FABRICATED stamp -- digits naming no file -- still counts against Truth, which is the half that
  # keeps this a reading rather than an escape hatch, and the control plants both halves.
  case "$target" in
    *YYYYMMDD*|*HHMMSS*)
      illustrations=$((illustrations + 1))
      printf 'illustration: %s\n' "$target" >> "$work/illustrations.txt"
      continue ;;
  esac
  cited=$((cited + 1))
  [ -e "$root/$dir/$target" ] && continue
  [ -e "$root/$target" ] && continue
  base=$(basename "$target")
  day=$(echo "$base" | sed -n 's/^\([0-9]\{8\}\)-[0-9]\{6\}[_.].*/\1/p')
  if [ -n "$day" ]; then
    hit=$(find "$root" -path "*/date/$day/$base" -print -quit 2>/dev/null)
    [ -n "$hit" ] && continue
  fi
  unresolved=$((unresolved + 1))
  printf 'unresolved: %s\n' "$target" >> "$work/unresolved.txt"
done < "$work/links.txt"

truth_counted=$((100 - 20 * unresolved))
[ "$truth_counted" -lt 0 ] && truth_counted=0

# --- Service inputs: what a reader needs to supply the judged number ------------------------------
citers=$( ( cd "$root" && git grep -l -- "$(basename "$path")" -- ':!'"$path" 2>/dev/null ) | grep -cvE '(^|/)[0-9]{8}-[0-9]{6}[_.]|(^|/)date/' || : )
[ -n "$citers" ] || citers=0
named_by_card=no
[ -f "$root/construction/ITINERARY.md" ] && grep -q -- "$(basename "$path")" "$root/construction/ITINERARY.md" 2>/dev/null && named_by_card=yes
in_seed=no
if [ -f "$root/template-manifest.bron" ]; then
  room=$(echo "$path" | cut -d/ -f1)
  grep -qE "^allow ($room|$path)\$" "$root/template-manifest.bron" 2>/dev/null && in_seed=yes
fi

# --- The card ------------------------------------------------------------------------------------
echo "qa_path=$path"
echo "qa_setting=$setting"
echo "register=$register (negative $neg_pct% of $sentences sentences)"
if [ "$reach_mode" = index ]; then
  echo "reach=$reach (grade $grade against $grade_ceiling; xrefs $xrefs per 100w reported, not scored; $words words, $links links)"
else
  echo "reach=$reach (grade $grade against $grade_ceiling; xrefs $xrefs per 100w against $xref_ceiling; $words words, $links links)"
fi
echo "reach_mode=$reach_mode (declares_index=$declares_index; prose floor $index_floor words)"
echo "truth_counted=$truth_counted ($unresolved of $cited cited paths unresolved; $illustrations placeholder shapes read as illustrations)"
[ -s "$work/unresolved.txt" ] && cat "$work/unresolved.txt"
[ -s "$work/illustrations.txt" ] && cat "$work/illustrations.txt"
echo "service_inputs living_citers=$citers named_by_card=$named_by_card in_seed=$in_seed"

truth=$truth_given
[ "$truth" -lt 0 ] && truth=$truth_counted
echo "truth=$truth"

if [ "$service" -lt 0 ]; then
  echo "service=judged"
  echo "composite=judged -- hand in --service to close the card"
  exit 0
fi

echo "service=$service"
composite=$(( (register + reach + truth + service + 2) / 4 ))
[ "$composite" -gt 100 ] && composite=100

# Truth is a gate rather than a quarter. A page whose claims have gone false costs a reader more
# than an absent one, so honesty-first is written into the arithmetic rather than left to a habit.
gated=no
if [ "$truth" -lt 60 ]; then
  composite=59
  gated=yes
fi

echo "truth_gate=$gated"
echo "composite=$composite"
echo "letter=$(letter_for "$composite")"
