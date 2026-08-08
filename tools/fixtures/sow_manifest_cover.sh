#!/bin/sh
# sow_manifest_cover.sh — M1: the manifest classifies every tracked root path,
# exactly once, and names no path the tree does not have.
# Prints M1_OK when the tree's root set equals the manifest's verdict set.
set -eu
A=$(git ls-files | sed -E 's#/.*##' | sort -u)
B=$(grep -E '^(template|scrub|personal) ' template-manifest.bron | awk '{print $2}' | sort -u)
if [ "$A" = "$B" ]; then
  echo M1_OK
else
  echo M1_BAD
  echo "--- in tree, not in manifest ---"
  printf '%s\n' "$A" | while IFS= read -r x; do printf '%s\n' "$B" | grep -qxF "$x" || echo "$x"; done
  echo "--- in manifest, not in tree ---"
  printf '%s\n' "$B" | while IFS= read -r x; do printf '%s\n' "$A" | grep -qxF "$x" || echo "$x"; done
fi
