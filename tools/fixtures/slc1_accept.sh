#!/bin/sh
# SLC-1 acceptance: type, run, version, recall — proven in one session.
set -e
root=$(pwd)
tmpdir=$(mktemp -d)
cd "$tmpdir"
export PATH="$root/rishi/bin:$root/mantra/bin:$PATH"
out=$("$root/rishi/bin/rishi" repl < "$root/tools/fixtures/slc1_accept.input")
# version — the store advanced with a blob:
test -s .mantra/HEAD
test -n "$(ls -A .mantra/blobs 2>/dev/null | head -n1)"
# type + run + recall — ACCEPT-OK printed twice (say, then the recall re-run):
count=$(printf '%s\n' "$out" | grep -c "ACCEPT-OK" || true)
test "$count" -ge 2
echo "GREEN: SLC-1 ACCEPT — type, run, version, recall"
