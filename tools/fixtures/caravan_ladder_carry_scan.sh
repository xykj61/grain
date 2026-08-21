#!/bin/sh
# caravan_ladder_carry_scan.sh -- how much of the Caravan ladder is a body the
# ladder has already written somewhere else, asked of EVERY body rather than of
# one named family.
#
# Three meters already stand beside this one, and each reads through a named
# window. `caravan_ladder_copy_scan.sh` reads bodies whose name opens on
# `check_`. `caravan_ladder_print_scan.sh` reads bodies whose name opens on
# `tell_`. `caravan_ladder_spine_scan.sh` reads one named function,
# `close_the_quarrel`. Every one of the three is honest inside its window and
# says so at the top, and together they governed eleven folds.
#
# What none of them can see is a body named anything else. That blindness was
# measured on `20260821` rather than reasoned about: `stand_taking_and_returning_reach`
# stood BYTE FOR BYTE in forty-two rungs at forty-four lines apiece -- the
# largest single carry the arc had ever folded -- and it rode past all three
# meters for six consecutive folds, because it opens on `stand_`. The fold that
# lifted it was found by hand, by asking a wider question once. This scan is
# that question made standing, so the next one is found by a meter rather than
# by luck.
#
# That is `REDS %102`'s family at ladder scale: a reading that sees a subset
# answers in the voice of the whole. A GREEN over part of a subject is more
# dangerous than a RED, since it answers the question nobody asked in the voice
# of the question they did. The answer is never a fourth named window; it is one
# window with no name in it at all.
#
# WHAT IT READS. Every top-level body in every rung module -- `fn` or `pub fn`
# at column zero, closing on the first bare `}` there, which is the same shape
# all three elder meters read a body by, so the four agree on what a body is.
# Bodies are compared by their exact text, so two bodies are one only when they
# stand byte for byte alike. No hashing, hence no collision to argue about.
#
# WHAT IT REPORTS.
#
#   CARRY_BODIES names how many bodies stand, how many distinct texts they are,
#   how many are a copy of one already counted, and how many lines those copies
#   carry. The last number is the carry, and it is the one a design call rests
#   on (REDS %93: a tally repeated from memory drifts).
#
#   CARRY_TOP names the families carrying the most, largest first, each as
#   `name:rungs x lines = carried`. This is the fold queue, printed rather than
#   remembered, so the next fold is chosen by measurement rather than by which
#   family somebody happened to look at.
#
# CARAVAN_CARRY_CEILING (default 143000): how many carried lines the ladder may
# hold. 142,850 stand today across 10,198 copied bodies, and 247 families carry
# past a hundred lines each. That number is far larger than any the three named
# meters report, and naming it plainly is the whole point of this scan -- the
# ladder's real carry was never the few thousand lines inside two prefixes. Each
# fold hands back the room it wins by lowering this ceiling, exactly as the
# print meter's has come down five times.
#
# CARAVAN_CARRY_TOP (default 12): how many carrying families to name.
#
# CARAVAN_LADDER_DIR (default caravan): the directory of rung modules, so the
# PASS and FAIL fixtures prove both paths without touching the tree.
set -eu

CEILING=${CARAVAN_CARRY_CEILING:-143000}
TOP=${CARAVAN_CARRY_TOP:-12}
DIR=${CARAVAN_LADDER_DIR:-caravan}

modules=0
for f in "$DIR"/*.rye; do
  test -f "$f" || continue
  modules=$((modules + 1))
done

if [ "$modules" -eq 0 ]; then
  echo "CARRY_BAD no rung modules found under ${DIR}"
  echo "CARRY_FAIL reason=no_modules dir=${DIR}"
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# One pass over every module. A body is keyed by its own exact text, so the
# count is a count rather than an estimate, and the family's name is kept from
# the first rung that wrote it so the report reads in words.
awk '
  FNR == 1 { inb = 0 }
  $0 ~ /^(pub )?fn [a-z_][a-z0-9_]*\(/ {
    name = ($1 == "pub") ? $3 : $2
    sub(/\(.*/, "", name); inb = 1; body = ""; n = 0
  }
  inb { body = body $0 "\n"; n++ }
  inb && /^}$/ {
    seen[body]++
    lines[body] = n
    if (seen[body] == 1) family[body] = name
    inb = 0
  }
  END {
    for (b in seen) {
      bodies += seen[b]
      distinct++
      if (seen[b] > 1) {
        copies += seen[b] - 1
        carried += (seen[b] - 1) * lines[b]
        printf "%d %d %d %s\n", (seen[b] - 1) * lines[b], seen[b], lines[b], family[b] > "'"$work"'/families"
      }
    }
    printf "%d %d %d %d\n", bodies + 0, distinct + 0, copies + 0, carried + 0
  }
' "$DIR"/*.rye > "$work/summary"

bodies=$(cut -d' ' -f1 "$work/summary")
distinct=$(cut -d' ' -f2 "$work/summary")
copies=$(cut -d' ' -f3 "$work/summary")
carried=$(cut -d' ' -f4 "$work/summary")

if [ "$bodies" -eq 0 ]; then
  echo "CARRY_BAD ${modules} modules hold no top-level bodies at all"
  echo "CARRY_FAIL reason=no_bodies dir=${DIR} modules=${modules}"
  exit 1
fi

echo "CARRY_MODULES ${modules} dir=${DIR}"
echo "CARRY_BODIES ${bodies} distinct=${distinct} copies=${copies} carried_lines=${carried}"

if [ -f "$work/families" ]; then
  families=$(wc -l < "$work/families" | tr -d ' ')
  echo "CARRY_FAMILIES ${families} carrying=1_or_more_copies"
  sort -rn "$work/families" | head -n "$TOP" | while read -r carry count len name; do
    echo "CARRY_TOP ${name}: ${count} rungs x ${len} lines = ${carry} carried"
  done
else
  echo "CARRY_FAMILIES 0 carrying=1_or_more_copies"
fi

if [ "$carried" -gt "$CEILING" ]; then
  echo "CARRY_BAD carried=${carried} stands past ceiling=${CEILING}"
  echo "CARRY_FAIL reason=past_ceiling carried=${carried} ceiling=${CEILING}"
  exit 1
fi

echo "CARRY_OK carried=${carried} ceiling=${CEILING} modules=${modules} bodies=${bodies}"
