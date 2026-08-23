#!/bin/sh
# sow_manifest_cover.sh -- M1: every tracked root path is classified, exactly once, and no
# SHIPPING row names a path the tree does not have.
#
# WHY THE SHAPE CHANGED `20260823.134057`. The check compared two sets for equality, which asked
# the manifest for something it should not give. The three verdicts are not symmetric:
#
#   template / scrub  are SHIPPING rows. One naming an absent path is a promise to ship
#                     something that is not there, and stays gated.
#   personal          is a WITHHOLD row. One naming an absent path costs nothing and guards
#                     something: it is a standing instruction that if that path ever returns,
#                     it is withheld. `twilight` is exactly this -- the palette's private source
#                     poems, debrided from all history `20260823.072824`, whose row says in its
#                     own comment that it stays as defence in depth.
#
# Set equality refused that row, so M1 read BAD from the moment the debride landed. The
# projector is an allowlist -- anything unclassified is withheld -- so a defence-in-depth row
# is belt beside braces, and the guard now permits it and reports it rather than failing it.
#
# TWO THINGS GOT STRICTER in the same pass, so this is not a loosening on balance. The elder
# check ran `sort -u` on both sides, so a path classified TWICE collapsed to one entry and the
# stated promise of "exactly once" went unchecked for the whole life of the file. It is checked
# now. And the shipping rows are gated on their own, rather than inside a set comparison where
# a withhold row could mask them.
#
# WHAT IT PRINTS. `M1_OK` when the tree's roots are all classified, no shipping row is a ghost,
# and no path is classified twice. Otherwise `M1_BAD` and the offending lists by name.
# Absent `personal` rows are printed under their own heading either way, so defence in depth
# stays visible rather than becoming invisible by being permitted.
#
# Kin: tools/sow_witness.rish (the rung that gates on this) - tools/fixtures/sow_project.sh
# (the allowlist projector) - template-manifest.bron (the boundary itself).
#
# Run from the repository root.
set -eu

# Both inputs are injectable so the guard can be proven able to RED on a throwaway pair rather
# than only ever observed passing on the real tree. Defaults are the real ones, so every existing
# caller is unchanged.
manifest="${1:-template-manifest.bron}"
roots_file="${2:-}"
[ -f "$manifest" ] || { echo "refused: no manifest at $manifest" >&2; exit 1; }

if [ -n "$roots_file" ]; then
  [ -f "$roots_file" ] || { echo "refused: no roots file at $roots_file" >&2; exit 1; }
  tree_roots=$(sort -u < "$roots_file")
else
  tree_roots=$(git ls-files | sed -E 's#/.*##' | sort -u)
fi
classified=$(grep -E '^(template|scrub|personal) ' "$manifest" | awk '{print $2}' | sort)
classified_once=$(printf '%s\n' "$classified" | sort -u)
shipping=$(grep -E '^(template|scrub) ' "$manifest" | awk '{print $2}' | sort -u)
withheld=$(grep -E '^personal ' "$manifest" | awk '{print $2}' | sort -u)

# (1) Every tracked root carries a verdict. An unclassified root is withheld by the projector's
# allowlist, so the cost is a room silently missing from the seed rather than a leak -- which is
# the safe direction, and still wrong.
unclassified=$(printf '%s\n' "$tree_roots" | while IFS= read -r x; do
  [ -n "$x" ] || continue
  printf '%s\n' "$classified_once" | grep -qxF "$x" || echo "$x"
done)

# (2) Every shipping row names a path the tree actually tracks.
ghost_shipping=$(printf '%s\n' "$shipping" | while IFS= read -r x; do
  [ -n "$x" ] || continue
  printf '%s\n' "$tree_roots" | grep -qxF "$x" || echo "$x"
done)

# (3) No path classified twice. Two rows disagreeing about one root is the failure that would
# hurt most, since which one wins depends on read order.
doubled=$(printf '%s\n' "$classified" | uniq -d)

# (4) Reported, never gated -- the defence-in-depth withholds.
absent_personal=$(printf '%s\n' "$withheld" | while IFS= read -r x; do
  [ -n "$x" ] || continue
  printf '%s\n' "$tree_roots" | grep -qxF "$x" || echo "$x"
done)

if [ -z "$unclassified" ] && [ -z "$ghost_shipping" ] && [ -z "$doubled" ]; then
  echo M1_OK
else
  echo M1_BAD
fi

echo "--- in tree, not classified ---"
[ -n "$unclassified" ] && printf '%s\n' "$unclassified" || true
echo "--- shipping rows naming a path the tree does not have ---"
[ -n "$ghost_shipping" ] && printf '%s\n' "$ghost_shipping" || true
echo "--- classified more than once ---"
[ -n "$doubled" ] && printf '%s\n' "$doubled" || true
echo "--- withheld by defence in depth, path absent (reported, never gated) ---"
[ -n "$absent_personal" ] && printf '%s\n' "$absent_personal" || true
