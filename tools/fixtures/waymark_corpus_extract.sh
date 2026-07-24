#!/bin/sh
# Extract sorted-unique [A-Z]{4} words from the flw fixture twin.
# Skips the attribution header above "# body unmodified below", then takes
# the first 51 body lines (elder four-letter block), same as the historic
# sed -n '1,51p' old/doc/spec/flw.txt pipeline.
# Usage: waymark_corpus_extract.sh <fixture> <out-corpus>
set -eu
fixture="${1:?fixture path required}"
out="${2:?output corpus path required}"
awk '/^# body unmodified below$/{p=1;next} p' "$fixture" \
  | sed -n '1,51p' \
  | tr ' ' '\n' \
  | grep -E '^[A-Z]{4}$' \
  | sort -u > "$out"
