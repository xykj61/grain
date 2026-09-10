#!/bin/sh
# tools/fixtures/t/tame_reach_control.sh -- proves tame_reach_scan.sh on real git trees in a pen.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every gate and
# both ceilings are planted and then lifted, and every welcome is asserted as hard as every
# refusal. The pen is a real git repository because the scan derives its population from
# `git ls-files` on purpose -- what the tree tracks is what the tree governs -- and a pen that
# faked that with `find` would prove a different instrument than the one that ships.
#
# The pen sits under this tree's own `.lap/`, the gitignored per-lap scratch room, rather than a
# shared /tmp: eight ships share this pier, and a path under this root cannot be reached by
# another ship at all (REDS %549, %620).
#
#   sh tools/fixtures/t/tame_reach_control.sh

set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

SCAN="$ROOT/tools/fixtures/t/tame_reach_scan.sh"
[ -f "$SCAN" ] || { echo "control: no scan at $SCAN" >&2; exit 2; }

mkdir -p "$ROOT/.lap" || exit 2
PEN=$(mktemp -d "$ROOT/.lap/tame-reach-pen.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT INT TERM

pass=0
fail=0
check() { # check <name> <expected> <actual>
  if [ "$2" = "$3" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "FAIL: $1 -- want [$2] got [$3]"
  fi
}

read_key() { printf '%s\n' "$2" | sed -n "s/^$1=//p" | tail -1; }

# --- the pen: a miniature tree the scan can find its root in ------------------
mkdir -p "$PEN/rishi/bin" "$PEN/tools/fixtures/t" "$PEN/alpha" "$PEN/beta"
cp "$SCAN" "$PEN/tools/fixtures/t/tame_reach_scan.sh"
: > "$PEN/rishi/bin/.keep"

cat > "$PEN/tools/fixtures/t/rooms.txt" <<'EOF'
# a pen roster
alpha
EOF

# The pen's debt-room list: the one room holding uncovered authored Rye when the pen is built.
cat > "$PEN/tools/fixtures/t/debt.txt" <<'EOF'
# a pen debt-room list
beta
EOF

printf 'const std = @import("std");\nconst assert = std.debug;\n' > "$PEN/alpha/one.rye"
printf 'const std = @import("std");\n' > "$PEN/alpha/two.rye"
printf 'const std = @import("std");\n' > "$PEN/beta/three.rye"

( cd "$PEN" && git init -q . && git add -A >/dev/null 2>&1 \
  && git -c user.email=pen@pen -c user.name=pen -c commit.gpgsign=false commit -qm pen >/dev/null 2>&1 ) || {
  echo "control: could not build the pen repository" >&2; exit 2; }

run_pen() { # run_pen <env assignments...>  -> prints scan output, sets RC
  ( cd "$PEN" && env TAME_REACH_DEBT_ROOMS=tools/fixtures/t/debt.txt \
      TAME_REACH_DEBT_ROOM_CEILING=1 "$@" sh tools/fixtures/t/tame_reach_scan.sh 2>&1 )
}

# --- 1. the clean read --------------------------------------------------------
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=0)
check "clean verdict"            "ok"     "$(read_key verdict "$out")"
check "clean roster_rooms"       "1"      "$(read_key roster_rooms "$out")"
check "clean phantom_rooms"      "0"      "$(read_key phantom_rooms "$out")"
check "clean population"         "3"      "$(read_key population "$out")"
check "clean covered"            "2"      "$(read_key covered "$out")"
check "clean uncovered_authored" "1"      "$(read_key uncovered_authored "$out")"
check "clean ban hits"           "0"      "$(read_key unwatched_ban_hits "$out")"

# --- 2. the file count is published and gated by nothing ----------------------
# The elder ceiling on this number red on ordinary work twice before it was retired, so the leg
# that matters now is that no ceiling exists to trip: the count is read and left alone.
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=0)
check "file count published"     "1"      "$(read_key uncovered_authored "$out")"
check "file count says it free"  "no"     "$(read_key uncovered_authored_gated "$out")"
check "clean rooms"              "1"      "$(read_key uncovered_rooms "$out")"
check "clean unknown rooms"      "0"      "$(read_key uncovered_rooms_unknown "$out")"
check "clean debt rooms"         "1"      "$(read_key debt_rooms "$out")"

# --- 2a. a room the debt list does not name, both sides ----------------------
printf '# a pen debt-room list\n' > "$PEN/tools/fixtures/t/debt.txt"
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=0)
rc=$?
check "unknown room verdict"     "unknown_debt_room" "$(read_key verdict "$out")"
check "unknown room refuses"     "1"      "$rc"
check "unknown room counted"     "1"      "$(read_key uncovered_rooms_unknown "$out")"
case "$out" in
  *"  beta"*) pass=$((pass + 1)) ;;
  *) fail=$((fail + 1)); echo "FAIL: unknown room is named -- got [$out]" ;;
esac
printf '# a pen debt-room list\nbeta\n' > "$PEN/tools/fixtures/t/debt.txt"
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=0)
check "unknown room lifted"      "ok"     "$(read_key verdict "$out")"
check "unknown back to zero"     "0"      "$(read_key uncovered_rooms_unknown "$out")"

# --- 2b. the debt-room ceiling, both sides -----------------------------------
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_DEBT_ROOM_CEILING=0 TAME_REACH_BAN_CEILING=0)
rc=$?
check "debt rooms over ceiling"  "over_debt_room_ceiling" "$(read_key verdict "$out")"
check "debt rooms refuse"        "1"      "$rc"
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=0)
check "debt rooms at ceiling ok" "ok"     "$(read_key verdict "$out")"

# --- 2d. an absent debt-room list refuses ------------------------------------
out=$( ( cd "$PEN" && TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_DEBT_ROOMS=tools/fixtures/t/absent.txt sh tools/fixtures/t/tame_reach_scan.sh 2>&1 ) )
rc=$?
check "absent debt list refuses" "2"      "$rc"
case "$out" in
  *"no debt-room list at"*) pass=$((pass + 1)) ;;
  *) fail=$((fail + 1)); echo "FAIL: absent debt list names itself -- got [$out]" ;;
esac

# --- 3. a ban outside the roster is unwatched debt ---------------------------
printf 'const std = @import("std");\nstd.debug.assert(x);\n' > "$PEN/beta/four.rye"
( cd "$PEN" && git add -A >/dev/null 2>&1 && git -c user.email=pen@pen -c user.name=pen -c commit.gpgsign=false commit -qm ban >/dev/null 2>&1 )
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=0)
rc=$?
check "ban over ceiling"         "over_ban_ceiling" "$(read_key verdict "$out")"
check "ban refuses"              "1"      "$rc"
check "ban hits counted"         "1"      "$(read_key unwatched_ban_hits "$out")"
check "ban files counted"        "1"      "$(read_key unwatched_ban_files "$out")"
check "ban room named"           "beta"   "$(read_key unwatched_ban_rooms "$out")"
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=1)
check "ban at ceiling ok"        "ok"     "$(read_key verdict "$out")"

# --- 4. a ban INSIDE the roster is the bans half's business, never counted here
printf 'const std = @import("std");\nstd.debug.assert(y);\nstd.debug.assert(z);\n' > "$PEN/alpha/five.rye"
( cd "$PEN" && git add -A >/dev/null 2>&1 && git -c user.email=pen@pen -c user.name=pen -c commit.gpgsign=false commit -qm inside >/dev/null 2>&1 )
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=1)
check "covered ban not counted"  "1"      "$(read_key unwatched_ban_hits "$out")"
check "covered room not named"   "beta"   "$(read_key unwatched_ban_rooms "$out")"
check "covered ban still ok"     "ok"     "$(read_key verdict "$out")"
check "covered grew"             "3"      "$(read_key covered "$out")"

# --- 5. a phantom roster room, both sides ------------------------------------
printf 'alpha\ngamma\n' > "$PEN/tools/fixtures/t/rooms.txt"
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=99)
rc=$?
check "phantom verdict"          "phantom_room" "$(read_key verdict "$out")"
check "phantom refuses"          "1"      "$rc"
check "phantom counted"          "1"      "$(read_key phantom_rooms "$out")"
printf 'alpha\n' > "$PEN/tools/fixtures/t/rooms.txt"
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=99)
check "phantom lifted"           "ok"     "$(read_key verdict "$out")"
check "phantom back to zero"     "0"      "$(read_key phantom_rooms "$out")"

# --- 6. a control's own plant is read past -----------------------------------
printf 'const std = @import("std");\nstd.debug.assert(p);\ndbg(q);\n' > "$PEN/tools/fixtures/t/plant_ban.rye"
( cd "$PEN" && git add -A >/dev/null 2>&1 && git -c user.email=pen@pen -c user.name=pen -c commit.gpgsign=false commit -qm plant >/dev/null 2>&1 )
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=1)
check "plant counted as plant"   "1"      "$(read_key uncovered_plant "$out")"
check "plant not authored debt"  "2"      "$(read_key uncovered_authored "$out")"
check "plant ban not counted"    "1"      "$(read_key unwatched_ban_hits "$out")"
check "plant leaves verdict ok"  "ok"     "$(read_key verdict "$out")"

# --- 7. symlink, .cache/ and bin/ are outside the population ------------------
mkdir -p "$PEN/beta/.cache" "$PEN/beta/bin"
printf 'std.debug.assert(a);\n' > "$PEN/beta/.cache/cached.rye"
printf 'std.debug.assert(b);\n' > "$PEN/beta/bin/built.rye"
( cd "$PEN/beta" && ln -s three.rye linked.rye )
( cd "$PEN" && git add -A -f >/dev/null 2>&1 && git -c user.email=pen@pen -c user.name=pen -c commit.gpgsign=false commit -qm edges >/dev/null 2>&1 )
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=1)
check "edges leave population"   "6"      "$(read_key population "$out")"
check "edges leave authored"     "2"      "$(read_key uncovered_authored "$out")"
check "edges leave ban count"    "1"      "$(read_key unwatched_ban_hits "$out")"

# --- 8. untracked Rye is outside the population, and the choice is proven -----
printf 'std.debug.assert(c);\n' > "$PEN/beta/scratch.rye"
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=1)
check "untracked outside"        "6"      "$(read_key population "$out")"
( cd "$PEN" && git add -A >/dev/null 2>&1 && git -c user.email=pen@pen -c user.name=pen -c commit.gpgsign=false commit -qm tracked >/dev/null 2>&1 )
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=2)
check "tracking it brings it in" "7"      "$(read_key population "$out")"
check "and its ban with it"      "2"      "$(read_key unwatched_ban_hits "$out")"

# --- 9. an absent roster refuses rather than reading a clean tree -------------
out=$( ( cd "$PEN" && TAME_REACH_ROSTER=tools/fixtures/t/absent.txt sh tools/fixtures/t/tame_reach_scan.sh 2>&1 ) )
rc=$?
check "absent roster refuses"    "2"      "$rc"
case "$out" in
  *"no roster at"*) pass=$((pass + 1)) ;;
  *) fail=$((fail + 1)); echo "FAIL: absent roster names itself -- got [$out]" ;;
esac

# --- 10. a comment line in the roster is not a room ---------------------------
printf '# beta\nalpha\n' > "$PEN/tools/fixtures/t/rooms.txt"
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=99)
check "comment is not a room"    "1"      "$(read_key roster_rooms "$out")"
check "comment leaves beta out"  "3"      "$(read_key uncovered_authored "$out")"

# --- 11. a new file in an ALREADY-NAMED debt room moves nothing gated ---------
# The whole point of the split, run last because it changes the population every leg above reads.
# The elder ceiling on the file count red exactly here, on lawful work, twice.
printf 'alpha\n' > "$PEN/tools/fixtures/t/rooms.txt"
before=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=99)
printf 'const std = @import("std");\n' > "$PEN/beta/lawful.rye"
( cd "$PEN" && git add -A >/dev/null 2>&1 && git -c user.email=pen@pen -c user.name=pen -c commit.gpgsign=false commit -qm lawful >/dev/null 2>&1 )
after=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=99)
check "lawful file leaves ok"    "ok"     "$(read_key verdict "$after")"
check "lawful file raises count" "$(( $(read_key uncovered_authored "$before") + 1 ))" "$(read_key uncovered_authored "$after")"
check "lawful file keeps rooms"  "$(read_key uncovered_rooms "$before")" "$(read_key uncovered_rooms "$after")"
check "lawful file keeps unknown" "0"     "$(read_key uncovered_rooms_unknown "$after")"

# --- 12. a wholly NEW uncovered room reds on the lap it arrives ---------------
# The promise the elder witness made and the file count could not keep: this file and the one
# above are indistinguishable to a count, and opposite to the room reading.
mkdir -p "$PEN/gamma"
printf 'const std = @import("std");\n' > "$PEN/gamma/new.rye"
( cd "$PEN" && git add -A >/dev/null 2>&1 && git -c user.email=pen@pen -c user.name=pen -c commit.gpgsign=false commit -qm gamma >/dev/null 2>&1 )
out=$(run_pen TAME_REACH_ROSTER=tools/fixtures/t/rooms.txt TAME_REACH_BAN_CEILING=99)
rc=$?
check "new room verdict"         "unknown_debt_room" "$(read_key verdict "$out")"
check "new room refuses"         "1"      "$rc"
check "new room counted"         "1"      "$(read_key uncovered_rooms_unknown "$out")"
check "new room raises rooms"    "2"      "$(read_key uncovered_rooms "$out")"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
exit 0
