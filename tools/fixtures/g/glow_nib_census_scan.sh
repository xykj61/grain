#!/bin/sh
# tools/fixtures/g/glow_nib_census_scan.sh -- count glow nibs that end in -v0.
#
# These nibs are waymark names. The census counts them and names each family.
# It does not rewrite a nib. Comlink is the family this lap reads by hand:
# its -v0 records stay beside the -v2 record that already accreted.
#
#   sh tools/fixtures/g/glow_nib_census_scan.sh
#   sh tools/fixtures/g/glow_nib_census_scan.sh --root <dir>
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
root=$ROOT
while [ $# -gt 0 ]; do
  case "$1" in
    --root) root=${2:-}; shift 2 ;;
    *) echo "verdict=bad_argument"; exit 2 ;;
  esac
done

list=$(mktemp)
fam=$(mktemp)
trap 'rm -f "$list" "$fam"' EXIT
: > "$list"
for dir in src/gate src/shape; do
  shelf=$root/$dir
  if [ -d "$shelf" ]; then
    find "$shelf" -maxdepth 1 -type f -name '*.glow' >> "$list"
  fi
done
sort -o "$list" "$list"

if [ ! -s "$list" ]; then
  echo "files_v0=0"
  echo "nibs_v0=0"
  echo "family_named=none"
  echo "verdict=ok"
  exit 0
fi

# xargs keeps the file list out of a shell glob. awk sees each glow file once.
xargs awk '
  {
    for (i = 1; i <= NF; i++) {
      if ($i == "nib" && (i + 1) <= NF && $(i + 1) ~ /-v0$/) {
        tok = $(i + 1)
        sub(/^equinox-[A-Za-z0-9]+-/, "", tok)
        sub(/-v0$/, "", tok)
        split(tok, parts, "-")
        print FILENAME "\t" parts[1]
      }
    }
  }
' < "$list" > "$fam"

files_v0=$(cut -f 1 "$fam" | sort -u | wc -l | tr -d ' ')
nibs_v0=$(wc -l < "$fam" | tr -d ' ')
echo "files_v0=$files_v0"
echo "nibs_v0=$nibs_v0"
if [ -s "$fam" ]; then
  cut -f 2 "$fam" | sort | uniq -c | while read -r n name; do
    echo "family_$name=$n"
  done
fi
if cut -f 2 "$fam" | grep -qx 'comlink'; then
  echo "family_named=comlink"
else
  echo "family_named=none"
fi
echo "verdict=ok"
exit 0
