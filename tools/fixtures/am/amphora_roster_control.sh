#!/bin/sh
# tools/fixtures/am/amphora_roster_control.sh -- prove amphora_roster_scan.sh on planted rooms.
#
# Every refusal is shown from the failing side AND then lifted, so a reading can never be a plant
# that planted nothing (REDS `%519`). Every welcome is asserted as hard as every refusal, because a
# refusal proven only in the passing direction cannot be told from a bypass. And the pen itself is
# proven innocent: a scan patched to always answer `ok` must FAIL this control, with the patch's own
# landing proven by `cmp -s` rather than assumed from a `sed` exit code.
#
# Run from the repository root:
#   sh tools/fixtures/am/amphora_roster_control.sh
set -u

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/am/amphora_roster_scan.sh"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/amphora_roster_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT

behaviors=0
failed=0

check() { # check <name> <expected> <actual>
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then
    echo "  ok   $1"
  else
    echo "  FAIL $1 -- wanted [$2] got [$3]"
    failed=$((failed + 1))
  fi
}

# A pen room holding two authored modules and one link, two rostered guards -- one direct, one an
# accrete shim whose target carries the module name. Every plant below starts from this.
#
# THE PEN IS ENTERED, never addressed from outside. The scan resolves a shim's target by testing
# the path the guard names, and those paths are repository-relative, so the reading is only true
# from the pen's own root. `cd` here is the whole reason the shim leg means anything.
mkpen() { # mkpen <name> ; echoes its root
  d="$PEN/$1"
  mkdir -p "$d/room/src" "$d/tools/am" "$d/tools/gen/room" "$d/construction"
  printf 'const std = @import("std");\n' > "$d/room/alpha.rye"
  printf 'const std = @import("std");\n' > "$d/room/src/beta.rye"
  ln -s ../elsewhere/borrowed.rye "$d/room/borrowed.rye"

  printf '# direct witness\nlet m = "room/alpha.rye"\n' > "$d/tools/am/room_alpha_witness.rish"
  printf '# accrete shim -> tools/gen/room/room_beta.rish\nlet r = run ["rishi/bin/rishi" "run" "tools/gen/room/room_beta.rish"]\n' \
    > "$d/tools/am/room_beta.rish"
  printf '# the target the shim runs\nlet m = "room/src/beta.rye"\n' > "$d/tools/gen/room/room_beta.rish"

  # The room's front door, naming both rostered guards. The `readme_unnamed` legs below plant on
  # this file; every other leg inherits a whole door so its own reading stays the thing under test.
  printf '# room\n\nGuards: room_alpha and room_beta.\n' > "$d/room/README.md"

  cat > "$d/construction/roster.kyri" <<'ROSTER'
guard room_alpha
path tools/am/room_alpha_witness.rish
tier lap
seated 20260907.223214

guard room_beta
path tools/am/room_beta.rish
tier cadence
seated 20260907.223214
ROSTER
  printf '%s' "$d"
}

# The README defaults to `<room>/README.md`, which is where every pen puts it; the absent-door leg
# points the fourth argument somewhere else on purpose.
field_of() { # field_of <key> <pen_root> [<scan>]
  ( cd "$2" && sh "${3:-$SCAN}" room construction/roster.kyri tools/am 2>/dev/null ) \
    | sed -n "s/^$1=//p" | head -1
}
exit_of() { # exit_of <pen_root> [<scan>]
  ( cd "$1" && sh "${2:-$SCAN}" room construction/roster.kyri tools/am >/dev/null 2>&1 )
  echo $?
}
detail_has() { # detail_has <key> <value> <pen_root>
  if ( cd "$3" && sh "$SCAN" room construction/roster.kyri tools/am 2>/dev/null ) \
     | grep -qx "detail_$1=$2"; then echo yes; else echo no; fi
}
field_of_door() { # field_of_door <key> <pen_root> <readme>
  ( cd "$2" && sh "$SCAN" room construction/roster.kyri tools/am "$3" 2>/dev/null ) \
    | sed -n "s/^$1=//p" | head -1
}

echo "amphora_roster_control: planted rooms"

# -- 1. the clean baseline walks free ------------------------------------------------------------
p=$(mkpen clean)
check "clean verdict"        "ok" "$(field_of verdict "$p")"
check "clean exit"           "0"  "$(exit_of "$p")"
check "clean modules"        "2"  "$(field_of modules "$p")"
check "clean covered"        "2"  "$(field_of covered "$p")"
check "clean guards"         "2"  "$(field_of guards "$p")"
check "clean lap guards"     "1"  "$(field_of lap_guards "$p")"
check "clean cadence guards" "1"  "$(field_of cadence_guards "$p")"

# -- 2. a symlink is another lane's module, never this one's --------------------------------------
# The reading that overstated this room 10 against 7 counted three links as its own; a module count
# that included the link would also demand a witness for it, which is the second half of the harm.
check "link counted apart"   "1"  "$(field_of linked "$p")"
check "link not a module"    "2"  "$(field_of modules "$p")"
check "link named"           "yes" "$(detail_has linked room/borrowed.rye "$p")"

# -- 3. a module no rostered guard names refuses, and the refusal lifts ---------------------------
p=$(mkpen uncovered)
printf 'const std = @import("std");\n' > "$p/room/gamma.rye"
check "uncovered verdict"    "drifted" "$(field_of verdict "$p")"
check "uncovered exit"       "1"       "$(exit_of "$p")"
check "uncovered count"      "1"       "$(field_of uncovered "$p")"
check "uncovered named"      "yes"     "$(detail_has uncovered room/gamma.rye "$p")"
printf '# names it\nlet m = "room/gamma.rye"\n' > "$p/tools/am/room_gamma_witness.rish"
cat >> "$p/construction/roster.kyri" <<'ADD'

guard room_gamma
path tools/am/room_gamma_witness.rish
tier lap
seated 20260907.223214
ADD
# A seated guard is named at the room's door in the same breath -- the exact step the front-door
# reading asks of a real lap, so the lift here is the whole repair rather than half of it.
printf '# room\n\nGuards: room_alpha, room_beta, room_gamma.\n' > "$p/room/README.md"
check "uncovered lifted"     "ok"      "$(field_of verdict "$p")"

# -- 4. a WITNESS that names it and no roster row does not cover it -------------------------------
# The whole point of this reading: coverage is what the roster is pointed at, never what the tools
# room happens to hold. A guard nobody runs guards nothing (REDS `%360`).
p=$(mkpen unrostered)
printf 'const std = @import("std");\n' > "$p/room/delta.rye"
printf '# names it, and no roster row names this file\nlet m = "room/delta.rye"\n' \
  > "$p/tools/am/room_delta_witness.rish"
check "unrostered still uncovered" "1"       "$(field_of uncovered "$p")"
check "unrostered verdict"         "drifted" "$(field_of verdict "$p")"
cat >> "$p/construction/roster.kyri" <<'ADD'

guard room_delta
path tools/am/room_delta_witness.rish
tier lap
seated 20260907.223214
ADD
printf '# room\n\nGuards: room_alpha, room_beta, room_delta.\n' > "$p/room/README.md"
check "unrostered lifted"          "ok"      "$(field_of verdict "$p")"

# -- 5. a roster row naming an absent file refuses, and the refusal lifts -------------------------
p=$(mkpen orphan)
cat >> "$p/construction/roster.kyri" <<'ADD'

guard room_gone
path tools/am/room_gone_witness.rish
tier lap
seated 20260907.223214
ADD
check "orphan verdict"       "drifted" "$(field_of verdict "$p")"
check "orphan count"         "1"       "$(field_of orphan_rows "$p")"
check "orphan named"         "yes"     "$(detail_has orphan_row tools/am/room_gone_witness.rish "$p")"
printf '# it exists now\n' > "$p/tools/am/room_gone_witness.rish"
printf '# room\n\nGuards: room_alpha, room_beta, room_gone.\n' > "$p/room/README.md"
check "orphan lifted"        "ok"      "$(field_of verdict "$p")"

# -- 6. a shim is followed one hop, and its target is what covers ---------------------------------
# `room/src/beta.rye` is named only inside tools/gen/room/room_beta.rish, which the rostered shim
# runs. Take the target away and beta must read uncovered -- otherwise the hop proved nothing.
p=$(mkpen shim)
check "shim covers via target"  "0" "$(field_of uncovered "$p")"
rm -f "$p/tools/gen/room/room_beta.rish"
check "target gone uncovers"    "1" "$(field_of uncovered "$p")"
check "target gone named"       "yes" "$(detail_has uncovered room/src/beta.rye "$p")"
printf '# the target the shim runs\nlet m = "room/src/beta.rye"\n' > "$p/tools/gen/room/room_beta.rish"
check "target back covers"      "0" "$(field_of uncovered "$p")"

# -- 7. a module one directory down is read like any other ----------------------------------------
# `amphora/src/main.rye` is the room's largest module and sits one level in; a maxdepth read would
# have missed it and called the room whole.
check "nested module counted"   "2" "$(field_of modules "$p")"

# -- 8. a thinly covered module is REPORTED and never gated ---------------------------------------
# A reported reading must show up in the count and leave the verdict alone. Both pen modules are
# named by exactly one guard, which is the honest state of two real modules in the vessel room.
p=$(mkpen singly)
check "singly counted"          "2"  "$(field_of singly_covered "$p")"
check "singly not gated"        "ok" "$(field_of verdict "$p")"
check "singly exit"             "0"  "$(exit_of "$p")"

# -- 9. an absent room and an absent roster answer misread, never zero ----------------------------
p=$(mkpen absent)
behaviors=$((behaviors + 1))
v=$( cd "$p" && sh "$SCAN" no_such_room construction/roster.kyri tools/am 2>/dev/null | sed -n 's/^verdict=//p' )
if [ "$v" = misread ]; then echo "  ok   absent room verdict"; else
  echo "  FAIL absent room verdict -- wanted [misread] got [$v]"; failed=$((failed + 1)); fi
behaviors=$((behaviors + 1))
( cd "$p" && sh "$SCAN" no_such_room construction/roster.kyri tools/am >/dev/null 2>&1 )
rc=$?
if [ "$rc" = 2 ]; then echo "  ok   absent room exit"; else
  echo "  FAIL absent room exit -- wanted [2] got [$rc]"; failed=$((failed + 1)); fi
behaviors=$((behaviors + 1))
v=$( cd "$p" && sh "$SCAN" room construction/no_such_roster.kyri tools/am 2>/dev/null | sed -n 's/^verdict=//p' )
if [ "$v" = misread ]; then echo "  ok   absent roster verdict"; else
  echo "  FAIL absent roster verdict -- wanted [misread] got [$v]"; failed=$((failed + 1)); fi

# -- 10. an empty guard room is a silence, never a pass -------------------------------------------
# Zero rostered guards over a room holding modules must refuse; a scan reading no texts and calling
# everything covered is the vacuum this leg exists to close.
p=$(mkpen vacuum)
: > "$p/construction/roster.kyri"
check "vacuum guards"        "0"       "$(field_of guards "$p")"
check "vacuum uncovered"     "2"       "$(field_of uncovered "$p")"
check "vacuum verdict"       "drifted" "$(field_of verdict "$p")"

# -- 11. the room's front door names every rostered guard, or the one it passes over is counted ----
# The list on `amphora/README.md` was typed by a hand and drifted exactly as the counts beside it
# did: 11 of 16 named. A count read off an instrument beside a hand-typed list is half a repair.
p=$(mkpen door)
check "door whole named"      "2"    "$(field_of readme_named "$p")"
check "door whole unnamed"    "0"    "$(field_of readme_unnamed "$p")"
check "door whole verdict"    "ok"   "$(field_of verdict "$p")"
printf '# room\n\nGuards: room_alpha.\n' > "$p/room/README.md"
check "door drops one"        "1"       "$(field_of readme_unnamed "$p")"
check "door drop verdict"     "drifted" "$(field_of verdict "$p")"
check "door drop exit"        "1"       "$(exit_of "$p")"
check "door drop named"       "yes"     "$(detail_has readme_unnamed room_beta "$p")"
printf '# room\n\nGuards: room_alpha and room_beta.\n' > "$p/room/README.md"
check "door drop lifted"      "ok"      "$(field_of verdict "$p")"

# -- 12. a name is matched at its boundaries, never as a substring ---------------------------------
# `amphora_pour` sits inside `amphora_pour_negative` and inside its own `amphora_pour_witness.rish`
# path, so a `grep -F` would let a door that names only the twin answer for the guard itself.
p=$(mkpen boundary)
printf '# room\n\nGuards: room_alpha_negative and room_beta_witness.rish.\n' > "$p/room/README.md"
check "longer name no credit"  "2"       "$(field_of readme_unnamed "$p")"
check "boundary verdict"       "drifted" "$(field_of verdict "$p")"
check "boundary names alpha"   "yes"     "$(detail_has readme_unnamed room_alpha "$p")"
check "boundary names beta"    "yes"     "$(detail_has readme_unnamed room_beta "$p")"
printf '# room\n\nGuards: room_alpha, room_beta.\n' > "$p/room/README.md"
check "boundary lifted"        "0"       "$(field_of readme_unnamed "$p")"

# -- 13. an absent front door answers absent, never zero -------------------------------------------
# Zero is the reading a whole door gives, so a room with no door must never look like one. The gate
# stands down there and the word is what a reader sees.
p=$(mkpen nodoor)
check "absent door word"      "absent" "$(field_of_door readme "$p" room/no_such_README.md)"
check "absent door unnamed"   "absent" "$(field_of_door readme_unnamed "$p" room/no_such_README.md)"
check "absent door spelled"   "absent" "$(field_of_door readme_spelled_lines "$p" room/no_such_README.md)"
check "absent door not gated" "ok"     "$(field_of_door verdict "$p" room/no_such_README.md)"

# -- 14. the room's weight is read, and a count spelled at the door is refused ---------------------
# The door read *`purchase_delivery.rye`, `vessel_fetch_wire.rye` and `vessel_fetch_delivery.rye`
# are 1,160 lines*. That figure was true one commit earlier and was written into the commit that
# grew one of the three by 109 changed lines, so it shipped 77 short and stood 161 short two days
# on. A hand that measures and then keeps working writes a true number that is already false, which
# is why `own_lines` reads on every run and the door is held at zero spelled counts.
p=$(mkpen weight)
check "weight own_lines"       "2"   "$(field_of own_lines "$p")"
check "weight names a module"  "yes" "$(detail_has lines "room/alpha.rye 1" "$p")"
check "weight door clean"      "0"   "$(field_of readme_spelled_lines "$p")"
check "weight clean verdict"   "ok"  "$(field_of verdict "$p")"
printf '# room\n\nGuards: room_alpha and room_beta.\nThe two are 1,160 lines together.\n' > "$p/room/README.md"
check "spelled count counted"  "1"       "$(field_of readme_spelled_lines "$p")"
check "spelled count gated"    "drifted" "$(field_of verdict "$p")"
check "spelled count exit"     "1"       "$(exit_of "$p")"
check "spelled count named"    "yes"     "$(detail_has spelled_line 4 "$p")"
# Folded case, so a door writing `1,160 Lines` cannot walk past a lowercase reading.
printf '# room\n\nGuards: room_alpha and room_beta.\nThe two are 1,160 Lines together.\n' > "$p/room/README.md"
check "spelled count folded"   "1"       "$(field_of readme_spelled_lines "$p")"
# The digit reading passes over the word form and the field names alike: `own_lines`, `detail_lines`
# and `thirty lines down` all walk free here, or the repair would refuse its own sentence. The word
# form is read by `readme_spelled_words` below rather than let go -- `%638` closed by saying a number
# spelled as a word cannot go stale in silence, and this room's own door proved otherwise the same day.
printf '# room\n\nGuards: room_alpha and room_beta.\nThe list thirty lines down reads own_lines and detail_lines off the scan.\n' \
  > "$p/room/README.md"
check "spelled count lifted"   "0"   "$(field_of readme_spelled_lines "$p")"
check "lift verdict"           "ok"  "$(field_of verdict "$p")"

# -- 14b. a count spelled in letters is read too, and reported rather than gated ------------------
# `%638` closed by saying a number spelled as a word cannot go stale in silence. It can: this room's
# own door read *Those eight build three modules* while nine of the rostered guards built all three,
# the sentence having been written when twelve guards stood over the room rather than sixteen. So
# the letter form is read beside the digit form -- and REPORTED, because the same door carries
# `three more modules` in a sentence that enumerates what it counts, and a wall refusing that would
# refuse honest prose.
printf '# room\n\nGuards: room_alpha and room_beta.\nThose eight build three modules here.\n' > "$p/room/README.md"
check "spelled word counted"   "1"   "$(field_of readme_spelled_words "$p")"
check "spelled word named"     "yes" "$(detail_has spelled_word 4 "$p")"
check "spelled word not gated" "ok"  "$(field_of verdict "$p")"
check "spelled word exit"      "0"   "$(exit_of "$p")"
# Case folded, so a door opening a sentence with the number is read too.
printf '# room\n\nGuards: room_alpha and room_beta.\nEight guards stand over this room.\n' > "$p/room/README.md"
check "spelled word folded"    "1"   "$(field_of readme_spelled_words "$p")"
# Hyphen form, since a door writes `a nine-line function` as readily as `nine lines`.
printf '# room\n\nGuards: room_alpha and room_beta.\nA nine-line function opens it.\n' > "$p/room/README.md"
check "spelled word hyphen"    "1"   "$(field_of readme_spelled_words "$p")"
# A word character after the noun ends the match, and a letter before the number ends it, so
# `eight guardrails` and `someone-line` walk free -- or the reading would refuse ordinary English.
printf '# room\n\nGuards: room_alpha and room_beta.\nThe eight guardrails hold, and someone-line wrote them.\n' > "$p/room/README.md"
check "spelled word bounded"   "0"   "$(field_of readme_spelled_words "$p")"
# The nouns are the four this instrument measures; a number beside any other noun is not its business.
printf '# room\n\nGuards: room_alpha and room_beta.\nIt holds one socket per exchange across two ports.\n' > "$p/room/README.md"
check "spelled word nouns"     "0"   "$(field_of readme_spelled_words "$p")"
check "spelled word clean"     "ok"  "$(field_of verdict "$p")"

# -- 15. the pen is proven innocent ---------------------------------------------------------------
# A scan that always answers ok must fail the uncovered leg above; if it passes, this control proves
# nothing. The patch's landing is proven by cmp rather than by sed's exit code (REDS `%519`).
LIAR="$PEN/liar_scan.sh"
sed 's/^echo "verdict=drifted"$/echo "verdict=ok"/; s/^exit 1$/exit 0/' "$SCAN" > "$LIAR"
behaviors=$((behaviors + 1))
if ! test -s "$LIAR" || cmp -s "$SCAN" "$LIAR"; then
  # An unreadable source leaves an EMPTY copy, which differs from the original and would read as a
  # landed patch -- so emptiness is checked before difference.
  echo "  FAIL innocence patch matched nothing -- the liar scan is empty or byte-identical"
  failed=$((failed + 1))
else
  echo "  ok   innocence patch landed"
  p=$(mkpen innocence)
  printf 'const std = @import("std");\n' > "$p/room/gamma.rye"
  check "liar scan says ok"     "ok"      "$(field_of verdict "$p" "$LIAR")"
  check "liar scan exits clean" "0"       "$(exit_of "$p" "$LIAR")"
  check "real scan refuses it"  "drifted" "$(field_of verdict "$p")"
fi

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "verdict=control_failed"
  exit 1
fi
echo "verdict=ok"
