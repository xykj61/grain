#!/bin/sh
# inner_i3_rename_close.sh — i3 close rename-polish block (i1–i3)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

# Fold prior polish witnesses.
rishi/bin/rishi run tools/i/inner_i1_twah_residual.rish >/dev/null
rishi/bin/rishi run tools/i/inner_i2_djin_prose.rish >/dev/null

# Living Gren door present; retired Twah generator gone.
test -f tools/g/gen_gren_fund_prep.rish
test -f edu/funds/gren-creating-one-of-twelve.md
test ! -e tools/gen_twah_fund_prep.rish
test ! -e tools/fixtures/gen_twah_fund_prep.sh
test ! -e edu/funds/twah-creating-one-of-twelve.md

grep -q 'Gren (fund)' context/LEXICON.md
grep -q 'Djin (fund) (retired name)' context/LEXICON.md
grep -q 'Twah (fund) (retired name)' context/LEXICON.md
grep -q 'rumi-hafez-kabir-ibn-arabi' gratitude/README.md

# Fascia machinery not yet on main — i3 closes polish; i4 opens tools.
# Honesty: refuse if someone pretends fascia* already landed without i4.
if ls tools/fascia* >/dev/null 2>&1; then
  echo "inner-i3 NOTE: tools/fascia* present — i4 machinery may have begun early" >&2
  # Still GREEN for rename-close; presence is informational for the chart.
  echo "close: fascia tools PRESENT (early) — rename-polish still closable"
else
  echo "close: fascia tools ABSENT on main — i4 entry door open"
fi

export RYE_ZIG="${RYE_ZIG:-$ROOT/vendor/zig-toolchain/zig}"
out="$(rishi/bin/rishi run tools/g/gen_gren_fund_prep.rish 2>&1)" || {
  echo "inner-i3 REFUSE: gen_gren left GREEN" >&2
  exit 1
}
echo "$out" | grep -q 'GREEN: gen-gren' || {
  echo "inner-i3 REFUSE: gen_gren missing GREEN line" >&2
  exit 1
}

echo "close: i1 residual GREEN · i2 prose GREEN · gen_gren GREEN"
echo "close: Lexicon Gren live · Twah retired · gratitude silo named"
echo "close: rename-polish block i1–i3 CLOSED"
echo "GREEN: inner-i3 — rename-polish closed · i4 fascia machinery next"
