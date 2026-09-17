#!/bin/sh
# tools/fixtures/f/falsifier_reach_scan.sh -- can a stated falsifier ever fire?
#
# Gauge at its Field setting asks every projection to carry a horizon, its
# assumptions, a FALSIFIER, and a confidence in plain words
# (context/GAUGE_STYLE.md). This seat's own charter sharpens the same sentence:
# a speculative paper that says which measurement would kill it is research, and
# one that does not is enthusiasm. Both stood on no instrument. Three corpus
# readers watch the code disciplines -- tools/w/width-check.rish over the widths,
# tools/t/tame-check.rish over the tidy bans, tools/fixtures/a/alloc_bound_reach_scan.sh
# over rule 1's call sites -- and the PROSE discipline this tree writes its
# research in had none.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#
# THE CORPUS, and why it stops where it does. Living tracked .md under
# external-research/ and active-designing/, which is 493 pages at this stamp.
# The date/, archive/ and yonder/ shelves are read past -- .claude/rules/read-scope.md
# names them closed stacks and accrete-never-break keeps every word they wrote,
# so a shelved page is testimony rather than a claim this tree still makes. That
# boundary removes 1,079 of 1,572 pages, and it is printed as `shelved_read_past`
# so a reader can see the size of what was set aside.
#
# THE REGION, which is the whole instrument. A falsifier's CONDITION rarely sits
# on the line carrying the word. A first draft read line by line, found 676
# mentions, and classed 509 of them as carrying no condition -- because
# `## The falsifier` is a heading whose condition lives in the block beneath it.
# That is the same fragment-reading error the allocation scan one lane over made
# on `@as(usize, @intCast(total))`, and it is why the walk reads a REGION:
#   heading mention  -- the block beneath it, skipping blank lines first
#   inline mention   -- from that line to the end of its paragraph
# bounded at 12 lines either way. A mention already inside a captured region is
# counted once. `mention_lines` is every LINE carrying the word and `regions_nested`
# is what the region walk folded away, so two mentions on ONE line read as one.
#
# THE CLASSES, first match wins, which makes them a partition rather than tags:
#   runnable   -- the region names a path this tree carries or a command form
#                 (sh, rishi run, rye run, git grep). Somebody can run it today.
#   quantified -- the region carries a QUANTITY: a digit, a percent, or a spelled
#                 number. "two seasons running", "under 40% of nameplate hours".
#                 The honest shape for a claim about a river basin or a mill,
#                 where the measurement is in the world rather than in the tree.
#   narrative  -- neither. A condition stated in prose with nothing to count.
#                 REPORTED and never gated: "a corridor whose verifiers are paid
#                 by the mill" is genuinely checkable by looking, and calling it
#                 unfalsifiable would be the meter lying about its own reach.
#
# THE ONE WALL, and it is decidable by text. A page that DECLARES Gauge at the
# Field setting in its own header, carries projection language, and names no
# falsifier anywhere on the page, has broken a promise it wrote itself. 21 such
# pages stand at this stamp. They are held in a tracked roster --
# tools/fixtures/f/falsifier_field_baseline.txt -- and the count splits the way
# bakery's root-finder census split on 20260917: `unfalsified_new`, a page the
# roster leaves out, GATED AT ZERO; `unfalsified_legacy`, the roster's own,
# ratcheted under a ceiling that only falls. A lap writing a new Field page with
# a projection pays one sentence, which is the law that page already declared.
# An absent roster REFUSES, since a gate whose roster can be deleted into silence
# is a gate with a door beside it.
#
# THE FALSIFIER OF THIS SCAN'S OWN HEADLINE, stated ahead of the run. If most
# narrative regions sit on pages that ALSO carry a runnable or quantified one,
# the narrative count measures a WRITING STYLE -- many short falsifiers per page
# -- rather than a gap. `page_narrative_only` is the reading that survives that
# widening, and it is printed beside the region counts for exactly that reason.
#
# WHAT IT CANNOT READ, counted rather than hidden. A region hitting the 12-line
# bound may carry its condition below the cut: `regions_truncated`. A quantity
# inside a citation ("20260917", "REDS %811") reads as a number and lifts a
# region to `quantified` that a hand would call narrative; stamps and REDS rows
# are stripped before the quantity test, and what survives is printed as
# `quantified_by_year` so the softest part of the reading names itself.
set -eu

[ -d .git ] || { echo "verdict=not_a_repo"; exit 2; }

list=false
[ "${1:-}" = "--list" ] && list=true

# THE ROSTER IS A PATH RATHER THAN A CONSTANT, so a repair is one line a reader
# can see in a diff, where a ceiling edit is a number nobody can attribute.
BASELINE=tools/fixtures/f/falsifier_field_baseline.txt
LEGACY_CEILING=21

MAX_REGION_LINES=12

pages=$(mktemp 2>/dev/null || echo "./.fals_pages.$$")
regions=$(mktemp 2>/dev/null || echo "./.fals_regions.$$")
pagecls=$(mktemp 2>/dev/null || echo "./.fals_pagecls.$$")
trap 'rm -f "$pages" "$regions" "$pagecls"' EXIT INT TERM

# `git ls-files` IS the boundary: an untracked draft and a vendored page are both
# outside it, so no exclusion roster can drift out of step with the tree.
git ls-files 'external-research/*.md' 'active-designing/*.md' 2>/dev/null \
  | grep -vE '/(date|archive|yonder)/' > "$pages" || true

living=$(wc -l < "$pages" | tr -d ' ')
[ "$living" -gt 0 ] || { echo "verdict=no_pages_found"; exit 2; }

all_pages=$(git ls-files 'external-research/*.md' 'active-designing/*.md' 2>/dev/null | wc -l | tr -d ' ')
shelved=$((all_pages - living))

[ -f "$BASELINE" ] || { echo "verdict=no_baseline"; echo "detail: $BASELINE is absent -- a gate whose roster can be deleted into silence is a gate with a door beside it"; exit 2; }

# ONE AWK OVER THE WHOLE CORPUS. State resets on FNR==1, so a paragraph never
# runs across a file boundary the way a concatenated stream would let it.
< "$pages" xargs awk -v maxr="$MAX_REGION_LINES" '
function flush_region(   t, cls, q, yr) {
  if (rlines == 0) return
  t = rtext
  # A tree stamp (20260917), a REDS row (%811), and a dated basename are
  # CITATIONS rather than measurements. Strip them before the quantity test, or
  # every well-cited narrative falsifier reads as quantified.
  yr = t
  gsub(/20[0-9]{6}[-.][0-9]{6}/, " ", t)
  gsub(/20[0-9]{6}/, " ", t)
  gsub(/%[0-9]+/, " ", t)
  cls = "narrative"
  if (t ~ /tools\/|\.rish|\.rye\b|\.sh\b|rishi run|rye run|git grep|git log/) cls = "runnable"
  else {
    q = 0
    if (t ~ /[0-9]/) q = 1
    if (t ~ /(^|[^a-z])(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|dozen|half|third|quarter|percent)([^a-z]|$)/) q = 1
    if (q) cls = "quantified"
  }
  printf "region\t%s\t%s\t%d\t%d\t%s\n", cls, FILENAME, rstart, truncated, (cls != "quantified") ? "-" : ((t ~ /[0-9]/) ? "digits" : "words")
  rtext = ""; rlines = 0; truncated = 0
}
FNR == 1 { flush_region(); inregion = 0; pend = 0 }
{
  line = $0
  if (tolower(line) ~ /falsifi/) mentions++
  if (inregion) {
    if (pend && line ~ /^[ \t]*$/) { flush_region(); inregion = 0; next }
    if (!pend && line !~ /^[ \t]*$/) pend = 1
    if (line !~ /^[ \t]*$/ || pend) { rtext = rtext " " line; rlines++ }
    if (rlines >= maxr) { truncated = 1; flush_region(); inregion = 0 }
    next
  }
  if (tolower(line) !~ /falsifi/) next
  rstart = FNR; rtext = line; rlines = 1; truncated = 0; inregion = 1
  # A HEADING carries the word and no condition; the block beneath it does. The
  # pending flag lets the walk skip the blank line that always follows a heading.
  if (line ~ /^[ \t]*#+[ \t]/) { rtext = ""; rlines = 0; pend = 0 }
  else pend = 1
}
END { flush_region(); printf "mentions\t%d\n", mentions + 0 }
' > "$regions" 2>/dev/null

# THE WALK ALWAYS EMITS ITS MENTION TALLY, so an empty file means awk never ran and a
# broken pipeline would otherwise print the same zeros a clean corpus prints. A corpus
# where NO page names a falsifier is a lawful reading rather than a refusal -- it is
# precisely the state the wall below exists to catch.
records=$(awk 'END{print NR+0}' "$regions")
[ "$records" -gt 0 ] || { echo "verdict=walk_failed"; exit 2; }

cls_count() { awk -F'\t' -v c="$1" '$1=="region" && $2==c{n++} END{print n+0}' "$regions"; }

runnable=$(cls_count runnable)
quantified=$(cls_count quantified)
narrative=$(cls_count narrative)
region_total=$((runnable + quantified + narrative))
truncated=$(awk -F'\t' '$1=="region" && $5==1{n++} END{print n+0}' "$regions")
by_words=$(awk -F'\t' '$1=="region" && $2=="quantified" && $6=="words"{n++} END{print n+0}' "$regions")
mentions=$(awk -F'\t' '$1=="mentions"{print $2+0}' "$regions")
[ -n "$mentions" ] || mentions=0
nested=$((mentions - region_total))
[ "$nested" -ge 0 ] || nested=0

# THE PAGE PASS -- the reading that decides what the region counts MEAN, and the
# one the stated falsifier asked for.
: > "$pagecls"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  hasf=no;  grep -qi 'falsifi' "$f" && hasf=yes
  hasp=no;  grep -qiE 'projection|projected|forecast|horizon' "$f" && hasp=yes
  field=no; head -25 "$f" | grep -qiE 'field setting|gauge, field|setting:[ \t]*field' && field=yes
  best=none
  if [ "$hasf" = yes ]; then
    if awk -F'\t' -v p="$f" '$1=="region" && $3==p && $2=="runnable"{found=1} END{exit found?0:1}' "$regions"; then best=runnable
    elif awk -F'\t' -v p="$f" '$1=="region" && $3==p && $2=="quantified"{found=1} END{exit found?0:1}' "$regions"; then best=quantified
    else best=narrative
    fi
  fi
  printf '%s\t%s\t%s\t%s\t%s\n' "$f" "$hasf" "$hasp" "$field" "$best" >> "$pagecls"
done < "$pages"

pages_falsifier=$(awk -F'\t' '$2=="yes"{n++} END{print n+0}' "$pagecls")
pages_projection=$(awk -F'\t' '$3=="yes"{n++} END{print n+0}' "$pagecls")
pages_field=$(awk -F'\t' '$4=="yes"{n++} END{print n+0}' "$pagecls")
page_runnable=$(awk -F'\t' '$5=="runnable"{n++} END{print n+0}' "$pagecls")
page_quantified=$(awk -F'\t' '$5=="quantified"{n++} END{print n+0}' "$pagecls")
page_narrative_only=$(awk -F'\t' '$5=="narrative"{n++} END{print n+0}' "$pagecls")
projection_no_falsifier=$(awk -F'\t' '$3=="yes" && $2=="no"{n++} END{print n+0}' "$pagecls")

# THE WALL. A page declaring Field, carrying a projection, and naming no
# falsifier, split by whether the tracked roster already knows it.
roster=$(grep -vE '^[ \t]*(#|$)' "$BASELINE" | tr '\n' '|' || true)
unfal_new=0
unfal_legacy=0
: > "$regions.wall"
while IFS="$(printf '\t')" read -r f hasf hasp field best; do
  [ "$field" = yes ] || continue
  [ "$hasp" = yes ] || continue
  [ "$hasf" = no ] || continue
  case "|$roster" in
    *"|$f|"*) unfal_legacy=$((unfal_legacy + 1)); g=legacy ;;
    *)        unfal_new=$((unfal_new + 1));       g=new ;;
  esac
  printf '%s\t%s\n' "$f" "$g" >> "$regions.wall"
done < "$pagecls"

if [ "$list" = true ]; then
  awk -F'\t' '$1=="region"{printf "detail: region class=%s %s:%s truncated=%s by=%s\n", $2, $3, $4, $5, $6}' "$regions"
  [ -s "$regions.wall" ] && awk -F'\t' '{printf "detail: unfalsified growth=%s %s\n", $2, $1}' "$regions.wall"
fi
rm -f "$regions.wall"

echo "living_pages=$living"
echo "shelved_read_past=$shelved"
echo "pages_with_falsifier=$pages_falsifier"
echo "pages_with_projection=$pages_projection"
echo "pages_declaring_field=$pages_field"
echo "projection_no_falsifier=$projection_no_falsifier"
echo "regions=$region_total"
echo "runnable=$runnable"
echo "quantified=$quantified"
echo "narrative=$narrative"
echo "quantified_by_words=$by_words"
echo "regions_truncated=$truncated"
echo "mention_lines=$mentions"
echo "regions_nested=$nested"
echo "page_runnable=$page_runnable"
echo "page_quantified=$page_quantified"
echo "page_narrative_only=$page_narrative_only"
echo "unfalsified_new=$unfal_new"
echo "unfalsified_legacy=$unfal_legacy"
echo "legacy_ceiling=$LEGACY_CEILING"

if [ "$unfal_new" -gt 0 ]; then
  echo "verdict=unfalsified_field_page"
  exit 1
fi
if [ "$unfal_legacy" -gt "$LEGACY_CEILING" ]; then
  echo "verdict=legacy_over_ceiling"
  exit 1
fi
echo "verdict=ok"
