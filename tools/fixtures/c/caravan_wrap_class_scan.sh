#!/bin/sh
# tools/fixtures/c/caravan_wrap_class_scan.sh -- every wrap site in the caravan room says which wrap it is.
#
# The room law (the optimization spine, move one, seated from
# active-designing/20260826-021136_caravan-rearchitected-the-optimization-spine.md): wrap where the
# quantity is genuinely periodic, assert where it is linear, and every wrap site carries an
# `// invariant:` comment naming which of the two it is. This scan is the law's meter: it reads
# every authored source in caravan/, finds each modulo or wrapping-arithmetic site, and holds the
# count of sites without a classification at zero.
#
# What counts as a site, and what stays free:
#   * A modulo whose result becomes a value -- `seq % max_outstanding` -- is a wrap site, and owes
#     a `wrap-as-periodic` or `wrap-as-linear` line within the six lines above it (a classification
#     comment may run several lines; the token is what the meter reads).
#   * A modulo feeding a comparison with zero -- `extent % page == 0` -- is a divisibility
#     predicate: nothing wraps, no comment owed. The room holds eight of these today.
#   * Zig's wrapping operators (`+%`, `-%`, `*%`) are sites the day they arrive; the room holds
#     none today, and the scan reads for them so the first one is loud.
#   * A symlink is skipped -- its laws belong to the room its target lives in.
#   * Comment lines are read for tokens, never for sites, so prose about wrapping stays free.
#
# Honest limit: a modulo inside a string literal would read as a site. The room's sources hold no
# such string today, and the day one arrives the scan speaks and a classification comment answers.
#
# Portable on purpose: POSIX sh + awk, no GNU-only flags -- the BSD dialect family (REDS %249,
# %250, %275) is the lesson this scan is born under.
#
#   sh tools/fixtures/c/caravan_wrap_class_scan.sh [root]     # root defaults to ., pen-friendly
#
# Prints sites_total / predicates_free / classified / unclassified and one line naming each
# unclassified site; verdict=ok exits 0, verdict=unclassified_wrap exits 1.

root=${1:-.}
if [ ! -d "$root/caravan" ]; then
  echo "verdict=no_room"
  exit 2
fi

work=$(mktemp -d "${TMPDIR:-/tmp}/wrapclass.XXXXXX") || exit 2
trap 'rm -rf "$work"' EXIT

files=0
: > "$work/sites.txt"
for f in "$root"/caravan/*.rye; do
  [ -f "$f" ] || continue
  [ -L "$f" ] && continue
  files=$((files+1))
  awk -v fname="$f" '
    function is_comment(s,  t) { t = s; sub(/^[ \t]+/, "", t); return substr(t, 1, 2) == "//" }
    {
      hist[NR] = $0
      if (is_comment($0)) next
      site = 0
      # a modulo used as arithmetic: value-space on both sides, spaces as the room writes them
      if (match($0, /[A-Za-z0-9_)] % [A-Za-z_(@]/)) site = 1
      # wrapping operators, loud from their first arrival
      if (index($0, "+%") > 0 || index($0, "*%") > 0 || index($0, " -% ") > 0) site = 1
      if (site == 0) next
      # a comparison with zero wraps nothing -- a divisibility predicate stays free
      if (match($0, /% [A-Za-z0-9_().]+ *[!=]= *0/)) { print "P"; next }
      ok = 0
      for (i = NR - 6; i <= NR; i++) {
        if (i < 1) continue
        if (index(hist[i], "wrap-as-periodic") > 0 || index(hist[i], "wrap-as-linear") > 0) ok = 1
      }
      if (ok) { print "C" } else { printf "U\t%s:%d\n", fname, NR }
    }
  ' "$f" >> "$work/sites.txt"
done

# grep -c prints its own honest zero on no match (exiting 1), so the count is captured
# bare and the exit neutralized -- a fallback echo here once doubled the zero into "0 0".
sites=$(grep -c '^[PCU]' "$work/sites.txt" || true)
preds=$(grep -c '^P' "$work/sites.txt" || true)
classified=$(grep -c '^C' "$work/sites.txt" || true)
unclassified=$(grep -c '^U' "$work/sites.txt" || true)

echo "files_read=$files"
echo "sites_total=$sites"
echo "predicates_free=$preds"
echo "classified=$classified"
echo "unclassified=$unclassified"
grep '^U' "$work/sites.txt" 2>/dev/null | while IFS='	' read -r _ where; do
  echo "unclassified: $where"
done

if [ "$unclassified" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=unclassified_wrap"
exit 1
