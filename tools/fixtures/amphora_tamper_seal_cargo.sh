#!/bin/sh
# Flip one nibble in the seal_cargo field of an Amphora vessel file.
# POSIX seam fixture — replaces the elder .py the tools scan refused.
# Usage: sh tools/fixtures/amphora_tamper_seal_cargo.sh <vessel>
set -e
f="$1"
[ -n "$f" ] && [ -f "$f" ]
awk '{
  if ($0 ~ /^seal_cargo ./) {
    head = "seal_cargo "
    body = substr($0, length(head) + 1)
    first = substr(body, 1, 1)
    flip = (first != "a") ? "a" : "b"
    print head flip substr(body, 2)
  } else {
    print
  }
}' "$f" > "$f.tamper" && mv "$f.tamper" "$f"
