#!/bin/sh
# While old/doc/spec/flw.txt remains in-tree, assert the fixture body after
# "# body unmodified below" is a byte-identical twin. Skip when elder is gone.
set -eu
fixture="${1:?fixture path required}"
elder="old/doc/spec/flw.txt"
if [ ! -f "$elder" ]; then
  echo "SKIP elder absent"
  exit 0
fi
awk '/^# body unmodified below$/{p=1;next} p' "$fixture" | cmp -s - "$elder"
echo "OK body twin"
