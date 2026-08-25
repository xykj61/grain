#!/bin/sh
# tools/fixtures/counsel_flow_scan.sh -- the counsel-flow descriptor is lawful Brix.
# Orchestrated by tools/gen/season/counsel_flow_witness.rish.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# Brix law checked here (TAME Brix Supplement): declarative only -- no commands,
# no conditions, no loops, no expressions; plain key-value, one field per line,
# a single space between key and value, `#` for comments. Readable by splitLines
# and a first-space split, which is exactly what this scan does.
set -eu
f="${1:-tools/gen/season/counsel_flow.brix}"
[ -f "$f" ] || { echo "verdict=missing_descriptor"; exit 2; }

fields=0
bad=0
while IFS= read -r line; do
  case "$line" in
    ''|'#'*) continue ;;
  esac
  key=${line%% *}
  val=${line#* }
  if [ "$key" = "$line" ]; then
    echo "detail: field without a value -> $line"
    bad=$((bad + 1))
    continue
  fi
  case "$key" in
    *[!a-z_]*) echo "detail: key not lowercase_snake -> $key"; bad=$((bad + 1)) ;;
  esac
  case "$line" in
    *'  '*) echo "detail: more than one space after key -> $key"; bad=$((bad + 1)) ;;
  esac
  fields=$((fields + 1))
done < "$f"

# Required keys: the contract is useless without these.
for req in name version voice register lens audience attention_channel \
           check_in_every_rounds coined_term_law measurement_before_claim; do
  grep -q "^$req " "$f" || { echo "detail: required key absent -> $req"; bad=$((bad + 1)); }
done

# Declarative only: a Brix file that grew a conditional stopped being data.
if grep -qE '^[[:space:]]*(if|for|while|let|assert|run) ' "$f"; then
  echo "detail: descriptor contains a command or condition -- Brix is data only"
  bad=$((bad + 1))
fi

echo "fields=$fields"
echo "faults=$bad"
if [ "$bad" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=unlawful_brix"; exit 1; fi
