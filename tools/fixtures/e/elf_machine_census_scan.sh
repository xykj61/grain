#!/bin/sh
# tools/fixtures/e/elf_machine_census_scan.sh -- which guards still prove an architecture by
# reading `file`'s prose?
#
#   sh tools/fixtures/e/elf_machine_census_scan.sh [--list]
#
# WHY THIS EXISTS. The sibling reader in this room answers a binary's architecture from its own
# ELF header. This counts the sites that still ask `file(1)` instead -- a borrowed utility absent
# on this pier, where the substring assert that followed it fired as a claim about the binary.
#
# WHAT COUNTS AS A SITE. A `file` call in COMMAND position inside a tracked `.rish`, `.sh`, or
# hook: at the start of a line, after `;`, `&`, `|`, or `(`, or opening a `run ["sh" "-c" "..."]`
# body. Comments are stripped before counting, so a sentence naming the utility is never counted
# as a call -- this file's own head would otherwise count itself.
#
# THE CEILING ONLY FALLS. Measured 20260906: 13 sites in 5 files. Ten of them stood in Glow's two
# cross-target witnesses and were replaced by the header reader in the same round, leaving 3 --
# two Android builds under tools/h/ and one APK pack under tools/t/. Those three are left rather
# than swept because neither toolchain runs on this pier, and editing a guard you cannot run is
# the fault this whole room exists to close. They fall on touch, from a bench that holds the NDK.
#
# PROVEN BOTH WAYS ON REAL STATE, 20260906. Before the repair this scan read `sites=13 files=5`
# and answered `verdict=over_ceiling`, exit 1. After it, `sites=3 files=3`, `verdict=under_ceiling`,
# exit 0. A refusal proven only in the passing direction cannot be told from a bypass, so the
# refusing direction is the one recorded here.
set -eu

# The depth-proof root walk every fixtures guard carries: climb to the first ancestor holding the
# root's own furniture, bounded at eight steps, so a future fold of this room cannot silently
# repoint it (REDS %301's last room).
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
cd "$_fd_root"
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

ceiling=3
mode=${1:-}

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

git ls-files '*.rish' '*.sh' 'tools/hooks/*' | sort -u > "$pen/sources"

# ONE AWK PASS over every source rather than a sed and a grep per file. The elder per-file loop
# spawned two processes for each of ~2,900 tracked runners and cost 17 of this guard's 18 seconds;
# one pass costs under a second, which is what buys it a lap tier rather than a cadence one.
cat > "$pen/census.awk" <<'AWK'
{
  line = $0
  sub(/#.*/, "", line)                      # a sentence naming the utility is not a call
  if (line ~ /(^|[;&|(]|"-c" ")[ \t]*file[ \t]+[^=|)]/) count[FILENAME]++
}
END { for (f in count) printf "%d\t%s\n", count[f], f }
AWK

: > "$pen/hits"
xargs_lines_batched 400 "$pen/sources" awk -f "$pen/census.awk" >> "$pen/hits"

sites=$(awk -F'\t' '{ n += $1 } END { print n + 0 }' "$pen/hits")
files=$(grep -c '' "$pen/hits" || true)

if [ "$mode" = --list ]; then
  sort -rn "$pen/hits" | while IFS="$(printf '\t')" read -r n f; do
    echo "site count=$n path=$f"
  done
fi

echo "sites=$sites files=$files ceiling=$ceiling"

if [ "$sites" -gt "$ceiling" ]; then
  echo "detail: a guard proves an architecture by reading file's prose; read the ELF header instead -- tools/fixtures/e/elf_machine_scan.sh"
  echo "verdict=over_ceiling"
  exit 1
fi
echo "verdict=under_ceiling"
