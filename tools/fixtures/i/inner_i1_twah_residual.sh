#!/bin/sh
# inner_i1_twah_residual.sh -- i1 Twah residual sweep (living tree)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

# THE TREE ROOT, resolved without git so a pen copy outside a repository still works: walk up to
# the first ancestor holding rishi/bin and tools/fixtures, bounded at 8 steps, loud past the bound.
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
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

# THE INSTRUMENT, PROVEN PRESENT BEFORE IT IS TRUSTED. Every reading below is a ripgrep capture
# whose emptiness is the pass branch, so a host without ripgrep would print this sweep's GREEN
# line byte for byte while measuring nothing at all -- proven on metal `20260905.223102` and
# booked as REDS %442. `rg` is borrowed rather than granted, so it is asked for by name.
require_instrument rg

# Retired name may appear as rename-forward history; broken paths must not.
test ! -e tools/gen_twah_fund_prep.rish
test ! -e tools/fixtures/gen_twah_fund_prep.sh
test ! -e docs-geode/edu/yonder/funds/twah-creating-one-of-twelve.md
test -f tools/g/gen_gren_fund_prep.rish
test -f tools/fixtures/g/gen_gren_fund_prep.sh
test -f docs-geode/edu/yonder/funds/gren-creating-one-of-twelve.md
grep -q 'Gren (fund)' context/LEXICON.md
grep -q 'Twah (fund) (retired name)' context/LEXICON.md
grep -q 'Djin (fund) (retired name)' context/LEXICON.md
grep -q '%gren' context/LEXICON.md
grep -q 'gren.fund' context/LEXICON.md

# Living tools/ + docs-geode/edu/yonder/ must not advertise deleted Twah generator paths.
# Exclude this sweep fixture (it names the deleted paths in negative tests).
hits="$(rg -n 'gen_twah_fund_prep|twah-creating-one-of-twelve|%twah|twah\.fund' tools edu \
  --glob '!**/quin-workshop/**' \
  --glob '!**/inner_i1_twah_residual.sh' \
  --glob '!**/inner_i1_twah_residual.rish' \
  --glob '!**/inner_i2_djin_prose.sh' \
  --glob '!**/inner_i2_djin_prose.rish' \
  --glob '!**/inner_i3_rename_close.sh' \
  --glob '!**/inner_i3_rename_close.rish' \
  --glob '!**/gen_gren_fund_prep.sh' \
  --glob '!**/gen_gren_fund_prep.rish' 2>/dev/null | grep -v 'was Twah' | grep -v 'rename-forward' | grep -v '(was Twah)' | grep -v 'was Djin' | grep -v '(was Djin)' || true)"
if [ -n "$hits" ]; then
  echo "$hits" >&2
  echo "inner-i1 REFUSE: living tools/edu still advertise Twah paths without rename-forward context" >&2
  exit 1
fi

# Operational generator must still GREEN
export RYE_ZIG="${RYE_ZIG:-$ROOT/vendor/zig-toolchain/zig}"
out="$(rishi/bin/rishi run tools/g/gen_gren_fund_prep.rish 2>&1)" || {
  echo "inner-i1 REFUSE: gen_gren left GREEN" >&2
  exit 1
}
echo "$out" | grep -q 'GREEN: gen-gren' || {
  echo "inner-i1 REFUSE: gen_gren missing GREEN line" >&2
  exit 1
}

echo "sweep: gen_twah ABSENT · twah edu ABSENT · gen_gren PRESENT"
echo "sweep: Lexicon Gren live · Djin retired · Twah retired row present"
echo "sweep: tools/edu free of bare Twah path ads (rename-forward context allowed)"
echo "GREEN: inner-i1 — Twah residual sweep · living overwrite holds · gen_gren GREEN"
