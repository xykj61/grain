#!/bin/sh
# tools/fixtures/q/qa_genre_census_scan.sh -- the whole program population, read at both settings.
#
# WHAT THIS ANSWERS. `tools/fixtures/q/qa_report_card.sh` reads every program HEAD at Door -- a
# reading grade of 9, one cross-reference per hundred words, and a register measured against 20
# percent. Gauge's own setting table in `context/GAUGE_STYLE.md` names three of those heads Meter
# instead: "ledger rows, witness headers, scan comments, commit bodies", uncapped on register,
# grade and cross-references, "because refusal is the subject". So a witness header is refusal
# prose scored for being refusal prose. The card already knows this: it derives `program_genre`
# from the basename, prints `program_genre_meter=named` for a witness and a scan, and prints
# `meter_shadow` -- the composite that head would carry if it were read at Meter. Every one of
# those readings is reported and scored by nothing.
#
# The standing ask on `construction/ITINERARY.md` came from a SAMPLE: 19 of 40 sampled
# `tools/*_witness.rish` read below B, and the card asked whether that is a red, a ratchet, or a
# card that says so. A sample sizes a class; only a count names its shapes. This is the count.
#
# WHAT IT MEASURED, `20260917` over all 2,914 tracked files the card's genre table can reach:
#
#     Door                                  Meter shadow
#     43 distinct composites, 50 to 94      1 distinct composite, 94
#     1,176 below B (40.3 percent)          0 below B
#
# Every figure above is FREE -- the population grows with the tree, and this scan is itself three
# more candidates than it counted. Run it rather than reading these numbers.
#
# ONE NUMBER, 2,914 TIMES. That is the whole finding, and it settles the ask without anyone
# needing an opinion about witness prose. At Meter both of the card's COUNTED readings are freed
# to 100 -- register and reach are the only two things it measures -- so the composite is fixed by
# Truth and Service alone, and the counted half of Truth reads 100 on every one of the 2,914. Move
# the three genres to Meter and a reading carrying 43 values across a 44-point span becomes a
# constant.
#
# THE CARD ALREADY REFUSED THIS ONCE, one family over and in its own words: a notation file
# carrying a comment block is refused Meter and read at Field, "because freeing it makes the
# reading a CONSTANT: register and reach are both set to 100, leaving a composite fixed by Truth
# and Service alone... every one of them read EXACTLY 94 at Meter with Service held at 75". That
# is REDS %402's disconnected reading. The program family carries the identical shape at 153 times
# the population, and nothing had counted it.
#
# SO THE ANSWER IS NEITHER A RED NOR A RELAXATION. Door is not mis-grading these heads; Door is the
# only reading that tells them apart at all. What is genuinely missing is a Meter reading with
# something in it -- a measurement of refusal prose that is not simply the absence of two other
# measurements. Naming that is Keaton's word, and this census is what a ruling would stand on.
#
# WHY THE CARD IS ASKED RATHER THAN COPIED. The genre table lives in one `case` statement inside
# the card, and a roster spelled twice is a roster that can quietly disagree with itself -- the
# discipline `qa_report_card_scan.sh` already keeps with the door roster, and `measure()` with the
# register floor. This scan PREFILTERS by the three words the tree spells in a basename and then
# lets the card name the genre. A candidate the card reads as `module` is a file the tree names
# witness, scan or control and the card's table does not reach; it is counted as `genre_unnamed`
# and gated under a ceiling that only falls, at 1 today -- `metaphor_only_control.txt`, a fixture
# control set rather than a program.
#
# WHAT IT DOES NOT GATE. A grade is not a gate (`.claude/rules/quality-assurance.md`), so the
# below-B counts are reported and refuse nothing. Heads grow as they teach more, and a wall on
# `door_below_b` would red a lane for writing a longer header -- which is the very thing the
# reading penalizes and the very thing this tree wants.
#
# THE LISTING PRINTS EVERY ROW. `--list` names all 2,914 with no `head` between the sort and the
# reader, under today's `listing_census` law: a capped listing makes an absent row and a dropped
# row look identical.
#
# Style: context/GAUGE_STYLE.md - Rule: .claude/rules/quality-assurance.md
#
# Run from the repository root:
#   sh tools/fixtures/q/qa_genre_census_scan.sh [--list] [--jobs N]
set -u

root=${QA_CENSUS_ROOT:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}
cd "$root" || { echo "verdict=root_unreadable"; exit 1; }

list=no
jobs=${QA_CENSUS_JOBS:-8}
service=${QA_CENSUS_SERVICE:-75}
while [ $# -gt 0 ]; do
  case $1 in
    --list) list=yes; shift ;;
    --jobs) jobs=${2:-8}; shift 2 ;;
    *) echo "qa-genre-census: unknown flag $1" >&2; exit 1 ;;
  esac
done

card=$root/tools/fixtures/q/qa_report_card.sh
[ -f "$card" ] || { echo "verdict=card_missing"; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The prefilter: the three words this tree spells in a program's basename, minus the two artifact
# kinds the card reads as something other than a program.
git ls-files \
  | grep -E '(^|/)[^/]*_(witness|scan|control)\.[^/.]+$' \
  | grep -vE '\.(md|mdc|markdown|bron|kyri)$' \
  | sort > "$work/candidates.txt"
candidates=$(wc -l < "$work/candidates.txt" | tr -d ' ')

cat > "$work/row.sh" <<'ROW'
#!/bin/sh
out=$(sh "$QA_CENSUS_CARD" "$1" --service "$QA_CENSUS_SVC" 2>/dev/null) || { echo "err err err $1"; exit 0; }
g=$(printf '%s\n' "$out" | awk -F'[= ]' '/^program_genre=/{print $2; exit}')
c=$(printf '%s\n' "$out" | awk -F= '/^composite=/{print $2; exit}')
m=$(printf '%s\n' "$out" | awk -F'[= ]' '/^meter_shadow=/{print $2; exit}')
[ -n "$g" ] || g=err
[ -n "$c" ] || c=err
[ -n "$m" ] || m=err
echo "$g $c $m $1"
ROW

# The NUL-delimited spelling `tools/fixtures/s/shell_portable.sh` publishes, since `xargs -a FILE`
# is a GNU extension and a path carrying a blank splits under the default delimiter. That file's
# own helpers take no `-P`, and 2,914 serial card runs is half an hour, so the shape is borrowed
# rather than called -- `tr` into `xargs -0`, which GNU and BSD both accept.
# EXPORTED rather than prefixed: a prefix binds to the first command of a pipeline, which is `tr`,
# so `row.sh` would lose both and every candidate would read as an error.
QA_CENSUS_CARD=$card
QA_CENSUS_SVC=$service
export QA_CENSUS_CARD QA_CENSUS_SVC
tr '\n' '\0' < "$work/candidates.txt" \
  | xargs -0 -P "$jobs" -n 1 sh "$work/row.sh" > "$work/rows.txt" 2>/dev/null
# A path answered twice would double a count, and a path answered never would hide one, so the
# rows are keyed by path before anything is counted.
sort -u -k4,4 "$work/rows.txt" > "$work/census.txt"

awk -v candidates="$candidates" '
  { genre = $1; door = $2; meter = $3 }
  door == "err" || meter == "err" || genre == "err" { errors++; next }
  {
    answered++
    g[genre]++
    if (door + 0 < 80) { door_b++; gb[genre]++ }
    if (meter + 0 < 80) meter_b++
    door_v[door]++
    meter_v[meter]++
    move += (meter + 0) - (door + 0)
    if (answered == 1 || door + 0 < dmin) dmin = door + 0
    if (door + 0 > dmax) dmax = door + 0
  }
  END {
    dd = 0; for (v in door_v) dd++
    md = 0; for (v in meter_v) md++
    one = ""
    if (md == 1) for (v in meter_v) one = v
    printf "candidates=%d\n", candidates
    printf "answered=%d errors=%d\n", answered + 0, errors + 0
    printf "genre_witness=%d genre_scan=%d genre_control=%d genre_unnamed=%d\n",
      g["witness"] + 0, g["scan"] + 0, g["control"] + 0, g["module"] + 0
    printf "witness_below_b=%d scan_below_b=%d control_below_b=%d\n",
      gb["witness"] + 0, gb["scan"] + 0, gb["control"] + 0
    printf "door_below_b=%d door_below_b_pct=%.1f door_distinct=%d door_min=%d door_max=%d\n",
      door_b + 0, (answered ? door_b * 100 / answered : 0), dd, dmin + 0, dmax + 0
    printf "meter_below_b=%d meter_distinct=%d meter_constant=%s\n",
      meter_b + 0, md, (md == 1 ? one : "no")
    printf "mean_move=%.2f\n", (answered ? move / answered : 0)
  }' "$work/census.txt" > "$work/report.txt"
cat "$work/report.txt"

if [ "$list" = yes ]; then
  echo "list_rows=$(wc -l < "$work/census.txt" | tr -d ' ') (every row, uncapped)"
  sort -k2,2n "$work/census.txt" | awk '{ printf "  %-8s door=%-3s meter=%-3s %s\n", $1, $2, $3, $4 }'
fi

errors=$(awk -F= '/^answered=/{print $0}' "$work/report.txt" | awk -F'errors=' '{print $2}')
unnamed=$(awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^genre_unnamed=/) { sub(/^genre_unnamed=/, "", $i); print $i } }' "$work/report.txt")
answered=$(awk -F'[= ]' '/^answered=/{print $2}' "$work/report.txt")

# The ceiling only ever falls. One today: tools/fixtures/mechanism_sentence_control/
# metaphor_only_control.txt, a fixture control set whose basename ends in _control and whose extension
# the card's genre table does not name.
unnamed_ceiling=1
echo "unnamed_ceiling=$unnamed_ceiling"

if [ "${errors:-1}" -ne 0 ]; then
  echo "verdict=card_refused_a_candidate"
  exit 1
fi
if [ "${answered:-0}" -ne "$candidates" ]; then
  echo "verdict=rows_do_not_balance"
  exit 1
fi
if [ "${unnamed:-0}" -gt "$unnamed_ceiling" ]; then
  echo "verdict=unnamed_rose"
  exit 1
fi
echo "verdict=ok"
