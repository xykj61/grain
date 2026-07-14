#!/bin/sh
# Source-loop crash probe for caravan_subscribe_poll_source_crash.rish
set -eu
service="$1"
delivery="$2"
sentinel="$3"
log="$4"
rm -f "$sentinel" "$log"
"$service" "$delivery" "$sentinel" >"$log" 2>&1 &
super=$!
src=""
attempt=0
while test "$attempt" -lt 10; do
  src=$(pgrep -P "$super" -f 'source-loop' 2>/dev/null | head -1 || true)
  test -n "$src" && break
  attempt=$((attempt + 1))
  sleep 0.15
done
test -n "$src"
kill -KILL "$src"
i=0
while kill -0 "$super" 2>/dev/null; do
  i=$((i + 1))
  test "$i" -gt 40 && exit 2
  sleep 0.25
done
super_exit=0
wait "$super" || super_exit=$?
echo "exit:${super_exit}"
cat "$log"
