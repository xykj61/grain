#!/bin/sh
# tools/fixtures/r/receipt_product_braid_scan.sh -- do the two products stay unbraided?
#
# WHAT THIS IS FOR. The accepted receipt contract carries one falsifier, and half of it is a
# statement about code: "If one replay cannot produce both product readings from the same admitted
# facts, or EITHER PRODUCT MUST IMPORT THE OTHER'S PROJECTION TYPE, this contract is wrong." Its
# acceptance case 8 says the same thing as a build condition -- "the build fails if Linengrow
# imports DimerollReceiptIntake or Dimeroll imports LinengrowReceipt."
#
# Measured `20260917`, that sentence stood on nothing. Neither projection type appeared in any
# module source, so the two rooms were clean; and a clean population with no guard over it is a
# boundary held by nobody once the build starts. The contract is ACCEPTED for implementation, which
# is precisely when the braid becomes tempting: one import saves an afternoon and costs the
# separation the whole contract exists to state. A boundary is cheap to hold before the code is
# written and expensive to recover after.
#
# WHERE THE PAIR COMES FROM. The contract's own `Residence | Owns` table, read rather than spelled:
# a row whose Owns cell reads `ReceiptState -> LinengrowReceipt` names one product room and one
# projection type. Exactly two such rows are wanted. So renaming a type in the contract moves this
# guard with it, and a contract this scan cannot read answers `verdict=unreadable` and exits
# non-zero rather than reporting a comfortable zero over a population it never found.
#
# GATED AT ZERO
#   cross_import   a product room's Rye source reaching the peer room in an `@import` argument.
#                  This is acceptance case 8 exactly.
#   cross_type     the peer's projection type name standing in a product room's Rye source
#                  OUTSIDE a comment and outside a string literal -- a declaration, a parameter,
#                  a field, a call. This is the falsifier's own words.
#
# REPORTED, NEVER GATED
#   cross_mention  the same type name inside a comment or a string literal. A module head that
#                  explains the boundary it keeps -- "this module never reaches
#                  DimerollReceiptIntake" -- is doing the right thing, and a meter reading for
#                  truth must hear a sentence that must stay false exactly as it hears one
#                  asserting it (`.claude/rules/derived-spine.md`, the pen-plant clause). So the
#                  role decides, never the room.
#   peer_word      a product room's source naming the peer room's own word in code outside a
#                  comment or string -- `dimeroll` inside `linengrow/`, or the reverse. A tell
#                  rather than a fault: the two products may legitimately share a fixture name or
#                  a lane word, and only a person reading the line can say which.
#
# WHAT IT CANNOT SEE. Whether the two projections actually mean different things, and a braid
# routed through a third module that imports both and hands each a view of the other. The first is
# a judgment about the product; the second wants a call graph rather than a scan, and the shared
# room the contract names -- Mantra -- is shared ON PURPOSE, which is why every room outside the
# two product rooms is read past here.
#
# STRINGS ARE BLANKED BEFORE COMMENTS, because a `//` inside a string literal opens no comment and
# blanking the other way round loses the rest of that line. Zig's `\\` multiline string runs to the
# end of its line, so it is blanked as a line tail.
#
# Usage: sh tools/fixtures/r/receipt_product_braid_scan.sh [--list]
# Environment: CONTRACT and ROOT override the inputs, so a pen may drive this same script against a
# planted braid in a throwaway tree.

set -eu

ROOT="${ROOT:-.}"
CONTRACT="${CONTRACT:-active-designing/20260912-201126_the-receipt-you-can-read-contract.md}"

LIST=no
for arg in "$@"; do
  case "$arg" in
    --list) LIST=yes ;;
    *) echo "detail: unknown argument $arg" >&2; exit 2 ;;
  esac
done

unreadable() {
  echo "detail: $1"
  echo "verdict=unreadable"
  exit 1
}

cd "$ROOT" 2>/dev/null || unreadable "cannot enter $ROOT"
[ -f "$CONTRACT" ] || unreadable "cannot read $CONTRACT"

WORK=$(mktemp -d) || unreadable "cannot make a work directory"
trap 'rm -rf "$WORK"' EXIT HUP INT TERM

# --- the product pair, read off the contract's residence table ---------------
# room<TAB>projection_type
awk '
  /^\| *Residence *\| *Owns *\|/ { intable = 1; next }
  intable && substr($0, 1, 1) != "|" { intable = 0 }
  intable {
    n = split($0, cell, "|")
    if (n < 4) next
    room = cell[2]; owns = cell[3]
    gsub(/^[ \t]+|[ \t]+$/, "", room)
    # The Owns cell that names a projection reads `<state> -> <Type>` in backticks.
    if (owns !~ /`[A-Za-z0-9_]+ -> [A-Za-z0-9_]+`/) next
    t = owns
    sub(/^.*-> /, "", t)
    sub(/`.*$/, "", t)
    gsub(/^[ \t]+|[ \t]+$/, "", t)
    if (room == "" || t == "") next
    printf "%s\t%s\n", room, t
  }
' "$CONTRACT" > "$WORK/pair"

PAIRS=$(wc -l < "$WORK/pair" | tr -d ' ')
[ "$PAIRS" = "2" ] || unreadable "the residence table named $PAIRS projection rows in $CONTRACT, wanting exactly 2"

A_ROOM=$(sed -n 1p "$WORK/pair" | cut -f1)
A_TYPE=$(sed -n 1p "$WORK/pair" | cut -f2)
B_ROOM=$(sed -n 2p "$WORK/pair" | cut -f1)
B_TYPE=$(sed -n 2p "$WORK/pair" | cut -f2)

A_DIR=$(printf '%s' "$A_ROOM" | tr 'A-Z' 'a-z')
B_DIR=$(printf '%s' "$B_ROOM" | tr 'A-Z' 'a-z')

# --- the population, from the index rather than the disk ---------------------
# A tracked file is what a clone receives; an untracked scratch copy is nobody's boundary.
git ls-files "$A_DIR" 2>/dev/null | grep '\.rye$' > "$WORK/a_files" || true
git ls-files "$B_DIR" 2>/dev/null | grep '\.rye$' > "$WORK/b_files" || true

A_N=$(wc -l < "$WORK/a_files" | tr -d ' ')
B_N=$(wc -l < "$WORK/b_files" | tr -d ' ')
[ "$A_N" -gt 0 ] || unreadable "no tracked Rye source under $A_DIR/"
[ "$B_N" -gt 0 ] || unreadable "no tracked Rye source under $B_DIR/"

# --- one reading, run once per direction -------------------------------------
# The file lists come from `git ls-files`, and a path holding a space would be split by a bare word
# expansion, so both lists are handed to awk BY NAME and read with getline rather than expanded.
read_room_safe() {
  # $1 files list, $2 self dir, $3 peer dir, $4 peer type
  awk -v peerdir="$3" -v peertype="$4" -v list="$LIST" -v filesf="$1" '
    # One walk, two answers. `keep` = 1 returns the line with COMMENTS removed and string
    # literals intact; `keep` = 0 blanks the strings as well. An `@import` argument IS a string
    # literal, so the import reading needs the first and the type reading needs the second -- a
    # single blanking served one of them and silently lost the other.
    function strip(line, keep,   out, i, c, n, instr) {
      out = ""; instr = 0; n = length(line)
      for (i = 1; i <= n; i++) {
        c = substr(line, i, 1)
        if (instr) {
          if (c == "\\") { out = out (keep ? substr(line, i, 2) : "  "); i++; continue }
          if (c == "\"") { instr = 0; out = out (keep ? c : " "); continue }
          out = out (keep ? c : " ")
          continue
        }
        if (c == "\"") { instr = 1; out = out (keep ? c : " "); continue }
        # A Zig multiline string runs to the end of its line, and so does a comment.
        if (c == "\\" && substr(line, i + 1, 1) == "\\") return out
        if (c == "/" && substr(line, i + 1, 1) == "/") return out
        out = out c
      }
      return out
    }
    BEGIN {
      while ((getline path < filesf) > 0) {
        n = 0
        while ((getline raw < path) > 0) {
          n++
          code = strip(raw, 0)
          live = strip(raw, 1)
          if (match(live, /@import\("[^"]*"\)/)) {
            arg = substr(live, RSTART + 9, RLENGTH - 11)
            low = tolower(arg)
            if (index(low, peerdir "/") > 0 || low ~ ("(^|/)" peerdir "[_.]")) {
              imports++
              if (list == "yes") printf "cross_import file=%s line=%d import=%s\n", path, n, arg
            }
          }
          if (index(code, peertype) > 0) {
            types++
            if (list == "yes") printf "cross_type file=%s line=%d type=%s\n", path, n, peertype
          } else if (index(raw, peertype) > 0) {
            mentions++
            if (list == "yes") printf "cross_mention file=%s line=%d type=%s\n", path, n, peertype
          }
          if (index(tolower(code), peerdir) > 0) {
            words++
            if (list == "yes") printf "peer_word file=%s line=%d word=%s\n", path, n, peerdir
          }
        }
        close(path)
      }
      close(filesf)
      printf "TALLY %d %d %d %d\n", imports + 0, types + 0, mentions + 0, words + 0
    }
  ' /dev/null
}

A_OUT=$(read_room_safe "$WORK/a_files" "$A_DIR" "$B_DIR" "$B_TYPE")
B_OUT=$(read_room_safe "$WORK/b_files" "$B_DIR" "$A_DIR" "$A_TYPE")

printf '%s\n' "$A_OUT" | grep -v '^TALLY ' || true
printf '%s\n' "$B_OUT" | grep -v '^TALLY ' || true

set -- $(printf '%s\n' "$A_OUT" | grep '^TALLY ' | cut -d' ' -f2-)
A_IMP=$1; A_TYP=$2; A_MEN=$3; A_WRD=$4
set -- $(printf '%s\n' "$B_OUT" | grep '^TALLY ' | cut -d' ' -f2-)
B_IMP=$1; B_TYP=$2; B_MEN=$3; B_WRD=$4

IMPORTS=$((A_IMP + B_IMP))
TYPES=$((A_TYP + B_TYP))
MENTIONS=$((A_MEN + B_MEN))
WORDS=$((A_WRD + B_WRD))

echo "product_a=$A_ROOM dir=$A_DIR type=$A_TYPE files=$A_N"
echo "product_b=$B_ROOM dir=$B_DIR type=$B_TYPE files=$B_N"
echo "cross_import=$IMPORTS cross_type=$TYPES"
echo "cross_mention=$MENTIONS peer_word=$WORDS"

if [ "$IMPORTS" -gt 0 ]; then
  echo "verdict=cross_import"
  exit 1
fi
if [ "$TYPES" -gt 0 ]; then
  echo "verdict=cross_type"
  exit 1
fi
echo "verdict=unbraided"
