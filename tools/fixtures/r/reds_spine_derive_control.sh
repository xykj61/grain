#!/bin/sh
# tools/fixtures/r/reds_spine_derive_control.sh -- prove the derived-spine scan on real git
# repositories in a throwaway pen, refusals and welcomes both.
#
# WHY BOTH DIRECTIONS. A refusal proven only in the passing direction cannot be told from a
# bypass: a scan that always exits 0 passes every "clean tree" case a control thinks to write.
# So every gated reading here is shown from BOTH sides -- planted and then removed -- and the
# welcomes are asserted as hard as the refusals (the exec-bit control's own discipline).
#
#   sh tools/fixtures/r/reds_spine_derive_control.sh
#
# Exit 0 when every case behaves, 1 when one does not. No network, no key, no funds, no device.
set -eu

SCAN="$(cd "$(dirname "$0")" && pwd)/reds_spine_derive_scan.sh"
pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

check() { # name expected_verdict actual_output
  _n="$1"; _want="$2"; _got="$3"
  if printf '%s\n' "$_got" | grep -q "^verdict=$_want$"; then
    echo "PASS: $_n (verdict=$_want)"
    pass=$((pass + 1))
  else
    echo "FAIL: $_n -- wanted verdict=$_want, got:"
    printf '%s\n' "$_got" | sed 's/^/       /'
    fail=$((fail + 1))
  fi
}

check_field() { # name field expected actual_output
  _n="$1"; _f="$2"; _want="$3"; _got="$4"
  _have=$(printf '%s\n' "$_got" | sed -n "s/^$_f=//p")
  if [ "$_have" = "$_want" ]; then
    echo "PASS: $_n ($_f=$_want)"
    pass=$((pass + 1))
  else
    echo "FAIL: $_n -- wanted $_f=$_want, got $_f=$_have"
    fail=$((fail + 1))
  fi
}

row() { # number stamp headline
  printf '**REDS %%%s (`%s`) -- %s** CLOSED.\n\n' "$1" "$2" "$3"
}

newpen() { # build a repo whose `anointed` branch holds rows 1 and 2
  rm -rf "$pen/r"; mkdir -p "$pen/r"; cd "$pen/r"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name Pen
  git config commit.gpgsign false
  { row 1 20260101.000001 "the first"; row 2 20260101.000002 "the second"; } > REDS.md
  git add -A; git commit -q -m "pen: two rows"
  git branch anointed
}

export REDS_SPINE_GLOB=REDS.md

echo "== 1. a clean tree, one unshared row above the anointed maximum =="
newpen
{ row 1 20260101.000001 "the first"; row 2 20260101.000002 "the second"; row 3 20260101.000003 "mine"; } > REDS.md
out=$(sh "$SCAN" --remote anointed 2>&1 || true)
check "clean tree welcomed" ok "$out"
check_field "shared maximum read from the anointed ref" shared_max 2 "$out"
check_field "next_free clears the anointed maximum and the row just booked" next_free 4 "$out"

echo
echo "== 2. THE COLLISION -- upstream already gave this number to another stamp =="
newpen
git checkout -q anointed
{ row 1 20260101.000001 "the first"; row 2 20260101.000002 "the second"; row 3 20260101.000009 "UPSTREAM took three"; } > REDS.md
git add -A; git commit -q -m "pen: upstream books three"
git checkout -q master 2>/dev/null || git checkout -q main
{ row 1 20260101.000001 "the first"; row 2 20260101.000002 "the second"; row 3 20260101.000003 "mine, booked from a local read"; } > REDS.md
out=$(sh "$SCAN" --remote anointed 2>&1 || true)
check "a number upstream already spent is refused" rebinding "$out"
check_field "it is counted as a squatter, not a moved row" squatters 1 "$out"

echo
echo "== 3. the same tree, renumbered to the derived seat -- the refusal lifts =="
{ row 1 20260101.000001 "the first"; row 2 20260101.000002 "the second"; row 4 20260101.000003 "mine, re-seated"; } > REDS.md
out=$(sh "$SCAN" --remote anointed 2>&1 || true)
check "the re-seated row is welcomed" ok "$out"
check_field "next_free clears both the upstream row and the re-seated one" next_free 5 "$out"

echo
echo "== 4. THE SHARED REBOUND -- a published row's key moves under it =="
newpen
{ row 1 20260101.000001 "the first"; row 2 20260101.999999 "the second, restamped"; } > REDS.md
out=$(sh "$SCAN" --remote anointed 2>&1 || true)
check "a published row whose stamp changed is refused" rebinding "$out"
check_field "the rebinding is counted" rebindings 1 "$out"

echo
echo "== 5. the same tree with the stamp restored -- the refusal lifts =="
{ row 1 20260101.000001 "the first"; row 2 20260101.000002 "the second"; } > REDS.md
out=$(sh "$SCAN" --remote anointed 2>&1 || true)
check "the restored key is welcomed" ok "$out"

echo
echo "== 6. next_free reads the ANOINTED spine, never the local maximum =="
newpen
{ row 1 20260101.000001 "the first"; row 2 20260101.000002 "the second"; row 9 20260101.000009 "a local row numbered high"; } > REDS.md
out=$(sh "$SCAN" --remote anointed 2>&1 || true)
check_field "local maximum is seen" local_max 9 "$out"
check_field "yet next_free follows the anointed maximum" next_free 3 "$out"

echo
echo "== 7. a stamp shared to the second is lawful, and reported =="
newpen
{ row 1 20260101.000001 "the first"; row 2 20260101.000002 "the second"; row 3 20260101.000007 "a"; row 4 20260101.000007 "b"; } > REDS.md
out=$(sh "$SCAN" --remote anointed 2>&1 || true)
check "a shared stamp does not refuse" ok "$out"
check_field "the tie is reported for the hash tiebreak" stamp_duplicates 1 "$out"

echo
echo "== 8. an unreachable anointed ref says so rather than guessing =="
newpen
out=$(sh "$SCAN" --remote no/such/ref 2>&1 || true)
check "an absent anointed ref still reads" ok "$out"
check_field "and admits it could not reach one" anointed_reachable no "$out"

echo
echo "== 9. misuse exits differently from a refusal =="
newpen
set +e
sh "$SCAN" --remote >/dev/null 2>&1; rc_a=$?
sh "$SCAN" --nonsense >/dev/null 2>&1; rc_b=$?
set -e
if [ "$rc_a" -eq 2 ] && [ "$rc_b" -eq 2 ]; then
  echo "PASS: misuse exits 2, never 0 and never 1"
  pass=$((pass + 1))
else
  echo "FAIL: misuse exits -- --remote:$rc_a --nonsense:$rc_b (wanted 2 and 2)"
  fail=$((fail + 1))
fi

# `--next` PROMISES ONE NUMBER, and a fresh caller writes `N=$(... --next)` rather than piping to
# tail. The mode printed forty-one lines before this leg existed: every stamp_duplicate note ahead
# of the answer, on stdout.
lines=$(cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)" && sh "$SCAN" --next 2>/dev/null | wc -l)
if [ "$lines" -eq 1 ]; then
  echo "PASS: --next prints exactly one line"
  pass=$((pass + 1))
else
  echo "FAIL: --next printed $lines lines (wanted 1)"
  fail=$((fail + 1))
fi

# AND IT REFUSES MID-REBASE. The allocator skips past numbers the LOCAL tree holds, and a replaying
# tree holds the very row being renumbered -- the Petrichor seat was answered one too high and
# renumbered six citation sites the wrong way. Proven from both sides, planted and then removed.
root=$(git rev-parse --show-toplevel 2>/dev/null || echo .)
gd=$(cd "$root" && git rev-parse --git-dir 2>/dev/null || echo .git)
case "$gd" in /*) ;; *) gd="$root/$gd" ;; esac
mkdir -p "$gd/rebase-merge"
set +e; ( cd "$root" && sh "$SCAN" --next >/dev/null 2>&1 ); rc_reb=$?; set -e
rmdir "$gd/rebase-merge" 2>/dev/null
set +e; ( cd "$root" && sh "$SCAN" --next >/dev/null 2>&1 ); rc_clean=$?; set -e
if [ "$rc_reb" -eq 2 ] && [ "$rc_clean" -eq 0 ]; then
  echo "PASS: --next refuses mid-rebase and welcomes a settled tree"
  pass=$((pass + 1))
else
  echo "FAIL: --next mid-rebase:$rc_reb settled:$rc_clean (wanted 2 and 0)"
  fail=$((fail + 1))
fi

echo
echo "cases_ok=$pass cases_red=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=red"; exit 1; fi
echo "control_verdict=ok"
