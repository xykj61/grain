#!/bin/sh
# tools/fixtures/r/remember_git_nib_write_control.sh -- prove the nib writer on planted cards in a
# throwaway pen, refusals and welcomes both.
#
# WHY BOTH DIRECTIONS. A refusal proven one way alone reads exactly like a bypass. A writer that
# always exits 1 refuses every bad card a control thinks to plant, and writes no good one either.
# So each refusal here is planted and then removed, and each welcome is asserted as hard as each
# refusal -- the exec-bit control's own discipline.
#
# THE CASE THE PROGRAM EXISTS FOR is number 6. English holds words made only of hex letters and
# long enough to pass for a hash; `defaced` is seven characters of one. Put such a word on the nib
# line and the guard's extractor reads it as the nib, while the writer aims at the backticked hash
# beside it. The two then name different tokens. The writer reads its own result back through the
# guard's extractor, sees the disagreement, and refuses with the card byte-identical. Case 7 writes
# a clean card in the same pen one line later, so the refusal is about the decoy rather than the pen.
#
#   sh tools/fixtures/r/remember_git_nib_write_control.sh
#
# Exit 0 when every case behaves, 1 when one misses. No network, no key, no funds, no device.

set -eu

WRITE="$(cd "$(dirname "$0")" && pwd)/remember_git_nib_write.sh"
pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

ok() { # name condition-already-evaluated
  if [ "$2" = yes ]; then
    echo "PASS: $1"
    pass=$((pass + 1))
  else
    echo "FAIL: $1"
    fail=$((fail + 1))
  fi
}

# The guard's own extractor, copied verbatim from tools/r/remember_git_nib_witness.rish, so this
# control asks the question the guard asks rather than a question of its own.
guard_reads() {
  awk '/Git nib:/{ if (match($0, /[0-9a-f]{7,40}/)) { print substr($0, RSTART, RLENGTH); exit } }' "$1"
}

card() { # path  -- a card shaped exactly like the operator card's nib line
  printf '# a card\n\n**Git nib:** `%s` -- HEAD parent, resolvable everywhere (%%401).\n\ntail\n' "${2:-1111111111}" > "$1"
}

wrote() { # card nib  -- run the writer, capture output, never abort the control on a refusal
  set +e
  _out=$(sh "$WRITE" "$1" "$2" 2>&1)
  _rc=$?
  set -e
  printf '%s\n' "$_out"
  return $_rc
}

echo "== 1. a stale nib is replaced by the one it was handed =="
card "$pen/a.md"
out=$(wrote "$pen/a.md" abcdef1234) && rc=0 || rc=1
ok "the write succeeds" "$([ "$rc" -eq 0 ] && echo yes || echo no)"
ok "it names what it wrote" "$(printf '%s\n' "$out" | grep -q '^nib_written=abcdef1234$' && echo yes || echo no)"
ok "it says the card changed" "$(printf '%s\n' "$out" | grep -q '^card_changed=yes$' && echo yes || echo no)"
ok "the guard's own extractor reads the new nib back" "$([ "$(guard_reads "$pen/a.md")" = abcdef1234 ] && echo yes || echo no)"

echo
echo "== 2. the same write again changes nothing =="
cp "$pen/a.md" "$pen/a.before"
out=$(wrote "$pen/a.md" abcdef1234) && rc=0 || rc=1
ok "the second write succeeds" "$([ "$rc" -eq 0 ] && echo yes || echo no)"
ok "it reports the card unchanged" "$(printf '%s\n' "$out" | grep -q '^card_changed=no$' && echo yes || echo no)"
ok "the bytes are identical" "$(cmp -s "$pen/a.md" "$pen/a.before" && echo yes || echo no)"

echo
echo "== 3. everything on the line except the hash survives =="
ok "the prose after the nib is byte-identical" \
  "$(grep -qF -- '`abcdef1234` -- HEAD parent, resolvable everywhere (%401).' "$pen/a.md" && echo yes || echo no)"
ok "the backticks are still a pair" "$([ "$(tr -cd '`' < "$pen/a.md" | wc -c | tr -d ' ')" = 2 ] && echo yes || echo no)"
ok "the file is still five lines" "$([ "$(wc -l < "$pen/a.md" | tr -d ' ')" = 5 ] && echo yes || echo no)"

echo
echo "== 4. a SECOND nib line is left where it stands =="
printf '**Git nib:** `1111111111` -- the first.\n**Git nib:** `2222222222` -- the second, and not ours.\n' > "$pen/two.md"
wrote "$pen/two.md" abcdef1234 >/dev/null
ok "the first line took the write" "$(grep -q '^\*\*Git nib:\*\* `abcdef1234` -- the first\.$' "$pen/two.md" && echo yes || echo no)"
ok "the second line is untouched" "$(grep -q '^\*\*Git nib:\*\* `2222222222` -- the second, and not ours\.$' "$pen/two.md" && echo yes || echo no)"

echo
echo "== 5. the mode the repository tracks survives the rewrite =="
card "$pen/x.md"
chmod +x "$pen/x.md"
wrote "$pen/x.md" abcdef1234 >/dev/null
ok "an executable card is still executable" "$([ -x "$pen/x.md" ] && echo yes || echo no)"

echo
echo "== 6. THE FENCE -- a hexadecimal English word the guard would read as the nib =="
printf '**Git nib:** the defaced card named `abc1234567` -- prose.\n' > "$pen/decoy.md"
cp "$pen/decoy.md" "$pen/decoy.before"
ok "the guard would read the word, not the hash" "$([ "$(guard_reads "$pen/decoy.md")" = defaced ] && echo yes || echo no)"
out=$(wrote "$pen/decoy.md" abcdef1234) && rc=0 || rc=1
ok "the write is REFUSED" "$([ "$rc" -ne 0 ] && echo yes || echo no)"
ok "the refusal names both readings" "$(printf '%s\n' "$out" | grep -q "reads back as 'defaced' rather than 'abcdef1234'" && echo yes || echo no)"
ok "the card is byte-identical -- refusal before mutation" "$(cmp -s "$pen/decoy.md" "$pen/decoy.before" && echo yes || echo no)"

echo
echo "== 7. the pen is innocent -- a clean card in the same directory writes =="
card "$pen/clean.md"
out=$(wrote "$pen/clean.md" abcdef1234) && rc=0 || rc=1
ok "the clean card writes" "$([ "$rc" -eq 0 ] && echo yes || echo no)"
ok "and reads back" "$([ "$(guard_reads "$pen/clean.md")" = abcdef1234 ] && echo yes || echo no)"

echo
echo "== 8. a card with no nib line gains none =="
printf 'a card that never pinned a nib\n' > "$pen/none.md"
cp "$pen/none.md" "$pen/none.before"
out=$(wrote "$pen/none.md" abcdef1234) && rc=0 || rc=1
ok "the write is refused" "$([ "$rc" -ne 0 ] && echo yes || echo no)"
ok "the refusal says it invents nothing" "$(printf '%s\n' "$out" | grep -q 'never invents one' && echo yes || echo no)"
ok "the card is byte-identical" "$(cmp -s "$pen/none.md" "$pen/none.before" && echo yes || echo no)"

echo
echo "== 9. the nib itself is checked before the card is opened =="
card "$pen/g.md"
cp "$pen/g.md" "$pen/g.before"
for bad in '' 'zzzzzzzzzz' 'abc123' 'ABCDEF1234' 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'; do
  out=$(wrote "$pen/g.md" "$bad") && rc=0 || rc=1
  ok "refused: [${bad:-empty}]" "$([ "$rc" -ne 0 ] && echo yes || echo no)"
done
ok "the card is byte-identical after five refusals" "$(cmp -s "$pen/g.md" "$pen/g.before" && echo yes || echo no)"

echo
echo "== 10. the width bound is proven at its own number, both ends =="
card "$pen/w.md"
out=$(wrote "$pen/w.md" 1234567) && rc=0 || rc=1
ok "seven characters -- the floor -- is welcomed" "$([ "$rc" -eq 0 ] && echo yes || echo no)"
long40=$(printf 'a%.0s' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40)
out=$(wrote "$pen/w.md" "$long40") && rc=0 || rc=1
ok "forty characters -- the ceiling -- is welcomed" "$([ "$rc" -eq 0 ] && echo yes || echo no)"
out=$(wrote "$pen/w.md" 123456) && rc=0 || rc=1
ok "six -- one under the floor -- is bitten" "$([ "$rc" -ne 0 ] && echo yes || echo no)"
out=$(wrote "$pen/w.md" "${long40}a") && rc=0 || rc=1
ok "forty-one -- one over the ceiling -- is bitten" "$([ "$rc" -ne 0 ] && echo yes || echo no)"

echo
echo "== 11. an absent card, and a card nobody named =="
out=$(wrote "$pen/absent.md" abcdef1234) && rc=0 || rc=1
ok "an absent card refuses" "$([ "$rc" -ne 0 ] && echo yes || echo no)"
set +e; sh "$WRITE" >/dev/null 2>&1; rc=$?; set -e
ok "no arguments at all refuses" "$([ "$rc" -ne 0 ] && echo yes || echo no)"

echo
echo "cases_ok=$pass cases_red=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=red"; exit 1; fi
echo "control_verdict=ok"
