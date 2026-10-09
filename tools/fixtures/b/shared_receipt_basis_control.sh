#!/bin/sh
# tools/fixtures/b/shared_receipt_basis_control.sh -- prove the shared-basis reading on real history.
#
# Builds a throwaway repository in a mktemp pen (outside the tree, so taking the reading cannot be
# one of the things it measures), then answers the scan from both sides: a planted receipt that
# should stand stands, and each refusal is planted and then tested. A refusal proven only in the
# passing direction cannot be told from a bypass, so every planted case is asserted both ways.
#
# Run from the repository root:
#   sh tools/fixtures/b/shared_receipt_basis_control.sh
# Prints one leg_ok or leg_FAIL line per leg, then control_legs, control_failed, control_verdict.

scan="$(pwd)/tools/fixtures/b/shared_receipt_basis_scan.sh"
pen=$(mktemp -d) || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT

legs=0
failed=0
leg() {
  # leg <name> <expected-exit> <expected-verdict-line> <scan args...>
  name=$1; want_exit=$2; want_line=$3; shift 3
  out=$(sh "$scan" "$@" 2>&1)
  code=$?
  legs=$((legs + 1))
  if [ "$code" -eq "$want_exit" ] && printf '%s\n' "$out" | grep -qx "$want_line"; then
    echo "leg_ok: $name"
  else
    failed=$((failed + 1))
    echo "leg_FAIL: $name (exit $code, wanted $want_exit and '$want_line')"
    printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

repo="$pen/repo"
mkdir -p "$repo" && cd "$repo" || { echo "control_verdict=no_repo"; exit 1; }
git init -q -b main
git config user.name pen && git config user.email pen@example.invalid
echo one > a.txt && git add -A && git commit -q -m base
base=$(git rev-parse HEAD)
echo two > b.txt && git add -A && git commit -q -m next
tip=$(git rev-parse HEAD)
git checkout -q -b side "$base"
echo side > s.txt && git add -A && git commit -q -m side
side_head=$(git rev-parse HEAD)
git checkout -q main

# A receipt writer, so every case states its fields in one place.
write_receipt() {
  # write_receipt <file> <format> <scope> <head>
  printf 'format %s\ndigest 000000000000\nhead %s\nscope %s\nstamp 20261009.000000\n' \
    "$2" "$4" "$3" > "$1"
}
v2=standing-equipment-receipt-v2
write_receipt "$pen/good.kyri" "$v2" full "$base"
write_receipt "$pen/scoped.kyri" "$v2" scoped "$base"
write_receipt "$pen/side.kyri" "$v2" full "$side_head"
write_receipt "$pen/ghost.kyri" "$v2" full 0123456789abcdef0123456789abcdef01234567
write_receipt "$pen/wrongfmt.kyri" "some-other-v1" full "$base"
write_receipt "$pen/tip.kyri" "$v2" full "$tip"

leg "a full green receipt at an ancestor stands, with the delta counted" \
  0 "verdict=stands" "$pen/good.kyri" "$repo"
leg "the stand names how many paths the delta holds" \
  0 "changed=1" "$pen/good.kyri" "$repo"
leg "a receipt at HEAD itself stands with an empty delta" \
  0 "changed=0" "$pen/tip.kyri" "$repo"
leg "a scoped receipt refuses: only a full green chains" \
  1 "reason=scope_not_full" "$pen/scoped.kyri" "$repo"
leg "a head on a side branch refuses: its delta does not exist here" \
  1 "reason=head_not_ancestor_of_HEAD" "$pen/side.kyri" "$repo"
leg "an unknown head refuses: the commit is not held here" \
  1 "reason=head_not_held_here" "$pen/ghost.kyri" "$repo"
leg "a file of another format refuses" \
  1 "reason=format_not_receipt" "$pen/wrongfmt.kyri" "$repo"
leg "a missing receipt refuses by name" \
  1 "reason=receipt_missing" "$pen/absent.kyri" "$repo"
leg "the digest is named as per-tree in every reading" \
  0 "digest_carries=no digest is per tree (HEAD plus worktree), so it cannot match across checkouts" \
  "$pen/good.kyri" "$repo"
leg "the verdict never reads stands while the head is absent" \
  1 "verdict=refused" "$pen/ghost.kyri" "$repo"

# The scan reads one receipt; a repository that is not one refuses rather than answering.
leg "outside a repository the scan refuses rather than answering" \
  2 "reason=not_a_repository" "$pen/good.kyri" "$pen"

echo "control_legs=$legs"
echo "control_failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=red"
exit 1
