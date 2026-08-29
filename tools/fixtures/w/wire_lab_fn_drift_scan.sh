#!/usr/bin/env sh
# wire_lab_fn_drift_scan.sh -- the wire-lab fn macro stays one macro.
#
# WHAT THIS READS. The 15 tools/co/comlink_*_wire_lab.rish orchestrators each name the guest
# build command and the two QEMU argv shapes exactly once, as three fn lines (build_guest,
# qemu_rx, qemu_tx), hoisted 20260829 from 135 repeated template sites with a byte-gated
# transformer and proven by two real qemu boots. Rishi has no cross-file include, so the fn
# lines are 15 deliberate copies of one body -- and 15 copies of one body are 15 files that
# may quietly come to disagree, which is the disease the hoist cured and this scan keeps cured.
#
# THE REFERENCE IS THE TEACHING HEAD, NOT A RECITED TEMPLATE. comlink_device_wire_lab.rish
# carries the family's full account and its fn lines are the reference the other labs are
# compared against. A deliberate family-wide edit (all 15 moved together, eyes on the head)
# passes; one file wandering reds. A template recited here would be a 16th copy -- the scan
# measures sameness rather than adding to it.
#
# THE READINGS
#   labs           comlink_*_wire_lab.rish files found                          reported
#   fn_drift       labs whose three fn lines differ from the head's, or are     ZERO, ENFORCED
#                  missing -- the macro re-braiding
#   raw_sites      qemu-system-riscv64 or rye/bin/rye build appearing outside   ZERO, ENFORCED
#                  a fn definition line -- the repeated template returning
#
# A missing head, or a head missing its own fn lines, reads verdict=unreadable rather than
# green off nothing -- a scan that reports zero because it found nothing is the failure this
# family of guards exists to refuse.
#
#   sh tools/fixtures/w/wire_lab_fn_drift_scan.sh [--root DIR]
set -eu

ROOT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    *) echo "wire_lab_fn_drift_scan: unknown argument: $1" >&2; exit 2 ;;
  esac
done
if [ -z "$ROOT" ]; then
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
fi

cd "$ROOT" || { echo "detail: cannot enter $ROOT"; echo "verdict=unreadable"; exit 1; }

HEAD_LAB="tools/co/comlink_device_wire_lab.rish"

echo "wire_lab_fn_drift_scan v1"
echo "head=$HEAD_LAB"

# invariant: the head is the subject every other lab is read against, so its absence -- or a
# head carrying no fn lines -- is unreadable rather than green.
if [ ! -f "$HEAD_LAB" ]; then
  echo "detail: the teaching head is absent, so no lab can be read against it"
  echo "verdict=unreadable"
  exit 1
fi

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

grep -E '^fn (build_guest|qemu_rx|qemu_tx) ' "$HEAD_LAB" | sort > "$pen/head_fns"
head_fn_count=$(grep -c . "$pen/head_fns" || true)
if [ "$head_fn_count" -ne 3 ]; then
  echo "detail: the head carries $head_fn_count of the three fn lines"
  echo "verdict=unreadable"
  exit 1
fi

labs=0
fn_drift=0
raw_sites=0
for f in tools/co/comlink_*_wire_lab.rish; do
  [ -f "$f" ] || continue
  labs=$((labs + 1))

  grep -E '^fn (build_guest|qemu_rx|qemu_tx) ' "$f" | sort > "$pen/this_fns"
  if ! cmp -s "$pen/head_fns" "$pen/this_fns"; then
    fn_drift=$((fn_drift + 1))
    echo "detail: $f fn lines differ from the head's, or are missing"
  fi

  # raw sites: the long templates outside a fn definition line. Full-line comments are
  # stripped so a header MENTIONING qemu stays a header.
  raw=$(sed 's/^[[:space:]]*#.*$//' "$f" | grep -Ev '^fn ' | grep -cE 'qemu-system-riscv64|rye/bin/rye build' || true)
  if [ "$raw" -gt 0 ]; then
    raw_sites=$((raw_sites + raw))
    echo "detail: $f carries $raw raw template line(s) outside the fns"
  fi
done

echo "labs=$labs"
echo "fn_drift=$fn_drift"
echo "raw_sites=$raw_sites"

if [ "$fn_drift" -ne 0 ]; then
  echo "verdict=fn_drift"
  exit 1
fi
if [ "$raw_sites" -ne 0 ]; then
  echo "verdict=raw_sites"
  exit 1
fi
echo "verdict=green"
