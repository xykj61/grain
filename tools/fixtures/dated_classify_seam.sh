#!/bin/sh
# dated_classify_seam.sh — the regex seam for dated_classify.rish.
#
# Rishi owns the interface (tools/fixtures/dated_classify.rish); this POSIX-sh seam
# holds the two ripgrep patterns Rishi has no native regex for, exactly as the elder
# dated_classify.py delegated to Python's `re`. One definition lives here, reached
# only through the rish, so no two roofs can drift (REDS 40).
#
# Canon: context/specs/living-vs-dated.md
#   dated name   : (^|/)YYYYMMDD-HHMMSS_   anchored path segment
#   living header: **Stamp:** living ledger  |  living ledger (born   (case-insensitive, first 8000 bytes)
#
#   sh dated_classify_seam.sh classify <path>
#   sh dated_classify_seam.sh census
set -eu

DATED_RE='(^|/)[0-9]{8}-[0-9]{6}_'
HDR_RE='(?i)(\*\*Stamp:\*\* *living ledger|living ledger *\(born)'
SKIP_RE='\.(png|jpg|jpeg|gif|webp|ico|pdf|woff|woff2|ttf|otf|zip|gz|xz|wasm|so|o|a|bin|mp4|webm)$'

is_dated_name() { printf '%s' "$1" | rg -q "$DATED_RE"; }
is_skip_ext()   { printf '%s' "$1" | rg -q "$SKIP_RE"; }
has_header()    { head -c 8000 "$1" 2>/dev/null | rg -q "$HDR_RE"; }

classify() {
  p="$1"
  if ! is_dated_name "$p"; then echo live; return 0; fi
  if is_skip_ext "$p"; then echo dated; return 0; fi
  if has_header "$p"; then echo live; else echo dated; fi
}

census() {
  all=$(mktemp); dn=$(mktemp); tx=$(mktemp)
  trap 'rm -f "$all" "$dn" "$tx"' EXIT
  git ls-files -z | tr '\0' '\n' > "$all"
  total=$(grep -c '' "$all")
  rg "$DATED_RE" "$all" > "$dn" || true
  dated_named=$(grep -c '' "$dn" || true)
  rg -v "$SKIP_RE" "$dn" > "$tx" || true
  live_among=$(while IFS= read -r f; do has_header "$f" && echo x; done < "$tx" | grep -c '' || true)
  dated=$(( dated_named - live_among ))
  live=$(( total - dated ))
  health=$(awk -v l="$live" -v t="$total" 'BEGIN{ if(t==0){print 0}else{printf "%.0f", 100.0*l/t} }')
  printf 'tracked_total=%s\n' "$total"
  printf 'dated_testimony=%s\n' "$dated"
  printf 'live_surface=%s\n' "$live"
  printf 'fascia_health=%s\n' "$health"
  printf 'definition=living-vs-dated\n'
  printf 'dated_name=(^|/)YYYYMMDD-HHMMSS_\n'
  printf 'living_header=Stamp living ledger | living ledger (born\n'
  printf 'verdict=ok\n'
}

cmd="${1:-}"
case "$cmd" in
  classify) [ $# -ge 2 ] || { echo "usage: dated_classify_seam.sh classify <path>" >&2; exit 2; }; classify "$2" ;;
  census)   census ;;
  *)        echo "usage: dated_classify_seam.sh classify <path> | census" >&2; exit 2 ;;
esac
