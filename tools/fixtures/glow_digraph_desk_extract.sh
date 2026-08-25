#!/bin/sh
# Emit digraphs from glow/gen/sample-digraph-table.glow rows='...' cord -- one per line.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
DESK="$ROOT/glow/gen/sample-digraph-table.glow"
line=$(grep -E "^rows='" "$DESK" | head -1)
# strip rows=' ... trailing '
inner=${line#rows=\'}
inner=${inner%\'}
# space-separated -> one digraph per line
printf '%s\n' $inner
