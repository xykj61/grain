#!/usr/bin/env sh
# tools/fixtures/a/amphora_asker_reply.sh -- does a source answer the asker, or a number?
#
# WHAT THIS ASKS, AND WHY IT TAKES TWO BINARIES. Before 20260906 the fetch source sent every answer
# to a port compiled into its own file, and the asker bound that same number. The pair agreed with
# itself, so nothing it did alone could tell *answers the asker* from *answers 38494*. Crossing the
# two builds is what separates them: hand an elder source an asker that binds a port the kernel
# chose, and the elder answers the number while the asker listens somewhere else. The repaired
# source reads the asker's address off the request and answers whoever actually asked.
#
# WHAT WAS TRIED FIRST AND MEASURED EQUAL. Two askers at once against one source was the obvious
# control and it is not one: both binaries passed it in half a second, because two short exchanges
# stagger by milliseconds and never overlap. A test both bytes pass discriminates nothing, and
# saying so is cheaper than a guard that reads green for the wrong reason.
#
# THE BUNDLE CARRIES ONE RESIN. `source` serves exactly two requests, so a one-cargo bundle keeps a
# single asker's single request well inside what the source will answer.
#
# USAGE, from the repository root -- the caller holds the port lock:
#   sh tools/fixtures/a/amphora_asker_reply.sh <source-binary> <fetcher-binary> [askers]
#
# `askers` defaults to 1; pass 2 to run two at once against one source. Prints `asker_reply=<verdict>`
# and exits 0 when every asker was answered, 1 when one was not.
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
. "$ROOT/tools/fixtures/s/shell_portable.sh"

SRC_BIN=${1:?usage: amphora_asker_reply.sh <source-binary> <fetcher-binary> [askers]}
FET_BIN=${2:?usage: amphora_asker_reply.sh <source-binary> <fetcher-binary> [askers]}
askers=${3:-1}
[ -x "$SRC_BIN" ] || { echo "$0: no executable at $SRC_BIN" >&2; exit 2; }
[ -x "$FET_BIN" ] || { echo "$0: no executable at $FET_BIN" >&2; exit 2; }
[ "$askers" = 1 ] || [ "$askers" = 2 ] || { echo "$0: askers is 1 or 2" >&2; exit 2; }

# Named here and checked at the edge: the module refuses on its own after three bounded attempts of
# ten seconds apiece, and that refusal by name is what a crossed pair should produce. Forty seconds
# lets the module's own bound arrive first, so an unanswered reading says *refused* rather than
# *cut off by this script*.
max_asker_seconds=40
if have_tool timeout; then bound="timeout ${max_asker_seconds}"; else bound=""; fi

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

mkdir -p "$pen/tree"
printf 'one resin, so one asker makes one request\n' > "$pen/tree/only.txt"

sh "$ROOT/tools/fixtures/a/amphora_pour.sh" "$pen/tree" "$pen/near" 20260906.113000 >"$pen/pour.out" 2>&1 || {
  echo "asker_reply=pour_failed"; sed -n '$p' "$pen/pour.out"; exit 1; }
# THE COUNT COMES FROM THE POUR, NOT FROM THE VESSEL. A poured vessel seals its cargo lines into
# `seal_cargo`, so grepping the file for `^cargo ` reads zero on a bundle that carries one -- which
# is what the first draft of this fixture did, and it refused a healthy bundle by name.
cargo=$(sed -n 's/.* cargo=\([0-9][0-9]*\).*/\1/p' "$pen/pour.out" | tail -n 1)
[ "${cargo:-0}" -eq 1 ] || { echo "asker_reply=bundle_not_one_cargo cargo=${cargo:-none}"; exit 1; }

i=1
while [ "$i" -le "$askers" ]; do
  mkdir -p "$pen/far_$i/resins"
  cp "$pen/near/vessel.bron" "$pen/near/manifest.bron" "$pen/far_$i/"
  i=$((i + 1))
done

$bound "$SRC_BIN" source "$pen/near" >"$pen/source.out" 2>&1 &
src_pid=$!
# The source binds on its own first line; a short settle keeps the first request from racing that
# bind, and an asker re-asks three times regardless, so this is politeness rather than the bound.
sleep 0.1

i=1
pids=""
while [ "$i" -le "$askers" ]; do
  $bound "$FET_BIN" fetcher "$pen/far_$i" >"$pen/asker_$i.out" 2>&1 &
  pids="$pids $!"
  i=$((i + 1))
done

answered=0
i=1
for pid in $pids; do
  wait "$pid"; code=$?
  files=$(ls "$pen/far_$i/resins" 2>/dev/null | wc -l | tr -d ' ')
  echo "asker_${i}_exit=$code resins=$files"
  if [ "$code" -eq 0 ] && [ "$files" -eq 1 ]; then answered=$((answered + 1)); fi
  i=$((i + 1))
done
kill "$src_pid" 2>/dev/null || true
wait "$src_pid" 2>/dev/null || true

echo "askers=$askers answered=$answered"
if [ "$answered" -eq "$askers" ]; then
  echo "asker_reply=every_asker_answered"
  exit 0
fi
echo "asker_reply=an_asker_went_unanswered"
exit 1
