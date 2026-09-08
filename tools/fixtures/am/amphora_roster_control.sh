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

# -- 11. the pen is proven innocent ---------------------------------------------------------------
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
