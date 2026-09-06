#!/usr/bin/env sh
# tools/fixtures/a/amphora_asker_port_scan.sh -- which port did the kernel hand each asker?
#
# WHY IT IS A SCAN RATHER THAN A LINE IN THE WITNESS. Rishi reads `$name` and `${name}` inside a
# string as its own interpolation, so shell arithmetic and command substitution cannot be written
# inline there -- the first draft of this reading tried and refused with UndefinedName. Shell logic
# belongs in a `.sh` the witness runs; the witness reads the verdict words.
#
# WHAT IT MEASURES. `demo` fetches two resins, so it binds an asker socket twice and prints the port
# `getsockname` read back each time. Two prints, two distinct values, neither the retired 38494, is
# what *the kernel chooses the asker's port* looks like as a number.
#
# Run from the repository root; this script takes the port lock itself:
#   sh tools/fixtures/a/amphora_asker_port_scan.sh [delivery-binary]
set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

BIN=${1:-"$ROOT/amphora/bin/vessel-fetch-delivery"}
[ -x "$BIN" ] || { echo "$0: no executable at $BIN" >&2; exit 2; }

# The number this file is allowed to name, because naming it is the point: it is the port the module
# no longer binds, and a scan that cannot say which number retired cannot prove it retired.
retired_port=38494

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

sh "$ROOT/tools/fixtures/a/amphora_vessel_port_lock.sh" "$BIN" demo >"$pen/demo.out" 2>&1
demo_code=$?
sed -n 's/^vfd: asker bound port //p' "$pen/demo.out" > "$pen/ports.txt"

printed=$(wc -l < "$pen/ports.txt" | tr -d ' ')
distinct=$(sort -u "$pen/ports.txt" | wc -l | tr -d ' ')
retired_used=$(grep -c "^${retired_port}\$" "$pen/ports.txt" || true)
green=0
grep -q 'demo GREEN' "$pen/demo.out" && green=1

echo "demo_exit=$demo_code demo_green=$green"
echo "ports: $(tr '\n' ' ' < "$pen/ports.txt")"
echo "printed=$printed distinct=$distinct retired_port_used=$retired_used"
if [ "$demo_code" -eq 0 ] && [ "$green" -eq 1 ] && [ "$printed" -eq 2 ] && [ "$distinct" -eq 2 ] && [ "$retired_used" -eq 0 ]; then
  echo "asker_port=kernel_chosen"
  exit 0
fi
echo "asker_port=not_kernel_chosen"
exit 1
