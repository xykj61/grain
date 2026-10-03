#!/bin/sh
# tools/fixtures/r/receipt_third_import_control.sh -- the third-import scan from both sides.
#
#   sh tools/fixtures/r/receipt_third_import_control.sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"
scan="sh tools/fixtures/r/receipt_third_import_scan.sh"
ok=0
bad=0
pen=".lap/receipt-third-import"
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

out=$($scan 2>&1) || true
case "$out" in
  *verdict=clear*) report live ok ;;
  *) report live red "$out" ;;
esac

cat > "$pen/both.rye" <<'EOF'
const a = @import("linengrow/receipt_offer.rye");
const b = @import("dimeroll/receipt_offer.rye");
pub fn main() void {}
EOF
out=$($scan --plant "$pen/both.rye" 2>&1) || true
case "$out" in
  *verdict=braid*) report both_imports ok ;;
  *) report both_imports red "$out" ;;
esac

cat > "$pen/one.rye" <<'EOF'
const a = @import("linengrow/receipt_offer.rye");
pub fn main() void {}
EOF
out=$($scan --plant "$pen/one.rye" 2>&1) || true
case "$out" in
  *verdict=clear*) report one_import ok ;;
  *) report one_import red "$out" ;;
esac

cat > "$pen/comment.rye" <<'EOF'
// @import("linengrow/receipt_offer.rye")
// @import("dimeroll/receipt_offer.rye")
pub fn main() void {}
EOF
out=$($scan --plant "$pen/comment.rye" 2>&1) || true
case "$out" in
  *verdict=clear*) report comment_welcome ok ;;
  *) report comment_welcome red "$out" ;;
esac

out=$($scan --plant mantra/src/receipt_offer_snapshot.rye 2>&1) || true
case "$out" in
  *verdict=clear*) report mantra_shared ok ;;
  *) report mantra_shared red "$out" ;;
esac

rm -f "$pen/both.rye" "$pen/one.rye" "$pen/comment.rye"
rmdir "$pen" 2>/dev/null || true
echo "control_legs=5"
echo "control_failed=$bad"
if [ "$bad" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
  exit 1
fi
