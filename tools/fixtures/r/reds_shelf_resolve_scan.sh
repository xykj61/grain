#!/bin/sh
# tools/fixtures/r/reds_shelf_resolve_scan.sh -- the census behind tools/r/reds_shelf_resolve.sh:
# how many REDS fold-shelf citations name a shelf that has since been renamed, and how many of
# those the resolver recovers.
#
# WHY A CENSUS RATHER THAN A WALL. A refold is ordinary work -- it absorbs a row into a wider
# range or retitles the same rows -- and it RAISES the count of citations naming a departed
# basename every time it runs. A gate on that count would red on the tree's own tending, which
# is a gate somebody turns off. So the gated reading is `unrecoverable`: the citations the
# resolver cannot answer, which a refold leaves exactly where it stood, because a refold moves
# a row between shelves and never off its number.
#
# The same reasoning seats the dated-path census one room over (.claude/rules/stamp-and-name.md):
# it gates what the resolver CANNOT recover rather than the whole broken count, for this reason
# in those words.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
#   sh tools/fixtures/r/reds_shelf_resolve_scan.sh              # read, change nothing
#   sh tools/fixtures/r/reds_shelf_resolve_scan.sh --list       # name every unrecoverable one
#
# READINGS:
#   shelves        -- REDS fold shelves standing on disk.
#   cited          -- distinct shelf basenames cited across tracked files.
#   home           -- of those, the ones that still stand. Nothing was renamed.
#   absent         -- of those, the ones on no path. FREE, and it rises on every refold.
#   recovered      -- of the absent, the ones the resolver answers with a named holder.
#   unrecoverable  -- of the absent, the ones it cannot: ambiguous or missing. RATCHET,
#                     under a ceiling that only falls. Split into its two causes below,
#                     because the two want different repairs and one wants none at all.
#   unrecoverable_ambiguous -- the row stands in two shelves. Every one of these today names a
#                     PUBLISHED DOUBLE -- %512, %530, %675 -- which .claude/rules/derived-spine.md
#                     states no lap may repair, since both rows reached the anointed spine and
#                     rule 3 freezes each. The resolver refusing here is the law working.
#   unrecoverable_missing -- no shelf carries the row. Both of these today are PEN PLANTS
#                     written by a living witness rather than a fixture --
#                     tools/c/convergence_tree_prove_witness.rish plants rows-999001 and
#                     tools/r/reds_pin_capacity_witness.rish plants rows-66. The read-past below
#                     is keyed on the tools/fixtures/ directory, and this measurement is what
#                     showed that proxy to be incomplete: a plant is a plant wherever it lives.
#                     They are counted rather than excluded, because widening an exclusion to
#                     make a number smaller is how a census stops measuring its subject.
#   testimony_only -- of the absent, the ones cited ONLY by dated testimony, which
#                     accrete-never-break forbids rewriting. Reported: it is the share no
#                     repair may ever reach, and it is the reason the resolver exists.
#
# WHAT IT READS PAST, each for its own reason. tools/fixtures/ plants fabricated shelf names on
# purpose -- reds_fold_control.sh writes REDS-absent-rows-9.md into a pen -- so counting a pen's
# plants would price this tree for a name no citation ever meant. The resolver's own header
# illustrates the shapes it accepts, and an illustration is not a citation (the lesson
# stamp-and-name.md records: three fabricated example paths were counted as broken references on
# the day that law was written).
#
# Exit 0 ok - 1 unrecoverable stands above CEILING - 2 misuse. A misuse exits DIFFERENTLY from a
# refusal, so a caller never reads a broken invocation as a clean census.
set -eu

CEILING=${REDS_SHELF_UNRECOVERABLE_CEILING:-6}
RESOLVER=${REDS_SHELF_RESOLVER:-tools/r/reds_shelf_resolve.sh}

list=no
[ "${1:-}" = "--list" ] && list=yes
[ $# -le 1 ] || { echo "usage: reds_shelf_resolve_scan.sh [--list]" >&2; exit 2; }
[ -x "$RESOLVER" ] || { echo "reds_shelf_resolve_scan: resolver unreadable: $RESOLVER" >&2; exit 2; }

pen=$(mktemp -d) || exit 2
trap 'rm -rf "$pen"' EXIT INT TERM

# Citations, gathered from tracked files alone -- an untracked scratch file is one lap's own and
# never a promise this tree made.
git ls-files -z \
  | grep -zvE '^tools/fixtures/' \
  | grep -zvE '^tools/r/reds_shelf_resolve\.sh$' \
  | xargs -0 grep -ohE 'REDS-[a-z0-9-]+-rows-[0-9]+(-[0-9]+)?\.md' 2>/dev/null \
  | sort -u > "$pen/cited" || true

# The same sweep again, keeping the citing path, so testimony_only can be read. A file whose own
# basename carries a one-clock stamp is testimony -- the tree's own rule for telling the two
# apart (.claude/rules/stamp-and-name.md).
git ls-files -z \
  | grep -zvE '^tools/fixtures/' \
  | grep -zvE '^tools/r/reds_shelf_resolve\.sh$' \
  | xargs -0 grep -oHE 'REDS-[a-z0-9-]+-rows-[0-9]+(-[0-9]+)?\.md' 2>/dev/null \
  | sort -u > "$pen/cited_by" || true

# One map, built once by the resolver itself and handed back to it for every lookup. The census
# never reads a row headline on its own -- a second reader of one question is the drift %768
# booked, where a scan and its ceiling disagreed about what they were counting.
sh "$RESOLVER" --map > "$pen/map" || exit 2
export REDS_SHELF_MAP="$pen/map"

ls construction/archive/ 2>/dev/null | grep -E '^REDS-.*\.md$' | sort -u > "$pen/ondisk" || true

shelves=$(grep -c . < "$pen/ondisk" || true)
cited=$(grep -c . < "$pen/cited" || true)
comm -12 "$pen/cited" "$pen/ondisk" > "$pen/home"
comm -23 "$pen/cited" "$pen/ondisk" > "$pen/absent"
home=$(grep -c . < "$pen/home" || true)
absent=$(grep -c . < "$pen/absent" || true)

recovered=0
unrecoverable=0
unrec_ambiguous=0
unrec_missing=0
: > "$pen/unrecoverable"
while IFS= read -r b; do
  [ -n "$b" ] || continue
  # One resolver call per name, read for BOTH its verdict and its cause -- a second call would
  # be a second reading of one question, and the two could part.
  v=$(sh "$RESOLVER" "$b" 2>/dev/null | sed -n 's/^verdict=//p' || true)
  case "$v" in
    home|recovered-by-rows|living-pin|split)
      recovered=$((recovered + 1))
      ;;
    ambiguous)
      unrecoverable=$((unrecoverable + 1))
      unrec_ambiguous=$((unrec_ambiguous + 1))
      echo "$b $v" >> "$pen/unrecoverable"
      ;;
    *)
      unrecoverable=$((unrecoverable + 1))
      unrec_missing=$((unrec_missing + 1))
      echo "$b ${v:-unreadable}" >> "$pen/unrecoverable"
      ;;
  esac
done < "$pen/absent"

# A citation reached only by dated testimony is one no lap may repair, by law. Counting it apart
# is what keeps `absent` from reading as a backlog somebody is neglecting.
testimony_only=0
while IFS= read -r b; do
  [ -n "$b" ] || continue
  living=$(grep -F ":$b" "$pen/cited_by" | cut -d: -f1 \
    | grep -vE '(^|/)[0-9]{8}-[0-9]{6}([_.])' | grep -c . || true)
  [ "$living" -eq 0 ] && testimony_only=$((testimony_only + 1))
done < "$pen/absent"

echo "shelves=$shelves"
echo "cited=$cited"
echo "home=$home"
echo "absent=$absent"
echo "recovered=$recovered"
echo "unrecoverable=$unrecoverable"
echo "unrecoverable_ambiguous=$unrec_ambiguous"
echo "unrecoverable_missing=$unrec_missing"
echo "testimony_only=$testimony_only"
echo "ceiling=$unrecoverable/$CEILING"

if [ "$list" = yes ]; then
  while IFS= read -r b; do
    [ -n "$b" ] || continue
    echo "unrecoverable_name=$b"
  done < "$pen/unrecoverable"
fi

if [ "$unrecoverable" -gt "$CEILING" ]; then
  echo "verdict=over-ceiling"
  exit 1
fi
echo "verdict=ok"
