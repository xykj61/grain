#!/bin/sh
# tools/fixtures/k/kyri_resins_landed_control.sh -- prove kyri_resins_landed_scan.sh on real git history.
#
# The subject is a reading taken from git, so every pen here is a REAL repository with real commits
# rather than a directory of files. A plant built without history would prove the scan can count
# files and nothing about the claim it exists to hold.
#
# Every refusal is shown from the failing side AND then lifted, so a reading can never be a plant
# that planted nothing (REDS `%519`). Every welcome is asserted as hard as every refusal, because a
# refusal proven only in the passing direction cannot be told from a bypass. Three mutations of the
# scan are asserted to BITE, each one a plausible edit that would leave the gate looking healthy.
# Every leg is named, and this control tallies its own legs so a leg nobody quotes is still heard
# (REDS `%794`'s family).
#
# Run from the repository root:
#   sh tools/fixtures/k/kyri_resins_landed_control.sh
set -u

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/k/kyri_resins_landed_scan.sh"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/kyri_resins_landed_control.XXXXXX") || exit 2
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

# A pen repository holding a cellar of two landed resins and a catalog. Identity and signing are
# set per repository, because this pen must commit on a machine whose global config may demand a
# key it cannot reach.
mkpen() { # mkpen <name> ; echoes its repository root
  d="$PEN/$1"
  mkdir -p "$d/kyri-resins"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email pen@example.invalid
  git -C "$d" config user.name pen
  git -C "$d" config commit.gpgsign false
  printf 'a\n' > "$d/kyri-resins/20260101-000001_first.kyri"
  printf 'b\n' > "$d/kyri-resins/20260101-000002_second.kyri"
  printf 'format kyri-resins-v1\n' > "$d/kyri-resins/manifest.kyri"
  git -C "$d" add -A
  git -C "$d" commit -q -m "cellar: land two resins"
  echo "$d"
}

# One scan run per (repository, scan, flag), cached in the pen. Reading four fields out of one
# cellar cost four whole scans before this, and the listing pen holds seventy resins -- so the
# cache is what keeps a control that proves itself on real history inside a lap's clock.
CACHE="$PEN/.capture"
mkdir -p "$CACHE"
capture() { # capture <repo> [<scan>] [<flag>] ; echoes the transcript path
  # The key carries the TREE STATE as well as the path, because a pen is edited and re-read in
  # the same run -- a cache keyed on the repository alone answered the lifted plant with the
  # planted reading, which is how this line came to be written.
  state=$( (git -C "$1" rev-parse HEAD 2>/dev/null; find "$1/kyri-resins" -type f -exec cksum {} + 2>/dev/null | LC_ALL=C sort) | cksum | cut -d' ' -f1)
  key=$(printf '%s|%s|%s|%s' "$1" "${2:-$SCAN}" "${3:-}" "$state" | cksum | cut -d' ' -f1)
  out="$CACHE/$key"
  if [ ! -f "$out" ]; then
    ( cd "$1" && sh "${2:-$SCAN}" kyri-resins ${3:-} 2>/dev/null ) > "$out" || true
  fi
  echo "$out"
}

field_of() { # field_of <key> <repo> [<scan>] [<flag>]
  grep "^$1=" "$(capture "$2" "${3:-}" "${4:-}")" | head -1 | cut -d= -f2-
}

exit_of() { # exit_of <repo> [<scan>]
  ( cd "$1" && sh "${2:-$SCAN}" kyri-resins >/dev/null 2>&1 )
  echo $?
}

echo "kyri-resins landed control -- real repositories in $PEN"

# --- the healthy reading, so every refusal below has a baseline ------------------------------
p=$(mkpen clean)
check "clean pen answers ok"        "ok" "$(field_of verdict "$p")"
check "clean pen counts two resins" "2"  "$(field_of resins "$p")"
check "clean pen lands both"        "2"  "$(field_of landed "$p")"
check "clean pen moves none"        "0"  "$(field_of moved "$p")"
check "clean pen exits clean"       "0"  "$(exit_of "$p")"

# --- an edit standing in the working tree, which is what a seal alone cannot see --------------
p=$(mkpen edited)
printf 'a changed\n' > "$p/kyri-resins/20260101-000001_first.kyri"
check "an uncommitted edit moves one" "1"      "$(field_of moved "$p")"
check "an uncommitted edit refuses"   "moved"  "$(field_of verdict "$p")"
check "an uncommitted edit exits 1"   "1"      "$(exit_of "$p")"
printf 'a\n' > "$p/kyri-resins/20260101-000001_first.kyri"
check "lifting the edit walks free"   "ok"     "$(field_of verdict "$p")"

# --- the exact defect this guard exists for: an edit landed with its seal, self-consistent -----
p=$(mkpen resealed)
printf 'a rewritten\n' > "$p/kyri-resins/20260101-000001_first.kyri"
printf 'seal 20260101-000001_first.kyri deadbeef\n' >> "$p/kyri-resins/manifest.kyri"
git -C "$p" add -A
git -C "$p" commit -q -m "cellar: rewrite a resin and reseal it"
check "a resealed rewrite still moves" "1"     "$(field_of moved "$p")"
check "a resealed rewrite refuses"     "moved" "$(field_of verdict "$p")"
check "a resealed rewrite is multi"    "1"     "$(field_of commits_multi "$p")"
git -C "$p" revert --no-edit HEAD >/dev/null 2>&1
check "reverting it walks free"        "ok"    "$(field_of verdict "$p")"

# --- a resin written and not yet committed: ordinary work, reported and never gated ------------
p=$(mkpen uncommitted)
printf 'c\n' > "$p/kyri-resins/20260101-000003_third.kyri"
check "an uncommitted resin is counted" "1"  "$(field_of uncommitted "$p")"
check "an uncommitted resin lands two"   "2"  "$(field_of landed "$p")"
check "an uncommitted resin walks free"  "ok" "$(field_of verdict "$p")"
git -C "$p" add -A
git -C "$p" commit -q -m "cellar: land a third resin"
check "committing it clears uncommitted"    "0"  "$(field_of uncommitted "$p")"
check "committing it lands three"        "3"  "$(field_of landed "$p")"

# --- the catalog is the living file and is excluded by name ------------------------------------
p=$(mkpen catalog)
printf 'entry 20260101-000001_first.kyri the first resin\n' >> "$p/kyri-resins/manifest.kyri"
git -C "$p" add -A
git -C "$p" commit -q -m "cellar: catalog a resin"
check "the catalog may move"        "ok" "$(field_of verdict "$p")"
check "the catalog is not a resin"  "2"  "$(field_of resins "$p")"

# --- a lawful move: a rename carrying a resin into a fold keeps its bytes ----------------------
p=$(mkpen renamed)
mkdir -p "$p/kyri-resins/date"
git -C "$p" mv kyri-resins/20260101-000002_second.kyri kyri-resins/20260101-000002_second_moved.kyri
git -C "$p" commit -q -m "cellar: fold a resin"
check "a rename keeps its bytes"    "0"  "$(field_of moved "$p")"
check "a rename walks free"         "ok" "$(field_of verdict "$p")"

# --- a re-add: deleted and restored, first with its own bytes and then with others -------------
p=$(mkpen readded)
git -C "$p" rm -q kyri-resins/20260101-000001_first.kyri
git -C "$p" commit -q -m "cellar: remove a resin"
printf 'a\n' > "$p/kyri-resins/20260101-000001_first.kyri"
git -C "$p" add -A
git -C "$p" commit -q -m "cellar: restore a resin"
check "a faithful re-add is counted" "1"  "$(field_of readded "$p")"
check "a faithful re-add walks free" "ok" "$(field_of verdict "$p")"
printf 'a different\n' > "$p/kyri-resins/20260101-000001_first.kyri"
git -C "$p" add -A
git -C "$p" commit -q -m "cellar: re-add a resin with other bytes"
check "an unfaithful re-add refuses" "moved" "$(field_of verdict "$p")"

# --- what the scan cannot read, answered by name rather than by a zero -------------------------
p=$(mkpen misread)
check "an absent room is a misread"   "misread" "$(cd "$p" && sh "$SCAN" no-such-room 2>/dev/null | grep '^verdict=' | cut -d= -f2)"
check "an absent room exits 2"        "2"       "$(cd "$p" && sh "$SCAN" no-such-room >/dev/null 2>&1; echo $?)"
check "an unknown flag is a misread"  "misread" "$(cd "$p" && sh "$SCAN" kyri-resins --nope 2>/dev/null | grep '^verdict=' | cut -d= -f2)"
mkdir -p "$PEN/bare/kyri-resins"
printf 'x\n' > "$PEN/bare/kyri-resins/20260101-000001_first.kyri"
check "no repository is a misread"    "misread" "$(cd "$PEN/bare" && sh "$SCAN" kyri-resins 2>/dev/null | grep '^verdict=' | cut -d= -f2)"

# --- the listing names its own drop (REDS %797) -------------------------------------------------
p=$(mkpen listing)
i=3
while [ "$i" -le 70 ]; do
  printf 'r%s\n' "$i" > "$p/kyri-resins/20260101-0000$i""_bulk.kyri"
  i=$((i + 1))
done
git -C "$p" add -A
git -C "$p" commit -q -m "cellar: land a large room"
check "a capped listing shows its cap"  "64" "$(field_of detail_cap "$p" "$SCAN" --list)"
check "a capped listing shows its drop" "6"  "$(field_of detail_dropped "$p" "$SCAN" --list)"
check "a capped listing shows 64 rows"  "64" "$(field_of detail_shown "$p" "$SCAN" --list)"
check "a large room still walks free"   "ok" "$(field_of verdict "$p")"

# --- mutations: three plausible edits that must each bite ---------------------------------------
mutate() { # mutate <name> <sed program> ; echoes the mutant path, or empty when the patch missed
  m="$PEN/mutant_$1.sh"
  sed "$2" "$SCAN" > "$m"
  if ! test -s "$m" || cmp -s "$SCAN" "$m"; then
    echo ""
  else
    echo "$m"
  fi
}

# M1 -- read the NEWEST adding commit rather than the earliest. An unfaithful re-add then compares
# the file against the bytes it was last added with, and reads `same`.
m=$(mutate newest_add 's/first\[\$1\] = \$2;/if (!($1 in first)) first[$1] = $2;/')
behaviors=$((behaviors + 1))
if [ -z "$m" ]; then
  echo "  FAIL mutation newest_add patched nothing"
  failed=$((failed + 1))
else
  echo "  ok   mutation newest_add landed"
  p=$(mkpen mut_newest)
  git -C "$p" rm -q kyri-resins/20260101-000001_first.kyri
  git -C "$p" commit -q -m "cellar: remove"
  printf 'a wholly other\n' > "$p/kyri-resins/20260101-000001_first.kyri"
  git -C "$p" add -A
  git -C "$p" commit -q -m "cellar: re-add with other bytes"
  check "real scan bites the re-add"     "moved" "$(field_of verdict "$p")"
  check "mutation newest_add misses it"  "ok"    "$(field_of verdict "$p" "$m")"
fi

# M2 -- stop excluding the catalog. The catalog moves by design, so a healthy cellar reds.
m=$(mutate keep_catalog 's/ ! -name manifest\.kyri//')
behaviors=$((behaviors + 1))
if [ -z "$m" ]; then
  echo "  FAIL mutation keep_catalog patched nothing"
  failed=$((failed + 1))
else
  echo "  ok   mutation keep_catalog landed"
  p=$(mkpen mut_catalog)
  printf 'entry 20260101-000001_first.kyri a note\n' >> "$p/kyri-resins/manifest.kyri"
  git -C "$p" add -A
  git -C "$p" commit -q -m "cellar: catalog a resin"
  check "real scan frees the catalog"        "ok"    "$(field_of verdict "$p")"
  check "mutation keep_catalog reds a clean cellar" "moved" "$(field_of verdict "$p" "$m")"
fi

# M3 -- report the move and exit clean. The reading stays honest and the gate stops gating, which
# is the shape a guard fails in most quietly.
m=$(mutate no_gate 's/^  echo "verdict=moved"$/  echo "verdict=moved"; exit 0/')
behaviors=$((behaviors + 1))
if [ -z "$m" ]; then
  echo "  FAIL mutation no_gate patched nothing"
  failed=$((failed + 1))
else
  echo "  ok   mutation no_gate landed"
  p=$(mkpen mut_gate)
  printf 'a changed\n' > "$p/kyri-resins/20260101-000001_first.kyri"
  check "real scan exits 1 on a move"   "1" "$(exit_of "$p")"
  check "mutation no_gate exits clean"  "0" "$(cd "$p" && sh "$m" kyri-resins >/dev/null 2>&1; echo $?)"
fi

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "verdict=control_failed"
  exit 1
fi
echo "verdict=ok"
