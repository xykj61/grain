#!/bin/sh
# tools/fixtures/dated_path_scan.sh -- the dated-reference census.
#
# WHY. Every folded room leaves references behind that point at the flat path a file used to
# hold. This walks every dated reference in the field, resolves each the way a reader would,
# and reports how many still land. Driven by tools/dated_path_witness.rish.
#
# WHAT A DATED REFERENCE IS. Any string shaped YYYYMMDD-HHMMSS_slug.ext, with an optional
# directory prefix and any number of leading ../ segments.
#
# HOW EACH ONE IS RESOLVED, first hit winning:
#   1. relative to the file that cites it   -- how a Markdown link actually resolves
#   2. root-relative, leading ../ stripped  -- how this tree's prose usually cites
#   3. by basename across every tracked file -- the recovery the full stamp buys
# A reference landing by 1 or 2 is HOME. One landing only by 3 is BROKEN and RECOVERABLE --
# the file is here, the path is stale. One that lands nowhere is BROKEN and GONE.
#
# WHAT IS DELIBERATELY OUT OF SCOPE, and why the bound is named rather than assumed:
#   seed/   -- the gitignored public-seed projection of this same tree; counting it would
#              double every reference the projection carries (8,425 of them, measured).
#   vendor/ -- third-party source held unmodified.
#   .git/   -- object storage, not authored prose.
#   dated_path_* -- the resolver, this scan, its control corpus, and their witness. Their example references are
#              deliberately stale BY CONSTRUCTION -- a resolver is demonstrated on paths that no
#              longer stand, and a witness proves its verdicts on exactly such paths. Those are
#              fixtures, not defects, and counting the instrument inside its own measurement
#              would make the ceiling rise every time the proof got stronger.
#
# USAGE
#   sh tools/fixtures/dated_path_scan.sh            # census -- key=value lines
#   sh tools/fixtures/dated_path_scan.sh list       # every broken reference, one per line
#
# Run from the repository root.

set -eu

verb="${1:-census}"

# THE RATCHET. Broken references only ever come down. This ceiling was set to the count
# measured on `20260821` when the resolver landed, with no slack: from here a fold that leaves a
# reference dangling, or a new document citing a path that no longer stands, reds on the lap it
# enters rather than months later. Lower it whenever a repair lands; never raise it.
BROKEN_CEILING=4138

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# The tracked corpus is the existence oracle. Symlinked and untracked paths are re-checked on
# disk afterward, so a path a reader can actually follow is never called broken.
git ls-files > "$work/all.txt"

grep -rIoE '(\.\./)*([A-Za-z0-9_.-]+/)*[0-9]{8}-[0-9]{6}_[A-Za-z0-9._-]+\.(md|bron|kyri|rye|rish|tsv|brix|glow|sh)' \
  --include=*.md --include=*.bron --include=*.kyri --include=*.rish \
  --include=*.rye --include=*.sh --include=*.brix --include=*.mdc \
  --exclude-dir=.git --exclude-dir=seed --exclude-dir=vendor \
  --exclude=dated_path_* \
  . 2>/dev/null | sed 's|^\./||' > "$work/pairs.txt"

# Six fields out, so no later step has to guess which path a column holds:
#   verdict, citing file, reference as written, reading one, reading two, recovered home
awk -F: '
NR==FNR { ex[$0] = 1; n = split($0, p, "/"); base = p[n]; cnt[base]++; where[base] = $0; next }
{
  file = $1; ref = $2
  key = file "\t" ref; if (seen[key]++) next
  dir = file; sub(/\/[^\/]*$/, "", dir); if (dir == file) dir = ""

  cand = (dir == "" ? ref : dir "/" ref)
  n = split(cand, seg, "/"); j = 0
  for (i = 1; i <= n; i++) {
    s = seg[i]
    if (s == "." || s == "") continue
    if (s == "..") { if (j > 0) j--; continue }
    out[++j] = s
  }
  rel = ""; for (i = 1; i <= j; i++) rel = rel (i > 1 ? "/" : "") out[i]

  root = ref; while (sub(/^\.\.\//, "", root)) ;

  n = split(ref, p, "/"); base = p[n]
  found = (base in cnt) ? where[base] : "-"

  if (rel in ex || root in ex) { verdict = "home" }
  else if (cnt[base] == 1)     { verdict = "recoverable" }
  else if (cnt[base] > 1)      { verdict = "ambiguous" }
  else                         { verdict = "gone" }

  print verdict "\t" file "\t" ref "\t" rel "\t" root "\t" found
}' "$work/all.txt" "$work/pairs.txt" > "$work/class.txt"

# A symlinked or untracked path still resolves for a reader, so re-check the two readings on
# disk before calling anything broken -- work-in-progress -> crux is the standing case. Only
# the doubtful lines reach the disk, so it is touched once per doubt rather than once per
# reference. The recovered-home column is never tested here; it exists by construction.
awk -F'\t' '$1 == "home"' "$work/class.txt" > "$work/final.txt"
awk -F'\t' '$1 != "home"' "$work/class.txt" > "$work/doubt.txt"
tab="$(printf '\t')"
while IFS="$tab" read -r verdict file ref rel root found; do
  [ -n "${verdict:-}" ] || continue
  if { [ -n "$rel" ] && [ -e "$rel" ]; } || { [ -n "$root" ] && [ -e "$root" ]; }; then
    verdict=home
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$verdict" "$file" "$ref" "$rel" "$root" "$found" >> "$work/final.txt"
done < "$work/doubt.txt"

if [ "$verb" = list ]; then
  awk -F'\t' '$1 != "home"' "$work/final.txt"
  exit 0
fi

# One pass for every count, so the four buckets and the total are read off the same file in
# the same moment and cannot disagree with each other.
eval "$(awk -F'\t' '
  { total++; n[$1]++ }
  END {
    printf "total=%d\nhome=%d\nrecoverable=%d\nambiguous=%d\ngone=%d\n",
      total, n["home"], n["recoverable"], n["ambiguous"], n["gone"]
  }' "$work/final.txt")"
broken=$((recoverable + ambiguous + gone))

echo "refs_total=$total"
echo "refs_home=$home"
echo "refs_broken=$broken"
echo "broken_recoverable=$recoverable"
echo "broken_ambiguous=$ambiguous"
echo "broken_gone=$gone"
echo "ceiling=$BROKEN_CEILING"

if [ "$broken" -le "$BROKEN_CEILING" ]; then
  echo "under_ceiling=yes"
else
  echo "under_ceiling=no"
fi

# The census is trustworthy only if every reference landed in exactly one bucket.
if [ "$((home + broken))" -eq "$total" ] && [ "$total" -gt 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=unsound"
  exit 1
fi
