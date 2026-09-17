#!/bin/sh
# tools/fixtures/c/comment_path_control.sh -- prove the comment-path reading on real repositories.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal,
# because a refusal proven only in the passing direction cannot be told from a bypass. Eight
# mutations of the scan itself are asserted to bite, so a leg that would pass with the check removed
# is named here rather than trusted.
#
# USAGE
#   sh tools/fixtures/c/comment_path_control.sh
#
# Driven by tools/c/comment_path_witness.rish. Run from the repository root.

set -eu

root=$(pwd)
scan="$root/tools/fixtures/c/comment_path_scan.sh"
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }
portable="$root/tools/fixtures/s/shell_portable.sh"
[ -f "$portable" ] || { echo "control_verdict=no_portable"; exit 1; }

pen=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

legs=0
failed=0

leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg_ok: $1"
  else
    failed=$((failed + 1))
    echo "leg_no: $1 -- wanted $3, read $2"
  fi
}

read_key() { awk -F= -v k="$1" '$1 == k { print $2 }'; }

# The scan is copied into a flat pen holding fixtures/c and fixtures/s and no tree at all, which is
# why its root walk keeps a named sibling fallback.
mkdir -p "$pen/kit/fixtures/c" "$pen/kit/fixtures/s"
cp "$scan" "$pen/kit/fixtures/c/comment_path_scan.sh"
cp "$portable" "$pen/kit/fixtures/s/shell_portable.sh"
kit="$pen/kit/fixtures/c/comment_path_scan.sh"

mk_repo() {
  d="$pen/$1"
  mkdir -p "$d"
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  echo "$d"
}

repo=$(mk_repo one)
cd "$repo"
mkdir -p room shelf room/sub/deep room/date/20260101 room/templates
: > room/real.md
: > room/sub/deep/leaf.md
: > shelf/target.md

# --- the welcomes: every one of these must stay uncounted ---
cat > room/welcomes.rish <<'SRC'
# Root-relative and tracked: `shelf/target.md`.
# Page-relative and tracked: `../shelf/target.md`.
# A tracked directory: `room/sub/`.
# No slash at all: `gone.md`.
# Holding a space: `gone/not a path.md`.
# An extension this tree does not write: `gone/x.pdf`.
# Holding a glob: `gone/*.md`.
# An absolute path: `/etc/gone/x.txt`.
# On the web: `https://example.invalid/gone/x.md`.
# A field this program prints: `transcript=shelf/gone.txt`.
# A shell expansion: `$work/gone.txt`.
# A label before the slash: `PATH:shelf/gone.md`.
say "a program line rather than a comment names `shelf/gone.md`"
SRC

# The room-relative try needs a source standing BELOW the room root, or the page-relative try answers
# first -- the spelling a page writes about its own room.
cat > room/templates/cell.rye <<'SRC'
// Room-relative from a source one level down: `sub/deep/leaf.md`.
SRC

# --- the comment mark is per language, and a program line is never read ---
cat > room/glow_mark.glow <<'SRC'
:: A Glow comment cites `shelf/target.md`.
SRC
cat > room/zig_mark.zig <<'SRC'
// A Zig comment cites `shelf/target.md`.
SRC
cat > room/roster.kyri <<'SRC'
# A roster comment cites `shelf/target.md`.
SRC

# --- the plant: one living citation whose PARENT this tree carries and whose file is gone ---
cat > room/plant.rish <<'SRC'
# The witness that binds this claim: `shelf/gone.md`.
SRC

# --- the fourth genre: a path whose parent this tree has never carried is a pen's own room ---
cat > room/builds_a_pen.sh <<'SRC'
# The control writes `nowhere/leaf.txt` and `deeper/still/leaf.md` into its own throwaway pen.
SRC

# --- a placeholder is an illustration, counted apart from a citation ---
cat > room/shapes.rish <<'SRC'
# The filing shape, inside a room this pen carries: `shelf/YYYYMMDD-HHMMSS_sprig.md`.
# A named slot, inside that same room: `shelf/<page>.md`.
SRC

# --- testimony keeps every word it wrote, and is counted apart ---
cat > room/20260101-010101_stamped.rish <<'SRC'
# A stamped basename is testimony: `shelf/gone.md`.
SRC
cat > room/date/20260101/folded.rish <<'SRC'
# A dated shelf is testimony: `shelf/gone.md`.
SRC

# --- a symlink's citations belong to its body, never to the door ---
ln -s real.md room/door.rish

git add -A && git commit -q -m pen

out=$(COMMENT_PATH_CEILING=99999 sh "$kit" 2>/dev/null)
leg "twelve welcome shapes, a program line and a room cell stay uncounted, and one plant is read" \
  "$(printf '%s\n' "$out" | read_key living)" "1"
leg "the plant stands in one file" "$(printf '%s\n' "$out" | read_key living_files)" "1"
leg "two pen paths are counted apart from the promise" "$(printf '%s\n' "$out" | read_key pen)" "2"
leg "two placeholder shapes are counted apart" "$(printf '%s\n' "$out" | read_key placeholder)" "2"
leg "two testimony shapes are counted apart" "$(printf '%s\n' "$out" | read_key testimony)" "2"
leg "the symlinked door is read past and said out loud" "$(printf '%s\n' "$out" | read_key symlinks_read_past)" "1"

list=$(COMMENT_PATH_CEILING=99999 sh "$kit" --list 2>/dev/null)
leg "--list names the file and the path it cites" \
  "$(printf '%s\n' "$list" | grep -c 'promise: room/plant.rish cites shelf/gone.md')" "1"
leg "--list stays silent about testimony" \
  "$(printf '%s\n' "$list" | grep -c 'promise: room/date/20260101/folded.rish')" "0"
leg "--list stays silent about a pen's own room" \
  "$(printf '%s\n' "$list" | grep -c 'nowhere/leaf.txt')" "0"

# --- the ceiling, proven from both sides with no slack ---
at=$(COMMENT_PATH_CEILING=1 sh "$kit" 2>/dev/null)
leg "standing exactly at the ceiling walks free" "$(printf '%s\n' "$at" | read_key verdict)" "ok"
over=$(COMMENT_PATH_CEILING=0 sh "$kit" 2>/dev/null || true)
leg "one over the ceiling refuses" "$(printf '%s\n' "$over" | read_key verdict)" "over_ceiling"
leg "and it leaves a non-zero exit" "$(COMMENT_PATH_CEILING=0 sh "$kit" >/dev/null 2>&1 && echo yes || echo no)" "no"

# --- lifting the plant returns the reading ---
rm room/plant.rish
git add -A && git commit -q -m lift
lifted=$(COMMENT_PATH_CEILING=0 sh "$kit" 2>/dev/null)
leg "with the plant lifted the living reading is zero" "$(printf '%s\n' "$lifted" | read_key living)" "0"
leg "and the clean tree reaches ok at a ceiling of zero" "$(printf '%s\n' "$lifted" | read_key verdict)" "ok"

# --- a fresh clone answers this, never one pier's disk ---
cat > room/untracked.rish <<'SRC'
# Present on this disk and in no clone: `shelf/ondisk.md`.
SRC
git add room/untracked.rish && git commit -q -m untracked
: > shelf/ondisk.md
disk=$(COMMENT_PATH_CEILING=99999 sh "$kit" 2>/dev/null)
leg "an untracked file on disk keeps the promise broken" "$(printf '%s\n' "$disk" | read_key living)" "1"
git add -A && git commit -q -m tracknow
now=$(COMMENT_PATH_CEILING=99999 sh "$kit" 2>/dev/null)
leg "tracking that same file keeps the promise" "$(printf '%s\n' "$now" | read_key living)" "0"

# --- an instrument that cannot answer refuses rather than answering ---
bare="$pen/bare"
mkdir -p "$bare"
outside=$(cd "$bare" && sh "$kit" 2>/dev/null || true)
leg "outside a repository the scan refuses rather than answering" \
  "$(printf '%s\n' "$outside" | read_key verdict)" "no_repo"
badflag=$(cd "$repo" && sh "$kit" --nope 2>/dev/null || true)
leg "an unknown flag refuses by name" "$(printf '%s\n' "$badflag" | read_key verdict)" "bad_flag"

# --- a root source whose name holds an equals sign, the awk assignment trap ---
cd "$repo"
cat > 'eq=1.sh' <<'SRC'
# A root source awk would read as a setting: `shelf/gone.md`.
SRC
git add -A && git commit -q -m eq
eq=$(COMMENT_PATH_CEILING=99999 sh "$kit" 2>/dev/null)
leg "the scan sees a root source whose name holds an equals sign" "$(printf '%s\n' "$eq" | read_key living)" "1"

# --- the mutations: each check removed must change an answer ---
mut="$pen/kit/fixtures/c/mutant.sh"
drop() { grep -vF "$1" "$kit" > "$mut"; }
# A whole-line swap compared literally, handed through the environment rather than through -v:
# awk processes escape sequences in a -v assignment, so a line holding a tab escape would be
# compared against a real tab and never match.
swap() { SWAP_OLD="$1" SWAP_NEW="$2" awk '$0 == ENVIRON["SWAP_OLD"] { print ENVIRON["SWAP_NEW"]; next } { print }' "$kit" > "$mut"; }

base=$(printf '%s\n' "$eq" | read_key living)

drop 'if (substr(line, 1, mlen) != mark) next'
m1=$(COMMENT_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the comment-mark test reads a program line as a comment" \
  "$([ "$(printf '%s\n' "$m1" | read_key living)" -gt "$base" ] && echo bit || echo silent)" "bit"

drop 'if (room != "" && here(norm(room "/" s))) continue'
m2=$(COMMENT_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the room-relative try makes an honest room cell read broken" \
  "$([ "$(printf '%s\n' "$m2" | read_key living)" -gt "$base" ] && echo bit || echo silent)" "bit"

swap '      print "pen\t" page "\t" s' '      print "living\t" page "\t" s'
m3=$(COMMENT_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the pen split prices two pen rooms as broken promises" \
  "$([ "$(printf '%s\n' "$m3" | read_key living)" -eq "$((base + 2))" ] && echo bit || echo silent)" "bit"

swap '    print (testimony(page) ? "testimony" : "living") "\t" page "\t" s' '    print "living\t" page "\t" s'
m4=$(COMMENT_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the testimony split pulls two shelved files into the gate" \
  "$([ "$(printf '%s\n' "$m4" | read_key living)" -eq "$((base + 2))" ] && echo bit || echo silent)" "bit"

# Both placeholder plants stand inside a room this pen carries, so removing the test moves them
# into the GATE rather than into the pen count -- a mutation proven on a reported number alone
# could not tell a sharpened report from a loosened gate.
drop 'if (placeholder(s)) { print "placeholder\t" page "\t" s; continue }'
m5=$(COMMENT_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the placeholder test prices two illustrations as citations" \
  "$([ "$(printf '%s\n' "$m5" | read_key living)" -eq "$((base + 2))" ] && echo bit || echo silent)" "bit"

# The field test sharpens the REPORT rather than the gate, and this leg says so by asserting where
# the two shapes land without it: a key=path or an expansion has no tracked parent, so it would be
# counted as a room somewhere else rather than as a broken promise.
drop 'if (s ~ /[=$]/) continue'
m6=$(COMMENT_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the field test counts two printed output lines as rooms" \
  "$([ "$(printf '%s\n' "$m6" | read_key pen)" -eq "$(( $(printf '%s\n' "$eq" | read_key pen) + 2 ))" ] && echo bit || echo silent)" "bit"
leg "and the gate stays where it was, which is what makes it a report" \
  "$(printf '%s\n' "$m6" | read_key living)" "$base"

# The symlink exclusion is asserted on the FIELD as well as the gate: a door read as a source would
# carry its body's citations twice, and repairing them would write through the link.
swap 'awk '"'"'$1 == "120000" { sub(/^[^\t]*\t/, ""); print }'"'"' "$work/staged.txt" > "$work/links.txt"' ': > "$work/links.txt"'
m7=$(COMMENT_PATH_CEILING=99999 sh "$mut" 2>/dev/null)
leg "dropping the symlink roster stops saying how many doors were read past" \
  "$([ "$(printf '%s\n' "$m7" | read_key symlinks_read_past)" -lt 1 ] && echo bit || echo silent)" "bit"

swap 'sed '"'"'s|^|./|'"'"' "$work/kept.txt" > "$work/sources.txt"' 'cat "$work/kept.txt" > "$work/sources.txt"'
m8=$(COMMENT_PATH_CEILING=99999 sh "$mut" 2>/dev/null || true)
leg "dropping the ./ prefix hides the equals-sign source from the reading" \
  "$([ "$(printf '%s\n' "$m8" | read_key living)" -lt "$base" ] && echo bit || echo silent)" "bit"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; exit 1; fi
