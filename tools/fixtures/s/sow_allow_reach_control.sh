#!/bin/sh
# sow_allow_reach_control.sh -- the reach gate proven on real projections in a throwaway pen.
#
#   sh tools/fixtures/s/sow_allow_reach_control.sh
#
# Recover the parked projection checks against the current reader. Each pen holds
# a real Git index and a small projection. The receipt binds coverage inputs:
# manifest bytes and the coverage STATE of each allowed room. It makes no promise
# about content freshness.
# Bounds: six small repositories, no network and no public seed writes.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
. "$root/tools/fixtures/s/sow_reach_inputs.sh"
scan=${SOW_REACH_SCAN:-"$root/tools/fixtures/s/sow_allow_reach_scan.sh"}
[ -f "$scan" ] || { echo "control_verdict=no_scan"; exit 2; }

mkdir -p "$root/session-output"
work=$(mktemp -d "$root/session-output/sow-reach.XXXXXX")
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
# The pen copies the scan at its own depth, because the scan resolves its root
# from that path. The copied bytes are the bytes that will ship.
pen() {
  d="$work/$1"
  mkdir -p "$d/room" "$d/seed/room" "$d/tools/fixtures/s"
  cp "$scan" "$d/tools/fixtures/s/sow_allow_reach_scan.sh"
  cp "$root/tools/fixtures/s/sow_reach_inputs.sh" "$d/tools/fixtures/s/sow_reach_inputs.sh"
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

# Each scan runs its pen copy so it reads the pen manifest and index.
pen_scan() { printf '%s/tools/fixtures/s/sow_allow_reach_scan.sh\n' "$1"; }
run_scan() {
  ( SOW_SEED=seed SOW_MANIFEST=template-manifest.bron sh "$(pen_scan "$1")" 2>&1 ) || true
}
run_rc() {
  ( SOW_SEED=seed SOW_MANIFEST=template-manifest.bron sh "$(pen_scan "$1")" >/dev/null 2>&1 ) && echo 0 || echo $?
}

stamp_receipt() {
  (cd "$1" && sow_reach_inputs template-manifest.bron > seed/.sow-projection.log)
}

# ---------------------------------------------------------------------------
# Leg A -- a CURRENT projection is welcomed, and the welcome is the whole point.
# ---------------------------------------------------------------------------
a=$(pen a)
stamp_receipt "$a"
out=$(run_scan "$a")
check "current/rc"        "$(run_rc "$a")" "0"
check "current/empty"     "$(printf '%s\n' "$out" | sed -n 's/^empty=//p')" "0"
check "current/allows"    "$(printf '%s\n' "$out" | sed -n 's/^allows=//p')" "2"
check "current/shipped"   "$(printf '%s\n' "$out" | sed -n 's/^shipped=//p')" "2"
check "current/no_refuse" "$(printf '%s\n' "$out" | grep -c '^refused:' || true)" "0"

# ---------------------------------------------------------------------------
# Leg B -- THE ROW'S OWN FAULT, planted. A room allowed after projection must be named as a stale input. This is the leg the
# elder scan fails: it printed `empty: late` and exited non-zero on a projector
# that had done nothing wrong.
# ---------------------------------------------------------------------------
b=$(pen b)
stamp_receipt "$b"
(
  cd "$b"
  mkdir -p late
  printf 'landed after the projection\n' > late/two.md
  printf 'allow late\n' >> template-manifest.bron
  git add -A -- late template-manifest.bron
  git commit -q -m 'pen: a room allowed after the projection was taken'
)
out=$(run_scan "$b")
check "late_room/refuses"        "$(printf '%s\n' "$out" | grep -c 'projection coverage is stale' || true)" "1"
check "late_room/rc"             "$(run_rc "$b")" "2"
check "late_room/no_accusation"  "$(printf '%s\n' "$out" | grep -c '^empty:' || true)" "0"
check "late_room/names_inputs"     "$(printf '%s\n' "$out" | grep -c 'manifest or tracked paths changed' || true)" "1"

# The same pen, projection refreshed: the refusal lifts and the late room is
# accounted for. A refusal that cannot be cleared is a wall, not a gate.
(
  cd "$b"
  mkdir -p seed/late
  cp late/two.md seed/late/two.md
)
stamp_receipt "$b"
out=$(run_scan "$b")
check "late_room/lifted/rc"     "$(run_rc "$b")" "0"
check "late_room/lifted/empty"  "$(printf '%s\n' "$out" | sed -n 's/^empty=//p')" "0"
check "late_room/lifted/allows" "$(printf '%s\n' "$out" | sed -n 's/^allows=//p')" "3"

# A file landing BESIDE its siblings leaves the coverage question answered: the
# room was already shippable and is still shippable, so the receipt holds and the
# next ship reads no refusal. This is the leg the elder inventory key failed --
# every commit adding a tracked file under an allowed room stalled the fleet.
printf 'new file\n' > "$b/late/three.md"
(cd "$b" && git add late/three.md)
out=$(run_scan "$b")
check "sibling_add/rc" "$(run_rc "$b")" "0"
check "sibling_add/no_accusation" "$(printf '%s\n' "$out" | grep -c '^empty:' || true)" "0"
(cd "$b" && git commit -q -m 'pen: a sibling landed')
check "sibling_commit/rc" "$(run_rc "$b")" "0"

# And the class change it must still catch, from both sides. A room allowed while
# the field carries nothing reads `barren`; the first tracked file under it makes
# it `shippable`, which is a real coverage change and refuses until re-projected.
(
  cd "$b"
  mkdir -p future
  printf 'allow future\n' >> template-manifest.bron
  git add template-manifest.bron
)
stamp_receipt "$b"
check "barren_room/quiet" "$(run_rc "$b")" "0"
printf 'the room stops being barren\n' > "$b/future/one.md"
(cd "$b" && git add future/one.md)
out=$(run_scan "$b")
check "barren_to_shippable/rc" "$(run_rc "$b")" "2"
check "barren_to_shippable/named" "$(printf '%s\n' "$out" | grep -c 'manifest or tracked paths changed' || true)" "1"
check "barren_to_shippable/no_accusation" "$(printf '%s\n' "$out" | grep -c '^empty:' || true)" "0"
(
  cd "$b"
  mkdir -p seed/future
  cp future/one.md seed/future/one.md
)
stamp_receipt "$b"
check "barren_to_shippable/lifted" "$(run_rc "$b")" "0"

printf '# coverage note\n' >> "$b/template-manifest.bron"
check "unstaged_manifest/rc" "$(run_rc "$b")" "2"
stamp_receipt "$b"
check "unstaged_manifest/lifted" "$(run_rc "$b")" "0"
printf 'new content\n' > "$b/late/two.md"
check "content_edit/coverage_unchanged" "$(run_rc "$b")" "0"
(cd "$b" && git add late/two.md && git commit -q -m 'pen: content changed')
check "content_commit/coverage_unchanged" "$(run_rc "$b")" "0"

# ---------------------------------------------------------------------------
# Leg C -- a GENUINE drop is still caught, at a current projection. The whole
# repair would be worthless if it bought quiet by going blind.
# ---------------------------------------------------------------------------
c=$(pen c)
rm -rf "$c/seed/room"
stamp_receipt "$c"
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

# An empty receipt refuses before any room is counted.
: > "$d/seed/.sow-projection.log"
out=$(run_scan "$d")
check "blank_receipt/refuses" "$(printf '%s\n' "$out" | grep -c 'names no complete coverage inputs' || true)" "1"
check "blank_receipt/rc"      "$(run_rc "$d")" "2"

# ---------------------------------------------------------------------------
# Leg E -- the elder refusals still stand. A repair that quietly drops a gate
# its predecessor held is a regression wearing a fix's clothes.
# ---------------------------------------------------------------------------
e=$(pen e)
stamp_receipt "$e"
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
stamp_receipt "$f"
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

# The producer writes exactly the receipt the reader accepts. Real copy and
# scrub code runs on this tiny pen; the public seed and publisher are untouched.
cp "$root/tools/fixtures/s/sow_project.sh" "$a/tools/fixtures/s/sow_project.sh"
cp "$root/tools/fixtures/s/sow_scrub.sed" "$a/tools/fixtures/s/sow_scrub.sed"
(cd "$a" && sh tools/fixtures/s/sow_project.sh > projector.out)
check "producer/receipt" "$(run_rc "$a")" "0"
check "producer/room" "$(cat "$a/seed/room/one.md")" "a room that ships"
check "producer/door" "$(cat "$a/seed/README.md")" "front door"

before_receipt=$(cat "$a/seed/.sow-projection.log")
(cd "$a" && sh tools/fixtures/s/sow_project.sh > projector.out)
check "producer/second_receipt" "$(cat "$a/seed/.sow-projection.log")" "$before_receipt"
check "producer/second_read" "$(run_rc "$a")" "0"
printf 'private note\n' > "$a/private-note"
(cd "$a" && git add private-note)
check "unallowed_path/coverage_unchanged" "$(run_rc "$a")" "0"
# Git failing to enumerate inputs is a failed reading, even if hashing works.
mkdir -p "$work/bin"
real_git=$(command -v git)
cat > "$work/bin/git" <<EOF
#!/bin/sh
case "\$*" in *ls-files*) echo 'planted inventory failure' >&2; exit 7 ;; esac
exec "$real_git" "\$@"
EOF
chmod +x "$work/bin/git"
git_fail_rc=0
(cd "$a" && PATH="$work/bin:$PATH" sh tools/fixtures/s/sow_allow_reach_scan.sh > failed-reader.out 2>&1) || git_fail_rc=$?
check "inventory_failure/refuses" "$git_fail_rc" "2"
check "inventory_failure/no_accusation" "$(grep -c '^empty:' "$a/failed-reader.out" || true)" "0"

check "inventory_failure/named" "$(grep -c 'could not read projection coverage inputs' "$a/failed-reader.out" || true)" "1"
# A failed producer must remove the earlier receipt before writing any new copy.
rm -f "$work/bin/git"
printf 'Keaton\n' > "$a/room/one.md"
printf '#!/bin/sh\nexit 9\n' > "$work/bin/sed"
chmod +x "$work/bin/sed"
producer_rc=0
(cd "$a" && PATH="$work/bin:$PATH" sh tools/fixtures/s/sow_project.sh > failed-producer.out 2>&1) || producer_rc=$?
check "producer_failure/refuses" "$producer_rc" "9"
check "producer_failure/no_receipt" "$(test -f "$a/seed/.sow-projection.log" && echo present || echo absent)" "absent"
check "producer_failure/reader_refuses" "$(run_rc "$a")" "2"
rm -f "$work/bin/sed"
printf 'a room that ships\n' > "$a/room/one.md"
(cd "$a" && sh tools/fixtures/s/sow_project.sh > projector.out)
check "producer_failure/lifted" "$(run_rc "$a")" "0"
# A manifest changed during copying cannot earn a receipt for the old input.
real_cp=$(command -v cp)
cat > "$work/bin/cp" <<EOF
#!/bin/sh
printf '# moved during copy\\n' >> template-manifest.bron
exec "$real_cp" "\$@"
EOF
chmod +x "$work/bin/cp"
producer_rc=0
(cd "$a" && PATH="$work/bin:$PATH" sh tools/fixtures/s/sow_project.sh > moved-producer.out 2>&1) || producer_rc=$?
check "producer_moved/refuses" "$producer_rc" "2"
check "producer_moved/no_receipt" "$(test -f "$a/seed/.sow-projection.log" && echo present || echo absent)" "absent"
check "producer_moved/named" "$(grep -c 'coverage inputs changed during projection' "$a/moved-producer.out" || true)" "1"
rm -f "$work/bin/cp"
(cd "$a" && sh tools/fixtures/s/sow_project.sh > projector.out)
check "producer_moved/lifted" "$(run_rc "$a")" "0"

echo "control_pass=$pass"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=broken"
  exit 1
fi
