#!/bin/sh
# session_roster_agree_scan.sh -- one derived number, typed into two rosters, read back from the shelf.
#
# WHY. Two living pins carry the same per-day lap count as a literal constant:
# `session-logs/README.md` (the way in, one row per day) and `session-logs/CHAPTERS.md` (the seasons
# roster). Only the pin is named by a close duty, so the roster drifted quietly. Measured
# `20260909.010753` against the shelves themselves, **six closed days read wrong in CHAPTERS and
# right in the pin** -- 20260828 66/67, 20260829 84/86, 20260830 92/73, 20260905 58/61,
# 20260906 133/134, 20260907 129/131 -- and **six days carried no row at all**, 20260821 through
# 20260826, because one row reading *the days still flat in the room* went stale when a log became
# born-on-shelf at `20260827.171500` and later hands appended below it.
#
# The law already answers this in one line: **count, never number** (`.claude/rules/stamp-and-name.md`).
# A total carried inside a page stays at whatever it was on the day somebody typed it; a total derived
# by counting stays true as the work grows. Both pins are readable by a person, so both keep their
# numbers -- and this scan holds the two of them to the one reading the shelves give.
#
#   sh tools/fixtures/s/session_roster_agree_scan.sh          # counts
#   sh tools/fixtures/s/session_roster_agree_scan.sh list     # one line per disagreement
#   SESSION_ROSTER_ROOT=<dir> sh tools/fixtures/s/session_roster_agree_scan.sh
#
# WHAT A ROW IS, on either side of the reading. A shelf row is a line opening with a one-clock stamp
# in backticks -- `| \`YYYYMMDD.HHMMSS\`` in the table shelves this tree writes today, `- \`YYYYMMDD.HHMMSS\``
# in the elder list shelves it wrote through `20260722`. Reading both shapes is what lets one scan
# derive all 48 shelves rather than the newest 46.
#
# GATED AT ZERO: `disagree` (the two rosters spell one day differently), `stale` (a roster number
# differs from the shelf's own rows), `uncounted` (a shelf on disk that neither roster's table names),
# `phantom` (a roster row naming a shelf file that is absent).
#
# RATCHETED: `one_sided` -- a shelf one roster's table names and the other's does not. The elder drift
# wore this shape six times over, `20260821` through `20260826`, and the ceiling stands at **1** for
# the single member standing today: `20260722-shelf`, which CHAPTERS names in prose rather than in a
# table row, since it is an absorbed overflow shelf rather than a day. A seventh reds on the lap it
# arrives; the ceiling only falls.
#
# REPORTED, NEVER GATED: `open_stale` -- a row still spelling `open` for a day already past. That is
# a duty the next day-close pays, and a gate on it would red every ship in the fleet from midnight
# until a hand ran the close, which is a gate somebody turns off.
#
# BOUNDS: at most 512 shelves read, at most 200 lines reported.
set -eu

root=${SESSION_ROSTER_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_SHELVES=512
MAX_REPORT=200
ONE_SIDED_CEILING=${SESSION_ROSTER_ONE_SIDED_CEILING:-1}
TODAY=${SESSION_ROSTER_TODAY:-$(TZ=America/New_York date +%Y%m%d)}

pin=session-logs/README.md
chapters=session-logs/CHAPTERS.md
shelf_dir=session-logs/date

for f in "$pin" "$chapters" "$shelf_dir"; do
  [ -e "$f" ] || { echo "refused: $f is absent -- every count below would read zero" >&2; exit 2; }
done

work=$(mktemp -d "${TMPDIR:-/tmp}/session-roster-agree.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

# DERIVED -- one line per shelf: key, rows counted off the shelf itself.
ls "$shelf_dir" | sed -n 's/^README-index-\(.*\)\.md$/\1/p' | sort > "$work/keys.txt"
shelf_count=$(wc -l < "$work/keys.txt" | tr -d ' ')
[ "$shelf_count" -le "$MAX_SHELVES" ] || {
  echo "refused: $shelf_count shelves exceed $MAX_SHELVES -- no partial reading" >&2
  exit 2
}
# A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170).
[ -s "$work/keys.txt" ] || { echo "refused: no shelf index files under $shelf_dir" >&2; exit 2; }

: > "$work/derived.txt"
while IFS= read -r key; do
  f="$shelf_dir/README-index-$key.md"
  n=$(grep -cE '^(\| |- )`[0-9]{8}\.' "$f" || true)
  printf '%s %s\n' "$key" "$n" >> "$work/derived.txt"
done < "$work/keys.txt"

# CLAIMED -- one line per roster table row that names a shelf and a count.
# A row's key comes from the shelf link it carries, never from its first cell, so the two rosters
# spell their day columns however they like and still answer the same question.
claims() {
  awk -v roster="$2" '
    /^\|/ {
      line = $0
      if (match(line, /README-index-[^.]*\.md/) == 0) next
      key = substr(line, RSTART + 13, RLENGTH - 16)
      n = split(line, cell, "|")
      count = ""
      for (i = 2; i <= n; i++) {
        c = cell[i]
        if (c ~ /README-index-/) break
        gsub(/[`* ]/, "", c)
        # THE LAST BARE CELL BEFORE THE LINK IS THE COUNT. Taking the first would read the day key,
        # which is bare digits too -- 91 false stale readings on the first run of this scan.
        if (c ~ /^[0-9]+$/ || c == "open") count = c
      }
      if (count == "") next
      print roster, key, count
    }
  ' "$1"
}
claims "$pin" pin > "$work/claims.txt"
claims "$chapters" chapters >> "$work/claims.txt"

disagree=0; stale=0; uncounted=0; phantom=0; open_stale=0; one_sided=0
: > "$work/report.txt"

derived_of() { awk -v k="$1" '$1 == k { print $2; found = 1 } END { if (!found) print "-" }' "$work/derived.txt"; }
claim_of() { awk -v r="$1" -v k="$2" '$1 == r && $2 == k { print $3; found = 1 } END { if (!found) print "-" }' "$work/claims.txt"; }

while IFS= read -r key; do
  d=$(derived_of "$key")
  p=$(claim_of pin "$key")
  c=$(claim_of chapters "$key")
  if [ "$p" = "-" ] && [ "$c" = "-" ]; then
    uncounted=$((uncounted + 1))
    printf 'uncounted\t%s\tshelf holds %s rows and neither roster names it\n' "$key" "$d" >> "$work/report.txt"
    continue
  fi
  if [ "$p" = "-" ] || [ "$c" = "-" ]; then
    one_sided=$((one_sided + 1))
    missing=pin; [ "$p" != "-" ] && missing=chapters
    printf 'one_sided\t%s\t%s carries no table row; the shelf holds %s rows\n' "$key" "$missing" "$d" >> "$work/report.txt"
  fi
  if [ "$p" != "-" ] && [ "$c" != "-" ] && [ "$p" != "$c" ]; then
    disagree=$((disagree + 1))
    printf 'disagree\t%s\tpin %s, chapters %s, shelf %s\n' "$key" "$p" "$c" "$d" >> "$work/report.txt"
  fi
  for pair in "pin $p" "chapters $c"; do
    roster=${pair%% *}; claimed=${pair##* }
    [ "$claimed" = "-" ] && continue
    if [ "$claimed" = open ]; then
      if [ "$key" != "$TODAY" ]; then
        open_stale=$((open_stale + 1))
        printf 'open_stale\t%s\t%s still reads open; the shelf holds %s rows\n' "$key" "$roster" "$d" >> "$work/report.txt"
      fi
      continue
    fi
    if [ "$claimed" != "$d" ]; then
      stale=$((stale + 1))
      printf 'stale\t%s\t%s reads %s, the shelf holds %s\n' "$key" "$roster" "$claimed" "$d" >> "$work/report.txt"
    fi
  done
done < "$work/keys.txt"

# PHANTOM -- a roster row pointing at a shelf file that is not on disk.
while read -r roster key count; do
  [ -f "$shelf_dir/README-index-$key.md" ] && continue
  phantom=$((phantom + 1))
  printf 'phantom\t%s\t%s names it at %s; no shelf file\n' "$key" "$roster" "$count" >> "$work/report.txt"
done < "$work/claims.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/report.txt" | while IFS="$(printf '\t')" read -r kind key detail; do
    printf '%s: %s -- %s\n' "$kind" "$key" "$detail"
  done
fi

shelves=$(wc -l < "$work/keys.txt" | tr -d ' ')
pin_rows=$(awk '$1 == "pin"' "$work/claims.txt" | wc -l | tr -d ' ')
chapter_rows=$(awk '$1 == "chapters"' "$work/claims.txt" | wc -l | tr -d ' ')

echo "today=$TODAY"
echo "shelves=$shelves"
echo "pin_rows=$pin_rows"
echo "chapter_rows=$chapter_rows"
echo "disagree=$disagree"
echo "stale=$stale"
echo "uncounted=$uncounted"
echo "phantom=$phantom"
echo "open_stale=$open_stale"
echo "one_sided=$one_sided"
echo "one_sided_ceiling=$ONE_SIDED_CEILING"
if [ "$one_sided" -le "$ONE_SIDED_CEILING" ]; then echo "one_sided_ok=yes"; else echo "one_sided_ok=no"; fi
if [ "$disagree" -eq 0 ] && [ "$stale" -eq 0 ] && [ "$uncounted" -eq 0 ] && [ "$phantom" -eq 0 ] \
   && [ "$one_sided" -le "$ONE_SIDED_CEILING" ]; then
  echo "verdict=ok"
else
  echo "verdict=drift"
fi
