#!/usr/bin/env sh
# wire_lab_fn_drift_control.sh -- prove the fn-drift scan from both sides in a pen.
#
# Builds a pen holding copies of the real 15 orchestrators, then proves each refusal by
# planting it and by removing it, since a refusal proven only in the passing direction
# cannot be told from a bypass: a drifted fn line bites and frees; a raw qemu line outside
# the fns bites and frees; a lab missing its fn block bites and frees; a missing head and a
# head stripped of its fns each read unreadable rather than green.
set -eu

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

SCAN="$ROOT/tools/fixtures/w/wire_lab_fn_drift_scan.sh"
pen_root=$(mktemp -d)
trap 'rm -rf "$pen_root"' EXIT INT TERM
pass=0
fail=0

new_pen() {
  _p="$pen_root/$1"
  mkdir -p "$_p/tools/co" "$_p/rishi/bin" "$_p/tools/fixtures"
  cp "$ROOT"/tools/co/comlink_*_wire_lab.rish "$_p/tools/co/"
  printf '%s' "$_p"
}

expect() {
  _name=$1; _code=$2; _text=$3; _pen=$4
  set +e
  _out=$(sh "$SCAN" --root "$_pen" 2>&1)
  _got=$?
  set -e
  if [ "$_got" -eq "$_code" ] && printf '%s' "$_out" | grep -q -- "$_text"; then
    echo "ok: $_name"
    pass=$((pass + 1))
  else
    echo "no: $_name -- want exit $_code with '$_text', got exit $_got"
    printf '%s\n' "$_out" | sed 's/^/    /'
    fail=$((fail + 1))
  fi
}

# ---- the live copies, unplanted ----------------------------------------------------------------
p=$(new_pen live)
expect live_green 0 "verdict=green" "$p"
expect live_no_drift 0 "fn_drift=0" "$p"
expect live_no_raw 0 "raw_sites=0" "$p"

# ---- one lab's fn line drifts ------------------------------------------------------------------
p=$(new_pen drift)
sed 's/^fn qemu_tx cable elf: \["timeout" "30"/fn qemu_tx cable elf: ["timeout" "31"/' \
  "$p/tools/co/comlink_receipt_wire_lab.rish" > "$p/t" && cat "$p/t" > "$p/tools/co/comlink_receipt_wire_lab.rish" && rm -f "$p/t"
expect drift_bites 1 "verdict=fn_drift" "$p"
cp "$ROOT/tools/co/comlink_receipt_wire_lab.rish" "$p/tools/co/"
expect drift_freed 0 "verdict=green" "$p"

# ---- a raw template line returns outside the fns -----------------------------------------------
p=$(new_pen raw)
printf '%s\n' 'let stray = run ["timeout" "30" "qemu-system-riscv64" "-machine" "virt"]' \
  >> "$p/tools/co/comlink_murr_wire_lab.rish"
expect raw_bites 1 "verdict=raw_sites" "$p"
cp "$ROOT/tools/co/comlink_murr_wire_lab.rish" "$p/tools/co/"
expect raw_freed 0 "verdict=green" "$p"

# ---- a lab missing its fn block entirely -------------------------------------------------------
p=$(new_pen fnless)
grep -v '^fn ' "$p/tools/co/comlink_recall_sync_wire_lab.rish" > "$p/t" \
  && cat "$p/t" > "$p/tools/co/comlink_recall_sync_wire_lab.rish" && rm -f "$p/t"
expect fnless_bites 1 "verdict=fn_drift" "$p"
cp "$ROOT/tools/co/comlink_recall_sync_wire_lab.rish" "$p/tools/co/"
expect fnless_freed 0 "verdict=green" "$p"

# ---- the head absent, and the head stripped of its fns -----------------------------------------
p=$(new_pen headless)
rm -f "$p/tools/co/comlink_device_wire_lab.rish"
expect headless_unreadable 1 "verdict=unreadable" "$p"
cp "$ROOT/tools/co/comlink_device_wire_lab.rish" "$p/tools/co/"
expect headless_freed 0 "verdict=green" "$p"
grep -v '^fn ' "$p/tools/co/comlink_device_wire_lab.rish" > "$p/t" \
  && cat "$p/t" > "$p/tools/co/comlink_device_wire_lab.rish" && rm -f "$p/t"
expect headfnless_unreadable 1 "verdict=unreadable" "$p"

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
  exit 1
fi
