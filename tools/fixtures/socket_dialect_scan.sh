#!/bin/sh
# tools/fixtures/socket_dialect_scan.sh -- the socket-dialect meter over authored Rye.
#
# WHAT THIS IS FOR. A module that reaches a kernel through sockets spells three kinds of number:
# the address family, the socket type, and the socket options. Two of those read the same on every
# kernel this tree runs on. The third does not, and this meter counts the places where the third is
# spelled by hand instead of asked of the host.
#
# WHY IT EXISTS. REDS %282 found `caravan/harvest.rye` reading a child's exit status through
# `std.os.linux.waitpid`, a raw Linux syscall that answers a constant 9 on a BSD kernel, and moved
# seven call sites onto `std.c`, whose namespaces already switch on `native_os`. The same round
# found `mantra/recall_subscribe_poll_delivery.rye` hand-rolling `sockaddr_in` in the Linux layout
# and moved that ONE module to `std.c.sockaddr.in`. Its `BindFailed` at rebind stayed open, and the
# root sits one layer under the struct: the module still spelled its socket OPTION numbers in
# Linux's dialect. Read from the vendored toolchain's own tables on `20260827`:
#
#   name              std.c on Linux x86_64   std.c on macOS (BSD)
#   SOL_SOCKET        1                       0xffff
#   SO_REUSEADDR      2                       0x0004
#   SO_RCVTIMEO       20                      0x1006
#   SO_BROADCAST      6                       0x0020
#   SO_BINDTODEVICE   25                      absent
#
# On a BSD kernel `setsockopt(fd, 1, 2, ...)` names no level that exists, so the call fails, its
# return is discarded with `_ =`, and SO_REUSEADDR is never set -- which is exactly a rebind that
# refuses. The receive timeout never arrives either, so a recv meant to time out waits instead.
# Both faults are silent: the wrong number is a plausible number, and a discarded return says
# nothing at all.
#
# WHAT IT MEASURES. Two readings held under ceilings that only fall, and one number reported so the
# direction of travel stays visible.
#
#   option_files / option_lines   a socket OPTION constant bound to a numeric literal. This is the
#                                 fault named above: the number is written here rather than
#                                 dispatched by the host, so one pier's value stands on both.
#   linux_layout_files            a hand-rolled `sockaddr_in` carrying `sin_family: c_ushort`,
#                                 which is the Linux layout. BSD opens the same structure with a
#                                 one-byte `sin_len` ahead of a one-byte family.
#   dispatched_files              files reaching `std.c.sockaddr.in`. Reported, never gated,
#                                 because this is the number meant to rise.
#
# WHAT IT LEAVES ALONE, AND WHY. `AF_INET` and `SOCK_DGRAM` are both 2 on every host in the
# vendored table, so a literal there is portable today and counting it would flag a non-fault. A
# meter that instructs a repair nobody needs is a meter somebody turns off.
#
# WHAT IS NOT PROVEN. That a dispatched constant is the RIGHT constant, and that any of these
# modules is exercised on a BSD pier at all. This proves the number is asked of the host rather
# than remembered by the file, and stops there.
#
# USAGE
#   sh tools/fixtures/socket_dialect_scan.sh [--root <dir>]
#
# Driven by tools/s/socket_dialect_witness.rish. Run from the repository root. Written in POSIX
# shell, through `shell_portable.sh`, because a portability meter that runs on one pier proves
# nothing about the other (REDS %240, %249, %250).

set -u

here=$(CDPATH= cd "$(dirname "$0")" && pwd)
. "$here/shell_portable.sh"

root=.
if [ $# -ge 2 ] && [ "$1" = "--root" ]; then root=$2; fi
cd "$root" || { echo "verdict=not_at_root" >&2; exit 1; }

# The ceilings only ever fall. The option pair opened at 19 files and 43 lines on `20260827`, the
# honest first reading of a class nobody had counted; the sweep that followed the same day carried
# both to ZERO, so the ceiling is now a wall -- one hand-spelled option constant anywhere in the
# authored corpus refuses. The layout ceiling keeps its opening reading, because that leg is
# unrepaired: 19 modules still hand-roll `sockaddr_in` in the Linux layout.
option_files_ceiling=0
option_lines_ceiling=0
linux_layout_files_ceiling=19

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The two readings, each in one place, so no caller can spell one of them differently.
#
# A socket OPTION constant bound to a numeric literal. `SOL_` and `SO_` are named explicitly rather
# than by a looser prefix, because `SOCK_DGRAM` also begins with SO and is portable-identical.
option_pattern='^const (SOL_|SO_)[A-Z_]+: *c_[a-z]+ *= *[0-9]'
# A hand-rolled `sockaddr_in` in the Linux layout: a two-byte family and no length byte.
layout_pattern='sin_family: *c_ushort'
# The dispatched shape, which is what a repaired module reads like.
dispatched_pattern='c\.sockaddr\.in'

# The authored corpus, drawn on the same line the width meter draws: vendor and gratitude are other
# people's code, aurora is freestanding, and dated testimony keeps every word it ever wrote.
git ls-files '*.rye' 2>/dev/null \
  | grep -vE '^(vendor/|aurora/|gratitude/)' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' > "$work/corpus.txt"
corpus_files=$(wc -l < "$work/corpus.txt" | tr -d ' ')

xargs_lines "$work/corpus.txt" grep -lE "$option_pattern" 2>/dev/null | sort -u > "$work/option_files.txt"
option_files=$(wc -l < "$work/option_files.txt" | tr -d ' ')

option_lines=0
: > "$work/option_detail.txt"
while read -r p; do
  [ -n "$p" ] || continue
  n=$(grep -cE "$option_pattern" "$p" 2>/dev/null || printf '0')
  option_lines=$((option_lines + n))
  printf '%s\t%s\n' "$n" "$p" >> "$work/option_detail.txt"
done < "$work/option_files.txt"

xargs_lines "$work/corpus.txt" grep -lE "$layout_pattern" 2>/dev/null | sort -u > "$work/layout_files.txt"
linux_layout_files=$(wc -l < "$work/layout_files.txt" | tr -d ' ')

xargs_lines "$work/corpus.txt" grep -lE "$dispatched_pattern" 2>/dev/null | sort -u > "$work/dispatched.txt"
dispatched_files=$(wc -l < "$work/dispatched.txt" | tr -d ' ')

echo "corpus_files=$corpus_files"
echo "option_files=$option_files"
echo "option_files_ceiling=$option_files_ceiling"
echo "option_lines=$option_lines"
echo "option_lines_ceiling=$option_lines_ceiling"
echo "linux_layout_files=$linux_layout_files"
echo "linux_layout_files_ceiling=$linux_layout_files_ceiling"
echo "dispatched_files=$dispatched_files"

# A refusal names the files it read, because a count nobody can walk back to a path repairs nothing.
[ "$option_files" -le "$option_files_ceiling" ] && [ "$option_lines" -le "$option_lines_ceiling" ] \
  || sort -rn "$work/option_detail.txt" | head -10 | sed 's/^/option_top: /'
[ "$linux_layout_files" -le "$linux_layout_files_ceiling" ] \
  || sed 's/^/layout_file: /' "$work/layout_files.txt"

if [ "$option_files" -le "$option_files_ceiling" ] \
  && [ "$option_lines" -le "$option_lines_ceiling" ] \
  && [ "$linux_layout_files" -le "$linux_layout_files_ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=socket_dialect_drift"
echo "refused: a socket number is spelled here that the host should have been asked for -- read the lines above" >&2
exit 1
