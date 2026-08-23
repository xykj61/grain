#!/bin/sh
# Print the closing parity cost table (top 20 by wall time + chapter totals)
# and optionally write work-in-progress/<stamp>_parity-cost-table.md.
#
# Env: PARITY_COST_LOG (default tools/.cache/parity-cost/current.tsv)
#      PARITY_COST_REPORT=1 to write the WIP markdown report
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
log=${PARITY_COST_LOG:-$root/tools/.cache/parity-cost/current.tsv}
stamp=$(TZ=America/New_York date +%Y%m%d-%H%M%S)
stamp_dot=$(TZ=America/New_York date +%Y%m%d.%H%M%S)

if [ ! -f "$log" ]; then
  echo "parity_cost_table: no cost log at $log" >&2
  exit 1
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# chapter name start end elapsed_ms exit
awk -F'\t' 'NF>=6 {print $0}' "$log" >"$tmp"

total_ms=$(awk -F'\t' '{s+=$5} END {print s+0}' "$tmp")
rows=$(wc -l <"$tmp" | tr -d ' ')

echo "=== parity cost table ==="
echo "stamp ${stamp_dot}"
echo "log ${log}"
echo "rows ${rows}"
echo "total_ms ${total_ms}"
echo
echo "--- chapter totals ---"
awk -F'\t' '{
  c[$1]+=$5; n[$1]++
} END {
  for (k in c) printf "%s\t%sms\t%d witnesses\n", k, c[k], n[k]
}' "$tmp" | sort -t'	' -k2 -nr
echo
echo "--- top 20 by wall time ---"
sort -t'	' -k5 -nr "$tmp" | head -20 | awk -F'\t' '{
  printf "%2d. %s / %s — %sms (exit %s)\n", NR, $1, $2, $5, $6
}'
echo "=== end parity cost table ==="

if [ "${PARITY_COST_REPORT:-}" = "1" ]; then
  report="$root/work-in-progress/${stamp}_parity-cost-table.md"
  {
    echo "# Parity cost table"
    echo
    echo "**Language:** EN"
    echo "**Stamp:** \`${stamp_dot}\`"
    echo "**Voice:** Quin"
    echo "**Status:** Measurement — S0 yardstick from instrumented full run"
    echo "**Ground:** counsel \`20260726.044729\` · log \`${log}\`"
    echo
    echo "---"
    echo
    echo "## Summary"
    echo
    echo "| Field | Value |"
    echo "|---|---|"
    echo "| Rows | ${rows} |"
    echo "| Total ms | ${total_ms} |"
    echo "| Total min (approx) | $(awk -v t="$total_ms" 'BEGIN {printf "%.1f", t/60000}') |"
    echo
    echo "## Chapter totals"
    echo
    echo '| Chapter | ms | Witnesses |'
    echo '|---|---:|---:|'
    awk -F'\t' '{
      c[$1]+=$5; n[$1]++
    } END {
      for (k in c) printf "| %s | %s | %d |\n", k, c[k], n[k]
    }' "$tmp" | sort -t'|' -k3 -nr
    echo
    echo "## Top 20 by wall time"
    echo
    echo '| Rank | Chapter | Name | ms | Exit |'
    echo '|---:|---|---|---:|---:|'
    sort -t'	' -k5 -nr "$tmp" | head -20 | awk -F'\t' '{
      printf "| %d | %s | %s | %s | %s |\n", NR, $1, $2, $5, $6
    }'
    echo
    echo "---"
    echo
    echo "*S0 only. No archive cuts and no pack workers land before this table.*"
  } >"$report"
  echo "REPORT_PATH=${report}"
fi
