#!/bin/sh
# tools/fixtures/l/landed_line_scan.sh -- a finished design names its shipping page.
#
# A landed line is its own line. The first word is Landed: and the second word is
# one repo-relative path. The scan checks that the path is a file. It prints. It
# does not edit the page.
#
#   sh tools/fixtures/l/landed_line_scan.sh
#   sh tools/fixtures/l/landed_line_scan.sh --root <dir> <page> ...
#
# With no pages, the roster below is the set that has opted in. A page with no
# landed line is unmarked, and unmarked is not a failure. A path the tree lacks
# is the failure.
set -euf

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
root=$ROOT
pages=""
while [ $# -gt 0 ]; do
  case "$1" in
    --root) root=${2:-}; shift 2 ;;
    *) pages="$pages $1"; shift ;;
  esac
done

if [ -z "$pages" ]; then
  pages="active-designing/date/20261003/20261003-135506_the-fascia-face.md active-designing/date/20261003/20261003-135506_where-a-finished-page-lives.md active-designing/date/20261003/20261003-112527_the-receipt-crawl.md"
fi

page_n=0
landed=0
unmarked=0
missing=0
bad=0

for page in $pages; do
  page_n=$((page_n + 1))
  target="$root/$page"
  if [ ! -f "$target" ]; then
    echo "detail: no page at $page"
    missing=$((missing + 1))
    continue
  fi
  found=0
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      "Landed:"*)
        found=$((found + 1))
        set -- $line
        if [ "$1" != "Landed:" ] || [ $# -ne 2 ]; then
          echo "detail: a landed line wants one path -> $page"
          bad=$((bad + 1))
          continue
        fi
        path=$2
        case "$path" in
          /*|*..*)
            echo "detail: path stays inside the root -> $path"
            bad=$((bad + 1))
            continue
            ;;
        esac
        if [ -f "$root/$path" ]; then
          landed=$((landed + 1))
          echo "landed=$path page=$page"
        else
          missing=$((missing + 1))
          echo "detail: shipping page is absent -> $path"
        fi
        ;;
    esac
  done < "$target"
  if [ "$found" -eq 0 ]; then
    unmarked=$((unmarked + 1))
    echo "unmarked=$page"
  fi
done

echo "pages=$page_n"
echo "landed=$landed"
echo "unmarked=$unmarked"
echo "missing=$missing"
echo "bad=$bad"
if [ "$missing" -eq 0 ] && [ "$bad" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=missing"
exit 1
