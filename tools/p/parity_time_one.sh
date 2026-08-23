#!/bin/sh
# Time one parity witness (or chapter child). Appends a TSV cost row and
# prints COST_START / COST_FINISH lines on stderr for the capture log.
#
# Usage: sh tools/p/parity_time_one.sh <name> -- <command> [args...]
# Env:   PARITY_COST_LOG (default tools/.cache/parity-cost/current.tsv)
#        PARITY_COST_CHAPTER (default unknown)
#        ZIG_* — seated to tools/.cache/zig/{local,global} when unset
set -eu
if [ "$#" -lt 3 ]; then
  echo "parity_time_one: usage: $0 <name> -- <command> [args...]" >&2
  exit 2
fi
name=$1
shift
if [ "$1" != "--" ]; then
  echo "parity_time_one: expected -- after name" >&2
  exit 2
fi
shift

root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
export ZIG_LOCAL_CACHE_DIR="${ZIG_LOCAL_CACHE_DIR:-$root/tools/.cache/zig/local}"
export ZIG_GLOBAL_CACHE_DIR="${ZIG_GLOBAL_CACHE_DIR:-$root/tools/.cache/zig/global}"
mkdir -p "$ZIG_LOCAL_CACHE_DIR" "$ZIG_GLOBAL_CACHE_DIR"

log=${PARITY_COST_LOG:-$root/tools/.cache/parity-cost/current.tsv}
mkdir -p "$(dirname "$log")"
chapter=${PARITY_COST_CHAPTER:-}
if [ -z "$chapter" ] && [ -f "$root/tools/.cache/parity-cost/chapter" ]; then
  chapter=$(cat "$root/tools/.cache/parity-cost/chapter")
fi
chapter=${chapter:-unknown}

start_ns=$(date +%s%N)
start_stamp=$(TZ=America/New_York date +%Y%m%d.%H%M%S)
printf 'COST_START chapter=%s name=%s stamp=%s\n' "$chapter" "$name" "$start_stamp" >&2

set +e
"$@"
code=$?
set -e

end_ns=$(date +%s%N)
end_stamp=$(TZ=America/New_York date +%Y%m%d.%H%M%S)
elapsed_ms=$(( (end_ns - start_ns) / 1000000 ))
printf 'COST_FINISH chapter=%s name=%s stamp=%s elapsed_ms=%s exit=%s\n' \
  "$chapter" "$name" "$end_stamp" "$elapsed_ms" "$code" >&2
printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
  "$chapter" "$name" "$start_stamp" "$end_stamp" "$elapsed_ms" "$code" >>"$log"
exit "$code"
