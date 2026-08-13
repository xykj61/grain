#!/bin/sh
# tools/fixtures/constel_naming_scan.sh — Constel test-network naming law, the safety scan.
#
#   sh tools/fixtures/constel_naming_scan.sh <names-file>
#
# Checks the one load-bearing promise of the Constel naming law: every fake dev-network
# constellation name carries at least one digit, and so can NEVER parse as a real @p (which
# after its ~ is lowercase letters + hyphens only, from a fixed 256-syllable table holding
# no digits). A digit anywhere is a structural proof of non-@p, checkable without the table
# — the same certainty the placeholder-ship-names law earns from segment length.
#
# Prints one `name=<n> digit=yes|no` line per drawn name, then a `verdict=ok` line when
# every name carries a digit, or `verdict=unsafe` naming the first that does not. Output
# convention: context/specs/20260729-215600_scan-seam-convention.md — the scan carries the
# verdict; a caller checks status before trusting the lines.
#
# Law: active-designing/20260813-022222_constel-test-network-naming-law.md
set -eu

if [ "$#" -ne 1 ]; then
  echo "detail: usage — constel_naming_scan.sh <names-file>" 1>&2
  exit 2
fi
names=$1
if [ ! -f "$names" ]; then
  echo "detail: absent names file ($names)" 1>&2
  exit 2
fi

unsafe=""
count=0
# Read each non-comment, non-blank line as one drawn constel name.
while IFS= read -r line; do
  case "$line" in
    ''|\#*) continue ;;
  esac
  name=$line
  count=$((count + 1))
  # A real @p body is [a-z-]+ with no digit; a digit proves the name is not a real address.
  if printf '%s' "$name" | grep -q '[0-9]'; then
    echo "name=$name digit=yes"
  else
    echo "name=$name digit=no"
    if [ -z "$unsafe" ]; then unsafe=$name; fi
  fi
done < "$names"

echo "names=$count"
if [ -n "$unsafe" ]; then
  echo "verdict=unsafe first=$unsafe"
  exit 1
fi
echo "verdict=ok"
