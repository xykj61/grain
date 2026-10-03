#!/bin/sh
# tools/fixtures/r/receipt_crawl_scan.sh -- list file paths from one day of receipts.
#
# A receipt crawl reads session logs from the oldest stamp toward the newest and
# prints each file line's path. here=yes means that path is a file under the
# root. The scan does not delete, rename, or edit a receipt.
#
#   sh tools/fixtures/r/receipt_crawl_scan.sh session-logs/date/20261003
#   sh tools/fixtures/r/receipt_crawl_scan.sh --root <dir> <day-dir>
#
# One directory. At most RECEIPT_CRAWL_MAX kyri files, default 256, the room bound.
set -euf

MAX=${RECEIPT_CRAWL_MAX:-256}
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
root=$ROOT
day=""
while [ $# -gt 0 ]; do
  case "$1" in
    --root) root=${2:-}; shift 2 ;;
    *) day=$1; shift ;;
  esac
done

if [ -z "$day" ]; then
  echo "verdict=no_day"
  exit 2
fi
case "$day" in
  *..*) echo "verdict=refused_parent"; exit 2 ;;
esac
if [ ! -d "$root/$day" ] && [ -d "$day" ]; then
  shelf=$day
else
  shelf=$root/$day
fi
if [ ! -d "$shelf" ]; then
  echo "verdict=not_a_directory"
  exit 2
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
find "$shelf" -maxdepth 1 -type f -name '*.kyri' | sort > "$tmp"
receipts=$(wc -l < "$tmp" | tr -d ' ')
if [ "$receipts" -gt "$MAX" ]; then
  echo "receipts=$receipts"
  echo "max=$MAX"
  echo "verdict=over_bound"
  exit 2
fi

paths=0
missing=0
refused=0
while IFS= read -r receipt; do
  [ -n "$receipt" ] || continue
  base=$(basename "$receipt" .kyri)
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      "file "*)
        set -- $line
        if [ $# -lt 2 ]; then
          continue
        fi
        path=$2
        case "$path" in
          /*|*..*)
            refused=$((refused + 1))
            echo "stamp=$base path=$path here=refused"
            continue
            ;;
        esac
        paths=$((paths + 1))
        if [ -f "$root/$path" ]; then
          echo "stamp=$base path=$path here=yes"
        else
          missing=$((missing + 1))
          echo "stamp=$base path=$path here=no"
        fi
        ;;
    esac
  done < "$receipt"
done < "$tmp"

echo "receipts=$receipts"
echo "paths=$paths"
echo "missing=$missing"
echo "refused=$refused"
echo "verdict=ok"
exit 0
