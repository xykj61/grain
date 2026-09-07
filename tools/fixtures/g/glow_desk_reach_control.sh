#!/bin/sh
# tools/fixtures/g/glow_desk_reach_control.sh -- prove the desk-reach reading on real desk rooms.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every refusal
# below is shown from both sides: planted, and then lifted back to ok. Every welcome is asserted as
# hard as every refusal, because a reading that called an ordinary covered desk uncovered would
# cost a hand an hour before they stopped believing it.
#
# The pen is a miniature desk room -- a glow/gen/ tree and a witness naming some of it -- rather
# than a copy of this tree, so the scan under proof reads the pen and never this bench.
#
#   sh tools/fixtures/g/glow_desk_reach_control.sh
set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "refused: not a git repository" >&2; exit 1; }
scan="$root/tools/fixtures/g/glow_desk_reach_scan.sh"
[ -f "$scan" ] || { echo "refused: the scan under proof is missing -- $scan" >&2; exit 1; }

pen=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$pen"' EXIT

pass=0
fail=0
check() {
  want=$1; got=$2; what=$3
  if [ "$want" = "$got" ]; then
    pass=$((pass + 1)); echo "  ok   $what"
  else
    fail=$((fail + 1)); echo "  FAIL $what -- want $want, got $got"
  fi
}
field() { sed -n "s/^$2=//p" "$1" | head -1; }

# A pen carries the two directories the scan's upward root walk looks for, so it resolves to the
# pen rather than climbing out into this tree.
newpen() {
  d="$pen/$1"; rm -rf "$d"
  mkdir -p "$d/tools/fixtures/g" "$d/tools/g" "$d/glow/gen/g" "$d/glow/gen/s"
  cp "$scan" "$d/tools/fixtures/g/glow_desk_reach_scan.sh"
  echo "$d"
}

# a plain runnable desk
desk() { printf '::  A desk (pen).\n|^  sample\nsample\n' > "$1"; }
# a desk declaring both ways that it must not run
norun() { printf '::  Refuse desk -- pen negative space.\n::  Parse-only; do not glow_run -- nest refuses.\n|^  sample\nsample\n' > "$1"; }

runscan() { ( cd "$1" && shift && env "$@" sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$2" 2>&1 || true; }

echo "glow_desk_reach control -- planted refusals, each lifted"

# --- 1. a clean room reads ok, and the arithmetic closes -------------------------------------
d=$(newpen clean)
desk "$d/glow/gen/g/gate-one.glow"
desk "$d/glow/gen/g/gate-two.glow"
norun "$d/glow/gen/g/gate-three-refuse.glow"
cat > "$d/tools/g/glow_run_desk_witness.rish" <<'PEN'
let a = run ["rishi/bin/rishi" "run" "tools/g/glow_run.rish" "glow/gen/g/gate-one.glow"]
let b = run ["rishi/bin/rishi" "run" "tools/g/glow_run.rish" "glow/gen/g/gate-two.glow"]
PEN
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=0 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "a clean room reads ok"
check 3 "$(field "$pen/o" desks)" "every .glow counted"
check 1 "$(field "$pen/o" declared_norun)" "the refuse desk is declared by both markers"
check 2 "$(field "$pen/o" runnable)" "runnable is desks minus declared_norun"
check 2 "$(field "$pen/o" covered)" "both runnable desks are covered"
check 0 "$(field "$pen/o" uncovered)" "nothing is left uncovered"

# --- 2. an uncovered desk refuses at the ceiling, and is welcomed once covered ----------------
desk "$d/glow/gen/g/gate-four.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=0 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check over_ceiling "$(field "$pen/o" verdict)" "a desk nothing runs refuses at a ceiling of zero"
check 1 "$(field "$pen/o" uncovered)" "the uncovered desk is counted"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=1 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "the same room reads ok one ceiling higher -- the ratchet, not a gate"
printf 'let d = run ["glow/gen/g/gate-four.glow"]\n' >> "$d/tools/g/glow_run_desk_witness.rish"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=0 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "covering the desk lifts the refusal"
rm -f "$d/glow/gen/g/gate-four.glow"
sed -i.bak '/gate-four/d' "$d/tools/g/glow_run_desk_witness.rish" && rm -f "$d/tools/g/glow_run_desk_witness.rish.bak"

# --- 3. a marker disagreement refuses, from both sides ----------------------------------------
# the head says refuse, the name does not
printf '::  Refuse desk -- head says so, name does not.\n|^  sample\nsample\n' > "$d/glow/gen/g/gate-five.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check marker_disagree "$(field "$pen/o" verdict)" "a head marker without a name marker refuses"
check 1 "$(field "$pen/o" norun_disagree)" "the disagreement is counted"
mv "$d/glow/gen/g/gate-five.glow" "$d/glow/gen/g/gate-five-refuse.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "renaming to carry the marker lifts the refusal"
# the name says refuse, the head does not
printf '::  An ordinary desk wearing a refuse name.\n|^  sample\nsample\n' > "$d/glow/gen/g/gate-six-refuse.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check marker_disagree "$(field "$pen/o" verdict)" "a name marker without a head marker refuses -- the other side"
rm -f "$d/glow/gen/g/gate-six-refuse.glow" "$d/glow/gen/g/gate-five-refuse.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "removing both plants returns the room to ok"

# --- 4. a phantom refuses, and is lifted by the file arriving ---------------------------------
printf 'let p = run ["glow/gen/g/gate-absent.glow"]\n' >> "$d/tools/g/glow_run_desk_witness.rish"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check phantom "$(field "$pen/o" verdict)" "a witness naming a desk that is not on disk refuses"
check 1 "$(field "$pen/o" phantom)" "the phantom is counted"
desk "$d/glow/gen/g/gate-absent.glow"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "the desk arriving lifts the phantom refusal"

# --- 5. a contradiction refuses, and is lifted by the witness letting go ----------------------
printf 'let c = run ["glow/gen/g/gate-three-refuse.glow"]\n' >> "$d/tools/g/glow_run_desk_witness.rish"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check contradicted "$(field "$pen/o" verdict)" "a witness running a declared-unrunnable desk refuses"
check 1 "$(field "$pen/o" contradicted)" "the contradiction is counted"
sed -i.bak '/gate-three-refuse/d' "$d/tools/g/glow_run_desk_witness.rish" && rm -f "$d/tools/g/glow_run_desk_witness.rish.bak"
( cd "$d" && GLOW_DESK_UNCOVERED_CEILING=9 sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 || true
check ok "$(field "$pen/o" verdict)" "the witness letting go lifts the contradiction"

# --- 6. the scan refuses to describe a subject it cannot read ---------------------------------
d2=$(newpen nowitness)
desk "$d2/glow/gen/g/gate-one.glow"
( cd "$d2" && sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 && rc=0 || rc=$?
check 2 "$rc" "a missing desk witness refuses by name rather than reading zero coverage"

d3=$(newpen noroom)
printf 'let a = run ["glow/gen/g/gate-one.glow"]\n' > "$d3/tools/g/glow_run_desk_witness.rish"
rm -rf "$d3/glow/gen"
( cd "$d3" && sh tools/fixtures/g/glow_desk_reach_scan.sh ) > "$pen/o" 2>&1 && rc=0 || rc=$?
check 2 "$rc" "a missing desk room refuses rather than reporting an empty corpus as clean"

echo "glow_desk_reach control: pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
