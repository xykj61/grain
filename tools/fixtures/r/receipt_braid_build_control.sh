#!/bin/sh
# tools/fixtures/r/receipt_braid_build_control.sh -- both answers of the braid build scan.
#
#   sh tools/fixtures/r/receipt_braid_build_control.sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"
scan="sh tools/fixtures/r/receipt_braid_build_scan.sh"
ok=0
bad=0

report() {
  if [ "$2" = ok ]; then
    echo "leg_ok: $1"
    ok=$((ok + 1))
  else
    echo "leg_bad: $1 -- $3"
    bad=$((bad + 1))
  fi
}

out=$(BRAID_BUILD= $scan 2>&1) || true
case "$out" in
  *verdict=build_refuses*) report live ok ;;
  *) report live red "$out" ;;
esac
case "$out" in
  *link=admitted*) report live_link ok ;;
  *) report live_link red "$out" ;;
esac

stubdir=".lap/receipt-braid-build-control"
rm -rf "$stubdir"
mkdir -p "$stubdir"

cat > "$stubdir/admit.sh" <<'EOF'
#!/bin/sh
exit 0
EOF
cat > "$stubdir/other.sh" <<'EOF'
#!/bin/sh
echo "other fault" >&2
exit 1
EOF
chmod 755 "$stubdir/admit.sh" "$stubdir/other.sh"

out=$(BRAID_BUILD="$root/$stubdir/admit.sh" $scan 2>&1) || true
case "$out" in
  *verdict=admitted*) report admitted_stub ok ;;
  *) report admitted_stub red "$out" ;;
esac

out=$(BRAID_BUILD="$root/$stubdir/other.sh" $scan 2>&1) || true
case "$out" in
  *verdict=other_refusal*) report other_stub ok ;;
  *) report other_stub red "$out" ;;
esac

rm -rf "$stubdir"
echo "control_legs=4"
echo "control_failed=$bad"
if [ "$bad" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
  exit 1
fi
