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
#   3. THE FOLD RULE: <room>/date/<YYYYMMDD>/<basename>, computed from the stamp alone -- and for
#      a BARE basename, the same rule inside the CITING file own room, since a bare reference was
#      a sibling and a day fold is what separated the siblings
#   4. by basename across every tracked file -- the recovery the full stamp buys
#
# Reading 3 was missing here for one lap while `tools/dated_path_resolve.rish` already had it,
# and the two instruments disagreed the moment four rooms folded: 82 references the resolver
# recovers by computation were reported ambiguous by this scan, because the same basename exists
# in two rooms and the scan had thrown away the room the reference itself names. A census that
# grades by a weaker rule than the tool it measures is not measuring that tool.
# A reference landing by 1 or 2 is HOME. One landing only by 3 is BROKEN and RECOVERABLE --
# the file is here, the path is stale. One that lands nowhere is BROKEN and GONE.
#
# WHAT IS DELIBERATELY OUT OF SCOPE, and why the bound is named rather than assumed:
#   seed/   -- the gitignored public-seed projection of this same tree; counting it would
#              double every reference the projection carries (8,425 of them, measured).
#   vendor/ -- third-party source held unmodified.
#   .git/   -- object storage, not authored prose.
#   INSTRUMENT FIXTURES -- files whose dated paths are selftest literals and demonstration
#              examples rather than citations of the field. Counting the instrument inside its
#              own measurement makes the meter rise every time a proof gets stronger, which is
#              exactly backwards. Each is named with its reason rather than matched by a loose
#              pattern, so the list stays short and every entry has to justify itself:
#                dated_path_*             the resolver, this scan, its control, their witness --
#                                         a resolver is demonstrated on paths that no longer
#                                         stand, and its witness proves verdicts on exactly such
#                                         paths
#                room_bound_control.sh    builds a throwaway room under a mktemp root
#                session_logs_archive.rye its selftest asserts on links inside a sandbox index
#
# USAGE
#   sh tools/fixtures/dated_path_scan.sh            # census -- key=value lines
#   sh tools/fixtures/dated_path_scan.sh list       # every broken reference, one per line
#
# Run from the repository root.

set -eu

verb="${1:-census}"

# THE RATCHET, and what it is honestly a ratchet ON. Corrected `20260821.171500` before the first
# fold ran, because the first shape of this gate would have red on the very move it was built to
# make safe.
#
# Under the mark law a stale reference is RESOLVED, never repointed. So a reference the resolver
# recovers is not damage -- it is the expected steady state, and it necessarily RISES when a room
# folds, since folding is exactly what turns a flat path into a recoverable one. Gating on the
# whole broken count would therefore punish the fold for working.
#
# What must never rise is what the resolver CANNOT recover: a basename that exists nowhere
# (`gone`), and a basename at more than one path where no single answer is safe (`ambiguous`).
# Together those are the LOST references, and they are the honest defect count. Moving a file
# changes its path and never its basename, so a correct fold leaves this number exactly where it
# stood. Set with no slack to the measured count: 199 when the resolver landed, lowered to 193
# on `20260821` when the session-log fold surfaced six index rows pointing at files that were
# never there and they were repaired. Lower it whenever a repair lands; never raise it.
LOST_CEILING=193

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# The tracked corpus is the existence oracle. Symlinked and untracked paths are re-checked on
# disk afterward, so a path a reader can actually follow is never called broken.
git ls-files > "$work/all.txt"

grep -rIoE '(\.\./)*([A-Za-z0-9_.-]+/)*[0-9]{8}-[0-9]{6}_[A-Za-z0-9._-]+\.(md|bron|kyri|rye|rish|tsv|brix|glow|sh)' \
  --include=*.md --include=*.bron --include=*.kyri --include=*.rish \
  --include=*.rye --include=*.sh --include=*.brix --include=*.mdc \
  --exclude-dir=.git --exclude-dir=seed --exclude-dir=vendor \
  --exclude=dated_path_* --exclude=room_bound_control.sh --exclude=session_logs_archive.rye \
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

  # The fold rule, computed rather than searched: a reference names its own room, and a folded
  # file sits under that rooms own date/<day>/ directory. Applied before the basename index so a
  # reference naming its room is never called ambiguous on account of another rooms namesake.
  # (No apostrophes in here -- this comment lives inside a single-quoted awk program.)
  folded = ""
  if (base ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]_/) {
    day = substr(base, 1, 8)
    room = substr(root, 1, length(root) - length(base) - 1)
    if (room != "") {
      c1 = room "/date/" day "/" base
      c2 = room "/archive/" day "/" base
      if (c1 in ex) folded = c1
      else if (c2 in ex) folded = c2
    }
    # A BARE basename was a sibling reference: two files sitting flat in one room, one naming
    # the other with no directory at all. A day fold puts siblings in different day folders and
    # breaks exactly those. The citing file still names the room, so the room is read off it --
    # this uses context the reference already carries rather than guessing between namesakes.
    if (folded == "" && root == base) {
      citer_room = dir
      sub(/\/date\/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/, "", citer_room)
      sub(/\/archive\/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/, "", citer_room)
      if (citer_room != "") {
        s1 = citer_room "/date/" day "/" base
        s2 = citer_room "/archive/" day "/" base
        if (s1 in ex) folded = s1
        else if (s2 in ex) folded = s2
      }
    }
  }

  if (rel in ex || root in ex) { verdict = "home" }
  else if (folded != "")       { verdict = "recoverable"; found = folded }
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
lost=$((ambiguous + gone))
echo "refs_lost=$lost"
echo "lost_ceiling=$LOST_CEILING"

if [ "$lost" -le "$LOST_CEILING" ]; then
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
