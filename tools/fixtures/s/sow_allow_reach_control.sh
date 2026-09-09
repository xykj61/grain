#!/bin/sh
# Prove seed reach and projection receipts in isolated Git repositories.
# Each pen holds a small manifest and neutral files. The checks cover a current
# copy, a late allow entry, a real missing room, logged withholding, and absent
# evidence. They also test staged edits and a source change during copying.
# Recovered from Bakery's parked control; no network or public push is used.
# SOW_REACH_SCAN can select an altered scan to prove that these checks refuse it.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
scan=${SOW_REACH_SCAN:-"$root/tools/fixtures/s/sow_allow_reach_scan.sh"}
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 2; }

work=$(mktemp -d 2>/dev/null || mktemp -d -t sowreach)
trap 'rm -rf "$work"' EXIT INT TERM

pass=0
fail=0
check() {
  # $1 name, $2 got, $3 want
  if [ "$2" = "$3" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "FAIL $1: got [$2] want [$3]"
  fi
}

# A pen: a git repository holding one allowed room, one manifest, and a projection directory the
# caller then shapes. Returns the pen path on stdout.
#
# The scan under test is COPIED IN at its own depth rather than invoked from the field, because it
# resolves its root as `dirname $0`/../../.. and `cd`s there -- so calling the field's copy from a
# pen would measure the field. Copied unmodified: the bytes under test are the bytes that ship.
pen() {
  d="$work/$1"
  mkdir -p "$d/room" "$d/seed/room" "$d/tools/fixtures/s"
  cp "$scan" "$d/tools/fixtures/s/sow_allow_reach_scan.sh"
  cp "$root/tools/fixtures/s/sow_projection_basis.sh" "$d/tools/fixtures/s/"
  printf 'allow room\nallow README.md\n' > "$d/template-manifest.bron"
  printf 'a room that ships\n' > "$d/room/one.md"
  printf 'front door\n' > "$d/README.md"
  cp "$d/room/one.md" "$d/seed/room/one.md"
  cp "$d/README.md" "$d/seed/README.md"
  : > "$d/seed/.sow-withheld.log"
  : > "$d/seed/.sow-excluded.log"
  (
    cd "$d"
    git init -q .
    git config user.email pen@example.invalid
    git config user.name pen
    git config commit.gpgsign false
    git add -A -- room README.md template-manifest.bron
    git commit -q -m 'pen: one allowed room'
  )
  printf '%s\n' "$d"
}

# The scan reads `$MANIFEST` and `git ls-files` from its own root, so each leg runs the pen's copy.
pen_scan() { printf '%s/tools/fixtures/s/sow_allow_reach_scan.sh\n' "$1"; }
run_scan() {
  ( SOW_SEED=seed SOW_MANIFEST=template-manifest.bron sh "$(pen_scan "$1")" 2>&1 ) || true
}
run_rc() {
  ( SOW_SEED=seed SOW_MANIFEST=template-manifest.bron sh "$(pen_scan "$1")" >/dev/null 2>&1 ) && echo 0 || echo $?
}

stamp_receipt() {
  # $1 pen dir, $2 commit to claim
  printf 'projected_from %s\nprojected_at 20260906.000000\n' "$2" > "$1/seed/.sow-projection.log"
  (cd "$1" && printf 'projected_basis %s\n' "$(sh tools/fixtures/s/sow_projection_basis.sh)") >> "$1/seed/.sow-projection.log"
}

# ---------------------------------------------------------------------------
# Leg A -- a CURRENT projection is welcomed, and the welcome is the whole point.
# ---------------------------------------------------------------------------
a=$(pen a)
stamp_receipt "$a" "$(cd "$a" && git rev-parse HEAD)"
out=$(run_scan "$a")
check "current/rc"        "$(run_rc "$a")" "0"
check "current/empty"     "$(printf '%s\n' "$out" | sed -n 's/^empty=//p')" "0"
check "current/allows"    "$(printf '%s\n' "$out" | sed -n 's/^allows=//p')" "2"
check "current/shipped"   "$(printf '%s\n' "$out" | sed -n 's/^shipped=//p')" "2"
check "current/no_refuse" "$(printf '%s\n' "$out" | grep -c '^refused:' || true)" "0"

# ---------------------------------------------------------------------------
# Leg B -- THE ROW'S OWN FAULT, planted. A room allowed AFTER the projection was
# taken must never be reported as one the projector dropped. This is the leg the
# elder scan fails: it printed `empty: late` and exited non-zero on a projector
# that had done nothing wrong.
# ---------------------------------------------------------------------------
b=$(pen b)
stamp_receipt "$b" "$(cd "$b" && git rev-parse HEAD)"
(
  cd "$b"
  mkdir -p late
  printf 'landed after the projection\n' > late/two.md
  printf 'allow late\n' >> template-manifest.bron
  git add -A -- late template-manifest.bron
  git commit -q -m 'pen: a room allowed after the projection was taken'
)
out=$(run_scan "$b")
check "late_room/refuses"        "$(printf '%s\n' "$out" | grep -c 'projection is stale' || true)" "1"
check "late_room/rc"             "$(run_rc "$b")" "2"
check "late_room/no_accusation"  "$(printf '%s\n' "$out" | grep -c '^empty:' || true)" "0"
check "late_room/names_both"     "$(printf '%s\n' "$out" | grep -c 'taken at .*tree now at' || true)" "1"

# The same pen, projection refreshed: the refusal lifts and the late room is
# accounted for. A refusal that cannot be cleared is a wall, not a gate.
(
  cd "$b"
  mkdir -p seed/late
  cp late/two.md seed/late/two.md
)
stamp_receipt "$b" "$(cd "$b" && git rev-parse HEAD)"
out=$(run_scan "$b")
check "late_room/lifted/rc"     "$(run_rc "$b")" "0"
check "late_room/lifted/empty"  "$(printf '%s\n' "$out" | sed -n 's/^empty=//p')" "0"
check "late_room/lifted/allows" "$(printf '%s\n' "$out" | sed -n 's/^allows=//p')" "3"

# ---------------------------------------------------------------------------
# Leg C -- a GENUINE drop is still caught, at a current projection. The whole
# repair would be worthless if it bought quiet by going blind.
# ---------------------------------------------------------------------------
c=$(pen c)
rm -rf "$c/seed/room"
stamp_receipt "$c" "$(cd "$c" && git rev-parse HEAD)"
# The scan REPORTS and the witness GATES, which is this tree's ordinary split and is asserted here
# rather than assumed: a real drop exits ZERO with `empty=1` printed, and it is
# `sow_allow_reach_witness.rish` that turns that count into a refusal. So the exit code separates
# *the scan could not answer* (2) from *the scan answered* (0), and the answer itself is the count.
out=$(run_scan "$c")
check "real_drop/rc"      "$(run_rc "$c")" "0"
check "real_drop/empty"   "$(printf '%s\n' "$out" | sed -n 's/^empty=//p')" "1"
check "real_drop/names"   "$(printf '%s\n' "$out" | grep -c '^empty: room' || true)" "1"

# And a LOUD absence at a current projection is still told from a silent one.
printf 'room/one.md\n' > "$c/seed/.sow-withheld.log"
out=$(run_scan "$c")
check "loud_absence/rc"       "$(run_rc "$c")" "0"
check "loud_absence/empty"    "$(printf '%s\n' "$out" | sed -n 's/^empty=//p')" "0"
check "loud_absence/withheld" "$(printf '%s\n' "$out" | sed -n 's/^withheld_by_design=//p')" "1"

# ---------------------------------------------------------------------------
# Leg D -- an UNPROVENANCED projection refuses. Every projection standing on
# disk before this repair has no receipt, and reading one as current would put
# the whole fault straight back.
# ---------------------------------------------------------------------------
d=$(pen d)
out=$(run_scan "$d")
check "no_receipt/refuses" "$(printf '%s\n' "$out" | grep -c 'no receipt at' || true)" "1"
check "no_receipt/rc"      "$(run_rc "$d")" "2"

# A receipt that names no commit is not a receipt. It refuses rather than
# comparing an empty string against HEAD, which would pass on an empty HEAD.
printf 'projected_at 20260906.000000\n' > "$d/seed/.sow-projection.log"
out=$(run_scan "$d")
check "blank_receipt/refuses" "$(printf '%s\n' "$out" | grep -c 'names no commit' || true)" "1"
check "blank_receipt/rc"      "$(run_rc "$d")" "2"

# ---------------------------------------------------------------------------
# Leg E -- the elder refusals still stand. A repair that quietly drops a gate
# its predecessor held is a regression wearing a fix's clothes.
# ---------------------------------------------------------------------------
e=$(pen e)
stamp_receipt "$e" "$(cd "$e" && git rev-parse HEAD)"
out=$( ( SOW_SEED=nowhere-at-all SOW_MANIFEST=template-manifest.bron sh "$(pen_scan "$e")" 2>&1 ) || true )
check "absent_seed/refuses" "$(printf '%s\n' "$out" | grep -c 'no projection at' || true)" "1"
out=$( ( SOW_SEED=seed SOW_MANIFEST=nowhere.bron sh "$(pen_scan "$e")" 2>&1 ) || true )
check "absent_manifest/refuses" "$(printf '%s\n' "$out" | grep -c 'no manifest at' || true)" "1"

# ---------------------------------------------------------------------------
# Leg F -- THE PEN PROVEN INNOCENT. A scan patched to answer `empty=0` for every
# input must fail this control, or the control proves nothing about the real one.
# ---------------------------------------------------------------------------
f=$(pen f)
rm -rf "$f/seed/room"
stamp_receipt "$f" "$(cd "$f" && git rev-parse HEAD)"
liar="$work/always-clean.sh"
{
  echo '#!/bin/sh'
  echo 'echo allows=2'
  echo 'echo shipped=2'
  echo 'echo withheld_by_design=0'
  echo 'echo empty=0'
} > "$liar"
lie_out=$( ( cd "$f" && sh "$liar" ) || true )
check "pen_innocent/liar_says_clean" "$(printf '%s\n' "$lie_out" | sed -n 's/^empty=//p')" "0"
real_out=$(run_scan "$f")
check "pen_innocent/real_says_dropped" "$(printf '%s\n' "$real_out" | sed -n 's/^empty=//p')" "1"

# The same commit can hold a changed index or changed working bytes.
capability() { sh "$(pen_scan "$1")" --capability; }
check "capability/current" "$(capability "$a")" present
printf 'edited after projection\n' >> "$a/room/one.md"
check "dirty_unstaged/rc" "$(run_rc "$a")" 2
check "dirty_unstaged/capability" "$(capability "$a")" absent
(cd "$a" && git add room/one.md)
check "dirty_staged/rc" "$(run_rc "$a")" 2
stamp_receipt "$a" "$(cd "$a" && git rev-parse HEAD)"
check "dirty_recorded/rc" "$(run_rc "$a")" 0
printf 'new tracked file\n' > "$a/room/two.md"
(cd "$a" && git add room/two.md)
check "new_index_path/rc" "$(run_rc "$a")" 2
rm -f "$d/seed/.sow-projection.log"
check "capability/no_receipt" "$(capability "$d")" absent
printf 'projected_at 20260906.000000\n' > "$d/seed/.sow-projection.log"
check "capability/malformed" "$(capability "$d")" unknown
stamp_receipt "$d" "$(cd "$d" && git rev-parse HEAD)"
printf 'projected_from duplicate\n' >> "$d/seed/.sow-projection.log"
check "capability/duplicate" "$(capability "$d")" unknown
rm -rf "$d/seed"
check "capability/no_seed" "$(capability "$d")" absent

# A valid receipt cannot become an absence when Git itself cannot answer.
h=$(pen h)
stamp_receipt "$h" "$(cd "$h" && git rev-parse HEAD)"
mkdir -p "$h/bin"
printf '#!/bin/sh\nexit 127\n' > "$h/bin/git"
chmod +x "$h/bin/git"
check "capability/unavailable_git" "$(PATH="$h/bin:$PATH" capability "$h")" unknown
sed '/^projected_basis /d' "$h/seed/.sow-projection.log" > "$work/no-basis"
cp "$work/no-basis" "$h/seed/.sow-projection.log"
check "capability/missing_digest" "$(capability "$h")" unknown

# Run the real projector against two neutral files. No public repository is used.
g=$(pen g)
cp "$root/tools/fixtures/s/sow_project.sh" "$g/tools/fixtures/s/"
cp "$root/tools/fixtures/s/sow_scrub.sed" "$g/tools/fixtures/s/"
(cd "$g" && sh tools/fixtures/s/sow_project.sh) > "$work/project.out" 2>&1
check "projector/receipt" "$(test -s "$g/seed/.sow-projection.log" && echo yes)" yes
check "projector/current" "$(run_rc "$g")" 0
check "projector/copy" "$(cmp -s "$g/room/one.md" "$g/seed/room/one.md" && echo yes)" yes
# The real projector must refuse a source edit during its copy. A cp wrapper
# performs the ordinary copy, then changes a tracked source once in this pen.
real_cp=$(command -v cp)
mkdir -p "$g/bin"
cat > "$g/bin/cp" <<EOF
#!/bin/sh
"$real_cp" "\$@" || exit 1
printf 'changed during copy\\n' >> '$g/room/one.md'
EOF
chmod +x "$g/bin/cp"
rc=0
(cd "$g" && PATH="$g/bin:$PATH" sh tools/fixtures/s/sow_project.sh) > "$work/moved.out" 2>&1 || rc=$?
check "projector/moved_rc" "$rc" 2
check "projector/moved_no_receipt" "$(test ! -e "$g/seed/.sow-projection.log" && echo yes)" yes
check "projector/moved_named" "$(grep -c 'tracked inputs changed' "$work/moved.out" || true)" 1

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=broken"
  exit 1
fi
