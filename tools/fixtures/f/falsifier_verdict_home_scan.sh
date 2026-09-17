#!/bin/sh
# tools/fixtures/f/falsifier_verdict_home_scan.sh -- does a graded row carry its verdict?
#
# A paper of this lane runs an elder paper's falsifier and reaches a verdict.
# The verdict is worth something to exactly one reader: the person who opens the
# ELDER page and reads the row that has since been refuted. So the question this
# scan asks is a question about POSITION rather than about wording -- when a
# child declares `row N of <elder>`, does the elder carry a `Row N erratum` line?
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#
# WHY A POSITION AND NEVER A SPELLING, which is the whole reason this instrument
# exists and the reason it gates what it gates. On `20260909.203002`
# external-research/20260909-203002_the-declaration-grew-in-the-door.md withdrew
# its own proposed construction/falsifier-ledger.kyri and seated one door key in
# its place -- `**Runs the falsifier of:** <elder> -- survived | fired |
# unrunnable` -- with a one-command kill condition: read the next twenty papers,
# and if fewer than half of those running an elder's falsifier use the seated
# spelling, withdraw it. Eight days and 127 pages later the key stands in three
# files, every one of them written before or within the hour of its own seating,
# and the seven papers that ran an elder falsifier since declared the relation
# under SIX other keys -- Answers, Serves, Reads, Grades, Subject, Elder. The
# falsifier fired.
#
# What grew in the same eight days, unprompted, is COMPLETE: all twelve ranked
# rows of active-designing/20260910-060204_the-bounded-torus-moonshots.md carry a
# `Row N erratum:` line stamped by the child paper that graded them. A spelling
# must be remembered and a position is found by looking, which is why one
# converged and the other never did.
#
# THE PAGES READ. Living tracked .md under external-research/ and active-designing/.
# The date/, archive/ and yonder/ shelves are read past: .claude/rules/read-scope.md
# names them closed stacks, and accrete-never-break keeps every word a shelved
# page wrote, so an unanswered declaration there is testimony rather than a debt.
#
# THE READINGS:
#   declarations  -- a line naming an elder basename and a row number, under any
#                    key, in either order. Form A carries its own pairing --
#                    `row N of [`basename`]`; form B has the link and the row on
#                    one line and is paired first-with-first.
#   answered      -- the elder page carries a matching `**Row <N> erratum:**`
#   unanswered    -- it does not. GATED AT ZERO: the child already did the work,
#                    and the reader who needs it is standing on the elder page.
#   elder_missing -- the basename resolves to no living tracked page. REPORTED:
#                    an elder that folded to a shelf is lawful, and the resolver
#                    at tools/d/dated_path_resolve.rish is how a reference to one
#                    is recovered rather than rewritten.
#   elders_distinct -- how many elder pages the declarations name. One today, so
#                    the census describes one page's habit and says so out loud.
#   erratum_no_paper -- an erratum whose stamp names no page in the two rooms.
#                    REPORTED and never gated: a lap may run a witness and record
#                    the result without writing a paper, and two such stand today.
#   key_seated    -- files carrying the withdrawn spelling. REPORTED. Gating a
#                    spelling this instrument's own paper refuted would be a meter
#                    arguing with its own reading.
#
# WHAT IT CANNOT READ, counted rather than hidden. A child that grades an elder
# WITHOUT naming a row -- prose alone, or a whole-paper verdict -- is invisible
# here, and the elder page proved by hand that a regular expression over firing
# language finds two of six. So `declarations` is a floor on the real population,
# never the population, and the gate is honest exactly to the extent that a hand
# wrote the row number down.
set -eu

[ -d .git ] || { echo "verdict=not_a_repo"; exit 2; }

list=false
[ "${1:-}" = "--list" ] && list=true

# Bound everything (TAME): a collection past this many declarations is one this
# reading was never sized for, and it refuses rather than truncating in silence.
MAX_DECL=4096

pages=$(mktemp 2>/dev/null || echo "./.vh_pages.$$")
decl=$(mktemp 2>/dev/null || echo "./.vh_decl.$$")
errata=$(mktemp 2>/dev/null || echo "./.vh_errata.$$")
trap 'rm -f "$pages" "$decl" "$errata"' EXIT INT TERM

git ls-files 'external-research/*.md' 'active-designing/*.md' 2>/dev/null \
  | grep -vE '/(date|archive|yonder)/' > "$pages" || true

living=$(wc -l < "$pages" | tr -d ' ')
[ "$living" -gt 0 ] || { echo "verdict=no_pages_found"; exit 2; }

# ONE AWK for the declarations. A door line carries the relation as
# `**<Key>:** row <N> of [`<basename>`](...)`; the key is captured rather than
# constrained, because the census of keys is the reading that fired the spelling.
< "$pages" xargs awk '
  {
    line = $0
    if (line !~ /\[`[0-9]{8}-[0-9]{6}/) next
    if (line !~ /row [0-9]+/) next
    key = "-"
    if (match(line, /^\*\*[A-Za-z ]+:\*\*/)) key = substr(line, RSTART + 2, RLENGTH - 5)

    # FORM A -- `row N of [`basename`]`, the shape that carries its own pairing.
    hits = 0
    rest = line
    while (match(rest, /row [0-9]+ of \[`[0-9]{8}-[0-9]{6}[^`]*`\]/)) {
      hit = substr(rest, RSTART, RLENGTH)
      rest = substr(rest, RSTART + RLENGTH)
      n = hit; sub(/^row /, "", n); sub(/ .*/, "", n)
      b = hit; sub(/^.*\[`/, "", b); sub(/`\].*$/, "", b)
      printf "decl\tA\t%s\t%s\t%s\t%s\n", FILENAME, key, n, b
      hits++
    }
    if (hits > 0) next

    # FORM B -- the link and the row number on one line in either order, which is
    # how three declarations in this collection are actually written. It is confined
    # to a DOOR line -- a `**Key:**` field inside the first 25 lines of the page --
    # because outside the door that shape is ordinary prose about a table, and an
    # unconfined form B read 15 such lines and named 13 elders that were never
    # graded. The door bound of 25 comes from the withdrawal paper, which counted
    # adoption in `a header field within the first twenty-five lines`.
    # First is paired with first, so a door line naming two rows of two elders
    # reads as one and the census undercounts rather than guessing.
    if (key == "-" || FNR > 25) next
    match(line, /\[`[0-9]{8}-[0-9]{6}[^`]*`\]/)
    b = substr(line, RSTART + 2, RLENGTH - 4)
    match(line, /row [0-9]+/)
    n = substr(line, RSTART + 4, RLENGTH - 4)
    printf "decl\tB\t%s\t%s\t%s\t%s\n", FILENAME, key, n, b
  }
' > "$decl" || true

declarations=$(awk 'END{print NR+0}' "$decl")
[ "$declarations" -le "$MAX_DECL" ] || { echo "verdict=over_bound"; echo "detail: $declarations declarations past MAX_DECL=$MAX_DECL"; exit 2; }

# ONE AWK for the errata, keyed by page and row, so the answer side is read once
# rather than once per declaration.
# `anchored` is a variable rather than a `^` inside the pattern so the pen can
# lift the anchor in one substitution: an elder MENTIONING an erratum mid-sentence
# must never read as carrying one, and a mutation is how that is proven.
< "$pages" xargs awk -v anchored=1 '
  {
    if (!match($0, /\*\*Row [0-9]+ erratum:\*\*/)) next
    if (anchored && RSTART != 1) next
    n = $0; sub(/^.*\*\*Row /, "", n); sub(/ .*/, "", n)
    s = "-"
    if (match($0, /`[0-9]{8}\.[0-9]{6}`/)) s = substr($0, RSTART + 1, RLENGTH - 2)
    printf "err\t%s\t%s\t%s\n", FILENAME, n, s
  }
' > "$errata" || true

errata_total=$(awk 'END{print NR+0}' "$errata")

form_b=$(awk -F'\t' '$2=="B"{n++} END{print n+0}' "$decl")
answered=0
unanswered=0
elder_missing=0

while IFS="$(printf '\t')" read -r _t form child key n base; do
  [ -n "${base:-}" ] || continue
  elder=$(grep -E "/${base}\$" "$pages" | head -1 || true)
  if [ -z "$elder" ]; then
    elder_missing=$((elder_missing + 1))
    $list && echo "detail: elder_missing $child form=$form key=$key row=$n elder=$base"
    continue
  fi
  if awk -F'\t' -v p="$elder" -v n="$n" '$2==p && $3==n {found=1} END{exit found?0:1}' "$errata"; then
    answered=$((answered + 1))
    $list && echo "detail: answered $child form=$form key=$key row=$n elder=$base"
  else
    unanswered=$((unanswered + 1))
    $list && echo "detail: unanswered $child form=$form key=$key row=$n elder=$base"
  fi
done < "$decl"

# An erratum's stamp names the lap that graded the row. Where no page in these
# two rooms carries that stamp, the evidence lives in a session log instead --
# lawful, and worth seeing.
erratum_no_paper=0
while IFS="$(printf '\t')" read -r _t page n stamp; do
  [ "${stamp:-}" = "-" ] && continue
  hyph=$(printf '%s' "$stamp" | tr '.' '-')
  if ! grep -q "/${hyph}_" "$pages"; then
    erratum_no_paper=$((erratum_no_paper + 1))
    $list && echo "detail: erratum_no_paper $page row=$n stamp=$stamp"
  fi
done < "$errata"

elders_distinct=$(awk -F'\t' '$1=="decl"{print $6}' "$decl" | sort -u | awk 'END{print NR+0}')
keys_distinct=$(awk -F'\t' '$1=="decl"{print $4}' "$decl" | sort -u | tr '\n' ',' | sed 's/,$//')
keys_count=$(awk -F'\t' '$1=="decl"{print $4}' "$decl" | sort -u | wc -l | tr -d ' ')
key_seated=$(< "$pages" xargs grep -l 'Runs the falsifier of:' 2>/dev/null | wc -l | tr -d ' ')

verdict=answered
[ "$unanswered" -gt 0 ] && verdict=unanswered

echo "living_pages=$living"
echo "declarations=$declarations"
echo "declarations_form_b=$form_b"
echo "answered=$answered"
echo "unanswered=$unanswered"
echo "elder_missing=$elder_missing"
echo "errata_total=$errata_total"
echo "erratum_no_paper=$erratum_no_paper"
echo "elders_distinct=$elders_distinct"
echo "keys_count=$keys_count"
echo "keys=$keys_distinct"
echo "key_seated=$key_seated"
echo "verdict=$verdict"
