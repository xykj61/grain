#!/bin/sh
# Isolated cwd for :version — creates .mantra in a temp dir, not the repo root.
set -e
root=$(pwd)
tmpdir=$(mktemp -d)
cd "$tmpdir"
export PATH="$root/rishi/bin:$root/mantra/bin:$PATH"
"$root/rishi/bin/rishi" repl < "$root/tools/fixtures/slc1_version_step2.input"
test -s .mantra/HEAD
test -n "$(ls -A .mantra/blobs 2>/dev/null | head -n1)"
echo "GREEN: SLC-1 Step 2"
