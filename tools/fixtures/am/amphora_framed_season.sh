#!/bin/sh
# tools/fixtures/am/amphora_framed_season.sh -- build the crafted season
# `tools/am/amphora_framed_name_witness.rish` plants, in one place a shell owns.
#
# Two ordinary files. One is named `a.txt`. The other's NAME carries two newlines and, after
# each, a complete record of its own -- a manifest line and a cargo line for a file the season
# does not hold, at a digest it never produced. A pour that writes that name writes THREE
# records where it read one file.
#
# It lives here rather than inside the witness because the name needs shell quoting and a
# Rishi string passes a backslash through to `sh` as written: `\"` inside a witness reaches the
# shell as an escaped quote and lands two literal quote characters in the filename, which is the
# awk-string fault booked `20260910.031353` wearing a different hat. A fixture takes one argument
# and quotes what it likes.
#
#   sh tools/fixtures/am/amphora_framed_season.sh <season-dir>

set -e

dir="$1"
if [ -z "$dir" ]; then
  echo "amphora_framed_season: name a season directory" >&2
  exit 2
fi

mkdir -p "$dir"
printf 'honest\n' > "$dir/a.txt"

# A well-formed lower-hex digest of the contract's own width, for a body that does not exist.
digest=abababababababababababababababababababababababababababababababab

name=$(printf 'b.txt\nmanifest plain-bytes %s evil.txt\ncargo plain-bytes %s evil.txt' "$digest" "$digest")
printf 'forged\n' > "$dir/$name"

# Two files, stated by the fixture that made them, so the witness reads a number rather than
# trusting this comment.
printf 'season_files=2 crafted_name_bytes=%s\n' "$(printf '%s' "$name" | wc -c | tr -d ' ')"
