#!/bin/sh
# inner_i2_djin_prose.sh — i2 Twah→Djin prose polish (replies · check-ins)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

# Living replies must not advertise deleted Twah operational doors.
# Season create filenames may keep Twah stamps; this sweep reads reply bodies.
hits="$(rg -n 'gen_twah|gen-twah|twah-creating-one-of-twelve|%twah|twah\.fund' counsel/replies \
  --glob '!**/quin-workshop/**' 2>/dev/null || true)"
if [ -n "$hits" ]; then
  echo "$hits" >&2
  echo "inner-i2 REFUSE: counsel/replies still advertise deleted Twah doors" >&2
  exit 1
fi

# Check-ins that name generators must say gen-gren, not gen-twah.
hits2="$(rg -n 'gen-twah|gen_twah_fund_prep|twah-creating-one-of-twelve' counsel \
  --glob '*checkin*.md' \
  --glob '!**/quin-workshop/**' 2>/dev/null || true)"
if [ -n "$hits2" ]; then
  echo "$hits2" >&2
  echo "inner-i2 REFUSE: check-ins still advertise deleted Twah generators" >&2
  exit 1
fi

test -f tools/g/gen_gren_fund_prep.rish
test ! -e tools/gen_twah_fund_prep.rish

export RYE_ZIG="${RYE_ZIG:-$ROOT/vendor/zig-toolchain/zig}"
out="$(rishi/bin/rishi run tools/g/gen_gren_fund_prep.rish 2>&1)" || {
  echo "inner-i2 REFUSE: gen_gren left GREEN" >&2
  exit 1
}
echo "$out" | grep -q 'GREEN: gen-gren' || {
  echo "inner-i2 REFUSE: gen_gren missing GREEN line" >&2
  exit 1
}

# Fold prior residual sweep so i1 stays honest under i2 polish.
rishi/bin/rishi run tools/i/inner_i1_twah_residual.rish >/dev/null

echo "polish: replies free of deleted Twah door ads"
echo "polish: check-ins free of gen-twah / twah-edu path ads"
echo "polish: gen_gren GREEN · gen_twah ABSENT · i1 residual still GREEN"
echo "GREEN: inner-i2 — Twah→Djin prose polish · living doors say Gren (was Djin)"
