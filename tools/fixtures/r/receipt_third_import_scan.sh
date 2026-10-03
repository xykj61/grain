#!/bin/sh
# tools/fixtures/r/receipt_third_import_scan.sh -- a third module that imports both receipts.
#
# The braid scan reads the two product rooms and reads Mantra past, because Mantra
# is the shared carrier on purpose. This scan reads every other tracked .rye file.
# A file counts when its own @import lines reach both receipt projections:
# linengrow/receipt_offer.rye or linengrow_receipt_offer.rye, and the dimeroll pair.
# One file, one hop. pond/apps/drawn_terminal.rye imports other files in those rooms
# and does not count.
#
#   sh tools/fixtures/r/receipt_third_import_scan.sh
#   sh tools/fixtures/r/receipt_third_import_scan.sh --plant <path>
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

plant=""
while [ $# -gt 0 ]; do
  case "$1" in
    --plant)
      plant=${2:-}
      [ -n "$plant" ] || { echo "detail: --plant wants a path" >&2; exit 2; }
      shift 2
      ;;
    *) echo "detail: unknown argument $1" >&2; exit 2 ;;
  esac
done

list=$(mktemp)
trap 'rm -f "$list"' EXIT HUP INT TERM

git ls-files '*.rye' | awk '
  $0 ~ /^(mantra|linengrow|dimeroll)\// { next }
  { print }
' > "$list"

if [ -n "$plant" ]; then
  [ -f "$plant" ] || { echo "detail: plant is not a file: $plant" >&2; exit 2; }
  case "$plant" in
    mantra/*|linengrow/*|dimeroll/*) ;;
    *) printf '%s\n' "$plant" >> "$list" ;;
  esac
fi

files=$(wc -l < "$list" | tr -d ' ')
ceiling=4096
if [ "$files" -gt "$ceiling" ]; then
  echo "files=$files third_import=0 ceiling=$ceiling"
  echo "verdict=over_ceiling"
  exit 1
fi

awk -v files="$files" -v ceiling="$ceiling" '
  function suffix(arg, tail,   n, m) {
    n = length(arg); m = length(tail)
    if (n < m) return 0
    if (substr(arg, n - m + 1) != tail) return 0
    if (n == m) return 1
    return substr(arg, n - m, 1) == "/"
  }
  function side(arg) {
    if (suffix(arg, "linengrow/receipt_offer.rye")) return "l"
    if (suffix(arg, "linengrow_receipt_offer.rye")) return "l"
    if (suffix(arg, "dimeroll/receipt_offer.rye")) return "d"
    if (suffix(arg, "dimeroll_receipt_offer.rye")) return "d"
    return ""
  }
  BEGIN {
    hits = 0
    while ((getline path < ARGV[1]) > 0) {
      have_l = 0; have_d = 0
      while ((getline raw < path) > 0) {
        line = raw
        sub(/^[ \t]*\/\/.*/, "", line)
        cut = index(line, "//")
        if (cut > 0) line = substr(line, 1, cut - 1)
        while (match(line, /@import\("[^"]*"\)/)) {
          arg = substr(line, RSTART + 9, RLENGTH - 11)
          which = side(arg)
          if (which == "l") have_l = 1
          if (which == "d") have_d = 1
          line = substr(line, RSTART + RLENGTH)
        }
      }
      close(path)
      if (have_l && have_d) hits++
    }
    close(ARGV[1])
    printf "files=%d third_import=%d ceiling=%d\n", files, hits, ceiling
    if (hits > 0) print "verdict=braid"
    else print "verdict=clear"
    exit (hits > 0)
  }
' "$list"
