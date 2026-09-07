#!/bin/sh
# grain_strand_count_scan.sh -- the grain's strand count, derived from the page that holds the strands.
#
# WHY. `foundations/20260826-024942_the-grain-and-the-crossing.md` is one of the two canonical hubs
# every leaf foundation routes through, and it names the standing commitments an idea must be cut to
# fit. Ten strands were seated `20260702`. Three more were seated `20260802` under *Strands Seated at
# the Fusion* -- the content address is the wall, a guard that cannot red guards nothing, and the
# crossing has twins -- each of them "beside the elders" in the page's own words. The page has held
# THIRTEEN since that day.
#
# Eight living sentences across five documents still say ten, measured `20260907.055715`: the
# foundations front door, the day-one compass rose, the compass foundation in four places, the aether
# threshold page the rota reads first, and a manual tutorial. Every one of them is a POINTER at the
# canonical page, and every one carried a total rather than deriving it -- which is exactly what
# `.claude/rules/stamp-and-name.md` rule 3 forbids: *count, never number*, because a total carried
# inside a sentence stays at whatever it was on the day somebody typed it.
#
# SO THE COUNT IS DERIVED HERE AND NOWHERE ELSE. This scan reads the canonical page's own structure
# -- the elder roster's bullets and the fusion section's bold-lead strands -- and then holds every
# living document that spells a DIFFERENT count at zero. Seat a fourteenth strand tomorrow and the
# derivation moves with it; the guard needs no edit.
#
#   sh tools/fixtures/g/grain_strand_count_scan.sh          # the counts
#   sh tools/fixtures/g/grain_strand_count_scan.sh list      # one line per disagreeing sentence
#   GRAIN_ROOT=<dir> sh tools/fixtures/g/grain_strand_count_scan.sh
#
# WHAT IS READ, AND WHAT IS LEFT ALONE. Tracked `.md` and `.mdc` documents, minus every `date/`,
# `archive/`, and `yonder/` shelf and the closed stacks named in `.claude/rules/read-scope.md`.
# Dated testimony keeps every word it wrote (accrete-never-break), so a session log or a counsel
# piece saying ten is a true record of the day it was written and is read past here.
#
# BOUNDS: at most 4000 documents scanned, at most 200 disagreements reported.
set -eu

root=${GRAIN_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
MAX_DOCS=4000
MAX_REPORT=200
page=${GRAIN_PAGE:-foundations/20260826-024942_the-grain-and-the-crossing.md}

[ -f "$page" ] || { echo "refused: the canonical grain page is absent at $page -- every count below would be derived from nothing" >&2; exit 2; }

# The elder roster: the bullet list under `## The Grain, Defined`, each strand a bold-led item.
elder=$(awk '/^## The Grain, Defined/{a=1} /^## The Crossing, Defined/{a=0} a && /^- \*\*/{n++} END{print n+0}' "$page")
# The fusion strands: bold-lead paragraphs under their own heading. The section's own opening
# sentence carries no bold lead, so it is not miscounted as a strand.
fusion=$(awk '/^## Strands Seated at the Fusion/{a=1;next} /^## /{a=0} a && /^\*\*[^*]/{n++} END{print n+0}' "$page")

# invariant: a corpus of zero is a red, never a reading (REDS %170). Either count reading zero means
# the page's headings moved and the derivation is measuring nothing at all.
[ "$elder" -gt 0 ] || { echo "refused: no elder strand bullets found under '## The Grain, Defined' -- the page's shape moved" >&2; exit 2; }
[ "$fusion" -gt 0 ] || { echo "refused: no bold-lead strands found under '## Strands Seated at the Fusion' -- the page's shape moved" >&2; exit 2; }

total=$((elder + fusion))

work=$(mktemp -d "${TMPDIR:-/tmp}/grain-strand.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files '*.md' '*.mdc' 2>/dev/null \
  | grep -v -E '/(date|archive|yonder)/' \
  | grep -v -E '^(session-logs|counsel|waymarks|external-research|gratitude|vendor|seed|research-silo|bron-resins|press|saga|journey|spellbook)/' \
  | head -"$MAX_DOCS" > "$work/docs.txt"

# invariant: the document corpus is never empty here either -- an empty list would report zero
# disagreements while reading no prose at all.
[ -s "$work/docs.txt" ] || { echo "refused: no living documents to read -- the count below would be vacuous" >&2; exit 2; }

# A sentence counts the grain's strands when a number stands within a short span before the word,
# on a line that also names the grain. The span is deliberately short: `ten standing strands`,
# `Ten strands`, `ten **grain strands**` all qualify, while a paragraph mentioning a number and a
# strand thirty words apart does not.
: > "$work/stale.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  awk -v file="$f" -v total="$total" '
    BEGIN {
      split("one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty", w, " ")
      for (i = 1; i <= 20; i++) num[w[i]] = i
    }
    {
      line = tolower($0)
      # The line must name the grain at all; the project shares the word, so the shape below does
      # the rest of the work.
      if (line !~ /grain/) next
      # Strip markdown emphasis and treat a hyphen as a space, so `ten **grain strands**` and
      # `ten-strand` both read as plain adjacent words.
      gsub(/[*`_]/, "", line)
      gsub(/[-]+/, " ", line)
      n = split(line, tok, /[^a-z0-9]+/)
      for (i = 1; i <= n; i++) {
        v = 0
        if (tok[i] in num) v = num[tok[i]]
        else if (tok[i] ~ /^[0-9]+$/) v = tok[i] + 0
        # A count of one is never a roster reading -- `hold one strand` speaks of a single strand
        # rather than of how many the grain has -- so the floor here and the plural noun below keep
        # ordinary prose out of the count.
        if (v < 2) continue
        # The number must govern the noun within two words: `ten strands`, `ten grain strands`,
        # `ten structural strands`. A number and a strand thirty words apart share only a line.
        for (j = i + 1; j <= i + 3 && j <= n; j++) {
          if (tok[j] == "strands") {
            if (v != total) printf "%s:%d\t%d\t%s\n", file, FNR, v, substr($0, 1, 120)
            i = n
            break
          }
        }
      }
    }
  ' "$f" >> "$work/stale.txt"
done < "$work/docs.txt"

# Does the canonical page state its own count in words? Without this reading the guard would pass a
# tree where nobody spells the number at all, and the next reader would be back to tallying bullets.
states=no
if awk -v total="$total" '
  BEGIN {
    split("one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty", w, " ")
    for (i = 1; i <= 20; i++) num[w[i]] = i
  }
  { line = tolower($0); gsub(/[*`_]/, "", line); n = split(line, tok, /[^a-z0-9]+/)
    for (i = 1; i <= n; i++) { v = 0
      if (tok[i] in num) v = num[tok[i]]; else if (tok[i] ~ /^[0-9]+$/) v = tok[i] + 0
      if (v != total) continue
      for (j = i + 1; j <= i + 3 && j <= n; j++) if (tok[j] == "strands") { found = 1 }
    }
  }
  END { exit(found ? 0 : 1) }
' "$page"; then states=yes; fi

stale=$(wc -l < "$work/stale.txt" | tr -d ' ')

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/stale.txt" | while IFS="$(printf '\t')" read -r where said text; do
    printf 'stale: %s says %s where the page holds %s -- %s\n' "$where" "$said" "$total" "$text"
  done
fi

echo "page=$page"
echo "strands_elder=$elder"
echo "strands_fusion=$fusion"
echo "strands_total=$total"
echo "page_states=$states"
echo "docs_read=$(wc -l < "$work/docs.txt" | tr -d ' ')"
echo "stale_counts=$stale"
