#!/bin/sh
# tools/fixtures/t/tally_caller_map_control.sh -- prove the caller-map reading by doing.
#
# WHY. A guard that cannot red guards nothing, and a refusal proven only in the passing direction
# cannot be told from a bypass. This control builds git repositories in a temporary pen, plants one
# condition in each, runs tools/fixtures/t/tally_caller_map_scan.sh inside them, and checks that
# each refusal bites AND that lifting the plant returns the reading to green. Nothing here touches
# the tree it runs from.
#
# WHY THE PEN NEEDS A NAMED SAMPLE OF ITS OWN. The scan's named half is a list of 19 real paths
# spelled in the script -- none of which exist in a pen. So every refusal that half can make would
# otherwise be provable only by breaking the real tree. The scan takes an optional sample file for
# exactly this, and the pen writes its own; the derived half needs no such door, since it is read
# from whatever index the pen holds.
#
# USAGE
#   sh tools/fixtures/t/tally_caller_map_control.sh
# Driven by tools/t/tally_caller_map_witness.rish. Run from the repository root.

set -u

root=$(pwd -P)
scan=$root/tools/fixtures/t/tally_caller_map_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

pen=$(mktemp -d) || { echo "control_verdict=no_pen" >&2; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

# A repository shaped like this tree's own seam: a tally/ canon room holding one mark, a consuming
# room linking it, the two README lines the prose binding reads, and the two directories the root
# walk looks for. Whatever a leg plants is added on top.
build() {
  d=$pen/$1
  mkdir -p "$d/rishi/bin" "$d/tools/fixtures" "$d/tally" "$d/saga" "$d/room"
  printf 'pub fn copy_disjoint() void {}\n' > "$d/tally/copy.rye"
  printf 'pub fn parse_int() void {}\n' > "$d/tally/parse_int.rye"
  printf '# Tally\n\n## Who calls Tally\n\n| Consumer family | Typical marks |\n|---|---|\n| `room/` | `copy` |\n' > "$d/tally/README.md"
  printf '# Saga\n\nCanon caller map: see tally/README.md.\n' > "$d/saga/README.md"
  printf 'keep\n' > "$d/rishi/bin/.keep"
  printf 'keep\n' > "$d/tools/fixtures/.keep"
  ( cd "$d/room" && ln -s ../tally/copy.rye tally_copy.rye )
  printf 'room/tally_copy.rye\n' > "$d/sample.txt"
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name Pen ) >/dev/null 2>&1
  echo "$d"
}

seal() { ( cd "$1" && git add -A && git commit -qm 'pen: one canon and its rooms' ) >/dev/null 2>&1; }

read_scan() { ( cd "$1" && sh "$scan" sample.txt 2>/dev/null; ) }
# A refusal is an exit code as much as a verdict line, so both are read.
scan_status() { ( cd "$1" && sh "$scan" sample.txt >/dev/null 2>&1; echo $?; ) }

has() { printf '%s\n' "$1" | grep -q "$2"; }

# 1. The honest tree: one canon, one linking room, both prose lines. Green, and the counts say so.
d=$(build clean); seal "$d"
out=$(read_scan "$d")
has "$out" 'verdict=ok'  && echo "clean_free=yes"      || echo "clean_free=no"
has "$out" 'marks=1'     && echo "clean_counted=yes"   || echo "clean_counted=no"
has "$out" 'named=1'     && echo "sample_read=yes"     || echo "sample_read=no"
has "$out" '^rooms_named=1$' && echo "table_room_counted=yes" || echo "table_room_counted=no"
has "$out" '^stale_named=0$' && echo "table_stale_clear=yes" || echo "table_stale_clear=no"
[ "$(scan_status "$d")" = "0" ] && echo "clean_exits_zero=yes" || echo "clean_exits_zero=no"

# 2. A dangling mark -- the link is tracked, its target is gone. Counted, named, and refused.
d=$(build dangling); seal "$d"
rm -f "$d/tally/copy.rye"
out=$(read_scan "$d")
has "$out" 'dangling=1'            && echo "dangling_counted=yes"  || echo "dangling_counted=no"
has "$out" 'verdict=dangling_mark' && echo "dangling_refused=yes"  || echo "dangling_refused=no"
[ "$(scan_status "$d")" = "1" ] && echo "dangling_exits_one=yes" || echo "dangling_exits_one=no"
# ... and lifting the plant returns the reading to green, so the refusal is the plant's and not the pen's.
printf 'pub fn copy_disjoint() void {}\n' > "$d/tally/copy.rye"
has "$(read_scan "$d")" 'verdict=ok' && echo "dangling_lift_green=yes" || echo "dangling_lift_green=no"

# 3. A COPY standing where the canon says a symlink belongs -- the exact state the elder `-e`
#    predicate passed in silence, and the whole reason this guard was widened.
d=$(build copy); seal "$d"
rm -f "$d/room/tally_copy.rye"
cp "$d/tally/copy.rye" "$d/room/tally_copy.rye"
out=$(read_scan "$d")
has "$out" 'named_not_link=1'     && echo "copy_counted=yes"  || echo "copy_counted=no"
has "$out" 'verdict=named_is_copy' && echo "copy_refused=yes" || echo "copy_refused=no"
# The elder predicate is shown failing on the same bytes, so the repair is proven rather than claimed.
[ -e "$d/room/tally_copy.rye" ] && echo "elder_predicate_passes_the_copy=yes" || echo "elder_predicate_passes_the_copy=no"
rm -f "$d/room/tally_copy.rye"
( cd "$d/room" && ln -s ../tally/copy.rye tally_copy.rye )
has "$(read_scan "$d")" 'verdict=ok' && echo "copy_lift_green=yes" || echo "copy_lift_green=no"

# 4. A named mark simply absent. Told apart from the copy above, since the repairs differ.
d=$(build absent); seal "$d"
rm -f "$d/room/tally_copy.rye"
out=$(read_scan "$d")
has "$out" 'named_missing=1'      && echo "absent_counted=yes" || echo "absent_counted=no"
has "$out" 'verdict=named_missing' && echo "absent_refused=yes" || echo "absent_refused=no"

# 5. A named mark RETARGETED out of tally/ -- the derived population's own blind spot, which is
#    why the named sample is kept beside it. Without the named half this reads as a clean tree.
d=$(build escaped); seal "$d"
mkdir -p "$d/elsewhere"
printf 'pub fn copy_disjoint() void {}\n' > "$d/elsewhere/copy.rye"
rm -f "$d/room/tally_copy.rye"
( cd "$d/room" && ln -s ../elsewhere/copy.rye tally_copy.rye )
out=$(read_scan "$d")
has "$out" 'named_escaped=1'             && echo "escaped_counted=yes" || echo "escaped_counted=no"
has "$out" 'verdict=named_escaped_canon' && echo "escaped_refused=yes" || echo "escaped_refused=no"
# The derived half genuinely cannot see it: the retargeted link resolves outside tally/, so the
# population is empty and the mark count falls to zero rather than reporting a fault.
has "$out" 'marks=0' && echo "derived_half_is_blind=yes" || echo "derived_half_is_blind=no"

# 6. A chain -- a mark reaching the canon through another room's link. Lawful, counted, and free.
d=$(build chain); mkdir -p "$d/middle"
( cd "$d/middle" && ln -s ../tally/parse_int.rye parse_int.rye )
( cd "$d/room" && ln -s ../middle/parse_int.rye parse_int.rye )
seal "$d"
out=$(read_scan "$d")
has "$out" 'chained=1'  && echo "chain_counted=yes" || echo "chain_counted=no"
has "$out" 'marks=3'    && echo "chain_in_population=yes" || echo "chain_in_population=no"
has "$out" 'verdict=ok' && echo "chain_free=yes"    || echo "chain_free=no"

# 7. The prose binding, each side alone, since one guard's own seat deserves both readings.
d=$(build prose_tally); seal "$d"
printf '# Tally\n\nno section here\n' > "$d/tally/README.md"
out=$(read_scan "$d")
has "$out" 'prose_tally_missing=1'      && echo "prose_tally_counted=yes" || echo "prose_tally_counted=no"
has "$out" 'verdict=prose_binding_lost' && echo "prose_tally_refused=yes" || echo "prose_tally_refused=no"

d=$(build prose_saga); seal "$d"
printf '# Saga\n\nno pointer here\n' > "$d/saga/README.md"
out=$(read_scan "$d")
has "$out" 'prose_saga_missing=1'       && echo "prose_saga_counted=yes" || echo "prose_saga_counted=no"
has "$out" 'verdict=prose_binding_lost' && echo "prose_saga_refused=yes" || echo "prose_saga_refused=no"

# 8. An UNTRACKED link is deliberately unread: the guard measures the tree a commit would ship, so
#    a working-tree experiment must not red it and must not be counted either.
d=$(build untracked); seal "$d"
( cd "$d/room" && ln -s ../tally/parse_int.rye parse_int.rye )
out=$(read_scan "$d")
has "$out" 'marks=1'    && echo "untracked_unread=yes" || echo "untracked_unread=no"
has "$out" 'verdict=ok' && echo "untracked_free=yes"   || echo "untracked_free=no"

# 9. No tally/ room at all -- the reading refuses by name rather than reporting a clean tree, which
#    is the shape a scan is likeliest to get wrong: nothing found reads exactly like nothing wrong.
d=$(build no_canon); seal "$d"
rm -rf "$d/tally"
out=$(read_scan "$d")
has "$out" 'verdict=no_canon_room' && echo "no_canon_says_so=yes" || echo "no_canon_says_so=no"
[ "$(scan_status "$d")" = "2" ] && echo "no_canon_refuses=yes" || echo "no_canon_refuses=no"

# 10. A sample file that does not exist refuses rather than falling back to the built-in 19, which
#     in a pen would red on nineteen absent paths and read as a fault of the pen.
d=$(build no_sample); seal "$d"
out=$( cd "$d" && sh "$scan" nowhere.txt 2>/dev/null )
has "$out" 'verdict=no_sample_file' && echo "no_sample_says_so=yes" || echo "no_sample_says_so=no"

# 11. The derived population empty while the named sample is intact -- the one case `no_marks_found`
#     alone reads, and the reason it keeps a seat behind the five specific verdicts. The sample is
#     emptied so the named half passes vacuously, and every link is removed so the derivation finds
#     nothing: a reading that found no marks must refuse rather than report a clean tree.
d=$(build no_marks)
rm -f "$d/room/tally_copy.rye"
: > "$d/sample.txt"
seal "$d"
out=$(read_scan "$d")
has "$out" 'named=0'                 && echo "empty_sample_read=yes"   || echo "empty_sample_read=no"
has "$out" 'verdict=no_marks_found'  && echo "no_marks_says_so=yes"    || echo "no_marks_says_so=no"
[ "$(scan_status "$d")" = "2" ] && echo "no_marks_refuses=yes" || echo "no_marks_refuses=no"

# 12. A link LOOP. The bounded walk must answer unresolvable and name the path, rather than spinning
#     or dropping the link out of the population in silence -- which is the fault the whole widening
#     was written against, one mechanism down. Reported, never gated: a loop in a room that never
#     calls Tally is a real fault and another lane's.
d=$(build loop)
( cd "$d/room" && ln -s ./loop_b.rye loop_a.rye && ln -s ./loop_a.rye loop_b.rye )
seal "$d"
out=$(read_scan "$d")
has "$out" 'unresolvable=2' && echo "loop_counted=yes" || echo "loop_counted=no"
has "$out" 'detail: unresolvable' && echo "loop_named=yes" || echo "loop_named=no"
has "$out" 'verdict=ok'     && echo "loop_reported_not_gated=yes" || echo "loop_reported_not_gated=no"
has "$out" 'marks=1'        && echo "loop_leaves_marks_intact=yes" || echo "loop_leaves_marks_intact=no"

# A table's first column names caller rooms; the second names the marks they use.
# Read this section only, reduce file paths to rooms, and count each room once.
d=$(build stale_table)
cat >> "$d/tally/README.md" <<'MD'
| `empty/` - `room/tally_copy.rye` | `tally/copy.rye` |

A prose link to `prose_only/` is outside the table reading.

## Another section
| `later/` | `copy` |
MD
seal "$d"
out=$(read_scan "$d")
has "$out" '^stale_named=1$' && echo "stale_table_counted=yes" || echo "stale_table_counted=no"
has "$out" '^verdict=stale_named$' && echo "stale_table_refused=yes" || echo "stale_table_refused=no"
[ "$(scan_status "$d")" = "1" ] && echo "stale_table_exits_one=yes" || echo "stale_table_exits_one=no"
has "$out" '^rooms_named=2$' && echo "table_scope_only=yes" || echo "table_scope_only=no"
mkdir -p "$d/empty"
( cd "$d/empty" && ln -s ../tally/copy.rye tally_copy.rye )
has "$(read_scan "$d")" '^verdict=stale_named$' && echo "table_untracked_unread=yes" || echo "table_untracked_unread=no"
seal "$d"
has "$(read_scan "$d")" '^verdict=ok$' && echo "stale_table_lift_green=yes" || echo "stale_table_lift_green=no"

# The table uses the scan's population ceiling. More unique rooms than that
# refuse before the scan can publish a truncated table reading.
d=$(build table_bound)
ceiling=$(sed -n 's/^max_marks=//p' "$scan")
awk -v limit="$ceiling" 'BEGIN { for (i=1; i<limit; i++) printf "| `room%d/` | `copy` |\n", i }' >> "$d/tally/README.md"
seal "$d"
out=$(read_scan "$d")
has "$out" "^rooms_named=$ceiling$" && echo "table_bound_exact_counted=yes" || echo "table_bound_exact_counted=no"
has "$out" '^verdict=stale_named$' && echo "table_bound_exact_read=yes" || echo "table_bound_exact_read=no"
printf '| `overflow/` | `copy` |\n' >> "$d/tally/README.md"
seal "$d"
out=$(read_scan "$d")
has "$out" '^verdict=table_rooms_unreadable$' && echo "table_bound_refused=yes" || echo "table_bound_refused=no"
[ "$(scan_status "$d")" = "2" ] && echo "table_bound_exits_two=yes" || echo "table_bound_exits_two=no"

echo "control_verdict=ok"
