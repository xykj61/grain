#!/bin/sh
# tools/fixtures/r/receipt_crawl_control.sh -- the crawl prints, and it does not cut.
#
# Oldest stamp first. A path that exists reads here=yes. A path that does not
# reads here=no. The file that exists is still there after the scan. A bound of
# one file refuses two receipts. A non-directory refuses.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
scan=tools/fixtures/r/receipt_crawl_scan.sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

mkdir -p "$pen/day" "$pen/kept"
printf 'kept\n' > "$pen/kept/note.txt"
printf 'file kept/note.txt the note\n' > "$pen/day/20261003-010000_older.kyri"
printf 'file kept/gone.txt absent\n' > "$pen/day/20261003-020000_newer.kyri"

behaviors=0
failed=0
one() {
  behaviors=$((behaviors + 1))
  name=$1
  shift
  if "$@"; then
    echo "behavior=$name ok"
  else
    echo "behavior=$name FAIL"
    failed=$((failed + 1))
  fi
}

out=$(sh "$scan" --root "$pen" day)
printf '%s\n' "$out" > "$pen/out.txt"
one order awk '
  /path=kept\/note.txt/ { note=NR }
  /path=kept\/gone.txt/ { gone=NR }
  END { exit !(note && gone && note < gone) }
' "$pen/out.txt"
one present grep -q 'path=kept/note.txt here=yes' "$pen/out.txt"
one absent grep -q 'path=kept/gone.txt here=no' "$pen/out.txt"
one still_there test -f "$pen/kept/note.txt"
one bound sh -c "RECEIPT_CRAWL_MAX=1 sh '$scan' --root '$pen' day; test \$? -eq 2"
one not_dir sh -c "sh '$scan' --root '$pen' kept/note.txt; test \$? -eq 2"

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=failed"
exit 1
