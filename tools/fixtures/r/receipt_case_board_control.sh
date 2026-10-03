#!/bin/sh
# tools/fixtures/r/receipt_case_board_control.sh -- the case board from both sides.
#
#   sh tools/fixtures/r/receipt_case_board_control.sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"
scan="sh tools/fixtures/r/receipt_case_board_scan.sh"
ok=0
bad=0
pen=".lap/receipt-case-board"
mkdir -p "$pen"

report() {
  if [ "$2" = ok ]; then
    echo "leg_ok: $1"
    ok=$((ok + 1))
  else
    echo "leg_bad: $1 -- $3"
    bad=$((bad + 1))
  fi
}

out=$(BOARD_BIN= $scan 2>&1) || true
case "$out" in
  *verdict=unstamped*) report live ok ;;
  *) report live red "$out" ;;
esac
case "$out" in
  *milestone=unstamped*) report live_unstamped ok ;;
  *) report live_unstamped red "$out" ;;
esac
case "$out" in
  *case4=source_order*) report live_case4 ok ;;
  *) report live_case4 red "$out" ;;
esac
case "$out" in
  *case8=green*) report live_case8 ok ;;
  *) report live_case8 red "$out" ;;
esac

for name in snapshot still refusal build third; do
  cat > "$pen/$name" <<EOF
#!/bin/sh
echo "GREEN: stub $name"
EOF
done
# The scan matches these exact sentences. The green stubs below replace the
# short lines just written.
cat > "$pen/snapshot" <<'EOF'
#!/bin/sh
echo "GREEN: receipt-snapshot runner"
EOF
cat > "$pen/still" <<'EOF'
#!/bin/sh
echo "GREEN: receipt-still-order"
EOF
cat > "$pen/refusal" <<'EOF'
#!/bin/sh
echo "GREEN: receipt-refusal-chain runner"
EOF
cat > "$pen/braid" <<'EOF'
#!/bin/sh
echo "stub braid refused" >&2
exit 1
EOF
cat > "$pen/build" <<'EOF'
#!/bin/sh
echo "GREEN: braid-build"
EOF
cat > "$pen/third" <<'EOF'
#!/bin/sh
echo "GREEN: third-import"
EOF
chmod 755 "$pen/snapshot" "$pen/still" "$pen/refusal" "$pen/braid" "$pen/build" "$pen/third"

out=$(BOARD_BIN="$root/$pen" $scan 2>&1) || true
case "$out" in
  *verdict=short*) report braid_short ok ;;
  *) report braid_short red "$out" ;;
esac
case "$out" in
  *case8=red*) report braid_case8 ok ;;
  *) report braid_case8 red "$out" ;;
esac
case "$out" in
  *milestone=unstamped*) report braid_unstamped ok ;;
  *) report braid_unstamped red "$out" ;;
esac

cat > "$pen/braid" <<'EOF'
#!/bin/sh
echo "GREEN: product-braid"
EOF
chmod 755 "$pen/braid"
out=$(BOARD_BIN="$root/$pen" $scan 2>&1) || true
case "$out" in
  *verdict=unstamped*) report stubs_unstamped ok ;;
  *) report stubs_unstamped red "$out" ;;
esac
case "$out" in
  *milestone=unstamped*) report stubs_milestone ok ;;
  *) report stubs_milestone red "$out" ;;
esac

rm -f "$pen/snapshot" "$pen/still" "$pen/refusal" "$pen/braid" "$pen/build" "$pen/third"
rmdir "$pen" 2>/dev/null || true
echo "control_legs=9"
echo "control_failed=$bad"
if [ "$bad" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
  exit 1
fi
