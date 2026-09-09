#!/bin/sh
# sow_reach_inputs.sh -- name the inputs used to count allowed seed rooms.
# Source this file and call sow_reach_inputs with one manifest path.
# The receipt covers manifest bytes and tracked paths under its allow entries.
# It is coverage provenance; privacy and file contents need their own witnesses.

sow_reach_inputs() (
  set -eu
  [ "$#" -eq 1 ] && [ -f "$1" ] || {
    echo "sow-reach: one existing manifest is required" >&2; exit 2;
  }
  manifest_hash=$(git hash-object -- "$1") || exit 2
  allowed=$(awk '$1 == "allow" { print $2 }' "$1") || exit 2
  set --
  for path in $allowed; do set -- "$@" "$path"; done
  # An empty allow list has an empty inventory. Calling git with no path arguments
  # would select the entire repository, which answers a different question.
  inventory=""
  if [ "$#" -gt 0 ]; then
    inventory=$(git -c core.quotePath=true ls-files -- "$@") || exit 2
  fi
  inventory_hash=$(printf '%s\n' "$inventory" | git hash-object --stdin) || exit 2
  printf 'reach_manifest %s\nreach_paths %s\n' "$manifest_hash" "$inventory_hash"
)
