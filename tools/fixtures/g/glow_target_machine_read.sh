#!/bin/sh
# tools/fixtures/g/glow_target_machine_read.sh -- read an ELF binary's target architecture.
#
# The reader uses the ELF magic, byte-order byte, and e_machine field. It prints one stable token
# and refuses out loud when the file cannot support that reading.

set -u

bin=${1:-}

[ -n "$bin" ] || { echo "glow_target_machine_read: no path given" >&2; exit 2; }
[ -r "$bin" ] || { echo "glow_target_machine_read: cannot read $bin" >&2; exit 2; }

command -v od >/dev/null 2>&1 || {
  echo "glow_target_machine_read: od is absent -- the reader cannot run, so no architecture is claimed" >&2
  exit 3
}

magic=$(od -An -tx1 -j0 -N4 -- "$bin" 2>/dev/null | tr -d ' \n')
[ "$magic" = "7f454c46" ] || {
  echo "glow_target_machine_read: $bin is not ELF (magic ${magic:-empty})" >&2
  exit 4
}

enc=$(od -An -tx1 -j5 -N1 -- "$bin" 2>/dev/null | tr -d ' \n')
pair=$(od -An -tx1 -j18 -N2 -- "$bin" 2>/dev/null | tr -d ' \n')
[ ${#pair} -eq 4 ] || {
  echo "glow_target_machine_read: $bin ends before its e_machine field" >&2
  exit 4
}

lo=$(printf '%s' "$pair" | cut -c1-2)
hi=$(printf '%s' "$pair" | cut -c3-4)

case "$enc" in
  01) machine="$hi$lo" ;;
  02) machine="$lo$hi" ;;
  *)
    echo "glow_target_machine_read: $bin declares no byte order (EI_DATA ${enc:-empty})" >&2
    exit 4
    ;;
esac

case "$machine" in
  00b7) echo aarch64 ;;
  00f3) echo riscv64 ;;
  003e) echo x86_64 ;;
  *)    echo "machine-0x$machine" ;;
esac
