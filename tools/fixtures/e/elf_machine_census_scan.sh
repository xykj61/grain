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
#
# AND IT ROSE TO 16 WITHOUT A GUARD BEING WRITTEN (`20260910.035630`). One commit landed
# `tools/fixtures/s/self_matching_assert_control.sh`, whose plants spell the very shape this
# census counts, and the reading went 3 -> 16 in an hour. `elf_machine` refused, and
# `standing_equipment` refused the whole 226-guard roster behind it -- a ceiling meant only to fall
# stopping the fleet over a control doing its job. Two clauses answer it, and each was measured
# alone rather than as a pair, since a census whose denominator has been wrong six times owes that:
#
#   a site is read off a LIVE line       16 -> 7, the nine plants inside heredoc bodies leaving
#   a control is not the tree's practice  7 -> 3, the four inside printf formats and a case argument
#
# Measured the same stamp: outside controls the live-line strand removes NOTHING today -- both
# readings land on the same three sites, so the control clause is what carries this repair and the
# position clause is what will catch the next plant written somewhere a name list cannot see.
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

# A CONTROL'S SITES ARE PLANTS OF THE SHAPE UNDER TEST, NEVER THE TREE'S PRACTICE
# (`20260910.035630`). `tools/fixtures/s/self_matching_assert_control.sh` landed thirteen
# `run ["sh" "-c" "file ..."]` lines in one commit -- nine inside heredoc bodies it writes into a
# pen, four inside `printf` format strings and a case argument -- because the shape it proves a
# guard against IS the REDS %460 shape this census counts. A guard cannot be proven without
# carrying its own subject, so no hand can remove those lines, and a census that counts them reads
# 16 against a ceiling of 3 and refuses the whole standing roster behind it.
#
# `tools/c/convergence_census.sh` skips controls by the same name for the sibling reason -- a
# control writes into its own pen and has nothing to converge -- so the convention is one this tree
# already leans on.
#
# AND THE EXCLUSION IS COUNTED AND PRINTED (`20260910.050000`), because this is a whole POPULATION
# held out rather than one named path, and `tools/fixtures/p/process_reach_scan.sh` already states
# the law over its own single exclusion: an exclusion nobody can see is a claim rather than a
# measurement. That guard's head also refuses a `*control*` PATTERN by name, on the ground that it
# blinds a guard inside every control in the tree -- which is the cost this scan accepts, so it
# prints what it costs on every run: `control_excluded`, `control_files`, `control_sites`.
#
# Why a figure in prose could not have carried it. This head read *exactly one of them carries a
# site* when the exclusion landed, and the same commit's other half added nine legs to
# `tools/fixtures/e/elf_machine_control.sh` -- four of them at live positions -- so the figure was
# two before the commit finished. Nothing held it still. RUN the scan: `control_excluded=244
# control_files=2 control_sites=8` at `20260910.050000`, and the reading moves when a control does.
#
# REPORTED, never gated. `ll_live` answers per LINE -- whether the line BEGAN inside a quoted
# region -- so a plant written as a single-quoted argument on one line reads live, and all eight of
# today's sites are exactly that: `cplant ... '...'`, `printf '...'`, `case_read ... '...'`. A gate
# here would red on honest fixtures, which is the shape of gate somebody turns off.
git ls-files '*.rish' '*.sh' 'tools/hooks/*' | sort -u > "$pen/all_sources"
grep -vE '_control\.(sh|rish)$' "$pen/all_sources" > "$pen/sources"
grep -E '_control\.(sh|rish)$' "$pen/all_sources" > "$pen/controls" || true

# ONE AWK PASS over every source rather than a sed and a grep per file. The elder per-file loop
# spawned two processes for each of ~2,900 tracked runners and cost 17 of this guard's 18 seconds;
# one pass costs under a second, which is what buys it a lap tier rather than a cadence one.
#
# AND A SITE IS READ OFF A LIVE LINE (`20260910.035630`). This pass read every line, and a line
# carries no position, so the thirteen `run ["sh" "-c" "file ..."]` lines standing inside the
# heredoc PLANTS of `tools/fixtures/s/self_matching_assert_control.sh` counted as thirteen live
# sites -- a census standing at 3 of a ceiling of 3 read 16 the hour that control landed, and
# `standing_equipment` refused the whole roster behind it. A plant is a Rishi program the control
# writes into its own pen and hands to the guard under test; it is the control's SUBJECT rather
# than the tree's practice, and no hand can remove it without removing the proof.
#
# `tools/fixtures/l/live_lines.sh` walks a source as a shell lexer and answers whether a line began
# outside every quoted region. It was written for `tools/c/convergence_census.sh`, where the same
# fault ran the other way -- a WRITE inside a `--tree-filter` string admitting a tool that writes
# nothing -- and it is a library rather than a habit because this is its second room.
#
# The one honest limit rides along: Rishi is not shell, so a `.rish` source whose quoting differs
# desyncs the walk to the file's end. That can only WITHHOLD lines, so this census loses a site
# rather than inventing one, and the ceiling it guards only falls.
. "$_fd_root/tools/fixtures/l/live_lines.sh"

{ live_lines_awk; cat <<'AWK'
FNR == 1 { ll_reset() }
{
  if (!ll_live($0)) next                    # text handed to another interpreter is not a call
  line = $0
  sub(/#.*/, "", line)                      # a sentence naming the utility is not a call
  if (line ~ /(^|[;&|(]|"-c" ")[ \t]*file[ \t]+[^=|)]/) count[FILENAME]++
}
END { for (f in count) printf "%d\t%s\n", count[f], f }
AWK
} > "$pen/census.awk"

: > "$pen/hits"
xargs_lines_batched 400 "$pen/sources" awk -f "$pen/census.awk" >> "$pen/hits"

sites=$(awk -F'\t' '{ n += $1 } END { print n + 0 }' "$pen/hits")
files=$(grep -c '' "$pen/hits" || true)

# THE EXCLUSION IS COUNTED AND PRINTED, because an exclusion nobody can see is a claim rather than
# a measurement -- `tools/fixtures/p/process_reach_scan.sh` states that law over its own exclusion
# one room over, and it is owed here twice over, since this exclusion covers the whole `_control.`
# population rather than one named path.
#
# Read through the SAME lexer, so this counts what a control does at a live position rather than
# what it plants. It is REPORTED and never gated: `ll_live` answers per LINE -- whether the line
# BEGAN inside a quoted region -- so a plant written as a single-quoted argument on one line reads
# live and lands here honestly. All of today's do.
: > "$pen/control_hits"
if [ -s "$pen/controls" ]; then
  xargs_lines_batched 400 "$pen/controls" awk -f "$pen/census.awk" >> "$pen/control_hits"
fi
control_sites=$(awk -F'\t' '{ n += $1 } END { print n + 0 }' "$pen/control_hits")
control_files=$(grep -c '' "$pen/control_hits" || true)
control_excluded=$(grep -c '' "$pen/controls" || true)

if [ "$mode" = --list ]; then
  sort -rn "$pen/hits" | while IFS="$(printf '\t')" read -r n f; do
    echo "site count=$n path=$f"
  done
  sort -rn "$pen/control_hits" | while IFS="$(printf '\t')" read -r n f; do
    echo "control site count=$n path=$f"
  done
fi

echo "sites=$sites files=$files ceiling=$ceiling"
echo "control_excluded=$control_excluded control_files=$control_files control_sites=$control_sites"

if [ "$sites" -gt "$ceiling" ]; then
  echo "detail: a guard proves an architecture by reading file's prose; read the ELF header instead -- tools/fixtures/e/elf_machine_scan.sh"
  echo "verdict=over_ceiling"
  exit 1
fi
echo "verdict=under_ceiling"
