#!/bin/sh
# tools/fixtures/l/lint_table_runs_scan.sh -- does each lint row keep the claim its heading makes?
#
# WHY THIS EXISTS. `context/TAME_GUIDANCE.md` closes on a section called **What We Check, and
# When**, whose first table holds the tree's whole textual lint surface. REDS %714 listened to
# that table one row at a time and found twenty rows under one heading keeping four different
# promises: some a roster pass runs every lap, some a hand runs, some nothing ran at all. The
# repair landed a witness for the title rule, a census for the line-length rule, and a paragraph
# beneath the table naming the split in prose.
#
# THAT PARAGRAPH WENT STALE INSIDE A DAY, by exactly the amount of its own repair. It reads
# *eight lean on five tools a roster pass runs every lap*, written `20260911.112513`. Measured
# `20260912` against the same roster, thirteen rows do -- because the same round that wrote the
# sentence rostered two more of the rows it was counting. A count spelled in prose is held by
# nobody, which is this tree's own first law about figures: count, never number.
#
# So the split moves out of the paragraph and into the table, one word per row, and this scan
# holds each word to the roster's own reading.
#
# WHAT THE WORD ANSWERS, and why this question rather than a nearby one. A reader meeting a lint
# row wants to know whether an unattended lap will catch them. That is decided in exactly one
# place -- `construction/standing-equipment.kyri` -- by whether a tool the row NAMES holds a
# `path` row there, and at which tier. Three words cover it:
#
#   every lap    a named tool stands on the roster at `tier lap`
#   on cadence   a named tool stands on the roster at `tier cadence`
#   by hand      no tool the row names stands on the roster at all
#
# A ROW IS JUDGED BY WHAT IT NAMES, never by what a reader could work out. Three rows read
# `tools/t/tame_style_scan_bans.rish` alone, and that scan is driven by `tools/t/tame_style_check.rish`,
# which the roster does carry -- so those rows run every lap and their own text could not say so.
# Naming the driver in the row is the repair; teaching this scan a private driver map would put
# the relationship in a second place, where the two can disagree. Same reasoning %714 used for the
# four rows held by a tool they never named.
#
# WHAT IS GATED, hard, at zero.
#   disagree     a row whose declared word differs from the roster's reading
#   undeclared   a row in the table carrying no word at all
#   unnamed      a row naming no `tools/` path, so no word could be derived
#
# WHAT IS REPORTED, never gated. The three populations, by name under `list`. They move whenever a
# guard's tier changes or a row is added, which is ordinary work rather than a fault -- and a
# reader wanting the split reads it here rather than from a sentence somebody typed.
#
# HOW THE TABLE IS FOUND. The first Markdown table after the line `## What We Check, and When`.
# The heading above that table is the sentence %714 found wrong, so anchoring on the heading's
# words would tie this scan to the very text it exists to let a hand repair. The section title is
# stable and names the subject; the table under it is the lint surface by construction.
#
#   sh tools/fixtures/l/lint_table_runs_scan.sh          # measure and gate
#   sh tools/fixtures/l/lint_table_runs_scan.sh list     # name every row, declared and derived
#
# Seated `20260912` on the air rota -- the row that feels, reading law and boundary.

set -eu

PAGE="${LINT_TABLE_PAGE:-context/TAME_GUIDANCE.md}"
ROSTER="${LINT_TABLE_ROSTER:-construction/standing-equipment.kyri}"
SECTION='## What We Check, and When'
MODE="${1:-measure}"

if [ ! -f "$PAGE" ]; then
  echo "page_missing=$PAGE"
  echo "verdict=refused"
  exit 1
fi
if [ ! -f "$ROSTER" ]; then
  echo "roster_missing=$ROSTER"
  echo "verdict=refused"
  exit 1
fi

# The roster's reading, one line per rostered path: "<path> <tier>". A record with no `tier` line
# before the next blank is `lap` by the roster's own default, stated in its header.
roster_tiers() {
  awk '
    /^path / { p = $2; t = ""; next }
    p != "" && /^tier / { t = $2 }
    p != "" && NF == 0 { print p, (t == "" ? "lap" : t); p = ""; t = "" }
    END { if (p != "") print p, (t == "" ? "lap" : t) }
  ' "$ROSTER"
}

# The table: every data row of the first Markdown table after the section line. The table is
# entered at its DELIMITER row rather than at the first bold rule, so a row somebody adds without
# bold is counted rather than vanishing from the census -- a population that can silently drop a
# member is the fault this whole family exists to catch.
table_rows() {
  awk -v section="$SECTION" '
    index($0, section) == 1 { seen = 1; next }
    seen && !intable && /^\|[- :|]+\|[ \t]*$/ { intable = 1; next }
    intable && /^\|/ { print; next }
    intable { exit }
  ' "$PAGE"
}

TIERS=$(roster_tiers)

# One analysis line per row: "<state>\t<rule>\t<declared>\t<derived>". The loop only prints, so
# no counter crosses a subshell boundary and no scratch file is needed -- a lap's own output
# belongs in this tree rather than a shared pen, and the cheapest way to honor that is to want
# no file at all.
report=$(table_rows | while IFS= read -r row; do
  [ -n "$row" ] || continue

  rule=$(printf '%s' "$row" | sed 's/^| *//; s/ *|.*//; s/\*\*//g')

  declared=$(printf '%s' "$row" | sed 's/ *|* *$//; s/.*| *//; s/ *$//')
  case "$declared" in
    "every lap"|"on cadence"|"by hand") : ;;
    *) declared="none" ;;
  esac

  paths=$(printf '%s' "$row" | grep -oE 'tools/[a-z]+/[a-z0-9_.-]+\.(rish|rye|sh)' | sort -u || true)

  if [ -z "$paths" ]; then
    derived="unnamed"
  else
    derived="by hand"
    for p in $paths; do
      tier=$(printf '%s\n' "$TIERS" | awk -v P="$p" '$1 == P { print $2; exit }')
      case "$tier" in
        lap) derived="every lap"; break ;;
        cadence) derived="on cadence" ;;
      esac
    done
  fi

  if [ "$derived" = unnamed ]; then state=unnamed
  elif [ "$declared" = none ]; then state=undeclared
  elif [ "$declared" != "$derived" ]; then state=disagree
  else state=agree
  fi

  printf '%s\t%s\t%s\t%s\n' "$state" "$rule" "$declared" "$derived"
done)

count_state() { printf '%s\n' "$report" | grep -c "^$1	" || true; }
count_derived() { printf '%s\n' "$report" | awk -F'\t' -v W="$1" 'NF && $4 == W { n++ } END { print n + 0 }'; }

rows=$(printf '%s\n' "$report" | awk 'NF { n++ } END { print n + 0 }')
every=$(count_derived "every lap")
cadence=$(count_derived "on cadence")
hand=$(count_derived "by hand")
disagree=$(count_state disagree)
undeclared=$(count_state undeclared)
unnamed=$(count_state unnamed)

if [ "$MODE" = list ]; then
  printf '%s\n' "$report" | awk 'NF'
fi

echo "lint_table_runs: does each lint row keep the claim its heading makes?"
echo "page=$PAGE"
echo "rows=$rows"
echo "runs_every_lap=$every"
echo "runs_on_cadence=$cadence"
echo "runs_by_hand=$hand"
echo "disagree=$disagree"
echo "undeclared=$undeclared"
echo "unnamed=$unnamed"

if [ "$rows" -eq 0 ]; then
  echo "verdict=refused"
  echo "detail: no lint table found under '$SECTION' in $PAGE"
  exit 1
fi
if [ "$disagree" -ne 0 ] || [ "$undeclared" -ne 0 ] || [ "$unnamed" -ne 0 ]; then
  echo "verdict=red"
  echo "detail: run 'sh tools/fixtures/l/lint_table_runs_scan.sh list' to name each row"
  exit 1
fi
echo "verdict=ok"
