#!/bin/sh
# Emit match_rune2 digraphs from glow/tokens.rye -- one two-byte head per line, order preserved.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
awk '/const pairs =/,/};/' "$ROOT/glow/tokens.rye" \
  | grep -oE '"[^"]{2}"' \
  | tr -d '"'
